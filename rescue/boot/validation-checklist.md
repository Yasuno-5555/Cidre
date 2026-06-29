# Jackrose Rescue Boot Validation Checklist

## Pre-flight

- [ ] macOS backup exists
- [ ] main Jackrose state exported
- [ ] rescue artifact built
- [ ] rescue metadata generated
- [ ] disk audit generated

## Boot planning

- [ ] rescue slot size chosen
- [ ] boot integration method documented
- [ ] main and rescue separation confirmed

## Validation

- [ ] rescue boots
- [ ] bash available
- [ ] jackrose-rescue-check passes
- [ ] main Jackrose can be scanned
- [ ] main Jackrose can be mounted read-only
- [ ] logs and state can be exported
- [ ] kernel-check works

## Exit

- [ ] macOS Restore Assistant available
- [ ] uninstall guide available
