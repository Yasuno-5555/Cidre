# Jackrose Seed Image Builder (Skeleton)

This directory contains the builder scaffold for compiling Jackrose seed target images.
In a future phase, this directory is destined to be split into its own independent `Yasuno-5555/jackrose-image-builder` repository.

## Important Guidelines

> [!IMPORTANT]
> **Packages over Overlays**
> `overlays/jackrose-seed/` is strictly reserved for files that must be injected directly into the rootfs outside of the standard Pacman packaging cycle.
> Whenever possible, prefer shipping files via packages (`PKGBUILD`) rather than overlays. Keep overlays as a last-resort option.

> [!CAUTION]
> **Never Include completion markers**
> A Jackrose seed image must **never** contain `/var/lib/jackrose/firstboot.done`.
> If this marker is present in the seed rootfs, the OOBE firstboot setup daemon (`jackrose-firstboot.service`) will skip its execution, leaving the root password locked and the target environment permanently locked out.
