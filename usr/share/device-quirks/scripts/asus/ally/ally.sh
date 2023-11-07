#!/bin/bash
if [ $(whoami) != 'root' ]; then
  echo "You must be root to run this script."
  exit 1
fi

# Create the base directory and subdirectories for easyeffects
mkdir -p "$HOME/.config/easyeffects"
mkdir -p "$HOME/.config/easyeffects/autoload"
mkdir -p "$HOME/.config/easyeffects/autoload/input"
mkdir -p "$HOME/.config/easyeffects/autoload/output"
mkdir -p "$HOME/.config/easyeffects/irs"
mkdir -p "$HOME/.config/easyeffects/input"
mkdir -p "$HOME/.config/easyeffects/output"

# Define the target directories
output_dir="$HOME/.config/easyeffects/output"
autoload_output_dir="$HOME/.config/easyeffects/autoload/output"
irs_dir="$HOME/.config/easyeffects/irs"

# Define the path of the script's current location (directory of this script)
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Copy the necessary files to the target directories
cp "$script_dir/alsa_output.pci-0000_c2_00.6.analog-stereoanalog-output-speaker.json" "$autoload_output_dir/alsa_output.pci-0000_c2_00.6.analog-stereoanalog-output-speaker.json"
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
