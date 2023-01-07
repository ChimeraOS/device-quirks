#!/bin/bash

if [ $(whoami) != 'root' ]; then
	echo "You must be root to run this script."
   exit 1
fi

# Inject EDID override into initramfs & rotate screen to landscape
sed -i 's#FILES=()#FILES=\(/${DQ_PATH}/aokzoe/a1/a1_edid.bin\)#' /etc/mkinitcpio.conf
cp /boot/chimeraos-*/* /boot
mkinitcpio -P
cp -a /boot/initramfs-linux.img /boot/chimeraos-*/
rm /boot/initramfs*
rm /boot/vmlinuz-linux

#  Update syslinux.cfg
if ! grep -q "drm.edid_firmware=eDP-1:edid/aokzoea1ar07_edid.bin" /boot/EFI/BOOT/syslinux.cfg

then

   sed -i 's#quiet splash#drm.edid_firmware=eDP-1:edid/aokzoea1ar07_edid.bin quiet splash#'  /boot/EFI/BOOT/syslinux.cfg

fi
