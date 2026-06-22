# Cidre.app Execution Log

## Log Record
Every safe command run triggers a log entry in memory:
* `timestamp`: Precise launch date.
* `commandLine`: Exact invoked command.
* `status`: PASS, BLOCKED, or FAIL outcome.
* `exitCode`: Exit code of process execution.
* `duration`: Runtime measured in milliseconds/seconds.
* `summary`: Decoded outcome from interface JSON.

## History UI
* Prepend-sorted logs list is displayed in the main navigation detail pane.
* Simple button action allows purging all runtime log items in settings/logs view.
