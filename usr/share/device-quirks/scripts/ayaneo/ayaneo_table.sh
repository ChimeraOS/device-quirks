#/bin/bash
### AYANEO SYSTEM IDENTIFICATION SCRIPT

PRODUCT_NAME="$(cat /sys/devices/virtual/dmi/id/product_name)"
BOARD_NAME="$(cat /sys/devices/virtual/dmi/id/board_name)"
CPU_NAME="$(cat /proc/cpuinfo | awk 'NR==5 {print $4$5$6$7}')"

2021_LIST=":AYA NEO Founder:AYA NEO 2021:AYANEO 2021:AYANEO 2021 Pro:AYANEO 2021 Pro Retro Power:"
2021_LIST=":AIR:AIR Pro:"

if [[ ":$2021_LIST:" =~ "$PRODUCT_NAME" ]] && [[ ":$2021_LIST:" =~ "$BOARD_NAME"]] && [[ ":AMDRyzen54500U:AMDRyzen74800U" =~ "$CPU_NAME"]]; then
    ./2021/2021.sh
   
elif [[ ":$2021_LIST:" =~ "$PRODUCT_NAME" ]] && [[ ":$2021_LIST:" =~ "$BOARD_NAME"]] && [[ ":AMDRyzen55560U:AMDRyzen75825U" =~ "$CPU_NAME"]]; then
    ./air/air.sh
else
    echo "${PRODUCT_NAME} does not have a quirk configuration script. Exiting."
fi
