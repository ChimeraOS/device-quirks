#!/bin/bash

if [ $(whoami) != 'root' ]; then
	echo "You must be root to run this script."
   exit 1
fi

$DQ_PATH/scripts/override_edid "eDP-1" "gpd_win4_edid.bin"

