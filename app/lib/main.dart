import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:localsend_app/config/init.dart';
import 'package:localsend_app/config/init_error.dart';
import 'package:localsend_app/config/theme.dart';
import 'package:localsend_app/gen/strings.g.dart';
import 'package:localsend_app/model/persistence/color_mode.dart';
import 'package:localsend_app/pages/home_page.dart';
import 'package:localsend_app/provider/local_ip_provider.dart';
import 'package:localsend_app/provider/network/server/server_provider.dart';
import 'package:localsend_app/provider/settings_provider.dart';
import 'package:localsend_app/util/native/platform_check.dart';
import 'package:localsend_app/util/ui/dynamic_colors.dart';
import 'package:localsend_app/widget/watcher/life_cycle_watcher.dart';
import 'package:localsend_app/widget/watcher/shortcut_watcher.dart';
import 'package:localsend_app/widget/watcher/tray_watcher.dart';
import 'package:localsend_app/widget/watcher/window_watcher.dart';
import 'package:localsend_isolates/isolate.dart';
import 'package:refena_flutter/addons.dart';
import 'package:refena_flutter/refena_flutter.dart';
import 'package:routerino/routerino.dart';
import 'package:system_date_time_format/system_date_time_format.dart';

/// Debounces the discovery rebind on Android resume (see
/// [LocalSendApp] lifecycle handling): Android delivers inactive/resumed
/// for every file picker, dialog and notification shade interaction.
Timer? _resumeDiscoveryRebindDebounce;

Future<void> main(List<String> args) async {
  final RefenaContainer container;
  try {
    container = await preInit(args);
  } catch (e, stackTrace) {
    showInitErrorApp(
      error: e,
      stackTrace: stackTrace,
    );
    return;
  }

  runApp(
    RefenaScope.withContainer(
      container: container,
      child: SDTFScope(
        child: TranslationProvider(
          child: const LocalSendApp(),
        ),
      ),
    ),
  );
}

class LocalSendApp extends StatelessWidget {
  const LocalSendApp();

  @override
  Widget build(BuildContext context) {
    final ref = context.ref;
    final (themeMode, colorMode, customColor) = ref.watch(
      settingsProvider.select((settings) => (settings.theme, settings.colorMode, settings.customColor)),
    );
    final dynamicColors = ref.watch(dynamicColorsProvider);
    return TrayWatcher(
      child: WindowWatcher(
        child: LifeCycleWatcher(
          onChangedState: (AppLifecycleState state) {
            switch (state) {
              case AppLifecycleState.resumed:
                ref.redux(localIpProvider).dispatch(InitLocalIpAction());
                if (checkPlatform([TargetPlatform.iOS, TargetPlatform.android])) {
                  // The OS may have invalidated the sockets of the suspended app without any error ever reaching the accept loop.
                  // ignore: discarded_futures
                  ref.notifier(serverProvider).ensureRunning();
                }
                if (checkPlatform([TargetPlatform.iOS, TargetPlatform.android])) {
                  // The multicast sockets die the same silent way but cannot be probed, so always rebind them.
                  // Android is included because its sockets are bound once at
                  // startup and never follow interface changes (e.g. an
                  // enabled hotspot). The iOS-only gate of 63efbe6b was an
                  // explicit decision for the suspend-kills-sockets case;
                  // the interface-set rebind of [FetchLocalIpAction] covers
                  // ordinary network changes, so this resume rebind is the
                  // remaining bootstrap for silently invalidated sockets.
                  //
                  // The rebind is debounced on Android: it reports
                  // inactive/resumed for every file picker, dialog and
                  // notification shade interaction, and every rebind clears
                  // the confirmed-device store on the Rust side and emits an
                  // announcement burst. iOS keeps the immediate rebind of
                  // 63efbe6b.
                  void rebindDiscovery() {
                    if (ref.read(parentIsolateProvider).discovery != null) {
                      ref.redux(parentIsolateProvider).dispatch(IsolateDiscoveryRestartAction());
                    }
                  }

                  if (checkPlatform([TargetPlatform.android])) {
                    _resumeDiscoveryRebindDebounce?.cancel();
                    _resumeDiscoveryRebindDebounce = Timer(const Duration(milliseconds: 750), rebindDiscovery);
                  } else {
                    rebindDiscovery();
                  }
                }
                break;
              case AppLifecycleState.detached:
                // The main isolate is only exited when all child isolates are exited.
                // https://github.com/localsend/localsend/issues/1568
                ref.redux(parentIsolateProvider).dispatch(IsolateDisposeAction());
                break;
              default:
                break;
            }
          },
          child: ShortcutWatcher(
            child: MaterialApp(
              title: t.appName,
              locale: TranslationProvider.of(context).flutterLocale,
              supportedLocales: AppLocaleUtils.supportedLocales,
              localizationsDelegates: GlobalMaterialLocalizations.delegates,
              debugShowCheckedModeBanner: false,
              theme: getTheme(colorMode, customColor, Brightness.light, dynamicColors),
              darkTheme: getTheme(colorMode, customColor, Brightness.dark, dynamicColors),
              themeMode: colorMode == ColorMode.oled ? ThemeMode.dark : themeMode,
              navigatorKey: context.read(navigationProvider).key,
              home: RouterinoHome(
                builder: () => const HomePage(
                  initialTab: HomeTab.receive,
                  appStart: true,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
