#!/bin/bash

# Checking Credentials
if [ $(whoami) != 'root' ]; then
  echo "You must be root to run this script."
  exit 1
fi

export DQ_PATH=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source "$DQ_PATH/scripts/functions/chip_quirks.sh"
source "$DQ_PATH/scripts/functions/configuration.sh"
source "$DQ_PATH/scripts/functions/identify_devices.sh"
source "$DQ_PATH/scripts/functions/kernel_options.sh"
source "$DQ_PATH/scripts/functions/vendor_quirks.sh"

# Define usage function
function usage() {
    echo "Usage: $0 [ROOT_PATH]"
}

# Setting Working path for device-quicks
if [[ $# -eq 0 ]]; then
    if [ ! -d /tmp/frzr_root ]; then
        export DQ_WORKING_PATH=""
    fi
elif [[ $# -gt 1 ]]; then
    usage
    exit 1
else
    if [[ -d "$1" ]]; then
        export DQ_WORKING_PATH="$1"
    else
        echo "PATH: $1 is not a directory."
        usage
        exit 1
    fi
fi

echo "Processing Vendor quirk fixes:"
process_vendor_quirks "$(get_vendor)"
echo "Processing Chip quirk fixes:"
process_chip_quirks

echo "Done."
exit 0
