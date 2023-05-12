#!/bin/bash
if [ $(whoami) != 'root' ]; then
	echo "You must be root to run this script."
   exit 1
fi

$DQ_PATH/scripts/override_dsdt "ayaneo_2021.dsl"

