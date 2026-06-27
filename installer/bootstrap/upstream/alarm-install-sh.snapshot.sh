#!/bin/sh
# Upstream ALARM Install entrypoint mock snapshot for Phase 20 static analysis
echo "ALARM Install entrypoint..."
sudo diskutil list
nvram boot-args=test
./install.sh
