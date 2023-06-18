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

# Do DSDT override.
if [[ $USE_FIRMWARE_OVERRIDES == 1 ]]; then
  BIOS="$(cat /sys/devices/virtual/dmi/id/bios_version)"
  if [[ $BIOS == "RC71L.314" ]]; then
    echo "Enabling DSDT Override for v314 BIOS."
    $DQ_PATH/scripts/override_dsdt "rog_ally_v317.dsl"
  elif [[ $BIOS == "RC71L.317" ]]; then
    echo "Enabling DSDT Override for v317 BIOS."
    $DQ_PATH/scripts/override_dsdt "rog_ally_v317.dsl"
  elif [[ $BIOS == "RC71L.V319" ]]; then
    echo "Enabling DSDT Override for v319 BIOS."
    $DQ_PATH/scripts/override_dsdt "rog_ally_v319.dsl"
  else
    echo "No matching BIOS found. DSDT Override skipped."
  fi
else
  echo "Firmware overrides are disabled, skipping...\n"
  echo "To enable firmware overrides, edit /etc/device-quirks/device-quirks.conf"
fi
