import 'package:flutter/material.dart';
import 'package:localsend_app/gen/strings.g.dart';
import 'package:localsend_app/provider/network/discovery_diagnosis_provider.dart';

/// Whether the manual fallback guidance is useful in the given empty-list
/// situation: hidden while a scan is running and when the device has no
/// network connection at all (manual input cannot reach anything either).
bool showManualFallback({required bool scanning, required DiscoveryFailureLayer? failureLayer}) {
  return !scanning && failureLayer != DiscoveryFailureLayer.noInterface;
}

/// Guidance shown below the empty nearby-devices list: favorites and manual
/// address input keep working without discovery when IP addresses change
/// (#3319: "add the devices to favorites" / "but my ip changes").
class DiscoveryManualFallback extends StatelessWidget {
  /// Whether the guidance is shown at all.
  final bool visible;

  /// Opens the favorites dialog; reuses the send tab entry.
  final Future<void> Function(BuildContext context)? onOpenFavorites;

  /// Opens the manual address dialog; reuses the send tab entry.
  final Future<void> Function(BuildContext context)? onOpenManualAddress;

  const DiscoveryManualFallback({
    required this.visible,
    this.onOpenFavorites,
    this.onOpenManualAddress,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (!visible) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            t.sendTab.diagnosis.manualFallback.message,
            style: const TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          Center(
            child: Wrap(
              spacing: 10,
              alignment: WrapAlignment.center,
              children: [
                if (onOpenFavorites != null)
                  TextButton.icon(
                    onPressed: () async => onOpenFavorites!(context),
                    icon: const Icon(Icons.favorite),
                    label: Text(t.sendTab.diagnosis.manualFallback.openFavorites),
                  ),
                if (onOpenManualAddress != null)
                  TextButton.icon(
                    onPressed: () async => onOpenManualAddress!(context),
                    icon: const Icon(Icons.ads_click),
                    label: Text(t.sendTab.diagnosis.manualFallback.manualInput),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
