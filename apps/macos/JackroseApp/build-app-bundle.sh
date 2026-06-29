#!/bin/sh
set -eu

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
BUILD_CONFIG="debug"

while [ "$#" -gt 0 ]; do
  case "$1" in
    --release) BUILD_CONFIG="release"; shift ;;
    --debug) BUILD_CONFIG="debug"; shift ;;
    --help|-h)
      echo "Usage: build-app-bundle.sh [--debug|--release]"
      exit 0
      ;;
    *)
      echo "ERROR: unknown option: $1" >&2
      exit 2
      ;;
  esac
done

cd "$SCRIPT_DIR"

swift build -c "$BUILD_CONFIG" >/dev/null
BIN_DIR="$(swift build -c "$BUILD_CONFIG" --show-bin-path)"
APP_DIR="$BIN_DIR/Jackrose.app"
CONTENTS_DIR="$APP_DIR/Contents"
MACOS_DIR="$CONTENTS_DIR/MacOS"
RESOURCES_DIR="$CONTENTS_DIR/Resources"

rm -rf "$APP_DIR"
mkdir -p "$MACOS_DIR" "$RESOURCES_DIR"

cp "$BIN_DIR/JackroseApp" "$MACOS_DIR/JackroseApp"
cp "$SCRIPT_DIR/Resources/Info.plist" "$CONTENTS_DIR/Info.plist"

if [ -d "$SCRIPT_DIR/Resources" ]; then
  find "$SCRIPT_DIR/Resources" -mindepth 1 ! -name 'Info.plist' -exec cp -R {} "$RESOURCES_DIR/" \;
fi

if command -v codesign >/dev/null 2>&1; then
  codesign --force --deep --sign - "$APP_DIR" >/dev/null 2>&1 || true
fi

printf '%s\n' "$APP_DIR"
