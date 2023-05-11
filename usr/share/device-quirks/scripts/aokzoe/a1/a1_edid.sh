#!/bin/bash
if [ $(whoami) != 'root' ]; then
	echo "You must be root to run this script."
   exit 1
fi

$DQ_PATH/override_edid "eDP-1" "aokzoe_a1ar07_edid.bin"
