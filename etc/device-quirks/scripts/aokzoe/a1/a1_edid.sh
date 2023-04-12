#!/bin/bash

if [ $(whoami) != 'root' ]; then
	echo "You must be root to run this script."
   exit 1
fi

# Get ChimeraOS Build Release
CHIMERAOS_VERSIONID=`grep 'VERSION_ID' /etc/os-release | awk -F= '{ print $2 }' | sed s/\"//g`

CHIMERAOS_BUILDID=`grep 'BUILD_ID' /etc/os-release | awk -F= '{ print $2 }' | sed s/\"//g`

CHIMERAOS_BUILD=chimeraos-"$CHIMERAOS_VERSIONID"_"$CHIMERAOS_BUILDID"

# Inject EDID override into initramfs & rotate screen to landscape
sed -i 's#FILES=()#FILES=\(/lib/firmware/edid/aokzoe_a1ar07_edid.bin\)#' /etc/mkinitcpio.conf
cp -a /boot/$CHIMERAOS_BUILD/* /boot
mkinitcpio -P
cp -a /boot/initramfs-linux.img /boot/$CHIMERAOS_BUILD/

#  Update systemd-boot entries config
if ! grep -q "drm.edid_firmware=eDP-1:edid/aokzoe_a1ar07_edid.bin" /boot/loader/entries/frzr.conf

then

   sed -i 's#iomem=relaxed#iomem=relaxed fbcon=rotate:3 drm.edid_firmware=eDP-1:edid/aokzoe_a1ar07_edid.bin#'  /boot/loader/entries/frzr.conf

fi
