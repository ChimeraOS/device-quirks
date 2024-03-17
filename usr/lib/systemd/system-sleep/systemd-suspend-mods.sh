#!/bin/bash
# This file runs during sleep/resume events. It will read the list of modules
# in /etc/device-quirks/systemd-suspend-mods.conf and rmmod them on suspend,
# insmod them on resume.

MOD_LIST=$(grep -v ^\# /etc/device-quirks/systemd-suspend-mods.conf)

PRODUCT=$(cat /sys/devices/virtual/dmi/id/product_name)
ROG_LIST="ROG Ally RC71L_RC71L:ROG Ally RC71L"

if [[ ":$ROG_LIST:" =~ ":$PRODUCT:" ]]; then
    exit 0
fi

case $1 in
    pre)
        for mod in $MOD_LIST; do
            modprobe -r $mod
        done
    ;;
    post)
        for mod in $MOD_LIST; do
            modprobe $mod
        done
    ;;
esac
