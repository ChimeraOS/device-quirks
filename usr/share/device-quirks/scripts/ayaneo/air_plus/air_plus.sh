#!/bin/bash
if [ $(whoami) != 'root' ]; then
	echo "You must be root to run this script."
   exit 1
fi
 
# DSDT override.
$DQ_PATH/scripts/ayaneo/air_plus/air_plus_dsdt.sh
