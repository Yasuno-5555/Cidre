# Install Stages

Cidre guided installation progress is tracked via the following discrete stages defined in `installer/stages.json`:

1. `macos-preflight`: Verifying macOS readiness and tools.
2. `macos-seed`: Creating the initial seed file.
3. `macos-handoff`: Generating boot guidelines.
4. `alarm-install`: The Arch Linux ARM installation process.
5. `root-preinstall`: Executing the root preinstall configuration script.
6. `normal-user-handoff`: Switch over to normal user.
7. `user-install`: Executing user configuration script.
8. `firstboot`: Initial boot configuration and services.
9. `user-phase`: final logging and system health checks.
10. `desktop-verification`: Verification of the graphical desktop.
11. `install-complete`: Finished guided installation.
