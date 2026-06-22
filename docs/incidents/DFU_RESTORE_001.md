# DFU_RESTORE_001

## Summary

GUI install flow appeared to complete, but the machine later failed before reaching m1n1 or normal Apple Recovery handoff and required DFU recovery intervention.

## Impact

- Startup Options could become unavailable
- Apple Recovery path could be damaged or inconsistent
- DFU restore could be required

## Containment

- Disk-changing install is disabled by default
- Protected Apple partitions must remain unchanged
- Pre/post disk snapshots are required for any future test enablement
- Finish, restart, and shutdown must stay blocked until boot safety gates pass
