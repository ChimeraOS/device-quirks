#!/bin/bash
if [ $(whoami) != 'root' ]; then
	echo "You must be root to run this script."
   exit 1
fi
 
# Force 16 bit audio, format S16LE, sample rate 96000.
$DQ_PATH/override_bitrate

# Fix rotation of TTY's.
cp $DQ_PATH/scripts/aokzoe/a1/a1_fbcon.conf /etc/tmpfiles.d/a1_fbcon.conf

source /etc/device-quirks.conf
if [ $USE_FIRMWARE_OVERRIDES == '1' ]; then
  # Do EDID override.
  $DQ_PATH/scripts/aokzoe/a1/a1_edid.sh
fi
