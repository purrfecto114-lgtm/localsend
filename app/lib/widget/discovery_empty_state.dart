import 'package:flutter/material.dart';
import 'package:localsend_app/gen/strings.g.dart';
import 'package:localsend_app/provider/network/discovery_diagnosis_provider.dart';
import 'package:localsend_app/provider/network/nearby_devices_provider.dart';
import 'package:localsend_app/provider/network/scan_facade.dart';
import 'package:localsend_app/provider/settings_provider.dart';
import 'package:localsend_app/widget/list_tile/device_placeholder_list_tile.dart';
import 'package:refena_flutter/refena_flutter.dart';

/// The placeholder shown in the send tab while no nearby device was found.
///
/// While a scan is running, it shows a "searching" hint. After a scan
/// finished without any device, it shows which discovery layer failed
/// (network interfaces / multicast / scan) together with actionable advice,
/// instead of a purely decorative placeholder.
class DiscoveryEmptyState extends StatelessWidget {
  const DiscoveryEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final (runningFavoriteScan, runningIps) = context.ref.watch(
      nearbyDevicesProvider.select((s) => (s.runningFavoriteScan, s.runningIps)),
    );
    final diagnosis = context.ref.watch(discoveryDiagnosisProvider);
    final port = context.ref.watch(settingsProvider.select((s) => s.port));
    final scanning = runningFavoriteScan || runningIps.isNotEmpty;

    final Widget? status;
    if (scanning) {
      status = Text(
        t.sendTab.diagnosis.scanning,
        style: const TextStyle(color: Colors.grey),
        textAlign: TextAlign.center,
      );
    } else {
      final layer = diagnosis.failureLayer;
      status = layer == null ? null : _Advice(layer: layer, diagnosis: diagnosis, port: port);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Opacity(
          opacity: 0.3,
          child: DevicePlaceholderListTile(),
        ),
        if (status != null)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: status,
          ),
        if (!scanning)
          Center(
            child: TextButton.icon(
              onPressed: () async {
                context.redux(nearbyDevicesProvider).dispatch(ClearFoundDevicesAction());
                await context.global.dispatchAsync(StartSmartScan());
              },
              icon: const Icon(Icons.sync),
              label: Text(t.sendTab.diagnosis.rescan),
            ),
          ),
      ],
    );
  }
}

/// The layered failure reason of a finished scan without devices:
/// a title, the actionable advice and the raw detail of the failed layer.
class _Advice extends StatelessWidget {
  final DiscoveryFailureLayer layer;
  final DiscoveryDiagnosisState diagnosis;
  final int port;

  const _Advice({
    required this.layer,
    required this.diagnosis,
    required this.port,
  });

  @override
  Widget build(BuildContext context) {
    final diagnostics = diagnosis.isolateDiagnostics;
    final (title, advice, detail) = switch (layer) {
      DiscoveryFailureLayer.noInterface => (
        t.sendTab.diagnosis.noInterface.title,
        t.sendTab.diagnosis.noInterface.advice,
        null as String?,
      ),
      DiscoveryFailureLayer.multicastUnavailable => (
        t.sendTab.diagnosis.multicastUnavailable.title,
        t.sendTab.diagnosis.multicastUnavailable.advice(port: port),
        diagnostics?.multicastError == null ? null : t.sendTab.diagnosis.multicastUnavailable.reason(reason: diagnostics!.multicastError!),
      ),
      DiscoveryFailureLayer.scanNoResult => (
        t.sendTab.diagnosis.scanNoResult.title,
        t.sendTab.diagnosis.scanNoResult.advice,
        diagnostics == null
            ? null
            : t.sendTab.diagnosis.scanNoResult.detail(
                announcements: diagnostics.announcementsSent,
                scans: diagnostics.subnetScansRequested + diagnostics.stagedScansRequested,
              ),
      ),
    };

    return Column(
      children: [
        Text(title, style: Theme.of(context).textTheme.titleSmall, textAlign: TextAlign.center),
        const SizedBox(height: 5),
        Text(
          advice,
          style: const TextStyle(color: Colors.grey),
          textAlign: TextAlign.center,
        ),
        if (detail != null)
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              detail,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }
}
