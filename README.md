<p align="right">
  <img align="right" height="140" src="https://github.com/rooootdev/mond/blob/main/mond.png?raw=true" style="float: right;"/>
</p>

<div style="width: calc(100% - 180px);">
  <h1 style="margin-bottom: 0;">mond-compat</h1>
</div>

<p align="left">
  Edit MobileGestalt on iOS 26.0 - 26.7.2 / 27.2!<br>
  <a href="https://discord.gg/gw8PcRF3Jr">
    <img src="https://img.shields.io/badge/Discord-Join%20Server-7289DA.svg" alt="Discord">
  </a>
  <a href="https://github.com/rooootdev/mond/stargazers">
    <img src="https://img.shields.io/github/stars/rooootdev/mond?style=social" alt="GitHub stars">
  </a>
  <a href="https://github.com/rooootdev/mond/issues">
    <img src="https://img.shields.io/github/issues/rooootdev/mond" alt="GitHub issues">
  </a>
</p>

> [!WARNING]  
> Some of the tweaks have the potential to brick your device!<br>Use at your own risk.

## Compatibility fork

This is an independently maintained compatibility fork of [rooootdev/mond](https://github.com/rooootdev/mond), with credit to the original developers below. Its primary goal is accurate iOS 27.0.1 diagnostics for `worse_query`, including errors caused by App Group signing. **A successful version check does not mean the sandbox escape succeeded.**

- The iOS check recognizes iOS 26.0 through 26.7.2 and iOS 27.0 through 27.2, matching `worse_query`'s published range. Exact devices and builds are not all verified.
- The app displays the real error codes from `worse_query` instead of wrongly reporting App Group error `-1` as a missing system function.
- MobileGestalt now offers **Check MobileGestalt Access**, a read-only check of the current cache and saved original. It does not change device files, test write permissions, or establish that applying any tweak is safe.
- Unsupported iPadOS Mode binary patches are shown as unavailable if their CacheData offset cannot be found. **Do not bypass this check**, since the upstream code warns of boot loops and other instability.
- The artwork subtype picker identifies the original iPhone 17 family model without mistaking an original subtype that shares a value with another model for a spoof.
- Settings shows whether the configured App Group is accessible. The default for this fork is `group.com.soum91.mondcompat`.
- The bundle identifier is `com.soum91.mondcompat`, allowing this fork to coexist with upstream mond.

### Signing requirement

To use `worse_query`, the **installed app's signed entitlements and provisioning profile** must both authorize the App Group identifier. Register the group in your own Apple Developer account and provision it for the chosen bundle identifier. If a signer provides a different registered group, enter that exact group in **Settings > Exploit > App Group identifier**, then tap **Run Exploit**. Changing the text field does not create or authorize an App Group.

If Settings reports *App Group unavailable*, the exploit cannot work in that installation. A third-party signing certificate without the necessary App Group provisioning cannot be fixed simply by repackaging the IPA.

Do not enable *Ignore exploit failure* or apply MobileGestalt changes until the access checks succeed. The separate PosterBoard container lookup may still fail on a supported iOS version.

>[!NOTE]
> No questions regarding Apple Intelligence will be answered in GitHub issues anymore.<br>Ask in the [discord server](https://discord.gg/gw8PcRF3Jr).

**Version Support:**
| iOS Version | Status |
|---|---|
| iOS 26.0 through 26.7.2 | In upstream exploit's stated range, unverified per build |
| iOS 27.0, 27.0.1, 27.1, 27.2 | In upstream exploit's stated range, unverified per build |
| Other iOS versions | Not claimed by this fork |

**Planned:**<br>
&#45; Gestalt Keys browser<br>

**Implemented:**<br>
&#45; Pocket Poster<br>
&#45; MobileGestalt Editor<br>
&#45; HouseArrest File Browser<br>

**Known Issues:**<br>
&#45; Tweaks may disappear on reboot<br>
&#45; Disable Region restrictions may be broken on some versions/devices<br>
&#45; iPadOS UI and related tweaks may not work and/or **bootloop** you!<br>

**Credits:**<br>
&#45; [forcequit](https://github.com/forcequitOS) for worse_ and bad_ query, the sandbox escapes used by mond<br>
&#45; [johnny](https://github.com/0xjohnnydev) for his work on the MCM bug class<br>
&#45; [jailbreak.party](https://github.com/jailbreakdotparty) for PartyUI, GestaltView and the implementation of [neon](https://github.com/neonmodder123)'s respring method<br>

<i>btw, you should like totally star this repo and stuff</i>
