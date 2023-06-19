#!/bin/bash
if [ $(whoami) != 'root' ]; then
  echo "You must be root to run this script."
  exit 1
fi
 
# Force 16 bit audio, format S16LE, sample rate 96000.
echo "Force S16LE 96000hz"
$DQ_PATH/scripts/override_bitrate

# Fix rotation of TTY's.
$DQ_PATH/scripts/kernel-options-manager --append video=eDP-1:panel_orientation=left_side_up

if [ -d /tmp/frzr_root ]; then
  source ${MOUNT_PATH}/etc/device-quirks.conf
else
  source /etc/device-quirks.conf
fi

if [[ $USE_FIRMWARE_OVERRIDES == 1 ]]; then
  # Do EDID override.
  echo "Enabling EDID Override"
  $DQ_PATH/scripts/override_edid "eDP-1" "aokzoe_a1ar07_edid.bin"
else
  echo "Firmware overrides are disabled, skipping...\n"
  echo "To enable firmware overrides, edit /etc/device-quirks.conf"
fi
