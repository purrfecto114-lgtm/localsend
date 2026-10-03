import 'dart:async';

import 'package:collection/collection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:localsend_app/model/state/network_state.dart';
import 'package:localsend_app/provider/settings_provider.dart';
import 'package:localsend_app/util/native/platform_check.dart';
import 'package:localsend_isolates/isolate.dart';
import 'package:localsend_isolates/util/network_interfaces.dart';
import 'package:logging/logging.dart';
import 'package:network_info_plus/network_info_plus.dart' as plugin;
import 'package:refena_flutter/refena_flutter.dart';

final _logger = Logger('NetworkInfo');

final localIpProvider = ReduxProvider<LocalIpService, NetworkState>((ref) {
  return LocalIpService(
    ref.notifier(settingsProvider),
    ref.notifier(parentIsolateProvider),
  );
});

StreamSubscription? _subscription;
Timer? _interfacePollTimer;

class LocalIpService extends ReduxNotifier<NetworkState> {
  final SettingsService _settingsService;
  final IsolateController _parentIsolateController;

  /// Monotonic id of the most recently started [FetchLocalIpAction].
  /// Fetches that were overtaken by a newer one discard their result.
  int _fetchId = 0;

  LocalIpService(this._settingsService, this._parentIsolateController);

  @override
  NetworkState init() {
    return const NetworkState(
      localIps: [],
      initialized: false,
    );
  }

  @override
  get initialAction => InitLocalIpAction();
}

/// Fetches the local IP address and registers a listener to update the IP address
class InitLocalIpAction extends ReduxAction<LocalIpService, NetworkState> {
  @override
  NetworkState reduce() {
    if (!kIsWeb) {
      // ignore: discarded_futures
      _subscription?.cancel();

      if (checkPlatform([TargetPlatform.windows])) {
        // https://github.com/localsend/localsend/issues/12
        // https://github.com/localsend/localsend/issues/78
        //
        // Windows is excluded from the connectivity stream because of the
        // false positives above. Poll the interface list instead. The poll
        // must not call the Wi-Fi plugin: getWifiIP performs a
        // location-sensitive WLAN query on Windows, which is why the former
        // periodic polling was removed upstream (221f40a9, "fix(windows):
        // unwanted location permission" for #78). The native interface list
        // alone detects address set changes, and [FetchLocalIpAction] only
        // rebinds the discovery when the set actually changed, so new
        // networks (e.g. an enabled hotspot) are picked up without the
        // spurious restarts of #12/#78.
        _interfacePollTimer?.cancel();
        _interfacePollTimer = Timer.periodic(const Duration(seconds: 10), (_) async {
          try {
            await dispatchAsync(FetchLocalIpAction(includeWifiIp: false));
          } catch (e, stackTrace) {
            // Keep polling even when a single fetch fails (e.g. a VPN
            // adapter disappearing mid-enumeration).
            _logger.warning('Interface poll failed', e, stackTrace);
          }
        });
      } else {
        _subscription = Connectivity().onConnectivityChanged.listen((_) async {
          await dispatchAsync(FetchLocalIpAction());
        });
      }
    }

    return state;
  }

  @override
  void after() {
    // ignore: discarded_futures
    dispatchAsync(FetchLocalIpAction());
  }
}

class FetchLocalIpAction extends AsyncReduxAction<LocalIpService, NetworkState> {
  FetchLocalIpAction({this.includeWifiIp = true});

  /// Whether [_getIp] may query the Wi-Fi plugin for the address of the
  /// active Wi-Fi interface. Must be false for the Windows interface poll
  /// (see [InitLocalIpAction]): the query is location-sensitive on Windows.
  final bool includeWifiIp;

  @override
  Future<NetworkState> reduce() async {
    final fetchId = ++notifier._fetchId;
    // Not the "first fetch" when an earlier fetch already completed (state
    // initialized) or merely started: a first fetch that hangs or throws
    // must not downgrade the next fetch to a no-rebind first fetch, or a
    // device that was offline at startup keeps its empty discovery binding
    // forever once the network appears.
    final firstFetchDone = state.initialized || fetchId > 1;
    final previousIps = state.localIps;
    final newState = NetworkState(
      localIps: await _getIp(
        whitelist: notifier._settingsService.state.networkWhitelist,
        blacklist: notifier._settingsService.state.networkBlacklist,
        includeWifiIp: includeWifiIp,
      ),
      initialized: true,
    );

    // A newer fetch started while this one was awaiting the platform calls;
    // its result is at least as fresh, so discard this one instead of
    // overwriting the newer state with older data.
    if (fetchId != notifier._fetchId) {
      return state;
    }

    // The multicast sockets are bound once when the discovery starts and are
    // never rebound on their own, so an interface change (e.g. a hotspot that
    // was just enabled) would stay invisible until a manual restart.
    // Rebind the discovery whenever the set of local addresses actually
    // changed (see [shouldRebindDiscovery]).
    if (shouldRebindDiscovery(
      previousIps: previousIps,
      nextIps: newState.localIps,
      firstFetchDone: firstFetchDone,
    )) {
      if (notifier._parentIsolateController.state.discovery != null) {
        external(notifier._parentIsolateController).dispatch(IsolateDiscoveryRestartAction());
      }
    }

    return newState;
  }
}

/// Whether the discovery should be rebound after the local address list
/// changed from [previousIps] to [nextIps].
///
/// The first fetch ([firstFetchDone] is false) never rebinds: the discovery
/// is not running yet or was just started with fresh state. The comparison
/// is a set comparison (dart:core Set has no value equality), so a new order
/// of the same addresses (re-ranking) does not rebind, while a list that
/// grows from empty (the device was offline when the discovery started)
/// does rebind.
@visibleForTesting
bool shouldRebindDiscovery({
  required List<String> previousIps,
  required List<String> nextIps,
  required bool firstFetchDone,
}) {
  return firstFetchDone && !setEquals(previousIps.toSet(), nextIps.toSet());
}

Future<List<String>> _getIp({
  required List<String>? whitelist,
  required List<String>? blacklist,
  bool includeWifiIp = true,
}) async {
  final info = plugin.NetworkInfo();
  String? ip;
  if (includeWifiIp) {
    try {
      ip = await info.getWifiIP();
    } catch (e) {
      _logger.warning('Failed to get wifi IP', e);
    }
  }

  final nativeResult =
      (await getNetworkInterfaces(
            whitelist: whitelist,
            blacklist: blacklist,
          ))
          .map((interface) => interface.addresses.map((a) => a.address).toList())
          .expand((ip) => ip)
          .where((ip) => !ip.contains(':')) // ignore IPv6 for now
          .toList();

  final addresses = rankIpAddresses(nativeResult, ip);
  _logger.info('Network state: $addresses');
  return addresses;
}

List<String> rankIpAddresses(List<String> nativeResult, String? thirdPartyResult) {
  if (thirdPartyResult == null) {
    // only take the list
    return nativeResult._rankIpAddresses(null);
  } else if (nativeResult.isEmpty) {
    // only take the first IP from third party library
    return [thirdPartyResult];
  } else {
    // merge but prefer result from third party library
    //
    // The third party result is the address of the active Wi-Fi interface,
    // so it is also trusted when it ends with ".1": a hotspot gateway (e.g.
    // 192.168.43.1 on Android below 12, 192.168.137.1 on Windows) is
    // exactly the network whose clients must be scanned when this device
    // provides the hotspot. Ranking it last made the hotspot subnet miss
    // the "maxInterfaces" cut on multi-adapter machines. Native addresses
    // ending with ".1" are still ranked last by [_rankIpAddresses]; only
    // the actively reported interface wins.
    //
    // Platform reality check: Android 12+ reports the cellular uplink
    // address (or null) while a hotspot is enabled, and iOS reports null
    // because the hotspot bridge interface is not an en* interface, so the
    // .1 preference mainly benefits older Android and some Windows
    // hotspot forms. The reliable fix for hotspot visibility on Windows is
    // the interface poll above (rebind on address set change), not this
    // ranking. The third party preference itself is pre-existing upstream
    // behavior and is kept unchanged.
    return {thirdPartyResult, ...nativeResult}.toList()._rankIpAddresses(thirdPartyResult);
  }
}

/// Sorts Ip addresses with first being the most likely primary local address
/// Currently,
/// - sorts ending with ".1" last
/// - primary is always first
extension ListIpExt on List<String> {
  List<String> _rankIpAddresses(String? primary) {
    return sorted((a, b) {
      int scoreA = a == primary ? 10 : (a.endsWith('.1') ? 0 : 1);
      int scoreB = b == primary ? 10 : (b.endsWith('.1') ? 0 : 1);
      return scoreB.compareTo(scoreA);
    });
  }
}
