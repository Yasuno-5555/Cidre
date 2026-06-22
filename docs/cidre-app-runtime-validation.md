# Cidre.app Runtime Validation

Cidre v0.34.0 adds runtime validation tooling for the macOS `Cidre.app` prototype.

- Purpose: confirm that `swift build`, launch preparation, repository selection, safe read-only actions, and report preview paths all work together on real macOS.
- Validation phases: preflight, build, launch, repository validation, metadata load, safe command execution, report preview, blocked action display, report generation.
- macOS requirements: these checks are blocked on Linux and return a safe refusal instead of attempting GUI validation.
- Read-only scope: only safe actions such as readiness, interface doctor, report index, artifact path reads, and dashboard reads are allowed.
- Output reports: runtime state, logs, markdown report, and JSON report are written under `.local/state/cidre/app-runtime/current/`.
