#!/bin/bash

### AOKZOE A1 Quirks

 
### Unlock Filesystem

frzr-unlock

### Force 16 bit audio, format S16LE, rate 192000

cp -a /usr/share/wireplumber /etc/

sed -i 's/--\["audio.format"\]/\["audio.format"\]/' /etc/wireplumber/main.lua.d/50-alsa-config.lua

sed -i 's/--\["audio.rate"\]/\["audio.rate"\]/' /etc/wireplumber/main.lua.d/50-alsa-config.lua

sed -i 's/44100/192000/' /etc/wireplumber/main.lua.d/50-alsa-config.lua

 

### Inject EDID override into initramfs & rotate screen to landscape

curl -O http://wiki.darkremix.net/aokzoe/aokzoea1ar07_edid.bin

mkdir -p /lib/firmware/edid

cp -a aokzoea1ar07_edid.bin /lib/firmware/edid/

sed -i 's#FILES=()#FILES=\(/lib/firmware/edid/aokzoea1ar07_edid.bin\)#' /etc/mkinitcpio.conf

cp /boot/chimeraos-*/* /boot

mkinitcpio -P

cp -a /boot/initramfs-linux.img /boot/chimeraos-*/

rm /boot/initramfs*

rm /boot/vmlinuz-linux

 

###  Update Syslinux.cfg if exists

if ! grep -q "iomem=relaxed drm.edid_firmware=eDP-1:edid/aokzoea1ar07_edid.bin fbcon=rotate:3" /boot/EFI/BOOT/syslinux.cfg

then

   sed -i 's#quiet splash#iomem=relaxed drm.edid_firmware=eDP-1:edid/aokzoea1ar07_edid.bin fbcon=rotate:3 quiet splash#'  /boot/EFI/BOOT/syslinux.cfg

fi