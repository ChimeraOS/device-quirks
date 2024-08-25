#!/bin/bash

# Returning a unique id to allow users to toggle on or off in /etc/device-quirks/device-quirks.conf
device_quirk_id(){
    echo "ATARI_DISABLE_WIFI_POWERSAVE"
}

# Returning the name of the fix to display.
device_quirk_name(){
    echo "Disable Wifi Powersave"
}

# Do the install here.
device_quirk_install(){

    if [[ -e "${DQ_WORKING_PATH}/etc/NetworkManager/conf.d/disable-wifi-powersave.conf" ]]; then
        return 2
    fi

    cp -a "${DQ_PATH}/scripts/atari/resources/$(device_quirk_id)/disable-wifi-powersave.conf" "${DQ_WORKING_PATH}/etc/NetworkManager/conf.d/disable-wifi-powersave.conf"
    if [[ $? -eq 0 ]]; then
        return 0
    fi

    echo "Failed to create ${DQ_WORKING_PATH}/etc/NetworkManager/conf.d/disable-wifi-powersave.conf"
    return 1
}

# Remove the install here.
device_quirk_removal(){

    if [[ ! -e "${DQ_WORKING_PATH}/etc/NetworkManager/conf.d/disable-wifi-powersave.conf" ]]; then
        return 2
    fi

    rm -f "${DQ_WORKING_PATH}/etc/NetworkManager/conf.d/disable-wifi-powersave.conf"
    if [[ $? -eq 0 ]]; then
        return 0
    fi

    echo "Failed to delete ${DQ_WORKING_PATH}/etc/NetworkManager/conf.d/disable-wifi-powersave.conf"
    return 1
}