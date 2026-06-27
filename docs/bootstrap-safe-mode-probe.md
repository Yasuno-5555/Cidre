# Bootstrap Safe-mode / No-exec Capability Probe

This document details the design and execution bounds of the bootstrap safe-mode capability probe.

---

## 1. Safety Guidelines

> [!WARNING]
> **No Execution**
> Phase 25 does not run the Asahi/ALARM installer.
> Do **not** execute bootstrap scripts, install.sh, or pipe curl outputs into shell.
> `SAFE_MODE_FOUND` means a safe-looking static path exists.
> It does **not** prove real installer safety.

---

## 2. Decision Matrix

The probe parses the target bootstrap snapshot and emits one of three decisions:
- **`SAFE_MODE_FOUND`**: A safe help/list/dry-run/no-exec flag branch exists before installer execution.
- **`NO_SAFE_MODE`**: No safe option branch is separable from execution.
- **`PATCH_REQUIRED`**: Safe metadata extraction is possible only with local script wrappers or patches.

---

## 3. Usage

To run the safe-mode probe:

```bash
installer/scripts/probe-bootstrap-safe-mode \
  --bootstrap-snapshot installer/bootstrap/upstream/asahi-bootstrap-dev.snapshot.sh \
  --override-env installer/override/examples/installer-env.metadata-only.localhost.env
```
