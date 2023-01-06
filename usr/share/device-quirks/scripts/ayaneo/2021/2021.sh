#!/bin/bash
if [ $(whoami) != 'root' ]; then
	echo "You must be root to run this script."
   exit 1
fi
 
# Uncomment to enable EDID override.
#./2021_dsdt.sh
