# Cidre.app Install Wizard

The setup wizard follows Welcome, Compatibility, Backup/Safety, Disk Plan, Install Plan, Privileged Preparation, Seed Generation, Artifact Preparation, Install Execution, Verification, and Finish.

The Disk Plan step is the only disk mutation entrypoint. As of v0.35.1 it is also covered by DFU incident containment, so disk-changing install remains disabled by default until the installer kill switch is explicitly enabled for test and the boot safety gates are satisfied.

The UI still exposes planning and safety context, but the helper refuses `partition-create` and APFS resize execution while containment is active.

The launchable local application is `dist/Cidre.app`.
