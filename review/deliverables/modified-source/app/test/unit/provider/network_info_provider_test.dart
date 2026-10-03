import 'package:localsend_app/provider/local_ip_provider.dart';
import 'package:test/test.dart';

void main() {
  group('rankIpAddresses', () {
    test('should only sort list if no primary', () {
      expect(rankIpAddresses(['123.456', '222.1', '321.222'], null), ['123.456', '321.222', '222.1']);
    });

    test('should only take primary', () {
      expect(rankIpAddresses([], '123.123'), ['123.123']);
    });

    test('should sort primary first', () {
      expect(rankIpAddresses(['123.456', '222.1', '321.222'], '123.123'), ['123.123', '123.456', '321.222', '222.1']);
    });

    test('should sort primary first and remove duplicates', () {
      expect(rankIpAddresses(['123.456', '123.123', '222.1', '222.1', '321.222'], '123.123'), ['123.123', '123.456', '321.222', '222.1']);
    });

    test('should prefer third party hotspot gateway (".1") address', () {
      // The third party result is the address of the active Wi-Fi interface.
      // When this device provides the hotspot, that address is the gateway
      // (e.g. 192.168.43.1) and its subnet is the one whose clients must be
      // scanned, so it must not be ranked last despite ending with ".1".
      expect(rankIpAddresses(['10.0.0.5', '192.168.43.1'], '192.168.43.1'), ['192.168.43.1', '10.0.0.5']);
    });

    test('should prefer third party iOS hotspot gateway address', () {
      expect(rankIpAddresses(['10.0.0.5', '172.20.10.1'], '172.20.10.1'), ['172.20.10.1', '10.0.0.5']);
    });

    test('should still rank native ".1" addresses last when primary is another network', () {
      expect(rankIpAddresses(['123.456', '222.1'], '123.123'), ['123.123', '123.456', '222.1']);
    });
  });
}
