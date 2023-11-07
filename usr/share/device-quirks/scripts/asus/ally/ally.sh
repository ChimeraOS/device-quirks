#!/bin/bash

# Find the main user's home directory under /home/
# Assumes the main user has the lowest UID greater than 1000
MAIN_USER_HOME=$(awk -F':' '{ if ($3 >= 1000 && $6 ~ /^\/home\//) print $0 }' /etc/passwd | sort -t: -k3,3n | head -n 1 | cut -d: -f6)

# Replace the \$HOME with the detected main user's home directory
# Create the base directory and subdirectories for easyeffects
mkdir -p ""$MAIN_USER_HOME"/.config/easyeffects"
mkdir -p ""$MAIN_USER_HOME"/.config/easyeffects/autoload"
mkdir -p ""$MAIN_USER_HOME"/.config/easyeffects/autoload/input"
mkdir -p ""$MAIN_USER_HOME"/.config/easyeffects/autoload/output"
mkdir -p ""$MAIN_USER_HOME"/.config/easyeffects/irs"
mkdir -p ""$MAIN_USER_HOME"/.config/easyeffects/input"
mkdir -p ""$MAIN_USER_HOME"/.config/easyeffects/output"

# Define the target directories
output_dir=""$MAIN_USER_HOME"/.config/easyeffects/output"
autoload_output_dir=""$MAIN_USER_HOME"/.config/easyeffects/autoload/output"
irs_dir=""$MAIN_USER_HOME"/.config/easyeffects/irs"

# Define the path of the script's current location (directory of this script)
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Copy the necessary files to the target directories
cp "$script_dir/alsa_output.pci-0000_c2_00.6.analog-stereo:analog-output-speaker.json" "$autoload_output_dir/alsa_output.pci-0000_c2_00.6.analog-stereo:analog-output-speaker.json"
cp "$script_dir/game.irs" "$irs_dir/game.irs"

# Generate the dolbers-atomsph.json file with the correct kernel-path
dolbers_atomsph_path="$output_dir/dolbers-atomsph.json"
echo '{
    "output": {
        "blocklist": [],
        "convolver#0": {
            "autogain": true,
            "bypass": false,
            "input-gain": 0.0,
            "ir-width": 100,
            "kernel-path": "'"${irs_dir}/game.irs"'"',
            "output-gain": 0.0
        },
        "plugins_order": [
            "convolver#0"
        ]
    }
}' > "$dolbers_atomsph_path"
