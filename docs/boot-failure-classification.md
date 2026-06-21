# Boot Failure Classification

This document maps error logs and observations to specific failure categories.

## Categories

1. **artifact**:
   The image file or checksum is missing, corrupt, or does not match manifest profiles.
2. **bootloader**:
   Early firmware (m1n1, U-Boot, GRUB) errors before loading the kernel.
3. **kernel**:
   Panic outputs, root filesystem mounting failures, or DTB mismatch.
4. **systemd**:
   Systemd target ordering fails, blocking `cidre-firstboot-root.service`.
5. **firstboot**:
   Firstboot root scripts fail to execute or loop indefinitely.
6. **OOBE**:
   Visual console OOBE prompts do not render.
7. **seed/resume**:
   Bootstrap seeds under `/var/lib/cidre/seed/` are missing or corrupted.
8. **handoff**:
   Normal user account is not created or `install --resume` targets are missing.
