import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:localsend_app/gen/strings.g.dart';
import 'package:localsend_app/widget/dialogs/connection_error_dialog.dart';

void main() {
  setUp(() => LocaleSettings.setLocale(AppLocale.en));

  Future<void> pumpDialog(WidgetTester tester, ConnectionErrorDialog dialog) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(builder: (context) => dialog),
        ),
      ),
    );
  }

  testWidgets('maps a timeout error to the offline/firewall advice', (tester) async {
    await pumpDialog(
      tester,
      const ConnectionErrorDialog(
        error: 'RhttpTimeoutException: Request timed out. URL: https://192.168.1.5:53317/api/localsend/v2/info',
      ),
    );

    expect(find.text(t.dialogs.connectionError.title), findsOneWidget);
    expect(find.text(t.dialogs.connectionError.timeout.message), findsOneWidget);
    expect(find.text(t.dialogs.connectionError.timeout.advice), findsOneWidget);
    // The raw error stays available for bug reports.
    expect(find.textContaining('Request timed out'), findsOneWidget);
    // No retry callback: no retry button.
    expect(find.text(t.dialogs.connectionError.retry), findsNothing);
  });

  testWidgets('maps a connection refused error to the not-running advice', (tester) async {
    await pumpDialog(
      tester,
      const ConnectionErrorDialog(error: 'Connection refused (os error 111)'),
    );

    expect(find.text(t.dialogs.connectionError.refused.message), findsOneWidget);
    expect(find.text(t.dialogs.connectionError.timeout.message), findsNothing);
  });

  testWidgets('maps a forbidden error to the PIN advice', (tester) async {
    await pumpDialog(
      tester,
      const ConnectionErrorDialog(error: 'Forbidden'),
    );

    expect(find.text(t.dialogs.connectionError.forbidden.message), findsOneWidget);
  });

  testWidgets('shows generic advice for unknown errors', (tester) async {
    await pumpDialog(
      tester,
      ConnectionErrorDialog(error: Exception('boom')),
    );

    expect(find.text(t.dialogs.connectionError.other.message), findsOneWidget);
    expect(find.textContaining('boom'), findsOneWidget);
  });

  testWidgets('retry button pops the dialog and re-runs the request', (tester) async {
    var attempts = 0;
    await pumpDialog(
      tester,
      ConnectionErrorDialog(
        error: 'Request timed out',
        onRetry: () async => attempts++,
      ),
    );

    await tester.tap(find.text(t.dialogs.connectionError.retry));
    await tester.pumpAndSettle();

    expect(attempts, 1);
  });
}
