#/bin/bash

PRODUCT_NAME="$(cat /sys/devices/virtual/dmi/id/product_name)"
BOARD_NAME="$(cat /sys/devices/virtual/dmi/id/board_name)"
CPU_NAME="$(cat /proc/cpuinfo | awk 'NR==5 {print $4$5$6$7}')"

if [[ "AOKZOE A1 AR07" == "$PRODUCT_NAME" ]] && [[ "AOKZOE A1 AR07" == "$BOARD_NAME"]] && [[ "AMDRyzen76800U" == "$CPU_NAME"]]; then
    $DQ_PATH/aokzoe/a1/a1.sh
    
else
    echo "${PRODUCT_NAME} does not have a quirk configuration script. Exiting."
fi
