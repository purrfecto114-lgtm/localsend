import 'package:flutter/material.dart';
import 'package:localsend_app/gen/strings.g.dart';
import 'package:localsend_app/util/connection_error.dart';
import 'package:localsend_isolates/util/rust.dart';
import 'package:routerino/routerino.dart';

/// A friendly, retryable error dialog for failed connection attempts to
/// another device (manual address input, favorites).
///
/// Instead of showing the raw exception (#2121), it explains in plain words
/// what likely went wrong, how to troubleshoot it, keeps the raw error
/// selectable for bug reports and offers to retry the failed request.
class ConnectionErrorDialog extends StatelessWidget {
  final Object error;

  /// Re-runs the failed request. The dialog closes itself before
  /// invoking this, so the caller can safely re-enter its loading state.
  final Future<void> Function()? onRetry;

  const ConnectionErrorDialog({
    required this.error,
    this.onRetry,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final (message, advice) = switch (classifyConnectionError(error)) {
      ConnectionErrorKind.timeout => (
        t.dialogs.connectionError.timeout.message,
        t.dialogs.connectionError.timeout.advice,
      ),
      ConnectionErrorKind.connectionRefused => (
        t.dialogs.connectionError.refused.message,
        t.dialogs.connectionError.refused.advice,
      ),
      ConnectionErrorKind.forbidden => (
        t.dialogs.connectionError.forbidden.message,
        t.dialogs.connectionError.forbidden.advice,
      ),
      ConnectionErrorKind.other => (
        t.dialogs.connectionError.other.message,
        t.dialogs.connectionError.other.advice,
      ),
    };

    return AlertDialog(
      title: Text(t.dialogs.connectionError.title),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(advice, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 10),
            Text(t.dialogs.connectionError.details, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            SelectableText(
              error.humanErrorMessage,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
      actions: [
        if (onRetry != null)
          FilledButton(
            onPressed: () async {
              await Navigator.of(context).maybePop();
              await onRetry!();
            },
            child: Text(t.dialogs.connectionError.retry),
          ),
        TextButton(
          onPressed: () => context.pop(),
          child: Text(t.general.close),
        ),
      ],
    );
  }
}

/// A short, friendly description of the error for inline display.
String connectionErrorMessage(Object error) {
  return switch (classifyConnectionError(error)) {
    ConnectionErrorKind.timeout => t.dialogs.connectionError.timeout.message,
    ConnectionErrorKind.connectionRefused => t.dialogs.connectionError.refused.message,
    ConnectionErrorKind.forbidden => t.dialogs.connectionError.forbidden.message,
    ConnectionErrorKind.other => t.dialogs.connectionError.other.message,
  };
}
