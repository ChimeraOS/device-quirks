#/bin/bash

PRODUCT_NAME="$(cat /sys/devices/virtual/dmi/id/product_name)"

if [[ "ONEXPLAYER Mini Pro" == "$PRODUCT_NAME" ]]; then
    $DQ_PATH/scripts/oxp/mini_pro/mini_pro.sh
    
else
    echo "${PRODUCT_NAME} does not have a quirk configuration script. Exiting."
fi
