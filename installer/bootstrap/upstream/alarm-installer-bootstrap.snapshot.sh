#!/bin/sh
# Upstream ALARM Bootstrap mock snapshot for Phase 20 static analysis
INSTALLER_DATA="${INSTALLER_DATA:-https://archlinuxarm.org/os/installer_data.json}"
REPO_BASE="${REPO_BASE:-https://archlinuxarm.org}"
INSTALLER_BASE="${INSTALLER_BASE:-https://archlinuxarm.org/os/installer}"
EXPERT="${EXPERT:-0}"

echo "Fetching installer data from $INSTALLER_DATA..."
curl -s -L "$INSTALLER_DATA" -o /tmp/installer_data.json
EOF
