#!/bin/bash

# Returning a unique id to allow users to toggle on or off in /etc/device-quirks/device-quirks.conf
device_quirk_id(){
    echo "AOKZOE_TTY_ROTATION_FIX"
}

# Returning the name of the fix to display.
device_quirk_name(){
    echo "TTY Rotation fix"
}

# Do the install here.
device_quirk_install(){
    local kernel_option="video=eDP-1:panel_orientation=left_side_up"

    append_kernel_option "$kernel_option"
    local return_code="$?"

    case $return_code in
        0) return 0;;
        1) return 1;;
        2) return 2;;
        *) return 1
    esac
}

# Remove the install here.
device_quirk_removal(){
    local kernel_option="video=eDP-1:panel_orientation=left_side_up"

    remove_kernel_option "$kernel_option"
    local return_code="$?"

    case $return_code in
        0) return 0;;
        1) return 1;;
        2) return 2;;
        *) return 1
    esac
}