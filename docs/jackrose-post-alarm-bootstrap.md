# Jackrose Post-ALARM Bootstrap

## Policy

Jackrose does not currently provide a full Apple Silicon installer.

Users must first install Asahi ALARM minimal and connect to the network manually.

After that point, Jackrose takes over and configures the desktop, input method, session, packages, welcome flow, diagnostics, and bootstrap reporting.

This direction is the active implementation boundary for Phase J1.

## Phase Name

Phase J1: Post-ALARM Bootstrap

Alternative label:

Phase J1: Minimal ALARM Bootstrap Takeover

## Required User State

- Asahi ALARM minimal is installed
- The system is booted into a usable ALARM shell
- Network is connected by `nmcli` or equivalent
- `pacman` can sync or query package metadata
- A normal user exists
- `sudo` is available, or bootstrap can start from root

## Bootstrap Command

```sh
curl -fsSL https://jackrose.dev/bootstrap | bash
```

Repository-local entrypoint during development:

```sh
scripts/jackrose-bootstrap --check
scripts/jackrose-bootstrap --apply
```

## Jackrose Responsibilities

- detect Linux, architecture, and Asahi or ALARM environment
- verify network, DNS, `pacman`, `sudo`, and disk-space readiness
- install Jackrose package repository and keyring
- install Jackrose desktop baseline packages
- configure `niri`, terminal, launcher, and bar
- configure Japanese locale, keyboard, and input method
- deploy Jackrose configuration
- enable session, firstboot, and welcome flow
- run doctor checks
- generate bootstrap state and reports
- provide retry and resume guidance

## Initial Bootstrap Steps

1. `environment_check`
2. `user_check`
3. `network_check`
4. `pacman_check`
5. `disk_space_check`
6. `repo_setup`
7. `keyring_setup`
8. `package_install`
9. `config_deploy`
10. `input_setup`
11. `session_setup`
12. `service_enable`
13. `firstboot_enable`
14. `doctor`
15. `final_report`

## State and Report Paths

Preferred runtime paths:

- `/var/lib/jackrose/bootstrap/state.json`
- `/var/log/jackrose/bootstrap-report.txt`
- `/var/log/jackrose/bootstrap-report.json`

For local development and non-root testing, the bootstrap script may fall back to repository-local `.local/state/jackrose/bootstrap/` and `.local/state/jackrose/logs/`.

## Active Reuse Targets

Reuse directly:

- `scripts/jackrose-doctor`
- `scripts/jackrose-recovery*`
- `components/firstboot/`
- `components/welcome/`
- `scripts/jackrose-firstboot*`
- `downstream/rootfs-overlay/`
- `packages/arch/jackrose-*`

Port carefully:

- `image/scripts/prepare-rootfs`
- `image/scripts/apply-overlays`
- `image/scripts/enable-firstboot`
- `scripts/jackrose-rescue-target-check`
- `rescue/create/target-rules.json`

## Out of Scope

- APFS resize
- partition create or delete
- `diskutil`-driven mutation
- Asahi installer replacement
- ALARM installer replacement
- m1n1 ownership
- boot policy mutation
- default startup disk mutation
- NVRAM mutation
- GRUB or ESP ownership logic
- macOS-side GUI installer
- macOS privileged helper execution
- automatic recovery volume creation

## UX Direction

This phase does not prioritize a rich GUI.

The expected user experience is a straightforward CLI or TUI:

```text
Jackrose Bootstrap

This tool converts an Asahi ALARM minimal system into a Jackrose desktop environment.

Required:
[OK] Network connected
[OK] pacman reachable
[OK] sudo available
```

If bootstrap fails, Jackrose should show the failed step, the reason, the log path, and the next suggested command without performing automatic repair.
