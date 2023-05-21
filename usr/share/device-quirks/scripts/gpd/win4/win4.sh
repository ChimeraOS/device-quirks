#!/bin/bash
if [ $(whoami) != 'root' ]; then
  echo "You must be root to run this script."
  exit 1
fi
 
if [ -d /tmp/frzr_root ]; then
  source ${MOUNT_PATH}/etc/device-quirks.conf
else
  source /etc/device-quirks.conf
fi

if [[ $USE_FIRMWARE_OVERRIDES == 1 ]]; then
  # Do EDID override.
  echo "Enabling EDID Override"
  $DQ_PATH/scripts/override_edid "eDP-1" "gpd_win4_edid.bin"
else
  echo "Firmware overrides are disabled, skipping...\n"
  echo "To enable firmware overrides, edit /etc/device-quirks/device-quirks.conf"
fi
