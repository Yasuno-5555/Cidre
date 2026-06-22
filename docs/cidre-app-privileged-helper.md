# Cidre.app Privileged Helper

`CidrePrivilegedHelper` is a separate executable invoked only after macOS administrator authentication. Its allowlist supports `partition-create`, `partition-delete`, `apfs-resize-container`, and `apfs-delete-volume`.

Every request includes a plan ID, exact confirmation token, target identifier, structured arguments, dry-run flag, and audit path. The helper validates identifiers and sizes, re-reads the target immediately before execution, and rejects startup, Recovery, Preboot, VM, whole-disk, and ambiguous deletion targets.

Dry-run performs the same validation and returns the exact command without changing disk state.
