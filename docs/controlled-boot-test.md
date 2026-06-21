# Controlled Boot Test

This document describes how to execute controlled boot tests on target Apple Silicon MacBook systems using the Cidre prototype image framework.

## Purpose

The primary goal of controlled boot validation is to observe the system initialization flow, OOBE startup parameters, temporary autologin scripts, and user handover markers without relying on unvalidated boot policies.

## Test Workflow

1. **Preflight Checks**:
   Check file integrity and manifest states:
   ```bash
   scripts/cidre-boot-preflight --artifact .local/state/cidre/image-build/registered/cidre-prototype-rootfs.img
   ```

2. **Test Environment Preparation**:
   Generate configuration templates and checklists:
   ```bash
   scripts/cidre-controlled-boot-test --prepare --artifact .local/state/cidre/image-build/registered/cidre-prototype-rootfs.img
   ```

3. **Observe Screen Output**:
   Manually boot the system and write observation logs:
   ```bash
   scripts/cidre-boot-observe \
     --firstboot-visible yes \
     --oobe-visible yes \
     --handoff-visible yes \
     --output .local/state/cidre/boot-test/current/observation.md
   ```

4. **Verify Markers**:
   Inspect state files inside rootfs:
   ```bash
   scripts/cidre-firstboot-verify --root / --expect-started
   ```

5. **Generate Summary**:
   Write the execution reports:
   ```bash
   scripts/cidre-controlled-boot-test --report --status success
   ```
