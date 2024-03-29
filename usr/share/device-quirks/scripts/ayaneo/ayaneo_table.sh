#/bin/bash

PRODUCT_NAME="$(cat /sys/devices/virtual/dmi/id/product_name)"
PRODUCT_LIST_AIR_PLUS="AIR Plus"
PRODUCT_LIST_2="AYANEO 2:GEEK"

if [[ ":$PRODUCT_LIST_AIR_PLUS:" =~ ":$PRODUCT_NAME:" ]]; then
	echo "AYA NEO AIR PLUS"
	$DQ_PATH/scripts/ayaneo/air_plus/air_plus.sh
elif [[ ":$PRODUCT_LIST_2:" =~ ":$PRODUCT_NAME:" ]]; then
	echo "AYA NEO 2 SERIES"
	$DQ_PATH/scripts/ayaneo/2/2.sh
else
	echo "${PRODUCT_NAME} does not have a quirk configuration script. Exiting."
fi
