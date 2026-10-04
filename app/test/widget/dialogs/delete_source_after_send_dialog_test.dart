import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:localsend_app/gen/strings.g.dart';
import 'package:localsend_app/model/persistence/color_mode.dart';
import 'package:localsend_app/model/persistence/quick_save_mode.dart';
import 'package:localsend_app/model/send_mode.dart';
import 'package:localsend_app/provider/persistence_provider.dart';
import 'package:localsend_app/provider/settings_provider.dart';
import 'package:localsend_app/widget/dialogs/delete_source_after_send_dialog.dart';
import 'package:refena_flutter/refena_flutter.dart';

/// Interaction tests for the confirmation dialog behind the
/// "delete source files after sending" setting: enabling is gated behind an
/// explicit confirmation, everything else keeps the setting unchanged.
void main() {
  setUp(() => LocaleSettings.setLocale(AppLocale.en));

  late _FakePersistence persistence;
  late SettingsService settings;

  Future<void> pumpToggle(WidgetTester tester, bool enabled) async {
    await tester.pumpWidget(
      RefenaScope(
        overrides: [
          persistenceProvider.overrideWithValue(persistence),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                settings = context.ref.notifier(settingsProvider);
                return TextButton(
                  onPressed: () {
                    // ignore: discarded_futures
                    DeleteSourceAfterSendDialog.handleToggle(context, settings, enabled);
                  },
                  child: Text('toggle-$enabled'),
                );
              },
            ),
          ),
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('confirming the warning enables the setting', (tester) async {
    persistence = _persistence();
    await pumpToggle(tester, true);
    await tester.tap(find.text('toggle-true'));
    await tester.pumpAndSettle();

    // The warning is shown before anything is persisted.
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text(t.dialogs.deleteSourceAfterSendDialog.title), findsOneWidget);
    expect(find.text(t.dialogs.deleteSourceAfterSendDialog.content), findsOneWidget);
    expect(persistence.calls[#setDeleteSourceAfterSend], isNull);

    await tester.tap(find.text(t.general.confirm));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
    expect(settings.state.deleteSourceAfterSend, isTrue);
    expect(persistence.calls[#setDeleteSourceAfterSend], [
      [true],
    ]);
  });

  testWidgets('canceling the warning keeps the setting off', (tester) async {
    persistence = _persistence();
    await pumpToggle(tester, true);
    await tester.tap(find.text('toggle-true'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);

    await tester.tap(find.text(t.general.cancel));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
    expect(settings.state.deleteSourceAfterSend, isFalse);
    expect(persistence.calls[#setDeleteSourceAfterSend], isNull);
  });

  testWidgets('dismissing the warning by tapping outside keeps the setting off', (tester) async {
    persistence = _persistence();
    await pumpToggle(tester, true);
    await tester.tap(find.text('toggle-true'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);

    // Tap the barrier outside the centered dialog.
    await tester.tapAt(const Offset(5, 5));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
    expect(settings.state.deleteSourceAfterSend, isFalse);
    expect(persistence.calls[#setDeleteSourceAfterSend], isNull);
  });

  testWidgets('disabling the setting needs no confirmation', (tester) async {
    persistence = _persistence();
    await pumpToggle(tester, false);
    await tester.tap(find.text('toggle-false'));
    await tester.pumpAndSettle();

    // No dialog at all: turning the destructive behavior off is safe.
    expect(find.byType(AlertDialog), findsNothing);
    expect(settings.state.deleteSourceAfterSend, isFalse);
    expect(persistence.calls[#setDeleteSourceAfterSend], [
      [false],
    ]);
  });
}

class _FakePersistence implements PersistenceService {
  final Map<Symbol, Object?> stubs;
  final Map<Symbol, List<List<Object?>>> calls = {};

  _FakePersistence(this.stubs);

  @override
  dynamic noSuchMethod(Invocation i) {
    if (stubs.containsKey(i.memberName)) return stubs[i.memberName];
    if (i.memberName.toString().contains('set')) {
      calls.putIfAbsent(i.memberName, () => []).add(i.positionalArguments);
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
  #getBleDiscoveryEnabled: false,
  #getAdvancedSettingsEnabled: false,
});
