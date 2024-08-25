#!/bin/bash

# Returning a unique id to allow users to toggle on or off in /etc/device-quirks/device-quirks.conf
device_quirk_id(){
    echo "GPD_EDID_OVERRIDE"
}

# Returning the name of the fix to display.
device_quirk_name(){
    echo "Override EDID"
}

# Do the install here.
device_quirk_install(){
    local edid_connection="eDP-1"
    local edid_filename="gpd_win4_edid.bin"
    local kernel_option="drm.edid_firmware=${edid_connection}:edid/${edid_filename}"

    if [[ -e "${DQ_WORKING_PATH}/etc/mkinitcpio.conf" ]]; then
        local mkinitcpio_files=$(grep -i 'files=(' "${DQ_WORKING_PATH}/etc/mkinitcpio.conf" | cut -d "(" -f2 | cut -d ")" -f1)

        if [[ ! $mkinitcpio_files =~ $edid_filename ]]; then
            grep -iv 'files=(' "${DQ_WORKING_PATH}/etc/mkinitcpio.conf" > "${DQ_WORKING_PATH}/etc/mkinitcpio.conf"
            if [[ $? -eq 0 ]]; then
                echo "files=( ${mkinitcpio_files} /lib/firmware/edid/${edid_filename} )" >> "${DQ_WORKING_PATH}/etc/mkinitcpio.conf"
            else
                echo "Unable to write to ${DQ_WORKING_PATH}/etc/mkinitcpio.conf, exiting."
                return 1
            fi
        fi
        append_kernel_option "$kernel_option"
        local return_code="$?"

        case $return_code in
            0) return 0;;
            1) return 1;;
            2) return 2;;
            *) return 1
        esac
    fi

    echo "Unable to update ${DQ_WORKING_PATH}/etc/mkinitcpio.conf since it does not exist."
    return 1
}

# Remove the install here.
device_quirk_removal(){
    local edid_connection="eDP-1"
    local edid_filename="gpd_win4_edid.bin"
    local kernel_option="drm.edid_firmware=${edid_connection}:edid/${edid_filename}"

    if [[ -e "${DQ_WORKING_PATH}/etc/mkinitcpio.conf" ]]; then
        local mkinitcpio_files=$(grep -i 'files=(' "${DQ_WORKING_PATH}/etc/mkinitcpio.conf" | cut -d "(" -f2 | cut -d ")" -f1)

        if [[ $mkinitcpio_files =~ $edid_filename ]]; then
            grep -iv 'files=(' "${DQ_WORKING_PATH}/etc/mkinitcpio.conf" > "${DQ_WORKING_PATH}/etc/mkinitcpio.conf"
            if [[ $? -eq 0 ]]; then
                local edid_path="/lib/firmware/edid/${edid_filename}"
                local updated_mkinitcpio_files=${mkinitcpio_files//$edid_path/}

                echo "files=( ${updated_mkinitcpio_files} )" >> "${DQ_WORKING_PATH}/etc/mkinitcpio.conf"
            else
                echo "Unable to write to ${DQ_WORKING_PATH}/etc/mkinitcpio.conf, exiting."
                return 1
            fi
        fi
        remove_kernel_option "$kernel_option"
        local return_code="$?"

        case $return_code in
            0) return 0;;
            1) return 1;;
            2) return 2;;
            *) return 1
        esac
    fi

    echo "Unable to update ${DQ_WORKING_PATH}/etc/mkinitcpio.conf since it does not exist."
    return 1
}

