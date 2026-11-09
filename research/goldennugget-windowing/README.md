# Hybrid C: external SpringBoard windowing preference experiment

**Status: packaged for offline inspection; no physical-iPhone success has been verified.**

Mond 3.0.7's on-device Hybrid B diagnostic failed with a `worse_query`
`grant result -6` on the global SpringBoard preferences directory. That
directory is **not** among the supported `worse_query` system/app-group
containers. Trying additional App Group names does not solve this path limit.

GoldenNugget has an **independent desktop backup/restore transport** for iOS
26.2-27.x. It supports version-3 `.batter` Community Tweaks whose plist writes
target `/var/Managed Preferences/mobile/com.apple.springboard.plist`. On iOS
27 it also writes a `HomeDomain` mirror of that plist. This is *not* a safe
substitute for user-specific merge/restore: it may replace unrelated original
SpringBoard preferences, affect layouts, and require a full device restore.

The template exposes one switch, **OFF by default**, that writes only:

- `SBChamoisWindowingEnabled = true`
- `SBMedusaMultitaskingEnabled = true`

Those keys appear in iOS 27 firmware/real device backup research. Their ability
to enable windowing on an iPhone-class SpringBoard remains unverified. We
deliberately omit `SBFlexibleWindowingPreviouslyEnabledAutomaticStageCreation`,
because independent GoldenNugget research identifies it as **runtime/history
state**, not a configuration switch. The earlier Hybrid B experiment tried to
set that third key; this template does not.

## Device and version guard

- Only consider **iPhone18,3 on iOS 27.0.1**, and only with a separate,
  successfully verified *encrypted computer backup* and a practical recovery
  plan (restore via Apple Devices/iTunes or Finder).
- GoldenNugget's `.batter` version restriction is iOS 27.0.1 only. It cannot
  enforce the device model. Users must verify the device model manually.
- This file is a **GoldenNugget Desktop** template for Windows/macOS/Linux,
  **not an IPA** and cannot be installed through FlareStore JSON.
- GoldenNugget's reset may empty both the managed preference file and its
  app-domain mirror. **Switching the template OFF does not restore anything**;
  the tool cannot reconstruct all of your original SpringBoard preferences.
- Do not apply on a daily-driver device without accepting the potential for a
  boot loop, changed layout, or data loss. No automated device modification is
  performed by this repository.

## Offline build and verification

```bash
python3 research/goldennugget-windowing/build_template.py \
  --output Mond-iPhone-Stage-Experiment.batter
python3 research/goldennugget-windowing/build_template.py \
  --verify Mond-iPhone-Stage-Experiment.batter
```

The builder uses Python's standard library. It verifies that the archive
contains only `MondWindowing/config.json`, the switch is OFF by default, and
exactly the two intended boolean keys are written to the intended managed
preferences path. It **does not** prove iOS will act on those keys, nor that
GoldenNugget's restore is safe for a specific device.

## Testing when a verified recovery backup exists

1. Download **GoldenNugget Desktop** from its official project. Install Apple
   Devices or iTunes on Windows, as the project requires.
2. Separately create and verify an **encrypted full-device backup** outside
   GoldenNugget's cache. Preserve Mond's known-working class-3 MobileGestalt
   backup if one exists. Do not depend on Mond's limited backup to recover a
   non-booting device.
3. Import `Mond-iPhone-Stage-Experiment.batter` into GoldenNugget's Templates /
   Community Tweaks. Initially inspect it with the switch OFF. Verify the
   destination path and values against `config.json` and run the app's preview.
4. The untested device trial would explicitly switch it ON and apply it using
   GoldenNugget's iOS 27 backup restore. This **does not** claim a working
   hybrid configuration. Record the device backup, time, UI state, reboot
   behavior, and which MobileGestalt state is present. Stop on any abnormality.
5. If the device behaves incorrectly, rely on the separate known-good computer
   backup and recovery procedure. Do **not** assume OFF, GoldenNugget Reset,
   or Mond's SpringBoard key rollback can reconstruct the original preference
   files after a desktop restore.

## Primary-source research

- `GoldenNugget-Team/GoldenNugget` (`README.md`, `documentation.md`,
  `src/tweaks/posterboard/community_tweaks.py`,
  `src/devicemanagement/device_manager.py`): Community Tweaks format,
  backup-domain mapping, iOS 27 mirror, and restore risks.
- `GoldenNugget-Team/GoldenNugget/docs/SPRINGBOARD_TWEAK_CANDIDATES.md`
  section 5: Chamois/Medusa preferences observed in actual backups; the
  `PreviouslyEnabledAutomaticStageCreation` value classed as runtime state.
- `forcequitOS/worse_query` and Mond's live result: sandboxed App Group access
  does not include arbitrary `/var/mobile/Library/Preferences` files.

These are third-party experimental tools. Neither their success nor their
recovery guarantees are endorsed by Apple.
