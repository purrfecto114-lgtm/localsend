import 'dart:async';
import 'dart:typed_data';

import 'package:localsend_app/provider/network/ble/ble_codec.dart';
import 'package:localsend_app/provider/network/ble/ble_discovery.dart';
import 'package:localsend_app/provider/network/ble/ble_transport.dart';
import 'package:localsend_isolates/model/device.dart';
import 'package:test/test.dart';

Device _selfDevice() => Device(
  signalingId: null,
  ip: '192.168.1.5',
  version: '2.2',
  port: 53317,
  https: true,
  fingerprint: 'fp-self',
  alias: 'Self',
  deviceModel: 'Test Machine',
  deviceType: DeviceType.desktop,
  download: false,
  channels: const [],
);

Uint8List _remotePayload({String fingerprint = 'fp-remote', String ip = '192.168.1.9', int port = 1234}) {
  return encodeBleDeviceInfo(
    BleDeviceInfo(
      alias: 'Remote',
      fingerprint: fingerprint,
      ip: ip,
      port: port,
      https: false,
      deviceModel: 'Pixel 8',
      deviceType: DeviceType.mobile,
      download: true,
      version: '2.2',
    ),
  );
}

/// Flushes the microtask/event queue so the serialized GATT chain of the
/// service settles; the fakes never use real timers.
Future<void> _pump([int times = 8]) async {
  for (var i = 0; i < times; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

class _FakeTransport implements BleTransport {
  @override
  final bool supportsAdvertising = true;

  final hits = StreamController<BleAdvertisementHit>.broadcast();
  final actions = <String>[];
  final gattReads = <String>[];

  Uint8List? advertisedBeacon;
  Uint8List? advertisedPayload;
  bool advertiseShouldThrow = false;
  bool scanShouldThrow = false;
  Object? readError;
  final Map<String, Uint8List?> payloads = {};

  void emit(String remoteId, {Uint8List? beacon}) {
    hits.add(BleAdvertisementHit(remoteId: remoteId, beacon: beacon, rssi: -60));
  }

  @override
  Future<void> startAdvertising({required Uint8List beacon, required Uint8List gattPayload}) async {
    actions.add('advertise');
    if (advertiseShouldThrow) {
      throw StateError('advertising refused');
    }
    advertisedBeacon = beacon;
    advertisedPayload = gattPayload;
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
    if (scanShouldThrow) {
      throw StateError('scan refused');
    }
  }

  @override
  Future<void> stopScan() async {
    actions.add('stopScan');
  }

  @override
  Future<Uint8List?> readRemotePayload(String remoteId) async {
    gattReads.add(remoteId);
    if (readError != null) {
      throw readError!;
    }
    return payloads[remoteId];
  }

  @override
  Future<void> dispose() async {
    actions.add('dispose');
  }
}

void main() {
  late _FakeTransport transport;
  late List<Device> dispatched;
  late DateTime clock;
  late BleDiscoveryService service;

  setUp(() {
    transport = _FakeTransport();
    dispatched = [];
    clock = DateTime(2026, 1, 1, 12);
    service = BleDiscoveryService(
      transportFactory: () => transport,
      isFeatureEnabled: () => true,
      selfDeviceInfo: _selfDevice,
      onDeviceDiscovered: dispatched.add,
      gattRetryCooldown: const Duration(seconds: 30),
      fingerprintRefreshInterval: const Duration(seconds: 60),
      now: () => clock,
    );
  });

  test('with the flag off, start() builds no transport and dispatches nothing', () async {
    var factoryCalls = 0;
    final disabled = BleDiscoveryService(
      transportFactory: () {
        factoryCalls++;
        return transport;
      },
      isFeatureEnabled: () => false,
      selfDeviceInfo: _selfDevice,
      onDeviceDiscovered: dispatched.add,
    );

    await disabled.start();
    transport.emit(
      'remote-1',
      beacon: encodeBleBeacon(port: 1234, fingerprint: 'fp-remote', salt: Uint8List(4)),
    );
    await _pump();

    expect(factoryCalls, 0, reason: 'the transport must not even be built while the flag is off');
    expect(transport.actions, isEmpty);
    expect(dispatched, isEmpty);
    expect(disabled.isRunning, isFalse);
  });

  test('start() advertises the beacon and scans', () async {
    await service.start();

    expect(transport.actions, containsAll(['advertise', 'scan']));
    final beacon = decodeBleBeacon(transport.advertisedBeacon!)!;
    expect(beacon.port, 53317);
    // The advertised hash is the own fingerprint hashed with the beacon salt.
    expect(bleFingerprintHash('fp-self', beacon.salt), beacon.fpHash);
    expect(beacon.fpHash, isNot(bleFingerprintHash('fp-other', beacon.salt)));
    final payload = decodeBleDeviceInfo(transport.advertisedPayload!)!;
    expect(payload.ip, '192.168.1.5');
    expect(payload.fingerprint, 'fp-self');
    expect(service.isRunning, isTrue);
  });

  test('a beacon hit becomes a dispatched Device with one HTTP channel', () async {
    transport.payloads['remote-1'] = _remotePayload();
    await service.start();

    transport.emit(
      'remote-1',
      beacon: encodeBleBeacon(port: 1234, fingerprint: 'fp-remote', salt: Uint8List.fromList([1, 2, 3, 4])),
    );
    await _pump();

    expect(dispatched, hasLength(1));
    final device = dispatched.single;
    expect(device.ip, '192.168.1.9');
    expect(device.port, 1234);
    expect(device.https, isFalse);
    expect(device.fingerprint, 'fp-remote');
    expect(device.alias, 'Remote');
    expect(device.deviceModel, 'Pixel 8');
    expect(device.deviceType, DeviceType.mobile);
    expect(device.download, isTrue);
    expect(device.channels, hasLength(1));
    final channel = device.channels.single as HttpChannel;
    expect(channel.host, '192.168.1.9');
    expect(channel.port, 1234);
    expect(channel.https, isFalse);
  });

  test('a beaconless hit (iOS-style advertiser) still dispatches', () async {
    transport.payloads['ios-peer'] = _remotePayload();
    await service.start();

    transport.emit('ios-peer'); // no manufacturer data, service UUID only
    await _pump();

    expect(dispatched, hasLength(1));
    expect(dispatched.single.fingerprint, 'fp-remote');
  });

  test('beacons of this device itself are ignored', () async {
    transport.payloads['mirror'] = _remotePayload();
    await service.start();

    // The remote beacon hashes the same fingerprint we own.
    transport.emit(
      'mirror',
      beacon: encodeBleBeacon(port: 1234, fingerprint: 'fp-self', salt: Uint8List(4)),
    );
    await _pump();

    expect(transport.gattReads, isEmpty, reason: 'the self beacon must not trigger a GATT handshake');
    expect(dispatched, isEmpty);
  });

  test('a GATT payload claiming our own fingerprint is dropped', () async {
    transport.payloads['spoof'] = _remotePayload(fingerprint: 'fp-self');
    await service.start();

    transport.emit('spoof'); // beaconless, so the fingerprint check decides
    await _pump();

    expect(transport.gattReads, ['spoof']);
    expect(dispatched, isEmpty);
  });

  test('repeated hits from the same remote within the cooldown read GATT once', () async {
    transport.payloads['remote-1'] = _remotePayload();
    await service.start();

    final beacon = encodeBleBeacon(port: 1234, fingerprint: 'fp-remote', salt: Uint8List(4));
    transport.emit('remote-1', beacon: beacon);
    await _pump();
    transport.emit('remote-1', beacon: beacon);
    await _pump();

    expect(transport.gattReads, hasLength(1));
    expect(dispatched, hasLength(1), reason: 'the fingerprint dedup keeps the single dispatch');

    // After the cooldown the remote is contacted again, and after the
    // refresh interval the device is dispatched again (store refresh).
    clock = clock.add(const Duration(seconds: 61));
    transport.emit('remote-1', beacon: beacon);
    await _pump();

    expect(transport.gattReads, hasLength(2));
    expect(dispatched, hasLength(2));
  });

  test('the same fingerprint from different remotes is dispatched once', () async {
    transport.payloads['remote-1'] = _remotePayload();
    transport.payloads['remote-2'] = _remotePayload();
    await service.start();

    transport.emit(
      'remote-1',
      beacon: encodeBleBeacon(port: 1234, fingerprint: 'fp-remote', salt: Uint8List(4)),
    );
    transport.emit(
      'remote-2',
      beacon: encodeBleBeacon(port: 1234, fingerprint: 'fp-remote', salt: Uint8List.fromList([9, 9, 9, 9])),
    );
    await _pump();

    expect(transport.gattReads, containsAll(['remote-1', 'remote-2']));
    expect(dispatched, hasLength(1));
  });

  test('transport failures are contained and the service keeps working', () async {
    transport.readError = StateError('GATT connection lost');
    await service.start();

    transport.emit(
      'remote-1',
      beacon: encodeBleBeacon(port: 1234, fingerprint: 'fp-remote', salt: Uint8List(4)),
    );
    await _pump();

    expect(dispatched, isEmpty, reason: 'the failed read must not dispatch anything');

    // The service recovers on the next hit.
    transport.readError = null;
    transport.payloads['remote-1'] = _remotePayload();
    clock = clock.add(const Duration(seconds: 31));
    transport.emit(
      'remote-1',
      beacon: encodeBleBeacon(port: 1234, fingerprint: 'fp-remote', salt: Uint8List(4)),
    );
    await _pump();

    expect(dispatched, hasLength(1));
  });

  test('a scan stream error does not escape', () async {
    await service.start();

    transport.hits.addError(StateError('radio died'));
    await _pump();

    // Still running and still processing afterwards.
    transport.payloads['remote-1'] = _remotePayload();
    transport.emit(
      'remote-1',
      beacon: encodeBleBeacon(port: 1234, fingerprint: 'fp-remote', salt: Uint8List(4)),
    );
    await _pump();
    expect(dispatched, hasLength(1));
  });

  test('a failing advertisement does not prevent scanning', () async {
    transport.advertiseShouldThrow = true;
    await service.start();

    expect(transport.actions, contains('scan'));
    expect(service.isRunning, isTrue);

    transport.payloads['remote-1'] = _remotePayload();
    transport.emit(
      'remote-1',
      beacon: encodeBleBeacon(port: 1234, fingerprint: 'fp-remote', salt: Uint8List(4)),
    );
    await _pump();
    expect(dispatched, hasLength(1));
  });

  test('a failing scan shuts the discovery down', () async {
    transport.scanShouldThrow = true;
    await service.start();

    expect(service.isRunning, isFalse);
    expect(transport.actions, containsAll(['stopScan', 'stopAdvertise', 'dispose']));
  });

  test('an unusable local address skips advertising but still scans', () async {
    final noIp = BleDiscoveryService(
      transportFactory: () => transport,
      isFeatureEnabled: () => true,
      selfDeviceInfo: () => _selfDevice().copyWith(ip: '-'),
      onDeviceDiscovered: dispatched.add,
    );
    await noIp.start();

    expect(transport.advertisedBeacon, isNull);
    expect(transport.actions, contains('scan'));
    expect(transport.actions, isNot(contains('advertise')));
  });

  test('stop() releases the transport and start() restarts cleanly', () async {
    await service.start();
    await service.stop();

    expect(service.isRunning, isFalse);
    expect(transport.actions, containsAll(['stopScan', 'stopAdvertise', 'dispose']));

    transport.actions.clear();
    await service.start();
    expect(transport.actions, containsAll(['advertise', 'scan']));

    transport.payloads['remote-1'] = _remotePayload();
    transport.emit(
      'remote-1',
      beacon: encodeBleBeacon(port: 1234, fingerprint: 'fp-remote', salt: Uint8List(4)),
    );
    await _pump();
    expect(dispatched, hasLength(1));
  });

  test('a transport that cannot even be built is tolerated', () async {
    final broken = BleDiscoveryService(
      transportFactory: () => throw UnsupportedError('no BLE on this platform'),
      isFeatureEnabled: () => true,
      selfDeviceInfo: _selfDevice,
      onDeviceDiscovered: dispatched.add,
    );

    await broken.start();
    expect(broken.isRunning, isFalse);
    expect(dispatched, isEmpty);
  });

  test('the noop transport is fully inert', () async {
    const noop = NoopBleTransport();
    expect(noop.supportsAdvertising, isFalse);
    await noop.startAdvertising(beacon: Uint8List(24), gattPayload: Uint8List(4));
    await noop.stopAdvertising();
    await noop.startScan();
    await noop.stopScan();
    expect(await noop.readRemotePayload('anywhere'), isNull);
    await noop.dispose();
    await expectLater(noop.scanStream, emitsDone);
  });
}
