# Local INSTALLER_DATA Override Dry-run

This document details how Cidre's generated metadata is served, fetched, and configured for dry-run selection overrides.

---

## 1. Safety Boundaries

> [!WARNING]
> **No Execution**
> Phase 19 is dry-run only.
> Do **not** source generated environment variable files and execute real installer scripts (`install.sh`, `installer-bootstrap.sh`).

---

## 2. Serving Metadata

Cidre metadata can be served locally:

```bash
installer/scripts/serve-installer-data \
  --directory installer/generated \
  --port 8765
```

---

## 3. Override Configuration

The printer script generates shell exports:

```bash
installer/scripts/print-installer-override-env \
  --installer-data-url http://127.0.0.1:8765/asahi-installer-data.cidre.dev.json \
  --repo-base http://127.0.0.1:8765
```
