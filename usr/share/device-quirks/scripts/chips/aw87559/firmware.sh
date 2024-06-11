#!/bin/bash

### Variables ###
AW87XXX_MD5="7a0192e05a7ab574aa95a9befdf7ae9c"
AW87XXX_FILENAME="aw87xxx_acf.bin"
AW87XXX_PATH="/usr/lib/firmware"
AW87XXX_URL="https://archive.org/download/awinic-aw87559-driver/awinic_smartk_acf.bin"
### Variables ###

aw87xxx_start() {
    echo "# AW87XXX firmware Downloader #"
    echo ""
}

aw87xxx_exit() {
    aw87xxx_exitcode="$1"

    if [[ "${aw87xxx_exitcode}" == "0" ]]; then
        echo "Firmware installed at ${MOUNT_PATH}/${AW87XXX_PATH}/${AW87XXX_FILENAME}"
        exit 0
    else
        exit 1
    fi
}

# Detect if the install media is running or not
if [ ! -d /tmp/frzr_root ]; then
  MOUNT_PATH=""
fi

aw87xxx_start

# If existing firmware file exists then exit
if [ -e "${MOUNT_PATH}/${AW87XXX_PATH}/${AW87XXX_FILENAME}" ]; then
    echo "Existing firmware file installed, exiting."
    aw87xxx_exit 0
fi

# Attempt to download the firmware file into tempfs
curl -f -L -o "/tmp/${AW87XXX_FILENAME}" "${AW87XXX_URL}"

if [[ $? -eq 0 ]]; then
  # Calculate the MD5 hash of the downloaded file
  calculated_md5=$(md5sum "/tmp/${AW87XXX_FILENAME}" | cut -d ' ' -f 1)

  # Compare the expected and actual MD5 hashes
  if [[ "${AW87XXX_MD5}" == "${calculated_md5}" ]]; then
    # Move the confirmed valid firmware file to the correct path
    mv "/tmp/${AW87XXX_FILENAME}" "${MOUNT_PATH}/${AW87XXX_PATH}/${AW87XXX_FILENAME}"
    if [[ $? -eq 0 ]]; then
        aw87xxx_exit 0
    else
        echo "Download completed, and valid MD5, but could not write to ${MOUNT_PATH}/${AW87XXX_PATH}/${AW87XXX_FILENAME}"
        aw87xxx_exit 1
    fi
  else
    echo "Download completed, but MD5 hash does NOT match!"
    echo "Expected: ${AW87XXX_MD5}"
    echo "Actual:   ${calculated_md5}"
    aw87xxx_exit 1
  fi
else
  echo "Download failed!"
  aw87xxx_exit 1
fi