# Fully Guided Installer

## Purpose
The purpose of the Cidre Fully Guided Installer is to streamline the installation journey from macOS, through the ALARM/Asahi install phase, root preinstall, normal user phase, firstboot OOBE, and final desktop verification.

## Install Phases
- macOS Phase: Preflight checks, seed generation, handoff generation.
- ALARM Install: Raw installation of Arch Linux ARM.
- Root Preinstall: Sudo/pacman/user initialization.
- User Phase: Cidre package and configuration setup.
- Firstboot: Post-reboot system configuration.
- Desktop Verification: Validation of final compositor, audio, and IME configurations.

## Dashboard
Run `cidre-install-dashboard` to view the overall state of the installation.
