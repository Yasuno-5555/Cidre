# Protected Apple Partitions

Cidre treats Apple recovery and startup-critical partitions as immutable during installer containment.

Protected examples:

- Apple_APFS_Recovery
- Apple_APFS_ISC
- recoveryOS-related partitions
- preboot / VM roles tied to the active startup disk
- current macOS startup APFS container and physical store
- other Apple-labelled partitions that are not explicitly known-safe Cidre targets

Any unexpected change in these areas blocks install completion.
