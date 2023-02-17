#!/bin/bash

if [ $(whoami) != 'root' ]; then
	echo "You must be root to run this script."
   exit 1
fi

cp $DQ_PATH/firmware/dsdt/ayaneo_2021_dsdt /boot/ayaneo_2021_dsdt

if ! grep -q "ayaneo_2021_dsdt" /boot/EFI/BOOT/syslinux.cfg
then
	sed -i 's/initrd.*/&\,..\/..\/ayaneo_2021_dsdt/g 1' /boot/EFI/BOOT/syslinux.cfg
fi
