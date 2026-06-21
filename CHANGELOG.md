# Changelog

All notable changes to the Cidre project will be documented in this file.

## [0.11.0] - 2026-06-21
### Added
- Guided `./preinstall` dashboard/wizard mode with backend selection across `dialog`, `whiptail`, and plain shell fallback.
- Root-phase setup status dashboard covering system, Apple Silicon hints, network, pacman, user, sudo, tools, next step, and preinstall log paths.
- Guided user selection/creation, wheel/sudo setup, isolated sudoers validation, and final root-to-user handoff output.
- Root-phase preinstall state logging under `~/.local/state/cidre/preinstall/` with `preinstall.log`, `last-check.log`, and `last-status`.

### Changed
- `cidre-doctor --base-readiness` terminology now aligns with preinstall readiness checks and points back to the root-phase entrypoint.
- Root execution failure path in `./install` now redirects to `./preinstall` and `cidre-doctor --base-readiness --summary`.
- `cidre-preinstall` package metadata now documents optional `dialog` and `whiptail` backends.

## [0.10.0] - 2026-06-21
### Added
- Root-phase helper utility `preinstall` (backed by `scripts/cidre-preinstall`) managing package sync, base utilities sync (`git`, `curl`, `sudo`, `base-devel`), sudo/wheel configuration validation, and normal user account verification.
- Intercept and guidance redirection pointing root execution attempts on `./install` to run `./preinstall --prepare` first.
- Pre-install base setup diagnostics flag `cidre-doctor --base-readiness` verifying network link, DNS lookups, system clock sanity, filesystem permissions, disk space, and Asahi platform hints.
- Consolidated guide for fresh ALARM base environment setups under `docs/base-install.md` and release notes under `docs/v0.10.0-base-install-simplification.md`.

## [0.9.0] - 2026-06-21
### Added
- Release candidate diagnostics check-suite inside `cidre-doctor --rc-readiness` auditing local tree command files, docs, global path statuses, and state structures.
- Release candidate installer validation dry-run `install --rc-dry-run` compiling all profile and doctor tests in a single simulation sweep.
- Consolidated documentation references for commands, profiles, package ownership, managed files, validation matrix, known limitations, and the v1.0.0 clean-install test plan.

## [0.8.0] - 2026-06-21
### Added
- Integrated update controller script `cidre-update` supporting `--check`, `--dry-run`, `--apply`, and `--doctor`.
- Everyday maintenance console `cidre-maintenance` supporting `status`, `prune`, `drift`, and `logs`.
- New diagnostic check-suite inside `cidre-doctor --maintenance` covering state, manifest, log health, and configuration drift.
- Enhanced snapshot pruning in `cidre-snapshot` supporting `--older-than` cutoff and interactive deletion prompts.
- Integration updates in firstboot diagnostic audits, welcome banners, and guided installers.
- Independent packaging definitions for `cidre-update` and `cidre-maintenance` packages under `packages/arch`.

## [0.7.0] - 2026-06-21
### Added
- Dedicated snapshot utility command `cidre-snapshot` for configuration backups.
- Automatic configuration pre-apply snapshot hooks inside `cidre-user-setup`.
- Rollback and history subcommands to `cidre-user-setup`.
- Extended `cidre-recovery` to run snapshots listings and rollback restores.
- Saved diagnostic execution runs, with parameters `--last`, `--history`, and `--fix-suggestions` in `cidre-doctor`.

## [0.6.0] - 2026-06-21
### Added
- Sane keybindings for window and workspace navigation (Super + Enter for Ghostty).
- Waybar native wireplumber audio volume and battery indicators.
- Sane Print Screen key bindings for Grim/Slurp screenshot flows.
- Extended volume, mute, unmute, and restart actions to `cidre-audio`.
- Daily diagnostics `--daily` verification flag in `cidre-doctor`.

## [0.5.0] - 2026-06-21
### Added
- Root-level `./install` entrypoint.
- `cidre-installer` guided interactive CLI manager.
- `desktop`, `developer`, `minimal`, and `recovery` installation profiles.
- `cidre-firstboot` first-boot verification helper script and package.
- Onboarding documentation.
- Integrated post-install check markers and installation logging.

## [0.4.0] - 2026-06-21
### Added
- `--check` and `--dry-run` modes to `bootstrap.sh`.
- `cidre-doctor` health diagnostics command.
- `cidre-diagnostics` Arch package definition.
- `doctor`, `list`, and `restore` subcommands to `cidre-recovery`.
- `check-packages` package verification script.
- `verify` and `list` subcommands to `cidre-user-setup`.
- Complete documentation guides for installation, recovery, and diagnostics.

## [0.3.0] - 2026-06-21
### Added
- Unified Catppuccin Mocha theme configuration for Waybar, Ghostty, and fuzzel.
- Premium abstract desktop wallpaper asset and `cidre-wallpapers` package.
- Systemd user service `fcitx5.service` to manage Japanese Mozc inputs.
- First-login dashboard CLI command `cidre-welcome`.
- Python-based configuration setup manager `cidre-user-setup` with backups and profile levels.

## [0.2.0] - 2026-06-21
### Added
- Automated `bootstrap.sh` script to install packages, localectl keymaps, and configure `greetd`.
- Core recovery tool `cidre-recovery` and audio profile settings `cidre-audio`.
- Updated package templates for `niri-cidre` remote fetch.

## [0.1.0] - 2026-06-20
### Added
- Initial proof-of-concept monorepo.
- ALARM minimal desktop boots on niri compositors.
