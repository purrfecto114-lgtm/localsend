import 'dart:io';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:localsend_app/gen/strings.g.dart';
import 'package:localsend_app/model/persistence/color_mode.dart';
import 'package:localsend_app/model/persistence/quick_save_mode.dart';
import 'package:localsend_app/model/send_mode.dart';
import 'package:localsend_app/model/state/network_state.dart';
import 'package:localsend_app/model/state/server/server_state.dart';
import 'package:localsend_app/model/state/server/web_share_state.dart';
import 'package:localsend_app/pages/tabs/settings_tab.dart';
import 'package:localsend_app/pages/tabs/settings_tab_controller.dart';
import 'package:localsend_app/pages/tabs/settings_tab_vm.dart';
import 'package:localsend_app/provider/device_info_provider.dart';
import 'package:localsend_app/provider/local_ip_provider.dart';
import 'package:localsend_app/provider/network/server/server_provider.dart';
import 'package:localsend_app/provider/persistence_provider.dart';
import 'package:localsend_app/provider/settings_provider.dart';
import 'package:localsend_app/provider/tv_provider.dart';
import 'package:localsend_app/util/ui/dynamic_colors.dart';
import 'package:localsend_isolates/isolate.dart';
import 'package:localsend_isolates/model/device.dart';
import 'package:localsend_isolates/model/device_info_result.dart';
import 'package:localsend_isolates/model/dto/multicast_dto.dart';
import 'package:localsend_isolates/model/stored_security_context.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:refena_flutter/refena_flutter.dart';
import 'package:typed_isolates/typed_isolates.dart';

/// Wiring tests for the friendly server start/restart errors in the settings
/// tab: the restart/start buttons (controller level) and the toggles that
/// restart the server after a settings change (widget level) must show the
/// classified startupError texts instead of the raw error.
///
/// The server service is replaced by a fake that throws, so the tests cover
/// the error path only; the raw error still reaches the log via
/// ServerService.startServer.
void main() {
  setUp(() async {
    await LocaleSettings.setLocale(AppLocale.en);

    // The settings tab controller asks the package info for the auto start
    // and context menu state during initialization.
    PackageInfo.setMockInitialValues(
      appName: 'LocalSend',
      packageName: 'org.localsend.localsend_app',
      version: '1.0.0',
      buildNumber: '1',
      buildSignature: '',
    );
  });

  String expectedMessage(String hint, String advice) => '$hint\n$advice';

  Future<void> dismissSnackBar(WidgetTester tester) async {
    // Let the snackbar auto-dismiss so no timer is pending at teardown.
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
  }

  Future<BuildContext> pumpContextOnly(WidgetTester tester) async {
    BuildContext? captured;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              captured = context;
              return const SizedBox();
            },
          ),
        ),
      ),
    );
    return captured!;
  }

  testWidgets('restart failure: Windows access denied (errno 10013) shows the classified advice', (tester) async {
    final error = SocketException(
      'Creating ServerSocket failed (errno = 10013, address = 0.0.0.0, port = 53317)',
      osError: const OSError('Forbidden access', 10013),
    );
    final harness = _Harness(error: error);
    final context = await pumpContextOnly(tester);

    harness.vm.onTapRestartServer(context);
    await tester.pump(const Duration(milliseconds: 100));

    expect(
      find.text(expectedMessage(t.dialogs.startupError.windowsAccessDenied.hint, t.dialogs.startupError.windowsAccessDenied.advice)),
      findsOneWidget,
    );
    // The raw error must not leak into the UI anymore.
    expect(find.textContaining('SocketException'), findsNothing);
    expect(find.textContaining('errno = 10013'), findsNothing);

    await dismissSnackBar(tester);
  });

  testWidgets('start failure: stringified isolate error (os error 98) shows the address-in-use advice', (tester) async {
    const error = 'Address already in use (os error 98)';
    final harness = _Harness(error: error);
    final context = await pumpContextOnly(tester);

    harness.vm.onTapStartServer(context);
    await tester.pump(const Duration(milliseconds: 100));

    expect(
      find.text(expectedMessage(t.dialogs.startupError.addressInUse.hint, t.dialogs.startupError.addressInUse.advice)),
      findsOneWidget,
    );
    expect(find.textContaining('os error 98'), findsNothing);

    await dismissSnackBar(tester);
  });

  testWidgets('start failure: unknown error shows the generic advice', (tester) async {
    final error = Exception('boom');
    final harness = _Harness(error: error);
    final context = await pumpContextOnly(tester);

    harness.vm.onTapStartServer(context);
    await tester.pump(const Duration(milliseconds: 100));

    expect(
      find.text(expectedMessage(t.dialogs.startupError.generic.hint, t.dialogs.startupError.generic.advice)),
      findsOneWidget,
    );
    expect(find.textContaining('boom'), findsNothing);

    await dismissSnackBar(tester);
  });

  testWidgets('verify checksums toggle: failed restart shows the classified message instead of failing silently', (tester) async {
    const error = 'Address already in use (os error 98)';
    final harness = _Harness(
      error: error,
      initialServerState: _serverState(),
      persistence: _persistence(
        advanced: true,
        verifyChecksums: true,
        createChecksums: false,
        https: false,
        enableAnimations: false,
      ),
    );

    await tester.pumpWidget(
      RefenaScope.withContainer(
        container: harness.container,
        ownsContainer: false,
        child: const MaterialApp(home: Scaffold(body: SettingsTab())),
      ),
    );
    await tester.pump();

    // With these persistence values the verify checksums switch is the only
    // switched-on one, which makes it unambiguous to tap.
    final target = find.byWidgetPredicate((widget) => widget is Switch && widget.value);
    expect(target, findsOneWidget);
    await tester.ensureVisible(target);
    await tester.pumpAndSettle();
    await tester.tap(target);
    await tester.pump(const Duration(milliseconds: 100));

    expect(
      find.text(expectedMessage(t.dialogs.startupError.addressInUse.hint, t.dialogs.startupError.addressInUse.advice)),
      findsOneWidget,
    );
    expect(find.textContaining('os error 98'), findsNothing);

    await dismissSnackBar(tester);
  });

  testWidgets('require pin toggle: failed restart shows the classified message instead of failing silently', (tester) async {
    const error = 'Address already in use (os error 98)';
    final harness = _Harness(
      error: error,
      initialServerState: _serverState(),
      persistence: _persistence(
        advanced: true,
        verifyChecksums: false,
        createChecksums: false,
        https: false,
        enableAnimations: false,
        receivePin: '1234',
      ),
    );

    await tester.pumpWidget(
      RefenaScope.withContainer(
        container: harness.container,
        ownsContainer: false,
        child: const MaterialApp(home: Scaffold(body: SettingsTab())),
      ),
    );
    await tester.pump();

    // The require pin switch is the only switched-on one (receivePin != null);
    // toggling it off takes the no-dialog path and restarts the server.
    final target = find.byWidgetPredicate((widget) => widget is Switch && widget.value);
    expect(target, findsOneWidget);
    await tester.ensureVisible(target);
    await tester.pumpAndSettle();
    await tester.tap(target);
    await tester.pump(const Duration(milliseconds: 100));

    expect(
      find.text(expectedMessage(t.dialogs.startupError.addressInUse.hint, t.dialogs.startupError.addressInUse.advice)),
      findsOneWidget,
    );
    expect(find.textContaining('os error 98'), findsNothing);

    await dismissSnackBar(tester);
  });
}

ServerState _serverState() {
  return const ServerState(alias: 'alias', port: 53317, https: true, session: null, web: null);
}

class _Harness {
  _Harness({
    required Object error,
    ServerState? initialServerState,
    _FakePersistence? persistence,
  }) {
    connector = _RecordingConnector();
    container = RefenaContainer(
      observers: [_NoopObserver()],
      overrides: [
        persistenceProvider.overrideWithValue(persistence ?? _persistence()),
        parentIsolateProvider.overrideWithNotifier(
          (ref) => IsolateController(
            initialState: ParentIsolateState(
              syncState: _syncState(),
              discovery: connector,
              httpUpload: null,
              httpServer: null,
            ),
          ),
        ),
        serverProvider.overrideWithNotifier(
          (ref) => _ThrowingServerService(error: error, initialServerState: initialServerState),
        ),
        localIpProvider.overrideWithNotifier(
          (ref) => _NoopLocalIpService(ref.notifier(settingsProvider), ref.notifier(parentIsolateProvider)),
        ),
        deviceRawInfoProvider.overrideWithValue(
          DeviceInfoResult(deviceType: DeviceType.headless, deviceModel: null, androidSdkInt: null),
        ),
        dynamicColorsProvider.overrideWithValue(null),
        tvProvider.overrideWithValue(false),
      ],
    );
    vm = container.read(settingsTabControllerProvider);
  }

  late final _RecordingConnector connector;
  late final RefenaContainer container;
  late final SettingsTabVm vm;
}

/// A server service whose start/restart always fails with [error].
class _ThrowingServerService extends ServerService {
  _ThrowingServerService({
    required this.error,
    this.initialServerState,
  });

  final Object error;
  final ServerState? initialServerState;

  @override
  ServerState? init() => initialServerState;

  @override
  Future<ServerState?> startServerFromSettings() async {
    throw error;
  }

  @override
  Future<ServerState?> restartServerFromSettings() async {
    // Not the inherited stopServer+start: stopServer would fail on the missing
    // http server connector long before the start error under test.
    throw error;
  }

  @override
  Future<ServerState?> restartServer({
    required String alias,
    required int port,
    required bool https,
    WebShareState? web,
  }) async {
    throw error;
  }
}

/// The real [LocalIpService] would subscribe to the connectivity stream and
/// fetch interfaces on init; the error paths under test never need them.
class _NoopLocalIpService extends LocalIpService {
  _NoopLocalIpService(super.settingsService, super.parentIsolateController);

  @override
  BaseReduxAction<ReduxNotifier<NetworkState>, NetworkState, dynamic>? get initialAction => null;
}

class _RecordingConnector implements IsolateConnector<IsolateTaskStreamResult<DiscoveryResult>, SendToIsolateData<IsolateTask<DiscoveryTask>>> {
  final sent = <SendToIsolateData<IsolateTask<DiscoveryTask>>>[];

  @override
  void sendToIsolate(SendToIsolateData<IsolateTask<DiscoveryTask>> message) => sent.add(message);

  @override
  Stream<IsolateTaskStreamResult<DiscoveryResult>> get receiveFromIsolate => const Stream.empty();

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

_FakePersistence _persistence({
  bool advanced = false,
  bool verifyChecksums = true,
  bool createChecksums = true,
  bool https = true,
  bool enableAnimations = true,
  String? receivePin,
}) {
  return _FakePersistence({
    #getShowToken: 'token',
    #getAlias: 'alias',
    #getTheme: ThemeMode.system,
    // Not ColorMode.system: the controller drops that entry from the dropdown
    // when dynamic colors are unavailable (the test override provides none),
    // and a value missing from the items fails the DropdownButton assertion.
    #getColorMode: ColorMode.localsend,
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
    #getReceivePin: receivePin,
    #isAutoFinish: false,
    #isMinimizeToTray: false,
    #isHttps: https,
    #getSendMode: SendMode.single,
    #getSaveWindowPlacement: true,
    #getAlwaysOnTop: false,
    #getEnableAnimations: enableAnimations,
    #getDeviceType: null,
    #getDeviceModel: null,
    #getShareViaLinkAutoAccept: false,
    #getReceiveViaLinkAutoAccept: false,
    #getCreateChecksums: createChecksums,
    #getVerifyChecksums: verifyChecksums,
    #getDiscoveryTimeout: 3,
    #getMaxInterfaces: 5,
    #getBleDiscoveryEnabled: false,
    #getAdvancedSettingsEnabled: advanced,
  });
}

SyncState _syncState() {
  return SyncState(
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
}
