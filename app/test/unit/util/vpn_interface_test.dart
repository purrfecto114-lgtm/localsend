import 'package:localsend_app/util/vpn_interface.dart';
import 'package:test/test.dart';

void main() {
  group('isVpnInterfaceName', () {
    test('should detect the classic tunnel driver names', () {
      // Linux / Android
      expect(isVpnInterfaceName('tun0'), isTrue);
      expect(isVpnInterfaceName('tap0'), isTrue);
      expect(isVpnInterfaceName('ppp0'), isTrue);
      expect(isVpnInterfaceName('tailscale0'), isTrue);
      expect(isVpnInterfaceName('wg0'), isTrue);
      expect(isVpnInterfaceName('nordlynx0'), isTrue);
      // macOS / iOS
      expect(isVpnInterfaceName('utun4'), isTrue);
      expect(isVpnInterfaceName('ipsec0'), isTrue);
      // ZeroTier
      expect(isVpnInterfaceName('zt7yzb5x4n'), isTrue);
    });

    test('should detect Windows friendly adapter names', () {
      expect(isVpnInterfaceName('Tailscale'), isTrue);
      expect(isVpnInterfaceName('Wintun'), isTrue);
      expect(isVpnInterfaceName('TAP-Windows Adapter V9'), isTrue);
      expect(isVpnInterfaceName('VPN Connection'), isTrue);
      expect(isVpnInterfaceName('ProtonVPN TUN'), isTrue);
      expect(isVpnInterfaceName('NordLynx'), isTrue);
      expect(isVpnInterfaceName('Mullvad'), isTrue);
      expect(isVpnInterfaceName('Cisco AnyConnect Secure Mobility Client Virtual Miniport Adapter'), isTrue);
      expect(isVpnInterfaceName('Palo Alto GlobalProtect'), isTrue);
      expect(isVpnInterfaceName('Fortinet SSL VPN'), isTrue);
    });

    test('should be case-insensitive', () {
      expect(isVpnInterfaceName('TUN0'), isTrue);
      expect(isVpnInterfaceName('Tailscale'), isTrue);
      expect(isVpnInterfaceName('WIREGUARD'), isTrue);
    });

    test('should not match physical and non-VPN virtual interfaces', () {
      // Linux
      expect(isVpnInterfaceName('eth0'), isFalse);
      expect(isVpnInterfaceName('wlan0'), isFalse);
      expect(isVpnInterfaceName('wlp3s0'), isFalse);
      expect(isVpnInterfaceName('docker0'), isFalse);
      expect(isVpnInterfaceName('br-abcdef12345'), isFalse);
      expect(isVpnInterfaceName('veth1234567'), isFalse);
      expect(isVpnInterfaceName('virbr0'), isFalse);
      expect(isVpnInterfaceName('usb0'), isFalse);
      // macOS
      expect(isVpnInterfaceName('en0'), isFalse);
      expect(isVpnInterfaceName('awdl0'), isFalse);
      expect(isVpnInterfaceName('llw0'), isFalse);
      expect(isVpnInterfaceName('bridge100'), isFalse);
      // Android
      expect(isVpnInterfaceName('rmnet_data0'), isFalse);
      expect(isVpnInterfaceName('swlan0'), isFalse);
      expect(isVpnInterfaceName('ap0'), isFalse);
      // Windows
      expect(isVpnInterfaceName('Wi-Fi'), isFalse);
      expect(isVpnInterfaceName('Ethernet 2'), isFalse);
      expect(isVpnInterfaceName('Intel(R) Wi-Fi 6 AX200 160MHz'), isFalse);
      expect(isVpnInterfaceName('Bluetooth Network Connection'), isFalse);
      expect(isVpnInterfaceName('Hyper-V Virtual Ethernet Adapter'), isFalse);
      expect(isVpnInterfaceName('vEthernet (Default Switch)'), isFalse);
      expect(isVpnInterfaceName('WSL'), isFalse);
    });

    test('should not match IPv6 transition pseudo interfaces', () {
      // ISATAP carries no IPv4 address; it must not be boosted just because
      // it contains "tap".
      expect(isVpnInterfaceName('isatap.{6B74FC01-4A5B-4C66-8E1C-9B2B80A8BE2C}'), isFalse);
      expect(isVpnInterfaceName('Teredo'), isFalse);
    });
  });
}
