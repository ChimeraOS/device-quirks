#/bin/bash
### AOKZOE SYSTEM IDENTIFICATION SCRIPT

PRODUCT_NAME="$(cat /sys/devices/virtual/dmi/id/product_name)"
BOARD_NAME="$(cat /sys/devices/virtual/dmi/id/board_name)"
CPU_NAME="$(cat /proc/cpu | awk 'NR==5 {print $4$5$6$7}')"


### AOKZOE Devices
if [[ "AOKZOE A1 AR07" == "$PRODUCT_NAME" ]] && [[ "AOKZOE A1 AR07" == "$BOARD_NAME"]] && [[ "AMDRyzen76800U" == "$CPU_NAME"]]; then
    echo "AOKZOE A1 FOUND"
    ./aokzoea1ar07.sh
    
# Unrecognized AOKZOE Device
else
    echo "AOKZOE Device was not recognized. Exiting quirk triage script."
fi