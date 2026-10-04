import 'package:localsend_app/provider/network/scan_facade.dart';
import 'package:test/test.dart';

void main() {
  group('selectSmartScanInterfaces', () {
    // A plausible ranked candidate list: active Wi-Fi first, then the
    // Tailscale address, then gateway-like ".1" addresses last (the order
    // that rankIpAddresses produces for such a machine).
    const rankedIps = [
      '192.168.1.42', // wlan0 (active)
      '100.101.102.103', // tailscale0
      '192.168.137.1', // hotspot gateway
      '172.17.0.1', // docker0
      '10.0.0.1', // wg0 hub gateway
    ];
    final vpnIps = {'100.101.102.103', '10.0.0.1'};

    test('should keep the previous behavior when the toggle is off', () {
      // VPN interfaces are not excluded today; they compete for the cut
      // like every other interface. The 6th interface would be dropped.
      expect(
        selectSmartScanInterfaces(
          rankedIps: rankedIps,
          vpnIps: vpnIps,
          includeVpnInterfaces: false,
          maxInterfaces: 3,
        ),
        ['192.168.1.42', '100.101.102.103', '192.168.137.1'],
      );
    });

    test('should cut at maxInterfaces like before', () {
      expect(
        selectSmartScanInterfaces(
          rankedIps: rankedIps,
          vpnIps: vpnIps,
          includeVpnInterfaces: false,
          maxInterfaces: 5,
        ),
        rankedIps,
      );
      expect(
        selectSmartScanInterfaces(
          rankedIps: rankedIps,
          vpnIps: vpnIps,
          includeVpnInterfaces: false,
          maxInterfaces: 2,
        ),
        ['192.168.1.42', '100.101.102.103'],
      );
    });

    test('should rank VPN interfaces to the front when the toggle is on', () {
      expect(
        selectSmartScanInterfaces(
          rankedIps: rankedIps,
          vpnIps: vpnIps,
          includeVpnInterfaces: true,
          maxInterfaces: 5,
        ),
        [
          '100.101.102.103',
          '10.0.0.1',
          '192.168.1.42',
          '192.168.137.1',
          '172.17.0.1',
        ],
      );
    });

    test('should let VPN interfaces survive the maxInterfaces cut', () {
      // The wg0 hub address is ranked last and would lose a cut of 2; with
      // the toggle on, both VPN addresses are scanned instead.
      expect(
        selectSmartScanInterfaces(
          rankedIps: rankedIps,
          vpnIps: vpnIps,
          includeVpnInterfaces: true,
          maxInterfaces: 2,
        ),
        ['100.101.102.103', '10.0.0.1'],
      );
    });

    test('should keep the relative order within the VPN and non-VPN groups', () {
      expect(
        selectSmartScanInterfaces(
          rankedIps: rankedIps,
          vpnIps: vpnIps,
          includeVpnInterfaces: true,
          maxInterfaces: 4,
        ),
        [
          '100.101.102.103', // vpn, relative ranked order kept
          '10.0.0.1', // vpn
          '192.168.1.42', // non-vpn, relative ranked order kept
          '192.168.137.1', // non-vpn
        ],
      );
    });

    test('should apply the limit after the boost when there are more VPN than allowed', () {
      expect(
        selectSmartScanInterfaces(
          rankedIps: ['10.0.0.1', '10.0.0.2', '10.0.0.3', '192.168.1.42'],
          vpnIps: {'10.0.0.1', '10.0.0.2', '10.0.0.3'},
          includeVpnInterfaces: true,
          maxInterfaces: 2,
        ),
        ['10.0.0.1', '10.0.0.2'],
      );
    });

    test('should ignore VPN addresses that are not in the ranked list', () {
      expect(
        selectSmartScanInterfaces(
          rankedIps: ['192.168.1.42', '192.168.2.42'],
          vpnIps: {'10.8.0.2'},
          includeVpnInterfaces: true,
          maxInterfaces: 5,
        ),
        ['192.168.1.42', '192.168.2.42'],
      );
    });

    test('should handle an empty ranked list', () {
      expect(
        selectSmartScanInterfaces(
          rankedIps: [],
          vpnIps: {'10.8.0.2'},
          includeVpnInterfaces: true,
          maxInterfaces: 5,
        ),
        isEmpty,
      );
    });
  });
}
