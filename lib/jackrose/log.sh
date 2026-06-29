#!/bin/bash
# lib/jackrose/log.sh — Jackrose shared logging utilities
# Source this file: source "$JACKROSE_ROOT/lib/jackrose/log.sh"
set -euo pipefail

# Ensure JACKROSE_ROOT is set by the caller, or derive it
if [ -z "${JACKROSE_ROOT:-}" ]; then
  JACKROSE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
fi

: "${JACKROSE_LOG_DIR:=$HOME/.local/state/jackrose}"
: "${JACKROSE_LOG_FILE:=$JACKROSE_LOG_DIR/install.log}"

# Initialize logging — call once at script start
jackrose_log_init() {
  mkdir -p "$JACKROSE_LOG_DIR"
  local log_name="${1:-install}"
  JACKROSE_LOG_FILE="${JACKROSE_LOG_DIR}/${log_name}-$(date +%Y%m%d-%H%M%S).log"

  # Tee all output to log file
  exec > >(tee -a "$JACKROSE_LOG_FILE") 2>&1

  echo "Jackrose log started at $(date -Is)"
  echo "Log file: $JACKROSE_LOG_FILE"
  echo ""
}

# Log a line with timestamp
jackrose_log() {
  printf '[%s] %s\n' "$(date -Is)" "$*" >> "${JACKROSE_LOG_FILE:-/dev/null}"
}

# Log an error and show it to the user
jackrose_log_error() {
  local context="$1"
  local message="$2"
  jackrose_log "ERROR [$context]: $message"
  echo -e "\e[1;31m[ERROR]\e[0m $message" >&2
}

# Log the final result path
jackrose_log_path() {
  echo ""
  echo "Log: ${JACKROSE_LOG_FILE:-$HOME/.local/state/jackrose/install.log}"
}
