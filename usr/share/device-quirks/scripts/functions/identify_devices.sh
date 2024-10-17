#!/bin/bash

get_vendor() {
    local vendor="$(cat /sys/devices/virtual/dmi/id/board_vendor)"
    local vendor_name=$(grep "$vendor" "$DQ_PATH/scripts/VENDORS" | awk -F '::' '{print $2}')
    
    if [ -z "$vendor_name" ]; then
        echo "$vendor"
        return 1
    else
        echo "$vendor_name"
        return 0
    fi
}

get_model() {
    local board_name="$(cat /sys/devices/virtual/dmi/id/board_name)"

    echo "$board_name"
}

check_device_compatiblity () {
    local quirk_id="$1"
    local vendor_id=$(get_vendor)
    local model_id=$(get_model)
    local model_check=$(grep "$quirk_id" "$DQ_PATH/scripts/$vendor_id/MODELS" | grep "$model_id")

    if [[ -z "$model_check" ]]; then
        return 1
    else
        return 0
    fi
}

check_for_device_entry() {
    local quirk_id="$1"

    ## Checking for entries in ACPI and via lspci
    for quirk_entry in $(grep "$quirk_id" "$DQ_PATH/scripts/chips/CHIPS" | awk -F '::' '{print $1}'); do
        if [ -d "/sys/bus/acpi/devices/$quirk_entry" ]; then
            return 0
        elif [[ ! -z $(lspci | grep "$quirk_entry") ]]; then
            return 0
        fi
    done

    return 1
}