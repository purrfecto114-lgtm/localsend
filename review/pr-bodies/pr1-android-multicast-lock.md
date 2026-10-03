# PR-1 body (android-multicast-lock → localsend/localsend:main)

Title: fix(android): hold a multicast lock so discovery packets are received

---

## Problem

Android's Wi-Fi stack filters out packets that are not explicitly addressed to this device in order to save battery; on many devices they are dropped entirely unless a `WifiManager.MulticastLock` is held:

> Normally the Wifi stack filters out packets not explicitly addressed to this device. Acquiring a multicast lock will cause the stack to receive packets addressed to multicast addresses.
> — [WifiManager documentation](https://developer.android.com/reference/android/net/wifi/WifiManager#createMulticastLock(java.lang.String))

LocalSend's discovery relies on receiving multicast announcements (UDP, group `224.0.0.167`, port 53317), so on affected devices the app never sees other members' announcements and discovery becomes unreliable or one-directional.

Since Android 11, receiving multicast without the lock is no longer reliable in general. The same problem hit Syncthing's local discovery when Android 11 shipped ("Android 11 breaks local discovery" — syncthing forum), and the Catfriend1 syncthing-android fork fixed it in 2021 by acquiring a `MulticastLock` with the comment *"Android 11 blocks local discovery if we did not acquire MulticastLock"* (SyncthingRunnable.java). The official syncthing-android app still has no lock and its LAN discovery is still reported broken on these devices. KDE Connect likewise declares `CHANGE_WIFI_MULTICAST_STATE` and holds a lock for its mDNS discovery.

## Fix

- Declare `CHANGE_WIFI_MULTICAST_STATE` (a normal permission, granted at install, no runtime prompt).
- Hold a `MulticastLock` for the lifetime of the main activity: acquire in `onCreate`, release in `onDestroy`, `setReferenceCounted(false)`.

Devices without Wi-Fi hardware (e.g. Ethernet-only TV boxes) are unaffected: `getSystemService(WIFI_SERVICE)` returns `null` there, so the lock is simply not taken. The new `<uses-feature android:name="android.hardware.wifi" android:required="false" />` keeps such devices visible on the Play Store — the multicast permission implies the `android.hardware.wifi` feature, and this line also un-filters the pre-existing implication coming from the `ACCESS_WIFI_STATE` permission declared by the `network_info_plus` plugin.

## Scope / limitations

- The lock removes the Wi-Fi multicast filter only. It does not override vendor battery savers, Doze or app-standby restrictions.
- Holding the lock does not guarantee delivery on every device (platform bugs exist, e.g. [issuetracker 247596083](https://issuetracker.google.com/issues/247596083)), but it removes the dominant, documented filter.
- On a hotspot (softAP) the lock is not relevant — it acts on the STA (client) side.
- Battery: the lock is held while the app runs, which is exactly the period in which discovery needs multicast. Google's documentation notes a potential battery impact; this is the standard trade-off of discovery-based apps (and when another app already holds a multicast lock, the Wi-Fi filter is already off and the incremental cost is zero). On Android 16+ the system itself deactivates the lock while the process is cached.

## Verification

- Compiles against the project toolchain (Kotlin 2.2.0, compileSdk 36); the API usage follows the `MulticastLock` contract (`setReferenceCounted(false)` before `acquire()`, release paired in `onDestroy`, `isHeld` checked defensively).
- I do not have an affected device at hand for an end-to-end check — it would be great if someone with a device that currently drops multicast could verify that discovery becomes bidirectional with this change.
