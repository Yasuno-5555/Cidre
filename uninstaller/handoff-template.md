# macOS Restore Handoff Guide

You have completed the Linux-side preparation phase of the guided uninstall.

Next, you need to transition back to macOS to finalize partition cleanup.

## Actions to perform in macOS:
1. Boot back into macOS.
2. Verify disk layout using diskutil:
   ```sh
   diskutil list
   ```
3. Use the macOS Restore Assistant or Disk Utility to remove the Cidre/Asahi container:
   ```sh
   ./install-macos --uninstall-plan
   ```
4. Restore default boot disk selection:
   ```sh
   ./install-macos --startup-disk-check
   ```
