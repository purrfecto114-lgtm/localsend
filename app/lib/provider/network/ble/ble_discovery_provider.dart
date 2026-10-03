import 'dart:async';

import 'package:flutter/foundation.dart' show TargetPlatform;
import 'package:localsend_app/model/state/settings_state.dart';
import 'package:localsend_app/provider/device_info_provider.dart';
import 'package:localsend_app/provider/network/ble/ble_discovery.dart';
import 'package:localsend_app/provider/network/ble/ble_low_energy_transport.dart';
import 'package:localsend_app/provider/network/ble/ble_transport.dart';
import 'package:localsend_app/provider/settings_provider.dart';
import 'package:localsend_app/util/native/platform_check.dart';
import 'package:localsend_isolates/isolate.dart';
import 'package:localsend_isolates/model/device.dart';
import 'package:logging/logging.dart';
import 'package:refena_flutter/refena_flutter.dart';

final _logger = Logger('BleDiscoveryProvider');

/// Whether the BLE plugin can run on this device (pure, so the platform
/// matrix is unit-testable).
///
/// On Android below SDK 31 (Android 12) the plugin's `authorize()` would
/// request `ACCESS_FINE_LOCATION`/`ACCESS_COARSE_LOCATION` - permissions
/// the app deliberately does not declare (this fork's BLE scan must stay
/// location-free) - which the system auto-denies, leaving the whole module
/// silently dead. Such devices are treated as unsupported instead, and the
/// discovery runs on the inert noop transport. An unknown SDK int counts
/// as unsupported (fail closed).
bool bleSupportedOnThisDevice({required bool isAndroid, required int? androidSdkInt}) {
  if (!isAndroid) {
    return true;
  }
  return (androidSdkInt ?? 0) >= 31;
}

/// The [BleTransport] backing the BLE discovery.
///
/// While the feature flag `ls_ble_discovery_enabled` is off (the default),
/// this is the [NoopBleTransport]: no platform API is touched, the scan
/// stream is empty and nothing can reach the discovery store. When the flag
/// is on, the bluetooth_low_energy adapter is used - or the noop transport
/// again on unsupported devices (Android below 12) and on platforms where
/// the adapter cannot even be constructed.
final bleTransportProvider = Provider<BleTransport>((ref) {
  if (!ref.read(settingsProvider).bleDiscoveryEnabled) {
    return const NoopBleTransport();
  }
  if (!bleSupportedOnThisDevice(
    isAndroid: checkPlatform([TargetPlatform.android]),
    androidSdkInt: ref.read(deviceInfoProvider).androidSdkInt,
  )) {
    _logger.warning(
      'BLE discovery needs Android 12 (SDK 31) or newer; on older versions the plugin would request undeclared location permissions, so the module stays off',
    );
    return const NoopBleTransport();
  }
  try {
    return LowEnergyBleTransport();
  } catch (e, stackTrace) {
    _logger.warning('The BLE transport is not available on this platform; the BLE discovery stays off', e, stackTrace);
    return const NoopBleTransport();
  }
});

/// Owns the [BleDiscoveryService] lifecycle: the service is started once
/// during the app init (see `config/init.dart`) and follows the feature
/// flag for the rest of the session.
///
/// Discovered devices are dispatched into the regular discovery store via
/// [IsolateDiscoveryAddDeviceAction] - the same injection seam the HTTP
/// /register request uses - and come back through the running discovery
/// listener like any other confirmed device.
final bleDiscoveryProvider = NotifierProvider<BleDiscoveryController, BleDiscoveryService>((ref) => BleDiscoveryController());

class BleDiscoveryController extends Notifier<BleDiscoveryService> {
  StreamSubscription<NotifierEvent<SettingsState>>? _settingsSubscription;

  @override
  BleDiscoveryService init() {
    final service = BleDiscoveryService(
      // Re-read on every start so the transport always matches the flag.
      transportFactory: () => ref.read(bleTransportProvider),
      isFeatureEnabled: () => ref.read(settingsProvider).bleDiscoveryEnabled,
      selfDeviceInfo: () => ref.read(deviceFullInfoProvider),
      onDeviceDiscovered: _dispatchDevice,
    );

    // Follow the feature flag at runtime: enabling starts the discovery,
    // disabling stops it again.
    _settingsSubscription = ref.stream(settingsProvider).listen((event) {
      if (event.prev.bleDiscoveryEnabled == event.next.bleDiscoveryEnabled) {
        return;
      }
      if (event.next.bleDiscoveryEnabled) {
        // Drop the (possibly noop) transport built while the flag was off;
        // the next start() builds a fresh one.
        ref.dispose(bleTransportProvider);
        unawaited(service.start());
      } else {
        unawaited(service.stop());
      }
    });

    return service;
  }

  @override
  void dispose() {
    unawaited(_settingsSubscription?.cancel());
    unawaited(state.stop());
    super.dispose();
  }

  void _dispatchDevice(Device device) {
    if (ref.read(parentIsolateProvider).discovery == null) {
      _logger.info('The discovery isolate is not running; dropping the BLE device ${device.alias}');
      return;
    }
    ref.redux(parentIsolateProvider).dispatch(IsolateDiscoveryAddDeviceAction(device: device));
  }
}
