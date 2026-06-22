# Cidre.app Runtime Known Issues

- SwiftPM executable launch validation is stronger than app bundle packaging validation in v0.34.0.
- Some safe commands still emit domain-specific JSON or raw output instead of a single unified app payload shape.
- Repository path selection depends on the local checkout layout and can fail if interface metadata is moved.
- Report rendering is intentionally diagnostic-first and does not yet cover every future install/uninstall artifact type.
