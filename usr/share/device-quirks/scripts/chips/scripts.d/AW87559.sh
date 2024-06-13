#!/bin/bash

# Returning a unique id to allow users to toggle on or off in /etc/device-quirks/device-quirks.conf
device_quirk_id(){
    echo "AW87559"
}

# Returning the name of the fix to display.
device_quirk_name(){
    echo "Firmware Download for Awinic AW87559 AMP"
}

# Do the install here.
device_quirk_install(){
    local AW87XXX_MD5="7a0192e05a7ab574aa95a9befdf7ae9c"
    local AW87XXX_FILENAME="aw87xxx_acf.bin"
    local AW87XXX_PATH="$DQ_WORKING_PATH/usr/lib/firmware"
    local AW87XXX_URL="https://archive.org/download/awinic-aw87559-driver/awinic_smartk_acf.bin"

    # If existing firmware file exists check if it's ours then exit, if not fail.
    if [ -e "${AW87XXX_PATH}/${AW87XXX_FILENAME}" ]; then
        # Calculate the MD5 hash of the downloaded file
        local calculated_md5=$(md5sum "${AW87XXX_PATH}/${AW87XXX_FILENAME}" | cut -d ' ' -f 1)

        # Compare the expected and actual MD5 hashes
        if [[ "${AW87XXX_MD5}" == "${calculated_md5}" ]]; then
            echo "Existing firmware file installed, exiting."
            return 2
        else
            echo "An alternative aw87559 firmware installed, exiting."
            return 1
        fi
    fi

    # Attempt to download the firmware file into tempfs
    curl -f -L -o "/tmp/${AW87XXX_FILENAME}" "${AW87XXX_URL}"

    if [[ $? -eq 0 ]]; then
        # Calculate the MD5 hash of the downloaded file
        local calculated_md5=$(md5sum "/tmp/${AW87XXX_FILENAME}" | cut -d ' ' -f 1)

        # Compare the expected and actual MD5 hashes
        if [[ "${AW87XXX_MD5}" == "${calculated_md5}" ]]; then
            # Move the confirmed valid firmware file to the correct path
            mv "/tmp/${AW87XXX_FILENAME}" "${AW87XXX_PATH}/${AW87XXX_FILENAME}"
            if [[ $? -eq 0 ]]; then
                return 0
            else
                echo "Download completed, and valid MD5, but could not write to ${AW87XXX_PATH}/${AW87XXX_FILENAME}"
                return 1
            fi
        else
            echo "Download completed, but MD5 hash does NOT match!"
            echo "Expected: ${AW87XXX_MD5}"
            echo "Actual:   ${calculated_md5}"
            return 1
        fi
    else
        echo "Download failed!"
        return 1
    fi

}

# Remove the install here.
device_quirk_removal(){
    local AW87XXX_MD5="7a0192e05a7ab574aa95a9befdf7ae9c"
    local AW87XXX_FILENAME="aw87xxx_acf.bin"
    local AW87XXX_PATH="$DQ_WORKING_PATH/usr/lib/firmware"

    # If existing firmware file exists check if it's ours then remove it, if not fail.
    if [ -e "${AW87XXX_PATH}/${AW87XXX_FILENAME}" ]; then
        # Calculate the MD5 hash of the downloaded file
        local calculated_md5=$(md5sum "${AW87XXX_PATH}/${AW87XXX_FILENAME}" | cut -d ' ' -f 1)

        # Compare the expected and actual MD5 hashes
        if [[ "${AW87XXX_MD5}" == "${calculated_md5}" ]]; then
            rm -f "${AW87XXX_PATH}/${AW87XXX_FILENAME}"
            if [[ $? -eq 0 ]]; then
                return 0
            else
                echo "Unable to delete ${AW87XXX_PATH}/${AW87XXX_FILENAME}, exiting."
                return 1
            fi
        else
            echo "An alternative aw87559 firmware installed, exiting."
            return 1
        fi
    fi

    return 2
}