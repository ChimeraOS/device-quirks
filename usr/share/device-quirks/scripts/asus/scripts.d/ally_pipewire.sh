#!/bin/bash

# Returning a unique id to allow users to toggle on or off in /etc/device-quirks/device-quirks.conf
device_quirk_id(){
    echo "ALLY-PIPEWIRE-CFG"
}

# Returning the name of the fix to display.
device_quirk_name(){
    echo "ROG Ally Pipewire Configuration"
}

# Do the install here.
device_quirk_install(){

    if [[ -d "${DQ_WORKING_PATH}/etc/pipewire" ]] && [[ ! -z $(diff -qr "${DQ_WORKING_PATH}/etc/pipewire" "${DQ_PATH}/scripts/asus/resources/ALLY-PIPEWIRE-CFG/pipewire") ]]; then
        return 2
    elif [[ -d "${DQ_WORKING_PATH}/etc/pipewire" ]] && [[ ! -e "${DQ_WORKING_PATH}/etc/pipewire/.ALLY-PIPEWIRE-CFG" ]]; then
        echo "There is no easy way to merge configuration files for Pipewire, renaming existing ${DQ_WORKING_PATH}/etc/pirewire directory to pipewire.bak."
        mv "${DQ_WORKING_PATH}/etc/pipewire" "${DQ_WORKING_PATH}/etc/pipewire.bak"
        if [ $? -eq 0 ]; then
            cp -r "${DQ_PATH}/scripts/asus/resources/ALLY-PIPEWIRE-CFG/pipewire" "${DQ_WORKING_PATH}/etc/"
            touch "${DQ_WORKING_PATH}/etc/pipewire/.ALLY-PIPEWIRE-CFG"
            return 0
        else
            echo "Error renaming existing pipewire directory."
            return 1
        fi
    else
        cp -r "${DQ_PATH}/scripts/asus/resources/ALLY-PIPEWIRE-CFG/pipewire" "${DQ_WORKING_PATH}/etc/" 
        if [ $? -eq 0 ]; then
            return 0
        else
            echo "Error copying pipewire directory into /etc"
            return 1
        fi
    fi
}

# Remove the install here.
device_quirk_removal(){

    if [[ -d "${DQ_WORKING_PATH}/etc/pipewire" ]] && [[ -z $(diff -qr "${DQ_WORKING_PATH}/etc/pipewire" "${DQ_PATH}/scripts/asus/resources/ALLY-PIPEWIRE-CFG/pipewire") ]]; then
        rm -rf "${DQ_WORKING_PATH}/etc/pipewire"
        if [ $? -eq 0 ]; then
            return 0
        else
            echo "Error removing pipewire directory."
            return 1
        fi
    elif [[ -d "${DQ_WORKING_PATH}/etc/pipewire" ]]; then
        echo "Manual removal of the Asus ROG Ally pipewire configuration required..."
        return 1
    else
        return 2
    fi

}