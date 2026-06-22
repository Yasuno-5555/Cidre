# Recovery Survival Check

`scripts/cidre-app-recovery-survival-check --json` verifies that the recovery
path still looks readable and classifiable.

Checks include:

- Apple_APFS_Recovery presence
- System Recovery presence
- startup APFS container presence
- startup disk readability
- APFS container classification availability
