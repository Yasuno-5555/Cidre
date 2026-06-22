# Disk Snapshot Schema

`scripts/cidre-app-disk-snapshot --json` records:

- host metadata
- disk and partition layout
- startup disk identifiers
- protected partition summary

`scripts/cidre-app-apfs-snapshot --json` records:

- APFS containers
- physical stores
- volume roles
- protected container and volume hints
