# Install State Layout

The installer state is persisted across system phases and reboots under the following directories:

## State Layout
- macOS: `$HOME/.local/state/cidre/install/current/install-state.json`
- Linux/User: `~/.local/state/cidre/install/current/install-state.json`
- Linux/Root/System: `/var/lib/cidre/install/install-state.json`

## State Model Schema
```json
{
  "schema_version": 1,
  "stage": "macos-preflight",
  "status": "passed",
  "next_stage": "macos-seed",
  "next_command": "./install-macos --continue",
  "failure_reason": "",
  "timestamp": "2026-06-22T00:00:00Z"
}
```
