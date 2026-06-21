# Firstboot Verification

This document summarizes the validation rules for the Cidre first boot state.

## Marker File Checking

The initialization system tracks the orchestration flow by writing markers to the state directory:
- `/var/lib/cidre/firstboot-root/started`: Set when the setup process begins.
- `/var/lib/cidre/firstboot-root/completed`: Set on clean completion of OOBE.
- `/var/lib/cidre/firstboot-root/failed`: Set if setup exits with error.

## Handoff Verification

The handoff target file (`/var/lib/cidre/firstboot-root/handoff.txt`) must include:
- Instructions to change root credentials.
- Instructions to run the user setup resume commands:
  ```bash
  su - <username>
  cd <repo-path>
  ./install --resume
  ```
- Profiles markers matching the manifest definitions.
