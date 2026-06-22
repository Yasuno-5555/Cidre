# App-Ready Command Interface

## Purpose
This interface provides a stable machine-readable layer for backend tooling, specifically designed to interact with a future macOS application (`Cidre.app`).

## Backend Model
The command manifest acts as the source of truth for all command options, capabilities, categories, and constraints.

## Exit Codes
Cidre uses exit codes systematically (defined in `exit-codes.json`) to distinguish success, generic errors, blocks, missing dependencies, and incorrect permissions.
