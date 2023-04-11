#!/bin/bash

## Get ChimeraOS Build Release
CHIMERAOS_VERSIONID=`grep 'VERSION_ID' /etc/os-release | awk -F= '{ print $2 }' | sed s/\"//g`

CHIMERAOS_BUILDID=`grep 'BUILD_ID' /etc/os-release | awk -F= '{ print $2 }' | sed s/\"//g`

CHIMERAOS_BUILD=chimeraos-"$CHIMERAOS_VERSIONID"_"$CHIMERAOS_BUILDID"

## Delete old Kernels that are NOT the current version

for kernel in `ls /boot | grep chimeraos | grep -v $CHIMERAOS_BUILD`; do rm -rf /boot/$kernel; done


## Replace generic preset with accurate mkinitcpio.d/linux.preset

echo '# mkinitcpio preset file for the '"'"'linux'"'"' package

ALL_config="/etc/mkinitcpio.conf"
ALL_kver="/boot/'$CHIMERAOS_BUILD'/vmlinuz-linux"
ALL_microcode=(/boot/'$CHIMERAOS_BUILD'/*-ucode.img)

PRESETS=('"'"'default'"'"' '"'"'fallback'"'"')

#default_config="/etc/mkinitcpio.conf"
default_image="/boot/'$CHIMERAOS_BUILD'/initramfs-linux.img"
#default_uki="/efi/EFI/Linux/arch-linux.efi"
#default_options="--splash /usr/share/systemd/bootctl/splash-arch.bmp"

#fallback_config="/etc/mkinitcpio.conf"
fallback_image="/boot/initramfs-linux-fallback.img"
#fallback_uki="/efi/EFI/Linux/arch-linux-fallback.efi"
fallback_options="-S autodetect"
' > /etc/mkinitcpio.d/linux.preset
