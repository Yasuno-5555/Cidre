#!/usr/bin/env sh
# DO NOT EXECUTE.
# Static danger-pattern fixture for mutation detector tests.
echo "fixture only"
sudo diskutil list
nvram boot-args=test
./install.sh
bless --folder /System
gpt show /dev/disk0
fdisk -l
dd if=/dev/zero of=/dev/disk2
mount /dev/disk0s2 /mnt
umount /mnt
mkfs.ext4 /dev/disk0s3
parted /dev/disk0
asr restore --source image.dmg
newfs_hfs /dev/disk0s4
