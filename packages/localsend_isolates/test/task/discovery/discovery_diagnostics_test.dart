import 'dart:async';
import 'dart:isolate';

import 'package:flutter_test/flutter_test.dart';
import 'package:localsend_isolates/isolate.dart';
import 'package:localsend_isolates/model/device.dart';
import 'package:localsend_isolates/model/device_info_result.dart';
import 'package:localsend_isolates/model/discovery_diagnostics.dart';
import 'package:localsend_isolates/model/dto/multicast_dto.dart';
import 'package:localsend_isolates/model/stored_security_context.dart';
import 'package:localsend_isolates/rust/api/discovery.dart' as rust_discovery;
import 'package:localsend_isolates/rust/api/model.dart' as rust_model;
import 'package:localsend_isolates/rust/frb_generated.dart';
import 'package:localsend_isolates/src/isolate/child/discovery_isolate.dart';
import 'package:localsend_isolates/src/task/discovery/discovery.dart';
import 'package:refena_flutter/refena_flutter.dart';
import 'package:typed_isolates/typed_isolates.dart';

/// Unit tests of the layered no-devices diagnosis:
/// - the pull-based diagnostics task protocol ([DiscoveryDiagnosticsTask])
///   without spawning an isolate (stubbed [DiscoveryService]),
/// - the parent-side [IsolateDiscoveryDiagnosticsAction] against a
///   scripted connector,
/// - the [DiscoveryService] counters and multicast error bookkeeping with
///   the Rust layer mocked ([RustLib.initMock], fake [rust_discovery.RsDiscovery]).
void main() {
  setUpAll(() {
    RustLib.initMock(api: rustApi);
  });

  final canned = DiscoveryDiagnostics(
    running: true,
    multicastError: 'No network interface available for multicast on port 53317',
    boundAt: DateTime.fromMillisecondsSinceEpoch(1000),
    announcementsSent: 3,
    subnetScansRequested: 2,
    stagedScansRequested: 1,
    unexpectedRestarts: 0,
    deviceConfirmations: 4,
  );

  group('handleDiscoveryTask', () {
    test('a diagnostics task is answered with exactly one event and one done', () async {
      final container = RefenaContainer(
        overrides: [
          discoveryProvider.overrideWithBuilder((ref) => _StubDiscoveryService(ref, canned)),
        ],
      );
      final results = <IsolateTaskStreamResult<DiscoveryResult>>[];

      await handleDiscoveryTask(
        container,
        IsolateTask(id: 42, data: DiscoveryDiagnosticsTask()),
        results.add,
      );

      expect(results, hasLength(2));
      expect(results.first.id, 42);
      expect(results.first.done, isFalse);
      final data = results.first.data;
      expect(data, isA<DiscoveryDiagnosticsResult>());
      expect((data as DiscoveryDiagnosticsResult).diagnostics.running, isTrue);
      expect(data.diagnostics.multicastError, canned.multicastError);
      expect(results.last.id, 42);
      expect(results.last.done, isTrue);
      expect(results.last.data, isNull);
    });
  });

  group('IsolateDiscoveryDiagnosticsAction', () {
    test('pulls the diagnostics through the isolate protocol', () async {
      final connector = _ScriptedDiscoveryConnector(canned);
      final container = RefenaContainer(
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

      final result = await container.redux(parentIsolateProvider).dispatchAsyncTakeResult(IsolateDiscoveryDiagnosticsAction());

      expect(result.running, isTrue);
      expect(result.multicastError, canned.multicastError);
      expect(result.announcementsSent, 3);
      expect(result.deviceConfirmations, 4);

      // Exactly one task was sent to the isolate, and it was the pull-based
      // diagnostics task (not mixed into the listen stream).
      expect(connector.sent, hasLength(1));
      expect(connector.sent.single.data?.data, isA<DiscoveryDiagnosticsTask>());
    });

    test('throws when the discovery isolate is not initialized', () async {
      final container = RefenaContainer(
        overrides: [
          parentIsolateProvider.overrideWithNotifier(
            (ref) => IsolateController(
              initialState: ParentIsolateState(
                syncState: _syncState(),
                discovery: null,
                httpUpload: null,
                httpServer: null,
              ),
            ),
          ),
        ],
      );

      await expectLater(
        container.redux(parentIsolateProvider).dispatchAsyncTakeResult(IsolateDiscoveryDiagnosticsAction()),
        throwsStateError,
      );
    });
  });

  group('DiscoveryService.diagnostics', () {
    test('reports not running and no error before the listener started', () async {
      final container = RefenaContainer(
        overrides: [
          syncProvider.overrideWithNotifier((ref) => SyncService(initial: _syncState())),
        ],
      );
      final service = container.read(discoveryProvider);

      final diagnostics = await service.diagnostics();

      expect(diagnostics.running, isFalse);
      expect(diagnostics.multicastError, isNull);
      expect(diagnostics.boundAt, isNull);
      expect(diagnostics.announcementsSent, 0);
      expect(diagnostics.subnetScansRequested, 0);
      expect(diagnostics.stagedScansRequested, 0);
      expect(diagnostics.unexpectedRestarts, 0);
      expect(diagnostics.deviceConfirmations, 0);
    });

    test('reports the live bind state, the multicast error and the counters', () async {
      final fake = _FakeRsDiscovery(multicastError: 'No network interface available for multicast on port 53317');
      final container = _serviceContainer([fake]);
      final service = container.read(discoveryProvider);
      service.startListener().listen((_) {});

      final diagnostics = await _until(
        () => service.diagnostics(),
        (d) => d.running,
      );

      expect(diagnostics.multicastError, 'No network interface available for multicast on port 53317');
      expect(diagnostics.boundAt, isNotNull);
      // The listener announces once per successful bind.
      expect(diagnostics.announcementsSent, 1);
      expect(diagnostics.unexpectedRestarts, 0);

      // A pull without a multicast error reports null and clears the cache.
      fake.multicastErrorOverride = null;
      final cleared = await service.diagnostics();
      expect(cleared.multicastError, isNull);
    });

    test('counts announcements, scans and confirmations', () async {
      final fake = _FakeRsDiscovery();
      final container = _serviceContainer([fake]);
      final service = container.read(discoveryProvider);
      service.startListener().listen((_) {});
      await _until(() => service.diagnostics(), (d) => d.running);

      fake.emit(_storedDevice('a'));
      fake.emit(_storedDevice('b'));
      await service.sendAnnouncement();
      await service.scanSubnet(networkInterface: '192.168.1.5', port: 53317, https: true);
      await service.discoverStaged(
        favorites: [('192.168.1.99', 53317)],
        networkInterfaces: ['192.168.1.5'],
        port: 53317,
        https: true,
        grace: const Duration(milliseconds: 1),
      );

      final diagnostics = await _until(
        () => service.diagnostics(),
        (d) => d.deviceConfirmations == 2,
      );
      expect(diagnostics.announcementsSent, 2); // bind announce + manual one
      expect(diagnostics.subnetScansRequested, 1);
      expect(diagnostics.stagedScansRequested, 1);
      expect(diagnostics.unexpectedRestarts, 0);
      expect(diagnostics.multicastError, isNull);
    });

    test('an unexpected stream end is counted and reported until the rebind', () async {
      final first = _FakeRsDiscovery();
      final second = _FakeRsDiscovery();
      final container = _serviceContainer([first, second]);
      final service = container.read(discoveryProvider);
      service.startListener().listen((_) {});
      await _until(() => service.diagnostics(), (d) => d.running);

      // The Rust side stops the discovery without a restart request, like
      // a permanent multicast failure does.
      await first.stop();

      final stopped = await _until(
        () => service.diagnostics(),
        (d) => !d.running,
      );
      expect(stopped.unexpectedRestarts, 1);
      expect(stopped.multicastError, contains('Multicast sockets failed'));

      // After the backoff the service rebinds and the error is refreshed
      // from the new binding (which has none).
      final rebound = await _until(
        () => service.diagnostics(),
        (d) => d.running,
        timeout: const Duration(seconds: 4),
      );
      expect(rebound.unexpectedRestarts, 1);
      expect(rebound.multicastError, isNull);
    }, timeout: const Timeout(Duration(seconds: 10)));
  });
}

RefenaContainer _serviceContainer(List<_FakeRsDiscovery> discoveries) {
  rustApi.reset(discoveries);
  return RefenaContainer(
    overrides: [
      syncProvider.overrideWithNotifier((ref) => SyncService(initial: _syncState())),
    ],
  );
}

/// Polls [probe] until [check] accepts its value.
Future<T> _until<T>(
  Future<T> Function() probe,
  bool Function(T) check, {
  Duration timeout = const Duration(seconds: 2),
}) async {
  final deadline = DateTime.now().add(timeout);
  while (true) {
    final value = await probe();
    if (check(value)) {
      return value;
    }
    if (DateTime.now().isAfter(deadline)) {
      fail('Condition not met within $timeout (last value: $value)');
    }
    await Future<void>.delayed(const Duration(milliseconds: 10));
  }
}

rust_discovery.RsStoredDevice _storedDevice(String fingerprint) {
  return rust_discovery.RsStoredDevice(
    alias: 'alias-$fingerprint',
    version: '2.0',
    deviceModel: null,
    deviceType: null,
    fingerprint: fingerprint,
    download: false,
    channels: [
      const rust_discovery.RsDeviceChannel(host: '192.168.1.10', port: 53317, protocol: rust_model.ProtocolType.https),
    ],
  );
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

/// A [DiscoveryService] that answers [DiscoveryService.diagnostics] with a
/// canned snapshot; the handler test does not need the Rust layer.
class _StubDiscoveryService extends DiscoveryService {
  _StubDiscoveryService(super.ref, this._canned);

  final DiscoveryDiagnostics _canned;

  @override
  Future<DiscoveryDiagnostics> diagnostics() async => _canned;
}

/// Answers every [DiscoveryDiagnosticsTask] with [diagnostics], like the
/// discovery isolate would.
class _ScriptedDiscoveryConnector
    implements IsolateConnector<IsolateTaskStreamResult<DiscoveryResult>, SendToIsolateData<IsolateTask<DiscoveryTask>>> {
  _ScriptedDiscoveryConnector(this.diagnostics);

  final DiscoveryDiagnostics diagnostics;
  final _responses = StreamController<IsolateTaskStreamResult<DiscoveryResult>>.broadcast();
  final sent = <SendToIsolateData<IsolateTask<DiscoveryTask>>>[];

  @override
  void sendToIsolate(SendToIsolateData<IsolateTask<DiscoveryTask>> message) {
    sent.add(message);
    final task = message.data;
    if (task != null && task.data is DiscoveryDiagnosticsTask) {
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

/// The Rust api mock, installed once; the scripted discoveries are swapped
/// per test via [reset].
final rustApi = _ScriptedRustApi();

class _ScriptedRustApi implements RustLibApi {
  final List<_FakeRsDiscovery> _discoveries = [];
  int _calls = 0;

  void reset(List<_FakeRsDiscovery> discoveries) {
    _discoveries
      ..clear()
      ..addAll(discoveries);
    _calls = 0;
  }

  @override
  Future<rust_discovery.RsDiscovery> crateApiDiscoveryStartDiscovery({
    required String group,
    required int port,
    List<String>? networkWhitelist,
    List<String>? networkBlacklist,
    required String alias,
    required String version,
    String? deviceModel,
    rust_model.DeviceType? deviceType,
    required String fingerprint,
    required rust_model.ProtocolType protocol,
    required bool download,
    required String certPem,
    required String privateKeyPem,
    required BigInt timeoutMs,
  }) async {
    if (_calls >= _discoveries.length) {
      throw StateError('No scripted discovery left (call ${_calls + 1})');
    }
    return _discoveries[_calls++];
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnsupportedError('Not mocked: ${invocation.memberName}');
}

/// A fake [rust_discovery.RsDiscovery]: the listen stream never ends on its
/// own, [stop] ends it (like the Rust side does on a permanent multicast
/// failure) and every method just counts.
class _FakeRsDiscovery implements rust_discovery.RsDiscovery {
  _FakeRsDiscovery({String? multicastError}) : multicastErrorOverride = multicastError;

  String? multicastErrorOverride;
  StreamController<rust_discovery.RsStoredDevice>? _listenController;
  int announcements = 0;
  int subnetScans = 0;
  int stagedScans = 0;

  @override
  Future<String?> multicastError() async => multicastErrorOverride;

  @override
  Future<void> announce() async => announcements++;

  @override
  Stream<rust_discovery.RsStoredDevice> listen() {
    _listenController ??= StreamController<rust_discovery.RsStoredDevice>();
    return _listenController!.stream;
  }

  void emit(rust_discovery.RsStoredDevice device) {
    _listenController?.add(device);
  }

  @override
  Future<void> stop() async {
    await _listenController?.close();
    _listenController = null;
  }

  @override
  Future<void> scanSubnet({required String interfaceIp, required int port, required rust_model.ProtocolType protocol}) async => subnetScans++;

  @override
  Future<void> discoverStaged({
    required List<rust_discovery.RsDeviceChannel> channels,
    required List<String> interfaceIps,
    required int port,
    required rust_model.ProtocolType protocol,
    required BigInt graceMs,
  }) async => stagedScans++;

  @override
  Future<void> setAnswerAnnouncements({required bool answer}) async {}

  @override
  Future<void> addDevice({required rust_discovery.RsDiscoveredDevice device}) async {}

  @override
  Future<List<rust_discovery.RsDeviceLog>> deviceLogs({required String fingerprint}) async => [];

  @override
  void dispose() {}

  @override
  bool get isDisposed => false;
}
