# iPadOS mode on iPhone 17: verified device results and next research

## Objective

Preserve iPadOS Windowed Apps / Stage Manager on iPhone18,3, iOS 27.0.1
without changing the original iPhone status bar, Lock Screen layout, safe
areas, Home Screen geometry, and third-party app scene layout.

## Actual iPhone 17 results (November 8, 2026)

| Tested state | Runtime observation |
| --- | --- |
| `DeviceClassNumber=3`, all 5 known iPad capability flags enabled | iPad windowing and Stage Manager appear; iPad menu/status bar, altered home dock, oversized Lock Screen and some app layout defects also appear. |
| `DeviceClassNumber=1`, same 5 flags enabled | Original iPhone Home Screen dock and status bar appear, but the iPad windowing UI is not retained. |
| Restore `DeviceClassNumber=3`, all 5 flags | iPad menus, status bar and Stage Manager return. |

On-disk read-back verified class and flag counts, but **the user's runtime
screenshots**, not file writes alone, establish this feature tradeoff.
The class-1-plus-flags experiment is not a validated hybrid fix. Do not
recommend repeating it just to confirm the already observed result.

## Architecture leads

- Apple's iPadOS guide says the app-name menu bar is present with Windowed Apps
  or Stage Manager and can be invoked using the app name in the upper-left.
- `SystemStatusUI` / Speakeasy is the modern status-bar rendering path; the
  legacy date and time overrides do not provide a verified iOS 27 layout fix.
- The open VPhone iPhone Duo bring-up research reports that `PFCurrentDeviceClass`
  maps MobileGestalt `DeviceClassNumber` 1 to iPhone and 3 to iPad in
  PosterFoundation, corroborating the class-dependent Lock Screen behavior.
- Distinct device identity per subsystem would probably require SpringBoard or
  framework-level changes, which a MobileGestalt file-write exploit alone does
  not authorize. This remains a hypothesis until reverse engineering confirms
  the exact callsites, process boundaries and practical permissions.
- `TrollPad` provides a concrete **jailbreak-only** example: it hooks
  `-[UIDevice userInterfaceIdiom]` in SpringBoard and temporarily returns iPad
  only while selected switcher/layout methods run, then restores the original
  iPhone idiom. This demonstrates per-call policy is possible **with runtime
  injection**, not that the same hook works on iOS 27 or can be applied with
  `worse_query` file descriptors.
- DarkSword/Cyanide's SpringBoard injection route does not support iOS 27.0.1:
  its required kernel vulnerabilities were patched by iOS 26.1, so do not
  suggest installing those tools or adapting an older injected tweak on this
  device without a newly validated entry point.

## Offline experiment

The `research/ipados-statusbar` branch supplies a research-only CI job. It
extracts iPhone18,3 / iOS 27.0.1 (24A446) dyld cache from Apple's firmware
using blacktop's `ipsw` tooling, inspects a few named frameworks, and uploads
text logs as a short-lived artifact. It never contacts or patches a phone.

### Verified offline results, November 8, 2026

The [completed workflow run](https://github.com/soum91/mond-compat/actions/runs/42557229505)
successfully extracted and searched the actual iOS 27.0.1 binaries for:

- `/System/Library/PrivateFrameworks/SystemStatusUI.framework/SystemStatusUI`
- `/System/Library/PrivateFrameworks/SpringBoardFoundation.framework/SpringBoardFoundation`
- `/System/Library/PrivateFrameworks/PosterFoundation.framework/PosterFoundation`
- `/System/Library/PrivateFrameworks/UIKitCore.framework/UIKitCore`
- `/System/Library/PrivateFrameworks/FrontBoardServices.framework/FrontBoardServices`

The named strings found in these firmware binaries include:

| Framework | Actual iOS 27.0.1 evidence | Interpretation and limit |
| --- | --- | --- |
| `SystemStatusUI` | `STUIStatusBar`, `STUIStatusBarDisplayItem`, `menuBar`, `StatusBarOverrides`, `STUIStatusBarDataOverridesViewController` | Confirms modern status-bar/menu bar internals; does not demonstrate a device-layout preference or writable UI override. |
| `SpringBoardFoundation` | `SBAutomaticallyShowAndHideMenuBar`, `SBMenuBarDemoMode`, `SBHomeScreenScreenTypeOverride` | Confirms known menu bar auto-hide option and an additional Home Screen override *name*; no evidence this affects status-bar geometry or keeps multitasking. |
| `PosterFoundation` | `DeviceClassNumber`, `PRPosterRoleLockScreen` | Consistent with a separately class-sensitive Lock Screen layout; not proof of a separate Lock Screen override. |
| `UIKitCore` | `userInterfaceIdiomOverride`, `UITraitUserInterfaceIdiom`, `_UIDeviceNativeUserInterfaceIdiomIgnoringClassic`, `STUIStatusBar_Wrapper` | Suggests scene/trait-level idiom mechanisms exist. No evidence that a stock sideloaded app can configure them inside SpringBoard/SystemStatusUI. |

The extractor previously failed to find `SystemStatusUI` and
`SpringBoardFoundation` only because each name also matched an accessibility
bundle. Using the full private-framework paths fixed that ambiguity.

### Stronger independent-windowing candidate (November 8 follow-up)

The [focused iOS 27.0.1 scan](https://github.com/soum91/mond-compat/actions/runs/42559195790)
also recovered `SpringBoard.framework` and `SystemStatus.framework`. The
**actual iOS 27.0.1 SpringBoardFoundation binary** contains each of:

- `SBChamoisWindowingEnabled`
- `SBMedusaMultitaskingEnabled`
- `SBFlexibleWindowingPreviouslyEnabledAutomaticStageCreation`

It also contains `DeviceSupportsEnhancedMultitasking`. Meanwhile,
`SpringBoard.framework` has `chamoisWindowingEnabled` and FlexibleWindowing
classes; `SystemStatus.framework` has the distinct `menuBarEntry` name; and
`UIKitCore` has `LegacyPhonesStatusBarUsesiPadLayout` (whose meaning and call
sites have **not** been verified).

An [independent iPadOS simulator automation](https://github.com/pingdotgg/t3code/blob/main/scripts/mobile-showcase.ts)
documents that the **three SpringBoard preferences** are all needed to switch
its iPad simulator from windowed apps to fullscreen mode; the simulator must
reboot afterward. This is evidence of a native windowing preferences path,
**not** a successful iPhone hybrid layout.

**Candidate next on-device test, not yet performed:** With separate external
backups of the original MobileGestalt, working class-3 MobileGestalt and
existing `com.apple.springboard` preferences, verify the current preference
values first. On a recoverable experimental installation only, test
`DeviceClassNumber=1` with the existing five iPad capability flags and the
three SpringBoard windowing preferences enabled. Read back both files before
rebooting. Record actual Stage Manager and status/Lock Screen behavior. If
windowing disappears or stability suffers, restore both captured originals;
**do not** repeatedly toggle device class or leave an unverified auto-apply
mechanism installed.

The research branch now contains the **Hybrid B** opt-in UI for this test.
It captures an exact `com.apple.springboard.plist` snapshot separately from
the known-working class-3 MobileGestalt, exports both via the native Files
picker, checks on-disk values, and offers independent preference rollback.
The code deliberately refuses to invent an absent SpringBoard plist, refuses
to overwrite a mismatched backup, and does not auto-respring or reboot.
Writing this file requires a separately obtained sandbox grant and may fail.
`cfprefsd` caching could undo direct disk changes, even when immediate readback
matches. **No physical-device validation has yet occurred.** The app is an
experimental test harness, not a proven iPhone-style status-bar fix.

This test still has a significant chance of failure: actual SpringBoard
windowing methods may independently require the iPad idiom, as TrollPad's
per-call hooks illustrate. The simulator result alone cannot establish safety
or success on a non-jailbroken iPhone 17. A locked-out or boot-looping device
may not be recoverable with the app's internal rollback button.

The modern `StatusBarOverrides.archive` research supports carrier and cellular
data changes; it does **not** demonstrate an iPhone-style status-bar layout or
suppression of `menuBarEntry`. Do not label that as a complete solution.

**Conclusion of this scan:** no verified independent non-jailbreak setting
for iPhone-style system status bar, Lock Screen, and Stage Manager together.
The more targeted approach remains a *SpringBoard-scoped* idiom override like
TrollPad's, contingent on a validated iOS 27 system-process injection method
and freshly verified selectors. `worse_query` granting selected file handles
is not evidence of that capability. A text string alone is not a safe patch.
In Mond's source, its logged `pb` handle specifically refers to a
**PosterBoard container descriptor**; it is not a SpringBoard process handle.

The next actionable threshold is identifying a **separate** preference,
entitled service, or independently enforced capability allowing Windowed Apps
without global iPad device class. Mere strings or unsupported preference
guesses are not enough to ship an on-device patch. If no such path exists,
report the lack of a verified fix instead of cycling additional MG values.

## Safety requirements

- Never replace the user's working class-3 MobileGestalt snapshot.
- Keep the distinct original class-1 and working class-3 backups outside mond.
- Avoid running MobileGestalt experiments on a low battery.
- Never equate a successful file write with a working runtime UI or a guaranteed
  recovery route after a boot loop.

## Primary references

- [Apple: iPadOS 27 menu bar](https://support.apple.com/en-mt/guide/ipad/ipadb4ede9db/27/ipados/27)
- [GoldenNugget: iOS 27 status-bar research](https://github.com/Eazvy/GoldenNugget/blob/main/docs/iOS27_StatusBar_Research.md)
- [VPhone: iPhone Duo and device-class mapping](https://lakr233.github.io/vphone-cli/research/Guest/iphone_duo_bringup.html)
- [TrollPad: scoped SpringBoard idiom hooks](https://github.com/khanhduytran0/TrollPad/blob/main/TweakSB.x)
- [Google Project Zero/GTIG: DarkSword patch status](https://cloud.google.com/blog/topics/threat-intelligence/darksword-ios-exploit-chain)
- [blacktop/ipsw: extracting dyld from remote IPSWs](https://blacktop.github.io/ipsw/docs/guides/extract/)
