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

# Do DSDT override.
DSDT_OVERRIDES="ayaneo_air_plus_D16_0x0D.dsl ayaneo_air_plus_D16_0xCF.dsl ayaneo_air_plus_D32_0x94.dsl ayaneo_air_plus_D32_0xD4.dsl"
if [[ $USE_FIRMWARE_OVERRIDES == 1 ]]; then
  $DQ_PATH/scripts/override_dsdt $DSDT_OVERRIDES
else
  echo "Firmware overrides are disabled, skipping...\n"
  echo "To enable firmware overrides, edit /etc/device-quirks/device-quirks.conf"
fi
