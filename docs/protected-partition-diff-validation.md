# Protected Partition Diff Validation

v0.35.2 adds machine-readable disk and APFS snapshots, protected Apple partition
classification, and pre/post diff validation.

Goals:

- prove protected Apple partitions remain unchanged
- separate allowed Cidre target changes from blocked Apple partition changes
- keep boot safety blocked whenever evidence is missing or unsafe
