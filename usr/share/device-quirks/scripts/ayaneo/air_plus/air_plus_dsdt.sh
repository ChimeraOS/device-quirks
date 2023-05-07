#!/bin/bash

if [ $(whoami) != 'root' ]; then
	echo "You must be root to run this script."
   exit 1
fi

if ! grep -q 'acpi_override' /boot/loader/entries/frzr.conf

   if [ ! -d /etc/kernel/firmware/acpi/ ]; then
      # create directory for acpi DSDT overrides
      mkdir -p /etc/kernel/firmware/acpi/
   fi
   
   cp /usr/lib/firmware/dsdt/ayaneo_air_plus.dsl /etc/kernel/firmware/acpi/dsdt.dsl
   iasl -tc /etc/kernel/firmware/acpi/dsdt.dsl
   cd /etc/
   find kernel | cpio -H newc --create > acpi_override
   cp acpi_override /boot
   sed -i 's#linux /vmlinuz-linux#&\ninitrd /acpi_override#' /boot/loader/entries/frzr.conf
fi


