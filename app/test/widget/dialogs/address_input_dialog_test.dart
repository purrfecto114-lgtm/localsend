import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:localsend_app/gen/strings.g.dart';
import 'package:localsend_app/model/persistence/color_mode.dart';
import 'package:localsend_app/model/persistence/quick_save_mode.dart';
import 'package:localsend_app/model/send_mode.dart';
import 'package:localsend_app/model/state/network_state.dart';
import 'package:localsend_app/provider/device_info_provider.dart';
import 'package:localsend_app/provider/http_provider.dart';
import 'package:localsend_app/provider/local_ip_provider.dart';
import 'package:localsend_app/provider/persistence_provider.dart';
import 'package:localsend_app/provider/settings_provider.dart';
import 'package:localsend_app/widget/dialogs/address_input_dialog.dart';
import 'package:localsend_isolates/isolate.dart';
import 'package:localsend_isolates/model/device.dart';
import 'package:localsend_isolates/model/device_info_result.dart';
import 'package:localsend_isolates/model/dto/multicast_dto.dart';
import 'package:localsend_isolates/model/stored_security_context.dart';
import 'package:localsend_isolates/rust/api/http.dart';
import 'package:localsend_isolates/rust/api/model.dart' as rust_model show ProtocolType, RegisterDto;
import 'package:refena_flutter/refena_flutter.dart';

/// Widget tests for the hashtag mode of the address input dialog
/// (REVIEW-FIX F4): an empty candidate list must be explained to the user
/// instead of silently returning to the idle state.
void main() {
  setUp(() => LocaleSettings.setLocale(AppLocale.en));

  Future<void> pumpDialog(
    WidgetTester tester, {
    required List<String> localIps,
    _FakeDiscoveryClient? client,
  }) async {
    await tester.pumpWidget(
      RefenaScope(
        overrides: [
          persistenceProvider.overrideWithValue(_persistence()),
          localIpProvider.overrideWithNotifier(
            (ref) => _StaticLocalIpService(NetworkState(localIps: localIps, initialized: true)),
          ),
          if (client != null) ...[
            deviceFullInfoProvider.overrideWithBuilder(
              (ref) => Device(
                signalingId: null,
                ip: localIps.isEmpty ? null : localIps.first,
                version: '2.0',
                port: 53317,
                https: true,
                fingerprint: 'fingerprint',
                alias: 'alias',
                deviceModel: null,
                deviceType: DeviceType.headless,
                download: false,
                channels: const [],
              ),
            ),
            httpProvider.overrideWithBuilder(
              (ref) => HttpClientCollection(privateKey: '', certificate: '', discovery: client),
            ),
          ],
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: Center(child: AddressInputDialog()),
          ),
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('explains when the hashtag cannot be expanded (IPv6-only network)', (tester) async {
    await pumpDialog(tester, localIps: ['fe80::1']);

    await tester.enterText(find.byType(TextFormField), '123');
    await tester.pump();
    await tester.tap(find.text(t.general.confirm));
    await tester.pumpAndSettle();

    // The hint explains why nothing happened ...
    expect(find.text(t.dialogs.addressInput.noHashtagCandidates), findsOneWidget);

    // ... and switching to the IP mode clears it again.
    await tester.tap(find.text(t.dialogs.addressInput.ip));
    await tester.pumpAndSettle();
    expect(find.text(t.dialogs.addressInput.noHashtagCandidates), findsNothing);
  });

  testWidgets('tries the expanded hashtag when an IPv4 prefix exists', (tester) async {
    final client = _FakeDiscoveryClient(({
      required protocol,
      required ip,
      required port,
      required payload,
    }) async {
      throw 'Connection refused (os error 111)';
    });
    await pumpDialog(tester, localIps: ['192.168.2.10'], client: client);

    await tester.enterText(find.byType(TextFormField), '123');
    await tester.pump();
    await tester.tap(find.text(t.general.confirm));
    await tester.pumpAndSettle();

    // No hint: the hashtag was expanded into a candidate and tried.
    expect(find.text(t.dialogs.addressInput.noHashtagCandidates), findsNothing);
    expect(client.registerCalls, hasLength(1));
    expect(client.registerCalls.single.ip, '192.168.2.123');
    // The failure is reported through the friendly error mapping.
    expect(find.text(t.dialogs.connectionError.refused.message), findsOneWidget);
  });
}

/// A [LocalIpService] with a fixed state: no fetch is started, so the
/// network never reaches the platform or the Rust layer in tests.
class _StaticLocalIpService extends LocalIpService {
  _StaticLocalIpService(NetworkState state)
    : _state = state,
      super(
        SettingsService(_persistence()),
        IsolateController(initialState: ParentIsolateState.initial(_syncState())),
      );

  final NetworkState _state;

  @override
  NetworkState init() => _state;

  @override
  get initialAction => null;
}

/// A fake [RsHttpClient] that only implements [RsHttpClient.register].
class _FakeDiscoveryClient implements RsHttpClient {
  _FakeDiscoveryClient(this._behavior);

  final Future<ResultWithPublicKeyRegisterResponseDto> Function({
    required rust_model.ProtocolType protocol,
    required String ip,
    required int port,
    required rust_model.RegisterDto payload,
  })
  _behavior;

  final registerCalls = <({String ip, int port})>[];

  @override
  Future<ResultWithPublicKeyRegisterResponseDto> register({
    required rust_model.ProtocolType protocol,
    required String ip,
    required int port,
    required rust_model.RegisterDto payload,
  }) {
    registerCalls.add((ip: ip, port: port));
    return _behavior(protocol: protocol, ip: ip, port: port, payload: payload);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError('${invocation.memberName} must not be called in this test');
}

class _FakePersistence implements PersistenceService {
  final Map<Symbol, Object?> stubs;

  _FakePersistence(this.stubs);

  @override
  dynamic noSuchMethod(Invocation i) {
    if (stubs.containsKey(i.memberName)) return stubs[i.memberName];
    if (i.memberName.toString().contains('set')) {
      return Future<void>.value();
    }
    return super.noSuchMethod(i);
  }
}

_FakePersistence _persistence() => _FakePersistence({
  #getShowToken: 'token',
  #getAlias: 'alias',
  #getTheme: ThemeMode.system,
  #getColorMode: ColorMode.system,
  #getCustomColor: const Color(0xFF000000),
  #getLocale: null,
  #getPort: 53317,
  #getNetworkWhitelist: null,
  #getNetworkBlacklist: null,
  #getMulticastGroup: '224.0.0.167',
  #getDestination: null,
  #isSaveToGallery: false,
  #isSaveToHistory: false,
  #getQuickSave: QuickSaveMode.off,
  #getReceivePin: null,
  #isAutoFinish: false,
  #isMinimizeToTray: false,
  #isHttps: true,
  #getSendMode: SendMode.single,
  #getSaveWindowPlacement: true,
  #getAlwaysOnTop: false,
  #getEnableAnimations: true,
  #getDeviceType: null,
  #getDeviceModel: null,
  #getShareViaLinkAutoAccept: false,
  #getReceiveViaLinkAutoAccept: false,
  #getCreateChecksums: true,
  #getVerifyChecksums: true,
  #getDeleteSourceAfterSend: false,
  #getDiscoveryTimeout: 3,
  #getMaxInterfaces: 5,
  #getIncludeVpnInterfaces: false,
  #getBleDiscoveryEnabled: false,
  #getAdvancedSettingsEnabled: false,
});

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
