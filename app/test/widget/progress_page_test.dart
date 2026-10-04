import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:localsend_app/config/theme.dart';
import 'package:localsend_app/gen/strings.g.dart';
import 'package:localsend_app/model/persistence/color_mode.dart';
import 'package:localsend_app/model/persistence/quick_save_mode.dart';
import 'package:localsend_app/model/send_mode.dart';
import 'package:localsend_app/model/state/send/send_session_state.dart';
import 'package:localsend_app/model/state/send/sending_file.dart';
import 'package:localsend_app/model/state/server/receive_session_state.dart';
import 'package:localsend_app/model/state/server/receiving_file.dart';
import 'package:localsend_app/model/state/server/server_state.dart';
import 'package:localsend_app/pages/progress_page.dart';
import 'package:localsend_app/provider/file_transfer_provider.dart';
import 'package:localsend_app/provider/network/send_provider.dart';
import 'package:localsend_app/provider/network/server/server_provider.dart';
import 'package:localsend_app/provider/persistence_provider.dart';
import 'package:localsend_isolates/model/device.dart';
import 'package:localsend_isolates/model/dto/file_dto.dart';
import 'package:localsend_isolates/model/file_status.dart';
import 'package:localsend_isolates/model/file_type.dart';
import 'package:localsend_isolates/model/session_status.dart';
import 'package:refena_flutter/refena_flutter.dart';

/// Widget tests for the session-level checksum line on the progress page
/// (mitigation for localsend/localsend#3441 / #3425): a finished session
/// must tell the user whether the integrity of the transferred files was
/// actually checked.
void main() {
  setUp(() => LocaleSettings.setLocale(AppLocale.en));

  Future<void> pumpPage(
    WidgetTester tester, {
    required ServerState serverState,
    required bool verifyChecksums,
    SendSessionState? sendSession,
    Map<String, FileStatus> fileStatuses = const {
      'file-1': FileStatus.finished,
      'file-2': FileStatus.finished,
    },
  }) async {
    await tester.pumpWidget(
      RefenaScope(
        overrides: [
          persistenceProvider.overrideWithValue(_persistence(verifyChecksums)),
          serverProvider.overrideWithNotifier((ref) => _FakeServerService(serverState)),
          if (sendSession != null) sendProvider.overrideWithNotifier((ref) => _FakeSendNotifier({'session-1': sendSession})),
        ],
        child: MaterialApp(
          theme: getTheme(ColorMode.localsend, const Color(0xFF000000), Brightness.light, null),
          home: const ProgressPage(
            showAppBar: false,
            closeSessionOnClose: true,
            sessionId: 'session-1',
          ),
        ),
      ),
    );
    // Let the post-frame init callback run (it populates the file list and
    // the selection), then mark all files as finished like the controllers
    // do when the transfer completes.
    await tester.pump();
    tester
        .element(find.byType(ProgressPage))
        .ref
        .notifier(fileTransferProvider)
        .setStatuses(
          sessionId: 'session-1',
          statuses: fileStatuses,
        );
    await tester.pump();
  }

  testWidgets('finished receiving session with verification and checksums reports verified', (tester) async {
    await pumpPage(tester, serverState: _receiveState(checksums: true), verifyChecksums: true);

    expect(find.text(t.progressPage.titleReceiving), findsOneWidget);
    expect(find.text(t.progressPage.checksum.verified), findsOneWidget);
  });

  testWidgets('finished receiving session without verification reports it as disabled', (tester) async {
    await pumpPage(tester, serverState: _receiveState(checksums: true), verifyChecksums: false);

    expect(find.text(t.progressPage.checksum.disabled), findsOneWidget);
    expect(find.text(t.progressPage.checksum.verified), findsNothing);
  });

  testWidgets('finished receiving session without sender checksums reports it as not verifiable', (tester) async {
    await pumpPage(tester, serverState: _receiveState(checksums: false), verifyChecksums: true);

    expect(find.text(t.progressPage.checksum.notVerifiable), findsOneWidget);
  });

  testWidgets('a session finished with errors keeps the error display and shows no checksum line', (tester) async {
    await pumpPage(
      tester,
      serverState: _receiveState(
        checksums: true,
        status: SessionStatus.finishedWithErrors,
        secondFileError: 'checksum mismatch',
      ),
      verifyChecksums: true,
      fileStatuses: const {
        'file-1': FileStatus.finished,
        'file-2': FileStatus.failed,
      },
    );

    expect(find.text(t.progressPage.total.title.finishedError), findsOneWidget);
    expect(find.text(t.progressPage.checksum.verified), findsNothing);
    expect(find.text(t.progressPage.checksum.notVerifiable), findsNothing);
    expect(find.text(t.progressPage.checksum.disabled), findsNothing);
  });

  testWidgets('a session that is still sending shows no checksum line', (tester) async {
    await pumpPage(
      tester,
      serverState: _receiveState(checksums: true, status: SessionStatus.sending),
      verifyChecksums: true,
    );

    expect(find.text(t.progressPage.checksum.verified), findsNothing);
    expect(find.text(t.progressPage.checksum.disabled), findsNothing);
  });

  testWidgets('finished sending session reports the attached checksum count', (tester) async {
    await pumpPage(
      tester,
      serverState: _serverStateWithoutSession,
      verifyChecksums: true,
      sendSession: _sendSession,
      fileStatuses: const {
        'file-1': FileStatus.finished,
        'file-2': FileStatus.finished,
        'file-3': FileStatus.finished,
      },
    );

    expect(find.text(t.progressPage.titleSending), findsOneWidget);
    expect(find.text(t.progressPage.checksum.attached(curr: 2, n: 3)), findsOneWidget);
  });
}

const _device = Device(
  signalingId: null,
  ip: '192.168.1.5',
  version: '2.2',
  port: 53317,
  https: true,
  fingerprint: 'fp-sender',
  alias: 'Sender',
  deviceModel: null,
  deviceType: DeviceType.desktop,
  download: false,
  channels: [],
);

FileDto _fileDto(String id, {String? hash}) => FileDto(
  id: id,
  fileName: '$id.txt',
  size: 10,
  fileType: FileType.text,
  hash: hash,
  preview: null,
  metadata: null,
);

ReceivingFile _receivingFile(String id, {String? hash, String? errorMessage}) => ReceivingFile(
  file: _fileDto(id, hash: hash),
  token: 'token-$id',
  desiredName: '$id.txt',
  path: null,
  savedToGallery: false,
  errorMessage: errorMessage,
);

/// A receive session with two files; [checksums] controls whether the
/// sender attached a SHA-256 to them.
ServerState _receiveState({
  required bool checksums,
  SessionStatus status = SessionStatus.finished,
  String? secondFileError,
}) {
  return ServerState(
    alias: 'receiver',
    port: 53317,
    https: true,
    session: ReceiveSessionState(
      sessionId: 'session-1',
      status: status,
      sender: _device,
      senderAlias: 'Sender',
      files: {
        'file-1': _receivingFile('file-1', hash: checksums ? 'a' : null),
        'file-2': _receivingFile('file-2', hash: checksums ? 'b' : null, errorMessage: secondFileError),
      },
      startTime: 1700000000000,
      endTime: 1700000001000,
      destinationDirectory: '/downloads',
      cacheDirectory: '/cache',
      saveToGallery: false,
      createdDirectories: {},
    ),
    web: null,
  );
}

final _serverStateWithoutSession = ServerState(
  alias: 'receiver',
  port: 53317,
  https: true,
  session: null,
  web: null,
);

/// A finished send session: two of the three files carry a checksum
/// (the sender could not hash the third one).
final _sendSession = SendSessionState(
  sessionId: 'session-1',
  remoteSessionId: 'remote-1',
  background: false,
  status: SessionStatus.finished,
  target: _device,
  files: {
    'file-1': SendingFile(
      file: _fileDto('file-1', hash: 'a'),
      token: 't',
      thumbnail: null,
      asset: null,
      path: null,
      bytes: null,
      errorMessage: null,
    ),
    'file-2': SendingFile(
      file: _fileDto('file-2', hash: 'b'),
      token: 't',
      thumbnail: null,
      asset: null,
      path: null,
      bytes: null,
      errorMessage: null,
    ),
    'file-3': SendingFile(file: _fileDto('file-3'), token: 't', thumbnail: null, asset: null, path: null, bytes: null, errorMessage: null),
  },
  hashedFileCount: 3,
  startTime: 1700000000000,
  endTime: 1700000001000,
  sendingTasks: [],
  errorMessage: null,
);

class _FakeServerService extends ServerService {
  _FakeServerService(this._initialState);

  final ServerState? _initialState;

  @override
  ServerState? init() => _initialState;
}

class _FakeSendNotifier extends SendNotifier {
  _FakeSendNotifier(this._initialState);

  final Map<String, SendSessionState> _initialState;

  @override
  Map<String, SendSessionState> init() => _initialState;
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

_FakePersistence _persistence(bool verifyChecksums) => _FakePersistence({
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
  #getVerifyChecksums: verifyChecksums,
  #getDiscoveryTimeout: 3,
  #getMaxInterfaces: 5,
  #getBleDiscoveryEnabled: false,
  #getAdvancedSettingsEnabled: false,
});
