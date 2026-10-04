import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';
import 'package:localsend_app/provider/network/ble/ble_codec.dart';
import 'package:localsend_app/provider/network/ble/ble_transport.dart';
import 'package:logging/logging.dart';

final _logger = Logger('BleLowEnergyTransport');

final UUID _serviceUuid = UUID.fromString(bleServiceUuidString);
final UUID _characteristicUuid = UUID.fromString(bleCharacteristicUuidString);

const _connectTimeout = Duration(seconds: 10);
const _gattTimeout = Duration(seconds: 5);

/// How long to wait for the first definitive adapter state when the cached
/// state is still [BluetoothLowEnergyState.unknown] (the backends fill it
/// asynchronously via a platform-channel roundtrip at manager construction;
/// reading it synchronously right after construction would misreport every
/// Android device as unavailable).
const _adapterStateTimeout = Duration(seconds: 3);

BleAdapterState _mapAdapterState(BluetoothLowEnergyState state) => switch (state) {
  BluetoothLowEnergyState.unknown => BleAdapterState.unknown,
  BluetoothLowEnergyState.unsupported => BleAdapterState.unsupported,
  BluetoothLowEnergyState.unauthorized => BleAdapterState.unauthorized,
  BluetoothLowEnergyState.poweredOff => BleAdapterState.poweredOff,
  BluetoothLowEnergyState.poweredOn => BleAdapterState.poweredOn,
};

/// Opens the system's app-settings page (Android/iOS) so the user can grant
/// the denied Bluetooth permissions. Returns false on platforms without
/// such a page or when it cannot be opened.
Future<bool> openBluetoothAppSettings() async {
  try {
    await PeripheralManager().showAppSettings();
    return true;
  } catch (e, stackTrace) {
    _logger.warning('Opening the app settings failed', e, stackTrace);
    return false;
  }
}

/// Which sections of a BLE advertisement this platform's beacon uses.
enum BleAdvertisementPayload {
  /// The advertisement carries the LocalSend service UUID only.
  ///
  /// iOS/macOS: the darwin stack drops the manufacturer data from app
  /// advertisements anyway, so the service UUID is the only usable marker.
  serviceUuid,

  /// The advertisement carries the manufacturer data beacon only.
  ///
  /// Android/Windows: a 128-bit service UUID (18 bytes of advertisement
  /// budget) plus the beacon structure (28 bytes) exceeds the 31 bytes a
  /// legacy advertisement may carry (`ADVERTISE_FAILED_DATA_TOO_LARGE`),
  /// so the beacon gets the whole budget. Scanners recognize it by the
  /// company id instead of a service UUID filter.
  manufacturerData,
}

/// Chooses the advertisement payload for a platform (pure, so the platform
/// matrix is unit-testable).
BleAdvertisementPayload bleAdvertisementPayloadFor({
  required bool isAndroid,
  required bool isIOS,
  required bool isMacOS,
}) {
  if (isIOS || isMacOS) {
    return BleAdvertisementPayload.serviceUuid;
  }
  return BleAdvertisementPayload.manufacturerData;
}

/// The [BleTransport] adapter on top of the bluetooth_low_energy plugin
/// (MIT, central role on Android/iOS/macOS/Windows/Linux, peripheral role on
/// Android/iOS/macOS/Windows).
///
/// - Scanning uses the central manager unfiltered: the Android/Windows
///   beacons no longer carry the service UUID (advertisement budget), so a
///   UUID filter would hide them. The raw stream is filtered down to
///   LocalSend peers in Dart ([_tryParseAdvertisement]).
/// - Advertising puts either the beacon into the manufacturer data section
///   (Android/Windows) or the service UUID (iOS/macOS) - never both, see
///   [bleAdvertisementPayloadFor]. The local name is deliberately omitted
///   (Windows refuses to advertise one and the service UUID variant is what
///   iOS keeps anyway).
/// - The device info is served from a read-only GATT characteristic; read
///   requests are answered with the latest payload (offset-aware for long
///   reads).
///
/// Every platform call is wrapped: a failing BLE stack degrades to no
/// discovery instead of crashing the app. This class cannot be constructed
/// on platforms without a bluetooth_low_energy backend (the manager
/// factories throw); the provider catches that and falls back to the noop
/// transport.
class LowEnergyBleTransport implements BleTransport {
  LowEnergyBleTransport() : _central = CentralManager();

  final CentralManager _central;

  PeripheralManager? _peripheralManager;
  bool _peripheralManagerResolved = false;
  StreamSubscription<GATTCharacteristicReadRequestedEventArgs>? _readRequests;

  /// The remote peers seen while scanning, by their UUID.
  /// Capped to keep a long session from growing without bounds.
  final Map<String, Peripheral> _peripherals = {};

  Uint8List _gattPayload = Uint8List(0);

  @override
  bool get supportsAdvertising => _resolvePeripheralManager() != null;

  /// The peripheral manager is resolved lazily because its factory throws
  /// on platforms without the peripheral role (Linux).
  PeripheralManager? _resolvePeripheralManager() {
    if (_peripheralManagerResolved) {
      return _peripheralManager;
    }
    try {
      _peripheralManager = PeripheralManager();
    } catch (e, stackTrace) {
      _logger.warning('The BLE peripheral role is not available on this platform; this device cannot be discovered via BLE', e, stackTrace);
    }
    _peripheralManagerResolved = true;
    return _peripheralManager;
  }

  @override
  Future<void> startAdvertising({
    required Uint8List beacon,
    required Uint8List gattPayload,
  }) async {
    final peripheral = _resolvePeripheralManager();
    if (peripheral == null) {
      return;
    }

    await _authorize(peripheral);
    await _ensureAdapterUsable(peripheral);

    _gattPayload = gattPayload;

    final characteristic = GATTCharacteristic.mutable(
      uuid: _characteristicUuid,
      properties: [GATTCharacteristicProperty.read],
      permissions: [GATTCharacteristicPermission.read],
      descriptors: const [],
    );
    final service = GATTService(
      uuid: _serviceUuid,
      isPrimary: true,
      includedServices: const [],
      characteristics: [characteristic],
    );
    await peripheral.addService(service);

    _readRequests ??= peripheral.characteristicReadRequested.listen(_onReadRequested);

    final payloadShape = bleAdvertisementPayloadFor(
      isAndroid: Platform.isAndroid,
      isIOS: Platform.isIOS,
      isMacOS: Platform.isMacOS,
    );
    // No name: the local name section is restricted on Windows and
    // iOS only keeps ~10 bytes anyway.
    final advertisement = switch (payloadShape) {
      BleAdvertisementPayload.serviceUuid => Advertisement(serviceUUIDs: [_serviceUuid]),
      BleAdvertisementPayload.manufacturerData => Advertisement(
        manufacturerSpecificData: [ManufacturerSpecificData(id: bleManufacturerId, data: beacon)],
      ),
    };
    await peripheral.startAdvertising(advertisement);
    _logger.info('BLE advertising started (${payloadShape.name})');
  }

  /// Requests the runtime Bluetooth permissions (Android only; the other
  /// platforms need no runtime request) and translates a denial into
  /// [BlePermissionDeniedException] so the caller can report it.
  Future<void> _authorize(BluetoothLowEnergyManager manager) async {
    try {
      if (!await manager.authorize()) {
        throw const BlePermissionDeniedException();
      }
    } on UnsupportedError {
      // Android-only API; the other platforms need no runtime request.
    }
  }

  /// Refuses to touch the radio while the adapter is not powered on.
  ///
  /// The manager's cached [BluetoothLowEnergyManager.state] starts as
  /// [BluetoothLowEnergyState.unknown] and is filled asynchronously at
  /// construction, so a still-unknown state waits briefly for the first
  /// definitive [BluetoothLowEnergyManager.stateChanged] event instead of
  /// misreading the startup gap; if nothing arrives the platform call
  /// itself surfaces the real error.
  Future<void> _ensureAdapterUsable(BluetoothLowEnergyManager manager) async {
    var state = manager.state;
    if (state == BluetoothLowEnergyState.unknown) {
      try {
        state = await manager.stateChanged
            .map((event) => event.state)
            .firstWhere((state) => state != BluetoothLowEnergyState.unknown)
            .timeout(_adapterStateTimeout);
      } on TimeoutException {
        return; // Still unknown: let the platform call surface the real error.
      }
    }
    switch (state) {
      case BluetoothLowEnergyState.poweredOn:
      case BluetoothLowEnergyState.unknown:
        return;
      case BluetoothLowEnergyState.poweredOff:
      case BluetoothLowEnergyState.unauthorized:
      case BluetoothLowEnergyState.unsupported:
        throw BleAdapterUnavailableException(_mapAdapterState(state));
    }
  }

  void _onReadRequested(GATTCharacteristicReadRequestedEventArgs args) {
    final peripheral = _peripheralManager;
    if (peripheral == null) {
      return;
    }
    try {
      final offset = args.request.offset;
      final payload = _gattPayload;
      if (offset < 0 || offset > payload.length) {
        _respondWithError(peripheral, args.request, GATTError.invalidOffset);
        return;
      }
      unawaited(
        peripheral.respondReadRequestWithValue(args.request, value: Uint8List.sublistView(payload, offset)).catchError((
          Object e,
          StackTrace stackTrace,
        ) {
          _logger.warning('Answering a BLE GATT read request failed', e, stackTrace);
        }),
      );
    } catch (e, stackTrace) {
      _logger.warning('Answering a BLE GATT read request failed', e, stackTrace);
      _respondWithError(peripheral, args.request, GATTError.unlikelyError);
    }
  }

  void _respondWithError(PeripheralManager peripheral, GATTReadRequest request, GATTError error) {
    unawaited(
      peripheral.respondReadRequestWithError(request, error: error).catchError((Object e, StackTrace stackTrace) {
        _logger.warning('Rejecting a BLE GATT read request failed', e, stackTrace);
      }),
    );
  }

  @override
  Future<void> stopAdvertising() async {
    final peripheral = _peripheralManager;
    if (peripheral == null) {
      return;
    }
    try {
      await peripheral.stopAdvertising();
    } catch (e, stackTrace) {
      _logger.warning('Stopping BLE advertising failed', e, stackTrace);
    }
  }

  @override
  late final Stream<BleAdvertisementHit> scanStream = _central.discovered
      .map<BleAdvertisementHit?>(_tryParseAdvertisement)
      .where((hit) => hit != null)
      .map((hit) => hit!);

  BleAdvertisementHit? _tryParseAdvertisement(DiscoveredEventArgs args) {
    final remoteId = args.peripheral.uuid.toString();
    _rememberPeripheral(remoteId, args.peripheral);

    for (final data in args.advertisement.manufacturerSpecificData) {
      if (data.id == bleManufacturerId) {
        return BleAdvertisementHit(remoteId: remoteId, beacon: data.data, rssi: args.rssi);
      }
    }
    // Advertisers that cannot carry the manufacturer data (iOS/macOS)
    // announce the service UUID instead; it is the only marker there.
    // Beacons of platforms that spent the whole advertisement budget on
    // the manufacturer data (Android/Windows) are already matched above.
    for (final uuid in args.advertisement.serviceUUIDs) {
      if (uuid == _serviceUuid) {
        return BleAdvertisementHit(remoteId: remoteId, beacon: null, rssi: args.rssi);
      }
    }
    return null;
  }

  void _rememberPeripheral(String remoteId, Peripheral peripheral) {
    // Re-inserting an existing key does not move it to the end of a Dart
    // map, so remove first: a remote that keeps advertising must count as
    // recently used, not as the next eviction candidate.
    _peripherals.remove(remoteId);
    if (_peripherals.length >= 512) {
      _peripherals.remove(_peripherals.keys.first);
    }
    _peripherals[remoteId] = peripheral;
  }

  @override
  Future<void> startScan() async {
    await _authorize(_central);
    await _ensureAdapterUsable(_central);

    // Unfiltered on purpose: the Android/Windows beacons carry no service
    // UUID (advertisement budget), so a UUID filter would hide them. The
    // Dart side filter ([_tryParseAdvertisement]) keeps the noise out.
    await _central.startDiscovery(serviceUUIDs: const []);
    _logger.info('BLE scan started');
  }

  @override
  Stream<BleAdapterState> get adapterStateChanges => _central.stateChanged.map((event) => _mapAdapterState(event.state));

  @override
  Future<void> stopScan() async {
    try {
      await _central.stopDiscovery();
    } catch (e, stackTrace) {
      _logger.warning('Stopping the BLE scan failed', e, stackTrace);
    }
  }

  @override
  Future<Uint8List?> readRemotePayload(String remoteId) async {
    final peripheral = _peripherals[remoteId];
    if (peripheral == null) {
      return null;
    }

    try {
      await _central.connect(peripheral).timeout(_connectTimeout);
      final services = await _central.discoverGATT(peripheral).timeout(_gattTimeout);
      for (final service in services) {
        for (final characteristic in service.characteristics) {
          if (characteristic.uuid == _characteristicUuid) {
            return await _central.readCharacteristic(peripheral, characteristic).timeout(_gattTimeout);
          }
        }
      }
      return null;
    } finally {
      try {
        await _central.disconnect(peripheral);
      } catch (e, stackTrace) {
        _logger.warning('Disconnecting from the BLE peripheral failed', e, stackTrace);
      }
    }
  }

  @override
  Future<void> dispose() async {
    await _readRequests?.cancel();
    _readRequests = null;

    final peripheral = _peripheralManager;
    if (peripheral == null) {
      return;
    }
    try {
      await peripheral.stopAdvertising();
    } catch (e, stackTrace) {
      _logger.warning('Stopping BLE advertising during the disposal failed', e, stackTrace);
    }
    try {
      await peripheral.removeAllServices();
    } catch (e, stackTrace) {
      _logger.warning('Removing the BLE GATT services failed', e, stackTrace);
    }
    _logger.info('BLE transport disposed');
  }
}
