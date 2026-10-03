import 'dart:async';
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

/// The [BleTransport] adapter on top of the bluetooth_low_energy plugin
/// (MIT, central role on Android/iOS/macOS/Windows/Linux, peripheral role on
/// Android/iOS/macOS/Windows).
///
/// - Scanning uses the central manager filtered by the LocalSend service
///   UUID, the only way iOS advertisers are visible at all.
/// - Advertising puts the beacon into the manufacturer data section and the
///   service UUID next to it; the local name is deliberately omitted
///   (Windows refuses to advertise one and the service UUID is what
///   scanners filter on).
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

    try {
      if (!await peripheral.authorize()) {
        _logger.warning('The Bluetooth permissions were not granted; BLE advertising is disabled');
        return;
      }
    } on UnsupportedError {
      // Android-only API; the other platforms need no runtime request.
    } catch (e, stackTrace) {
      _logger.warning('Requesting the Bluetooth permissions failed; BLE advertising is disabled', e, stackTrace);
      return;
    }

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

    await peripheral.startAdvertising(
      Advertisement(
        // No name: the local name section is restricted on Windows and
        // iOS only keeps ~10 bytes anyway.
        serviceUUIDs: [_serviceUuid],
        manufacturerSpecificData: [ManufacturerSpecificData(id: bleManufacturerId, data: beacon)],
      ),
    );
    _logger.info('BLE advertising started');
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
        unawaited(peripheral.respondReadRequestWithError(args.request, error: GATTError.invalidOffset));
        return;
      }
      unawaited(peripheral.respondReadRequestWithValue(args.request, value: Uint8List.sublistView(payload, offset)));
    } catch (e, stackTrace) {
      _logger.warning('Answering a BLE GATT read request failed', e, stackTrace);
      try {
        unawaited(peripheral.respondReadRequestWithError(args.request, error: GATTError.unlikelyError));
      } catch (_) {
        // Nothing left to do; the central will see the failed request.
      }
    }
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
    // iOS/macOS advertisers cannot carry manufacturer data; the service
    // UUID is the only marker (it also matches our own advertisements,
    // which carry both).
    for (final uuid in args.advertisement.serviceUUIDs) {
      if (uuid == _serviceUuid) {
        return BleAdvertisementHit(remoteId: remoteId, beacon: null, rssi: args.rssi);
      }
    }
    return null;
  }

  void _rememberPeripheral(String remoteId, Peripheral peripheral) {
    if (_peripherals.length >= 512 && !_peripherals.containsKey(remoteId)) {
      _peripherals.remove(_peripherals.keys.first);
    }
    _peripherals[remoteId] = peripheral;
  }

  @override
  Future<void> startScan() async {
    try {
      if (!await _central.authorize()) {
        _logger.warning('The Bluetooth permissions were not granted; BLE scanning is disabled');
        return;
      }
    } on UnsupportedError {
      // Android-only API; the other platforms need no runtime request.
    } catch (e, stackTrace) {
      _logger.warning('Requesting the Bluetooth permissions failed; BLE scanning is disabled', e, stackTrace);
      return;
    }

    await _central.startDiscovery(serviceUUIDs: [_serviceUuid]);
    _logger.info('BLE scan started');
  }

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
