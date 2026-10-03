import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:localsend_app/gen/strings.g.dart';
import 'package:localsend_app/model/persistence/color_mode.dart';
import 'package:localsend_app/model/persistence/quick_save_mode.dart';
import 'package:localsend_app/model/send_mode.dart';
import 'package:localsend_app/provider/device_info_provider.dart';
import 'package:localsend_app/provider/http_provider.dart';
import 'package:localsend_app/provider/persistence_provider.dart';
import 'package:localsend_app/widget/dialogs/favorite_edit_dialog.dart';
import 'package:localsend_isolates/model/device.dart';
import 'package:localsend_isolates/rust/api/http.dart';
import 'package:localsend_isolates/rust/api/model.dart' as rust_model show ProtocolType, RegisterDto;
import 'package:refena_flutter/refena_flutter.dart';

/// Widget tests for the favorite edit dialog's register flow: the friendly
/// error mapping, the retry button and the IP input validation (REVIEW-FIX
/// F1). The register request is faked; no Rust code is involved.
void main() {
  setUp(() => LocaleSettings.setLocale(AppLocale.en));

  Future<void> pumpDialog(WidgetTester tester, _FakeDiscoveryClient client) async {
    await tester.pumpWidget(
      RefenaScope(
        overrides: [
          persistenceProvider.overrideWithValue(_persistence()),
          deviceFullInfoProvider.overrideWithBuilder(
            (ref) => Device(
              signalingId: null,
              ip: '192.168.2.10',
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
        child: const MaterialApp(
          home: Scaffold(
            body: Center(child: FavoriteEditDialog()),
          ),
        ),
      ),
    );
    // Let the post-frame ensureRef callback initialize the settings-backed
    // port prefill before interacting with the dialog.
    await tester.pump();
  }

  Future<void> enterAddress(WidgetTester tester, String ip) async {
    // The fields appear in the order: alias, ip, port.
    await tester.enterText(find.byType(TextFormField).at(1), ip);
    await tester.enterText(find.byType(TextFormField).at(2), '53317');
    // Let onChanged-setState rebuild before interacting further.
    await tester.pump();
  }

  testWidgets('shows a friendly error message when the register probe fails', (tester) async {
    final client = _FakeDiscoveryClient(({
      required protocol,
      required ip,
      required port,
      required payload,
    }) async {
      throw 'RhttpTimeoutException: Request timed out. URL: https://192.168.1.5:53317/api/localsend/v2/register';
    });
    await pumpDialog(tester, client);
    await enterAddress(tester, '192.168.1.5');

    await tester.tap(find.text(t.general.confirm));
    await tester.pumpAndSettle();

    // The inline error is the mapped, friendly message ...
    expect(find.text(t.dialogs.connectionError.timeout.message), findsOneWidget);
    // ... and not the raw exception (that stays inside the details dialog).
    expect(find.textContaining('RhttpTimeoutException'), findsNothing);
    expect(client.registerCalls, hasLength(1));
    expect(client.registerCalls.single.ip, '192.168.1.5');
    expect(client.registerCalls.single.port, 53317);
  });

  testWidgets('the retry button of the error dialog re-runs the register request', (tester) async {
    final client = _FakeDiscoveryClient(({
      required protocol,
      required ip,
      required port,
      required payload,
    }) async {
      throw 'RhttpTimeoutException: Request timed out. URL: https://192.168.1.5:53317/api/localsend/v2/register';
    });
    await pumpDialog(tester, client);
    await enterAddress(tester, '192.168.1.5');

    await tester.tap(find.text(t.general.confirm));
    await tester.pumpAndSettle();
    expect(client.registerCalls, hasLength(1));

    // Open the error details dialog.
    await tester.tap(find.byIcon(Icons.info));
    await tester.pumpAndSettle();
    expect(find.text(t.dialogs.connectionError.title), findsOneWidget);
    // The raw error is kept selectable there for bug reports.
    expect(find.textContaining('RhttpTimeoutException'), findsOneWidget);

    await tester.tap(find.text(t.dialogs.connectionError.retry));
    await tester.pumpAndSettle();

    // The failed register request was re-run with the same parameters.
    expect(client.registerCalls, hasLength(2));
    expect(client.registerCalls.last.ip, '192.168.1.5');
    expect(client.registerCalls.last.port, 53317);
    // The details dialog is closed, the edit dialog is still open and shows
    // the error again.
    expect(find.text(t.dialogs.connectionError.title), findsNothing);
    expect(find.text(t.dialogs.favoriteEditDialog.titleAdd), findsOneWidget);
    expect(find.text(t.dialogs.connectionError.timeout.message), findsOneWidget);
  });

  testWidgets('rejects garbage input instead of sending a register request', (tester) async {
    final client = _FakeDiscoveryClient(({
      required protocol,
      required ip,
      required port,
      required payload,
    }) async {
      fail('register must not be called for invalid input');
    });
    await pumpDialog(tester, client);
    await enterAddress(tester, 'http://192.168.1.5');

    // The validation error is shown while typing ...
    expect(find.text(t.dialogs.addressInput.validation.scheme), findsOneWidget);

    // ... and the confirm button does not fire a register request.
    await tester.tap(find.text(t.general.confirm));
    await tester.pumpAndSettle();

    expect(client.registerCalls, isEmpty);
    expect(find.text(t.dialogs.addressInput.validation.scheme), findsOneWidget);
  });

  testWidgets('normalizes a bracketed IPv6 address before registering', (tester) async {
    final client = _FakeDiscoveryClient(({
      required protocol,
      required ip,
      required port,
      required payload,
    }) async {
      throw 'Connection refused (os error 111)';
    });
    await pumpDialog(tester, client);
    await enterAddress(tester, '[::1]');

    expect(find.text(t.dialogs.addressInput.validation.invalid), findsNothing);

    await tester.tap(find.text(t.general.confirm));
    await tester.pumpAndSettle();

    expect(client.registerCalls, hasLength(1));
    // The brackets are stripped by the shared manual address validator.
    expect(client.registerCalls.single.ip, '::1');
    expect(find.text(t.dialogs.connectionError.refused.message), findsOneWidget);
  });
}

/// A fake [RsHttpClient] that only implements [RsHttpClient.register];
/// every other member fails the test because the favorite dialog must not
/// call it.
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
    // All mutating methods return Future<void>; all value getters used by
    // SettingsService.init() are stubbed above (pattern copied from
    // settings_provider_test.dart).
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
  #getDiscoveryTimeout: 3,
  #getMaxInterfaces: 5,
  #getBleDiscoveryEnabled: false,
  #getAdvancedSettingsEnabled: false,
});
