import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:localsend_app/provider/network/ble/ble_codec.dart';
import 'package:localsend_app/provider/network/ble/ble_transport.dart';
import 'package:localsend_isolates/model/device.dart';
import 'package:logging/logging.dart';

final _logger = Logger('BleDiscovery');

/// Orchestrates the BLE-assisted discovery (phase 1).
///
/// While the feature flag is on, this service advertises a 24 byte beacon
/// (plus a GATT characteristic holding the full device info) and scans for
/// the peers' beacons. A recognized peer is contacted over GATT, its device
/// info is decoded into a [Device] with a single [HttpChannel] and handed to
/// [onDeviceDiscovered] - which feeds it into the regular HTTP discovery
/// store via the same injection seam the /register HTTP request uses. The
/// actual file transfer always goes over the network; BLE only bridges the
/// discovery when the network blocks multicast (AP isolation).
///
/// Robustness rules:
/// - While the feature flag is off, [start] returns before building any
///   transport: no platform API is touched, nothing is dispatched.
/// - Every platform interaction is wrapped; a failing BLE stack degrades to
///   "no BLE discovery" and never propagates into the app.
/// - Beacons are deduplicated per remote (with a retry cooldown) and the
///   dispatched devices per fingerprint (with a refresh interval, so a peer
///   stays in the store while it keeps advertising).
class BleDiscoveryService {
  BleDiscoveryService({
    required BleTransport Function() transportFactory,
    required bool Function() isFeatureEnabled,
    required Device Function() selfDeviceInfo,
    required void Function(Device device) onDeviceDiscovered,
    this.gattRetryCooldown = const Duration(seconds: 30),
    this.fingerprintRefreshInterval = const Duration(seconds: 60),
    DateTime Function() now = DateTime.now,
  }) : _transportFactory = transportFactory,
       _isFeatureEnabled = isFeatureEnabled,
       _selfDeviceInfo = selfDeviceInfo,
       _onDeviceDiscovered = onDeviceDiscovered,
       _now = now;

  final BleTransport Function() _transportFactory;
  final bool Function() _isFeatureEnabled;
  final Device Function() _selfDeviceInfo;
  final void Function(Device device) _onDeviceDiscovered;

  /// How long a remote that was already contacted (successfully or not)
  /// waits before its next GATT handshake.
  final Duration gattRetryCooldown;

  /// How long a dispatched fingerprint waits before the same device is fed
  /// into the discovery store again (the store entry would otherwise expire
  /// while the peer keeps advertising).
  final Duration fingerprintRefreshInterval;

  final DateTime Function() _now;

  BleTransport? _transport;
  StreamSubscription<BleAdvertisementHit>? _scanSubscription;

  /// Serializes the GATT handshakes: one connection at a time.
  Future<void> _gattChain = Future.value();

  /// The remote ids already handed to GATT, and when.
  final Map<String, DateTime> _lastGattAttempt = {};

  /// The fingerprints already dispatched, and when.
  final Map<String, DateTime> _lastDispatch = {};

  bool _running = false;

  /// Whether the service currently runs (advertising and/or scanning).
  bool get isRunning => _running;

  /// Starts advertising and scanning.
  ///
  /// A no-op while the feature flag is off or when called twice. Failures
  /// are contained: an unusable advertisement (e.g. Windows Nearby Sharing
  /// holding the radio) only disables advertising, while a failing scan
  /// stops the whole BLE discovery again.
  Future<void> start() async {
    if (_running) {
      return;
    }
    if (!_isFeatureEnabled()) {
      // Feature flag off: not even the transport is built.
      return;
    }

    final BleTransport transport;
    try {
      transport = _transportFactory();
    } catch (e, stackTrace) {
      _logger.warning('The BLE transport is not available; the BLE discovery stays off', e, stackTrace);
      return;
    }
    _running = true;
    _transport = transport;

    final Device self;
    try {
      self = _selfDeviceInfo();
    } catch (e, stackTrace) {
      _logger.warning('Reading the local device info failed; stopping the BLE discovery', e, stackTrace);
      await _shutdown();
      return;
    }
    final ip = self.ip;
    final hasUsableAddress = ip != null && ip.isNotEmpty && ip != '-' && self.port > 0 && self.port <= 0xFFFF;

    // Advertising is best effort: without it this device cannot be *found*
    // via BLE, but it can still find others.
    if (transport.supportsAdvertising && hasUsableAddress) {
      try {
        final beacon = encodeBleBeacon(
          port: self.port,
          fingerprint: self.fingerprint,
          salt: _randomSalt(),
        );
        final payload = encodeBleDeviceInfo(BleDeviceInfo.fromDevice(self));
        await transport.startAdvertising(beacon: beacon, gattPayload: payload);
      } catch (e, stackTrace) {
        _logger.warning('BLE advertising failed to start; scanning still works', e, stackTrace);
      }
    } else {
      _logger.info('Skipping BLE advertising (supported: ${transport.supportsAdvertising}, usable address: $hasUsableAddress); scanning only');
    }

    try {
      _scanSubscription = transport.scanStream.listen(
        _onScanHit,
        onError: (Object e, StackTrace stackTrace) {
          _logger.warning('The BLE scan stream failed', e, stackTrace);
        },
      );
      await transport.startScan();
      _logger.info('BLE discovery started');
    } catch (e, stackTrace) {
      _logger.warning('Starting the BLE scan failed; stopping the BLE discovery', e, stackTrace);
      await _shutdown();
    }
  }

  /// Stops advertising and scanning and releases the transport.
  Future<void> stop() async {
    if (!_running) {
      return;
    }
    await _shutdown();
  }

  Future<void> _shutdown() async {
    _running = false;

    final subscription = _scanSubscription;
    _scanSubscription = null;
    await subscription?.cancel();

    final transport = _transport;
    _transport = null;
    if (transport == null) {
      return;
    }
    // Swallow teardown errors: a failing stop must not mask the original
    // state, and the platform stack is going away anyway.
    try {
      await transport.stopScan();
    } catch (e, stackTrace) {
      _logger.warning('Stopping the BLE scan failed', e, stackTrace);
    }
    try {
      await transport.stopAdvertising();
    } catch (e, stackTrace) {
      _logger.warning('Stopping BLE advertising failed', e, stackTrace);
    }
    try {
      await transport.dispose();
    } catch (e, stackTrace) {
      _logger.warning('Disposing the BLE transport failed', e, stackTrace);
    }
  }

  void _onScanHit(BleAdvertisementHit hit) {
    // Serialize the handshakes: concurrent GATT connections to multiple
    // peers are the fastest way to trip a mobile BLE stack.
    _gattChain = _gattChain.then((_) => _processHit(hit));
  }

  Future<void> _processHit(BleAdvertisementHit hit) async {
    // Every failure here is contained; the chain must stay usable.
    try {
      final transport = _transport;
      if (transport == null || !_running) {
        return;
      }

      final self = _selfDeviceInfo();

      // Self-detection without leaking the fingerprint: recompute the
      // salted hash with our own fingerprint and skip on a match. Only
      // possible when the beacon is decodable; the beaconless path (iOS
      // advertisers) relies on the fingerprint check after the GATT read.
      final rawBeacon = hit.beacon;
      if (rawBeacon != null) {
        final beacon = decodeBleBeacon(rawBeacon);
        if (beacon != null && _bytesEqual(bleFingerprintHash(self.fingerprint, beacon.salt), beacon.fpHash)) {
          return;
        }
      }

      final now = _now();
      final lastAttempt = _lastGattAttempt[hit.remoteId];
      if (lastAttempt != null && now.difference(lastAttempt) < gattRetryCooldown) {
        return;
      }
      _lastGattAttempt[hit.remoteId] = now;

      final payload = await transport.readRemotePayload(hit.remoteId);
      if (payload == null) {
        return;
      }
      final info = decodeBleDeviceInfo(payload);
      if (info == null) {
        _logger.info('Dropping a malformed BLE GATT payload from ${hit.remoteId}');
        return;
      }
      if (info.fingerprint == self.fingerprint) {
        // Ourselves, seen through the beaconless path.
        return;
      }

      final lastDispatch = _lastDispatch[info.fingerprint];
      if (lastDispatch != null && now.difference(lastDispatch) < fingerprintRefreshInterval) {
        // Already in the store; re-dispatch only after the refresh
        // interval so the peer does not expire while it keeps advertising.
        return;
      }
      _lastDispatch[info.fingerprint] = now;
      _onDeviceDiscovered(info.toDevice());
    } catch (e, stackTrace) {
      _logger.warning('Processing a BLE discovery hit failed', e, stackTrace);
    }
  }
}

Uint8List _randomSalt() {
  final random = Random.secure();
  return Uint8List.fromList(List.generate(4, (_) => random.nextInt(256)));
}

bool _bytesEqual(List<int> a, List<int> b) {
  if (a.length != b.length) {
    return false;
  }
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) {
      return false;
    }
  }
  return true;
}
