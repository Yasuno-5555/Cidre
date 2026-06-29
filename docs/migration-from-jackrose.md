# Migration from Jackrose to Jackrose

Jackrose is the new name for the project formerly known as Jackrose. 

## Migration Steps for Users

For most users, the migration will happen automatically. The first time Jackrose runs or when package upgrades are applied, the system will migrate your configurations.

### Configuration and Data Locations

The following paths are migrated:

- `~/.config/jackrose` -> `~/.config/jackrose`
- `~/.local/share/jackrose` -> `~/.local/share/jackrose`
- `/etc/jackrose` -> `/etc/jackrose` (where applicable)
- `/var/lib/jackrose` -> `/var/lib/jackrose` (where applicable)

> [!NOTE]
> System shared assets in `/usr/share/jackrose` are owned by the package manager and will not be moved directly. The new packages will populate `/usr/share/jackrose` directly.

### Command Line Interface

The old `jackrose` commands are now deprecated. Compatibility wrappers are provided for:
- `jackrose` -> forwards to `jackrose`
- `jackrose-doctor` -> forwards to `jackrose-doctor`
- `jackrose-welcome` -> forwards to `jackrose-welcome`

Please update your scripts and aliases to use `jackrose` instead of `jackrose`.
