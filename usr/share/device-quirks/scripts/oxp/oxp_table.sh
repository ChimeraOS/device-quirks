#/bin/bash

PRODUCT_NAME="$(cat /sys/devices/virtual/dmi/id/product_name)"
BOARD_NAME="$(cat /sys/devices/virtual/dmi/id/board_name)"
CPU_NAME="$(cat /proc/cpuinfo | awk 'NR==5 {print $4$5$6$7}')"

if [[ "Dummy" == "$PRODUCT_NAME" ]] && [[ "dummy" == "$BOARD_NAME"]] && [[ "dummy" == "$CPU_NAME"]]; then
    $DQ_PATH/oxp/model/model.sh
   
else
    echo "${PRODUCT_NAME} does not have a quirk configuration script. Exiting."
fi
