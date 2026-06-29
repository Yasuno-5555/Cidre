# Jackrose Installer Asset Inventory

## Purpose

This document inventories installer-related assets that remain in the Jackrose repository and classifies which ones should be reused, ported, referenced, frozen, or removed later for the next installer phase.

This is an audit artifact, not a new installer design or implementation.

Status note:

The inventory conclusions now feed the Post-ALARM Bootstrap pivot rather than a full-installer revival.

## Current Direction

The current direction is to avoid reimplementing low-level Apple Silicon boot handling inside Jackrose.

Jackrose should primarily own, after ALARM minimal and networking are already working:

- post-ALARM bootstrap readiness and takeover
- install image and profile integration
- firstboot and welcome flow
- deferred recovery provisioning
- doctor and repair workflow
- safety checks, reports, and operator handoff

Jackrose should not directly own:

- APFS container mutation strategy
- NVRAM or default boot mutation
- m1n1, GRUB, or ESP ownership logic
- direct boot stack reinvention that already exists in Asahi or ALARM
- the pre-ALARM installation phase itself

## Audit Snapshot

Audit run date: 2026-06-29

- Tracked files scanned: 6931
- Install-ish files in focused roots: 454
- Keyword grep hits in focused roots: 19504
- Focused roots: `install`, `install-macos`, `preinstall`, `README.md`, `installer/`, `image/`, `rescue/`, `uninstaller/`, `scripts/`, `apps/macos/`, `components/`, `downstream/`, `resources/`, `docs/`

Notes:

- The raw hit count is intentionally broad and includes design docs and fixtures.
- The most useful implementation clusters are `scripts/`, `installer/`, `apps/macos/JackroseApp/`, `image/`, `components/`, `rescue/`, and `downstream/`.
- Legacy `Cidre` residue still exists, but most hits are in migration docs and compatibility tooling rather than active installer code.

## Major Asset Groups

| Asset Group | Paths | Role | Tests | Suggested Category | Risk |
| --- | --- | --- | --- | --- | --- |
| Guided install CLI | `install`, `preinstall`, `scripts/jackrose-installer`, `scripts/jackrose-install-*` | Current shell entrypoints, state machine, reports, resume flow | Partial script-level validation | Reference | Medium |
| Seed image builder | `image/`, `image/scripts/*`, `downstream/rootfs-overlay/` | Build rootfs, apply overlays, enable firstboot, assemble seed artifacts | Some validation scripts and docs | Port | Medium |
| Firstboot and welcome | `components/firstboot/`, `components/welcome/`, `scripts/jackrose-firstboot*` | First login, user setup handoff, retry and repair | Present through services, scripts, docs | Port | Medium |
| Doctor and recovery UX | `scripts/jackrose-doctor`, `scripts/jackrose-recovery*`, `docs/recovery*.md` | Read-only checks, recovery UI, session repair guidance | Existing command surface | Reuse | Low |
| Rescue provisioning | `rescue/`, `scripts/jackrose-rescue*`, `rescue/overlay/usr/lib/jackrose/*` | Minimal rescue environment, target checks, create/preflight/report flow | Existing scripts and examples | Port | High |
| Installer metadata workspace | `installer/metadata/`, `installer/compat/`, `installer/bootstrap/`, `installer/scripts/*metadata*`, `*compat*`, `*plan*`, `*validate*` | Compatibility study, schemas, wrapper planning, dry-run contracts | Strongest test coverage in repo area | Reference | Low |
| Wrapper staging pipeline | `installer/scripts/jackrose-wrapper-*`, especially `*-stage-target` | Artifact selection, extraction, dry-run planning, target staging | Multiple test runners, but live risk remains | Freeze | High |
| macOS CLI orchestration | `scripts/jackrose-macos-*install*`, `scripts/jackrose-macos-*rescue*`, `scripts/jackrose-macos-*uninstall*` | Read-only macOS guidance, audits, handoff, rescue planning | Mostly command-contract style validation | Reference | Medium |
| macOS GUI installer shell | `apps/macos/JackroseApp/Sources/JackroseApp/` | Wizard UI, dashboard, target review, boot policy messaging, reports | Fixtures exist; automated coverage is limited | Reference | Medium |
| Privileged disk helper | `apps/macos/JackroseApp/Helper/JackrosePrivilegedHelper/.../DiskOperationService.swift` | `diskutil` execution for APFS resize, add/delete volume, partition delete | Helper-side validation only | Freeze | Critical |
| Uninstall pipeline | `uninstaller/`, `scripts/jackrose-uninstall*`, `scripts/jackrose-macos-uninstall*` | Target policy, protected target list, guided uninstall flow | Existing stage and failure-action definitions | Reference | High |
| Historical and release docs | `docs/*installer*`, `docs/*firstboot*`, `docs/*rescue*`, release notes | Design rationale and safety history | N/A | Reference | Low |

## Detailed Classification

| Paths | Naming | What It Does | Phase | Root Required | Sensitive Areas | Tests | Fit For New Direction | Category | Risk | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `image/`, `image/scripts/prepare-rootfs`, `image/scripts/apply-overlays`, `image/scripts/enable-firstboot`, `downstream/rootfs-overlay/` | Jackrose | Builds and prepares installable rootfs artifacts | Seed image assembly | Usually yes | Rootfs writes, package install, service enable | Some validation scripts | Strong fit for install image and deferred setup | Port | Medium | Best source for new install image pipeline |
| `components/firstboot/`, `components/welcome/`, `scripts/jackrose-firstboot*` | Jackrose | Firstboot OOBE, retry, repair, welcome, user handoff | Post-boot setup | Mixed | Service ordering, mutable state under `/var/lib/jackrose` | Existing service and docs coverage | Strong fit for new firstboot ownership | Port | Medium | Reuse behavior, rename only where needed |
| `scripts/jackrose-doctor`, `scripts/jackrose-recovery*` | Jackrose | Read-only diagnosis and guided recovery actions | Validation and repair | No for checks, mixed for repair | Session health, logs, state export | Existing command surface | Direct fit for doctor and repair workflow | Reuse | Low | Valuable as stable operator-facing tools |
| `rescue/`, `scripts/jackrose-rescue*`, `rescue/create/*.json` | Jackrose | Rescue slot profile, target checks, creation preflight, reports | Deferred recovery provisioning | Mixed | Mount, target selection, rootfs deployment | Examples and scripts present | Good fit if narrowed to minimal recovery environment | Port | High | Keep planning and profile assets; review live mutation steps carefully |
| `installer/metadata/`, `installer/compat/`, `installer/bootstrap/notes/`, `installer/scripts/*validate*`, `*compat*`, `*inspect*` | Jackrose and upstream snapshots | Records wrapper experiments, schema study, compatibility mapping, safety probes | Prior wrapper and integration phase | No | Mostly read-only analysis | 23 dedicated test runners in `installer/scripts/` | Useful as design evidence, not as runtime core | Reference | Low | Best evidence base for "what we learned" |
| `installer/scripts/generate-jackrose-install-plan`, `generate-jackrose-firstboot-handoff`, `bind-jackrose-final-install-contract` | Jackrose | Produces dry-run contracts and review-only install plans | Controlled wrapper phase | No | Plan generation, permission flags | Yes | Partial fit for contract design ideas | Reference | Low | Keep the contract language, not the full wrapper flow |
| `installer/scripts/jackrose-wrapper-stage-target` | Jackrose | Mounts target and copies validated rootfs into target path | Controlled staging phase | Yes | Mount, filesystem writes, staging apply | Some tests exist | Conflicts with new "do not directly own low-level staging" direction | Freeze | High | Do not integrate directly into next installer |
| `scripts/jackrose-installer`, `scripts/jackrose-install-*`, `install`, `preinstall` | Jackrose | Current guided shell installer and resume/report UX | Legacy and current CLI phase | Mixed | Package install, mutable state, repair flows | Partial | Useful for user flow ideas, not as future boot/install authority | Reference | Medium | Preserve UX language and report structure |
| `scripts/jackrose-macos-installer`, `scripts/jackrose-macos-*` | Jackrose | macOS-side handoff, partition audit, restore and rescue guidance | macOS wrapper phase | No for audits; mixed overall | Disk inventory, startup disk messaging | Partial | Good as handoff and audit reference | Reference | Medium | Keep read-only guidance; avoid promoting into mutation engine |
| `apps/macos/JackroseApp/Sources/JackroseApp/` | Jackrose | GUI wizard, target review, progress, safety gates, reporting | GUI installer MVP | No by itself | Encodes install/uninstall state and boot-policy UX | Fixtures exist, but sparse tests | Useful only as interaction reference | Reference | Medium | Potential source for future Welcome or repair UI patterns |
| `apps/macos/JackroseApp/Helper/JackrosePrivilegedHelper/.../DiskOperationService.swift` | Jackrose | Executes `diskutil apfs resizeContainer`, add/delete volume, partition delete | macOS privileged mutation phase | Yes | APFS, partition delete, boot-adjacent disk mutation | Validation exists in code | Explicitly out of scope for new direction | Freeze | Critical | Keep for historical audit only |
| `uninstaller/`, `scripts/jackrose-uninstall*`, `scripts/jackrose-macos-uninstall*` | Jackrose | Guided uninstall, target rules, protected target checks, dry-run planning | Uninstall phase | Mixed | Partition delete, disk review, restore flow | Existing stage files | Useful for protection policy, not for installer runtime | Reference | High | Can mine rules and guardrails |
| `installer/generated/`, local fixtures, old dry-run samples, `docs/INSTALL_legacy.md` | Mixed | Generated or transitional assets from prior experiments | Transitional | No | None or low | N/A | Low long-term value once replacement path stabilizes | Remove Later | Low | Remove only after successor docs and flows are stable |

## High-Risk Assets

The following areas should be treated as explicit design-review inputs and should not be pulled into a new installer unchanged:

- `apps/macos/JackroseApp/Helper/JackrosePrivilegedHelper/Sources/JackrosePrivilegedHelper/DiskOperationService.swift`
- `installer/scripts/jackrose-wrapper-stage-target`
- `scripts/jackrose-app-m1n1-acquire`
- `scripts/jackrose-app-m1n1-build`
- `scripts/jackrose-app-boot-policy-create`
- `scripts/jackrose-app-repair-boot-policy`
- `scripts/jackrose-uninstall-execute`
- `scripts/jackrose-rescue-mount`
- `scripts/jackrose-image-mount`
- `scripts/jackrose-image-unmount`

Reasons:

- direct APFS or partition mutation
- target mount and filesystem writes
- boot policy or startup-disk-adjacent behavior
- m1n1 or boot-chain-adjacent ownership

## Reuse and Port Priorities

### Reuse First

- `scripts/jackrose-doctor`
- `scripts/jackrose-recovery*`
- JSON policy assets such as `rescue/create/target-rules.json` and `uninstaller/protected-targets.example.json`
- reporting and handoff patterns from the current shell tools

### Port With Adaptation

- `image/` seed assembly scripts
- `components/firstboot/`
- `components/welcome/`
- `scripts/jackrose-firstboot*`
- `scripts/jackrose-rescue*` with live mutation paths split from safe checks

### Reference Only

- `installer/` compatibility and wrapper workspace
- `scripts/jackrose-macos-*`
- `apps/macos/JackroseApp/Sources/JackroseApp/`
- installer and rescue design docs under `docs/`

### Freeze

- privileged helper disk mutation code
- wrapper staging apply scripts
- boot-policy mutation helpers
- m1n1 acquisition or boot-chain mutation experiments

## Naming and Historical Residue

- `Cidre` references still exist mainly in migration documents and compatibility tooling.
- The rename residue does not appear to be the main blocker for the next installer design.
- Rename-only migration is safe for user-facing firstboot and welcome assets, but not sufficient for the old macOS GUI or wrapper mutation flows.

## Recommended Next-Step Boundary

The active Post-ALARM Bootstrap phase should start from these assets:

- rootfs and seed-image assembly from `image/` and `downstream/`
- a new `scripts/jackrose-bootstrap` entrypoint
- firstboot and welcome runtime from `components/` and `scripts/jackrose-firstboot*`
- doctor and repair surface from `scripts/jackrose-doctor` and `scripts/jackrose-recovery*`
- rescue profile and target policy from `rescue/` and related JSON rules

It should explicitly avoid promoting these assets into the new runtime core:

- privileged disk mutation helper code
- direct wrapper staging apply code
- boot-policy mutation code
- experimental macOS installer MVP execution paths

Legacy policy and active phase definition now live in:

- `docs/jackrose-post-alarm-bootstrap.md`
- `docs/jackrose-installer-legacy-policy.md`
- `legacy/installer-experiments/README.md`
