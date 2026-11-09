# Mond / GoldenNugget Mobile windowing experiment

## Do not apply on a primary iPhone

This is an **UNVERIFIED, HIGH-RISK research experiment** specifically for **iPhone18,3 on iOS 27.0.1**. It has **not been verified on a device**; a successful backup restore does **not** mean Stage Manager or iPad multitasking will actually work. A restore can break the SpringBoard UI or force device recovery. **Before using, make an independently verified, encrypted backup with Finder or Apple Devices/iTunes on a computer**, and be prepared to recover the device. There is no reliable on-device rollback if the phone fails to boot.

This experiment uses the existing **GoldenNugget Mobile** app; no modified IPA is required. It is a separate mobile-compatible format-2 `.batter`, not the format-3 Desktop experiment. GoldenNugget Mobile implements v2 community template extraction, `ManagedPreferencesDomain` backup payloads and an iOS 27 `HomeDomain` mirror. This pathway was validated by inspecting its upstream source, **not** by running an actual restore on iPhone18,3.

## What the optional switch writes

When the experiment checkbox is **ON**, the single `container/mobile/com.apple.springboard.plist` contains only:

- `SBChamoisWindowingEnabled = true`
- `SBMedusaMultitaskingEnabled = true`

The template's restore domain is `ManagedPreferencesDomain`; for iOS 27 GoldenNugget Mobile also mirrors it into `HomeDomain/Library/Preferences/com.apple.springboard.plist`. These are **whole-file restores**, not key-preserving updates, so existing unrelated SpringBoard preferences in either location may be overwritten. It does not patch `MobileGestalt`, does not change `DeviceClassNumber`, and deliberately excludes the runtime/history key `SBFlexibleWindowingPreviouslyEnabledAutomaticStageCreation`.

The imported template checkbox is **OFF by default**. With the switch OFF, its file is removed during template compilation, so it contributes **no SpringBoard payload**. This is not a universal safeguard: if you enable the experiment and apply once, later switching the checkbox OFF, removing the template, or applying again will **not restore the original preferences**. Do not select additional tweaks while testing because their payloads may merge or collide with this one.

## Import into an already installed GoldenNugget Mobile

1. Independently back up the **test phone** first; do not rely solely on GoldenNugget's in-process protective backup.
2. Download `Mond-iPhone-Windowing-Mobile.batter` from this project's *separate mobile experiment prerelease*, save to the iPhone Files app. Do not use the older `Mond-iPhone-Stage-Experiment.batter` desktop v3 file.
3. Open **GoldenNugget Mobile → Templates → Import .batter template** and select the new file from Files. The selected device must report iOS **27.0.1** for the template's version gate.
4. Open the imported **Mond: iPhone Windowing (Mobile Experiment)** template. The checkbox is OFF until explicitly enabled. If you accept the high-risk, unverified test, check **Request iPad windowing**.
5. Return to GoldenNugget Mobile's **GoldenNugget/Home** page and choose **Apply**. The app's normal pairing, tunnel and protective backup/restore prerequisites still apply. If the apply is disabled, consult the app's device identity, pairing and run log; this template cannot bypass a missing tunnel or unsupported restore exploit.
6. Record the complete apply log and verify behavior. A successful write is **disk-only evidence** until SpringBoard behavior is independently verified. There is no guaranteed way to activate the iPad window manager on this iPhone.

This experimental package is built and validated offline by `build_template.py` with Python's standard library. The workflow publishes only the `.batter` file, not an IPA and not a FlareStore JSON entry.
