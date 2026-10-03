import 'dart:convert';
import 'dart:typed_data';

import 'package:localsend_app/provider/network/ble/ble_codec.dart';
import 'package:localsend_isolates/model/device.dart';
import 'package:test/test.dart';

void main() {
  group('beacon', () {
    test('roundtrips through encode and decode', () {
      final salt = Uint8List.fromList([0x01, 0x02, 0x03, 0x04]);
      final beacon = encodeBleBeacon(port: 53317, fingerprint: 'fp-abc', salt: salt);

      expect(beacon.length, bleBeaconLength);
      final decoded = decodeBleBeacon(beacon)!;
      expect(decoded.protoVer, bleBeaconProtoVer);
      expect(decoded.port, 53317);
      expect(decoded.fpHash, bleFingerprintHash('fp-abc', salt));
      expect(decoded.salt, salt);
    });

    test('stays within the manufacturer data budget', () {
      final beacon = encodeBleBeacon(port: 1234, fingerprint: 'fp', salt: Uint8List(4));
      // 31 bytes is the whole manufacturer data section of a legacy
      // advertisement; the company id takes 2 more bytes on top of this.
      expect(beacon.length, lessThanOrEqualTo(bleBeaconMaxManufacturerData));
    });

    test('clamps an out-of-range port into the 16 bit range', () {
      final salt = Uint8List.fromList([9, 9, 9, 9]);
      expect(decodeBleBeacon(encodeBleBeacon(port: 65536, fingerprint: 'fp', salt: salt))!.port, 65535);
      expect(decodeBleBeacon(encodeBleBeacon(port: 1 << 20, fingerprint: 'fp', salt: salt))!.port, 65535);
      // A non-positive port is clamped to 0, which the decoder rejects.
      expect(decodeBleBeacon(encodeBleBeacon(port: -5, fingerprint: 'fp', salt: salt)), isNull);
      expect(decodeBleBeacon(encodeBleBeacon(port: 0, fingerprint: 'fp', salt: salt)), isNull);
    });

    test('hashes the fingerprint with the salt (unlinked across salts)', () {
      final saltA = Uint8List.fromList([1, 1, 1, 1]);
      final saltB = Uint8List.fromList([2, 2, 2, 2]);

      expect(bleFingerprintHash('fp', saltA), bleFingerprintHash('fp', saltA));
      expect(bleFingerprintHash('fp', saltA), isNot(bleFingerprintHash('fp', saltB)));
      expect(bleFingerprintHash('fp', saltA), isNot(bleFingerprintHash('other', saltA)));
      expect(bleFingerprintHash('fp', saltA).length, 8);
    });

    test('hides the fingerprint: it does not appear in the beacon bytes', () {
      final fingerprint = 'super-secret-fingerprint';
      final beacon = encodeBleBeacon(port: 53317, fingerprint: fingerprint, salt: Uint8List(4));
      expect(utf8.decode(beacon, allowMalformed: true).contains(fingerprint), isFalse);
    });

    test('rejects malformed payloads', () {
      final salt = Uint8List.fromList([4, 3, 2, 1]);
      final valid = encodeBleBeacon(port: 53317, fingerprint: 'fp', salt: salt);

      expect(decodeBleBeacon(const []), isNull);
      expect(decodeBleBeacon(valid.sublist(1)), isNull); // 23 bytes
      expect(decodeBleBeacon([...valid, 0x00]), isNull); // 25 bytes

      final future = Uint8List.fromList(valid);
      future[0] = bleBeaconProtoVer + 1;
      expect(decodeBleBeacon(future), isNull);

      final zeroPort = Uint8List.fromList(valid);
      zeroPort[1] = 0x00;
      zeroPort[2] = 0x00;
      expect(decodeBleBeacon(zeroPort), isNull);
    });

    test('encodes big-endian port and a zeroed reserved area', () {
      final salt = Uint8List.fromList([0xAA, 0xBB, 0xCC, 0xDD]);
      final beacon = encodeBleBeacon(port: 0x1234, fingerprint: 'fp', salt: salt);
      expect(beacon[1], 0x12);
      expect(beacon[2], 0x34);
      expect(beacon.sublist(15), everyElement(0));
    });

    test('throws on a salt with the wrong length', () {
      expect(
        () => encodeBleBeacon(port: 1, fingerprint: 'fp', salt: Uint8List(3)),
        throwsArgumentError,
      );
    });
  });

  group('GATT device info', () {
    const info = BleDeviceInfo(
      alias: 'Fancy Device',
      fingerprint: 'fp-123',
      ip: '192.168.1.42',
      port: 53317,
      https: true,
      deviceModel: 'Pixel 8',
      deviceType: DeviceType.mobile,
      download: true,
      version: '2.2',
    );

    BleDeviceInfo? roundtrip(BleDeviceInfo value) {
      return decodeBleDeviceInfo(encodeBleDeviceInfo(value));
    }

    test('roundtrips', () {
      final decoded = roundtrip(info)!;
      expect(decoded.alias, info.alias);
      expect(decoded.fingerprint, info.fingerprint);
      expect(decoded.ip, info.ip);
      expect(decoded.port, info.port);
      expect(decoded.https, info.https);
      expect(decoded.deviceModel, info.deviceModel);
      expect(decoded.deviceType, info.deviceType);
      expect(decoded.download, info.download);
      expect(decoded.version, info.version);
    });

    test('roundtrips optional fields as null', () {
      const minimal = BleDeviceInfo(
        alias: 'a',
        fingerprint: 'f',
        ip: '10.0.0.1',
        port: 1,
        https: false,
        deviceModel: null,
        deviceType: DeviceType.headless,
        download: false,
        version: '',
      );
      final decoded = roundtrip(minimal)!;
      expect(decoded.deviceModel, isNull);
      expect(decoded.version, '');
    });

    test('normalizes an empty deviceModel to null', () {
      final decoded = decodeBleDeviceInfo(
        utf8.encode(
          '{"alias":"a","fingerprint":"f","ip":"10.0.0.1","port":1,"https":false,"deviceModel":"","deviceType":"desktop","download":false,"version":"2.2"}',
        ),
      )!;
      expect(decoded.deviceModel, isNull);
    });

    test('converts to a Device with a single HTTP channel', () {
      final device = roundtrip(info)!.toDevice();
      expect(device.ip, '192.168.1.42');
      expect(device.port, 53317);
      expect(device.https, isTrue);
      expect(device.fingerprint, 'fp-123');
      expect(device.channels, hasLength(1));
      final channel = device.channels.single as HttpChannel;
      expect(channel.host, '192.168.1.42');
      expect(channel.port, 53317);
      expect(channel.https, isTrue);
      expect(device.transmissionMethods, contains(TransmissionMethod.http));
    });

    test('is built from a Device without losing fields', () {
      final device = roundtrip(info)!.toDevice();
      final rebuilt = roundtrip(BleDeviceInfo.fromDevice(device))!;
      expect(rebuilt.alias, info.alias);
      expect(rebuilt.deviceType, info.deviceType);
    });

    test('accepts only IP literals as the ip field', () {
      // The GATT payload comes from an unrelated device in radio range,
      // so the ip must be a literal the announcer can serve on - host
      // names would let a spoofed peer redirect the file transfer.
      BleDeviceInfo withIp(String ip) => BleDeviceInfo(
        alias: info.alias,
        fingerprint: info.fingerprint,
        ip: ip,
        port: info.port,
        https: info.https,
        deviceModel: info.deviceModel,
        deviceType: info.deviceType,
        download: info.download,
        version: info.version,
      );

      const accepted = [
        '192.168.1.42', // IPv4
        '10.0.0.1',
        'fd00::1', // IPv6
        '::1',
        'fe80::1%3', // scoped IPv6 (zone id preserved)
        'fe80::1%eth0',
      ];
      for (final ip in accepted) {
        expect(decodeBleDeviceInfo(encodeBleDeviceInfo(withIp(ip))), isNotNull, reason: ip);
      }

      String mutateIp(String ip) {
        final map = jsonDecode(utf8.decode(encodeBleDeviceInfo(info))) as Map<String, dynamic>;
        map['ip'] = ip;
        return jsonEncode(map);
      }

      const rejected = [
        'example.com', // host name
        'banana',
        '[::1]', // bracketed form (accepted for manual input, not here)
        '192.168.1.42:53317', // port suffix
        'http://192.168.1.42', // scheme
        ' 192.168.1.42', // whitespace
        '0177.0.0.1', // leading zeros (Dart rejects as IPv4)
      ];
      for (final ip in rejected) {
        expect(decodeBleDeviceInfo(utf8.encode(mutateIp(ip))), isNull, reason: ip);
      }
    });

    test('tolerates unknown extra fields', () {
      final raw = utf8.decode(encodeBleDeviceInfo(info));
      final extended = raw.replaceFirst('}', ',"futureField":42}');
      expect(decodeBleDeviceInfo(utf8.encode(extended)), isNotNull);
    });

    test('rejects malformed payloads', () {
      final valid = encodeBleDeviceInfo(info);

      expect(decodeBleDeviceInfo(const []), isNull);
      expect(decodeBleDeviceInfo(Uint8List(2049)), isNull);
      expect(decodeBleDeviceInfo(utf8.encode('not json')), isNull);
      expect(decodeBleDeviceInfo(utf8.encode('[1,2,3]')), isNull);
      expect(
        decodeBleDeviceInfo(
          Uint8List.fromList([0xFF, 0xFE, 0x80]),
        ),
        isNull,
      ); // invalid UTF-8

      String mutate(String key, Object? value) {
        final map = jsonDecode(utf8.decode(valid)) as Map<String, dynamic>;
        if (value == null) {
          map.remove(key);
        } else {
          map[key] = value;
        }
        return jsonEncode(map);
      }

      expect(decodeBleDeviceInfo(utf8.encode(mutate('alias', null))), isNull);
      expect(decodeBleDeviceInfo(utf8.encode(mutate('alias', ''))), isNull);
      expect(decodeBleDeviceInfo(utf8.encode(mutate('alias', 42))), isNull);
      expect(decodeBleDeviceInfo(utf8.encode(mutate('fingerprint', ''))), isNull);
      expect(decodeBleDeviceInfo(utf8.encode(mutate('ip', ''))), isNull);
      expect(decodeBleDeviceInfo(utf8.encode(mutate('ip', null))), isNull);
      expect(decodeBleDeviceInfo(utf8.encode(mutate('port', 0))), isNull);
      expect(decodeBleDeviceInfo(utf8.encode(mutate('port', 65536))), isNull);
      expect(decodeBleDeviceInfo(utf8.encode(mutate('port', '53317'))), isNull);
      expect(decodeBleDeviceInfo(utf8.encode(mutate('https', 'yes'))), isNull);
      expect(decodeBleDeviceInfo(utf8.encode(mutate('deviceType', 'toaster'))), isNull);
      expect(decodeBleDeviceInfo(utf8.encode(mutate('deviceType', null))), isNull);
      expect(decodeBleDeviceInfo(utf8.encode(mutate('deviceModel', 7))), isNull);
      expect(decodeBleDeviceInfo(utf8.encode(mutate('download', 1))), isNull);
      expect(decodeBleDeviceInfo(utf8.encode(mutate('version', 2.2))), isNull);
    });
  });
}
