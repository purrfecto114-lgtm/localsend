/// Name-based detection of virtual VPN/tunnel network interfaces.
///
/// There is deliberately no platform API for this: operating systems expose
/// VPN adapters as ordinary interfaces, and the only portable signal is the
/// interface name (or, on Windows, the friendly adapter name that
/// `dart:io NetworkInterface.list()` reports as the name).
///
/// Matched names cover the common tunnel drivers and products:
/// - Linux/Android: `tun0`, `tap0`, `ppp0`, `tailscale0`, `wg0`, `zt...`
///   (ZeroTier), `nordlynx0`
/// - macOS/iOS: `utun4`, `ppp0`, `ipsec0`
/// - Windows (friendly names): "Tailscale", "Wintun", "TAP-Windows Adapter",
///   "VPN Connection", "Cisco AnyConnect ...", "Mullvad", ...
///
/// Non-VPN adapters that must NOT match: `eth0`, `wlan0`, `en0`, `docker0`,
/// `br-*`, `veth*`, `virbr0`, `awdl0`, `bridge100`, `rmnet*`, `isatap.*`
/// (IPv6 transition tunnels without an IPv4 address), Hyper-V / WSL virtual
/// switches.
bool isVpnInterfaceName(String name) {
  final n = name.toLowerCase();

  // Prefixes of the classic tunnel drivers (Linux, Android, macOS, iOS).
  // `tap` is a prefix (not a substring) so that `isatap.{guid}` is not
  // matched; `tun` as a prefix plus the `wintun` substring below covers
  // `tun0` and `utun4` alike.
  const prefixes = [
    'tun', // Linux tun0, macOS utun4 (via substring too), Android tun0
    'tap', // Linux tap0, Windows "TAP-Windows Adapter V9"
    'ppp', // PPP dial-up / PPPoE / old PPTP links
    'ipsec', // macOS IKEv1/v2 VPN interfaces
    'tailscale', // Linux tailscale0
    'wg', // WireGuard on Linux (wg0, wg1, ...)
    'zt', // ZeroTier (ztXXXXXXXX)
    'nordlynx', // NordVPN's WireGuard interface on Linux
  ];

  // Substrings of the friendly adapter names reported on Windows.
  const substrings = [
    'vpn', // "VPN Connection", "ProtonVPN TUN", "ExpressVPN Wintun", ...
    'tun', // "Wintun" (WireGuard's driver) and macOS "utun4" alike
    'tailscale',
    'wireguard',
    'openvpn',
    'zerotier',
    'nordlynx', // "NordLynx" on Windows
    'mullvad',
    'anyconnect', // Cisco AnyConnect virtual miniport adapter
    'globalprotect', // Palo Alto GlobalProtect
    'fortissl', // Fortinet SSL-VPN
  ];

  return prefixes.any(n.startsWith) || substrings.any(n.contains);
}
