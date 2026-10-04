import 'package:dart_mappable/dart_mappable.dart';

part 'network_state.mapper.dart';

@MappableClass()
class NetworkState with NetworkStateMappable {
  final List<String> localIps;

  /// The addresses of [localIps] that belong to VPN/tunnel interfaces
  /// (see [isVpnInterfaceName]). This is a plain description of the machine
  /// and does not depend on any setting: whether these interfaces are
  /// actually scanned is decided by the smart scan via
  /// [SettingsState.includeVpnInterfaces].
  final Set<String> vpnIps;
  final bool initialized;

  const NetworkState({
    required this.localIps,
    this.vpnIps = const {},
    required this.initialized,
  });
}
