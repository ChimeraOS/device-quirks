#!/bin/bash
if [ $(whoami) != 'root' ]; then
	echo "You must be root to run this script."
	exit 1
fi

# Force 16 bit audio, format S16LE, sample rate 96000.
echo "Force S16LE 96000hz"
$DQ_PATH/scripts/override_bitrate
