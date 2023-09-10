#/bin/bash

PRODUCT_NAME="$(cat /sys/devices/virtual/dmi/id/product_name)"
PRODUCT_LIST="VCS"

if [[ ":$PRODUCT_LIST:" =~ ":$PRODUCT_NAME:" ]]; then
  echo "ATARI VCS Device"
  $DQ_PATH/scripts/atari/vcs/vcs.sh
else
  echo "${PRODUCT_NAME} does not have a quirk configuration script. Exiting."
fi
