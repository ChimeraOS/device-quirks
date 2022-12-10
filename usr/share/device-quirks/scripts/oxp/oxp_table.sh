#/bin/bash
### OneXPlayer SYSTEM IDENTIFICATION SCRIPT

PRODUCT_NAME="$(cat /sys/devices/virtual/dmi/id/product_name)"
BOARD_NAME="$(cat /sys/devices/virtual/dmi/id/board_name)"
CPU_NAME="$(cat /proc/cpu | awk 'NR==5 {print $4$5$6$7}')"


### OXP Devices
#if [[ "Dummy" == "$PRODUCT_NAME" ]] && [[ "dummy" == "$BOARD_NAME"]] && [[ "dummy" == "$CPU_NAME"]]; then
#    echo "OXP FOUND"
#    ./ayaneoair.sh
    
# Unrecognized OXP Device
#else
#    echo "OXP Device was not recognized. Exiting quirk triage script."
#fi