import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:crypto/crypto.dart';
import 'package:localsend_isolates/model/device.dart';

/// Codec for the BLE-assisted discovery payloads (phase 1).
///
/// Wire format:
/// - The BLE advertisement carries a 24 byte beacon in its manufacturer
///   data section (the same order of magnitude as MS-CDP's Nearby Sharing
///   beacon): a protocol version, the advertised HTTP port, a salted hash
///   of the device fingerprint and the salt itself. The fingerprint never
///   travels in clear text because advertisements are visible to everyone
///   in radio range.
/// - The full device description is exchanged over GATT: the scanner
///   connects and reads a dedicated characteristic whose value is a small
///   UTF-8 JSON document. This is the payload that ends up as a [Device]
///   in the regular (HTTP) discovery store, so it must contain a reachable
///   IP address.

/// The BLE discovery service UUID advertised and scanned for.
/// Generated once for this fork; do not change it without coordinating the
/// scanner filter (old beacons would become invisible).
const bleServiceUuidString = 'c5945864-cad2-425c-b03c-656e98007fab';

/// The UUID of the GATT characteristic holding the device info JSON.
const bleCharacteristicUuidString = '2e1b0bc9-5251-4cf0-b7e4-85532ff20f12';

/// The Bluetooth SIG company id used in the manufacturer data section.
/// 0xFFFF is reserved for development; a registered company id should be
/// used before any wider rollout (see the module README).
const bleManufacturerId = 0xFFFF;

/// The beacon protocol version understood by this build.
const bleBeaconProtoVer = 1;

/// The fixed length of the beacon payload.
const bleBeaconLength = 24;

/// BLE legacy advertising leaves 31 bytes per advertisement PDU for the
/// manufacturer data section (which itself starts with the 2 byte company
/// id), so the beacon payload must stay within this budget.
const bleBeaconMaxManufacturerData = 31;

/// The maximum accepted length of a GATT device-info payload. The real
/// payloads are a few hundred bytes; anything larger is treated as corrupt.
const bleGattPayloadMaxLength = 2048;

/// The decoded 24 byte beacon payload.
class BleBeacon {
  const BleBeacon({
    required this.protoVer,
    required this.port,
    required this.fpHash,
    required this.salt,
  });

  /// The beacon protocol version ([bleBeaconProtoVer]).
  final int protoVer;

  /// The HTTP port the advertising device serves on (a hint; the GATT
  /// payload is authoritative).
  final int port;

  /// The 8 byte salted hash of the advertising device's fingerprint.
  final Uint8List fpHash;

  /// The 4 byte salt the hash was computed with.
  final Uint8List salt;
}

/// Computes the beacon fingerprint hash: the first 8 bytes of
/// `SHA-256(fingerprint || salt)`.
///
/// The salt makes the advertised hash unlinkable across advertising
/// sessions (a passive listener cannot track the fingerprint, MS-CDP uses
/// the same scheme) while a scanner that already knows a fingerprint can
/// still verify a match by recomputing with the beacon's salt.
Uint8List bleFingerprintHash(String fingerprint, List<int> salt) {
  final digest = sha256.convert([...utf8.encode(fingerprint), ...salt]);
  return Uint8List.fromList(digest.bytes.sublist(0, 8));
}

/// Encodes the 24 byte beacon payload.
///
/// [port] is clamped into the representable unsigned 16 bit range; the
/// caller is expected to pass a real server port (the discovery service
/// skips advertising entirely when it has none).
///
/// Throws an [ArgumentError] when [salt] is not exactly 4 bytes.
Uint8List encodeBleBeacon({
  required int port,
  required String fingerprint,
  required Uint8List salt,
}) {
  if (salt.length != 4) {
    throw ArgumentError.value(salt.length, 'salt.length', 'must be exactly 4 bytes');
  }
  final bytes = Uint8List(bleBeaconLength); // zero-initialized; reserved stays 0
  bytes[0] = bleBeaconProtoVer;
  ByteData.sublistView(bytes).setUint16(1, port.clamp(0, 0xFFFF), Endian.big);
  bytes.setRange(3, 11, bleFingerprintHash(fingerprint, salt));
  bytes.setRange(11, 15, salt);
  return bytes;
}

/// Decodes a 24 byte beacon payload.
///
/// Returns `null` when the payload is malformed: wrong length, an
/// unsupported protocol version or a zero port. The reserved bytes are
/// ignored so future minor extensions stay decodable.
BleBeacon? decodeBleBeacon(List<int> data) {
  if (data.length != bleBeaconLength) {
    return null;
  }
  final bytes = Uint8List.fromList(data);
  final protoVer = bytes[0];
  if (protoVer != bleBeaconProtoVer) {
    return null;
  }
  final port = ByteData.sublistView(bytes).getUint16(1, Endian.big);
  if (port == 0) {
    return null;
  }
  return BleBeacon(
    protoVer: protoVer,
    port: port,
    fpHash: Uint8List.sublistView(bytes, 3, 11),
    salt: Uint8List.sublistView(bytes, 11, 15),
  );
}

/// The device description exchanged over the GATT characteristic,
/// mirroring the fields of the multicast/register announcements.
class BleDeviceInfo {
  const BleDeviceInfo({
    required this.alias,
    required this.fingerprint,
    required this.ip,
    required this.port,
    required this.https,
    required this.deviceModel,
    required this.deviceType,
    required this.download,
    required this.version,
  });

  final String alias;
  final String fingerprint;
  final String ip;
  final int port;
  final bool https;
  final String? deviceModel;
  final DeviceType deviceType;
  final bool download;
  final String version;

  factory BleDeviceInfo.fromDevice(Device device) {
    return BleDeviceInfo(
      alias: device.alias,
      fingerprint: device.fingerprint,
      ip: device.ip ?? '',
      port: device.port,
      https: device.https,
      deviceModel: device.deviceModel,
      deviceType: device.deviceType,
      download: device.download,
      version: device.version,
    );
  }

  /// Builds the [Device] fed into the regular discovery store. The Rust
  /// store skips devices without an IP, so the payload decoder guarantees
  /// a non-empty one.
  Device toDevice() {
    return Device(
      signalingId: null,
      ip: ip,
      version: version,
      port: port,
      https: https,
      fingerprint: fingerprint,
      alias: alias,
      deviceModel: deviceModel,
      deviceType: deviceType,
      download: download,
      channels: [HttpChannel(host: ip, port: port, https: https)],
    );
  }
}

/// Encodes the GATT device-info payload as UTF-8 JSON.
Uint8List encodeBleDeviceInfo(BleDeviceInfo info) {
  final json = jsonEncode({
    'alias': info.alias,
    'fingerprint': info.fingerprint,
    'ip': info.ip,
    'port': info.port,
    'https': info.https,
    'deviceModel': info.deviceModel,
    'deviceType': info.deviceType.name,
    'download': info.download,
    'version': info.version,
  });
  return Uint8List.fromList(utf8.encode(json));
}

/// Decodes a GATT device-info payload.
///
/// Returns `null` when the payload is malformed in any way: not valid
/// UTF-8, not a JSON object, wrong or missing field types, an empty
/// alias/fingerprint, an [BleDeviceInfo.ip] that is not an IP literal
/// (IPv4 or IPv6, optionally scoped like `fe80::1%3` - host names are
/// rejected, see below), a port outside 1..65535 or an unknown device
/// type. Unknown extra fields are ignored (forward compatibility).
///
/// The ip validation is deliberately stricter than the manual address
/// input: the payload comes from an unrelated device in radio range, so it
/// must never be able to redirect the file transfer to an arbitrary host -
/// only literals the announcing device can actually serve on are accepted.
BleDeviceInfo? decodeBleDeviceInfo(List<int> data) {
  if (data.isEmpty || data.length > bleGattPayloadMaxLength) {
    return null;
  }
  final String json;
  final dynamic decoded;
  try {
    json = utf8.decode(data);
    decoded = jsonDecode(json);
  } catch (_) {
    return null;
  }
  if (decoded is! Map) {
    return null;
  }

  final alias = decoded['alias'];
  final fingerprint = decoded['fingerprint'];
  final ip = decoded['ip'];
  final port = decoded['port'];
  final https = decoded['https'];
  final deviceModel = decoded['deviceModel'];
  final deviceType = decoded['deviceType'];
  final download = decoded['download'];
  final version = decoded['version'];

  if (alias is! String || alias.isEmpty) return null;
  if (fingerprint is! String || fingerprint.isEmpty) return null;
  if (ip is! String || ip.isEmpty) return null;
  if (InternetAddress.tryParse(ip) == null) {
    // Not an IP literal: reject the whole payload. Unlike the manual
    // address input, a BLE peer is not trusted with host names (it could
    // point the file transfer at any server on the internet).
    return null;
  }
  if (port is! int || port < 1 || port > 0xFFFF) return null;
  if (https is! bool) return null;
  if (deviceModel is! String?) return null;
  final normalizedDeviceModel = deviceModel == null || deviceModel.isEmpty ? null : deviceModel;
  if (deviceType is! String) return null;
  final parsedDeviceType = DeviceType.values.firstWhereOrNull((type) => type.name == deviceType);
  if (parsedDeviceType == null) return null;
  if (download is! bool) return null;
  if (version is! String) return null;

  return BleDeviceInfo(
    alias: alias,
    fingerprint: fingerprint,
    ip: ip,
    port: port,
    https: https,
    deviceModel: normalizedDeviceModel,
    deviceType: parsedDeviceType,
    download: download,
    version: version,
  );
}
