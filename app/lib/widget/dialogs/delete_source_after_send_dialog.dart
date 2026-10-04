import 'package:flutter/material.dart';
import 'package:localsend_app/gen/strings.g.dart';
import 'package:localsend_app/provider/settings_provider.dart';
import 'package:routerino/routerino.dart';

/// Asks for confirmation before the "delete source files after sending"
/// setting is enabled.
///
/// Pops with `true` when the user confirms; any other way of leaving the
/// dialog (cancel button, tapping outside) keeps the setting unchanged.
class DeleteSourceAfterSendDialog extends StatelessWidget {
  const DeleteSourceAfterSendDialog({super.key});

  /// Applies a toggle of the "delete source files after sending" setting.
  ///
  /// Enabling the setting is destructive, so it asks for an explicit
  /// confirmation first and does nothing when the user cancels the dialog.
  /// Disabling it needs no confirmation.
  static Future<void> handleToggle(BuildContext context, SettingsService settings, bool enabled) async {
    if (enabled) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (_) => const DeleteSourceAfterSendDialog(),
      );
      if (confirmed != true) {
        return;
      }
    }
    await settings.setDeleteSourceAfterSend(enabled);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(t.dialogs.deleteSourceAfterSendDialog.title),
      content: Text(t.dialogs.deleteSourceAfterSendDialog.content),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: Text(t.general.cancel),
        ),
        FilledButton(
          onPressed: () => context.pop(true),
          child: Text(t.general.confirm),
        ),
      ],
    );
  }
}
