# Cidre Wrapper Metadata Selection Prototype

This document details the design and schema specifications of the wrapper metadata selection layers.

---

## 1. Safety Guidelines

> [!WARNING]
> **No Execution**
> Phase 27 does not run the Asahi/ALARM installer.
> Phase 27 does not fetch or extract the Cidre rootfs artifact.
> Do **not** execute bootstrap scripts, install.sh, or curl outputs.
> `selected-image.json` is a selection verification artifact, **not** an installation authorization.

---

## 2. Selection Specifications

To isolate metadata parsing from subsequent download blocks, the wrapper writes a `selected-image.json` record containing target keys:
- name, version, arch, platform.
- package, url, manifest, sha256.
- first_boot_mode.
- `install_allowed: false` (strictly locked).

---

## 3. Usage

To select an image:

```bash
installer/scripts/cidre-wrapper-select-image \
  --metadata installer/generated/asahi-installer-data.cidre.dev.normalized.json \
  --id cidre-seed-aarch64 \
  --output installer/wrapper/selected-image.json
```

To validate the selection file:

```bash
installer/scripts/validate-cidre-wrapper-selection \
  --selection installer/wrapper/selected-image.json
```
