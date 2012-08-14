#!/usr/bin/env bash
#
# Copyright (c) 2009-2012 VMware, Inc.

set -e

base_dir=$(readlink -nf $(dirname $0)/../..)
source $base_dir/lib/prelude_apply.bash

disk_image_name=root.img
kernel_image_name=kernel.img
ramdisk_image_name=initrd.img

# Map partition in image to loopback
dev=$(kpartx -av $work/$disk_image_name | grep "^add" | cut -d" " -f3)

# Mount partition
mnt=$work/mnt
mkdir -p $mnt
mount /dev/mapper/$dev $mnt

# Find and copy kernel
vmlinuz_file=$(find $mnt/boot/ -name "vmlinuz-*")
if [ -e "${vmlinuz_file:-}" ]
then
  cp $vmlinuz_file $work/$kernel_image_name
fi

# Find and copy ramdisk
initrd_file=$(find $mnt/boot/ -name "initrd*")
if [ -e "${initrd_file:-}" ]
then
  cp $initrd_file $work/$ramdisk_image_name
fi

# Unmount partition
umount $mnt

# Unmap partition
kpartx -dv $work/$disk_image_name