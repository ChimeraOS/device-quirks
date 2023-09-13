#!/bin/bash

# Systemd passes the DEVNAME as the first parameter to the script
eval $(udevadm info --query=env --export $1)

# Remove portion of DEVPATH after USB Root Hub ID
IFS='/'
read -ra DEVPATH_ARRAY <<< "$DEVPATH"
IFS=""

# Restore path string from array
hubpath=""
for ((i=1; i<6; i++));
do
   hubpath="${hubpath}/${DEVPATH_ARRAY[$i]}"
done

# Get full sysfs path for USB Root Hub
POWER_PATH="/sys$hubpath/power/wakeup"

source /etc/device-quirks.conf

if [[ $USB_WAKE_ENABLED == 1 ]]; then
  FROM_STATUS="disabled"
  TO_STATUS="enabled"
else
  FROM_STATUS="enabled"
  TO_STATUS="disabled"


# Check and set WOL enabled.
status=$(cat $POWER_PATH)
if [[ $status == $FROM_STATUS ]]; then
  echo $TO_STATUS > $POWER_PATH
fi

status=$(cat $POWER_PATH)
echo "$POWER_PATH wake on USB is set to $status"
exit 0
