# Fork Roadmap

Evidence-based, feasibility-ranked backlog for this LocalSend fork.
Research date: 2026-10-03. Baseline: upstream `9529e915` (app 1.18.2+64). At research time, `origin/main == 9529e915` (zero upstream drift) and the latest upstream release is v1.18.2 (2026-08-21).

Branch model:

- `radical` (Track B, default) — all fixes plus community-driven features. Evolves.
- `conservative` (Track A) — P0 fixes + MulticastLock + discovery logging only. Upstream-PR-shaped.
- Both branches keep the official v2 network protocol byte-for-byte unchanged.

Full research evidence (Chinese, with per-claim sources) is archived under [`review/research/`](review/research/):

| File | Scope |
|---|---|
| `review/research/defects-report.md` | Upstream issue mining (GitHub API + web), symptom/root-cause/feasibility per item |
| `review/research/bluetooth-report.md` | Bluetooth (BLE/classic) fit assessment for discovery & transfer, plugin/license landscape, integration design |
| `review/research/staleness-report.md` | Upstream drift, dependency staleness (`flutter pub outdated` + pub.dev API), deprecated-API grep, site deps |

## Feasibility rubric

- **High** — pure Dart-side, fully verifiable by our gates (`flutter pub get` + `flutter analyze` + `flutter test` + `dart format --set-exit-if-changed`), no protocol change.
- **Medium** — Dart-side but wide blast radius, needs codegen/platform config, or runtime aspects we cannot verify in this environment (no GUI, no devices).
- **Low** — requires Rust/FRB changes (no Rust toolchain in this environment), real hardware, or official v2 protocol changes. Excluded from this fork's scope.

## Delivered in v1.18.2-fork.1

Plus the earlier P0 discovery-robustness batch (settings-change discovery restart, Android resume rebinding, external-IP ranking, rebind-window fix, release-mode observer) — see CHANGELOG `v1.18.2-fork.1` for the full list.

| Item | Evidence | Feasibility | Status |
|---|---|---|---|
| BLE-assisted discovery, phase 1 (beacon + GATT handshake → existing HTTP channel via `IsolateDiscoveryAddDeviceAction`; feature-flagged, default off; `bluetooth_low_energy ^6.2.1`, MIT) | #850 (51👍), #144 (35👍); AirDrop/MS-CDP/Quick Share all use BLE for discovery only; design in `review/research/bluetooth-report.md` §5 | High (gates) / needs device matrix for behavior | merged |
| Server-bind failure → actionable error dialog (errno 10013 family: excluded port ranges, winsock reset, port change hints) | #125 (22👍/59c), #2884, #2746 | High | merged |
| Manual address input validation + IPv6 literal support | #549 (37👍, highest-voted open issue) | High | merged |
| Friendly + retryable errors for favorites/manual connect (timeout/refused/forbidden mapping) | #2121 (15c) | High | merged |
| Empty device list: layer-4 guidance CTA (favorites / manual input) on top of existing 3-layer diagnosis | #3319 (11c), #527 | High | merged |
| Dependency refresh: non-gated minor/patch batch (url_launcher, slang, pool, share_handler, glob, image, mime, nanoid2, uri_content), refena_flutter 3.6.0, flutter_markdown → flutter_markdown_plus | staleness report §3–§4 | High | merged |

Two originally planned items were dropped after evidence-based pushback (details in `review/research/staleness-report.md` §3.2–§3.3):

- `wakelock_plus` 1.7.0 — blocked: it requires `win32 >=6.0.0`, which `win32_registry 2.1.0` transitively pins to `^5.11.0`. Needs the `win32_registry` 3.x bundle (API adaptation in `autostart_helper.dart`); moved to the Next-up list.
- cherry-pick `102f9894` (hi/ur translation fix) — per-hunk comparison proved all 5 fixes already exist in our baseline (upstream got the same content via a later Weblate sync; only diff shape differs). No-op, skipped.

## Next up (ranked)

| # | Item | Evidence | Feasibility | Notes |
|---|---|---|---|---|
| 1 | Transfer-complete view: show checksum verification status | #3441, #3425 | High | Pure UI; low-cost mitigation for integrity disputes (checksums are computed since v1.18.0) |
| 2 | "Include VPN/tun interfaces" scan toggle | #1598 (7👍/23c), #1123 (Tailscale) | Medium | Copy the maxInterfaces settings pattern; cannot verify without a VPN environment |
| 3 | IPv4-priority local-IP ranking for hotspot scenarios | #3509 (2026-10-03) | Medium | Upstream 2023 draft `feature/improve-local-ip-ranking` is a useful reference; needs real hotspot validation |
| 4 | iOS Share Sheet stuck on stale "Finished" screen | #3197 | Medium | State reset is testable; entry-point behavior needs a device |
| 5 | Subnet > /24 scan range (legacy IP scan fallback) | #525 (7c, rolls up #175/#199/#201/#221) | Medium | Needs rate-limited/concurrent enumeration design |
| 6 | "Delete source files after send" option | #1918 | Medium | Send-controller success callback + setting + confirm UI |
| 7 | Manual "clear cache" entry in settings | #2926 | High (build) / Low (root cause) | Swelling source is likely iOS extension/engine cache; needs a device to locate it |
| 8 | Linux autostart robustness | #1927 (17👍), #3064, #3421 | Medium | Desktop-file/platform config; no GUI here to verify |
| 9 | `--hidden` launch still receives files (Linux) | #3055 (10c) | Medium | Dart lifecycle logic; needs desktop verification |
| 10 | Xiaomi HyperOS picker NoPermissionDialog → system photo picker | #3065, #3459 | Medium | Dependency swap; needs device regression |
| 11 | `wakelock_plus` 1.7.0 + `win32_registry` 3.0.3 bundle | staleness report §3.2/§3.3 | Medium | Transitive `win32 <6` lock; requires `autostart_helper.dart` API adaptation, Windows behavior unverifiable here |

## Watch-list (do not duplicate; cherry-pick when upstream lands)

- Upstream PR **#3462** — retry interrupted files in an existing transfer (collides with backlog item "failed-file retry"; wait for its final shape).
- Upstream PR **#3471** — background receiving controls (#2153, 32👍 / #1468).
- Upstream PRs **#3102** (QUIC transport), **#2488** (Live Photo), **#3453** (theme intensity).
- Weblate commit `fca8ead0` — 15-locale batch translation, zero file conflicts, needs `dart run slang` regen (Medium). Verify per-hunk content overlap with baseline first: the `102f9894` case showed patch-id comparison can miss already-merged content (diff shape differs even when content is identical).
- Flutter SDK 3.41.9 → 3.47.6 unlock chain (freezed 4 / test 1.32 / mockito 5.8 / build_runner 2.16 / intl 0.20.3 / connectivity_plus 7.3.2 / flex_color_picker 4 / uri_content 4 / tray_manager 0.7): upstream CI pins 3.41.9, so staying aligned is deliberate; revisit when upstream bumps.
- `bluetooth_low_energy` 7.x line (pre-release): track breaking changes before adopting.

## Excluded (with reasons)

| Item | Evidence | Reason |
|---|---|---|
| QUIC transport | PR #3102 | Rust-side (FRB + jni); no cargo in this environment; protocol evolution |
| Full IPv6 discovery (IPv6 multicast announce) | #549 | Changes official v2 protocol (fixed 224.0.0.167:53317) |
| Web client transfer issues | #2951 | web.localsend.org lives in a separate project, not this repo |
| CLI receive-folder structure loss | #3503 | `cli/` is a Rust project |
| Self-built background receiving | #2153, #1468 | Foreground service + platform channels + devices; wait for upstream #3471 |
| Bluetooth-classic (RFCOMM/SPP) transport | #144 | Only plugin unmaintained 5 years, Android-only; iOS has no public API |
| BLE large-file transfer | — | Realistic phone-to-phone GATT throughput 0.1–0.5 MB/s; no resumption; no precedent (AirDrop/MS-CDP/Quick Share all keep payloads on IP) |
| Transfer speed ~5 MB/s to Android root cause | #1090, #1597 | Root cause in Rust read pipeline (content URI streaming) + device power management; v1.18.0 read-ahead already in baseline |
| Win10 1.18.2 startup failure | #3456 | Needs a Windows device |
| Linux tray/icons/themes family | #2902, #3484, #3413, #3416, #2241 | Upstream marks them *awaiting flutter upgrade* |
| WebRTC / signaling-server approaches | #850 discussion | Violates LocalSend's serverless principle (maintainer position) |

## Verification honesty

This fork is developed in a headless environment: `flutter analyze` + `flutter test` (incl. isolate package) + `dart format` are the hard gates; runtime behavior of platform-sensitive features (BLE, hotspot ranking, VPN, desktop integration, iOS share sheet) requires a real-device matrix before any product claim.
