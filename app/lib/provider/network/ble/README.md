# BLE-assisted discovery (phase 1)

This module adds an opt-in discovery path for networks where multicast does
not work (AP isolation, guest Wi-Fi, restricted corporate networks — upstream
issues #850 and #144). Bluetooth Low Energy is only used to **find** peers
and exchange their IP:port; the file transfer itself always goes over the
regular HTTP v2 protocol, byte-for-byte unchanged. This mirrors AirDrop
(BLE discovery → AWDL transfer), Windows Nearby Sharing (MS-CDP: a 30-byte
BLE beacon → transport over LAN/BT/WiFi Direct) and Quick Share.

## Design

```
app/lib/provider/network/ble/
  ble_codec.dart               # pure dart: 24 byte beacon + GATT JSON codec
  ble_transport.dart           # BleTransport interface + inert NoopBleTransport
  ble_low_energy_transport.dart# bluetooth_low_energy adapter (central+peripheral)
  ble_discovery.dart           # BleDiscoveryService orchestration
  ble_discovery_provider.dart  # refena providers (feature-flag gated)
```

Everything lives on the app-side main isolate (platform channels cannot run
in the child isolate as spawned here), and nothing here touches
`localsend_isolates` or the Rust side. A discovered peer is fed through the
existing injection seam (`IsolateDiscoveryAddDeviceAction` — the same one the
HTTP `/register` request uses), merged by the Rust discovery store and
re-emitted by the running discovery listener, so the send flow, progress UI
and session model are untouched.

Wire format:

- **Beacon** (manufacturer data, 24 bytes, MS-CDP scale):
  `protoVer (1) | port (2, BE) | fpHash (8) | salt (4) | reserved (9)`.
  `fpHash = SHA-256(fingerprint || salt)[0..8]`.
- **GATT characteristic** `2e1b0bc9-...`: UTF-8 JSON with
  `alias, fingerprint, ip, port, https, deviceModel, deviceType, download,
  version` (a superset of the multicast announcement fields; the IP is
  mandatory because the Rust store drops devices without one, and it must
  be an IP literal — see the security notes).
- **Service UUID** `c5945864-...`: advertised by iOS/macOS peers (the darwin
  stack drops manufacturer data from app advertisements, so the UUID is the
  only marker there) and matched by every scanner. Android/Windows peers
  cannot carry it next to the beacon (see the advertisement budget below)
  and are recognized by the company id instead.
- **Company id** `0xFFFF`: reserved-for-development. Register a real
  Bluetooth SIG company id before any wider rollout.

Advertisement budget: a legacy BLE advertisement has 31 bytes for all its AD
structures. The beacon structure (header + company id + payload) costs 28
and a 128-bit service UUID costs 18, so carrying both would fail with
`ADVERTISE_FAILED_DATA_TOO_LARGE` (observed on Android). The payload is
therefore split per platform: Android and Windows advertise the manufacturer
data beacon only, iOS/macOS the service UUID only. Scanning consequently
runs unfiltered (`startDiscovery` with an empty UUID list is a full scan on
all backends) and the Dart-side filter recognizes both markers.

The beacon layout under company id `0xFFFF` deliberately matches none of the
formats (iBeacon, AltBeacon, Eddystone) that Android filters from the scan
results of apps asserting `neverForLocation` — the assertion this app makes
to keep the BLE scan location-free. Confirming that on the real-device
matrix is part of the open verification work below.

## Security notes

- The certificate fingerprint never travels in clear text over the air: the
  beacon carries only `SHA-256(fingerprint || salt)` with a fresh random
  salt that is rotated every 90 seconds while advertising, so a passive
  listener can neither recover the fingerprint nor track a device for
  longer than one rotation interval (same scheme as MS-CDP, which rotates
  per advertising session; the shorter period also breaks long-session
  linkability).
- The GATT characteristic is readable without pairing, like the beacon, so
  it must not contain secrets. It carries the same fields a multicast
  announcement broadcasts to the whole network, plus the sender's IP: a
  multicast listener derives that address from the UDP source, a BLE
  scanner cannot, so the payload has to include it. Because the payload
  comes from an unrelated device in radio range, the decoder accepts IP
  literals only (IPv4/IPv6, optionally scoped like `fe80::1%3`) — a host
  name must never be able to redirect a file transfer to an arbitrary
  server.
- Self-detection recomputes the salted hash with the own fingerprint, and a
  GATT payload claiming the own fingerprint is dropped.
- Scan flooding is mitigated at three layers: hits weaker than −80 dBm are
  dropped, at most one GATT handshake is in flight (a hit arriving meanwhile
  is dropped and picked up by that peer's next advertisement, not queued),
  and the per-remote cooldown bookkeeping is capped at 128 entries (LRU), so
  an attacker spoofing many remote ids cannot grow memory or connection
  work without bounds.

## Enabling it

The feature flag `ls_ble_discovery_enabled` (advanced settings, default
**off**) gates the whole module. While it is off the real transport is never
constructed: zero platform API calls, zero permissions requested, zero
behavior difference. Toggling it starts/stops the discovery at runtime.

**Both devices must run this fork with the flag on** — upstream LocalSend
does not advertise a BLE beacon, so a fork device cannot discover a stock
one over Bluetooth. The file transfer itself always goes over the network;
BLE only bridges the discovery when the network blocks multicast.

### Status surfacing (fork.3)

The module is observable in the UI, not only in the logs:

- `BleDiscoveryService` runs a `BleDiscoveryStatus` state machine
  (`disabled` / `active` / `activeScanOnly` / `paused` /
  `permissionDenied` / `adapterOff` / `unsupportedPlatform` / `error`)
  and publishes every transition on `statusStream`.
- The settings tab shows the live status under the toggle. A permission
  denial additionally offers "Open system settings" (the plugin's
  `showAppSettings()`, Android/iOS).
- The discovery empty state spells out the fork-to-fork requirement while
  BLE is active, so "no devices found" is not misread as "not implemented".
- The transport refuses to touch the radio while the adapter is off,
  unauthorized or unsupported (`BleAdapterUnavailableException`), and a
  denied runtime permission throws `BlePermissionDeniedException`; the
  service maps both to their statuses instead of pretending to run.
- The adapter state is followed while the module is enabled: switched off
  mid-session stops the scan (`adapterOff`), switched back on restarts the
  discovery — but never while the app is lifecycle-paused (the radio work
  stays strictly foreground; the resume transition restarts it). The gate
  waits for the first definitive `stateChanged` event while the cached state
  is still `unknown` (the backends fill it asynchronously at manager
  construction), and a fresh successful Android `authorize()` outranks a
  stale `unauthorized` cache right after the permission grant.
- An `unauthorized` adapter (the app's Bluetooth permission was denied,
  e.g. on iOS) is reported as `permissionDenied` with the settings
  shortcut, not as a radio problem.
- A transport that cannot even be constructed fails loudly into the
  `error` status instead of silently running on an inert noop transport.
- `stop(paused: true)` (app lifecycle) reports `paused` and the resume
  transition restarts the discovery.

While it is on, the discovery follows the app lifecycle on mobile: it is
stopped when the app is paused and restarted when it resumes, keeping the
radio work strictly foreground (see `main.dart`).

The required platform permission **declarations ship with the app** (they
are dormant metadata until the flag is turned on — declarations alone
trigger no prompt and no API access; only the runtime request started by
enabling the flag does):

- **Android** (`AndroidManifest.xml`): `BLUETOOTH_SCAN`
  (`neverForLocation`: the scan results are never used to derive a
  location), `BLUETOOTH_ADVERTISE`, `BLUETOOTH_CONNECT`, plus the legacy
  `BLUETOOTH`/`BLUETOOTH_ADMIN` with `maxSdkVersion="30"`, and
  `android.hardware.bluetooth_le` as a non-required feature. If the
  runtime request is denied, the plugin's `authorize()` returns false, BLE
  logs it and stays off.
- **iOS** (`Info.plist`): `NSBluetoothAlwaysUsageDescription`. This key is
  mandatory hardware-side: touching CoreBluetooth without it terminates
  the app, which is exactly why it ships instead of being left to anyone
  compiling a "BLE-enabled" variant. No background modes: phase 1 only
  runs while the app is in the foreground, which matches the "receiving
  requires an open app" model anyway.
- **macOS** (Debug and Release entitlements):
  `com.apple.security.device.bluetooth` (the app is sandboxed), plus
  `NSBluetoothAlwaysUsageDescription` in `Runner/Info.plist` (mandatory on
  macOS 10.15+; without it CoreBluetooth refuses the connection).
- **Windows**: no manifest change; the OS may require location to be
  enabled for BLE. Watch out for `ResourceInUse` when the system's Nearby
  Sharing occupies the advertising radio — the failure is caught and
  logged, and scanning still works.
- **Linux**: scanning works (BlueZ central), but bluetooth_low_energy has
  no peripheral API, so a Linux device can find others but cannot be found
  via BLE. `supportsAdvertising` reports false and advertising is skipped.

## Dependencies

`bluetooth_low_energy: ^6.2.1` (MIT, publisher zeekr.dev) is the only
addition: one package covering both the central and the peripheral role.
`flutter_blue_plus` was rejected (non-OSI license since 2.0.0, build-time
license ping since 2.3.5, central-only). Track the 7.x pre-release line
for breaking changes before upgrading.

## Known limits (honesty section)

- **Android 7+ (SDK >= 24).** The app itself installs from Android 7.0
  (the Flutter engine's `flutter.minSdkVersion` is 24), and since fork.4
  the BLE module follows: on Android 7–11 (API 24–30) the plugin's
  `authorize()` requests `ACCESS_COARSE_LOCATION`/`ACCESS_FINE_LOCATION`,
  which the app declares for exactly those API levels
  (`maxSdkVersion="30"` in the manifest; Android 12+ uses the
  `BLUETOOTH_SCAN` `neverForLocation` path instead). Two caveats are
  surfaced to the user: the location permission dialog appears when
  enabling the feature on those versions, and scan results are only
  delivered while the system location services are turned on — the
  settings toggle shows a dedicated hint. Below SDK 24 the plugin has no
  backend at all; the discovery service detects it and reports
  `unsupportedPlatform` (the transport provider double-gates with a log
  line) instead of letting it die silently.
- **Android/Windows advertise the beacon only** (manufacturer data, no
  service UUID): both together exceed the 31-byte legacy advertisement
  budget. Scanners therefore run unfiltered and match on the company id;
  see "Advertisement budget" above.
- The advertising payload (IP, port, alias) is captured when the discovery
  starts and is not refreshed when the network changes mid-session; a
  restart of the app (or toggling the flag) picks up the new address.
- The GATT handshake is serialized (one connection at a time) and at most
  one is in flight; a crowd of peers takes correspondingly longer to
  appear, and a hit landing during a handshake waits for that peer's next
  advertisement.
- Devices found via BLE but unreachable over unicast (full client
  isolation) show up and fail on send, like a manual favorite would.
- This fork is developed in a headless environment without Bluetooth
  hardware: the module is verified by `flutter analyze` + `flutter test`
  (codec roundtrips, orchestration with a fake transport, flag gating)
  only. The radio behavior (per-platform advertising visibility, the
  neverForLocation beacon filtering, Windows Nearby Sharing conflicts,
  Android vendor stacks) needs a real-device matrix before any product
  claim — see the fork ROADMAP
  "Verification honesty" section.
- Phase 2 (small-text fallback transfer over GATT) and phase 3 (BLE large
  files) are explicitly out of scope here; see
  `review/research/bluetooth-report.md` for the throughput evidence
  (0.1–0.5 MB/s phone-to-phone) behind that decision.
