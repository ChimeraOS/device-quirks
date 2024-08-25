#!/bin/bash

# Returning a unique id to allow users to toggle on or off in /etc/device-quirks/device-quirks.conf
device_quirk_id(){
    echo "ALLY-X-PIPEWIRE-CFG"
}

# Returning the name of the fix to display.
device_quirk_name(){
    echo "ROG Ally X Pipewire Configuration"
}
PIPEWIRE_DIR=${DQ_WORKING_PATH}/etc/pipewire
ALLY_X_PATH=${DQ_PATH}/scripts/asus/resources/ALLY-X-PIPEWIRE-CFG/pipewire
ALLY_X_PIPEWIRE_DIR=${DQ_PATH}/scripts/asus/resources/ALLY-X-PIPEWIRE-CFG/pipewire
# Do the install here.
device_quirk_install(){

  if [[ -d "${PIPEWIRE_DIR}" ]] && [[ ! -z $(diff -qr "${PIPEWIRE_DIR}" "${ALLY_X_PIPEWIRE_DIR}") ]]; then
        return 2
    elif [[ -d ${PIPEWIRE_DIR} ]] && [[ ! -e ${ALLY_X_PATH} ]]; then
        echo "There is no easy way to merge configuration files for Pipewire, renaming existing ${PIPEWIRE_DIR} directory to pipewire.bak."
        mv "${PIPEWIRE_DIR}" "${PIPEWIRE_DIR}.bak"
        if [ $? -eq 0 ]; then
            cp -r "${ALLY_X_PIPEWIRE_DIR}" "${DQ_WORKING_PATH}/etc/"
            touch "${PIPEWIRE_DIR}/.ALLY-X-PIPEWIRE-CFG"
            return 0
        else
            echo "Error renaming existing pipewire directory."
            return 1
        fi
    else
        cp -r "${ALLY_X_PIPEWIRE_DIR}" "${DQ_WORKING_PATH}/etc/"
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

    if [[ -d "${PIPEWIRE_DIR}" ]] && [[ -z $(diff -qr "${PIPEWIRE_DIR}" "${ALLY_X_PIPEWIRE_DIR") ]]; then
        rm -rf "${DQ_WORKING_PATH}/etc/pipewire"
        if [ $? -eq 0 ]; then
            return 0
        else
            echo "Error removing pipewire directory."
            return 1
        fi
    elif [[ -d "${PIPEWIRE_DIR}" ]]; then
        echo "Manual removal of the Asus ROG Ally pipewire configuration required..."
        return 1
    else
        return 2
    fi

}
