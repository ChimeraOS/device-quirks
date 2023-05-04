#!/bin/bash

if [ $(whoami) != 'root' ]; then
	echo "You must be root to run this script."
   exit 1
fi

mkdir -p /run/media/boot
mount -L frzr_efi /run/media/boot

if ! grep -q 'ayaneo_air_plus_dsdt' /run/media/boot/loader/entries/frzr.conf
  cp /lib/firmware/dsdt/ayaneo_air_plus_dsdt /rum/media/boot/ayaneo_air_plus_dsdt
  sed 's/linux \/vmlinuz-linux/initrd \/ayane_air_plus_dsdt/a' /run/media/boot/loader/entries/frzr.conf
fi

umount -l /run/media/boot
rm -r /run/media/boot

