#!/bin/bash

echo "Starting Network Device Configuration."

# Detect if the install media is running or not
MOUNT_PREFIX=""
if [[ -d /tmp/frzr_root ]]; then
  echo "Running as install."
  MOUNT_PREFIX=$MOUNT_PATH
else
  echo "Running as upgrade."
fi

# Remove MT7921E quirk for MT7922 devices.
if [[ ! -z $(lspci | grep "MT7922") ]]; then
  EDIT_FILE=${MOUNT_PREFIX}/etc/device-quirks/systemd-suspend-mods.conf
  if [[ ! -f ${EDIT_FILE} ]]; then
    echo "Unable to source ${EDIT_FILE}. MT7922 quirk NOT APPLIED. Exiting. "
  else
    echo "Removing MT7921E quirk from device with MT7922."
    sed -i 's/mt7921e//g' ${EDIT_FILE}
  fi
fi

echo "Network Device Configuration completed."
