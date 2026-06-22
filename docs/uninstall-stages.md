# Uninstall Stages

The guided uninstaller processes exit via the following sequential stages:
- **preflight**: Verify system prerequisites and environment.
- **export**: Gather log files, reports, and system state artifacts.
- **partition audit**: Document system partition tables.
- **target scan**: Scan disk devices and identify uninstallable spaces.
- **target review**: Analyze the specific uninstall candidate.
- **dry-run**: Mock the execution phase.
- **restore handoff**: Hand off guidance to the macOS side helper.
- **verify**: Ensure that the uninstall finished cleanly.
