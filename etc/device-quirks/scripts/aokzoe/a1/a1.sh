#!/bin/bash
if [ $(whoami) != 'root' ]; then
	echo "You must be root to run this script."
   exit 1
fi
 
# Force 16 bit audio, format S16LE, rate 192000.
cp -a /usr/share/wireplumber /etc/
sed -i 's/--\["audio.format"\]/\["audio.format"\]/' /etc/wireplumber/main.lua.d/50-alsa-config.lua
sed -i 's/--\["audio.rate"\]/\["audio.rate"\]/' /etc/wireplumber/main.lua.d/50-alsa-config.lua
sed -i 's/44100/192000/' /etc/wireplumber/main.lua.d/50-alsa-config.lua

# Fix rotation of TTY's.
cp $DQ_PATH/scripts/aokzoe/a1/a1_fbcon.conf /etc/tmpfiles.d/a1_fbcon.conf

# Do EDID override.
$DQ_PATH/scripts/aokzoe/a1/a1_edid.sh
