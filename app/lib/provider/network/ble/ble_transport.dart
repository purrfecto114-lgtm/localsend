import 'dart:typed_data';

/// The state of the Bluetooth adapter as far as the transport can tell.
///
/// Mirrors the plugin's adapter state without leaking the plugin type into
/// the transport interface (which stays pure Dart and unit-testable).
enum BleAdapterState { unknown, unsupported, unauthorized, poweredOff, poweredOn }

/// The runtime Bluetooth permissions were denied (Android: the "Nearby
/// devices" permission group). Thrown by [BleTransport.startScan] and
/// [BleTransport.startAdvertising] so the caller can report an actionable
/// status instead of silently doing nothing.
class BlePermissionDeniedException implements Exception {
  const BlePermissionDeniedException();

  @override
  String toString() => 'The Bluetooth permissions were denied';
}

/// The Bluetooth adapter is not in a usable state (powered off, unauthorized
/// or unsupported). Thrown by [BleTransport.startScan] and
/// [BleTransport.startAdvertising] before any radio work is attempted.
class BleAdapterUnavailableException implements Exception {
  const BleAdapterUnavailableException(this.state);

  /// The adapter state that made the transport refuse to start.
  final BleAdapterState state;

  @override
  String toString() => 'The Bluetooth adapter is unavailable (${state.name})';
}

/// One advertisement of a LocalSend peer recognized by the BLE scanner.
class BleAdvertisementHit {
  const BleAdvertisementHit({
    required this.remoteId,
    required this.beacon,
    required this.rssi,
  });

  /// A stable identifier of the remote peripheral for the lifetime of the
  /// transport. Used to deduplicate hits and to address GATT reads.
  final String remoteId;

  /// The raw manufacturer-data beacon payload, when the advertisement
  /// carried one. iOS/macOS advertisers can only carry the service UUID
  /// and the local name, so this is null for them and the scanner has to
  /// fetch everything over GATT.
  final Uint8List? beacon;

  /// The received signal strength indication, in dBm. Not used by the
  /// phase 1 discovery; kept for a future proximity ranking.
  final int rssi;
}

/// The BLE capabilities [BleDiscoveryService] needs: advertising a beacon
/// with a GATT-served device info, scanning for the peers' beacons and
/// reading their device info over GATT.
///
/// The abstraction keeps the discovery orchestration free of platform code
/// and testable with fakes; [NoopBleTransport] is the inert implementation
/// used while the feature flag is off or on platforms without BLE support.
abstract interface class BleTransport {
  /// Whether this platform can advertise and run a GATT server at all
  /// (Linux has no peripheral API in bluetooth_low_energy, for example).
  bool get supportsAdvertising;

  /// Starts advertising the [beacon] payload in the manufacturer data
  /// section and serving [gattPayload] on the device info characteristic.
  Future<void> startAdvertising({
    required Uint8List beacon,
    required Uint8List gattPayload,
  });

  /// Stops advertising. The GATT service is torn down by [dispose].
  Future<void> stopAdvertising();

  /// The recognized peer advertisements. The transport filters the raw
  /// platform scan stream down to LocalSend peers (manufacturer data with
  /// the LocalSend company id or the LocalSend service UUID) and may
  /// coalesce duplicates.
  Stream<BleAdvertisementHit> get scanStream;

  /// Starts scanning for LocalSend peers; the hits arrive on [scanStream].
  ///
  /// Throws [BlePermissionDeniedException] when the runtime Bluetooth
  /// permissions were denied and [BleAdapterUnavailableException] when the
  /// adapter is off/unauthorized/unsupported, so the caller can surface an
  /// honest status instead of a silently dead scan.
  Future<void> startScan();

  /// Stops scanning.
  Future<void> stopScan();

  /// The adapter state changes while the transport is alive (powered
  /// on/off, authorization changes). The inert [NoopBleTransport] emits
  /// nothing. Lets the discovery react to the radio being switched off or
  /// back on mid-session.
  Stream<BleAdapterState> get adapterStateChanges;

  /// Connects to the peer identified by [remoteId] and reads its device
  /// info characteristic. Returns null when the payload could not be read
  /// (peer vanished, GATT layout unknown, timeout).
  Future<Uint8List?> readRemotePayload(String remoteId);

  /// Releases every platform resource held by this transport (the GATT
  /// server registration in particular). The transport must support a
  /// full restart afterwards.
  Future<void> dispose();
}

/// The inert [BleTransport]: every method is a no-op, the scan stream is
/// empty and no platform API is ever touched.
///
/// Installed while the feature flag `ls_ble_discovery_enabled` is off (the
/// default) so that a disabled flag costs nothing at runtime, and as the
/// fallback on platforms where the BLE plugin cannot operate.
class NoopBleTransport implements BleTransport {
  const NoopBleTransport();

  @override
  bool get supportsAdvertising => false;

  @override
  Future<void> startAdvertising({
    required Uint8List beacon,
    required Uint8List gattPayload,
  }) async {}

  @override
  Future<void> stopAdvertising() async {}

  @override
  Stream<BleAdvertisementHit> get scanStream => const Stream.empty();

  @override
  Future<void> startScan() async {}

  @override
  Future<void> stopScan() async {}

  @override
  Stream<BleAdapterState> get adapterStateChanges => const Stream.empty();

  @override
  Future<Uint8List?> readRemotePayload(String remoteId) async => null;

  @override
  Future<void> dispose() async {}
}
