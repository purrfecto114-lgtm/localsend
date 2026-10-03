import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:localsend_app/gen/strings.g.dart';
import 'package:localsend_app/provider/network/discovery_diagnosis_provider.dart';
import 'package:localsend_app/widget/discovery_manual_fallback.dart';

void main() {
  setUp(() => LocaleSettings.setLocale(AppLocale.en));

  Future<void> pumpFallback(WidgetTester tester, DiscoveryManualFallback fallback) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: fallback),
      ),
    );
  }

  group('showManualFallback', () {
    test('hidden while a scan is running', () {
      expect(
        showManualFallback(scanning: true, failureLayer: DiscoveryFailureLayer.scanNoResult),
        isFalse,
      );
      expect(
        showManualFallback(scanning: true, failureLayer: null),
        isFalse,
      );
    });

    test('hidden without any network connection (manual input cannot reach anything either)', () {
      expect(
        showManualFallback(scanning: false, failureLayer: DiscoveryFailureLayer.noInterface),
        isFalse,
      );
    });

    test('shown when multicast is unavailable', () {
      expect(
        showManualFallback(scanning: false, failureLayer: DiscoveryFailureLayer.multicastUnavailable),
        isTrue,
      );
    });

    test('shown when the scan found nothing', () {
      expect(
        showManualFallback(scanning: false, failureLayer: DiscoveryFailureLayer.scanNoResult),
        isTrue,
      );
    });

    test('shown when no diagnosis is available yet', () {
      expect(
        showManualFallback(scanning: false, failureLayer: null),
        isTrue,
      );
    });
  });

  testWidgets('renders nothing when invisible', (tester) async {
    await pumpFallback(
      tester,
      const DiscoveryManualFallback(visible: false),
    );

    expect(find.text(t.sendTab.diagnosis.manualFallback.message), findsNothing);
    expect(find.byType(TextButton), findsNothing);
  });

  testWidgets('shows the guidance message and both buttons when visible', (tester) async {
    await pumpFallback(
      tester,
      DiscoveryManualFallback(visible: true, onOpenFavorites: (_) async {}, onOpenManualAddress: (_) async {}),
    );

    expect(find.text(t.sendTab.diagnosis.manualFallback.message), findsOneWidget);
    expect(find.text(t.sendTab.diagnosis.manualFallback.openFavorites), findsOneWidget);
    expect(find.text(t.sendTab.diagnosis.manualFallback.manualInput), findsOneWidget);
  });

  testWidgets('favorites button invokes the favorites entry', (tester) async {
    var calls = 0;
    await pumpFallback(
      tester,
      DiscoveryManualFallback(
        visible: true,
        onOpenFavorites: (_) async => calls++,
        onOpenManualAddress: (_) async => fail('manual address entry must not be called'),
      ),
    );

    await tester.tap(find.text(t.sendTab.diagnosis.manualFallback.openFavorites));
    await tester.pump();

    expect(calls, 1);
  });

  testWidgets('manual input button invokes the manual address entry', (tester) async {
    var calls = 0;
    await pumpFallback(
      tester,
      DiscoveryManualFallback(
        visible: true,
        onOpenFavorites: (_) async => fail('favorites entry must not be called'),
        onOpenManualAddress: (_) async => calls++,
      ),
    );

    await tester.tap(find.text(t.sendTab.diagnosis.manualFallback.manualInput));
    await tester.pump();

    expect(calls, 1);
  });

  testWidgets('buttons are hidden without callbacks', (tester) async {
    await pumpFallback(
      tester,
      const DiscoveryManualFallback(visible: true),
    );

    expect(find.text(t.sendTab.diagnosis.manualFallback.message), findsOneWidget);
    expect(find.byType(TextButton), findsNothing);
  });
}
