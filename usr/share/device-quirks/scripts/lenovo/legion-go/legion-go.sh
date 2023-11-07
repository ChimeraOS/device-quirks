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
mkdir -p ""$MAIN_USER_HOME"/.config/easyeffects/input"
mkdir -p ""$MAIN_USER_HOME"/.config/easyeffects/output"

# Define the target directories
output_dir=""$MAIN_USER_HOME"/.config/easyeffects/output"

# Create the directories if they don't exist
mkdir -p "$output_dir"

# Define the path of the script's current location (directory of this script)
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Copy the files to the target directories
cp "$script_dir/dolbers-atomsph.json" "$output_dir/dolbers-atomsph.json"
