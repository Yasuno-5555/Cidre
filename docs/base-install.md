# Fresh ALARM Base Setup Guide

This document describes how to prepare a fresh ALARM (Arch Linux ARM) or Asahi Linux Minimal install before running the Cidre guided installer.

## Root Setup Phase

Log into your fresh Asahi minimal console as `root` (default password is `root`).

### Step 1: Install Git & Clone Repository
Verify network connectivity and synchronize packages:
```bash
pacman -Sy --needed git
```

Clone the Cidre repository:
```bash
git clone https://github.com/Yasuno-5555/Cidre.git
cd Cidre
```

### Step 2: Run Preinstall Helper
Run the preinstall entrypoint:
```bash
./preinstall
```

On a TTY, `./preinstall` opens a guided dashboard/wizard that shows:

- current system readiness
- network and pacman state
- required base packages
- target user and wheel/sudo state
- the next required action
- the final handoff command to `./install`

If `dialog` or `whiptail` is unavailable, it falls back to plain shell prompts. For a non-destructive audit, use:

```bash
./preinstall --check
```

For command-line preparation without the wizard, use:

```bash
./preinstall --prepare --user yasuno
```

## User Installation Phase

After preinstall setup completes, switch to your normal user:
```bash
su - yasuno
```

Navigate back to the repository and execute the guided onboarding installer:
```bash
cd ~/Cidre
./install
```
