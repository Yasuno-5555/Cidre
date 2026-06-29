# Jackrose Installer Architecture Boundaries

## Purpose

This document defines the implementation boundary for the next Jackrose phase so that we can reuse useful assets without inheriting the dangerous parts of older installer experiments.

The current active phase is Post-ALARM Bootstrap, not full-installer development.

## Primary Rule

Jackrose should integrate with the existing Asahi and ALARM boot stack, not replace it.

That means the active Jackrose bootstrap layer should focus on:

- install image composition
- installer profile selection
- firstboot and welcome experience
- deferred recovery provisioning
- doctor, readiness, and repair workflow
- handoff reports and operator guidance

Jackrose should not become the owner of low-level Apple Silicon boot mutation.
Users are expected to complete ALARM minimal installation and initial network setup before Jackrose takes over.

## In-Bounds Responsibilities

### 1. Post-ALARM Bootstrap Layer

Allowed sources:

- `image/`
- `downstream/rootfs-overlay/`
- `installer/metadata/`
- `scripts/jackrose-bootstrap`

Allowed responsibilities:

- package and overlay composition
- post-ALARM readiness checks
- rootfs validation
- install profile metadata
- artifact manifest generation
- read-only verification and reporting

### 2. Firstboot and Welcome

Allowed sources:

- `components/firstboot/`
- `components/welcome/`
- `scripts/jackrose-firstboot*`

Allowed responsibilities:

- initial user setup
- first-login guidance
- deferred post-install tasks
- retry and repair entrypoints
- user-phase handoff

### 3. Recovery, Doctor, and Repair

Allowed sources:

- `scripts/jackrose-doctor`
- `scripts/jackrose-recovery*`
- `scripts/jackrose-rescue*`
- `rescue/`

Allowed responsibilities:

- read-only health checks
- recovery shell and repair guidance
- rescue environment profile definition
- target eligibility checks
- rescue reporting and operator instructions

### 4. Safety Contracts and Policy Assets

Allowed sources:

- `installer/metadata/schema/`
- `rescue/create/*.json`
- `uninstaller/*.json`

Allowed responsibilities:

- machine-readable policy
- target guardrails
- confirmation rules
- report schema and interoperability contracts

## Reference-Only Areas

These areas are useful as design evidence but should not be promoted directly into the new runtime:

- `installer/bootstrap/`
- `installer/compat/`
- `installer/scripts/*wrapper*`
- `installer/scripts/*compat*`
- `scripts/jackrose-macos-*`
- `apps/macos/JackroseApp/Sources/JackroseApp/`
- historical installer and release docs under `docs/`
- legacy installer experiments indexed under `legacy/installer-experiments/README.md`

Use them for:

- terminology
- report structure
- UI sequencing ideas
- compatibility lessons
- prior failure analysis

Do not use them as the default implementation substrate.

## Frozen Areas

These assets should remain in the repository for historical traceability, but the next installer should not directly integrate them without a new design review.

### Critical Freeze

- `apps/macos/JackroseApp/Helper/JackrosePrivilegedHelper/Sources/JackrosePrivilegedHelper/DiskOperationService.swift`
- any code path that executes `diskutil apfs resizeContainer`
- any code path that deletes APFS volumes or partitions

### High-Risk Freeze

- `installer/scripts/jackrose-wrapper-stage-target`
- `scripts/jackrose-app-boot-policy-create`
- `scripts/jackrose-app-repair-boot-policy`
- `scripts/jackrose-app-m1n1-acquire`
- `scripts/jackrose-app-m1n1-build`
- `scripts/jackrose-uninstall-execute`
- `scripts/jackrose-image-mount`
- `scripts/jackrose-image-unmount`
- `scripts/jackrose-rescue-mount`

## Explicitly Out of Scope

The next installer phase should not add or directly absorb logic for:

- APFS resize or container mutation
- partition create or delete
- default startup disk mutation
- NVRAM writes
- m1n1 build, acquisition, or boot policy ownership
- GRUB or ESP ownership logic
- automatic boot entry mutation
- live macOS privileged execution flow

If any of these become necessary later, they should be introduced as a separately reviewed subsystem with explicit safety gates.

## Implementation Split To Preserve

The repository already hints at a healthy split. Keep that split:

- `build and compose`
  use `image/`, `downstream/`, metadata, manifests
- `firstboot and welcome`
  use `components/` and `scripts/jackrose-firstboot*`
- `read-only checks and repair`
  use doctor, recovery, rescue check/report tools
- `dangerous mutation experiments`
  keep isolated, frozen, and non-default

## Candidate Starting Set For The Next Phase

If we continue the active Post-ALARM Bootstrap phase, the safest seed set is:

- `scripts/jackrose-bootstrap`
- `image/scripts/prepare-rootfs`
- `image/scripts/apply-overlays`
- `image/scripts/enable-firstboot`
- `components/firstboot/`
- `components/welcome/`
- `scripts/jackrose-doctor`
- `scripts/jackrose-recovery*`
- `scripts/jackrose-rescue-target-check`
- `rescue/create/target-rules.json`
- `installer/metadata/schema/jackrose-installer-metadata.schema.json`

For policy detail, see:

- `docs/jackrose-post-alarm-bootstrap.md`
- `docs/jackrose-installer-legacy-policy.md`

## Deletion Boundary

Assets should only move to removal after their replacement exists and is validated.

Likely future removal candidates:

- old generated local installer metadata samples
- obsolete dry-run fixtures that describe superseded wrapper paths
- legacy installer docs that duplicate the new boundary documents

Until then, keep them as reference material rather than executable authority.
