import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:flutter/material.dart' show Color, ThemeMode;
import 'package:localsend_app/model/persistence/color_mode.dart';
import 'package:localsend_app/model/persistence/quick_save_mode.dart';
import 'package:localsend_app/model/send_mode.dart';
import 'package:localsend_app/model/state/send/send_session_state.dart';
import 'package:localsend_app/model/state/send/sending_file.dart';
import 'package:localsend_app/provider/file_transfer_provider.dart';
import 'package:localsend_app/provider/network/send_provider.dart';
import 'package:localsend_app/provider/persistence_provider.dart';
import 'package:localsend_isolates/isolate.dart';
import 'package:localsend_isolates/model/device.dart';
import 'package:localsend_isolates/model/device_info_result.dart';
import 'package:localsend_isolates/model/dto/file_dto.dart';
import 'package:localsend_isolates/model/dto/multicast_dto.dart';
import 'package:localsend_isolates/model/file_status.dart';
import 'package:localsend_isolates/model/file_type.dart';
import 'package:localsend_isolates/model/session_status.dart';
import 'package:localsend_isolates/model/stored_security_context.dart';
// The upload task envelope types are not part of the public isolate API,
// but the fake connector below must spell out the exact generic type.
// ignore: implementation_imports
import 'package:localsend_isolates/src/isolate/child/upload_isolate.dart' show BaseHttpUploadTask, HttpUploadFilesTask;
import 'package:path/path.dart' as p;
import 'package:refena_flutter/refena_flutter.dart';
import 'package:test/test.dart';
import 'package:typed_isolates/typed_isolates.dart';

/// Tests for the "delete source files after a successful send" behavior of
/// [SendNotifier].
///
/// The upload itself is faked at the isolate boundary: the fake upload
/// connector answers HttpUploadFilesTask envelopes with the same started /
/// finished / failed events the real upload isolate would emit. The source
/// files on the other hand are REAL small files in the system temp
/// directory, so the deletion is exercised against the actual filesystem.
///
/// The completion path is driven through [SendNotifier.sendFile] with
/// `isRetry: true` - the same public entry the retry button on the progress
/// page uses - which runs the upload and then the session finish logic.
void main() {
  late _FakePersistence persistence;
  late _FakeUploadConnector uploadConnector;
  late RefenaContainer container;
  late SendNotifier send;

  SendNotifier harness({
    bool deleteSourceAfterSend = true,
    Map<String, bool> uploadOutcomes = const {},
  }) {
    persistence = _persistence(deleteSourceAfterSend: deleteSourceAfterSend);
    uploadConnector = _FakeUploadConnector(uploadOutcomes);
    container = RefenaContainer(
      observers: [_NoopObserver()],
      overrides: [
        persistenceProvider.overrideWithValue(persistence),
        parentIsolateProvider.overrideWithNotifier(
          (ref) => IsolateController(
            initialState: ParentIsolateState(
              syncState: _syncState(),
              discovery: null,
              httpUpload: uploadConnector,
              httpServer: null,
            ),
          ),
        ),
      ],
    );
    send = container.notifier(sendProvider);
    return send;
  }

  SendingFile file({
    required String id,
    required String name,
    String? path,
    String? token = 'token',
  }) {
    return SendingFile(
      file: FileDto(
        id: id,
        fileName: name,
        size: 3,
        fileType: FileType.other,
        hash: null,
        preview: null,
        metadata: null,
      ),
      token: token,
      thumbnail: null,
      asset: null,
      path: path,
      bytes: path == null ? Uint8List.fromList([1, 2, 3]) : null,
      errorMessage: null,
    );
  }

  void seedSession(SendSessionState session) {
    // ignore: invalid_use_of_protected_member
    send.state = {...send.state, session.sessionId: session};
  }

  SendSessionState session({
    required String sessionId,
    required Map<String, SendingFile> files,
    bool background = false,
    SessionStatus status = SessionStatus.sending,
  }) {
    return SendSessionState(
      sessionId: sessionId,
      remoteSessionId: 'remote-$sessionId',
      background: background,
      status: status,
      target: Device.empty,
      files: files,
      hashedFileCount: files.length,
      startTime: null,
      endTime: null,
      sendingTasks: [],
      errorMessage: null,
    );
  }

  void seedStatuses(String sessionId, Map<String, FileStatus> statuses) {
    container
        .notifier(fileTransferProvider)
        .setStatuses(
          sessionId: sessionId,
          statuses: statuses,
        );
  }

  test('a fully successful session deletes exactly its finished local sources', () async {
    final notifier = harness();
    final dir = await Directory.systemTemp.createTemp('ls_delsrc_success');
    addTearDown(() => dir.delete(recursive: true));
    final plain = File(p.join(dir.path, 'plain.txt'))..writeAsStringSync('a');
    final asUri = File(p.join(dir.path, 'as-uri.bin'))..writeAsStringSync('b');
    final unrelated = File(p.join(dir.path, 'unrelated.txt'))..writeAsStringSync('c');

    final files = {
      'plain': file(id: 'plain', name: 'plain.txt', path: plain.path),
      'uri': file(id: 'uri', name: 'as-uri.bin', path: p.toUri(asUri.path).toString()),
      // Android-style source: kept because there is no channel to delete it.
      'content': file(id: 'content', name: 'photo.jpg', path: 'content://media/external/images/media/42'),
      // A text message sent from memory has no source at all.
      'memory': file(id: 'memory', name: 'message'),
    };
    seedSession(session(sessionId: 's1', files: files));
    seedStatuses('s1', const {
      'plain': FileStatus.finished,
      'uri': FileStatus.finished,
      'content': FileStatus.finished,
      'memory': FileStatus.finished,
    });

    // Retry the memory file to drive the session through its finish logic.
    await notifier.sendFile(sessionId: 's1', file: files['memory']!, isRetry: true);

    expect(notifier.state['s1']!.status, SessionStatus.finished);
    expect(plain.existsSync(), isFalse, reason: 'a plain path of a finished file is deleted');
    expect(asUri.existsSync(), isFalse, reason: 'a file:// URI source is resolved and deleted');
    // The content:// source is skipped without crashing, and the in-memory
    // file has nothing to delete; reaching these assertions is the proof.
    expect(unrelated.existsSync(), isTrue, reason: 'files outside the session are never touched');
  });

  test('a session with a failed file keeps all its sources', () async {
    final notifier = harness(uploadOutcomes: {'retry-me': false});
    final dir = await Directory.systemTemp.createTemp('ls_delsrc_failure');
    addTearDown(() => dir.delete(recursive: true));
    final ok = File(p.join(dir.path, 'ok.txt'))..writeAsStringSync('a');
    final failed = File(p.join(dir.path, 'failed.txt'))..writeAsStringSync('b');

    final files = {
      'ok': file(id: 'ok', name: 'ok.txt', path: ok.path),
      'retry-me': file(id: 'retry-me', name: 'failed.txt', path: failed.path),
    };
    seedSession(session(sessionId: 's1', files: files, status: SessionStatus.finishedWithErrors));
    seedStatuses('s1', const {
      'ok': FileStatus.finished,
      'retry-me': FileStatus.failed,
    });

    await notifier.sendFile(sessionId: 's1', file: files['retry-me']!, isRetry: true);

    expect(notifier.state['s1']!.status, SessionStatus.finishedWithErrors);
    expect(ok.existsSync(), isTrue, reason: 'even the successful file is kept when the session has errors');
    expect(failed.existsSync(), isTrue);
  });

  test('a background success closes the session and deletes the sources', () async {
    final notifier = harness();
    final dir = await Directory.systemTemp.createTemp('ls_delsrc_background');
    addTearDown(() => dir.delete(recursive: true));
    final source = File(p.join(dir.path, 'source.txt'))..writeAsStringSync('a');

    final files = {
      'a': file(id: 'a', name: 'source.txt', path: source.path),
    };
    seedSession(session(sessionId: 's1', files: files, background: true));
    seedStatuses('s1', const {'a': FileStatus.queue});

    await notifier.sendFile(sessionId: 's1', file: files['a']!, isRetry: true);

    expect(notifier.state.containsKey('s1'), isFalse, reason: 'a background session removes itself on success');
    expect(source.existsSync(), isFalse, reason: 'the source is deleted after the silent background finish');
  });

  test('a source that another pending session may still upload is kept', () async {
    final notifier = harness();
    final dir = await Directory.systemTemp.createTemp('ls_delsrc_shared');
    addTearDown(() => dir.delete(recursive: true));
    final shared = File(p.join(dir.path, 'shared.txt'))..writeAsStringSync('a');

    // A second session is still waiting for its receiver decision and
    // references the same file on disk.
    seedSession(
      session(
        sessionId: 'waiting',
        files: {'x': file(id: 'x', name: 'shared.txt', path: shared.path, token: null)},
        status: SessionStatus.waiting,
      ),
    );

    final files = {
      'y': file(id: 'y', name: 'shared.txt', path: shared.path),
    };
    seedSession(session(sessionId: 'running', files: files));
    seedStatuses('running', const {'y': FileStatus.queue});

    await notifier.sendFile(sessionId: 'running', file: files['y']!, isRetry: true);

    expect(notifier.state['running']!.status, SessionStatus.finished);
    expect(shared.existsSync(), isTrue, reason: 'the pending session may still need this source');
  });

  test('nothing is deleted when the setting is off', () async {
    final notifier = harness(deleteSourceAfterSend: false);
    final dir = await Directory.systemTemp.createTemp('ls_delsrc_off');
    addTearDown(() => dir.delete(recursive: true));
    final source = File(p.join(dir.path, 'source.txt'))..writeAsStringSync('a');

    final files = {
      'a': file(id: 'a', name: 'source.txt', path: source.path),
    };
    seedSession(session(sessionId: 's1', files: files));
    seedStatuses('s1', const {'a': FileStatus.queue});

    await notifier.sendFile(sessionId: 's1', file: files['a']!, isRetry: true);

    expect(notifier.state['s1']!.status, SessionStatus.finished);
    expect(source.existsSync(), isTrue, reason: 'the setting gates the whole deletion');
  });
}

/// Answers upload tasks with the same event stream shape the real upload
/// isolate produces: started, then finished or failed per file, then done.
class _FakeUploadConnector implements IsolateConnector<IsolateTaskStreamResult<HttpUploadEvent>, SendToIsolateData<IsolateTask<BaseHttpUploadTask>>> {
  _FakeUploadConnector(this._outcomes);

  /// file id -> whether its upload succeeds.
  final Map<String, bool> _outcomes;
  final _events = StreamController<IsolateTaskStreamResult<HttpUploadEvent>>.broadcast();

  @override
  Stream<IsolateTaskStreamResult<HttpUploadEvent>> get receiveFromIsolate => _events.stream;

  @override
  void sendToIsolate(SendToIsolateData<IsolateTask<BaseHttpUploadTask>> message) {
    final task = message.data!;
    final uploadFiles = (task.data as HttpUploadFilesTask).files;
    final taskId = task.id;
    // ignore: discarded_futures
    Future(() async {
      for (final uploadFile in uploadFiles) {
        _events.add(
          IsolateTaskStreamResult.event(
            id: taskId,
            data: HttpUploadFileStartedEvent(fileId: uploadFile.fileId),
          ),
        );
        if (_outcomes[uploadFile.fileId] ?? true) {
          _events.add(
            IsolateTaskStreamResult.event(
              id: taskId,
              data: HttpUploadFileFinishedEvent(fileId: uploadFile.fileId),
            ),
          );
        } else {
          _events.add(
            IsolateTaskStreamResult.event(
              id: taskId,
              data: HttpUploadFileFailedEvent(fileId: uploadFile.fileId, error: 'fake upload failure'),
            ),
          );
        }
      }
      _events.add(IsolateTaskStreamResult.done(id: taskId));
    });
  }

  @override
  Isolate get isolate => throw UnimplementedError();
}

class _NoopObserver extends RefenaObserver {
  @override
  void handleEvent(RefenaEvent event) {}
}

class _FakePersistence implements PersistenceService {
  final Map<Symbol, Object?> stubs;

  _FakePersistence(this.stubs);

  @override
  dynamic noSuchMethod(Invocation i) {
    if (stubs.containsKey(i.memberName)) return stubs[i.memberName];
    if (i.memberName.toString().contains('set')) {
      return Future<void>.value();
    }
    return super.noSuchMethod(i);
  }
}

_FakePersistence _persistence({required bool deleteSourceAfterSend}) => _FakePersistence({
  #getShowToken: 'token',
  #getAlias: 'alias',
  #getTheme: ThemeMode.system,
  #getColorMode: ColorMode.system,
  #getCustomColor: const Color(0xFF000000),
  #getLocale: null,
  #getPort: 53317,
  #getNetworkWhitelist: null,
  #getNetworkBlacklist: null,
  #getMulticastGroup: '224.0.0.167',
  #getDestination: null,
  #isSaveToGallery: false,
  #isSaveToHistory: false,
  #getQuickSave: QuickSaveMode.off,
  #getReceivePin: null,
  #isAutoFinish: false,
  #isMinimizeToTray: false,
  #isHttps: true,
  #getSendMode: SendMode.single,
  #getSaveWindowPlacement: true,
  #getAlwaysOnTop: false,
  #getEnableAnimations: true,
  #getDeviceType: null,
  #getDeviceModel: null,
  #getShareViaLinkAutoAccept: false,
  #getReceiveViaLinkAutoAccept: false,
  #getCreateChecksums: true,
  #getVerifyChecksums: true,
  #getDeleteSourceAfterSend: deleteSourceAfterSend,
  #getDiscoveryTimeout: 3,
  #getMaxInterfaces: 5,
  #getBleDiscoveryEnabled: false,
  #getAdvancedSettingsEnabled: false,
});

SyncState _syncState() => SyncState(
  rootIsolateToken: Object(),
  securityContext: StoredSecurityContext(privateKey: '', publicKey: '', certificate: '', certificateHash: ''),
  deviceInfo: DeviceInfoResult(deviceType: DeviceType.headless, deviceModel: null, androidSdkInt: null),
  alias: 'alias',
  port: 53317,
  networkWhitelist: null,
  networkBlacklist: null,
  protocol: ProtocolType.https,
  multicastGroup: '224.0.0.167',
  discoveryTimeout: 3,
  serverRunning: false,
  download: false,
);
