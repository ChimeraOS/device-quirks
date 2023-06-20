#/bin/bash

PRODUCT_NAME="$(cat /sys/devices/virtual/dmi/id/product_name)"
BOARD_NAME="$(cat /sys/devices/virtual/dmi/id/board_name)"
CPU_NAME="$(cat /proc/cpuinfo | awk 'NR==5 {print $4$5$6$7}')"

if [[ "AOKZOE A1 AR07" == "$PRODUCT_NAME" ]]; then
    echo "A1 AR07"
    $DQ_PATH/scripts/aokzoe/a1/a1.sh
elif [[ "AOKZOE A1 Pro" == "$PRODUCT_NAME" ]]; then
    echo "A1 Pro"
    $DQ_PATH/scripts/aokzoe/a1/a1pro.sh 
else
    echo "${PRODUCT_NAME} does not have a quirk configuration script. Exiting."
fi
