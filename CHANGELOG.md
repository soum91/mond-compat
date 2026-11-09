# Changelog

All entries describe actual source changes. The installed version and build number are shown in the app's Settings screen.

## Hybrid D GoldenNugget Mobile template - 2026-11-09 (no Mond app version change)

- Add a separate format-2, default-OFF `.batter` research template compatible with GoldenNugget Mobile's imported-template format. No new IPA, FlareStore JSON or Mond application changes are involved.
- Package exactly two SpringBoard Boolean preferences, `SBChamoisWindowingEnabled` and `SBMedusaMultitaskingEnabled`, in one `ManagedPreferencesDomain` plist payload, gated to iOS 27.0.1; omit MobileGestalt device-class spoofing and runtime/history state.
- Add an offline archive builder/validator and dedicated prerelease workflow, separate from the existing Desktop Hybrid C template.
- Document that GoldenNugget Mobile mirrors the payload into `HomeDomain` on iOS 27 and can overwrite unrelated settings, that disabling the template does not roll back an earlier restore, and that actual device behavior is unverified.

## Hybrid C external research addendum - 2026-11-09 (no Mond app version change)

- Add an offline-built, OFF-by-default GoldenNugget Desktop `.batter` template for the two confirmed iOS 27.0.1 SpringBoard **configuration** keys, `SBChamoisWindowingEnabled` and `SBMedusaMultitaskingEnabled`. It is not an IPA, not a FlareStore update, and not confirmed to enable Stage Manager on an iPhone.
- Deliberately exclude `SBFlexibleWindowingPreviouslyEnabledAutomaticStageCreation`, since independent primary-source device-backup research identifies it as runtime/history state rather than a tweakable preference.
- Provide a self-checking standard-library builder, read-only archive verification, a separate high-risk experimental prerelease workflow, and detailed backup/restore precautions. The workflow does not modify any device.
- Document that GoldenNugget's iOS 27 backup restore mirrors managed preferences into the normal SpringBoard plist, can replace unrelated original keys, and has no trustworthy automatic rollback for those keys. The existing Mond 3.0.7 `grant result -6` is not fixed by installing a different App Group.

## 3.0.7 (8) - research branch, 2026-11-09

- Add a separate **Hybrid B: SpringBoard Windowing** experiment for iPhone18,3 on iOS 27.0.1. It stages three firmware-confirmed SpringBoard preference keys (`SBChamoisWindowingEnabled`, `SBMedusaMultitaskingEnabled`, `SBFlexibleWindowingPreviouslyEnabledAutomaticStageCreation`) before invoking the existing class-1-plus-five-flags test. Actual hybrid multitasking behavior is **unverified**.
- Preserve the complete original `com.apple.springboard.plist` in a separate private, conflict-protected snapshot, alongside the established exact working class-3 MobileGestalt snapshot; add native Files export of the SpringBoard backup.
- Read back and verify the written preference file, provide a read-only preference report with Copy/Share/Save as Text, and attempt to recover both originals if the subsequent MobileGestalt write fails.
- Add **Restore Both Working System Files** and **Restore SpringBoard Keys Only** controls; the latter restores only the original presence/values of the three keys, preserving unrelated SpringBoard preferences.
- Leave the existing class-only test, original iPadOS toggle, main release and automatic-restart behavior unchanged. Add a research-branch-only CI build that uploads an unsigned IPA artifact without publishing a release.
- Warn that `cfprefsd` caching may discard direct preference-file edits, a file write does not prove active windowing, and an app-local rollback cannot recover a device stuck in a boot loop.

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
