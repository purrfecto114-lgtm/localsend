import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:localsend_app/provider/favorites_provider.dart';
import 'package:localsend_app/provider/local_ip_provider.dart';
import 'package:localsend_app/provider/network/discovery_diagnosis_provider.dart';
import 'package:localsend_app/provider/network/nearby_devices_provider.dart';
import 'package:localsend_app/provider/settings_provider.dart';
import 'package:refena_flutter/refena_flutter.dart';

/// Discovers devices in stages, cheapest first: multicast announcement and
/// favorite probes right away, http-based discovery on the subnets only when
/// nothing was confirmed within 1 second.
class StartSmartScan extends AsyncGlobalAction {
  @override
  Future<void> reduce() async {
    final favorites = ref.read(favoritesProvider);
    final settings = ref.read(settingsProvider);
    final networkState = ref.read(localIpProvider);
    // The interface limit is user-configurable (advanced settings, default 5).
    // VPN interfaces can be opted into (advanced settings, default off): they
    // are then ranked to the front of the candidates so that they always
    // survive the limit.
    final networkInterfaces = selectSmartScanInterfaces(
      rankedIps: networkState.localIps,
      vpnIps: networkState.vpnIps,
      includeVpnInterfaces: settings.includeVpnInterfaces,
      maxInterfaces: settings.maxInterfaces,
    );

    // Void the previous no-devices diagnosis while scanning.
    ref.notifier(discoveryDiagnosisProvider).scanStarted();

    await ref
        .redux(nearbyDevicesProvider)
        .dispatchAsync(
          StartStagedScan(
            favorites: favorites,
            interfaces: networkInterfaces,
            port: settings.port,
            https: settings.https,
            grace: const Duration(seconds: 1),
          ),
        );

    // The last confirmations of a scan race the completion of the scan by
    // a few isolate hops; give them a moment to land so the diagnosis does
    // not declare "no devices" right before a device registers.
    await Future<void>.delayed(const Duration(milliseconds: 500));

    // Judge why the list is (still) empty, from the freshest state.
    await ref
        .notifier(discoveryDiagnosisProvider)
        .scanFinished(
          localIps: ref.read(localIpProvider).localIps,
          devicesFound: ref.read(nearbyDevicesProvider).allDevices.isNotEmpty,
        );
  }
}

/// Selects the interfaces that the smart scan covers.
///
/// [rankedIps] is the ranked list of local addresses (see
/// [rankIpAddresses]) and [vpnIps] the subset belonging to VPN/tunnel
/// interfaces. When [includeVpnInterfaces] is off (the default, preserving
/// the previous behavior), the first [maxInterfaces] addresses are taken as
/// before. When it is on, the VPN addresses are stably moved to the front
/// first, so they are never dropped by the limit even on multi-adapter
/// machines where they would lose the ranking (e.g. behind several physical
/// and virtual adapters, or as a ".1" gateway address of a VPN hub).
@visibleForTesting
List<String> selectSmartScanInterfaces({
  required List<String> rankedIps,
  required Set<String> vpnIps,
  required bool includeVpnInterfaces,
  required int maxInterfaces,
}) {
  final ordered = includeVpnInterfaces && vpnIps.isNotEmpty
      ? [
          ...rankedIps.where(vpnIps.contains),
          ...rankedIps.where((ip) => !vpnIps.contains(ip)),
        ]
      : rankedIps;
  return ordered.take(maxInterfaces).toList();
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
