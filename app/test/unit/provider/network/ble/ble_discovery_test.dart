import 'dart:async';
import 'dart:typed_data';

import 'package:fake_async/fake_async.dart';
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

Uint8List _beacon(String fingerprint) => encodeBleBeacon(port: 1234, fingerprint: fingerprint, salt: Uint8List(4));

/// Flushes the microtask/event queue so the serialized GATT chain of the
/// service settles; the fakes never use real timers.
Future<void> _pump([int times = 8]) async {
  for (var i = 0; i < times; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

class _FakeTransport implements BleTransport {
  _FakeTransport({this.supportsAdvertising = true});

  @override
  final bool supportsAdvertising;

  final hits = StreamController<BleAdvertisementHit>.broadcast();
  final adapterStates = StreamController<BleAdapterState>.broadcast();
  final actions = <String>[];
  final gattReads = <String>[];

  Uint8List? advertisedBeacon;
  Uint8List? advertisedPayload;
  bool advertiseShouldThrow = false;
  bool scanShouldThrow = false;
  Object? advertiseError;
  Object? scanError;
  Object? readError;

  /// While set, [startScan] does not complete until the completer fires
  /// (used to suspend a start midway).
  Completer<void>? scanGate;

  /// While set, [readRemotePayload] does not complete until the completer
  /// fires (used to keep a GATT handshake in flight).
  Completer<void>? readGate;

  final Map<String, Uint8List?> payloads = {};

  void emit(String remoteId, {Uint8List? beacon, int rssi = -60}) {
    hits.add(BleAdvertisementHit(remoteId: remoteId, beacon: beacon, rssi: rssi));
  }

  @override
  Future<void> startAdvertising({required Uint8List beacon, required Uint8List gattPayload}) async {
    actions.add('advertise');
    if (advertiseError != null) {
      throw advertiseError!;
    }
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
  Stream<BleAdapterState> get adapterStateChanges => adapterStates.stream;

  @override
  Future<void> startScan() async {
    actions.add('scan');
    if (scanError != null) {
      throw scanError!;
    }
    if (scanShouldThrow) {
      throw StateError('scan refused');
    }
    final gate = scanGate;
    if (gate != null) {
      await gate.future;
    }
  }

  @override
  Future<void> stopScan() async {
    actions.add('stopScan');
  }

  @override
  Future<Uint8List?> readRemotePayload(String remoteId) async {
    gattReads.add(remoteId);
    final gate = readGate;
    if (gate != null) {
      await gate.future;
    }
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
    expect(disabled.status, BleDiscoveryStatus.disabled);
  });

  test('a successful start reports the active status on the status stream', () async {
    final statuses = <BleDiscoveryStatus>[];
    final subscription = service.statusStream.listen(statuses.add);
    addTearDown(subscription.cancel);

    await service.start();
    await _pump();

    expect(service.status, BleDiscoveryStatus.active);
    expect(statuses, [BleDiscoveryStatus.active]);

    await service.stop();
    await _pump();
    expect(service.status, BleDiscoveryStatus.disabled);
    expect(statuses, [BleDiscoveryStatus.active, BleDiscoveryStatus.disabled]);
  });

  test('a start without advertising reports activeScanOnly', () async {
    final scanOnly = BleDiscoveryService(
      transportFactory: () => _FakeTransport(supportsAdvertising: false),
      isFeatureEnabled: () => true,
      selfDeviceInfo: _selfDevice,
      onDeviceDiscovered: dispatched.add,
    );

    await scanOnly.start();

    expect(scanOnly.status, BleDiscoveryStatus.activeScanOnly);
    expect(scanOnly.isRunning, isTrue);
  });

  test('a denied permission stops the discovery and reports permissionDenied', () async {
    transport.scanError = const BlePermissionDeniedException();
    transport.advertiseError = const BlePermissionDeniedException();

    await service.start();

    expect(service.isRunning, isFalse, reason: 'the service must not pretend to run after a denial');
    expect(service.status, BleDiscoveryStatus.permissionDenied);
    expect(transport.actions, contains('scan'), reason: 'the scan start must have been attempted: it decides the final status');
    expect(transport.actions, containsAll(['stopScan', 'stopAdvertise', 'dispose']));
  });

  test('an unavailable adapter stops the discovery and reports adapterOff', () async {
    transport.scanError = const BleAdapterUnavailableException(BleAdapterState.poweredOff);
    transport.advertiseError = const BleAdapterUnavailableException(BleAdapterState.poweredOff);

    await service.start();

    expect(service.isRunning, isFalse);
    expect(service.status, BleDiscoveryStatus.adapterOff);
    expect(transport.actions, contains('scan'), reason: 'the scan start must have been attempted: it decides the final status');
    expect(transport.actions, containsAll(['stopScan', 'stopAdvertise', 'dispose']));
  });

  test('an unauthorized adapter is reported as a permission problem, not a radio problem', () async {
    transport.scanError = const BleAdapterUnavailableException(BleAdapterState.unauthorized);

    await service.start();

    expect(service.isRunning, isFalse);
    expect(
      service.status,
      BleDiscoveryStatus.permissionDenied,
      reason: 'an unauthorized adapter must offer the settings shortcut, not the turn-bluetooth-on advice',
    );
  });

  test('a generic scan failure reports error', () async {
    transport.scanShouldThrow = true;

    await service.start();

    expect(service.isRunning, isFalse);
    expect(service.status, BleDiscoveryStatus.error);
    expect(transport.actions, containsAll(['stopScan', 'stopAdvertise', 'dispose']));
  });

  test('stop(paused) reports paused while the flag is on, stop() reports disabled', () async {
    await service.start();

    await service.stop(paused: true);
    expect(service.status, BleDiscoveryStatus.paused);
    expect(service.isRunning, isFalse);

    await service.start();
    expect(service.status, BleDiscoveryStatus.active);

    await service.stop();
    expect(service.status, BleDiscoveryStatus.disabled);
  });

  test('an unsupported platform reports unsupportedPlatform without building a transport', () async {
    var factoryCalls = 0;
    final unsupported = BleDiscoveryService(
      transportFactory: () {
        factoryCalls++;
        return transport;
      },
      isFeatureEnabled: () => true,
      isPlatformSupported: () => false,
      selfDeviceInfo: _selfDevice,
      onDeviceDiscovered: dispatched.add,
    );

    await unsupported.start();

    expect(factoryCalls, 0, reason: 'no transport may be built on an unsupported platform');
    expect(unsupported.status, BleDiscoveryStatus.unsupportedPlatform);
    expect(unsupported.isRunning, isFalse);
  });

  test('an adapter-off event mid-run stops the scan; powered-on restarts it', () async {
    await service.start();
    expect(service.status, BleDiscoveryStatus.active);

    transport.adapterStates.add(BleAdapterState.poweredOff);
    await _pump();

    expect(service.isRunning, isFalse);
    expect(service.status, BleDiscoveryStatus.adapterOff);
    expect(transport.actions, containsAll(['stopScan', 'stopAdvertise', 'dispose']));

    transport.adapterStates.add(BleAdapterState.poweredOn);
    await _pump();

    expect(service.isRunning, isTrue);
    expect(service.status, BleDiscoveryStatus.active);
    expect(transport.actions.where((a) => a == 'scan').length, 2, reason: 'the discovery must restart with the adapter');
  });

  test('an adapter-on event while lifecycle-paused does not restart the discovery', () async {
    await service.start();
    await service.stop(paused: true);
    expect(service.status, BleDiscoveryStatus.paused);
    expect(transport.actions.where((a) => a == 'scan'), hasLength(1));

    // The user toggles Bluetooth while the app is in the background: the
    // radio work must stay down (strictly foreground), even though the
    // adapter is now powered on and the flag is still enabled.
    transport.adapterStates.add(BleAdapterState.poweredOn);
    await _pump();

    expect(service.isRunning, isFalse, reason: 'the background restart must be suppressed while lifecycle-paused');
    expect(service.status, BleDiscoveryStatus.paused);
    expect(transport.actions.where((a) => a == 'scan'), hasLength(1), reason: 'no second scan start may have happened');

    // The resume transition restarts the discovery.
    await service.start();
    expect(service.isRunning, isTrue);
    expect(service.status, BleDiscoveryStatus.active);
    expect(transport.actions.where((a) => a == 'scan'), hasLength(2));
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

    transport.emit('remote-1', beacon: _beacon('fp-remote'));
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

  test('a GATT payload with a non-literal ip is dropped without a dispatch', () async {
    transport.payloads['evil'] = _remotePayload(ip: 'attacker.example.com');
    await service.start();

    transport.emit('evil', beacon: _beacon('fp-remote'));
    await _pump();

    expect(transport.gattReads, ['evil']);
    expect(dispatched, isEmpty, reason: 'the codec must reject a host name in the ip field');
  });

  test('repeated hits from the same remote within the cooldown read GATT once', () async {
    transport.payloads['remote-1'] = _remotePayload();
    await service.start();

    final beacon = _beacon('fp-remote');
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

    // The advertisements arrive one after the other, as they do on the
    // radio: a hit landing while a handshake is in flight is dropped and
    // picked up again by the peer's next advertisement.
    transport.emit('remote-1', beacon: _beacon('fp-remote'));
    await _pump();
    transport.emit(
      'remote-2',
      beacon: encodeBleBeacon(port: 1234, fingerprint: 'fp-remote', salt: Uint8List.fromList([9, 9, 9, 9])),
    );
    await _pump();

    expect(transport.gattReads, containsAll(['remote-1', 'remote-2']));
    expect(dispatched, hasLength(1));
  });

  test('hits weaker than the RSSI floor are dropped', () async {
    transport.payloads['far'] = _remotePayload();
    await service.start();

    transport.emit('far', beacon: _beacon('fp-remote'), rssi: -95);
    await _pump();
    expect(transport.gattReads, isEmpty, reason: 'a -95 dBm hit is below the -80 dBm floor');

    transport.emit('far', beacon: _beacon('fp-remote'), rssi: -79);
    await _pump();
    expect(transport.gattReads, ['far'], reason: 'a -79 dBm hit passes the floor');
  });

  test('a hit arriving while a GATT handshake is in flight is dropped, not queued', () async {
    final readGate = Completer<void>();
    transport.readGate = readGate;
    await service.start();

    transport.payloads['slow'] = _remotePayload();
    transport.emit('slow'); // beaconless hit, its GATT read now hangs on the gate
    await _pump(3);
    expect(transport.gattReads, ['slow']);

    transport.payloads['other'] = _remotePayload(fingerprint: 'fp-other');
    transport.emit('other');
    await _pump(3);
    expect(transport.gattReads, ['slow'], reason: 'the in-flight handshake must hold the single-flight token');

    readGate.complete();
    await _pump(3);
    expect(dispatched, hasLength(1), reason: 'only the slow handshake can dispatch');

    // The dropped peer is picked up by its next advertisement.
    transport.emit('other');
    await _pump(3);
    expect(transport.gattReads, contains('other'));
    expect(dispatched, hasLength(2));
  });

  test('the per-remote cooldown bookkeeping is capped (LRU)', () async {
    final capped = BleDiscoveryService(
      transportFactory: () => transport,
      isFeatureEnabled: () => true,
      selfDeviceInfo: _selfDevice,
      onDeviceDiscovered: dispatched.add,
      gattRetryCooldown: const Duration(seconds: 30),
      fingerprintRefreshInterval: const Duration(seconds: 60),
      gattAttemptCacheLimit: 2,
      now: () => clock,
    );
    await capped.start();

    transport.payloads['a'] = _remotePayload(fingerprint: 'fp-a');
    transport.payloads['b'] = _remotePayload(fingerprint: 'fp-b');
    transport.payloads['c'] = _remotePayload(fingerprint: 'fp-c');
    for (final id in ['a', 'b']) {
      transport.emit(id, beacon: _beacon('fp-$id'));
      await _pump();
    }
    expect(transport.gattReads, containsAll(['a', 'b']));

    // 'c' evicts 'a' (the least recently used entry) from the cooldown
    // map: 'b' is still remembered (its next advertisement stays blocked
    // within the cooldown), while 'a' is contacted again immediately.
    transport.emit('c', beacon: _beacon('fp-c'));
    await _pump();
    transport.emit('b', beacon: _beacon('fp-b'));
    await _pump();
    transport.emit('a', beacon: _beacon('fp-a'));
    await _pump();

    expect(transport.gattReads.where((id) => id == 'c').length, 1);
    expect(transport.gattReads.where((id) => id == 'b').length, 1, reason: 'the remembered remote is still within its cooldown');
    expect(transport.gattReads.where((id) => id == 'a').length, 2, reason: 'the evicted remote is contacted again');
    await capped.stop();
  });

  test('transport failures are contained and the service keeps working', () async {
    transport.readError = StateError('GATT connection lost');
    await service.start();

    transport.emit('remote-1', beacon: _beacon('fp-remote'));
    await _pump();

    expect(dispatched, isEmpty, reason: 'the failed read must not dispatch anything');

    // The service recovers on the next hit.
    transport.readError = null;
    transport.payloads['remote-1'] = _remotePayload();
    clock = clock.add(const Duration(seconds: 31));
    transport.emit('remote-1', beacon: _beacon('fp-remote'));
    await _pump();

    expect(dispatched, hasLength(1));
  });

  test('a scan stream error does not escape', () async {
    await service.start();

    transport.hits.addError(StateError('radio died'));
    await _pump();

    // Still running and still processing afterwards.
    transport.payloads['remote-1'] = _remotePayload();
    transport.emit('remote-1', beacon: _beacon('fp-remote'));
    await _pump();
    expect(dispatched, hasLength(1));
  });

  test('a failing advertisement does not prevent scanning', () async {
    transport.advertiseShouldThrow = true;
    await service.start();

    expect(transport.actions, contains('scan'));
    expect(service.isRunning, isTrue);

    transport.payloads['remote-1'] = _remotePayload();
    transport.emit('remote-1', beacon: _beacon('fp-remote'));
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
    transport.emit('remote-1', beacon: _beacon('fp-remote'));
    await _pump();
    expect(dispatched, hasLength(1));
  });

  test('stop() while start() is still settling leaves no orphan scan', () async {
    final gate = Completer<void>();
    transport.scanGate = gate;
    final starting = service.start();
    await _pump(2);
    expect(service.isRunning, isTrue, reason: 'the service counts as running while the scan startup is in flight');

    final stopping = service.stop();
    gate.complete();
    await starting;
    await stopping;
    await _pump();

    expect(service.isRunning, isFalse);
    expect(transport.actions.where((a) => a == 'scan'), hasLength(1));
    expect(transport.actions.where((a) => a == 'stopScan'), hasLength(1), reason: 'the scan that started mid-shutdown must be torn down again');
    expect(transport.actions, containsAll(['stopAdvertise', 'dispose']));

    // A hit after the shutdown goes nowhere: the subscription is gone.
    transport.payloads['remote-1'] = _remotePayload();
    transport.emit('remote-1', beacon: _beacon('fp-remote'));
    await _pump();
    expect(transport.gattReads, isEmpty);
  });

  test('the beacon salt rotates while advertising', () {
    fakeAsync((async) {
      final rotating = BleDiscoveryService(
        transportFactory: () => transport,
        isFeatureEnabled: () => true,
        selfDeviceInfo: _selfDevice,
        onDeviceDiscovered: dispatched.add,
        gattRetryCooldown: const Duration(seconds: 30),
        fingerprintRefreshInterval: const Duration(seconds: 60),
        beaconSaltRotationInterval: const Duration(seconds: 90),
        now: () => clock,
      );
      unawaited(rotating.start());
      async.flushMicrotasks();

      final initial = decodeBleBeacon(transport.advertisedBeacon!)!;
      expect(bleFingerprintHash('fp-self', initial.salt), initial.fpHash);

      async.elapse(const Duration(seconds: 90));
      async.flushMicrotasks();

      final rotated = decodeBleBeacon(transport.advertisedBeacon!)!;
      expect(rotated.salt, isNot(equals(initial.salt)), reason: 'the salt must change after one rotation interval');
      expect(
        bleFingerprintHash('fp-self', rotated.salt),
        rotated.fpHash,
        reason: 'the rotated beacon must still hash the own fingerprint',
      );
      expect(transport.actions.where((a) => a == 'advertise').length, 2);
      expect(transport.actions, contains('stopAdvertise'));

      // Stopping cancels the rotation: no further advertisement restarts.
      unawaited(rotating.stop());
      async.flushMicrotasks();
      async.elapse(const Duration(seconds: 180));
      async.flushMicrotasks();
      expect(transport.actions.where((a) => a == 'advertise').length, 2, reason: 'the rotation must stop with the service');
    });
  });

  test('a failing advertisement is not retried by the salt rotation', () {
    fakeAsync((async) {
      transport.advertiseShouldThrow = true;
      final rotating = BleDiscoveryService(
        transportFactory: () => transport,
        isFeatureEnabled: () => true,
        selfDeviceInfo: _selfDevice,
        onDeviceDiscovered: dispatched.add,
        beaconSaltRotationInterval: const Duration(seconds: 90),
        now: () => clock,
      );
      unawaited(rotating.start());
      async.flushMicrotasks();
      expect(transport.advertisedBeacon, isNull);

      async.elapse(const Duration(seconds: 180));
      async.flushMicrotasks();
      expect(
        transport.actions.where((a) => a == 'advertise').length,
        1,
        reason: 'the rotation must not hammer a radio that refused the advertisement',
      );
    });
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
