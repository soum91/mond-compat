# Repository release rules

- Preserve upstream attribution and the repository's GNU AGPL-3.0 license, alongside the separate licensing notices in imported `worse_query` code.
- Every release must update the root `CHANGELOG.md` with concrete, verified changes. Do not use generic release notes.
- Match `MARKETING_VERSION` and `CURRENT_PROJECT_VERSION` in both Debug and Release configurations. Display the installed version in the app.
- Keep the sideload-facing version in strict `x.y.z` form; use the numeric build number separately.
- Never claim a firmware is exploitable solely because its version passes a guard. Validate the App Group container and return codes on a real device.
- Run the iOS build workflow on every change to `main`. A failed build must be reported as failed, not published as a working IPA.
- Do not remove `worse_query`'s App Group prerequisite or ship privileged tweaks with exploit failure ignored by default.
