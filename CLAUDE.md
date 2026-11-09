# Claude Code instructions

Follow `AGENTS.md` in the repository root before editing, building, or releasing this app. In particular:

- Every diagnostic or log screen must provide **Copy**, native **Share**, and **Save as .txt** via native Files picker, with the complete selectable report.
- A clipboard write is not a verified copy. Read it back and show visible success/failure feedback; provide independent Share and file-export fallbacks.
- Include app/version, device/OS, useful return/error codes and redact sensitive data. Do not claim working Copy/Share/Save without a signed-device test and cross-app paste check.
- Preserve the upstream license and attribution; add concrete, verified entries to `CHANGELOG.md` for releases, and keep app and catalog versions consistent.
