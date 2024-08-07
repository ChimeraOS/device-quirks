#/bin/bash
BOARD_NAME="$(cat /sys/devices/virtual/dmi/id/board_name)"
CPU_NAME="$(cat /proc/cpuinfo | awk 'NR==5 {print $4$5$6$7}')"

if [[ "RC71L" == "$BOARD_NAME" ]] && [[ "AMDRyzenZ1Extreme" == "$CPU_NAME" ]]; then
  echo "ROG Ally detected"
  $DQ_PATH/scripts/asus/rog-ally/rog-ally.sh
elif [[ "RC72LA" == "$BOARD_NAME" ]] && [[ "AMDRyzenZ1Extreme" == "$CPU_NAME" ]]; then
  echo "ROG Ally X detected"
  $DQ_PATH/scripts/asus/rog-ally-x/rog-ally-x.sh
else
  echo "${PRODUCT_NAME} does not have a quirk configuration script. Exiting."
fi
