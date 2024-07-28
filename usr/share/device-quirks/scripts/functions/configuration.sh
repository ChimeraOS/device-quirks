#!/bin/bash

get_firmware_override_status() {
    local firmware_override_status=0

    if [[ ! -e "$DQ_WORKING_PATH/etc/device-quirks/device-quirks.conf" ]]; then
        return 0
    fi

    firmware_override_status=$(grep -i "USE_FIRMWARE_OVERRIDES" "$DQ_WORKING_PATH/etc/device-quirks/device-quirks.conf" | awk -F '=' '{print $2}')

    if [[ "$firmware_override_status" == "1" ]]; then
        return 1
    else
        return 0
    fi
}

get_quirk_id_status() {
    local quirk_id="$1"
    local quirk_id_status=$(grep -i "$quirk_id" "$DQ_WORKING_PATH/etc/device-quirks/device-quirks.conf" | awk -F '=' '{print $2}')

    if [[ "$quirk_id_status" != "0" ]]; then
        return 1
    else
        return 0
    fi
}

# This function should only be called post quirk install as to not override an existing setting
set_quirk_id_status() {
    local quirk_id="$1"

    echo "export DQ_${quirk_id^^}=1" >> "$DQ_WORKING_PATH/etc/device-quirks/device-quirks.conf" 
}