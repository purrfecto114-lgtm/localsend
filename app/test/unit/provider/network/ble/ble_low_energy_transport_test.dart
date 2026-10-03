import 'package:localsend_app/provider/network/ble/ble_codec.dart';
import 'package:localsend_app/provider/network/ble/ble_low_energy_transport.dart';
import 'package:test/test.dart';

/// Tests the pure platform policy of the bluetooth_low_energy adapter.
/// The adapter itself needs a real platform channel backend and is only
/// verified statically (see the module README, "Known limits").
void main() {
  group('bleAdvertisementPayloadFor', () {
    test('Android advertises the manufacturer data beacon only', () {
      expect(
        bleAdvertisementPayloadFor(isAndroid: true, isIOS: false, isMacOS: false),
        BleAdvertisementPayload.manufacturerData,
      );
    });

    test('iOS and macOS advertise the service UUID only', () {
      expect(
        bleAdvertisementPayloadFor(isAndroid: false, isIOS: true, isMacOS: false),
        BleAdvertisementPayload.serviceUuid,
      );
      expect(
        bleAdvertisementPayloadFor(isAndroid: false, isIOS: false, isMacOS: true),
        BleAdvertisementPayload.serviceUuid,
      );
    });

    test('Windows (no android/darwin flag) gets the manufacturer data budget too', () {
      expect(
        bleAdvertisementPayloadFor(isAndroid: false, isIOS: false, isMacOS: false),
        BleAdvertisementPayload.manufacturerData,
      );
    });
  });

  group('advertisement budget', () {
    test('the beacon structure alone fits the legacy advertisement budget', () {
      // AD structure header (length + type) + company id + beacon payload.
      const adHeaderBytes = 2;
      const companyIdBytes = 2;
      expect(adHeaderBytes + companyIdBytes + bleBeaconLength, lessThanOrEqualTo(bleBeaconMaxManufacturerData));
    });

    test('service UUID and beacon together would exceed the budget (the reason for the split)', () {
      // AD structure header + 128-bit UUID.
      const uuid128StructureBytes = 2 + 16;
      const beaconStructureBytes = 2 + 2 + bleBeaconLength;
      expect(uuid128StructureBytes + beaconStructureBytes, greaterThan(bleBeaconMaxManufacturerData));
    });
  });
}
