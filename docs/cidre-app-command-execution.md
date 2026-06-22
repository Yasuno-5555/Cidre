# Cidre.app Command Execution

## Allowed Commands
Only safe, read-only commands without root-elevation requirements are permitted for real execution. Examples:
* `scripts/cidre-app-readiness --json`
* `scripts/cidre-interface-doctor --json`
* `scripts/cidre-app-action-plan --install --json`
* `scripts/cidre-app-action-plan --uninstall --json`
* `scripts/cidre-artifact-paths --all --json`
* `scripts/cidre-report-index --scan --json`

## Blocked Commands
All system-altering or privilege-elevating commands are strictly blocked. Example execution yields a `blocked` status JSON.

## Output Handling
* Standard output (stdout) is parsed into `CommandResult` structures if JSON is supported.
* Standard error (stderr) is captured and rendered inside validation logs.
* Execution timelines and exits codes are preserved in memory log stores.
