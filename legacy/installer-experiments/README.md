# Legacy Installer Experiments

## Purpose

This directory marks the old full-installer effort as legacy.

Jackrose is currently focused on Post-ALARM Bootstrap, not on reviving a full Apple Silicon installer stack.

## What Belongs Here

- macOS GUI installer experiments
- privileged disk helper work
- wrapper staging and controlled-install experiments
- boot-policy mutation helpers
- m1n1 acquisition or build experiments
- uninstall-pipeline assets tied to old installer assumptions
- generated metadata and dry-run fixtures from superseded installer paths

## Current Policy

At the moment, most legacy assets are still stored in their original paths and are marked legacy by policy rather than physically moved.

That is intentional.

The repository still contains:

- active references
- command contracts
- historical docs
- tests and fixtures

Moving them all at once would create avoidable breakage. This directory therefore acts as a stable index and policy anchor first.

## Legacy-By-Policy Index

- `installer/bootstrap/`
- `installer/compat/`
- `installer/generated/`
- `installer/scripts/*wrapper*`
- `installer/scripts/*compat*`
- `installer/scripts/*metadata*`
- `installer/scripts/*plan*`
- `installer/scripts/*validate*`
- `apps/macos/JackroseApp/Sources/JackroseApp/`
- `apps/macos/JackroseApp/Helper/`
- `scripts/jackrose-macos-*install*`
- `scripts/jackrose-macos-*rescue*`
- `scripts/jackrose-macos-*uninstall*`
- `scripts/jackrose-app-m1n1-*`
- `scripts/jackrose-app-boot-policy-*`
- `scripts/jackrose-app-repair-boot-policy`
- `scripts/jackrose-uninstall*`
- `uninstaller/`
- `docs/INSTALL_legacy.md`

## Active Counterpart

The active implementation direction lives in:

- `docs/jackrose-post-alarm-bootstrap.md`
- `docs/jackrose-installer-legacy-policy.md`
- `scripts/jackrose-bootstrap`

## Move Strategy

If and when physical relocation becomes safe, move legacy assets incrementally:

1. move the highest-risk assets first
2. verify imports, paths, and tests
3. keep docs and fixtures readable
4. prefer reference-only preservation over large risky rewrites
