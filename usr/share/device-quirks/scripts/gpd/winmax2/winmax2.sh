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

# Force 16 bit audio, format S16LE, sample rate 96000.
echo "Force S16LE 96000hz"
$DQ_PATH/scripts/override_bitrate

PRODUCT_NAME="$(cat /sys/devices/virtual/dmi/id/product_name)"
if [[ $USE_FIRMWARE_OVERRIDES == 1 ]]; then
  # Do DSDT override.
  DSDT_OVERRIDES="gpd_win_max_2_0x7E.dsl gpd_win_max_2_0xCC.dsl"
  for dsdt in $DSDT_OVERRIDES; do
    APPLY_PATCH=$($DQ_PATH/scripts/verify_dsdt $dsdt)
    if [[ $APPLY_PATCH == 1 ]]; then
      $DQ_PATH/scripts/override_dsdt $dsdt
      break
    fi
  done
else
  echo "Firmware overrides are disabled, skipping...\n"
  echo "To enable firmware overrides, edit /etc/device-quirks/device-quirks.conf"
fi
