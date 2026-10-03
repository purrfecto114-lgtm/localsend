import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:localsend_app/gen/strings.g.dart';
import 'package:localsend_app/util/startup_error_classifier.dart';
import 'package:localsend_app/widget/dialogs/startup_error_dialog.dart';

void main() {
  setUp(() => LocaleSettings.setLocale(AppLocale.en));

  Future<void> pumpDialog(WidgetTester tester, StartupErrorDialog dialog) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(builder: (context) => dialog),
        ),
      ),
    );
  }

  testWidgets('shows Windows-specific advice for errno 10013', (tester) async {
    await pumpDialog(
      tester,
      StartupErrorDialog(
        classification: classifyStartupError('An attempt was made to access a socket in a way forbidden by its access permissions. (os error 10013)'),
        port: 53317,
      ),
    );

    expect(find.text(t.dialogs.startupError.title), findsOneWidget);
    expect(find.text(t.dialogs.startupError.port(port: 53317)), findsOneWidget);
    expect(find.text(t.dialogs.startupError.windowsAccessDenied.hint), findsOneWidget);
    expect(find.text(t.dialogs.startupError.windowsAccessDenied.advice), findsOneWidget);
    // The raw error is selectable for bug reports.
    expect(find.textContaining('(os error 10013)'), findsOneWidget);
  });

  testWidgets('shows address-in-use advice for errno 98', (tester) async {
    await pumpDialog(
      tester,
      StartupErrorDialog(
        classification: classifyStartupError('Address already in use (os error 98)'),
        port: 53317,
      ),
    );

    expect(find.text(t.dialogs.startupError.addressInUse.hint), findsOneWidget);
    expect(find.text(t.dialogs.startupError.windowsAccessDenied.hint), findsNothing);
  });

  testWidgets('shows generic advice without a known errno', (tester) async {
    await pumpDialog(
      tester,
      StartupErrorDialog(
        classification: classifyStartupError(Exception('boom')),
        port: 1234,
      ),
    );

    expect(find.text(t.dialogs.startupError.generic.hint), findsOneWidget);
    expect(find.text(t.dialogs.startupError.port(port: 1234)), findsOneWidget);
  });

  testWidgets('copy button copies the raw error details', (tester) async {
    // Clipboard.setData goes through the platform channel.
    final clipboardCalls = <MethodCall>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
      clipboardCalls.add(call);
      return null;
    });
    addTearDown(() => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform, null));

    const detail = 'Address already in use (os error 98)';
    await pumpDialog(
      tester,
      StartupErrorDialog(
        classification: classifyStartupError(detail),
        port: 53317,
      ),
    );

    await tester.tap(find.text(t.dialogs.startupError.copyDetails));
    await tester.pump();

    // The platform channel carries unrelated framework traffic too.
    final setDataCalls = clipboardCalls.where((call) => call.method == 'Clipboard.setData').toList();
    expect(setDataCalls, hasLength(1));
    expect(setDataCalls.single.arguments, <String, Object>{'text': detail});
  });

  testWidgets('open settings button pops the dialog and invokes the callback', (tester) async {
    var openSettingsCalled = false;
    await pumpDialog(
      tester,
      StartupErrorDialog(
        classification: classifyStartupError('Address already in use (os error 98)'),
        port: 53317,
        onOpenSettings: () => openSettingsCalled = true,
      ),
    );

    await tester.tap(find.text(t.dialogs.startupError.openSettings));
    await tester.pumpAndSettle();

    expect(openSettingsCalled, isTrue);
  });

  testWidgets('open settings button is hidden without a callback', (tester) async {
    await pumpDialog(
      tester,
      StartupErrorDialog(
        classification: classifyStartupError('Address already in use (os error 98)'),
        port: 53317,
      ),
    );

    expect(find.text(t.dialogs.startupError.openSettings), findsNothing);
  });
}
