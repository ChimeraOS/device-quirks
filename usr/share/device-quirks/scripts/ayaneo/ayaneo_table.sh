#/bin/bash

PRODUCT_NAME="$(cat /sys/devices/virtual/dmi/id/product_name)"
BOARD_NAME="$(cat /sys/devices/virtual/dmi/id/board_name)"
CPU_NAME="$(cat /proc/cpuinfo | awk 'NR==5 {print $4$5$6$7}')"

BOARD_LIST_2021="AYA NEO Founder:AYA NEO 2021:AYANEO 2021:AYANEO 2021 Pro:AYANEO 2021 Pro Retro Power"
BOARD_LIST_AIR="AIR:AIR Pro"
CPU_LIST_2021="AMDRyzen54500U:AMDRyzen74800U"
CPU_LIST_AIR="AMDRyzen5560U:AMDRyzen75825U"
PRODUCT_LIST_2021="AYA NEO Founder:AYA NEO 2021:AYANEO 2021:AYANEO 2021 Pro:AYANEO 2021 Pro Retro Power"
PRODUCT_LIST_AIR="AIR:AIR Pro"

if [[ ":$PRODUCT_LIST_2021:" =~ "$PRODUCT_NAME" ]] && [[ ":$BOARD_LIST_2021:" =~ "$BOARD_NAME" ]] && [[ ":$CPU_LIST_2021:" =~ "$CPU_NAME" ]]; then
  $DQ_PATH/ayaneo/2021/2021.sh
#elif [[ ":$LIST_AIR:" =~ "$PRODUCT_NAME" ]] && [[ ":$LIST_AIR:" =~ "$BOARD_NAME" ]] && [[ ":$CPU_LIST_AIR:" =~ "$CPU_NAME" ]]; then
#  $DQ_PATH/ayaneo/air/air.sh
else
  echo "${PRODUCT_NAME} does not have a quirk configuration script. Exiting."
fi
