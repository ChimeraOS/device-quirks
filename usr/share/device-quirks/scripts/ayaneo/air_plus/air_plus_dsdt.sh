#!/bin/bash
if [ $(whoami) != 'root' ]; then
	echo "You must be root to run this script."
   exit 1
fi

$DQ_PATH/override_dsdt "ayaneo_air_plus.dsl"
