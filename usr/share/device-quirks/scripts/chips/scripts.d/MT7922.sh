#!/bin/bash

# Returning a unique id to allow users to toggle on or off in /etc/device-quirks/device-quirks.conf
device_quirk_id(){
    echo "MT7922"
}

# Returning the name of the fix to display.
device_quirk_name(){
    echo "Remove MT7921E fix on the MT7922"
}

# Do the install here.
device_quirk_install(){
	if [ -f "${$DQ_WORKING_PATH}/etc/device-quirks/systemd-suspend-mods.conf" ] && [ $(grep -i 'mt7921e' "${$DQ_WORKING_PATH}/etc/device-quirks/systemd-suspend-mods.conf") ]; then
		grep -iv 'mt7921e' "${$DQ_WORKING_PATH}/etc/device-quirks/systemd-suspend-mods.conf" > "${$DQ_WORKING_PATH}/etc/device-quirks/systemd-suspend-mods.conf"
        return 0
	fi
    return 2
}

# Remove the install here.
device_quirk_removal(){
    if [ -f "${$DQ_WORKING_PATH}/etc/device-quirks/systemd-suspend-mods.conf" ] && [ ! $(grep -i 'mt7921e' "${$DQ_WORKING_PATH}/etc/device-quirks/systemd-suspend-mods.conf") ]; then
        echo "mt7921e" > "${$DQ_WORKING_PATH}/etc/device-quirks/systemd-suspend-mods.conf"
        return 0
    elif [ -f "${$DQ_WORKING_PATH}/etc/device-quirks/systemd-suspend-mods.conf" ]; then
        return 2
    else
        cp -a "${DQ_PATH}/scripts/chips/resources/$(device_quirk_id)/systemd-suspend-mods.conf" "${$DQ_WORKING_PATH}/etc/device-quirks/systemd-suspend-mods.conf"
        return 0
    fi
}