# Cidre Welcome Optimized Experience Upgrade Design

This document details the optional desktop upgrade workflow for installing Cidre's optimized graphical environment components (`Ghostty` terminal, `fish` shell, and `niri-cidre` compositor).

---

## 1. Safety Guidelines

> [!IMPORTANT]
> **Preserve the Baseline Fallback**
> The upgrade process is optional and time-consuming. Any failure or interruption during compilation or installation of optimized components **must not** damage or remove the baseline fallback desktop (`upstream niri` + `foot` terminal + `bash` shell). The baseline must remain active and functional.

---

## 2. State & Log Markers

To manage state tracking and logging, we define the following paths:

- `/var/lib/cidre/welcome.done`
  - Created when the graphical Cidre Welcome setup completes.
- `/var/lib/cidre/optimized.done`
  - Created only when all optimized components build and deploy successfully.
- `/var/lib/cidre/experience-upgrade.state`
  - Tracks step-by-step progress to allow retry or resume actions:
    ```ini
    ghostty=done
    fish=configured
    niri_cidre=failed
    ```
- `/var/log/cidre/experience-upgrade.log`
  - Captures full compiler, package, and script outputs.

---

## 3. Toolchain & Commands

The upgrade is orchestrated by:
- `cidre-experience-upgrade`
  - Verification check, network check, and sequencing command.
- `cidre-build-ghostty`
  - Build helper compiling or deploying Ghostty terminal.
- `cidre-build-niri-cidre`
  - Build helper compiling or deploying optimized niri.
- `cidre-setup-fish`
  - Setup helper configuring fish shell settings.
