# Jackrose Installer Wrapper

This directory centralizes policies for the Jackrose-owned installer wrapper strategy.

## Safety Boundaries
The Jackrose installer wrapper does not execute upstream bootstrap scripts in Phase 26.
It does not run install.sh.
It does not modify disks.
All tasks are sandboxed preflights and validations.
