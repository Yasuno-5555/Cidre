# Uninstall State

## State Layout
State is tracked in:
- Linux user space: `~/.local/state/cidre/uninstall/current/uninstall-state.json`
- Linux root space: `/var/lib/cidre/uninstall/uninstall-state.json`
- macOS space: `.local/state/cidre/macos-uninstall/current/uninstall-state.json`

## Stage Model
Stages transit sequentially based on success status.

## Status Values
- `pending`
- `running`
- `passed`
- `failed`
- `blocked`
- `skipped`

## Resume
Run `cidre-uninstall-resume` to determine and run the next scheduled command.
