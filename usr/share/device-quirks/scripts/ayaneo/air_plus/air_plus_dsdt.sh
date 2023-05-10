#!/bin/bash

if [ $(whoami) != 'root' ]; then
	echo "You must be root to run this script."
   exit 1
fi

# Detect if the install media is running or not
if [ ! -d /tmp/frzr_root ]; then
	SUBVOL=""
	MOUNT_PATH=""
fi

ACPI_BUILD_DIR="/tmp/kernel/firmware/acpi"
DEPLOYMENT_DSDT_PATH="${SUBVOL}/usr/lib/firmware/dsdt/ayaneo_air_plus.dsl"
BOOTLOADER_CONFIG="${MOUNT_PATH}/boot/loader/entries/frzr.conf"
ACPI_OVERRIDE_DEVICE="ayaneo_air_plus_IRQ_fix"

if ! grep -q "${ACPI_OVERRIDE_DEVICE}" ${BOOTLOADER_CONFIG}; then

   if [ ! -d "${MOUNT_PATH}${ACPI_BUILD_DIR}" ]; then
      # create directory for acpi DSDT overrides
      mkdir -p "${MOUNT_PATH}${ACPI_BUILD_DIR}"
   fi
   
   cp ${DEPLOYMENT_DSDT_PATH} ${ACPI_BUILD_DIR}/dsdt.dsl
   echo "Compiling DSDT..."
   iasl -tc ${ACPI_BUILD_DIR}/dsdt.dsl
   cd ${MOUNT_PATH}/tmp/
   find kernel | cpio -H newc --create > ${ACPI_OVERRIDE_DEVICE}
   cp ${ACPI_OVERRIDE_DEVICE} ${MOUNT_PATH}/boot
   echo "Adding $ACPI_OVERRIDE_DEVICE to bootloader"
   sed -i "s|linux .*/vmlinuz-linux|&\ninitrd /${ACPI_OVERRIDE_DEVICE}|" ${BOOTLOADER_CONFIG}
   echo "Done!"
else
   echo "$ACPI_OVERRIDE_DEVICE already detected in bootloader, exiting"
fi


