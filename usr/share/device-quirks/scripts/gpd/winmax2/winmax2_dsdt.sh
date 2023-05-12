#!/bin/bash
if [ $(whoami) != 'root' ]; then
	echo "You must be root to run this script."
   exit 1
fi

$DQ_PATH/scriipts/override_dsdt "gpd_winmax2"
