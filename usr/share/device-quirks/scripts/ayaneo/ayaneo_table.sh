#/bin/bash

PRODUCT_NAME="$(cat /sys/devices/virtual/dmi/id/product_name)"
PRODUCT_LIST_AIR_1S="AIR 1S: AIR 1S Limited"
PRODUCT_LIST_AIR_PLUS="AIR Plus"
PRODUCT_LIST_2="AYANEO 2:AYANEO 2S:GEEK:GEEK 1S"
PRODUCT_LIST_FLIP="FLIP KB:FLIP DS"
PRODUCT_LIST_KUN="AYANEO KUN"

if [[ ":$PRODUCT_LIST_AIR_1S:" =~ ":$PRODUCT_NAME:" ]]; then
	echo "AYA NEO AIR 1S"
	$DQ_PATH/scripts/ayaneo/air_1s/air_1s.sh
elif [[ ":$PRODUCT_LIST_AIR_PLUS:" =~ ":$PRODUCT_NAME:" ]]; then
	echo "AYA NEO AIR PLUS"
	$DQ_PATH/scripts/ayaneo/air_plus/air_plus.sh
elif [[ ":$PRODUCT_LIST_2:" =~ ":$PRODUCT_NAME:" ]]; then
	echo "AYA NEO 2 SERIES"
	$DQ_PATH/scripts/ayaneo/2/2.sh
elif [[ ":$PRODUCT_LIST_FLIP:" =~ ":$PRODUCT_NAME:" ]]; then
	echo "AYA NEO FLIP"
	$DQ_PATH/scripts/ayaneo/flip/flip.sh
elif [[ ":$PRODUCT_LIST_KUN:" =~ ":$PRODUCT_NAME:" ]]; then
	echo "AYA NEO AIR PLUS"
	$DQ_PATH/scripts/ayaneo/kun/kun.sh
else
	echo "${PRODUCT_NAME} does not have a quirk configuration script. Exiting."
fi
