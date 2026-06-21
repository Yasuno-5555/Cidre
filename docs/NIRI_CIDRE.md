# niri-cidre

`niri-cidre` is the compositor component inside Cidre.

This repository contains the Cidre environment, including installer, recovery, rescue tooling, documentation, package metadata, and the `niri-cidre` desktop layer.

## Role In Cidre

Public split:

- product: `Cidre`
- compositor component: `niri-cidre`
- session launcher: `cidre-session`
- shipped config assets: `cidre-config`

The intent is that users understand Cidre as the full environment, while `niri-cidre` is one part of that environment.

## What Lives Here

This repository is where the Cidre environment lives:

- `niri-cidre` binary changes
- Cidre session wiring
- default config assets
- Apple Silicon oriented behavior and recovery work
- Arch packaging drafts for the Cidre desktop stack

## Cidre-Specific Areas

Examples of Cidre-specific behavior in this repo:

- safe-mode and recovery-oriented startup behavior
- scratch column workflow
- power-aware compositor behavior
- touchpad workflow tuning for Apple Silicon laptops
- Cidre session naming and packaging

## What This Is Not

This is not the whole future Cidre project layout.

Longer term, you should expect more separation between:

- compositor source
- session/config packages
- installer or distribution tooling
- project-wide documentation

## Related Reading

- [README.md](../README.md)
- [UPSTREAM_NIRI.md](./UPSTREAM_NIRI.md)
- [niri-cidre-config.md](./niri-cidre-config.md)
