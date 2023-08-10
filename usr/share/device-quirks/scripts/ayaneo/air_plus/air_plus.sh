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

if [[ $USE_FIRMWARE_OVERRIDES == 1 ]]; then
  BIOS="$(cat /sys/devices/virtual/dmi/id/bios_version)"
  if [[ $BIOS == "E.AB05_A_V.D16..006" ]]; then
    echo "Enabling DSDT Override for D16 BIOS."
    DSDT_OVERRIDES="ayaneo_air_plus_D16_0x0D.dsl ayaneo_air_plus_D16_0x0F.dsl ayaneo_air_plus_D16_0x7D.dsl ayaneo_air_plus_D16_0xCF.dsl"
  elif [[ $BIOS == "E.AB05_A_V.D32..006" ]]; then
    echo "Enabling DSDT Override for D32 BIOS."
    DSDT_OVERRIDES="ayaneo_air_plus_D32_0x0D.dsl ayaneo_air_plus_D32_0x94.dsl ayaneo_air_plus_D32_0xD4.dsl"
  else
    echo "No matching BIOS found. DSDT Override skipped."
  fi

  $DQ_PATH/scripts/override_dsdt $DSDT_OVERRIDES
else
  echo "Firmware overrides are disabled, skipping...\n"
  echo "To enable firmware overrides, edit /etc/device-quirks/device-quirks.conf"
fi
