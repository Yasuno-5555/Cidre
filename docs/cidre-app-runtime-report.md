# Cidre.app Runtime Report

`scripts/cidre-app-runtime-report` aggregates runtime validation status into markdown and JSON artifacts.

- Report fields: preflight, build, launch, repository, metadata, safe commands, reports, blocked action display, known issues, next steps.
- Markdown output: `.local/state/cidre/app-runtime/current/runtime-validation-report.md`
- JSON output: `.local/state/cidre/app-runtime/current/runtime-validation-report.json`
- History layout: v0.34.0 writes the current report path now and leaves history rotation for a future release.
