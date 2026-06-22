# Cidre.app Disk Operations

Partition creation uses `diskutil apfs resizeContainer <physical-store> <new-container-size> APFS <name> <new-partition-size>`. Both sizes are explicit so the preview fully describes the resulting layout.

Deletion operations are available only for a selected non-system APFS volume or partition. The helper refuses any target related to the startup volume and does not expose whole-disk erase operations.

Disk operations are inherently interruption-sensitive. Keep a current backup, connect power, and do not force-quit the app or restart macOS while `diskutil` is running.
