#!/bin/sh
# Upstream Asahi Bootstrap mock snapshot for Phase 20 static analysis
INSTALLER_DATA="${INSTALLER_DATA:-https://alx.sh/installer_data.json}"
REPO_BASE="${REPO_BASE:-https://alx.sh}"
INSTALLER_BASE="${INSTALLER_BASE:-https://alx.sh/installer}"
EXPERT="${EXPERT:-0}"

echo "Fetching installer data from $INSTALLER_DATA..."
curl -s -L "$INSTALLER_DATA" -o /tmp/installer_data.json
EOF
