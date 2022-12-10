#/bin/bash
### SYSTEM IDENTIFICATION SCRIPT

SYS_ID="$(cat /sys/devices/virtual/dmi/id/product_name)"
VENDOR="$(cat /sys/devices/virtual/dmi/id/board_vendor)"

### DEVICE LISTS
# OXP Devices
OXP_LIST="ONE XPLAYER:ONEXPLAYER 1 T08:ONEXPLAYER 1S A08:ONEXPLAYER 1S T08:ONEXPLAYER mini A07:ONEXPLAYER mini GA72:ONEXPLAYER mini GT72:ONEXPLAYER GUNDAM GA72:ONEXPLAYER 2 ARP23"

# AYANEO AIR Devices
AYANEO_LIST="AIR:AIR Pro"

# AOKZOE Devices
AOK_LIST="AOKZOE"

### CALL DEVICE SPECIFIC SCRIPTS
# OXP Devices
if [[ ":$OXP_LIST:" =~ ":$SYS_ID:"  ]]; then
    echo "Possible OneXPlayer Device FOUND"
    ./oxp/oxp_table.sh
fi

# Aya Neo Air Devices
if [[ ":$AYANEO_LIST:" =~ ":$SYS_ID:"  ]]; then
    echo "Possible AYANEO Device FOUND"
    ./ayaneo/ayaneo_table.sh
fi

# AOKZOE Devices
if [[ ":$AOK_LIST:" =~ ":$VENDOR:"  ]]; then
    echo "Possible AOKZOE Device FOUND"
    ./aokzoe/aokzoe_table.sh
fi

# Unrecognized Device
if [[ ":$OXP_LIST:" != ":$SYS_ID:"  ]] && [[ ":$AYANEO_LIST:" != ":$SYS_ID:"  ]] && [[ ":$AOK_LIST:" != ":$SYS_ID:"  ]]; then
    echo "Device was not recognized. Exiting quirk triage script."
fi