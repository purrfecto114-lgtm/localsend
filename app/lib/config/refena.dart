import 'package:localsend_app/provider/file_transfer_provider.dart';
import 'package:localsend_app/provider/local_ip_provider.dart';
import 'package:localsend_app/provider/logging/discovery_logs_provider.dart';
import 'package:logging/logging.dart';
import 'package:refena_flutter/refena_flutter.dart';
import 'package:refena_inspector_client/refena_inspector_client.dart';

final _logger = Logger('Refena');

class CustomRefenaObserver extends RefenaMultiObserver {
  CustomRefenaObserver()
    : super(
        observers: [
          RefenaDebugObserver(
            onLine: (line) => _logger.info(line),
            exclude: _exclude,
          ),
          RefenaTracingObserver(
            limit: 100,
            exclude: _exclude,
          ),
          RefenaInspectorObserver(),
        ],
      );
}

/// Refena 3.5.0 only invokes provider-level `onChanged` callbacks when the
/// container has at least one observer (BaseNotifier._setState gates
/// `_onChangedListener` on `_observer != null`). The observer list used to
/// be empty outside debug mode, which silently disabled the settings sync
/// (`IsolateSyncSettingsAction`) and the discovery restart in release and
/// profile builds. This no-op observer keeps `onChanged` alive there
/// without adding any logging overhead.
class OnChangeEnablingObserver extends RefenaObserver {
  @override
  void handleEvent(RefenaEvent event) {}
}

bool _exclude(RefenaEvent event) {
  return switch (event) {
    ChangeEvent() => event.notifier is DiscoveryLogger || event.notifier is LocalIpService || event.notifier is FileTransferNotifier,
    ActionDispatchedEvent() => event.action.runtimeType.toString() == 'FetchLocalIpAction',
    ActionFinishedEvent() => event.action.runtimeType.toString() == 'FetchLocalIpAction',
    _ => false,
  };
}
