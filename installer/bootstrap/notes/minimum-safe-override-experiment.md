# Minimum safe next experiment

Define the smallest next experiment that Phase 22 may perform.

## 1. Allowed Actions
- Serve generated Asahi-like installer data over localhost.
- Fetch generated metadata with `curl -L`.
- Print `INSTALLER_DATA` / `REPO_BASE` environment variables.
- Validate fetched metadata.
- Simulate selection.
- Inspect bootstrap scripts statically.

## 2. Forbidden Actions
- Execute bootstrap scripts.
- Execute `install.sh`.
- Run `alx.sh`.
- Run `installer-bootstrap.sh`.
- Pipe curl output into shell.
- Use sudo for installer execution.
- Run `diskutil`, `bless`, `nvram`, `gpt`, `fdisk`, `dd`, `mkfs`, `parted`.
- Modify partitions.
- Modify boot policy.
- No real installer execution.

## 3. Success Criteria
- Exporter output matches schema format validations.
- Simulator processes served selection dry-runs correctly.
