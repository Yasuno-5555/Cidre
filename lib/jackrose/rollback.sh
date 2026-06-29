#!/bin/bash
# lib/jackrose/rollback.sh — Jackrose shared rollback & snapshot helpers
# Source this file: source "$JACKROSE_ROOT/lib/jackrose/rollback.sh"
set -euo pipefail

# Source UI if not already loaded
if ! declare -f jackrose_ok >/dev/null 2>&1; then
  JACKROSE_ROOT="${JACKROSE_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
  source "$JACKROSE_ROOT/lib/jackrose/ui.sh"
fi

: "${JACKROSE_SNAPSHOT_DIR:=$HOME/.local/state/jackrose/snapshots}"

# Create a snapshot of Jackrose config files before a mutation
# Usage: jackrose_snapshot_create "pre-install"
jackrose_snapshot_create() {
  local label="${1:-snapshot}"
  local ts
  ts=$(date +%Y%m%d-%H%M%S)
  local snapshot_dir="${JACKROSE_SNAPSHOT_DIR}/${label}-${ts}"

  mkdir -p "$snapshot_dir"

  # Back up key config dirs
  for dir in niri waybar ghostty fuzzel fish fcitx5 environment.d starship; do
    if [ -d "$HOME/.config/$dir" ]; then
      cp -r "$HOME/.config/$dir" "$snapshot_dir/$dir" 2>/dev/null || true
    fi
  done

  echo "$snapshot_dir"
}

# List available snapshots
jackrose_snapshot_list() {
  if [ ! -d "$JACKROSE_SNAPSHOT_DIR" ]; then
    echo "No snapshots found."
    return
  fi

  echo "Available snapshots:"
  for dir in "$JACKROSE_SNAPSHOT_DIR"/*/; do
    [ -d "$dir" ] || continue
    local name
    name=$(basename "$dir")
    echo "  $name"
  done
}

# Restore from a snapshot
# Usage: jackrose_snapshot_restore "pre-install-20260625-120000"
jackrose_snapshot_restore() {
  local snapshot_name="$1"
  local snapshot_dir="${JACKROSE_SNAPSHOT_DIR}/${snapshot_name}"

  if [ ! -d "$snapshot_dir" ]; then
    # Try latest match
    snapshot_dir=$(find "$JACKROSE_SNAPSHOT_DIR" -maxdepth 1 -type d -name "${snapshot_name}*" 2>/dev/null | sort | tail -n 1)
    if [ -z "$snapshot_dir" ] || [ ! -d "$snapshot_dir" ]; then
      echo "Error: Snapshot '$snapshot_name' not found." >&2
      jackrose_snapshot_list
      return 1
    fi
  fi

  echo "Restoring from: $(basename "$snapshot_dir")"

  for dir in niri waybar ghostty fuzzel fish fcitx5 environment.d starship; do
    if [ -d "$snapshot_dir/$dir" ]; then
      rm -rf "$HOME/.config/$dir"
      cp -r "$snapshot_dir/$dir" "$HOME/.config/$dir"
      jackrose_ok "Restored $dir config"
    fi
  done

  echo ""
  echo "Configs restored. You may need to restart your session."
}

# Rollback: create a checkpoint before running a risky command
# Usage: jackrose_rollback_wrap "label" command arg1 arg2...
jackrose_rollback_wrap() {
  local label="$1"
  shift

  local snapshot
  snapshot=$(jackrose_snapshot_create "$label")
  echo "Checkpoint saved: $snapshot"

  if "$@"; then
    jackrose_ok "Command succeeded."
    return 0
  else
    local exit_code=$?
    jackrose_fail "Command failed (exit code: $exit_code)"
    echo ""
    echo "To rollback: jackrose-snapshot restore $(basename "$snapshot")"
    return $exit_code
  fi
}
