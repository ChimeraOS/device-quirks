#!/bin/bash

if [ $(whoami) != 'root' ]; then
	echo "You must be root to run this script."
   exit 1
fi

cp ./2021_dsdt /boot/2021_dsdt
if ! grep -q "initrd ../../chimeraos-39_31d74f0/amd-ucode.img,../../chimeraos-39_31d74f0/intel-ucode.img,../../chimeraos-39_31d74f0/initramfs-linux.img,2021_dsdt" /boot/EFI/BOOT/syslinux.cfg

then

   sed -i 's#quiet splash#drm.edid_firmware=eDP-1:edid/aokzoea1ar07_edid.bin quiet splash#'  /boot/EFI/BOOT/syslinux.cfg
   sed -i 's#initrd ../../chimeraos-39_31d74f0/amd-ucode.img,../../chimeraos-39_31d74f0/intel-ucode.img,../../chimeraos-39_31d74f0/initramfs-linux.img#initrd ../../chimeraos-39_31d74f0/amd-ucode.img,../../chimeraos-39_31d74f0/intel-ucode.img,../../chimeraos-39_31d74f0/initramfs-linux.img,2021_dsdt#'  /boot/EFI/BOOT/syslinux.cfg

fi
