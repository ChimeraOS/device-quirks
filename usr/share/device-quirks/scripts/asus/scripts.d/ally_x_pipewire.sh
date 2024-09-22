#!/bin/bash

# Returning a unique id to allow users to toggle on or off in /etc/device-quirks/device-quirks.conf

device_quirk_id(){
    echo "ALLY-X-PIPEWIRE-CFG"
}

# Returning the name of the fix to display.

device_quirk_name(){
    echo "ROG Ally X Pipewire and WirePlumber Configuration"
}

PIPEWIRE_DIR="${DQ_WORKING_PATH}/etc/pipewire"
ALLY_X_PIPEWIRE_PATH="${DQ_PATH}/scripts/asus/resources/ALLY-PIPEWIRE-CFG/pipewire"
ALLY_X_PIPEWIRE_DIR="${DQ_PATH}/scripts/asus/resources/ALLY-PIPEWIRE-CFG/pipewire"
WIREPLUMBER_DIR="${DQ_WORKING_PATH}/etc/wireplumber"
ALLY_X_WIREPLUMBER_PATH="${DQ_PATH}/scripts/asus/resources/ALLY-PIPEWIRE-CFG/wireplumber"
ALLY_X_WIREPLUMBER_DIR="${DQ_PATH}/scripts/asus/resources/ALLY-PIPEWIRE-CFG/wireplumber"
# Do the install here.

device_quirk_install(){

    # Pipewire configuration installation
    if [[ -d "${PIPEWIRE_DIR}" ]] && [[ -n "$(diff -qr "${PIPEWIRE_DIR}" "${ALLY_X_PIPEWIRE_DIR}")" ]]; then
        echo "Pipewire configurations differ. Please review the differences:"
        diff -qr "${PIPEWIRE_DIR}" "${ALLY_X_PIPEWIRE_DIR}"
        return 2
    elif [[ -d "${PIPEWIRE_DIR}" ]]; then
        echo "Renaming existing ${PIPEWIRE_DIR} directory to pipewire.bak."
        mv "${PIPEWIRE_DIR}" "${PIPEWIRE_DIR}.bak"
        if [ $? -eq 0 ]; then
            cp -r "${ALLY_X_PIPEWIRE_DIR}" "${DQ_WORKING_PATH}/etc/"
            if [[ ! -f "${PIPEWIRE_DIR}/.ALLY-X-PIPEWIRE-CFG" ]]; then
                touch "${PIPEWIRE_DIR}/.ALLY-X-PIPEWIRE-CFG"
            fi
            echo "Pipewire configuration installed successfully."
        else
            echo "Error renaming existing pipewire directory."
            return 1
        fi
    else
        cp -r "${ALLY_X_PIPEWIRE_DIR}" "${DQ_WORKING_PATH}/etc/"
        if [ $? -eq 0 ]; then
            echo "Pipewire configuration installed successfully."
        else
            echo "Error copying pipewire directory into /etc"
            return 1
        fi
    fi

    # Wireplumber configuration installation
    if [[ -d "${WIREPLUMBER_DIR}" ]] && [[ -n "$(diff -qr "${WIREPLUMBER_DIR}" "${ALLY_X_WIREPLUMBER_DIR}")" ]]; then
        echo "Wireplumber configurations differ. Please review the differences:"
        diff -qr "${WIREPLUMBER_DIR}" "${ALLY_X_WIREPLUMBER_DIR}"
        return 2
    elif [[ -d "${WIREPLUMBER_DIR}" ]]; then
        echo "Renaming existing ${WIREPLUMBER_DIR} directory to wireplumber.bak."
        mv "${WIREPLUMBER_DIR}" "${WIREPLUMBER_DIR}.bak"
        if [ $? -eq 0 ]; then
            cp -r "${ALLY_X_WIREPLUMBER_DIR}" "${DQ_WORKING_PATH}/etc/"
            if [[ ! -f "${WIREPLUMBER_DIR}/.ALLY-X-WIREPLUMBER-CFG" ]]; then
                touch "${WIREPLUMBER_DIR}/.ALLY-X-WIREPLUMBER-CFG"
            fi
            echo "Wireplumber configuration installed successfully."
            return 0
        else
            echo "Error renaming existing wireplumber directory."
            return 1
        fi
    else
        cp -r "${ALLY_X_WIREPLUMBER_DIR}" "${DQ_WORKING_PATH}/etc/"
        if [ $? -eq 0 ]; then
            echo "Wireplumber configuration installed successfully."
            return 0
        else
            echo "Error copying wireplumber directory into /etc"
            return 1
        fi
    fi
}

device_quirk_removal(){

    # Pipewire configuration removal
    if [[ -d "${PIPEWIRE_DIR}" ]] && [[ -z "$(diff -qr "${PIPEWIRE_DIR}" "${ALLY_X_PIPEWIRE_DIR}")" ]]; then
        rm -rf "${DQ_WORKING_PATH}/etc/pipewire"
        if [ $? -eq 0 ]; then
            echo "Successfully removed pipewire directory."
        else
            echo "Error removing pipewire directory."
            return 1
        fi
    else
        echo "Pipewire configuration not found or differs from the expected configuration."
    fi

    # Wireplumber configuration removal
    if [[ -d "${WIREPLUMBER_DIR}" ]] && [[ -z "$(diff -qr "${WIREPLUMBER_DIR}" "${ALLY_X_WIREPLUMBER_DIR}")" ]]; then
        rm -rf "${DQ_WORKING_PATH}/etc/wireplumber"
        if [ $? -eq 0 ]; then
            echo "Successfully removed wireplumber directory."
            return 0
        else
            echo "Error removing wireplumber directory."
            return 1
        fi
    fi

    echo "Wireplumber configuration not found or differs from the expected configuration."

    return 2
}
