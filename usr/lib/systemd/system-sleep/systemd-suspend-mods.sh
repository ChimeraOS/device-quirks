#!/bin/bash
# This file runs during sleep/resume events. It will read the list of modules
# in /etc/device-quirks/systemd-suspend-mods.conf and rmmod them on suspend,
# insmod them on resume.

case $1 in
    pre)
        for mod in $(</etc/device-quirks/systemd-suspend-mods.conf); do
            rmmod $mod
        done
    ;;
    post)
        for mod in $(</etc/device-quirks/systemd-suspend-mods.conf); do
            insmod $mod
        done
    ;;
esac
