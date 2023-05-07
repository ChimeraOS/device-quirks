#!/bin/bash

if [ $(whoami) != 'root' ]; then
	echo "You must be root to run this script."
   exit 1
fi

if ! grep -q 'acpi_override' /boot/loader/entries/frzr.conf; then

   if [ ! -d /etc/kernel/firmware/acpi/ ]; then
      # create directory for acpi DSDT overrides
      mkdir -p /etc/kernel/firmware/acpi/
   fi
   
   echo "Copying ACPI DSL to /etc/kernel/firmware/acpi/"
   cp /usr/lib/firmware/dsdt/ayaneo_air_plus.dsl /etc/kernel/firmware/acpi/dsdt.dsl
   echo "Compiling DSDT..."
   iasl -tc /etc/kernel/firmware/acpi/dsdt.dsl
   echo "Changing directory to /etc"
   cd /etc/
   echo "Find kernel path and create acpi_override"
   find kernel | cpio -H newc --create > acpi_override
   echo "Copy acpi_override to /boot"
   cp acpi_override /boot
   echo "Add acpi_override to bootloader"
   sed -i 's#linux /vmlinuz-linux#&\ninitrd /acpi_override#' /boot/loader/entries/frzr.conf
   echo "Done!"
else
   echo "acpi_override already detected in bootloader, exiting"
fi


