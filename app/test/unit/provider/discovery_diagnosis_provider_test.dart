import 'dart:async';
import 'dart:isolate';

import 'package:localsend_app/provider/network/discovery_diagnosis_provider.dart';
import 'package:localsend_isolates/isolate.dart';
import 'package:localsend_isolates/model/device.dart';
import 'package:localsend_isolates/model/device_info_result.dart';
import 'package:localsend_isolates/model/discovery_diagnostics.dart';
import 'package:localsend_isolates/model/dto/multicast_dto.dart';
import 'package:localsend_isolates/model/stored_security_context.dart';
import 'package:refena_flutter/refena_flutter.dart';
import 'package:test/test.dart';
import 'package:typed_isolates/typed_isolates.dart';

void main() {
  group('judgeDiscoveryFailure', () {
    const ips = ['192.168.1.5'];

    test('returns null before any scan completed', () {
      expect(
        judgeDiscoveryFailure(localIps: ips, diagnostics: null, scanCompleted: false, devicesFound: false),
        isNull,
      );
    });

    test('returns null when devices were found', () {
      expect(
        judgeDiscoveryFailure(
          localIps: ips,
          diagnostics: _diagnostics(running: true),
          scanCompleted: true,
          devicesFound: true,
        ),
        isNull,
      );
    });

    test('layer 1: no usable network interface', () {
      // Even a perfectly healthy discovery cannot find anything without
      // an interface to talk over.
      expect(
        judgeDiscoveryFailure(
          localIps: [],
          diagnostics: _diagnostics(running: true),
          scanCompleted: true,
          devicesFound: false,
        ),
        DiscoveryFailureLayer.noInterface,
      );
    });

    test('returns null when the isolate diagnostics are unavailable', () {
      // Without the isolate-side view, layers 2 and 3 cannot be
      // distinguished; showing no diagnosis is better than a wrong one.
      expect(
        judgeDiscoveryFailure(localIps: ips, diagnostics: null, scanCompleted: true, devicesFound: false),
        isNull,
      );
    });

    test('layer 2: the discovery is not running', () {
      expect(
        judgeDiscoveryFailure(
          localIps: ips,
          diagnostics: _diagnostics(running: false),
          scanCompleted: true,
          devicesFound: false,
        ),
        DiscoveryFailureLayer.multicastUnavailable,
      );
    });

    test('layer 2: the multicast join failed', () {
      expect(
        judgeDiscoveryFailure(
          localIps: ips,
          diagnostics: _diagnostics(running: true, multicastError: 'No network interface available for multicast on port 53317'),
          scanCompleted: true,
          devicesFound: false,
        ),
        DiscoveryFailureLayer.multicastUnavailable,
      );
    });

    test('layer 3: healthy discovery but no device answered', () {
      expect(
        judgeDiscoveryFailure(
          localIps: ips,
          diagnostics: _diagnostics(running: true),
          scanCompleted: true,
          devicesFound: false,
        ),
        DiscoveryFailureLayer.scanNoResult,
      );
    });
  });

  group('DiscoveryDiagnosisService', () {
    test('starts undiagnosed', () {
      final harness = _Harness(null);
      expect(harness.container.read(discoveryDiagnosisProvider).scanCompleted, isFalse);
      expect(harness.container.read(discoveryDiagnosisProvider).failureLayer, isNull);
    });

    test('scanFinished stores the isolate diagnostics and the layer', () async {
      final diagnostics = _diagnostics(running: true);
      final harness = _Harness(diagnostics);
      final service = harness.container.notifier(discoveryDiagnosisProvider);

      await service.scanFinished(localIps: ['192.168.1.5'], devicesFound: false);

      final state = harness.container.read(discoveryDiagnosisProvider);
      expect(state.scanCompleted, isTrue);
      expect(state.lastScanFinishedAt, isNotNull);
      expect(state.isolateDiagnostics, same(diagnostics));
      expect(state.failureLayer, DiscoveryFailureLayer.scanNoResult);

      // The diagnosis pulled the isolate exactly once.
      expect(harness.connector?.sent, hasLength(1));
      expect(harness.connector?.sent.single.data?.data, isA<DiscoveryDiagnosticsTask>());
    });

    test('scanFinished judges layer 1 even when the isolate is healthy', () async {
      // No interfaces: layer 1 wins over a perfectly healthy discovery.
      final diagnostics = _diagnostics(running: true);
      final harness = _Harness(diagnostics);
      final service = harness.container.notifier(discoveryDiagnosisProvider);

      await service.scanFinished(localIps: [], devicesFound: false);

      expect(harness.container.read(discoveryDiagnosisProvider).failureLayer, DiscoveryFailureLayer.noInterface);
    });

    test('scanFinished with found devices keeps no failure layer', () async {
      final harness = _Harness(_diagnostics(running: true));
      final service = harness.container.notifier(discoveryDiagnosisProvider);

      await service.scanFinished(localIps: ['192.168.1.5'], devicesFound: true);

      expect(harness.container.read(discoveryDiagnosisProvider).failureLayer, isNull);
    });

    test('scanStarted voids the previous diagnosis', () async {
      final harness = _Harness(_diagnostics(running: false));
      final service = harness.container.notifier(discoveryDiagnosisProvider);

      await service.scanFinished(localIps: ['192.168.1.5'], devicesFound: false);
      expect(harness.container.read(discoveryDiagnosisProvider).failureLayer, DiscoveryFailureLayer.multicastUnavailable);

      service.scanStarted();
      final state = harness.container.read(discoveryDiagnosisProvider);
      expect(state.scanCompleted, isFalse);
      expect(state.failureLayer, isNull);
      expect(state.isolateDiagnostics, isNull);
    });

    test('scanFinished tolerates a missing discovery isolate', () async {
      final harness = _Harness(null);
      final service = harness.container.notifier(discoveryDiagnosisProvider);

      await service.scanFinished(localIps: ['192.168.1.5'], devicesFound: false);

      final state = harness.container.read(discoveryDiagnosisProvider);
      expect(state.scanCompleted, isTrue);
      expect(state.isolateDiagnostics, isNull);
      expect(state.failureLayer, isNull);
    });
  });
}

DiscoveryDiagnostics _diagnostics({required bool running, String? multicastError}) {
  return DiscoveryDiagnostics(
    running: running,
    multicastError: multicastError,
    boundAt: DateTime.fromMillisecondsSinceEpoch(1000),
    announcementsSent: 1,
    subnetScansRequested: 1,
    stagedScansRequested: 1,
    unexpectedRestarts: 0,
    deviceConfirmations: 0,
  );
}

class _Harness {
  _Harness(DiscoveryDiagnostics? diagnostics) {
    connector = diagnostics == null ? null : _ScriptedDiscoveryConnector(diagnostics);
    container = RefenaContainer(
      overrides: [
        parentIsolateProvider.overrideWithNotifier(
          (ref) => IsolateController(
            initialState: ParentIsolateState(
              syncState: _syncState(),
              discovery: connector,
              httpUpload: null,
              httpServer: null,
            ),
          ),
        ),
      ],
    );
  }

  /// The connector installed in the container state; null simulates a
  /// missing discovery isolate.
  late final _ScriptedDiscoveryConnector? connector;

  late final RefenaContainer container;
}

SyncState _syncState() => SyncState(
  rootIsolateToken: Object(),
  securityContext: StoredSecurityContext(privateKey: '', publicKey: '', certificate: '', certificateHash: ''),
  deviceInfo: DeviceInfoResult(deviceType: DeviceType.headless, deviceModel: null, androidSdkInt: null),
  alias: 'alias',
  port: 53317,
  networkWhitelist: null,
  networkBlacklist: null,
  protocol: ProtocolType.https,
  multicastGroup: '224.0.0.167',
  discoveryTimeout: 3,
  serverRunning: false,
  download: false,
);

/// Answers every [DiscoveryDiagnosticsTask] with [diagnostics], like the
/// discovery isolate would; records everything sent to it.
class _ScriptedDiscoveryConnector
    implements IsolateConnector<IsolateTaskStreamResult<DiscoveryResult>, SendToIsolateData<IsolateTask<DiscoveryTask>>> {
  _ScriptedDiscoveryConnector(this.diagnostics);

  final DiscoveryDiagnostics? diagnostics;
  final _responses = StreamController<IsolateTaskStreamResult<DiscoveryResult>>.broadcast();
  final sent = <SendToIsolateData<IsolateTask<DiscoveryTask>>>[];

  @override
  void sendToIsolate(SendToIsolateData<IsolateTask<DiscoveryTask>> message) {
    sent.add(message);
    final task = message.data;
    final diagnostics = this.diagnostics;
    if (task != null && task.data is DiscoveryDiagnosticsTask && diagnostics != null) {
      _responses.add(
        IsolateTaskStreamResult.event(
          id: task.id,
          data: DiscoveryDiagnosticsResult(diagnostics: diagnostics),
        ),
      );
      _responses.add(IsolateTaskStreamResult.done(id: task.id));
    }
  }

  @override
  Stream<IsolateTaskStreamResult<DiscoveryResult>> get receiveFromIsolate => _responses.stream;

  @override
  Isolate get isolate => throw UnimplementedError();
}
