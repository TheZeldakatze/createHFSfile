#!/bin/bash
set -e

export PATH=/sbin/:$PATH

dd bs=512K count=100 if=/dev/zero of=DISK.APM
parted DISK.APM --script mklabel mac mkpart primary hfs+ 33kB 100%

LOOP=$(sudo kpartx -s -a -v DISK.APM | awk -F'[ ]' '{print $3}' | tail -n1 )
sudo mkfs.hfsplus /dev/mapper/$LOOP
sudo mount -o loop /dev/mapper/$LOOP /mnt/

sudo cp -rv contents/* /mnt/

sudo umount /mnt/
sudo kpartx -d DISK.APM

