#!/usr/bin/env sh
# Safe sample script for tests.
# Contains variable assignments and curl-like lines, but no real mutation commands.
INSTALLER_DATA="${INSTALLER_DATA:-http://127.0.0.1:8765/installer_data.json}"
REPO_BASE="${REPO_BASE:-http://127.0.0.1:8765}"
curl -L "$INSTALLER_DATA" -o /tmp/installer_data.json
