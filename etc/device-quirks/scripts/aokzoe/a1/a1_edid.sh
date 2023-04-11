#!/bin/bash

if [ $(whoami) != 'root' ]; then
	echo "You must be root to run this script."
   exit 1
fi

# Inject EDID override into initramfs & rotate screen to landscape
sed -i 's#FILES=()#FILES=\(/lib/firmware/edid/aokzoe_a1ar07_edid.bin\)#' /etc/mkinitcpio.conf
cp /boot/chimeraos-*/* /boot
mkinitcpio -P
cp -a /boot/initramfs-linux.img /boot/chimeraos-*/
rm /boot/initramfs*
rm /boot/vmlinuz-linux

#  Update systemd-boot entries config
if ! grep -q "drm.edid_firmware=eDP-1:edid/aokzoe_a1ar07_edid.bin" /boot/loader/entries/frzr.conf

then

   sed -i 's#iomem=relaxed#iomem=relaxed drm.edid_firmware=eDP-1:edid/aokzoe_a1ar07_edid.bin#'  /boot/loader/entries/frzr.conf

fi
