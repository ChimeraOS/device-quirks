#!/bin/bash
if [ $(whoami) != 'root' ]; then
	echo "You must be root to run this script."
   exit 1
fi

# Switch to Open Sound Firmware
echo options snd-intel-dspcfg dsp_driver=1 > /etc/modprobe.d/alsa-base.conf

## Swap the goodix touchscreen driver
#sed -i 's/goodix-gpdwin3/goodix-ts/g' /etc/modprobe.d/goodixgpdw3.conf
#systemctl restart systemd-modules-load.service
#
#touchscreen rules?
