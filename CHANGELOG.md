# Changelog

All entries describe actual source changes. The installed version and build number are shown in the app's Settings screen.

## 3.0.5 (6) - 2026-11-08

- Compare the iPadOS Mode CacheData nibble patch and five capability keys against the upstream Nugget implementation; retain the unique validated iOS 27.0.1 locator and high-risk confirmation.
- Require the iOS 27.0.1 saved original to decode to iPhone DeviceClassNumber 1 before enabling the tweak; the backup is no longer accepted on CacheData length alone.
- Make the iPadOS toggle reflect both DeviceClassNumber 3 and all five capability flags, avoiding a false enabled state when only the flags are set.
- Extend the read-only diagnostics with the installed build, on-disk class value, 0-5 iPadOS flag count, original backup class value, write method, and a **non-mutating** `O_RDWR` open check (not proof an actual write will work).
- Verify the complete file after writing or reverting. An iPadOS Mode write is only reported as staged successfully if the read-back has DeviceClassNumber 3 and all five flags; otherwise show a specific error and warn against restarting.
- Add native Files export of the saved original MobileGestalt `.plist` for offline backup. This does not make the device recoverable from every boot loop.
- After a verified experimental iPadOS write, refrain from offering an automatic respring. Activation on actual iPhone 17 / iOS 27.0.1 remains unverified until a device test.

## 3.0.4 (5) - 2026-11-08

- Replace the silent MobileGestalt Copy Diagnostic action with a shared export control that verifies clipboard contents and displays a visible copy result.
- Add native Share and Save as Text actions to MobileGestalt diagnostics; export the complete report through the iOS share sheet or the native Files picker when copying fails.
- Make application logs selectable and give them the same Copy, Share and Save as Text options.
- Document a mandatory cross-app diagnostic export contract for future releases. Clipboard success in the field remains unverified until a signed device test.

## 3.0.3 (4) - 2026-11-08

- Add an **experimental** iOS 27.0.1 iPadOS Mode locator using the CacheData structural pattern employed by Nugget when the older MobileGestalt-library offset resolver fails.
- Only accept a single candidate with verified neighboring marker values; reject ambiguous matches, out-of-range offsets, and conflicts between the two resolvers.
- Require a readable saved MobileGestalt backup with the same CacheData length before staging iPadOS Mode on iOS 27.0.1.
- Add a separate confirmation prompt before applying an enabled iPadOS Mode patch, and report the detected patch method in the read-only diagnostic.
- This is **not** verified on a physical iPhone 17 running iOS 27.0.1. The patch remains unavailable if validation fails, and even a validated offset does not prove that iPadOS Mode is safe on this firmware.

## 3.0.2 (3) - 2026-11-08

- Add a **Check MobileGestalt Access** read-only diagnostic showing whether the current cache can be read and parsed, the CacheExtra/CacheData state, current artwork subtype, and whether the saved original backup can be read. Include an in-app Copy Diagnostic button.
- Label the original artwork subtype with the actual iPhone 17 family model where identifiable; avoid incorrectly displaying an original subtype of `2622` as an iPhone 16 Pro spoof.
- Display **Unsupported** for iPadOS Mode when the necessary CacheData offset is missing, with the reason shown in the editor instead of permitting a failed toggle attempt.
- Explicitly state that a successful read-only diagnostic is not proof of write permission or safe binary patching.

## 3.0.1 (2) - 2026-11-08

- Correct the compatibility check to recognize iOS 27.0.1 within the stated `worse_query` support range.
- Fix incorrectly mapped `worse_query` error codes: `-1` now means the App Group is unavailable, while `-2` indicates a missing container manager function or library.
- Report precise failures for missing paths, symlink creation, container manager rejection, and sandbox extension refusal.
- Add an App Group status check and configurable identifier in Settings for differently provisioned builds.
- Use this fork's separate bundle identifier and App Group identifier.
- Document the signing and provisioning prerequisite and explain that a version check is not proof of exploit success.

## Upstream 3 - 2026-11-08

- Integrated `worse_query` and introduced MobileGestalt write changes. See [upstream release](https://github.com/rooootdev/mond/releases/tag/3).
