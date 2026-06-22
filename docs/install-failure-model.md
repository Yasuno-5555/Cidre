# Install Failure Model

When any phase encounters a failure, the installer:
1. Records the failure details inside `install-state.json`.
2. Resolves suggested actions from `installer/failure-actions.json`.
3. Creates a markdown failure report via `cidre-install-failure-report`.
4. Suggests diagnostic recovery entrypoints (e.g. `cidre-doctor` or `cidre-recovery`).
