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

PRODUCT_NAME="$(cat /sys/devices/virtual/dmi/id/product_name)"
if [[ $USE_FIRMWARE_OVERRIDES == 1 ]]; then
  # Do DSDT override.
  case $PRODUCT_NAME in
    "AYANEO 2021")
      echo "Enabling DSDT Override"
      $DQ_PATH/scripts/override_dsdt "ayaneo_2021.dsl"
      ;;
    "AYANEO 2021 Pro Retro Power")
      echo "Enabling DSDT Override"
      $DQ_PATH/scripts/override_dsdt "ayaneo_2021_pro_retro_power.dsl"
      ;;
  esac
else
  echo "Firmware overrides are disabled, skipping...\n"
  echo "To enable firmware overrides, edit /etc/device-quirks/device-quirks.conf"
fi
