#/bin/bash

PRODUCT_NAME="$(cat /sys/devices/virtual/dmi/id/product_name)"
BOARD_NAME="$(cat /sys/devices/virtual/dmi/id/board_name)"
CPU_NAME="$(cat /proc/cpuinfo | awk 'NR==5 {print $4$5$6$7}')"

if [[ "83E1" == "$PRODUCT_NAME" ]] && [[ "LNVNB161216" == "$BOARD_NAME" ]] && [[ "AMDRyzenZ1Extreme" == "$CPU_NAME" ]]; then
    echo "Legion Go detected"
    $DQ_PATH/scripts/lenovo/legion/legion.sh

else
    echo "${PRODUCT_NAME} does not have a quirk configuration script. Exiting."
fi

# Create the base directory and subdirectories for easyeffects
mkdir -p "$HOME/.config/easyeffects"
mkdir -p "$HOME/.config/easyeffects/autoload"
mkdir -p "$HOME/.config/easyeffects/autoload/input"
mkdir -p "$HOME/.config/easyeffects/autoload/output"
mkdir -p "$HOME/.config/easyeffects/input"
mkdir -p "$HOME/.config/easyeffects/output"

# Define the target directories
output_dir="$HOME/.config/easyeffects/output"
autoload_output_dir="$HOME/.config/easyeffects/autoload/output"

# Create the directories if they don't exist
mkdir -p "$output_dir"
mkdir -p "$autoload_output_dir"

# Define the path of the script's current location (directory of this script)
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Copy the files to the target directories
cp "$script_dir/gamemode.json" "$output_dir/gamemode.json"
cp "$script_dir/alsa_output.pci-0000_c2_00.6.analog-stereoanalog-output-speaker.json" "$autoload_output_dir/alsa_output.pci-0000_c2_00.6.analog-stereoanalog-output-speaker.json"
