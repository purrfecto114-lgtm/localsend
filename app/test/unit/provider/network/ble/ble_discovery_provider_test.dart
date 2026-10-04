import 'dart:async';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show TargetPlatform, debugDefaultTargetPlatformOverride;
import 'package:flutter/material.dart' show Color, ThemeMode;
import 'package:localsend_app/model/persistence/color_mode.dart';
import 'package:localsend_app/model/persistence/quick_save_mode.dart';
import 'package:localsend_app/model/send_mode.dart';
import 'package:localsend_app/provider/device_info_provider.dart';
import 'package:localsend_app/provider/network/ble/ble_codec.dart';
import 'package:localsend_app/provider/network/ble/ble_discovery_provider.dart';
import 'package:localsend_app/provider/network/ble/ble_transport.dart';
import 'package:localsend_app/provider/persistence_provider.dart';
import 'package:localsend_app/provider/settings_provider.dart';
import 'package:localsend_isolates/isolate.dart';
import 'package:localsend_isolates/model/device.dart';
import 'package:localsend_isolates/model/device_info_result.dart';
import 'package:localsend_isolates/model/dto/multicast_dto.dart';
import 'package:localsend_isolates/model/stored_security_context.dart';
import 'package:localsend_isolates/src/isolate/child/discovery_isolate.dart';
import 'package:logging/logging.dart';
import 'package:refena_flutter/refena_flutter.dart';
import 'package:test/test.dart';
import 'package:typed_isolates/typed_isolates.dart';

/// Wiring tests for the BLE discovery providers: the feature flag gates the
/// whole module (flag off = zero transport calls, zero dispatch), a
/// discovered peer travels through the real injection seam
/// ([IsolateDiscoveryAddDeviceAction] -> [DiscoveryAddDeviceTask]) and
/// toggling the flag at runtime starts/stops the service.
void main() {
  test('flag on: a discovered peer is dispatched into the discovery store', () async {
    final harness = _Harness(enabled: true);
    final fake = harness.transport;

    final service = harness.container.read(bleDiscoveryProvider);
    await service.start();
    await _pump();

    expect(fake.actions, containsAll(['advertise', 'scan']));
    expect(decodeBleBeacon(fake.advertisedBeacon!)!.port, 53317);

    fake.payloads['peer-1'] = _peerPayload();
    fake.emit(
      'peer-1',
      beacon: encodeBleBeacon(port: 9999, fingerprint: 'fp-peer', salt: Uint8List(4)),
    );
    await _pump();

    expect(harness.connector.sent, hasLength(1));
    final task = harness.connector.sent.single.data!.data as DiscoveryAddDeviceTask;
    expect(task.device.fingerprint, 'fp-peer');
    expect(task.device.ip, '192.168.1.9');
    expect(task.device.channels.single, isA<HttpChannel>());
    expect(service.isRunning, isTrue);
  });

  test('flag off: zero transport calls and zero dispatch', () async {
    final harness = _Harness(enabled: false);
    final fake = harness.transport;

    final service = harness.container.read(bleDiscoveryProvider);
    await service.start();
    await _pump();

    // The service-level "the transport factory is never called while the
    // flag is off" property is covered by ble_discovery_test.dart; here the
    // override is built eagerly by the RefenaContainer itself.
    expect(fake.actions, isEmpty);
    expect(harness.connector.sent, isEmpty);
    expect(service.isRunning, isFalse);
  });

  test('a peer is dropped without a running discovery isolate (no crash)', () async {
    final harness = _Harness(enabled: true, discoveryRunning: false);
    final fake = harness.transport;

    final service = harness.container.read(bleDiscoveryProvider);
    await service.start();
    await _pump();

    fake.payloads['peer-1'] = _peerPayload();
    fake.emit(
      'peer-1',
      beacon: encodeBleBeacon(port: 9999, fingerprint: 'fp-peer', salt: Uint8List(4)),
    );
    await _pump();

    expect(service.isRunning, isTrue);
    expect(harness.connector.sent, isEmpty);
  });

  test('toggling the flag at runtime starts and stops the service', () async {
    final harness = _Harness(enabled: false);
    final fake = harness.transport;

    final service = harness.container.read(bleDiscoveryProvider);
    await service.start();
    await _pump();
    expect(service.isRunning, isFalse);

    final settings = harness.container.notifier(settingsProvider);
    await settings.setBleDiscoveryEnabled(true);
    await _pump();
    expect(service.isRunning, isTrue);
    expect(fake.actions, containsAll(['advertise', 'scan']));

    await settings.setBleDiscoveryEnabled(false);
    await _pump();
    expect(service.isRunning, isFalse);
    expect(fake.actions, containsAll(['stopScan', 'stopAdvertise', 'dispose']));
    expect(harness.connector.sent, isEmpty);
  });

  group('bleSupportedOnThisDevice', () {
    test('accepts every non-Android platform regardless of the SDK int', () {
      expect(bleSupportedOnThisDevice(isAndroid: false, androidSdkInt: null), isTrue);
      expect(bleSupportedOnThisDevice(isAndroid: false, androidSdkInt: 30), isTrue);
    });

    test('accepts Android SDK 31 and newer', () {
      expect(bleSupportedOnThisDevice(isAndroid: true, androidSdkInt: 31), isTrue);
      expect(bleSupportedOnThisDevice(isAndroid: true, androidSdkInt: 34), isTrue);
    });

    test('rejects Android below SDK 31, failing closed on an unknown SDK int', () {
      expect(bleSupportedOnThisDevice(isAndroid: true, androidSdkInt: 30), isFalse);
      expect(bleSupportedOnThisDevice(isAndroid: true, androidSdkInt: 24), isFalse);
      expect(bleSupportedOnThisDevice(isAndroid: true, androidSdkInt: null), isFalse);
    });
  });

  test('the transport provider short-circuits on Android below SDK 31', () {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);

    final records = <LogRecord>[];
    final subscription = Logger.root.onRecord.listen(records.add);
    addTearDown(subscription.cancel);

    final harness = _Harness(enabled: true, androidSdkInt: 30, overrideTransport: false);
    final transport = harness.container.read(bleTransportProvider);

    expect(transport, isA<NoopBleTransport>());
    expect(
      records.where((record) => record.message.contains('Android 12')),
      isNotEmpty,
      reason: 'the SDK gate must fire',
    );
    expect(
      records.where((record) => record.message.contains('not available on this platform')),
      isEmpty,
      reason: 'the plugin must not even be constructed on a gated device',
    );
  });

  test('the transport provider passes the SDK gate on Android 12+ and tries the plugin', () {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);

    final records = <LogRecord>[];
    final subscription = Logger.root.onRecord.listen(records.add);
    addTearDown(subscription.cancel);

    final harness = _Harness(enabled: true, androidSdkInt: 31, overrideTransport: false);
    final transport = harness.container.read(bleTransportProvider);

    // The test VM has no platform channel backend, so the plugin constructor
    // fails and the provider falls back to the noop transport - but the SDK
    // gate itself must have passed (no gate log, but the plugin attempt).
    expect(transport, isA<NoopBleTransport>());
    expect(records.where((record) => record.message.contains('Android 12')), isEmpty);
    expect(
      records.where((record) => record.message.contains('not available on this platform')),
      isNotEmpty,
      reason: 'the gate must let SDK 31 through to the real transport constructor',
    );
  });

  test('the flag stays the first gate: off means no device info read at all', () {
    final harness = _Harness(enabled: false, androidSdkInt: 30, overrideTransport: false);
    final transport = harness.container.read(bleTransportProvider);
    expect(transport, isA<NoopBleTransport>());
  });
}

Future<void> _pump([int times = 8]) async {
  for (var i = 0; i < times; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

Uint8List _peerPayload() {
  return encodeBleDeviceInfo(
    const BleDeviceInfo(
      alias: 'Peer',
      fingerprint: 'fp-peer',
      ip: '192.168.1.9',
      port: 9999,
      https: true,
      deviceModel: null,
      deviceType: DeviceType.mobile,
      download: false,
      version: '2.2',
    ),
  );
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

class _FakeTransport implements BleTransport {
  @override
  final bool supportsAdvertising = true;

  final hits = StreamController<BleAdvertisementHit>.broadcast();
  final actions = <String>[];

  Uint8List? advertisedBeacon;
  final Map<String, Uint8List?> payloads = {};

  void emit(String remoteId, {Uint8List? beacon}) {
    hits.add(BleAdvertisementHit(remoteId: remoteId, beacon: beacon, rssi: -55));
  }

  @override
  Future<void> startAdvertising({required Uint8List beacon, required Uint8List gattPayload}) async {
    actions.add('advertise');
    advertisedBeacon = beacon;
  }

  @override
  Future<void> stopAdvertising() async {
    actions.add('stopAdvertise');
  }

  @override
  Stream<BleAdvertisementHit> get scanStream => hits.stream;

  @override
  Future<void> startScan() async {
    actions.add('scan');
  }

  @override
  Future<void> stopScan() async {
    actions.add('stopScan');
  }

  @override
  Future<Uint8List?> readRemotePayload(String remoteId) async => payloads[remoteId];

  @override
  Future<void> dispose() async {
    actions.add('dispose');
  }
}

class _Harness {
  _Harness({
    required bool enabled,
    bool discoveryRunning = true,
    int? androidSdkInt,
    bool overrideTransport = true,
  }) {
    transport = _FakeTransport();
    connector = _RecordingConnector();
    container = RefenaContainer(
      overrides: [
        persistenceProvider.overrideWithValue(_persistence(enabled)),
        parentIsolateProvider.overrideWithNotifier(
          (ref) => IsolateController(
            initialState: ParentIsolateState(
              syncState: _syncState(),
              discovery: discoveryRunning ? connector : null,
              httpUpload: null,
              httpServer: null,
            ),
          ),
        ),
        if (overrideTransport) bleTransportProvider.overrideWithValue(transport),
        deviceRawInfoProvider.overrideWithValue(
          DeviceInfoResult(deviceType: DeviceType.headless, deviceModel: null, androidSdkInt: androidSdkInt),
        ),
        deviceFullInfoProvider.overrideWithBuilder(
          (ref) => Device(
            signalingId: null,
            ip: '192.168.1.5',
            version: '2.2',
            port: 53317,
            https: true,
            fingerprint: 'fp-self',
            alias: 'Self',
            deviceModel: null,
            deviceType: DeviceType.desktop,
            download: false,
            channels: const [],
          ),
        ),
      ],
    );
  }

  late final _FakeTransport transport;
  late final _RecordingConnector connector;
  late final RefenaContainer container;
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

_FakePersistence _persistence(bool bleEnabled) => _FakePersistence({
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
  #getDeleteSourceAfterSend: false,
  #getDiscoveryTimeout: 3,
  #getMaxInterfaces: 5,
  #getIncludeVpnInterfaces: false,
  #getBleDiscoveryEnabled: bleEnabled,
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
  serverRunning: true,
  download: false,
);
