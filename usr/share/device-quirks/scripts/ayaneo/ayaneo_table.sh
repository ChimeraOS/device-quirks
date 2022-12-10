#/bin/bash
### AYANEO SYSTEM IDENTIFICATION SCRIPT

PRODUCT_NAME="$(cat /sys/devices/virtual/dmi/id/product_name)"
BOARD_NAME="$(cat /sys/devices/virtual/dmi/id/board_name)"
CPU_NAME="$(cat /proc/cpu | awk 'NR==5 {print $4$5$6$7}')"


### AYANEO Devices
#if [[ "Dummy" == "$PRODUCT_NAME" ]] && [[ "dummy" == "$BOARD_NAME"]] && [[ "dummy" == "$CPU_NAME"]]; then
#    echo "AYANEO AIR FOUND"
#    ./ayaneoair.sh
    
# Unrecognized AYANEO Device
#else
#    echo "AYANEO Device was not recognized. Exiting quirk triage script."
#fi