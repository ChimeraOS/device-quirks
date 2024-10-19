#!/bin/bash

# File constants
DEPLOYED_FILE="${$DQ_WORKING_PATH}/etc/device-quirks/systemd-suspend-mods.conf"
SOURCE_FILE="${DQ_PATH}/scripts/resources/systemd-suspend-mods.conf"

# Returning a unique id to allow users to toggle on or off in /etc/device-quirks/device-quirks.conf
device_quirk_id(){
    echo "MT7921E"
}

# Returning the name of the fix to display.
device_quirk_name(){
    echo "Add MT7921E fix"
}

# Do the install here.
device_quirk_install(){
    # On new installs, we need to add the file so the quirk exists
	  if [[ ! -f ${DEPLOYED_FILE} ]]; then
        DIR_NAME=$(dirname ${DEPLOYED_FILE})
        if [[ ! -d ${DIR_NAME} ]]; then
            echo "Creating device_quirks location."
            mkdir -p ${DIR_NAME}
        fi
        # Create device-quirks with mt7921e config
        echo "Creating empty default config"
        cat > "${DEPLOYED_FILE}" <<EOL
# Line separated list of modules to unload/reload at suspend/resume.
mt7921e
EOL
    fi

    # Nothing to do if the qurik exists
    if grep -q -i 'mt7921e' "${DEPLOYED_FILE}"; then
        return 0
    # Add the mt7921e quirk if it doesnt exist
    else
        echo "mt7921e" >> ${DEPLOYED_FILE}
        return 0
	fi
    
    # Error if we failed to apply the quirk
    return 2
}

# Remove the install here.
device_quirk_removal(){
    # Remove the MT7921E quirk
    if [[ -f "${DEPLOYED_FILE}" ]] && grep -q -i 'mt7921e' "${DEPLOYED_FILE}"; then
        grep -iv 'mt7921e' "${DEPLOYED_FILE}" > "${DEPLOYED_FILE}"
        return 0
    elif [ -f ${DEPLOYED_FILE} ]; then
        return 2
    fi
}
