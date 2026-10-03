import 'package:flutter/material.dart';
import 'package:localsend_app/config/theme.dart';
import 'package:localsend_app/gen/strings.g.dart';
import 'package:localsend_app/model/persistence/favorite_device.dart';
import 'package:localsend_app/provider/device_info_provider.dart';
import 'package:localsend_app/provider/favorites_provider.dart';
import 'package:localsend_app/provider/http_provider.dart';
import 'package:localsend_app/provider/settings_provider.dart';
import 'package:localsend_app/util/address_input_validator.dart';
import 'package:localsend_app/widget/dialogs/connection_error_dialog.dart';
import 'package:localsend_app/widget/dialogs/favorite_delete_dialog.dart';
import 'package:localsend_isolates/model/device.dart';
import 'package:localsend_isolates/rust/api/model.dart';
import 'package:localsend_isolates/util/rust.dart';
import 'package:refena_flutter/refena_flutter.dart';
import 'package:routerino/routerino.dart';

/// A dialog to add or edit a favorite device.
class FavoriteEditDialog extends StatefulWidget {
  final FavoriteDevice? favorite;
  final Device? prefilledDevice;

  const FavoriteEditDialog({
    this.favorite,
    this.prefilledDevice,
  });

  @override
  State<FavoriteEditDialog> createState() => _FavoriteEditDialogState();
}

class _FavoriteEditDialogState extends State<FavoriteEditDialog> with Refena {
  final _ipController = TextEditingController();
  final _portController = TextEditingController();
  final _aliasController = TextEditingController();
  bool _fetching = false;
  Object? _error;
  ManualAddressError? _ipValidationError;

  /// The register parameters of the most recent attempt, so the retry
  /// button of the [ConnectionErrorDialog] can re-run exactly the failed
  /// request.
  ({String host, int port})? _lastRegisterAttempt;

  @override
  void initState() {
    super.initState();

    _ipController.text = widget.prefilledDevice?.ip ?? widget.favorite?.ip ?? '';
    _aliasController.text = widget.prefilledDevice?.alias ?? widget.favorite?.alias ?? '';

    ensureRef((ref) {
      _portController.text =
          widget.prefilledDevice?.port.toString() ?? widget.favorite?.port.toString() ?? ref.read(settingsProvider).port.toString();
    });
  }

  @override
  void dispose() {
    _ipController.dispose();
    _portController.dispose();
    _aliasController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.favorite != null ? t.dialogs.favoriteEditDialog.titleEdit : t.dialogs.favoriteEditDialog.titleAdd),
      content: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t.dialogs.favoriteEditDialog.name),
            const SizedBox(height: 5),
            TextFormField(
              controller: _aliasController,
              decoration: InputDecoration(
                hintText: t.dialogs.favoriteEditDialog.auto,
              ),
              enabled: !_fetching,
            ),
            const SizedBox(height: 16),
            Text(t.dialogs.favoriteEditDialog.ip),
            const SizedBox(height: 5),
            TextFormField(
              controller: _ipController,
              autofocus: widget.favorite == null && widget.prefilledDevice == null,
              enabled: !_fetching,
              decoration: InputDecoration(
                errorText: _ipValidationErrorText,
              ),
              onChanged: (s) {
                setState(() {
                  _ipValidationError = parseManualAddress(s).$2;
                });
              },
            ),
            const SizedBox(height: 16),
            Text(t.dialogs.favoriteEditDialog.port),
            const SizedBox(height: 5),
            TextFormField(
              controller: _portController,
              enabled: !_fetching,
              keyboardType: TextInputType.number,
            ),
            if (widget.favorite != null) ...[
              const SizedBox(height: 16),
              TextButton.icon(
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.warning,
                ),
                onPressed: () async {
                  final result = await showDialog<bool>(
                    context: context,
                    builder: (_) => FavoriteDeleteDialog(widget.favorite!),
                  );

                  if (context.mounted && result == true) {
                    await context.ref.redux(favoritesProvider).dispatchAsync(RemoveFavoriteAction(deviceFingerprint: widget.favorite!.fingerprint));
                    if (context.mounted) {
                      context.pop();
                    }
                  }
                },
                icon: const Icon(Icons.delete),
                label: Text(t.general.delete),
              ),
            ],
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        connectionErrorMessage(_error!),
                        style: TextStyle(color: Theme.of(context).colorScheme.warning),
                      ),
                    ),
                    const SizedBox(width: 5),
                    InkWell(
                      onTap: () async {
                        final attempt = _lastRegisterAttempt;
                        await showDialog(
                          context: context,
                          builder: (_) => ConnectionErrorDialog(
                            error: _error!,
                            onRetry: attempt == null ? null : () => _registerFavorite(host: attempt.host, port: attempt.port),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Icon(Icons.info, color: Theme.of(context).colorScheme.warning, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: Text(t.general.cancel),
        ),
        FilledButton(
          onPressed: _fetching
              ? null
              : () async {
                  if (_ipController.text.isEmpty) {
                    return;
                  }

                  if (_portController.text.isEmpty) {
                    return;
                  }

                  final (address, ipError) = parseManualAddress(_ipController.text);
                  if (address == null) {
                    // Reject garbage input instead of firing a register
                    // request at it (same validator as the manual address
                    // dialog).
                    setState(() => _ipValidationError = ipError ?? ManualAddressError.invalid);
                    return;
                  }

                  if (widget.favorite != null) {
                    // Update existing favorite
                    final existingFavorite = widget.favorite!;
                    final trimmedNewAlias = _aliasController.text.trim();
                    if (trimmedNewAlias.isEmpty) {
                      return;
                    }

                    await ref
                        .redux(favoritesProvider)
                        .dispatchAsync(
                          UpdateFavoriteAction(
                            existingFavorite.copyWith(
                              ip: address.host,
                              port: int.parse(_portController.text),
                              alias: trimmedNewAlias,
                              customAlias: existingFavorite.customAlias || trimmedNewAlias != existingFavorite.alias,
                            ),
                          ),
                        );
                  } else {
                    // Add new favorite: probe the device with a register
                    // request before saving it.
                    await _registerFavorite(host: address.host, port: int.parse(_portController.text));
                  }
                },
          child: Text(t.general.confirm),
        ),
      ],
    );
  }

  /// Runs the register request that probes a device before it is added to
  /// the favorites. Also used as the retry callback of the
  /// [ConnectionErrorDialog].
  Future<void> _registerFavorite({required String host, required int port}) async {
    _lastRegisterAttempt = (host: host, port: port);
    setState(() {
      _fetching = true;
    });

    try {
      final https = ref.read(settingsProvider).https;
      final payload = ref.read(deviceFullInfoProvider).toRegisterDto();
      final response = await ref
          .read(httpProvider)
          .discovery
          .register(
            protocol: https ? ProtocolType.https : ProtocolType.http,
            ip: host,
            port: port,
            payload: payload,
          );

      final name = _aliasController.text.trim();

      await ref
          .redux(favoritesProvider)
          .dispatchAsync(
            AddFavoriteAction(
              FavoriteDevice.fromValues(
                fingerprint: response.body.token,
                ip: host,
                port: port,
                alias: name.isEmpty ? response.body.alias : name,
              ),
            ),
          );

      if (mounted) {
        context.pop();
      }
    } catch (e) {
      setState(() {
        _fetching = false;
        _error = e;
      });
    }
  }

  String? get _ipValidationErrorText {
    final error = _ipValidationError;
    if (error == null) {
      return null;
    }
    return switch (error) {
      ManualAddressError.scheme => t.dialogs.addressInput.validation.scheme,
      ManualAddressError.port => t.dialogs.addressInput.validation.port,
      ManualAddressError.invalid => t.dialogs.addressInput.validation.invalid,
    };
  }
}
