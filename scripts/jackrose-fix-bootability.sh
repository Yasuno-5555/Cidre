#!/bin/bash
set -eu
# jackrose-fix-bootability.sh
# Fixes Jackrose bootability: fsctl bootable flag + missing files + bless.
# MUST be run with sudo: sudo bash jackrose-fix-bootability.sh
#
# Reference: https://github.com/asahi-alarm/asahi-alarm-installer

if [ "$(id -u)" != "0" ]; then
    echo "This script must be run with sudo:"
    echo "  sudo bash $0"
    exit 1
fi

echo "=== Jackrose Bootability Fix ==="
echo ""

VGID="79209CAB-9676-45C9-BE84-F75E181BFAB3"
SYSTEM_DEV="disk3s2"
SYSTEM_MOUNT="/Volumes/Jackrose 1"

# ── Step 1: Ensure volume is mounted ───────────────────────────────────
echo "[1/5] Ensuring System volume is mounted..."
diskutil mount "$SYSTEM_DEV" 2>/dev/null || true
sleep 1

SYSTEM_MOUNT=$(diskutil info "$SYSTEM_DEV" 2>/dev/null | grep "Mount Point" | sed 's/.*Mount Point:[[:space:]]*//')
echo "  System mount: $SYSTEM_MOUNT"

# Try to remount read-write
echo "  Attempting remount rw..."
mount -u -w "$SYSTEM_MOUNT" 2>&1 || {
    echo "  NOTE: remount rw failed (System role volumes are inherently read-only)"
    echo "  This is OK - fsctl may still work on a read-only mount"
}
echo ""

# ── Step 2: Set fsctl bootable flag ────────────────────────────────────
echo "[2/5] Setting bootable flag via fsctl (APFS_BOOTABLE_SET)..."
/usr/bin/python3 -c "
import ctypes
from ctypes import c_char_p, c_ulong, POINTER, c_int, CDLL, get_errno, byref, c_uint

sysdll = CDLL('libSystem.B.dylib', use_errno=True)
func = sysdll.fsctl
func.restype = c_int
func.argtypes = (c_char_p, c_ulong, POINTER(c_int), c_uint)

path = '$SYSTEM_MOUNT'

# Query current state
cmd = c_int(0)
err = func(path.encode(), 0xc0044a57, byref(cmd), 0)
print(f'  Current state: bootable={cmd.value}')

# Set bootable (cmd=1 means set bootable)
cmd = c_int(1)
err = func(path.encode(), 0xc0044a57, byref(cmd), 0)
if err == -1:
    errn = get_errno()
    print(f'  ERROR: fsctl SET failed, errno={errn}')
    if errn == 1:
        print(f'  (EPERM: need root or volume must be writable)')
    elif errn == 30:
        print(f'  (EROFS: read-only file system - need to change volume role first)')
    exit(1)
print(f'  Set result: err={err}, returned={cmd.value}')
print(f'  Volume marked as BOOTABLE ✅')

# Verify
cmd = c_int(0)
err = func(path.encode(), 0xc0044a57, byref(cmd), 0)
print(f'  Verified: bootable={cmd.value}')
if cmd.value != 1:
    print(f'  WARNING: bootable flag did not stick!')
    exit(1)
" 2>&1
echo ""

# ── Step 3: Copy PlatformSupport.plist ──────────────────────────────────
echo "[3/5] Copying PlatformSupport.plist to Jackrose CoreServices..."
if [ -f "/System/Library/CoreServices/PlatformSupport.plist" ]; then
    cp "/System/Library/CoreServices/PlatformSupport.plist" \
       "$SYSTEM_MOUNT/System/Library/CoreServices/PlatformSupport.plist"
    echo "  PlatformSupport.plist: copied ✅"
else
    echo "  WARNING: macOS PlatformSupport.plist not found"
fi
echo ""

# ── Step 4: Verify structure ──────────────────────────────────────────
echo "[4/5] Verifying Jackrose boot structure..."
echo "  CoreServices:"
for f in "$SYSTEM_MOUNT/System/Library/CoreServices/"*; do
    echo "    $(basename "$f") ($(du -sh "$f" 2>/dev/null | awk '{print $1}'))"
done
echo ""
echo "  SystemVersion: $(plutil -p "$SYSTEM_MOUNT/System/Library/CoreServices/SystemVersion.plist" 2>/dev/null | grep ProductVersion | head -1)"
echo "  .IAPhysicalMedia: $(cat "$SYSTEM_MOUNT/.IAPhysicalMedia" 2>/dev/null | grep FinishInstallPhase || echo MISSING)"
echo "  fsctl bootable: $(python3 -c "
import ctypes; from ctypes import *
sysdll = CDLL('libSystem.B.dylib', use_errno=True)
func = sysdll.fsctl; func.restype = c_int
func.argtypes = (c_char_p, c_ulong, POINTER(c_int), c_uint)
cmd = c_int(0); func(b'$SYSTEM_MOUNT', 0xc0044a57, byref(cmd), 0)
print(cmd.value)
" 2>/dev/null)"
echo ""

# ── Step 5: Run bless ─────────────────────────────────────────────────
echo "[5/5] Running bless --setBoot..."
echo ""
echo "  Enter your macOS admin password when prompted."
echo ""

ACTUAL_USER=$(stat -f '%Su' /dev/console)
echo "  Using console user: $ACTUAL_USER"

bless --setBoot --device "/dev/$SYSTEM_DEV" --user "$ACTUAL_USER" --stdinpass 2>&1

echo ""
echo "============================================"
echo "Bootability fix complete!"
echo ""
echo "Next:"
echo "  1. Restart your Mac"
echo "  2. Mac should boot into Jackrose (1TR mode)"
echo "  3. Utilities → Terminal → /Volumes/Jackrose/jackrose-step2.sh"
echo "  4. After step2 + reboot, Jackrose shows in boot picker"
echo "============================================"
