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

## Offline experiment

The `research/ipados-statusbar` branch supplies a research-only CI job. It
extracts iPhone18,3 / iOS 27.0.1 (24A446) dyld cache from Apple's firmware
using blacktop's `ipsw` tooling, inspects a few named frameworks, and uploads
text logs as a short-lived artifact. It never contacts or patches a phone.

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
- [blacktop/ipsw: extracting dyld from remote IPSWs](https://blacktop.github.io/ipsw/docs/guides/extract/)
