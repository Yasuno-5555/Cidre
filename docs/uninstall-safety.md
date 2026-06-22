# Uninstall Safety

## Export First
System state backup is required before uninstall planning. If no verified state export exists, progression is blocked.

## Dry-run First
Previewing changes with dry-run is required prior to unlocking execute steps.

## Explicit Confirmation
Execution requires `--uninstall` and `--i-understand-this-deletes-cidre` arguments.

## Protected Target Rules
System critical targets are hard-blocked to avoid bricking macOS systems.
