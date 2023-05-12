#!/bin/bash
if [ $(whoami) != 'root' ]; then
	echo "You must be root to run this script."
   exit 1
fi
 
source /etc/device-quirks.conf
if [ $USE_FIRMWARE_OVERRIDES == '1' ]; then
  # Do EDID override.
  $DQ_PATH/scripts/ayaneo/air_plus/air_plus_dsdt.sh
fi
