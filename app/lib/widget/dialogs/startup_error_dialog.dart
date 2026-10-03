import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localsend_app/gen/strings.g.dart';
import 'package:localsend_app/util/startup_error_classifier.dart';
import 'package:localsend_app/util/ui/snackbar.dart';
import 'package:routerino/routerino.dart';

/// An actionable dialog shown when the server could not be started
/// (e.g. the port is blocked or already in use).
///
/// Instead of dumping the raw error into a snackbar, it explains the
/// classified cause, lists concrete next steps, offers to copy the error
/// details and can jump directly to the network settings where the port
/// can be changed.
class StartupErrorDialog extends StatelessWidget {
  final StartupErrorClassification classification;

  /// The port the server tried to bind.
  final int port;

  /// Called when the user wants to fix the port, e.g. by switching to the
  /// settings tab. The dialog closes itself before invoking this.
  final void Function()? onOpenSettings;

  const StartupErrorDialog({
    required this.classification,
    required this.port,
    this.onOpenSettings,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final (hint, advice) = switch (classification.kind) {
      StartupErrorKind.windowsAccessDenied => (
        t.dialogs.startupError.windowsAccessDenied.hint,
        t.dialogs.startupError.windowsAccessDenied.advice,
      ),
      StartupErrorKind.addressInUse => (
        t.dialogs.startupError.addressInUse.hint,
        t.dialogs.startupError.addressInUse.advice,
      ),
      StartupErrorKind.generic => (
        t.dialogs.startupError.generic.hint,
        t.dialogs.startupError.generic.advice,
      ),
    };

    return AlertDialog(
      title: Text(t.dialogs.startupError.title),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t.dialogs.startupError.port(port: port)),
            const SizedBox(height: 10),
            Text(hint, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(advice, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 10),
            Text(t.dialogs.startupError.details, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            SelectableText(
              classification.detail,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
      actions: [
        TextButton.icon(
          onPressed: () async {
            await Clipboard.setData(ClipboardData(text: classification.detail));
            if (context.mounted) {
              context.showSnackBar(t.general.copiedToClipboard);
            }
          },
          icon: const Icon(Icons.copy),
          label: Text(t.dialogs.startupError.copyDetails),
        ),
        if (onOpenSettings != null)
          FilledButton(
            onPressed: () async {
              await Navigator.of(context).maybePop();
              onOpenSettings!();
            },
            child: Text(t.dialogs.startupError.openSettings),
          ),
        TextButton(
          onPressed: () => context.pop(),
          child: Text(t.general.close),
        ),
      ],
    );
  }
}
