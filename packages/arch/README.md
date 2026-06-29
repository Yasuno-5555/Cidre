# Jackrose Arch Package Drafts

This directory contains draft Arch Linux ARM / ALARM package definitions for the planned Jackrose meta packages.

Current package set:

- `niri-jackrose`
- `jackrose-meta-core`
- `jackrose-meta-desktop`
- `jackrose-meta-dev`
- `jackrose-meta-diagnostics`
- `jackrose-meta-optional`
- `jackrose-session`
- `jackrose-config`

These are packaging drafts for `Jackrose v1.0` planning, not yet published repository packages.

Planned standard install:

- `jackrose-meta-core`
- `jackrose-meta-desktop`
- `jackrose-meta-dev`

## Design Notes

- `niri-jackrose` owns the compositor binary.
- `jackrose-meta-core` owns the base system and Asahi platform baseline.
- `jackrose-meta-desktop` owns the default login stack and desktop runtime.
- `jackrose-meta-dev` owns the default developer toolchain.
- `jackrose-meta-diagnostics` and `jackrose-meta-optional` are additive profiles.
- `jackrose-session` owns the public login entry and session launcher.
- `jackrose-config` owns the default Jackrose configuration assets.

Intended dependency direction:

- `jackrose-session -> niri-jackrose`
- `jackrose-meta-desktop -> niri-jackrose, jackrose-session, jackrose-config`
- `niri-jackrose` does not depend on `jackrose-session`

For the current public package model, see:

- [docs/jackrose-v1-package-plan.md](../../docs/jackrose-v1-package-plan.md)
- [GREETD.md](../../GREETD.md)
