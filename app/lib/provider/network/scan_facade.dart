import 'dart:async';

import 'package:localsend_app/provider/favorites_provider.dart';
import 'package:localsend_app/provider/local_ip_provider.dart';
import 'package:localsend_app/provider/network/nearby_devices_provider.dart';
import 'package:localsend_app/provider/settings_provider.dart';
import 'package:logging/logging.dart';
import 'package:refena_flutter/refena_flutter.dart';

final _logger = Logger('ScanFacade');

/// Discovers devices in stages, cheapest first: multicast announcement and
/// favorite probes right away, http-based discovery on the subnets only when
/// nothing was confirmed within 1 second.
class StartSmartScan extends AsyncGlobalAction {
  /// Maximum number of interfaces to scan.
  /// If there are more interfaces, the first ones will be used or the user needs to select one.
  ///
  /// 5 instead of 3: multi-adapter desktop machines (ethernet + Wi-Fi + VPN +
  /// virtual adapters) plus an active hotspot easily exceed 3 networks, which
  /// dropped the hotspot subnet out of the automatic scan. Each interface
  /// only costs a `/24` scan when the cheap stages (multicast and favorite
  /// probes) found nothing, so the extra candidates are rarely paid for.
  static const maxInterfaces = 5;

  @override
  Future<void> reduce() async {
    final favorites = ref.read(favoritesProvider);
    final settings = ref.read(settingsProvider);
    final networkInterfaces = ref.read(localIpProvider).localIps.take(maxInterfaces).toList();
    final grace = const Duration(seconds: 1);
    _logger.info(
      '[SCAN] smart scan start: ${favorites.length} favorites, interfaces=$networkInterfaces, '
      'port=${settings.port}, https=${settings.https}, grace=${grace.inMilliseconds}ms',
    );
    final devicesBefore = ref.read(nearbyDevicesProvider).devices.length;
    final stopwatch = Stopwatch()..start();

    await ref
        .redux(nearbyDevicesProvider)
        .dispatchAsync(
          StartStagedScan(
            favorites: favorites,
            interfaces: networkInterfaces,
            port: settings.port,
            https: settings.https,
            grace: grace,
          ),
        );

    final devicesAfter = ref.read(nearbyDevicesProvider).devices.length;
    _logger.info(
      '[SCAN] smart scan finished in ${stopwatch.elapsedMilliseconds}ms: ${devicesAfter - devicesBefore} new device(s), total: $devicesAfter',
    );
  }
}

/// HTTP based discovery on a fixed set of subnets.
class StartLegacySubnetScan extends AsyncGlobalAction {
  final List<String> subnets;

  StartLegacySubnetScan({
    required this.subnets,
  });

  @override
  Future<void> reduce() async {
    final settings = ref.read(settingsProvider);
    final port = settings.port;
    final https = settings.https;

    // send announcement in parallel
    ref.redux(nearbyDevicesProvider).dispatch(StartMulticastScan());

    await Future.wait<void>([
      for (final subnet in subnets) ref.redux(nearbyDevicesProvider).dispatchAsync(StartLegacyScan(port: port, localIp: subnet, https: https)),
    ]);
  }
}
