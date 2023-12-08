#/bin/bash

PRODUCT_NAME="$(cat /sys/devices/virtual/dmi/id/product_name)"

if [[ "AOKZOE A1 AR07" == "$PRODUCT_NAME" ]]; then
    echo "A1 AR07"
    $DQ_PATH/scripts/aokzoe/a1/a1.sh
elif [[ "AOKZOE A1 Pro" == "$PRODUCT_NAME" ]]; then
    $DQ_PATH/scripts/aokzoe/a1/a1.sh
else
    echo "${PRODUCT_NAME} does not have a quirk configuration script. Exiting."
fi
