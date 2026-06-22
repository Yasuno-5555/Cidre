# Cidre.app Packaging and Signing

Run `scripts/cidre-app-package` to produce `dist/Cidre.app`. The bundle contains the release SwiftUI executable, privileged helper, backend scripts, interface metadata, and documentation.

The local bundle is ad-hoc signed and can be launched with `scripts/cidre-app-launch` or Finder. A public release must replace ad-hoc signing with Developer ID Application signing, hardened runtime entitlements, notarization, and stapling.
