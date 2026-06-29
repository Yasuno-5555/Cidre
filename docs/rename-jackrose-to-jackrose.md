# Naming Policy: Rename Jackrose to Jackrose

This document outlines the naming guidelines and policy for the transition from the Jackrose project to Jackrose.

## Core Namespaces

| Category | Old Value | New Value |
| --- | --- | --- |
| **Display Name** | Jackrose | Jackrose |
| **Lowercase Identifier** | `jackrose` | `jackrose` |
| **Uppercase Identifier** | `JACKROSE` | `JACKROSE` |
| **Official CLI** | `jackrose` / `jackrose-*` | `jackrose` / `jackrose-*` |
| **User Configuration** | `~/.config/jackrose` | `~/.config/jackrose` |
| **User Local Data** | `~/.local/share/jackrose` | `~/.local/share/jackrose` |
| **System Mutable State** | `/etc/jackrose` | `/etc/jackrose` |
| **System Mutable Data** | `/var/lib/jackrose` | `/var/lib/jackrose` |
| **Package-Owned Assets** | `/usr/share/jackrose` | `/usr/share/jackrose` |
| **Systemd Units** | `jackrose-*.service` | `jackrose-*.service` |
| **macOS Bundle ID** | `org.jackrose.Installer` / `org.jackrose.PrivilegedHelper` | `org.jackrose.Installer` / `org.jackrose.PrivilegedHelper` |

## Migration Policy

1. **User Configuration**: User-level configuration directories under `~/.config/jackrose` and `~/.local/share/jackrose` will be migrated automatically on first boot/run or package installation/upgrade via an idempotent migration script.
2. **System State**: `/etc/jackrose` and `/var/lib/jackrose` will be migrated where applicable.
3. **Package Assets**: `/usr/share/jackrose` will not be moved or modified directly to avoid package manager metadata conflicts. Instead, new packages will deploy assets directly to `/usr/share/jackrose`.
4. **Compatibility Wrappers**: Temporarily, public wrappers for `jackrose`, `jackrose-doctor`, and `jackrose-welcome` will be provided to warn users and forward arguments to `jackrose`.
