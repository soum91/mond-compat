# Changelog

## [hybrid-d-goldennugget-mobile-27.0.1] - 2026-11-09

## Verified changes since hybrid-c-goldennugget-27.0.1

- Fix GoldenNugget Mobile release workflow shell closing fi ([`8ffe9ec3`](https://github.com/soum91/mond-compat/commit/8ffe9ec3dd2aef63b4aef1f5d33140e3954a3c30); `.github/workflows/package-goldennugget-mobile.yml`)
- Hybrid D: add default-off GoldenNugget Mobile windowing template ([`0d317756`](https://github.com/soum91/mond-compat/commit/0d317756e7b03e77e390fe73973ef4cae2bafdf3); `.github/workflows/package-goldennugget-mobile.yml`, `research/goldennugget-mobile-windowing/README.md`, `research/goldennugget-mobile-windowing/build_template.py`, and 1 more)

[Inspect exact code changes](https://github.com/soum91/mond-compat/compare/hybrid-c-goldennugget-27.0.1...hybrid-d-goldennugget-mobile-27.0.1)

## [hybrid-c-goldennugget-27.0.1] - 2026-11-09

## Verified changes since hybrid-b-3.0.7

- CI: publish validated GoldenNugget windowing template as experimental prerelease ([`7a62d51c`](https://github.com/soum91/mond-compat/commit/7a62d51c0a79d5636efe58a7b6faa0ec5e23f933); `.github/workflows/package-goldennugget-hybrid.yml`)
- Research: add opt-in GoldenNugget external SpringBoard hybrid template ([`ca857231`](https://github.com/soum91/mond-compat/commit/ca857231e4e40008b898230d4f583342681444d5); `research/goldennugget-windowing/config.json`)
- Research: add opt-in GoldenNugget external SpringBoard hybrid template ([`8d74a47e`](https://github.com/soum91/mond-compat/commit/8d74a47e9539989279861edbf327d61d6abbdc9b); `research/goldennugget-windowing/README.md`)
- Research: add opt-in GoldenNugget external SpringBoard hybrid template ([`92541383`](https://github.com/soum91/mond-compat/commit/925413836b0ff2a8be53bf7f866df9b4c5f4df7e); `research/goldennugget-windowing/build_template.py`)
- Publish successful Hybrid B IPA as isolated GitHub prerelease ([`7b7d0ef5`](https://github.com/soum91/mond-compat/commit/7b7d0ef51886a450cca40a36113716ac1cb881b2); `.github/workflows/publish-hybrid-b.yml`)

[Inspect exact code changes](https://github.com/soum91/mond-compat/compare/hybrid-b-3.0.7...hybrid-c-goldennugget-27.0.1)

## [hybrid-b-3.0.7] - 2026-11-09

## Verified changes since development

- Research: build unsigned research IPA without main release ([`1b78e6bc`](https://github.com/soum91/mond-compat/commit/1b78e6bc2a24837add217f9e626e7c7249330aec); `.github/workflows/ipados-hybrid-research-build.yml`)
- Research: record opt-in experiment and limits ([`b5b36e87`](https://github.com/soum91/mond-compat/commit/b5b36e873449377696bfe00e719e73b41d7141a5); `docs/ipados-hybrid-research.md`)
- Research: bump research build to 3.0.7 (8) ([`edecac3b`](https://github.com/soum91/mond-compat/commit/edecac3b8641679ede2d3a94be61863332416fdc); `mond.xcodeproj/project.pbxproj`)
- Research: expose separate hybrid B backup, test and restore UI ([`28e2a6b0`](https://github.com/soum91/mond-compat/commit/28e2a6b0fd86944dd9c252bb3e567bf779b3b1e9); `mond/views/tweaks/mobilegestalt/GestaltView.swift`)
- Research: add reversible SpringBoard hybrid B experiment ([`74e11a8a`](https://github.com/soum91/mond-compat/commit/74e11a8ae0ef217ea590250436a7e3b161d81146); `mond/helpers/mg.swift`)
- Record verified iOS 27 windowing preference candidates and rollback test criteria ([`418991d4`](https://github.com/soum91/mond-compat/commit/418991d4f37df2dfc339e3e8c89f5494c17057ff); `docs/ipados-hybrid-research.md`)
- Verify exact iOS 27 Chamois and flexible windowing preference names ([`59c8eba1`](https://github.com/soum91/mond-compat/commit/59c8eba1498c93abd3d385457208f124b3827c40); `scripts/research/ipados-statusbar-offline.sh`)
- Focus iOS 27 binary scan on Medusa, menu bar and device-idiom selectors ([`456a0bdb`](https://github.com/soum91/mond-compat/commit/456a0bdbad21096cd60e60ab258cfd3200e96301); `scripts/research/ipados-statusbar-offline.sh`)
- Probe iOS 27 SpringBoard multitasking gates and SystemStatus archive symbols ([`d5839248`](https://github.com/soum91/mond-compat/commit/d58392489b5bfc39f68546839254815c57ee38a7); `scripts/research/ipados-statusbar-offline.sh`)
- Clarify PosterBoard file access versus SpringBoard injection ([`95fb3612`](https://github.com/soum91/mond-compat/commit/95fb3612d0bf4a8b33688f10ce71b12a4c250563); `docs/ipados-hybrid-research.md`)
- Document verified iOS 27 SystemStatusUI and SpringBoard firmware research ([`f94d3390`](https://github.com/soum91/mond-compat/commit/f94d339024c832e4fe8615cda0620fa955147922); `docs/ipados-hybrid-research.md`)
- Fix iOS 27 framework path disambiguation in offline status bar scan ([`15cce119`](https://github.com/soum91/mond-compat/commit/15cce1199deb67dbcf531f1e954f6db50ebcd9ab); `scripts/research/ipados-statusbar-offline.sh`)
- research: fix Bash 3.2 compatibility on macOS CI ([`289d9cee`](https://github.com/soum91/mond-compat/commit/289d9ceeaaabb7815487082919157c0df95587c5); `scripts/research/ipados-statusbar-offline.sh`)
- docs: record TrollPad per-call idiom hooks and iOS 27 exploit boundary ([`6ef38a54`](https://github.com/soum91/mond-compat/commit/6ef38a547f36b09c7bfd716c43fb53fe2e638b46); `docs/ipados-hybrid-research.md`)
- research: run read-only iPadOS status-bar firmware analysis in CI ([`9940cfde`](https://github.com/soum91/mond-compat/commit/9940cfde14e8ad247b7e85f2dac54f60ad88fa16); `.github/workflows/ipados-statusbar-research.yml`)
- research: inspect iOS 27.0.1 status UI framework metadata offline ([`70897dc8`](https://github.com/soum91/mond-compat/commit/70897dc8f35398852392d5636fd67506a219fa17); `scripts/research/ipados-statusbar-offline.sh`)
- docs: record physical iPhone hybrid A/B results ([`5356c680`](https://github.com/soum91/mond-compat/commit/5356c680b36e53bca4a1c54b22b85e9272eb3057); `docs/ipados-hybrid-research.md`)

[Inspect exact code changes](https://github.com/soum91/mond-compat/compare/development...hybrid-b-3.0.7)

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
