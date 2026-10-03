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

  group('shouldRebindDiscovery', () {
    test('should not rebind when the address set is unchanged', () {
      // dart:core Set has no value equality: a naive `!=` on the sets is an
      // identity comparison and would rebind on every fetch.
      expect(
        shouldRebindDiscovery(previousIps: ['192.168.1.5', '10.0.0.5'], nextIps: ['192.168.1.5', '10.0.0.5'], firstFetchDone: true),
        isFalse,
      );
    });

    test('should not rebind when the addresses are only re-ranked', () {
      expect(
        shouldRebindDiscovery(previousIps: ['192.168.1.5', '10.0.0.5'], nextIps: ['10.0.0.5', '192.168.1.5'], firstFetchDone: true),
        isFalse,
      );
    });

    test('should not rebind on duplicates appearing or disappearing', () {
      expect(
        shouldRebindDiscovery(previousIps: ['192.168.1.5', '192.168.1.5'], nextIps: ['192.168.1.5'], firstFetchDone: true),
        isFalse,
      );
    });

    test('should rebind when an address was added', () {
      expect(
        shouldRebindDiscovery(previousIps: ['192.168.1.5'], nextIps: ['192.168.1.5', '192.168.137.1'], firstFetchDone: true),
        isTrue,
      );
    });

    test('should rebind when an address was removed', () {
      expect(
        shouldRebindDiscovery(previousIps: ['192.168.1.5', '10.0.0.5'], nextIps: ['192.168.1.5'], firstFetchDone: true),
        isTrue,
      );
    });

    test('should rebind when the network appears after an offline start', () {
      // The device was offline when the discovery started (empty list after
      // the first fetch); the discovery must rebind once a network exists.
      expect(
        shouldRebindDiscovery(previousIps: [], nextIps: ['192.168.1.5'], firstFetchDone: true),
        isTrue,
      );
    });

    test('should not rebind when staying offline', () {
      expect(
        shouldRebindDiscovery(previousIps: [], nextIps: [], firstFetchDone: true),
        isFalse,
      );
    });

    test('should never rebind on the first fetch', () {
      expect(
        shouldRebindDiscovery(previousIps: [], nextIps: ['192.168.1.5'], firstFetchDone: false),
        isFalse,
      );
    });
  });
}
