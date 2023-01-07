#!/bin/bash

if [ $(whoami) != 'root' ]; then
	echo "You must be root to run this script."
   exit 1
fi

cp $DQ_PATH/ayaneo/2021/2021_dsdt /boot/2021_dsdt
if ! grep -q "2021_dsdt" /boot/EFI/BOOT/syslinux.cfg

then
	sed -i 's/initrd.*/&\,..\/..\/2021_dsdt/g 1' /boot/EFI/BOOT/syslinux.cfg
fi
