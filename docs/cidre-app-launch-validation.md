# Cidre.app Launch Validation

`scripts/cidre-app-launch-check` validates launch readiness for the SwiftPM-built executable.

- Launch target: `apps/macos/CidreApp/.build/debug/CidreApp`
- Window checks: v0.34.0 focuses on launch readiness and manual verification instead of full UI automation.
- Manual checklist: confirm the window opens, sidebar navigation works, settings render, repository selection succeeds, and safe commands return visible output.
- Limitation: SwiftPM executable validation is used even when a notarized `.app` bundle is not available.
