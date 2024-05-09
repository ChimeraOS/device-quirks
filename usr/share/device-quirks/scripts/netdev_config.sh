#!/bin/bash

# Detect if the install media is running or not
if [ ! -d /tmp/frzr_root ]; then
  MOUNT_PATH=""
fi

if [[ ! -z $(lspci | grep "MT7922") ]];
then
	echo "Removing MT7921E quirk from device with MT7922."
	sed -i 's/mt7921e//g' ${MOUNT_PATH}/etc/device-quirks/systemd-suspend-mods.conf
fi
