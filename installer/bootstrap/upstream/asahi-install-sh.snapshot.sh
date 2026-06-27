#!/bin/sh
# Upstream Asahi Install entrypoint mock snapshot for Phase 20 static analysis
echo "Asahi Install entrypoint..."
sudo diskutil list
nvram boot-args=test
./install.sh
