# Static Bootstrap Override Inspection

This guide summarizes findings from statically inspecting Asahi/ALARM bootstrap installer entrypoint scripts.

---

## 1. Safety Boundary

> [!WARNING]
> **No Execution**
> Bootstrap scripts are snapshots for inspection only.
> Do **not** piping bootstrap URLs (`curl | sh`) or invoke installer scripts (`install.sh`, `alx.sh`).

---

## 2. Override Entrypoints

Variable overrides allow custom data redirection:
- **`INSTALLER_DATA`**: Redirects metadata target JSON files.
- **`REPO_BASE`**: Redirects seed archives download base URLs.

---

## 3. Mutation Gaps

Dangerous boundaries are located where:
- Partition commands (`gpt`, `fdisk`) are triggered.
- System setups (`bless`, `nvram`) modify macOS variables.
