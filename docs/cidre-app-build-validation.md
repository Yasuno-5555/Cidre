# Cidre.app Build Validation

`scripts/cidre-app-build-check` validates that the SwiftPM-based macOS app can be built on a real macOS machine.

- Build command: `cd apps/macos/CidreApp && swift build`
- Expected outputs: `.build/debug/CidreApp` and `.local/state/cidre/app-runtime/current/app-build.log`
- Common failures: missing Swift toolchain, SwiftUI compile regressions, or command metadata drift that breaks the app target.
- Linux behavior: this command is intentionally blocked outside macOS and returns a machine-readable safe refusal.
