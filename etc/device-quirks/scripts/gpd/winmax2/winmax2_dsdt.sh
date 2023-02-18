#!/bin/bash

if [ $(whoami) != 'root' ]; then
	echo "You must be root to run this script."
   exit 1
fi

cp $DQ_PATH/firmware/dsdt/gpd_winmax2_dsdt /boot/gpd_winmax2_dsdt

if ! grep -q "gpd_winmax2_dsdt" /boot/EFI/BOOT/syslinux.cfg
then
	sed -i 's/initrd.*/&\,..\/..\/gpd_winmax2_dsdt/g 1' /boot/EFI/BOOT/syslinux.cfg
fi
