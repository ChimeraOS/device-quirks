#!/bin/bash

if [ $(whoami) != 'root' ]; then
	echo "You must be root to run this script."
   exit 1
fi

# If the script is being ran directly we will need to set the paths
if [ -z "${MOUNT_PATH}" ]; then
	if [ -d /tmp/frzr_root ]; then
		MOUNT_PATH=/tmp/frzr_root/
		echo "It appears as though we are installing from the install media"
	elif [ -d /frzr_root ]; then
		MOUNT_PATH=/frzr_root/
		echo "It appears as though we are installing from a deployed system"
	else
		MOUNT_PATH=/
		echo "It appears as though this script is being ran from a non-frzr based system"
	fi
fi

ACPI_DIR="etc/kernel/firmware/acpi/"
DEPLOYMENT_DSDT_PATH="${MOUNT_PATH}/usr/lib/firmware/dsdt/ayaneo_air_plus.dsl"
BOOTLOADER_CONFIG="${MOUNT_PATH}/boot/loader/entries/frzr.conf"
ACPI_OVERRIDE_DEVICE="ayaneo_air_plus_IRQ_fix"

if ! grep -q "${ACPI_OVERRIDE_DEVICE}" ${BOOTLOADER_CONFIG}; then

   if [ ! -d "${MOUNT_PATH}${ACPI_DIR}" ]; then
      # create directory for acpi DSDT overrides
      mkdir -p "${MOUNT_PATH}${ACPI_DIR}"
   fi
   
   echo "Copying ACPI DSL to /etc/kernel/firmware/acpi/"
   cp ${DEPLOYMENT_DSDT_PATH} ${MOUNT_PATH} ${ACPI_DIR}/dsdt.dsl
   echo "Compiling DSDT..."
   iasl -tc ${ACPI_DIR}/dsdt.dsl
   echo "Changing directory to /etc"
   cd ${MOUNT_PATH}/etc/
   echo "Find kernel path and create acpi_override"
   find kernel | cpio -H newc --create > ${ACPI_OVERRIDE_DEVICE}
   echo "Copy acpi_override to /boot"
   cp ${ACPI_OVERRIDE_DEVICE} /boot
   echo "Add acpi_override to bootloader"
   sed -i "s|linux .*/vmlinuz-linux|&\ninitrd /${ACPI_OVERRIDE_DEVICE}|" ${BOOTLOADER_CONFIG}
   echo "Done!"
else
   echo "acpi_override already detected in bootloader, exiting"
fi


