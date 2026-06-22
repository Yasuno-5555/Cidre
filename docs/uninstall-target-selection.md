# Uninstall Target Selection

## Exact Target Requirement
You must supply an exact identifier like `--target diskXsY` or `--target /dev/nvme0n1pX`. Wildcards or automatic resolution (e.g. `auto` or `linux`) are rejected.

## Candidate Classification
- `candidate-cidre`: Verified Cidre partition.
- `candidate-asahi`: Asahi Linux system space.
- `candidate-linux`: Sibling Linux filesystems.
- `protected-macos`: Standard macOS system, data, preboot, VM volumes.
- `protected-recovery`: Device recoveries.
- `protected-external`: Externally mounted backup/storage devices.
- `ambiguous`: Mixed attributes that block automation.
- `unknown`: Unrecognized filesystem markers.
