import 'dart:isolate';

import 'package:flutter/material.dart' show Color, ThemeMode;
import 'package:localsend_app/model/persistence/color_mode.dart';
import 'package:localsend_app/model/persistence/quick_save_mode.dart';
import 'package:localsend_app/model/send_mode.dart';
import 'package:localsend_app/provider/persistence_provider.dart';
import 'package:localsend_app/provider/settings_provider.dart';
import 'package:localsend_isolates/isolate.dart';
import 'package:localsend_isolates/model/device.dart';
import 'package:localsend_isolates/model/device_info_result.dart';
import 'package:localsend_isolates/model/dto/multicast_dto.dart';
import 'package:localsend_isolates/model/stored_security_context.dart';
import 'package:refena_flutter/refena_flutter.dart';
import 'package:test/test.dart';
import 'package:typed_isolates/typed_isolates.dart';

/// Regression tests for the settings -> discovery restart chain.
///
/// Note: an observer is REQUIRED for provider-level onChanged to fire in
/// refena 3.5.0 (BaseNotifier._setState only calls _onChangedListener when
/// _observer != null). The app now always passes an observer
/// (OnChangeEnablingObserver outside debug mode); these tests mirror that
/// setup. A hand-rolled noSuchMethod fake is used for the persistence
/// service because the generated mocks.mocks.dart is stale for some getters.
void main() {
  late _RecordingConnector connector;
  late RefenaContainer container;
  late SettingsService settings;

  setUp(() {
    connector = _RecordingConnector();
    container = RefenaContainer(
      observers: [_NoopObserver()],
      overrides: [
        persistenceProvider.overrideWithValue(_persistence()),
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
      ],
    );
    settings = container.notifier(settingsProvider);
  });

  test('whitelist change sends sync first, then restart after the debounce', () async {
    await settings.setNetworkWhitelist(['192.168.0.*']);

    // The sync message is dispatched immediately.
    expect(connector.sent, hasLength(1));
    expect(connector.sent.first.syncState?.networkWhitelist, ['192.168.0.*']);
    expect(connector.sent.first.data, isNull);

    // The restart is debounced (500ms) but must still arrive.
    await Future<void>.delayed(const Duration(milliseconds: 600));
    expect(connector.sent, hasLength(2));
    expect(connector.sent.last.syncState, isNull);
    expect(connector.sent.last.data?.data, isA<DiscoveryRestartTask>());
  });

  test('unrelated settings change sends nothing to the discovery', () async {
    await settings.setAlias('x');
    await Future<void>.delayed(const Duration(milliseconds: 600));
    expect(connector.sent, isEmpty);
  });

  test('discovery == null during startup does not throw StateError', () async {
    final container2 = RefenaContainer(
      observers: [_NoopObserver()],
      overrides: [
        persistenceProvider.overrideWithValue(_persistence()),
        parentIsolateProvider.overrideWithNotifier(
          (ref) => IsolateController(
            initialState: ParentIsolateState(
              syncState: _syncState(),
              discovery: null,
              httpUpload: null,
              httpServer: null,
            ),
          ),
        ),
      ],
    );
    final settings2 = container2.notifier(settingsProvider);
    await settings2.setDiscoveryTimeout(2);
    await Future<void>.delayed(const Duration(milliseconds: 600));
    // Reaching this point without a StateError is the assertion: the restart
    // dispatch is guarded by discovery != null.
  });

  test('rapid consecutive changes converge into one restart with the final value', () async {
    // Typing "15" into the timeout field fires onChanged twice.
    await settings.setDiscoveryTimeout(1);
    await settings.setDiscoveryTimeout(15);

    // Both syncs are dispatched immediately.
    expect(
      connector.sent.where((m) => m.syncState != null).map((m) => m.syncState!.discoveryTimeout),
      [1, 15],
    );

    // Only one restart arrives after the debounce, and no further messages follow.
    await Future<void>.delayed(const Duration(milliseconds: 700));
    expect(connector.sent.where((m) => m.data != null), hasLength(1));
    expect(connector.sent.last.data?.data, isA<DiscoveryRestartTask>());
  });
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
    // All mutating methods return Future<void>; all value getters used by
    // SettingsService.init() are stubbed above.
    if (i.memberName.toString().contains('set')) return Future<void>.value();
    return super.noSuchMethod(i);
  }
}

PersistenceService _persistence() => _FakePersistence({
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
  #getDiscoveryTimeout: 3,
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
