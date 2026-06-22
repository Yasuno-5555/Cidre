# Cidre v0.28.0 Validation Matrix

The following matrix documents the verification scopes completed on Cidre before the v1.0.0 release.

## Verification Status

| Feature / Area | Static Analysis | Dry-Run | Sandboxed HOME | Live Session | Real Hardware | Notes |
| :--- | :---: | :---: | :---: | :---: | :---: | :--- |
| **preinstall setup** | Yes | Yes | N/A | Partial | No | Checks dashboard/wizard flow, fallback backend logic, user/sudo handoff, and network/pacman readiness |
| **macOS bootstrap** | Yes | Planned | N/A | No | No | POSIX shell syntax, Linux rejection path, profile validation, and seed generation paths checked statically |
| **seed verify/import/resume** | Yes | Partial | N/A | No | No | Valid seed verification, invalid profile rejection, unsafe path rejection, non-root import rejection, and resume path wiring checked |
| **downstream foundation** | Yes | Partial | N/A | No | No | Downstream docs exist, installer entry example validates as JSON, rootfs overlay layout exists, and firstboot-root prototype passes syntax checks |
| **image prototype** | Yes | Yes | N/A | No | No | Image build scripts parse, overlay sync runs, overlay tarball and checksum generate, manifest writes, and overlay inspection passes |
| **firstboot OOBE** | Yes | Yes | N/A | No | No | firstboot-root dry-run and status work, state transitions and handoff generation work under simulated roots, doctor/recovery report state, and overlay inspection includes OOBE scripts |
| **builder integration** | Yes | Yes | N/A | No | No | Builder configuration check, staging tree layout, script integration, artifact registration and promotion paths |
| **real image build** | Yes | Yes | N/A | No | No | Host tool checks, command invocation, artifact registering, metadata validation, report compilation, and logs collection |
| **bootstrap system** | Yes | Yes | N/A | Partial | No | System commands and pacman dependencies simulated |
| **user config apply** | Yes | Yes | Yes | Partial | No | Sandboxed user home file deployment fully tested |
| **diagnostics (doctor)** | Yes | Yes | Yes | Partial | No | Script parsing & maintenance checks verified |
| **niri configuration** | Yes | No | N/A | Partial | No | KDL configuration syntax static parsing verified |
| **audio profile settings** | Yes | No | N/A | Partial | Partial | Verified buffering variables, hardware pop pops popping tests deferred |
| **snapshot & prune** | Yes | Yes | Yes | Partial | No | Pruning chronological ranges and latest protection verified |
| **updates (update)** | Yes | Yes | Yes | Partial | No | Safe pacman synchronization checks verified |
| **maintenance status**| Yes | Yes | Yes | Partial | No | Verified log summaries, path checks, drift metrics |

* **Live Session**: Compositions and greeter tests on standard VMs.
* **Real Hardware**: Apple Silicon Mac environment validation is **deferred** until v1.0.0 clean-install validation.

## Image boot validation (v0.17.0)

| Check | Command |
|---|---|
| Builder status | `scripts/cidre-builder-status` |
| Image mount read-only | `scripts/cidre-image-mount <image>` |
| Rootfs inspect | `scripts/cidre-rootfs-inspect --rootfs <rootfs>` |
| Firstboot service enabled | Check `etc/systemd/system/multi-user.target.wants/` |
| Firstboot state clean | Verify `completed`/`skipped` markers absent |
| Boot readiness | `scripts/cidre-image-boot-readiness --rootfs <rootfs>` |
| Boot checklist | `scripts/cidre-boot-checklist --output checklist.md` |
| Boot log collection | `scripts/cidre-boot-log-collect --dry-run` |
| Doctor boot check | `scripts/cidre-doctor --boot` |
| Recovery boot status | `scripts/cidre-recovery boot-status` |

## Builder Integration Pack (v0.18.0)

| Check | Command |
|---|---|
| Builder config status | `scripts/cidre-builder-config` |
| Overlay injection | `scripts/cidre-builder-integrate --dry-run` |
| Build execution wrap | `scripts/cidre-builder-invoke --dry-run` |
| Build log analysis | `scripts/cidre-builder-log` |
| Artifact registration | `scripts/cidre-builder-artifacts` |
| Image promotion | `scripts/cidre-image-promote` |
| Doctor builder check | `scripts/cidre-doctor --builder` |
| Recovery builder check | `scripts/cidre-recovery builder-status` |

## Real Image Build Pack (v0.19.0)

| Check | Command |
|---|---|
| Environment checks | `scripts/cidre-build-environment` |
| Real build dry-run | `scripts/cidre-real-image-build --dry-run` |
| Builder execution run | `scripts/cidre-real-image-build --run` |
| Artifact register | `scripts/cidre-image-register` |
| Verification check | `scripts/cidre-image-verify` |
| Doctor real build checks | `scripts/cidre-doctor --real-build` |
| Recovery real build status| `scripts/cidre-recovery real-build-status` |

## Controlled Boot Test (v0.20.0)

| Check | Command |
|---|---|
| Boot preflight | `scripts/cidre-boot-preflight` |
| Controlled boot test | `scripts/cidre-controlled-boot-test` |
| Human observation record | `scripts/cidre-boot-observe` |
| Boot result | `scripts/cidre-boot-result` |
| Failure classification | `scripts/cidre-boot-failure-classify` |
| Boot test report | `scripts/cidre-boot-test-report` |
| Doctor controlled boot checks | `scripts/cidre-doctor --controlled-boot` |
| Recovery controlled boot status| `scripts/cidre-recovery boot-test-status` |

## Firstboot Fixup Pack (v0.21.0)

| Check | Command |
|---|---|
| Firstboot Diagnose | `scripts/cidre-firstboot-diagnose` |
| Firstboot Retry | `scripts/cidre-firstboot-retry` |
| Firstboot Repair | `scripts/cidre-firstboot-repair` |
| Firstboot Report | `scripts/cidre-firstboot-report` |
| Firstboot Console Status | `scripts/cidre-firstboot-console` |
| Doctor firstboot-fixup check | `scripts/cidre-doctor --firstboot-fixup` |
| Recovery firstboot-diagnose / retry / repair / report | `scripts/cidre-recovery firstboot-<subcommand>` |

## User Phase Handoff Pack (v0.22.0)

| Check | Command |
|---|---|
| User Handoff show/verify/import | `scripts/cidre-user-handoff <subcommand>` |
| User Phase State | `scripts/cidre-user-phase-state <subcommand>` |
| User Phase Verify | `scripts/cidre-user-phase-verify` |
| User Phase Report | `scripts/cidre-user-phase-report` |
| User Phase Repair | `scripts/cidre-user-phase-repair` |
| First Login Guidance | `scripts/cidre-first-login` |
| Doctor User Phase Checks | `scripts/cidre-doctor --user-phase` |
| Recovery User Phase Status/Report | `scripts/cidre-recovery user-phase-<subcommand>` |

## Uninstall & Exit Path Pack (v0.23.0)

| Check | Command |
|---|---|
| Uninstall readiness | `scripts/cidre-uninstall-check` |
| Exit plan generation | `scripts/cidre-exit-plan` |
| State export dry-run | `scripts/cidre-state-export --dry-run` |
| State export real generation | `scripts/cidre-state-export --include-logs --include-reports` |
| Partition audit text/json | `scripts/cidre-partition-audit` |
| macOS restore guide generation | `scripts/cidre-macos-restore-guide` |
| Uninstall risk classification | `scripts/cidre-uninstall-risk` |
| Goodbye report generation | `scripts/cidre-goodbye` |
| Erase preflight blocked mode | `scripts/cidre-erase-preflight --dry-run` |
| Doctor uninstall checks | `scripts/cidre-doctor --uninstall` |
| Recovery uninstall status | `scripts/cidre-recovery uninstall-status` |

## macOS Restore Assistant (v0.24.0)

| Check | Command |
|---|---|
| Restore help | `./install-macos --restore-help` |
| Restore check | `./install-macos --restore-check` |
| Partition audit | `./install-macos --partition-audit` |
| Startup disk check | `./install-macos --startup-disk-check` |
| Uninstall guide | `./install-macos --uninstall-guide` |
| Restore report | `./install-macos --restore-report` |
| macOS readiness check | `scripts/cidre-macos-check --restore-readiness` |
| Doctor macOS restore checks | `scripts/cidre-doctor --macos-restore` |

## Recovery Screen & Safe Mode (v0.25.0)

| Check | Command |
|---|---|
| Panic dry-run | `scripts/cidre-panic --reason desktop-session-failed --stage first-desktop --dry-run` |
| Recovery screen non-interactive | `scripts/cidre-recovery-screen --reason desktop-session-failed --non-interactive` |
| Recovery actions list | `scripts/cidre-recovery-actions --list` |
| Recovery action doctor dry-run | `scripts/cidre-recovery-actions --run doctor --dry-run` |
| Safe mode dry-run | `scripts/cidre-safe-mode --reason desktop-session-failed --dry-run` |
| Safe shell env | `scripts/cidre-safe-shell --print-env` |
| Session failure mock | `scripts/cidre-session-failure --component niri --exit-code 1 --reason niri-failed` |
| Desktop failure detect dry-run | `scripts/cidre-desktop-failure-detect --dry-run` |
| Emergency banner | `scripts/cidre-emergency-banner --reason desktop-session-failed` |
| Recovery report | `scripts/cidre-recovery-report` |
| Doctor recovery checks | `scripts/cidre-doctor --recovery-screen` |
| Doctor safe mode checks | `scripts/cidre-doctor --safe-mode` |
| Recovery screen command | `scripts/cidre-recovery screen --non-interactive` |
| Recovery safe mode command | `scripts/cidre-recovery safe-mode --dry-run` |

## Rescue Slot Foundation (v0.26.0)

| Check | Command |
|---|---|
| Rescue status | `scripts/cidre-rescue --check` |
| Rescue check | `scripts/cidre-rescue-check` |
| Rescue plan | `scripts/cidre-rescue-plan --size 8` |
| Rescue profile validate | `scripts/cidre-rescue-profile --validate` |
| Rescue image build dry-run | `scripts/cidre-rescue-image-build --dry-run` |
| Rescue overlay artifact | `scripts/cidre-rescue-image-build --overlay-only` |
| Rescue image inspect | `scripts/cidre-rescue-image-inspect --overlay rescue/overlay` |
| Rescue manifest generate/validate | `scripts/cidre-rescue-manifest --generate` / `--validate` |
| Rescue mount scan dry-run | `scripts/cidre-rescue-mount --scan --dry-run` |
| Rescue export dry-run | `scripts/cidre-rescue-export --main-root /mnt/cidre-main --dry-run` |
| Rescue kernel-check mock | `scripts/cidre-rescue-kernel-check --main-root test/fixtures/main-root` |
| Rescue report | `scripts/cidre-rescue-report` |
| Doctor rescue checks | `scripts/cidre-doctor --rescue` |
| Recovery rescue status | `scripts/cidre-recovery rescue-status` |
| Recovery rescue inspect | `scripts/cidre-recovery rescue-inspect` |

## Rescue Boot Integration (v0.27.0)

| Check | Command |
|---|---|
| Rescue boot plan | `scripts/cidre-rescue-boot-plan --size 8` |
| Rescue disk check | `scripts/cidre-rescue-disk-check` |
| Rescue slot metadata | `scripts/cidre-rescue-slot-metadata --generate` / `--validate` |
| Rescue boot guide | `scripts/cidre-rescue-boot-guide` |
| Rescue boot report | `scripts/cidre-rescue-boot-report` |
| Rescue create dry-run | `scripts/cidre-rescue-create-dry-run --size 8` |
| Rescue boot checklist | `scripts/cidre-rescue-boot-checklist` |
| Rescue boot risk | `scripts/cidre-rescue-boot-risk --json` |
| Rescue boot validate | `scripts/cidre-rescue-boot-validate --record not-tested --model "MacBook Air M1"` |
| macOS rescue check | `./install-macos --rescue-check` |
| macOS rescue disk audit | `./install-macos --rescue-disk-audit` |
| macOS rescue plan | `./install-macos --rescue-plan` |
| macOS rescue guide | `./install-macos --rescue-guide` |
| macOS rescue report | `./install-macos --rescue-report` |
| macOS rescue create dry-run | `./install-macos --rescue-create-dry-run` |
| Doctor rescue boot checks | `scripts/cidre-doctor --rescue-boot` |
| Doctor macOS rescue checks | `scripts/cidre-doctor --macos-rescue` |

## Guided Rescue Slot Creation (v0.28.0)

| Check | Command |
|---|---|
| Rescue create dry-run | `scripts/cidre-rescue-create --dry-run` |
| Rescue create preflight | `scripts/cidre-rescue-create-preflight --target test/fixtures/rescue-target --artifact .local/state/cidre/rescue/artifacts/cidre-rescue-rootfs.tar.gz --metadata .local/state/cidre/rescue-boot/current/rescue-slot-metadata.json` |
| Rescue target check | `scripts/cidre-rescue-target-check --target test/fixtures/rescue-target --json` |
| Protected target block | `scripts/cidre-rescue-target-check --target / --strict` |
| Rescue target format dry-run | `scripts/cidre-rescue-target-format --target test/fixtures/rescue-block --fs ext4 --dry-run` |
| Rescue deploy dry-run | `scripts/cidre-rescue-deploy-rootfs --artifact .local/state/cidre/rescue/artifacts/cidre-rescue-rootfs.tar.gz --target test/fixtures/rescue-target --dry-run` |
| Rescue deploy fixture | `scripts/cidre-rescue-deploy-rootfs --artifact .local/state/cidre/rescue/artifacts/cidre-rescue-rootfs.tar.gz --target test/fixtures/rescue-target --deploy` |
| Rescue metadata install | `scripts/cidre-rescue-install-metadata --target test/fixtures/rescue-target --metadata .local/state/cidre/rescue-boot/current/rescue-slot-metadata.json` |
| Rescue create verify | `scripts/cidre-rescue-create-verify --target test/fixtures/rescue-target` |
| Rescue create report | `scripts/cidre-rescue-create-report` |
| Rescue create risk | `scripts/cidre-rescue-create-risk --json` |
| Rescue create clean dry-run | `scripts/cidre-rescue-create-clean --dry-run` |
| Doctor rescue create checks | `scripts/cidre-doctor --rescue-create` |
| Recovery rescue create status | `scripts/cidre-recovery rescue-create-status` |

## Fully Guided Installer (v0.29.0)

| Check | Command |
|---|---|
| Stage validation | `scripts/cidre-install-stage --validate` |
| Install dashboard | `scripts/cidre-install-dashboard` |
| Install preflight (macos) | `scripts/cidre-install-preflight --phase macos` |
| Install preflight (root) | `scripts/cidre-install-preflight --phase root` |
| Install preflight (user) | `scripts/cidre-install-preflight --phase user` |
| Install preflight (desktop) | `scripts/cidre-install-preflight --phase desktop` |
| Install guide | `scripts/cidre-install-guide` |
| Install report | `scripts/cidre-install-report` |
| Install resume | `scripts/cidre-install-resume` |
| Install failure report | `scripts/cidre-install-failure-report` |
| Install verify | `scripts/cidre-install-verify --desktop` |
| macOS installer dashboard | `./install-macos --dashboard` |
| macOS installer preflight | `./install-macos --install-preflight` |
| macOS installer guide | `./install-macos --install-guide` |
| macOS installer report | `./install-macos --install-report` |
| preinstall dashboard | `./preinstall --dashboard` |
| preinstall resume | `./preinstall --resume` |
| install dashboard | `./install --dashboard` |
| install resume | `./install --resume` |
| Doctor guided install checks | `scripts/cidre-doctor --guided-install` |
| Recovery install status | `scripts/cidre-recovery install-status` |

## Fully Guided Uninstaller (v0.30.0)

| Check | Command |
|---|---|
| Uninstall dashboard | `scripts/cidre-uninstall-dashboard` |
| Uninstall state show | `scripts/cidre-uninstall-state --show` |
| Uninstall preflight (linux) | `scripts/cidre-uninstall-preflight --phase linux` |
| Uninstall export dry-run | `scripts/cidre-uninstall-export --dry-run` |
| Uninstall target scan | `scripts/cidre-uninstall-target-scan` |
| Uninstall target review | `scripts/cidre-uninstall-target-review --target test/fixtures/cidre-uninstall-target` |
| Uninstall plan | `scripts/cidre-uninstall-plan --target test/fixtures/cidre-uninstall-target` |
| Uninstall dry-run | `scripts/cidre-uninstall-dry-run --target test/fixtures/cidre-uninstall-target` |
| Uninstall execute safety | `scripts/cidre-uninstall-execute --target test/fixtures/cidre-uninstall-target` |
| Uninstall report | `scripts/cidre-uninstall-report` |
| Uninstall resume | `scripts/cidre-uninstall-resume` |
| Uninstall failure report | `scripts/cidre-uninstall-failure-report --stage target-review --reason mock-failure` |
| install-macos dashboard | `./install-macos --uninstall-dashboard` |
| install-macos preflight | `./install-macos --uninstall-preflight` |
| install-macos target-scan | `./install-macos --uninstall-target-scan` |
| install-macos report | `./install-macos --uninstall-report` |
| Doctor guided uninstall checks | `scripts/cidre-doctor --guided-uninstall` |
| Recovery uninstall status | `scripts/cidre-recovery uninstall-status` |

## App-Ready Command Interface (v0.31.0)

| Check | Command |
|---|---|
| App readiness | `scripts/cidre-app-readiness --json` |
| Interface doctor | `scripts/cidre-interface-doctor --json` |
| App action plan | `scripts/cidre-app-action-plan --install --json` |
| Command manifest verify | `scripts/cidre-command-manifest --verify` |
| Doctor app readiness | `scripts/cidre-doctor --app-readiness` |

## Cidre.app Prototype (v0.32.0)

| Check | Command |
|---|---|
| App prototype check | `scripts/cidre-app-prototype-check` |
| JSON output check | `scripts/cidre-app-prototype-check --json` |
| Fixture generation | `scripts/cidre-app-fixture-generate --json` |
| Mock action run | `scripts/cidre-app-mock-run --action install-preflight --json` |
| Report preview | `scripts/cidre-app-report-preview --install --json` |
| Doctor app prototype | `scripts/cidre-doctor --app-prototype` |
| Doctor rc-readiness | `scripts/cidre-doctor --rc-readiness` |
| Recovery app status | `scripts/cidre-recovery app-prototype-status` |
| Recovery app fixtures | `scripts/cidre-recovery app-fixtures` |
| Recovery app report preview | `scripts/cidre-recovery app-report-preview` |

## Cidre.app Guided Action UI (v0.33.0)

| Check | Command |
|---|---|
| App live check | `scripts/cidre-app-live-check --json` |
| Safe action list JSON | `scripts/cidre-app-safe-actions --json` |
| Execution policy JSON | `scripts/cidre-app-execution-policy --json` |
| UI components validation | `scripts/cidre-app-ui-validation --json` |
| Log fixture generation | `scripts/cidre-app-log-fixture --json` |
| Doctor app guided UI | `scripts/cidre-doctor --app-guided-ui` |
| Recovery app guided UI status | `scripts/cidre-recovery app-guided-ui-status` |
| Recovery app safe actions | `scripts/cidre-recovery app-safe-actions --json` |
| Recovery app live check | `scripts/cidre-recovery app-live-check --json` |
| Recovery app execution policy | `scripts/cidre-recovery app-execution-policy --json` |

## Cidre.app Runtime Validation (v0.34.0)

| Check | Command |
|---|---|
| Runtime preflight | `scripts/cidre-app-runtime-check --json` |
| Build validation | `scripts/cidre-app-build-check --json` |
| Launch validation | `scripts/cidre-app-launch-check --json` |
| Runtime report | `scripts/cidre-app-runtime-report --json` |
| Runtime fixtures | `scripts/cidre-app-runtime-fixture --json` |
| Runtime log collection | `scripts/cidre-app-runtime-log-collect --json` |
| Runtime result | `scripts/cidre-app-runtime-result --show --json` |
| Doctor app runtime | `scripts/cidre-doctor --app-runtime` |
| Recovery app runtime status | `scripts/cidre-recovery app-runtime-status --json` |
| Recovery app build check | `scripts/cidre-recovery app-build-check --json` |
