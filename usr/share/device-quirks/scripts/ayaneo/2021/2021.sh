#!/bin/bash
if [ $(whoami) != 'root' ]; then
  echo "You must be root to run this script."
  exit 1
fi
 
if [ -d /tmp/frzr_root ]; then
  source ${MOUNT_PATH}/etc/device-quirks/device-quirks.conf
else
  source /etc/device-quirks/device-quirks.conf
fi

if [[ $USE_FIRMWARE_OVERRIDES == 1 ]]; then
  # Do DSDT override.
  DSDT_OVERRIDES="ayaneo_2021_0x03.dsl ayaneo_2021_0xE3.dsl"
  APPLY_PATCH=$($DQ_PATH/scripts/verify_dsdt $DSDT_OVERRIDES)
  if [[ $APPLY_PATCH != "" ]]; then
     $DQ_PATH/scripts/override_dsdt $APPLY_PATCH
  else
    echo "Unable to find a matching DSDT. Firmware overrides not set."
  fi
else
  echo "Firmware overrides are disabled, skipping...\n"
  echo "To enable firmware overrides, edit /etc/device-quirks/device-quirks.conf"
fi
