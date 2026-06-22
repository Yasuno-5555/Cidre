# Cidre.app Safety Model

- **Read-only prototype restrictions**: Disables all system mutation actions in the GUI shell.
- **Dangerous commands blockade**: Intercepts `destructive_capable = true` commands and immediately returns blocked status.
- **User privilege isolation**: Blocks actions that require root/sudo access.
- **Mock execution mode**: Simulates script outputs without calling underlying commands.
