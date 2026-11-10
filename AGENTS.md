# Repository release rules

- Preserve upstream attribution and the repository's GNU AGPL-3.0 license, alongside the separate licensing notices in imported `worse_query` code.
- Every release must update the root `CHANGELOG.md` with concrete, verified changes. Do not use generic release notes.
- Match `MARKETING_VERSION` and `CURRENT_PROJECT_VERSION` in both Debug and Release configurations. Display the installed version in the app.
- Keep the sideload-facing version in strict `x.y.z` form; use the numeric build number separately.
- Never claim a firmware is exploitable solely because its version passes a guard. Validate the App Group container and return codes on a real device.
- Run the iOS build workflow on every change to `main`. A failed build must be reported as failed, not published as a working IPA.
- Do not remove `worse_query`'s App Group prerequisite or ship privileged tweaks with exploit failure ignored by default.

## Universal diagnostic export rule (applies to all future diagnostic UIs)

- Never ship a silent, clipboard-only diagnostic or log copy button. After writing to the iOS pasteboard, read back and verify the exact text, then show visible success or failure feedback.
- Give every generated diagnostic at least three independent user actions: **Copy**, **Share** using the native share sheet, and **Save as `.txt`** using the native Files picker (`fileExporter` or `UIDocumentPickerViewController`). A failed clipboard operation must not prevent sharing or saving.
- Keep the diagnostic text selectable, export the **entire** report instead of a truncated preview, and include iOS/device/app version and relevant error or return codes. Avoid secrets, account tokens, and private keys; offer redaction if potentially sensitive fields exist.
- Test all actions in a real signed/sideloaded iPhone build, not only in simulator or an Xcode preview. Check that copied text really pastes into a different app; test native Share and Files export. If hardware verification is unavailable, state it explicitly and do not claim Copy/Share works.
- Show distinct statuses for no report, copy success, copy failure, and save failure. Never use an unacknowledged `UIPasteboard.general.string = ...` as the only reporting mechanism.
- For SwiftUI projects, prefer a reusable shared diagnostic export component, and add the same contract to new repos' `AGENTS.md` so other coding agents follow it.


## Public attribution and owner privacy

Use `soum91` as the author, maintainer, developer, and publisher in all first-party metadata. Do not publish the owner's legal name, private email, or other personal identifiers in source, licenses, Sileo/FlareStore feeds, release assets, binary packages, generated docs, logs, or commits. Audit generated artifacts before publishing. Preserve legitimate third-party copyright notices. Existing bundle identifiers, app groups, and entitlements must not be silently changed, because doing so can break upgrades and stored data.
