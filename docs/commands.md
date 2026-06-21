# Cidre Command Reference

This document catalogs all stable command line utilities provided by the Cidre desktop layer.

## User-Facing Commands

### `./preinstall` / `cidre-preinstall`
The root-phase base system helper.
* `--tui`: Forces the guided dashboard/wizard mode.
* `--check`: Audits base system packages and connections.
* `--dry-run`: Previews setup actions.
* `--prepare`: Installs core dependencies and configures wheel-sudo users.
* `--non-interactive`: Forces plain output without interactive prompts.
* `--user <name>`: Pins the target normal user for verification or creation.
* `--yes`: Auto-confirms prompts.

### `./install` / `cidre-installer`
The guided interactive orchestration installer.
* `--check`: Runs compatibility checks on commands and packages.
* `--dry-run`: Simulates the system bootstrap and configuration deploy.
* `--profile <name>`: Installs with the specified profile (`desktop`, `developer`, `minimal`, `recovery`).
* `--rc-dry-run`: Runs comprehensive simulation of all profiles and doctor audits.

### `cidre-user-setup`
Manages user configurations, profiles, and backup snapshots.
* `apply --profile <name>`: Deploys template files to the user's home directory.
* `verify`: Checks if configurations match expected template configurations or have drift.
* `diff`: Shows differences between deployed configurations and template sources.
* `rollback`: Reverts changes using the most recent auto-backup snapshot.

### `cidre-doctor`
Diagnoses system compatibility and environment state.
* `--daily`: Standard diagnostic suit covering wayland, binaries, service activation.
* `--maintenance`: Audits snapshot directories, log files, package synchronization dates.
* `--rc-readiness`: Confirms tree readiness for release candidate standards.
* `--base-readiness`: Audits root-phase readiness for `./preinstall`.
* `--base-readiness --summary`: Condensed readiness status for handoff/debugging.
* `--fix-suggestions`: Renders actionable recovery commands based on the last run.

### `cidre-recovery`
Dispatches rescue triggers from console TTY in emergency loops.
* `status`: Inspects session and config state.
* `safe-mode`: Disables compositor customizations and re-routes logins to console standard.
* `restore latest`: Restores configurations to the last snapshot.
* `reset-niri`: Resets composer files to stable factory defaults.

### `cidre-snapshot`
Takes snapshot points of Cidre configuration directories.
* `create [--label <lbl>]`: Copies configurations to a snapshot bundle.
* `list`: Chronologically lists available snapshot points.
* `prune [--keep <num>] [--older-than <dur>]`: Deletes older snapshots, protecting the latest index.

### `cidre-update`
Safe updater wrapper for packages and configurations.
* `--check`: Checks update prerequisites and Sync age.
* `--dry-run`: Previews incoming sync changes.
* `--apply`: Safely updates package databases and configuration templates.

### `cidre-maintenance`
Consolidates standard admin tasks.
* `status`: Displays snapshot statistics and log summaries.
* `prune`: Cleans up logs and snapshots interactively.
* `drift`: Tracks configuration updates.

### `cidre-welcome`
Visual dashboard greeting users with keybindings and navigation tips upon initial login.

### `cidre-audio`
Manages audio volume and buffer profiles (e.g. Asahi popping noise workarounds).
* `status`: Displays audio profiles.
* `profile stable`: Sets buffer rates for pop noise prevention.
