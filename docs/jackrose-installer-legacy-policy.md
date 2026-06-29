# Jackrose Installer Legacy Policy

## Purpose

This document records that previous full-installer efforts are now treated as legacy experiments.

Jackrose will not currently continue the old macOS GUI installer, wrapper staging installer, boot-policy helper, or APFS mutation path as active runtime code.

## Reason

The project now prioritizes a reliable post-ALARM bootstrap path over full installation automation.

Jackrose is explicitly narrowing its responsibility to the point after Asahi ALARM minimal is already installed and network-ready.

## Legacy Areas

- macOS GUI installer shell
- privileged disk helper
- wrapper staging pipeline
- m1n1 acquisition and build experiments
- boot-policy mutation helpers
- direct APFS and partition mutation tooling
- old uninstall pipeline
- generated installer metadata samples

Representative paths:

- `installer/bootstrap/`
- `installer/compat/`
- `installer/generated/`
- `installer/scripts/*wrapper*`
- `installer/scripts/*compat*`
- `installer/scripts/*metadata*`
- `installer/scripts/*plan*`
- `installer/scripts/*validate*`
- `apps/macos/JackroseApp/Sources/JackroseApp/`
- `apps/macos/JackroseApp/Helper/`
- `scripts/jackrose-macos-*install*`
- `scripts/jackrose-macos-*rescue*`
- `scripts/jackrose-macos-*uninstall*`
- `scripts/jackrose-app-m1n1-*`
- `scripts/jackrose-app-boot-policy-*`
- `scripts/jackrose-app-repair-boot-policy`
- `scripts/jackrose-uninstall*`
- `uninstaller/`
- `docs/INSTALL_legacy.md`

## Active Areas

- post-ALARM bootstrap
- firstboot
- welcome
- doctor
- recovery guidance
- package profiles and desktop baseline
- config deployment
- readiness checks
- reports and resume flow

Representative paths:

- `scripts/jackrose-bootstrap`
- `scripts/jackrose-doctor`
- `scripts/jackrose-recovery*`
- `scripts/jackrose-firstboot*`
- `components/firstboot/`
- `components/welcome/`
- `image/`
- `downstream/rootfs-overlay/`

## Rule

Legacy installer assets may be used for:

- terminology
- UI sequencing ideas
- report formats
- safety contracts
- prior failure analysis

They must not be promoted back into runtime code without a new design review.

## Current Handling

For this phase, risky installer assets are marked legacy by policy and indexed under `legacy/installer-experiments/README.md`.

Physical moves should happen only when they do not break active scripts, imports, or tests.
