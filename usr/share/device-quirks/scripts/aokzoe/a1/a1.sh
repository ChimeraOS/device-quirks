#!/bin/bash
if [ $(whoami) != 'root' ]; then
	echo "You must be root to run this script."
   exit 1
fi
 
# Force 16 bit audio, format S16LE, sample rate 96000.
echo "Force S16LE 96000hz"
$DQ_PATH/scripts/override_bitrate

# Fix rotation of TTY's.
cp $DQ_PATH/scripts/aokzoe/a1/a1_fbcon.conf /etc/tmpfiles.d/a1_fbcon.conf

source /etc/device-quirks.conf
if [ $USE_FIRMWARE_OVERRIDES == '1' ]; then
	# Do EDID override.
	echo "Requesting EDID Override"
	$DQ_PATH/scripts/override_edid "eDP-1" "aokzoe_a1ar07_edid.bin"
fi
