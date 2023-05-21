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

# Force 16 bit audio, format S16LE, sample rate 96000.
echo "Force S16LE 96000hz"
$DQ_PATH/scripts/override_bitrate

if [[ $USE_FIRMWARE_OVERRIDES == 1 ]]; then
  # Do DSDT override.
  echo "Enabling DSDT Override"
  $DQ_PATH/scripts/override_dsdt "ayaneo_air_plus.dsl"
else
  echo "Firmware overrides are disabled, skipping...\n"
  echo "To enable firmware overrides, edit /etc/device-quirks/device-quirks.conf"
fi
