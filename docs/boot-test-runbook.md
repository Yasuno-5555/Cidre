# Boot Test Runbook

This document captures step-by-step actions for developers booting a custom Cidre prototype image.

## Step 1: Pre-Boot Validation

Run preflight checks to confirm target images are generated correctly:
```bash
scripts/cidre-controlled-boot-test --prepare --artifact .local/state/cidre/image-build/registered/cidre-prototype-rootfs.img
```
Read the generated checklist at `.local/state/cidre/boot-test/current/checklist.md`.

## Step 2: Boot Picker Execution

1. Power down your target Apple Silicon hardware.
2. Hold down the Power Button to access recovery options.
3. Select your custom prototype volume boot targets.
4. Observe the early terminal output:
   - Check if OOBE setup screen appears.
   - Note if default user configuration prompts show up.

## Step 3: Diagnostic Collection

After boot setup succeeds or halts, run the logs command:
```bash
scripts/cidre-controlled-boot-test --collect-logs
```
Verify the contents stored at `.local/state/cidre/boot-test/current/`.
