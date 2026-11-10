# Changelog

## [development] - 2026-11-09

## Verified changes since project start

- feat: opt-in hybrid iPhone layout test with exact iPadOS snapshot restore ([`5afc0a77`](https://github.com/soum91/mond-compat/commit/5afc0a77539e8dfef2c90a40f52b0b035d34b6b1); `README.md`, `mond.xcodeproj/project.pbxproj`, `mond/helpers/mg.swift`, and 1 more)
- feat: verify iPadOS CacheData write/readback and export original backup (3.0.5) ([`7460d88b`](https://github.com/soum91/mond-compat/commit/7460d88b073a5774adb6add421494b894596adb9); `README.md`, `mond.xcodeproj/project.pbxproj`, `mond/helpers/mg.swift`, and 1 more)
- fix: verify diagnostic copy and provide native share and text export (3.0.4) ([`33f41cbc`](https://github.com/soum91/mond-compat/commit/33f41cbc0adb9a4e728973c26a2e98d0308c0c53); `mond.xcodeproj/project.pbxproj`, `mond/views/app/DiagnosticExport.swift`, `mond/views/app/LogView.swift`, and 1 more)
- Update FlareStore catalog for compiled experimental iPadOS Mode 3.0.3 (4) ([`91f3d093`](https://github.com/soum91/mond-compat/commit/91f3d0939442161c5d7952d10dffd0a81abbdd6b); `repo.json`)
- Add strictly validated experimental iPadOS Mode locator for iOS 27.0.1 (3.0.3) ([`339ca98a`](https://github.com/soum91/mond-compat/commit/339ca98a19e072b77cb38c2b55c350e774d02651); `README.md`, `mond.xcodeproj/project.pbxproj`, `mond/helpers/mg.swift`, and 1 more)
- Publish FlareStore metadata for verified 3.0.2 (3) IPA ([`470b7e84`](https://github.com/soum91/mond-compat/commit/470b7e84e139dff64df42d7c2ff1790bef5b2b8b); `repo.json`)
- Add read-only MobileGestalt diagnostics and safe iOS 27 subtype handling (3.0.2) ([`30a4a8ea`](https://github.com/soum91/mond-compat/commit/30a4a8ea495ba7115f5c0d2381dfa37e35ce2478); `README.md`, `mond.xcodeproj/project.pbxproj`, `mond/helpers/mg.swift`, and 1 more)
- Synchronize FlareStore asset metadata with successful build ([`a3f34eee`](https://github.com/soum91/mond-compat/commit/a3f34eeed26c6d9e260e0c13f1c77eab973dfe05); `repo.json`)
- Publish FlareStore source for mond-compat 3.0.1 ([`4129e38f`](https://github.com/soum91/mond-compat/commit/4129e38f4247687aba6ff878ecd13ea8a0949cc5); `.github/workflows/ios-release.yml`, `repo.json`)
- Fix iOS 27.0.1 compatibility diagnostics and App Group handling ([`43e6501c`](https://github.com/soum91/mond-compat/commit/43e6501cba9396ed075fec18adf87bb168ba3314); `.github/workflows/ios-release.yml`, `LICENSE`, `README.md`, and 35 more)

[Inspect exact code changes](https://github.com/soum91/mond-compat/commits/development)

All entries describe actual source changes. The installed version and build number are shown in the app's Settings screen.

## 3.0.6 (7) - 2026-11-09

- Add a separately confirmed, opt-in **Hybrid Layout Experiment** for iPhone18,3 on iOS 27.0.1. It changes only the validated `DeviceClassNumber` value from 3 (iPad) to 1 (iPhone), retaining all five iPadOS capability flags for a controlled on-device A/B test. It does **not** claim that iPad windowing or iPhone Lock Screen layout will remain functional.
- Capture the complete, previously working class-3, five-flag MobileGestalt in a private backup before the hybrid write. Refuse stale/conflicting snapshots, missing original iPhone backup, wrong hardware/firmware, invalid binary offsets, or unexpected on-disk flag states.
- Add native Files export of the working iPadOS snapshot and a separate **Restore Working iPadOS Layout** action that writes back the exact saved pre-test file instead of guessing at a reverse patch.
- Check complete on-disk read-back after either operation and show the hybrid state in the read-only diagnostic. Warn explicitly that write verification is not evidence of runtime UI compatibility or guaranteed recovery from a boot loop.
- Preserve the working iPadOS toggle and its existing class-3 behavior unchanged. No test automatically resprings or reboots the phone.

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
