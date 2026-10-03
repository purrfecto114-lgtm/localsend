import 'package:flutter/foundation.dart';
import 'package:localsend_isolates/isolate.dart';
import 'package:localsend_isolates/model/discovery_diagnostics.dart';
import 'package:logging/logging.dart';
import 'package:refena_flutter/refena_flutter.dart';

final _logger = Logger('DiscoveryDiagnosis');

/// The layer the discovery failed at, when the device list is still empty
/// after a finished scan. Ordered from the most basic precondition (a
/// connected network interface) to the deepest network issue (nobody
/// answered the announcements or the subnet scan).
enum DiscoveryFailureLayer {
  /// The device has no usable network interface: it is not connected to
  /// any network.
  noInterface,

  /// Interfaces exist, but the discovery is not running with multicast
  /// (binding the group failed), so announcements are neither sent nor
  /// heard.
  multicastUnavailable,

  /// The discovery is healthy, but neither the announcements nor the
  /// subnet scan confirmed any device.
  scanNoResult,
}

/// The diagnosis of the last finished smart scan, shown in the send tab
/// while no nearby device was found.
class DiscoveryDiagnosisState {
  /// Whether at least one scan finished since the app started.
  final bool scanCompleted;

  /// When the last scan finished.
  final DateTime? lastScanFinishedAt;

  /// The diagnostics pulled from the discovery isolate after the last scan;
  /// null when the isolate was not available.
  final DiscoveryDiagnostics? isolateDiagnostics;

  /// The layer the last finished scan failed at; null when it cannot be
  /// judged (no scan finished, devices were found, or the isolate
  /// diagnostics are unavailable while interfaces exist).
  final DiscoveryFailureLayer? failureLayer;

  const DiscoveryDiagnosisState({
    this.scanCompleted = false,
    this.lastScanFinishedAt,
    this.isolateDiagnostics,
    this.failureLayer,
  });
}

/// Caches the diagnosis of the most recent smart scan: pulls the discovery
/// diagnostics from the discovery isolate (pull-based, like the device
/// logs) and judges which discovery layer failed while the device list is
/// empty.
final discoveryDiagnosisProvider = NotifierProvider<DiscoveryDiagnosisService, DiscoveryDiagnosisState>((ref) {
  return DiscoveryDiagnosisService(
    isolateController: ref.notifier(parentIsolateProvider),
  );
});

class DiscoveryDiagnosisService extends Notifier<DiscoveryDiagnosisState> {
  final IsolateController _isolateController;

  DiscoveryDiagnosisService({
    required IsolateController isolateController,
  }) : _isolateController = isolateController;

  @override
  DiscoveryDiagnosisState init() => const DiscoveryDiagnosisState();

  /// Called when a smart scan starts: the previous diagnosis is void while
  /// scanning, so the UI does not show stale advice.
  void scanStarted() {
    state = const DiscoveryDiagnosisState();
  }

  /// Called when a smart scan finished: pulls the discovery diagnostics
  /// from the isolate and judges which layer failed.
  Future<void> scanFinished({
    required List<String> localIps,
    required bool devicesFound,
  }) async {
    final diagnostics = await _pullDiagnostics();
    state = DiscoveryDiagnosisState(
      scanCompleted: true,
      lastScanFinishedAt: DateTime.now(),
      isolateDiagnostics: diagnostics,
      failureLayer: judgeDiscoveryFailure(
        localIps: localIps,
        diagnostics: diagnostics,
        scanCompleted: true,
        devicesFound: devicesFound,
      ),
    );
  }

  Future<DiscoveryDiagnostics?> _pullDiagnostics() async {
    if (_isolateController.state.discovery == null) {
      return null;
    }
    try {
      return await ref.redux(parentIsolateProvider).dispatchAsyncTakeResult(IsolateDiscoveryDiagnosticsAction());
    } catch (e) {
      _logger.warning('Could not pull the discovery diagnostics', e);
      return null;
    }
  }
}

/// Judges which discovery layer failed after a finished scan, from the
/// data both sides can provide:
/// - [localIps]: the interfaces this device currently has (layer 1),
/// - [diagnostics]: the isolate-side bind/multicast state (layer 2),
/// - [devicesFound]: the outcome of the announcements and the subnet scan
///   (layer 3).
///
/// Returns null when no failure can be diagnosed: no scan finished yet,
/// devices were found (nothing to diagnose), or the isolate diagnostics
/// are unavailable while interfaces exist (layers 2 and 3 cannot be
/// distinguished without them).
@visibleForTesting
DiscoveryFailureLayer? judgeDiscoveryFailure({
  required List<String> localIps,
  required DiscoveryDiagnostics? diagnostics,
  required bool scanCompleted,
  required bool devicesFound,
}) {
  if (!scanCompleted || devicesFound) {
    return null;
  }
  if (localIps.isEmpty) {
    return DiscoveryFailureLayer.noInterface;
  }
  if (diagnostics == null) {
    return null;
  }
  if (!diagnostics.running || diagnostics.multicastError != null) {
    return DiscoveryFailureLayer.multicastUnavailable;
  }
  return DiscoveryFailureLayer.scanNoResult;
}
