import 'package:localsend_app/util/address_input_validator.dart';
import 'package:test/test.dart';

void main() {
  group('parseManualAddress IPv4', () {
    test('plain IPv4', () {
      final (address, error) = parseManualAddress('192.168.1.5');
      expect(error, isNull);
      expect(address?.type, ManualAddressType.ipv4);
      expect(address?.host, '192.168.1.5');
    });

    test('surrounding whitespace is trimmed', () {
      final (address, error) = parseManualAddress('  8.8.8.8  ');
      expect(error, isNull);
      expect(address?.host, '8.8.8.8');
    });

    test('incomplete IPv4 is rejected', () {
      expect(parseManualAddress('192.168.1').$1, isNull);
      expect(parseManualAddress('192.168.1').$2, ManualAddressError.invalid);
    });

    test('out-of-range octets are rejected', () {
      expect(parseManualAddress('192.168.1.256').$1, isNull);
      expect(parseManualAddress('999.1.1.1').$1, isNull);
    });

    test('leading zeros are rejected', () {
      expect(parseManualAddress('192.168.01.5').$1, isNull);
    });
  });

  group('parseManualAddress IPv6', () {
    test('loopback', () {
      final (address, error) = parseManualAddress('::1');
      expect(error, isNull);
      expect(address?.type, ManualAddressType.ipv6);
      expect(address?.host, '::1');
    });

    test('link-local', () {
      final (address, error) = parseManualAddress('fe80::1');
      expect(error, isNull);
      expect(address?.type, ManualAddressType.ipv6);
      expect(address?.host, 'fe80::1');
    });

    test('bracketed IPv6 is accepted and normalized', () {
      final (address, error) = parseManualAddress('[::1]');
      expect(error, isNull);
      expect(address?.type, ManualAddressType.ipv6);
      expect(address?.host, '::1');
    });

    test('scoped (zone id) IPv6 keeps its scope', () {
      final (address, error) = parseManualAddress('fe80::1%3');
      expect(error, isNull);
      expect(address?.host, 'fe80::1%3');
    });

    test('long form is accepted and passed through', () {
      // Dart's InternetAddress does not rewrite IPv6 text, so the entered
      // form reaches the request unchanged (it is a valid literal).
      final (address, error) = parseManualAddress('2001:0db8:0000:0000:0000:0000:0000:0001');
      expect(error, isNull);
      expect(address?.host, '2001:0db8:0000:0000:0000:0000:0000:0001');
    });

    test('IPv4-mapped IPv6', () {
      final (address, error) = parseManualAddress('::ffff:192.168.1.5');
      expect(error, isNull);
      expect(address?.type, ManualAddressType.ipv6);
    });

    test('brackets around an IPv4 address are rejected', () {
      expect(parseManualAddress('[192.168.1.5]').$1, isNull);
      expect(parseManualAddress('[192.168.1.5]').$2, ManualAddressError.invalid);
    });

    test('malformed brackets are rejected', () {
      expect(parseManualAddress('[]').$1, isNull);
      expect(parseManualAddress('[::1]extra').$1, isNull);
      expect(parseManualAddress('[fe80::').$1, isNull);
    });
  });

  group('parseManualAddress host names', () {
    test('simple host name', () {
      final (address, error) = parseManualAddress('my-pc');
      expect(error, isNull);
      expect(address?.type, ManualAddressType.hostname);
      expect(address?.host, 'my-pc');
    });

    test('mDNS style host name', () {
      final (address, error) = parseManualAddress('my-pc.local');
      expect(error, isNull);
      expect(address?.host, 'my-pc.local');
    });

    test('host names are lowercased', () {
      final (address, error) = parseManualAddress('MY-PC.LOCAL');
      expect(error, isNull);
      expect(address?.host, 'my-pc.local');
    });

    test('FQDN trailing dot is stripped', () {
      final (address, error) = parseManualAddress('my-pc.local.');
      expect(error, isNull);
      expect(address?.host, 'my-pc.local');
    });

    test('underscores are rejected', () {
      expect(parseManualAddress('my_pc.local').$1, isNull);
    });

    test('leading and trailing hyphens are rejected', () {
      expect(parseManualAddress('-abc.local').$1, isNull);
      expect(parseManualAddress('abc-.local').$1, isNull);
    });

    test('labels longer than 63 characters are rejected', () {
      expect(parseManualAddress('a' * 64 + '.local').$1, isNull);
    });

    test('host names longer than 253 characters are rejected', () {
      final name = List.filled(38, 'abcdefghij').join('.'); // 38*11-1 = 417 -> too long
      expect(name.length, greaterThan(253));
      expect(parseManualAddress(name).$1, isNull);
    });

    test('all-numeric labels are rejected (incomplete IPv4)', () {
      expect(parseManualAddress('192.168.1').$1, isNull);
      expect(parseManualAddress('12345').$1, isNull);
    });
  });

  group('parseManualAddress rejected forms', () {
    test('empty and whitespace input', () {
      final (address, error) = parseManualAddress('');
      expect(address, isNull);
      expect(error, isNull);
      final (address2, error2) = parseManualAddress('   ');
      expect(address2, isNull);
      expect(error2, isNull);
    });

    test('scheme prefixes', () {
      expect(parseManualAddress('http://192.168.1.5').$2, ManualAddressError.scheme);
      expect(parseManualAddress('https://my-pc.local').$2, ManualAddressError.scheme);
    });

    test('host:port forms', () {
      expect(parseManualAddress('192.168.1.5:53317').$2, ManualAddressError.port);
      expect(parseManualAddress('my-pc.local:8080').$2, ManualAddressError.port);
      expect(parseManualAddress('[::1]:53317').$2, ManualAddressError.port);
    });

    test('garbage', () {
      expect(parseManualAddress('not a host').$1, isNull);
      expect(parseManualAddress('fe80:::1').$1, isNull);
      expect(parseManualAddress(':::').$1, isNull);
      expect(parseManualAddress('%').$1, isNull);
    });
  });

  group('buildHashtagCandidates', () {
    test('builds one candidate per unique IPv4 prefix', () {
      final candidates = buildHashtagCandidates(['192.168.1.5', '192.168.2.5', '10.0.0.7'], '123');
      expect(candidates, ['192.168.1.123', '192.168.2.123', '10.0.0.123']);
    });

    test('deduplicates shared prefixes', () {
      final candidates = buildHashtagCandidates(['192.168.1.5', '192.168.1.9'], '42');
      expect(candidates, ['192.168.1.42']);
    });

    test('IPv6 local addresses are skipped', () {
      final candidates = buildHashtagCandidates(['fe80::1', '192.168.1.5', '::1'], '123');
      expect(candidates, ['192.168.1.123']);
    });

    test('empty interface list yields no candidates', () {
      expect(buildHashtagCandidates([], '123'), isEmpty);
    });
  });
}
