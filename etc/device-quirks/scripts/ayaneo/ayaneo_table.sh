#/bin/bash

PRODUCT_NAME="$(cat /sys/devices/virtual/dmi/id/product_name)"

PRODUCT_LIST_2021="AYA NEO Founder:AYA NEO 2021:AYANEO 2021:AYANEO 2021 Pro:AYANEO 2021 Pro Retro Power"

if [[ ":$PRODUCT_LIST_2021:" =~ "$PRODUCT_NAME" ]]; then
  $DQ_PATH/scripts/ayaneo/2021/2021.sh
else
  echo "${PRODUCT_NAME} does not have a quirk configuration script. Exiting."
fi
