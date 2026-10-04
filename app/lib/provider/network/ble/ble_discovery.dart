import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:localsend_app/provider/network/ble/ble_codec.dart';
import 'package:localsend_app/provider/network/ble/ble_transport.dart';
import 'package:localsend_isolates/model/device.dart';
import 'package:logging/logging.dart';

final _logger = Logger('BleDiscovery');

/// The user-facing state of the BLE-assisted discovery.
///
/// Every transition is surfaced through [BleDiscoveryService.statusStream]
/// and shown under the settings toggle, so the feature is observable:
/// a user enabling it can tell whether it actually runs (fork.2 hid all
/// of this in the logs, which read as "not implemented").
enum BleDiscoveryStatus {
  /// The feature flag is off (the default).
  disabled,

  /// Running: scanning and advertising.
  active,

  /// Running: scanning only (the platform cannot advertise, or the local
  /// address is not usable yet).
  activeScanOnly,

  /// Stopped because the app went to the background (mobile); resumes on
  /// the next foreground transition while the flag stays on.
  paused,

  /// The runtime Bluetooth permissions were denied; the discovery is off
  /// until they are granted and the flag is toggled again.
  permissionDenied,

  /// The Bluetooth adapter is powered off, unauthorized or unsupported;
  /// the discovery restarts itself when the adapter comes back.
  adapterOff,

  /// The platform is not supported (e.g. Android below 12, where the scan
  /// would need undeclared location permissions).
  unsupportedPlatform,

  /// The discovery could not start for another reason (transport missing,
  /// radio error). Details are in the app log.
  error,
}

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
/// - [start] and [stop] are serialized: a stop issued while a start is still
///   settling waits for it and then tears everything down again, so no
///   orphaned scan (or advertisement) can outlive a stop.
/// - Scan flooding is contained by three bounds: hits weaker than
///   [minHitRssi] are dropped, at most one GATT handshake is in flight (a
///   hit arriving meanwhile is dropped and simply picked up by the peer's
///   next advertisement), and the per-remote cooldown bookkeeping is capped
///   (an attacker cannot grow it without bounds by rotating remote ids).
/// - The beacon salt is rotated every [beaconSaltRotationInterval] while
///   advertising, so the salted fingerprint hash is not a stable radio
///   tracker across a long session.
class BleDiscoveryService {
  BleDiscoveryService({
    required BleTransport Function() transportFactory,
    required bool Function() isFeatureEnabled,
    required Device Function() selfDeviceInfo,
    required void Function(Device device) onDeviceDiscovered,
    bool Function()? isPlatformSupported,
    this.gattRetryCooldown = const Duration(seconds: 30),
    this.fingerprintRefreshInterval = const Duration(seconds: 60),
    this.minHitRssi = defaultMinHitRssi,
    this.gattAttemptCacheLimit = 128,
    this.beaconSaltRotationInterval = const Duration(seconds: 90),
    DateTime Function() now = DateTime.now,
  }) : _transportFactory = transportFactory,
       _isFeatureEnabled = isFeatureEnabled,
       _selfDeviceInfo = selfDeviceInfo,
       _onDeviceDiscovered = onDeviceDiscovered,
       _isPlatformSupported = isPlatformSupported,
       _now = now;

  /// The default RSSI floor for advertisement hits, in dBm. Advertisements
  /// weaker than this are treated as noise and dropped before any GATT
  /// work is queued for them.
  static const int defaultMinHitRssi = -80;

  final BleTransport Function() _transportFactory;
  final bool Function() _isFeatureEnabled;
  final Device Function() _selfDeviceInfo;
  final void Function(Device device) _onDeviceDiscovered;

  /// Whether the platform can run the BLE stack at all (Android below 12
  /// cannot, see [bleSupportedOnThisDevice]). When it returns false the
  /// discovery reports [BleDiscoveryStatus.unsupportedPlatform] and never
  /// builds a transport.
  final bool Function()? _isPlatformSupported;

  /// How long a remote that was already contacted (successfully or not)
  /// waits before its next GATT handshake.
  final Duration gattRetryCooldown;

  /// How long a dispatched fingerprint waits before the same device is fed
  /// into the discovery store again (the store entry would otherwise expire
  /// while the peer keeps advertising).
  final Duration fingerprintRefreshInterval;

  /// Advertisement hits with an RSSI below this value (in dBm) are dropped.
  /// A radio-range attacker spoofing many beacons cannot make the service
  /// connect to all of them; the constant trades discovery range for
  /// flood resilience and can be tuned per deployment.
  final int minHitRssi;

  /// How many remotes the GATT cooldown bookkeeping remembers at most
  /// (least recently used are evicted first). Bounds the memory a scan
  /// flood can consume; the remotes themselves keep working - an evicted
  /// remote is simply contacted again on its next advertisement.
  final int gattAttemptCacheLimit;

  /// How often the beacon salt is regenerated (and the advertisement
  /// restarted with the new salted hash) while advertising.
  final Duration beaconSaltRotationInterval;

  final DateTime Function() _now;

  BleTransport? _transport;
  StreamSubscription<BleAdvertisementHit>? _scanSubscription;

  /// Serializes the GATT handshakes: one connection at a time.
  Future<void> _gattChain = Future.value();

  /// Whether a GATT handshake is queued or running. While it is, further
  /// hits are dropped (backpressure) instead of piling onto the chain.
  bool _gattInFlight = false;

  /// Bumped on every shutdown so a handshake that outlives its session
  /// cannot clear the in-flight token of the next one.
  int _gattGeneration = 0;

  /// The remote ids already handed to GATT, and when.
  final Map<String, DateTime> _lastGattAttempt = {};

  /// The fingerprints already dispatched, and when.
  final Map<String, DateTime> _lastDispatch = {};

  /// Serializes [start], [stop] and the salt rotation: none of them may
  /// interleave with another, otherwise a stop during a starting scan
  /// would leave an orphaned scan behind.
  Future<void> _lifecycleChain = Future.value();

  /// Rotates the beacon salt while advertising.
  Timer? _saltRotationTimer;

  /// Follows the adapter state while the discovery runs, so a radio
  /// switched off mid-session stops the scan (and one switched back on
  /// restarts it) instead of dying silently.
  ///
  /// Deliberately kept alive across stop/start sessions (only [dispose]
  /// cancels it): the adapter-on restart needs it while the service is
  /// stopped. The underlying platform stream (the plugin manager's
  /// broadcast stream) survives transport disposal, and a later transport
  /// wraps the same manager singleton.
  StreamSubscription<BleAdapterState>? _adapterSubscription;

  /// The current user-facing status (see [BleDiscoveryStatus]).
  BleDiscoveryStatus _status = BleDiscoveryStatus.disabled;

  /// The status change events, for the UI. Broadcast: any number of
  /// listeners, before and after transitions.
  Stream<BleDiscoveryStatus> get statusStream => _statusController.stream;
  final StreamController<BleDiscoveryStatus> _statusController = StreamController<BleDiscoveryStatus>.broadcast();

  /// The current user-facing status.
  BleDiscoveryStatus get status => _status;

  void _setStatus(BleDiscoveryStatus status) {
    if (_status == status) {
      return;
    }
    _status = status;
    _logger.info('BLE discovery status: ${status.name}');
    _statusController.add(status);
  }

  /// The device info and salt currently advertised (null while not
  /// advertising). Kept so the salt rotation can re-encode the beacon.
  Device? _advertisedSelf;
  Uint8List _advertisedGattPayload = Uint8List(0);
  Uint8List _beaconSalt = Uint8List(0);

  bool _running = false;

  /// Whether the service currently runs (advertising and/or scanning).
  bool get isRunning => _running;

  /// Starts advertising and scanning.
  ///
  /// A no-op while the feature flag is off or when called twice. Failures
  /// are contained and reported through [statusStream]: a denied permission
  /// or an unusable adapter stops the whole discovery again with the
  /// matching status instead of pretending to run.
  Future<void> start() => _runExclusive(_start);

  /// Stops advertising and scanning and releases the transport.
  ///
  /// A no-op when not running. If a start is still settling, the stop
  /// waits for it and then releases everything that start created.
  /// [paused] marks the stop as temporary (app lifecycle): the status
  /// becomes [BleDiscoveryStatus.paused] instead of `disabled`, and the
  /// next [start] (the resume transition) runs the discovery again.
  Future<void> stop({bool paused = false}) => _runExclusive(() => _stop(paused));

  /// Runs [action] exclusively: lifecycle operations (and the beacon salt
  /// rotation) must never interleave. Errors of one operation neither
  /// escape into the caller of the next queued operation.
  Future<void> _runExclusive(Future<void> Function() action) {
    final result = _lifecycleChain.then((_) => action());
    _lifecycleChain = result.then((_) {}, onError: (Object e, StackTrace stackTrace) {});
    return result;
  }

  Future<void> _start() async {
    if (_running) {
      return;
    }
    if (!_isFeatureEnabled()) {
      // Feature flag off: not even the transport is built.
      _setStatus(BleDiscoveryStatus.disabled);
      return;
    }
    if (!(_isPlatformSupported?.call() ?? true)) {
      _logger.warning('The platform cannot run the BLE discovery (e.g. Android below 12); the module stays off');
      _setStatus(BleDiscoveryStatus.unsupportedPlatform);
      return;
    }

    final BleTransport transport;
    try {
      transport = _transportFactory();
    } catch (e, stackTrace) {
      _logger.warning('The BLE transport is not available; the BLE discovery stays off', e, stackTrace);
      _setStatus(BleDiscoveryStatus.error);
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
      _setStatus(BleDiscoveryStatus.error);
      return;
    }
    final ip = self.ip;
    final hasUsableAddress = ip != null && ip.isNotEmpty && ip != '-' && self.port > 0 && self.port <= 0xFFFF;

    // Advertising is best effort: without it this device cannot be *found*
    // via BLE, but it can still find others. A denied permission or an
    // unavailable adapter is logged here; the scan start below throws the
    // same typed exception and decides the final status.
    var advertising = false;
    if (transport.supportsAdvertising && hasUsableAddress) {
      try {
        _beaconSalt = _randomSalt();
        _advertisedSelf = self;
        _advertisedGattPayload = encodeBleDeviceInfo(BleDeviceInfo.fromDevice(self));
        await transport.startAdvertising(
          beacon: _encodeBeacon(self, _beaconSalt),
          gattPayload: _advertisedGattPayload,
        );
        advertising = true;
        _startSaltRotation();
      } on BlePermissionDeniedException catch (e, stackTrace) {
        _logger.warning('The Bluetooth permissions were denied; BLE advertising is off (the scan start decides the final status)', e, stackTrace);
        _stopSaltRotation();
        _advertisedSelf = null;
        _advertisedGattPayload = Uint8List(0);
      } on BleAdapterUnavailableException catch (e, stackTrace) {
        _logger.warning('The Bluetooth adapter is unavailable; BLE advertising is off (the scan start decides the final status)', e, stackTrace);
        _stopSaltRotation();
        _advertisedSelf = null;
        _advertisedGattPayload = Uint8List(0);
      } catch (e, stackTrace) {
        _logger.warning('BLE advertising failed to start; scanning still works', e, stackTrace);
        _stopSaltRotation();
        _advertisedSelf = null;
        _advertisedGattPayload = Uint8List(0);
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
      _adapterSubscription ??= transport.adapterStateChanges.listen(
        _onAdapterStateChanged,
        onError: (Object e, StackTrace stackTrace) {
          _logger.warning('The BLE adapter state stream failed', e, stackTrace);
        },
      );
      await transport.startScan();
      _setStatus(advertising ? BleDiscoveryStatus.active : BleDiscoveryStatus.activeScanOnly);
      _logger.info('BLE discovery started (${_status.name})');
    } on BlePermissionDeniedException catch (e, stackTrace) {
      _logger.warning('The Bluetooth permissions were denied; the BLE discovery is off', e, stackTrace);
      await _shutdown();
      _setStatus(BleDiscoveryStatus.permissionDenied);
    } on BleAdapterUnavailableException catch (e, stackTrace) {
      _logger.warning('The Bluetooth adapter is unavailable; the BLE discovery is off', e, stackTrace);
      await _shutdown();
      _setStatus(BleDiscoveryStatus.adapterOff);
    } catch (e, stackTrace) {
      _logger.warning('Starting the BLE scan failed; stopping the BLE discovery', e, stackTrace);
      await _shutdown();
      _setStatus(BleDiscoveryStatus.error);
    }
  }

  Future<void> _stop(bool paused) async {
    // A stop never invents a running-looking status: paused only makes
    // sense while the flag is on; everything else lands on disabled.
    final resulting = paused && _isFeatureEnabled() ? BleDiscoveryStatus.paused : BleDiscoveryStatus.disabled;
    if (!_running) {
      _setStatus(resulting);
      return;
    }
    await _shutdown();
    _setStatus(resulting);
  }

  Future<void> _shutdown() async {
    _running = false;

    _stopSaltRotation();
    _advertisedSelf = null;
    _advertisedGattPayload = Uint8List(0);

    // A GATT handshake that is still settling belongs to the old session;
    // it must not hold the in-flight token of the next one.
    _gattGeneration++;
    _gattInFlight = false;

    final subscription = _scanSubscription;
    _scanSubscription = null;
    try {
      await subscription?.cancel();
    } catch (e, stackTrace) {
      _logger.warning('Cancelling the BLE scan subscription failed', e, stackTrace);
    }

    // The adapter subscription intentionally survives the shutdown: it is
    // the trigger for the adapter-on restart while the service is stopped.

    final transport = _transport;
    _transport = null;
    if (transport == null) {
      return;
    }
    await _releaseTransport(transport);
  }

  /// Tears a transport down, swallowing every error: a failing stop must
  /// not mask the original state, and the platform stack is going away
  /// anyway. Also used for a transport whose start was abandoned midway.
  Future<void> _releaseTransport(BleTransport transport) async {
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

  Uint8List _encodeBeacon(Device self, Uint8List salt) {
    return encodeBleBeacon(port: self.port, fingerprint: self.fingerprint, salt: salt);
  }

  void _startSaltRotation() {
    _stopSaltRotation();
    if (beaconSaltRotationInterval <= Duration.zero) {
      return;
    }
    _saltRotationTimer = Timer.periodic(beaconSaltRotationInterval, (_) {
      unawaited(_runExclusive(_rotateBeaconSalt));
    });
  }

  void _stopSaltRotation() {
    _saltRotationTimer?.cancel();
    _saltRotationTimer = null;
  }

  /// Regenerates the beacon salt and restarts the advertisement with the
  /// new salted hash, so the on-air hash changes periodically and cannot
  /// be used to track one session's fingerprint for long.
  Future<void> _rotateBeaconSalt() async {
    final transport = _transport;
    final self = _advertisedSelf;
    if (transport == null || self == null || !_running) {
      return;
    }
    final salt = _randomSalt();
    try {
      final beacon = _encodeBeacon(self, salt);
      // Restarting is the only portable way to swap the advertised payload
      // (the plugin backends have no in-place update).
      await transport.stopAdvertising();
      await transport.startAdvertising(beacon: beacon, gattPayload: _advertisedGattPayload);
      _beaconSalt = salt;
    } catch (e, stackTrace) {
      _logger.warning('Rotating the BLE beacon salt failed', e, stackTrace);
    }
  }

  /// Reacts to the Bluetooth adapter being switched off or back on while
  /// the discovery runs: off stops the scan and reports [BleDiscoveryStatus.adapterOff]
  /// (the platform scan would die silently otherwise); back on restarts the
  /// discovery while the flag is still enabled.
  ///
  /// Runs outside the lifecycle chain's serialization on purpose: the
  /// actual work is queued onto it, so it can never interleave with a
  /// settling start or stop.
  void _onAdapterStateChanged(BleAdapterState state) {
    if (state == BleAdapterState.unknown) {
      return;
    }
    if (state == BleAdapterState.poweredOn) {
      if (!_running && _isFeatureEnabled() && (_isPlatformSupported?.call() ?? true)) {
        unawaited(start());
      }
      return;
    }
    if (_running) {
      _logger.info('The Bluetooth adapter became unavailable (${state.name}); stopping the BLE discovery');
      unawaited(
        _runExclusive(() async {
          await _shutdown();
          _setStatus(BleDiscoveryStatus.adapterOff);
        }),
      );
    }
  }

  /// Stops the discovery (if running) and closes the status stream. The
  /// service must not be used afterwards.
  ///
  /// Goes through [stop] so a still-settling start is drained first; the
  /// status stream is closed only after the chain is idle, so no listener
  /// notification can hit a closed controller.
  Future<void> dispose() async {
    await stop();
    final adapterSubscription = _adapterSubscription;
    _adapterSubscription = null;
    try {
      await adapterSubscription?.cancel();
    } catch (e, stackTrace) {
      _logger.warning('Cancelling the BLE adapter subscription failed', e, stackTrace);
    }
    await _statusController.close();
  }

  void _onScanHit(BleAdvertisementHit hit) {
    if (hit.rssi < minHitRssi) {
      // Too weak to be worth a connection; also the first line of defense
      // against a flood of spoofed advertisements.
      return;
    }
    if (_gattInFlight) {
      // Backpressure: a handshake is queued or running. The dropped peer
      // advertises again within moments and is picked up then; its
      // cooldown is not consumed, so the retry is immediate.
      return;
    }
    _gattInFlight = true;
    final generation = _gattGeneration;
    // Serialize the handshakes: concurrent GATT connections to multiple
    // peers are the fastest way to trip a mobile BLE stack.
    _gattChain = _gattChain.then((_) => _processHit(hit)).whenComplete(() {
      if (generation == _gattGeneration) {
        _gattInFlight = false;
      }
    });
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
      _lastGattAttempt.remove(hit.remoteId);
      if (_lastGattAttempt.length >= gattAttemptCacheLimit) {
        // Least recently used first; a scan flood cannot grow this map
        // without bounds by rotating remote ids.
        _lastGattAttempt.remove(_lastGattAttempt.keys.first);
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
