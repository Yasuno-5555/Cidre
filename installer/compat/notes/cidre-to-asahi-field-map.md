# Cidre to Asahi/ALARM Installer Data Fields Mappings

## Summary
The fields mappings summarize how Cidre installer-facing JSON translates into upstream Asahi/ALARM installer definitions.

| Cidre field | Installer-facing field | Asahi/ALARM field | Mapping status | Notes |
|---|---|---|---|---|
| `entries[].id` | `images[].id` | `id` | compatible | Maps directly |
| `entries[].name` | `images[].label` | `name` | compatible | Maps to OS display name |
| `entries[].image.url` | `images[].url` | `package` | transform-required | Upstream may expect relative repository base paths |
| `entries[].image.sha256` | `images[].sha256` | `checksum` | compatible | Maps directly |
| `entries[].image.size_bytes` | `images[].size_bytes` | `size` | compatible | Maps directly |
| `entries[].image.manifest` | `images[].manifest` | `manifest` | compatible | Maps directly |
| `entries[].compatibility` | `images[].platform` | `compatibility` | compatible | Mapped properties |
