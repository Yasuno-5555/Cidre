# Cidre.app Install Wizard

The setup wizard follows Welcome, Compatibility, Backup/Safety, Disk Plan, Install Plan, Privileged Preparation, Seed Generation, Artifact Preparation, Install Execution, Verification, and Finish.

The Disk Plan step is the only disk mutation entrypoint. It detects the startup APFS physical store, validates explicit resize values, previews the exact operation, requires an exact generated confirmation phrase, and invokes the helper through the macOS authentication dialog.

The launchable local application is `dist/Cidre.app`.
