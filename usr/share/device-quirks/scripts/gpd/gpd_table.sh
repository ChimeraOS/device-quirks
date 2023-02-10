#/bin/bash

PRODUCT_NAME="$(cat /sys/devices/virtual/dmi/id/product_name)"
BOARD_NAME="$(cat /sys/devices/virtual/dmi/id/board_name)"

# Win3
BOARD_WIN3="G1618-03"

# WinMax2
BOARD_WM2="G1619-04"

# Win3
if [[ ":$BOARD_WIN3:" =~ "$BOARD_NAME" ]]; then
  $DQ_PATH/gpd/win3/win3.sh

# WinMax2
elif [[ ":$BOARD_WM2:" =~ "$BOARD_NAME" ]]; then
  $DQ_PATH/gpd/winmax2/winmax2.sh

# No Match
else
  echo "${PRODUCT_NAME} does not have a quirk configuration script. Exiting."
fi
