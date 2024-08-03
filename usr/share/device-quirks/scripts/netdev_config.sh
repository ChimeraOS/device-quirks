#!/bin/bash

echo "Starting Network Device Configuration."

# Detect if the install media is running or not
if [[ ! -d /tmp/frzr_root ]]; then
  echo "Running as upgrade."
  MOUNT_PATH=""
else
  echo "Running as install."
fi

# Remove MT7921E quirk for MT7922 devices.
if [[ ! -z $(lspci | grep "MT7922") ]]; then
  EDIT_FILE=${MOUNT_PATH}/etc/device-quirks/systemd-suspend-mods.conf
  if [[ ! -f ${EDIT_FILE} ]]; then
    echo "Unable to source ${EDIT_FILE}. Creating empty file."
    DIR_NAME=$(dirname ${EDIT_FILE})
    if [[ ! -d ${DIR_NAME} ]]; then
      echo "Creating device_quirks location."
      mkdir -p ${DIR_NAME}
    fi
    # Create device-quirks default config
    echo "Creating empty default config"
    cat >${EDIT_FILE} <<EOL
# Line separated list of modules to unload/reload at suspend/resume.
EOL
  else
    echo "Removing MT7921E quirk from device with MT7922."
    sed -i 's/mt7921e//g' ${EDIT_FILE}
  fi
else
  echo "Nothing to do."
fi

echo "Network Device Configuration completed."
