#!/bin/bash
# build-cidre-seed-image.sh: Scaffold for Cidre target image assembly
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROFILE=""
DRY_RUN=0

usage() {
  echo "Usage: $0 --profile <name> --dry-run"
  echo "Options:"
  echo "  --profile <name>    Profile name to load (under image/profiles/<name>.conf)"
  echo "  --dry-run           Perform dry-run simulation (REQUIRED in Phase 5)"
  exit 1
}

# Parse parameters
while [ $# -gt 0 ]; do
  case "$1" in
    --profile)
      if [ $# -lt 2 ]; then
        echo "ERROR: --profile requires an argument." >&2
        exit 1
      fi
      PROFILE="$2"
      shift 2
      ;;
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    *)
      echo "ERROR: Unknown option: $1" >&2
      usage
      ;;
  esac
done

if [ -z "$PROFILE" ]; then
  echo "ERROR: --profile is required." >&2
  usage
fi

# Phase 5 Enforcement: --dry-run is strictly required
if [ "$DRY_RUN" -ne 1 ]; then
  echo "ERROR: Phase 5 only supports --dry-run." >&2
  echo "Real image building is reserved for a later phase." >&2
  exit 1
fi

# 1. Load profile configuration
PROFILE_PATH="$SCRIPT_DIR/profiles/${PROFILE}.conf"
if [ ! -f "$PROFILE_PATH" ]; then
  echo "ERROR: Profile config not found at $PROFILE_PATH" >&2
  exit 1
fi

# Load variables
# shellcheck source=profiles/cidre-seed.conf
source "$PROFILE_PATH"

echo "=== Cidre Seed Image Builder [DRY-RUN SIMULATION] ==="
echo "Profile loaded: $CIDRE_PROFILE_NAME ($CIDRE_ARCH)"
echo ""

# 2. Check required host tools
echo "[Step 1/10] Checking required host tools..."
REQUIRED_TOOLS=(bash grep sed awk mkdir tar)
FUTURE_TOOLS=(chroot arch-chroot pacman xz zstd fakeroot systemd-nspawn)

missing_req=0
for tool in "${REQUIRED_TOOLS[@]}"; do
  if command -v "$tool" >/dev/null 2>&1; then
    echo "  [OK] Required tool: $tool"
  else
    echo "  [FAIL] Missing required tool: $tool"
    missing_req=$((missing_req + 1))
  fi
done

if [ $missing_req -gt 0 ]; then
  echo "ERROR: Missing required tools for dry-run simulation." >&2
  exit 1
fi

for tool in "${FUTURE_TOOLS[@]}"; do
  if command -v "$tool" >/dev/null 2>&1; then
    echo "  [OK] Future tool: $tool"
  else
    echo "  [WARN] Missing future tool (required for real build): $tool"
  fi
done
echo ""

# 3. Base rootfs check
echo "[Step 2/10] Verifying base rootfs settings..."
if [ -z "${CIDRE_BASE_ROOTFS:-}" ]; then
  echo "  warning: CIDRE_BASE_ROOTFS is empty; rootfs extraction will be skipped in dry-run."
else
  echo "  Base rootfs targets: $CIDRE_BASE_ROOTFS"
fi
echo ""

# 4. Working directory setup
echo "[Step 3/10] Preparing workdir and out structures..."
echo "  [DRY-RUN] would create workspace: $CIDRE_WORKDIR"
echo "  [DRY-RUN] would create output dir: $CIDRE_OUTPUT_DIR"
echo ""

# 5. Extract rootfs
echo "[Step 4/10] Extracting base rootfs..."
echo "  [DRY-RUN] would extract rootfs tarball to workspace."
echo ""

# 6. Install local packages
echo "[Step 5/10] Installing Cidre packages..."
echo "  Local packages directory: $CIDRE_LOCAL_PACKAGE_DIR"
echo "  [DRY-RUN] would install local Cidre packages:"
for pkg in "${CIDRE_CIDRE_PACKAGES[@]}"; do
  echo "    - $pkg"
done
echo "  [DRY-RUN] would install base system dependencies:"
for pkg in "${CIDRE_BASE_PACKAGES[@]}"; do
  echo "    - $pkg"
done
echo ""

# 7. Apply overlays
echo "[Step 6/10] Injecting filesystem overlays..."
OVERLAY_SRC="$SCRIPT_DIR/overlays/${PROFILE}"
if [ -d "$OVERLAY_SRC" ]; then
  echo "  Overlay source path: $OVERLAY_SRC"
  echo "  [DRY-RUN] would copy overlays directly into target rootfs."
else
  echo "  No overlay directory found for profile."
fi
echo ""

# 8. Enable firstboot service
echo "[Step 7/10] Registering firstboot services..."
echo "  [DRY-RUN] would enable NetworkManager.service and cidre-firstboot.service."
echo "  [DRY-RUN] would disable greetd.service in target rootfs."
echo ""

# 9. Lock root password login
echo "[Step 8/10] Enforcing root password policy..."
echo "  [DRY-RUN] would run 'passwd -l root' inside chroot."
echo ""

# 10. Run validation scripts
echo "[Step 9/10] Validating assembled rootfs..."
VALIDATOR="$SCRIPT_DIR/scripts/validate-rootfs"
if [ -x "$VALIDATOR" ]; then
  "$VALIDATOR" --rootfs "$CIDRE_WORKDIR" --dry-run
else
  echo "  ERROR: Rootfs validator script missing or not executable at $VALIDATOR" >&2
  exit 1
fi
echo ""

# 11. Pack image
echo "[Step 10/10] Compressing output image..."
echo "  [DRY-RUN] would archive workspace rootfs to $CIDRE_OUTPUT_DIR/cidre-seed-$CIDRE_ARCH.tar.xz"
echo ""

echo "=== Cidre Seed Image Builder Dry-Run Successful ==="
