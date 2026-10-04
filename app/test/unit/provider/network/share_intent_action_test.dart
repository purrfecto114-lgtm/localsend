import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart' show Color, PageController, ThemeMode;
import 'package:flutter_test/flutter_test.dart' show TestWidgetsFlutterBinding;
import 'package:localsend_app/model/persistence/color_mode.dart';
import 'package:localsend_app/model/persistence/quick_save_mode.dart';
import 'package:localsend_app/model/send_mode.dart';
import 'package:localsend_app/model/state/send/send_session_state.dart';
import 'package:localsend_app/pages/home_page.dart';
import 'package:localsend_app/pages/home_page_controller.dart';
import 'package:localsend_app/provider/network/send_provider.dart';
import 'package:localsend_app/provider/network/share_intent_action.dart';
import 'package:localsend_app/provider/persistence_provider.dart';
import 'package:localsend_app/provider/selection/selected_sending_files_provider.dart';
import 'package:localsend_app/util/native/cache_helper.dart';
import 'package:localsend_isolates/model/device.dart';
import 'package:localsend_isolates/model/file_type.dart';
import 'package:localsend_isolates/model/session_status.dart';
import 'package:localsend_isolates/rust/api/model.dart';
import 'package:localsend_isolates/rust/frb_generated.dart';
import 'package:refena_flutter/refena_flutter.dart';
import 'package:share_handler/share_handler.dart';
import 'package:test/test.dart';

/// Tests for [HandleShareIntentAction], the action behind the iOS share
/// sheet / Android share entry points (see init.dart).
///
/// The regression behind localsend/localsend#3197: sharing again without
/// leaving the old result screen left the send tab showing the stale
/// "Finished" session, because the incoming intent only added files and
/// switched tabs. The action must close terminal send sessions first
/// (waiting / sending sessions are never touched) and must not wipe the
/// cache while doing so, because the attachments of the new payload live
/// exactly there.
///
/// The navigation side (popping the stale result page) is a no-op in these
/// unit tests: [TestWidgetsFlutterBinding] is initialized (reading the
/// navigation service's GlobalKey requires an initialized binding) but no
/// widget tree is built, so there is no navigator and the pop does nothing.
/// The store-level effects are fully covered here.
void main() {
  // The share intent action pops the stale result screen via the refena
  // navigation service; reading its GlobalKey requires an initialized
  // binding even when no navigator is attached.
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    RustLib.initMock(api: _FakeRustLibApi());
  });

  late Directory tempDir;
  late _RecordingObserver observer;
  late RefenaContainer container;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('ls_share_intent_test');
  });

  tearDown(() async {
    container.disposeContainer();
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  RefenaContainer createContainer({
    required Map<String, SendSessionState> sessions,
    SendMode sendMode = SendMode.single,
  }) {
    observer = _RecordingObserver();
    return RefenaContainer(
      observers: [observer],
      overrides: [
        persistenceProvider.overrideWithValue(_persistence(sendMode)),
        sendProvider.overrideWithNotifier((ref) => _SeededSendNotifier(sessions)),
        // The home page controller normally drives the PageView of the real
        // widget tree; the unattached controller would throw here.
        homePageControllerProvider.overrideWithInitialState(
          initialState: HomePageVm(
            controller: _NoopPageController(),
            currentTab: HomeTab.receive,
            changeTab: (_) {},
          ),
        ),
        // The real ClearCacheAction spawns an isolate and touches platform
        // channels, neither of which is possible inside `flutter test`.
        // Registering it as a null mock ("empty reducer") short-circuits the
        // dispatch before the real reduce runs; whether it was dispatched at
        // all is recorded by the observer (the ActionDispatchedEvent fires
        // before the override check).
        globalReduxProvider.overrideWithGlobalReducer(
          reducer: {
            ClearCacheAction: null,
          },
        ),
      ],
    );
  }

  SendSessionState session(String id, SessionStatus status) {
    return SendSessionState(
      sessionId: id,
      remoteSessionId: null,
      background: false,
      status: status,
      target: Device.empty,
      files: const {},
      hashedFileCount: 0,
      startTime: null,
      endTime: null,
      sendingTasks: null,
      errorMessage: null,
    );
  }

  Future<File> createSharedFile(String name, List<int> bytes) async {
    final file = File('${tempDir.path}/$name');
    await file.writeAsBytes(bytes);
    return file;
  }

  Future<void> dispatchShareIntent({String? content, List<File> attachments = const []}) {
    return container.global.dispatchAsync(
      HandleShareIntentAction(
        payload: SharedMedia(
          content: content,
          attachments: [
            for (final file in attachments)
              SharedAttachment(
                path: file.path,
                type: SharedAttachmentType.image,
              ),
          ],
        ),
      ),
    );
  }

  test('a new share intent closes a finished session and resets the selection (single send mode)', () async {
    container = createContainer(
      sessions: {
        'a': session('a', SessionStatus.finished),
      },
    );
    container
        .redux(selectedSendingFilesProvider)
        .dispatch(
          AddBinaryAction(bytes: Uint8List.fromList([1]), fileType: FileType.image, fileName: 'photo1.jpg'),
        );

    final photo2 = await createSharedFile('photo2.jpg', [2, 2, 2, 2]);
    await dispatchShareIntent(attachments: [photo2]);
    await Future<void>.delayed(const Duration(milliseconds: 20));

    // The stale session is gone, so its result page can pop back home.
    expect(container.read(sendProvider), isEmpty);

    // The old photo was replaced by the newly shared one
    // (the same reset closing a finished session performs in single mode).
    expect(
      container.read(selectedSendingFilesProvider).map((f) => f.name),
      ['photo2.jpg'],
    );

    // The send tab is active.
    expect(container.read(homePageControllerProvider).currentTab, HomeTab.send);

    // The cache must not be wiped: the new attachment lives in it
    // and would be deleted before it can be sent.
    expect(observer.dispatchedActions.whereType<ClearCacheAction>(), isEmpty);
  });

  test('sessions that are still in flight are never closed', () async {
    container = createContainer(
      sessions: {
        'waiting': session('waiting', SessionStatus.waiting),
        'sending': session('sending', SessionStatus.sending),
        'finished': session('finished', SessionStatus.finished),
      },
    );

    final photo2 = await createSharedFile('photo2.jpg', [2, 2, 2, 2]);
    await dispatchShareIntent(content: 'hello', attachments: [photo2]);

    final sessions = container.read(sendProvider);
    expect(sessions.keys, {'waiting', 'sending'});
    expect(sessions['waiting']!.status, SessionStatus.waiting);
    expect(sessions['sending']!.status, SessionStatus.sending);

    // The finished session reset the selection (single mode),
    // then the message and the new file were added.
    final selection = container.read(selectedSendingFilesProvider);
    expect(selection, hasLength(2));
    expect(selection.first.fileType, FileType.text); // the shared message
    expect(selection.last.name, 'photo2.jpg');

    expect(container.read(homePageControllerProvider).currentTab, HomeTab.send);
  });

  test('without any session the behavior is unchanged (regression)', () async {
    container = createContainer(sessions: {});
    container
        .redux(selectedSendingFilesProvider)
        .dispatch(
          AddBinaryAction(bytes: Uint8List.fromList([1]), fileType: FileType.image, fileName: 'photo1.jpg'),
        );

    expect(container.notifier(sendProvider).closeTerminalSessions(), 0);
    expect(container.read(sendProvider), isEmpty);

    final photo2 = await createSharedFile('photo2.jpg', [2, 2, 2, 2]);
    await dispatchShareIntent(content: 'hello', attachments: [photo2]);

    // The previous selection is kept and the new items are appended,
    // exactly like before the fix.
    final selection = container.read(selectedSendingFilesProvider);
    expect(selection, hasLength(3));
    expect(selection[0].name, 'photo1.jpg');
    expect(selection[1].fileType, FileType.text);
    expect(selection[2].name, 'photo2.jpg');

    expect(container.read(homePageControllerProvider).currentTab, HomeTab.send);
  });

  test('every terminal session state is closed, active ones are kept (multiple send mode keeps the selection)', () async {
    container = createContainer(
      sendMode: SendMode.multiple,
      sessions: {
        'busy': session('busy', SessionStatus.recipientBusy),
        'declined': session('declined', SessionStatus.declined),
        'attempts': session('attempts', SessionStatus.tooManyAttempts),
        'finished': session('finished', SessionStatus.finished),
        'errors': session('errors', SessionStatus.finishedWithErrors),
        'canceledBySender': session('canceledBySender', SessionStatus.canceledBySender),
        'canceledByReceiver': session('canceledByReceiver', SessionStatus.canceledByReceiver),
        'sending': session('sending', SessionStatus.sending),
      },
    );
    container
        .redux(selectedSendingFilesProvider)
        .dispatch(
          AddBinaryAction(bytes: Uint8List.fromList([1]), fileType: FileType.image, fileName: 'photo1.jpg'),
        );

    final photo2 = await createSharedFile('photo2.jpg', [2, 2, 2, 2]);
    await dispatchShareIntent(attachments: [photo2]);

    // All terminal sessions are closed, the in-flight one survives.
    expect(container.read(sendProvider).keys, {'sending'});

    // Multiple send mode does not reset the selection; the new file is appended.
    expect(
      container.read(selectedSendingFilesProvider).map((f) => f.name),
      ['photo1.jpg', 'photo2.jpg'],
    );

    expect(container.read(homePageControllerProvider).currentTab, HomeTab.send);
  });

  test('closing a finished session directly still clears the cache (default unchanged)', () async {
    container = createContainer(
      sessions: {
        'a': session('a', SessionStatus.finished),
      },
    );

    container.notifier(sendProvider).closeSession('a');
    await Future<void>.delayed(const Duration(milliseconds: 20));

    expect(container.read(sendProvider), isEmpty);
    expect(observer.dispatchedActions.whereType<ClearCacheAction>(), hasLength(1));
  });
}

class _SeededSendNotifier extends SendNotifier {
  final Map<String, SendSessionState> _initialState;

  _SeededSendNotifier(this._initialState);

  @override
  Map<String, SendSessionState> init() => _initialState;
}

/// A [PageController] that is never attached to a [PageView]:
/// [ChangeTabAction] calls [PageController.jumpToPage], which requires
/// an attached position in a real controller.
class _NoopPageController extends PageController {
  @override
  void jumpToPage(int page) {}
}

/// Records every dispatched action so tests can assert whether an action
/// (e.g. [ClearCacheAction]) was dispatched at all, even when its reducer is
/// mocked away.
class _RecordingObserver extends RefenaObserver {
  final List<Object> dispatchedActions = [];

  @override
  void handleEvent(RefenaEvent event) {
    if (event is ActionDispatchedEvent) {
      dispatchedActions.add(event.action);
    }
  }
}

/// Provides deterministic [FileMetadata]s without the Rust native library.
class _FakeRustLibApi implements RustLibApi {
  @override
  Future<FileMetadata?> crateApiMetadataReadFileMetadata({required String path}) async {
    return const FileMetadata(modified: '2000-01-01T00:00:00Z', accessed: '2000-01-02T00:00:00Z');
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnsupportedError('Not mocked: ${invocation.memberName}');
}

class _FakePersistence implements PersistenceService {
  final Map<Symbol, Object?> stubs;

  _FakePersistence(this.stubs);

  @override
  dynamic noSuchMethod(Invocation i) {
    if (stubs.containsKey(i.memberName)) return stubs[i.memberName];
    return super.noSuchMethod(i);
  }
}

_FakePersistence _persistence(SendMode sendMode) => _FakePersistence({
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
  #getSendMode: sendMode,
  #getSaveWindowPlacement: true,
  #getAlwaysOnTop: false,
  #getEnableAnimations: true,
  #getDeviceType: null,
  #getDeviceModel: null,
  #getShareViaLinkAutoAccept: false,
  #getReceiveViaLinkAutoAccept: false,
  #getCreateChecksums: true,
  #getVerifyChecksums: true,
  #getDiscoveryTimeout: 3,
  #getMaxInterfaces: 5,
  #getBleDiscoveryEnabled: false,
  #getAdvancedSettingsEnabled: false,
});
