# Cidre (v0.11.0 Base Setup TUI Pack)

Cidre is an Apple Silicon Mac-oriented Linux experience layer built on ALARM (Arch Linux ARM) / Asahi Linux.

> [!IMPORTANT]
> **Cidre is not a niri fork.**
> Cidre is a full integration layer that manages installer scripts, configuration deployment, system recovery, sound optimization, and desktop session profiles. The compositor itself is managed under a separate component called `niri-cidre`.

## Installation

### Phase 1: Fresh ALARM Root Setup
Log in as `root`, sync packages, and clone the repository:
```bash
pacman -Sy --needed git
git clone https://github.com/Yasuno-5555/Cidre.git
cd Cidre
./preinstall
```

`./preinstall` now opens a guided root-phase dashboard/wizard when a TTY is available. It falls back to plain shell prompts when `dialog`/`whiptail` are unavailable, and `./preinstall --check` remains non-destructive.

### Phase 2: Normal User Setup
After base environment preparation finishes, switch to your normal user and execute the installer:
```bash
su - <username>
cd ~/Cidre
./install
```

## Documentation Guides

- [Guided Onboarding](./docs/onboarding.md)
- [Fresh ALARM Base Setup](./docs/base-install.md)
- [Installation Guide (Advanced)](./docs/installation.md)
- [Stable Commands Reference](./docs/commands.md)
- [Installation Profiles](./docs/profiles.md)
- [Package Ownership Index](./docs/packages.md)
- [Managed Files Inventory](./docs/managed-files.md)
- [Validation Matrix](./docs/validation-matrix.md)
- [Known Limitations](./docs/known-limitations.md)
- [v1.0.0 Clean-Install Test Plan](./docs/v1.0.0-clean-install-test-plan.md)
- [Update Guide](./docs/update.md)
- [Maintenance Guide](./docs/maintenance.md)
- [Recovery Guide](./docs/recovery.md)
- [Diagnostics Guide](./docs/diagnostics.md)
- [Configuration Management Guide](./docs/config-management.md)
- [v0.11.0 Release Notes](./docs/v0.11.0-base-setup-tui.md)
- [v0.10.0 Release Notes](./docs/v0.10.0-base-install-simplification.md)
- [v0.9.0 Release Notes](./docs/v0.9.0-rc-readiness.md)
- [v0.8.0 Release Notes](./docs/v0.8.0-update-maintenance.md)
- [v0.7.0 Release Notes](./docs/v0.7.0-stability-rollback.md)
- [v0.6.0 Release Notes](./docs/v0.6.0-daily-driver-polish.md)
- [v0.5.0 Release Notes](./docs/v0.5.0-guided-onboarding.md)
