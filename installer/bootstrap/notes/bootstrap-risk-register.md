# Bootstrap Override Risk Register

| Risk ID | Risk | Severity | Trigger | Detection | Mitigation | Status |
|---|---|---:|---|---|---|---|
| R-001 | Bootstrap enters real installer execution | Critical | install.sh / alx.sh call | Static detector | Keep Phase 22 non-execution | Open |
| R-002 | Disk mutation command executes | Critical | diskutil/bless/nvram/etc. | Mutation detector | Never execute bootstrap in Phase 21/22 | Open |
| R-003 | INSTALLER_DATA points to invalid metadata | High | bad URL / invalid JSON | validate-installer-data-url | Validate before any experiment | Mitigated |
| R-004 | Jackrose Asahi-like metadata is not actually upstream-compatible | High | real installer parse failure | compatibility study | Adapter remains prototype | Open |
| R-005 | REPO_BASE semantics differ from Jackrose assumptions | High | package fetch failure | static inspection | Document unresolved behavior | Open |
