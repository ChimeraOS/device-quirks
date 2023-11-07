#/bin/bash

PRODUCT_NAME="$(cat /sys/devices/virtual/dmi/id/product_name)"
BOARD_NAME="$(cat /sys/devices/virtual/dmi/id/board_name)"
CPU_NAME="$(cat /proc/cpuinfo | awk 'NR==5 {print $4$5$6$7}')"

if [[ "83E1" == "$PRODUCT_NAME" ]] && [[ "LNVNB161216" == "$BOARD_NAME" ]] && [[ "AMDRyzenZ1Extreme" == "$CPU_NAME" ]]; then
    echo "Legion Go detected"
    $DQ_PATH/scripts/lenovo/legion-go/legion-go.sh

else
    echo "${PRODUCT_NAME} does not have a quirk configuration script. Exiting."
fi
