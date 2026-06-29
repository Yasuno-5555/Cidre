#!/bin/bash
set -eu
# jackrose-asahi-style-setup.sh
# Asahi ALARM approach: create proper VG, set up boot files, bless.
# Run this script from macOS Terminal to fix Jackrose boot picker visibility.
#
# Reference: https://github.com/asahi-alarm/asahi-alarm-installer

echo "=== Jackrose Asahi-Style Setup ==="
echo "This follows the Asahi ALARM approach exactly."
echo ""

MACOS_VGID="08E3B56E-946D-4280-9E3C-1931ED8B8B34"
M1N1_SRC="/Users/yasuno/Projects/Jackrose/libexec/m1n1.macho"
STEP2_SRC="/Users/yasuno/Projects/Jackrose/scripts/jackrose-app-recovery-step2"

# ── Step 1: Nuke all existing Jackrose volumes ─────────────────────────
echo "[1/6] Cleaning up existing Jackrose volumes..."
for dev in disk3s4 disk3s3 disk3s1 disk3s2; do
  diskutil apfs deleteVolume "$dev" 2>/dev/null && echo "  Deleted $dev" || true
done
sleep 3
echo ""

# ── Step 2: Create volumes in correct order ─────────────────────────
echo "[2/6] Creating Jackrose Volume Group..."
# Data volume (role D)
diskutil apfs addVolume disk3 APFS Jackrose -role D
echo "  Data volume: created"
sleep 2

# System volume WITH role S (required by APFS for -groupWith)
diskutil apfs addVolume disk3 APFS Jackrose -role S -groupWith disk3s1
echo "  System volume: created"
sleep 2

# Preboot volume (role B)
diskutil apfs addVolume disk3 APFS Preboot -role B
echo "  Preboot volume: created"
sleep 2

# Recovery volume (role R)
diskutil apfs addVolume disk3 APFS Recovery -role R
echo "  Recovery volume: created"
sleep 2

# Get VG UUID
VGID=$(diskutil apfs listVolumeGroups -plist 2>/dev/null | python3 -c "
import plistlib, sys
d = plistlib.loads(sys.stdin.buffer.read())
for c in d.get('Containers', []):
    if c.get('ContainerReference') == 'disk3':
        for vg in c.get('VolumeGroups', []):
            print(vg.get('APFSVolumeGroupUUID', ''))
            sys.exit(0)
print('')
")
echo "  VG UUID: $VGID"
echo ""

# ── Step 3: Mount volumes ───────────────────────────────────────────
echo "[3/6] Mounting volumes..."
diskutil mount disk3s2 2>/dev/null || true  # System (writable!)
diskutil mount disk3s3 2>/dev/null || true  # Preboot

SYSTEM_MOUNT=$(diskutil info disk3s2 2>/dev/null | grep "Mount Point" | sed 's/.*Mount Point:[[:space:]]*//')
PREBOOT_MOUNT=$(diskutil info disk3s3 2>/dev/null | grep "Mount Point" | sed 's/.*Mount Point:[[:space:]]*//')
echo "  System: $SYSTEM_MOUNT"
echo "  Preboot: $PREBOOT_MOUNT"
echo ""

# ── Step 4: Set up Preboot (restore bundle + boot.efi) ─────────────
echo "[4/6] Setting up Preboot volume..."
mkdir -p "$PREBOOT_MOUNT/$VGID/System/Library/CoreServices"
mkdir -p "$PREBOOT_MOUNT/$VGID/restore"

# Copy macOS restore bundle
echo "  Copying macOS restore bundle..."
cp -R "/System/Volumes/Preboot/$MACOS_VGID/restore/" "$PREBOOT_MOUNT/$VGID/restore/"

# Copy SystemVersion.plist from restore bundle
cp "$PREBOOT_MOUNT/$VGID/restore/SystemVersion.plist" \
   "$PREBOOT_MOUNT/$VGID/System/Library/CoreServices/SystemVersion.plist"

# Copy Apple kernelcache as boot.efi (for 1TR boot with Full Security)
echo "  Setting boot.efi = Apple kernelcache..."
cp "/System/Volumes/Preboot/$MACOS_VGID/restore/kernelcache.release.mac13g" \
   "$PREBOOT_MOUNT/$VGID/System/Library/CoreServices/boot.efi"
chmod 755 "$PREBOOT_MOUNT/$VGID/System/Library/CoreServices/boot.efi"

# Save m1n1 backup for step2 restoration
echo "  Saving m1n1 backup..."
cp "$M1N1_SRC" "$PREBOOT_MOUNT/$VGID/System/Library/CoreServices/boot.efi.m1n1"
chmod 755 "$PREBOOT_MOUNT/$VGID/System/Library/CoreServices/boot.efi.m1n1"

echo "  Preboot setup: done ($(du -sh "$PREBOOT_MOUNT/$VGID" | awk '{print $1}'))"
echo ""

# ── Step 5: Set up System volume ────────────────────────────────────
echo "[5/6] Setting up System volume..."

# System role volumes are mounted read-only. Try to remount read-write.
echo "  Attempting remount rw..."
diskutil unmount disk3s2 2>/dev/null || true
sleep 1
# Try mount -u -w with raw device node
mount -uw /dev/disk3s2 2>&1 || {
  echo "  mount -uw failed, trying alternative..."
  # Try hdiutil or direct mount
  /sbin/mount -t apfs -o update,nobrowse,rw /dev/disk3s2 "$SYSTEM_MOUNT" 2>&1 || true
}
diskutil mount disk3s2 2>/dev/null || true
SYSTEM_MOUNT=$(diskutil info disk3s2 2>/dev/null | grep "Mount Point" | sed 's/.*Mount Point:[[:space:]]*//')
echo "  System mount: $SYSTEM_MOUNT"

mkdir -p "$SYSTEM_MOUNT/System/Library/CoreServices"

# SystemVersion.plist
cp "$PREBOOT_MOUNT/$VGID/restore/SystemVersion.plist" \
   "$SYSTEM_MOUNT/System/Library/CoreServices/SystemVersion.plist"

# boot.efi = kernelcache
cp "/System/Volumes/Preboot/$MACOS_VGID/restore/kernelcache.release.mac13g" \
   "$SYSTEM_MOUNT/System/Library/CoreServices/boot.efi"
chmod 755 "$SYSTEM_MOUNT/System/Library/CoreServices/boot.efi"

# m1n1 backup
cp "$M1N1_SRC" "$SYSTEM_MOUNT/System/Library/CoreServices/boot.efi.m1n1"
chmod 755 "$SYSTEM_MOUNT/System/Library/CoreServices/boot.efi.m1n1"

# .IAPhysicalMedia (triggers 1TR auto-boot)
cat > "$SYSTEM_MOUNT/.IAPhysicalMedia" << 'IAPEOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>FinishInstallPhase</key>
    <string>Install</string>
</dict>
</plist>
IAPEOF
chmod 644 "$SYSTEM_MOUNT/.IAPhysicalMedia"

# Copy step2.sh
if [ -f "$STEP2_SRC" ]; then
    cp "$STEP2_SRC" "$SYSTEM_MOUNT/jackrose-step2.sh"
    chmod +x "$SYSTEM_MOUNT/jackrose-step2.sh"
    echo "  step2.sh: installed"
fi

echo "  System setup: done"
echo ""

# ── Step 6: Set System role and Bless ────────────────────────────────
echo "[6/6] Finalizing..."

# Now add System role (makes it read-only, but everything is written)
echo "  Setting System role..."
diskutil unmount disk3s2 2>/dev/null || true
sleep 1
diskutil apfs changeVolumeRole disk3s2 S 2>&1 || {
    echo "  WARNING: Could not set System role. This may be OK."
    echo "  The volume is already set up correctly."
}
diskutil mount disk3s2 2>/dev/null || true
sleep 1

# Verify VG
echo ""
echo "  === Volume Group ==="
diskutil apfs listVolumeGroups -plist 2>/dev/null | python3 -c "
import plistlib, sys
d = plistlib.loads(sys.stdin.buffer.read())
for c in d.get('Containers', []):
    if c.get('ContainerReference') == 'disk3':
        for vg in c.get('VolumeGroups', []):
            print('  VG UUID:', vg.get('APFSVolumeGroupUUID', '?'))
            for v in vg.get('Volumes', []):
                print('   ', v.get('DeviceIdentifier','?'), v.get('Name','?'), 'role=' + str(v.get('Role','?')))
"

echo ""
echo "============================================"
echo "Setup complete!"
echo ""
echo "VG UUID: $VGID"
echo "System: $SYSTEM_MOUNT"
echo "Preboot: $PREBOOT_MOUNT"
echo ""
echo "Next step: Run bless to set Jackrose as default boot:"
echo "  sudo bless --setBoot --device /dev/disk3s2 --user \$USER --stdinpass"
echo ""
echo "Then restart your Mac. The Mac will boot into Jackrose (1TR mode)."
echo "In 1TR mode, step2 will auto-run (bputil + kmutil + reboot)."
echo "After that, Jackrose will appear in the boot picker!"
echo "============================================"
