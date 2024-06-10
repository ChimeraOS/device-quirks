#!/bin/bash

# Detect if the install media is running or not
if [ ! -d /tmp/frzr_root ]; then
  MOUNT_PATH=""
fi

if [[ ! -z $(lspci | grep "MT7922") ]];
then
	if [ -d "${MOUNT_PATH}/etc/device-quirks/systemd-suspend-mods.conf" ] && [ ! -d "${DEVICE_QUIRKS_LOCATION}/etc/device-quirks/systemd-suspend-mods.conf" ]; then
		echo "Removing MT7921E quirk from device with MT7922."
		cp "${MOUNT_PATH}/etc/device-quirks/systemd-suspend-mods.conf" "${DEVICE_QUIRKS_LOCATION}/etc/device-quirks/systemd-suspend-mods.conf"
		sed -i 's/mt7921e//g' "${DEVICE_QUIRKS_LOCATION}/etc/device-quirks/systemd-suspend-mods.conf"
	elif [ -d "${DEVICE_QUIRKS_LOCATION}/etc/device-quirks/systemd-suspend-mods.conf" ]
		echo "Removing MT7921E quirk from device with MT7922."
		sed -i 's/mt7921e//g' "${DEVICE_QUIRKS_LOCATION}/etc/device-quirks/systemd-suspend-mods.conf"
	else
		echo "Could not copy '${MOUNT_PATH}/etc/device-quirks/systemd-suspend-mods.conf' into '${DEVICE_QUIRKS_LOCATION}/etc/device-quirks/systemd-suspend-mods.conf'"
	fi
fi
