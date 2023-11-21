#!/bin/bash

# Check for root
if [ "$(whoami)" != 'root' ]; then
  echo "You must be root to run this script."
  exit 1
fi

# Define the path of the ally.sh script and pipewire folder
ally_dir="$DQ_PATH/scripts/asus/ally"
pipewire_dir="$ally_dir/pipewire"  # Adjust this path as necessary

# Check if the PipeWire directory exists
if [ -d "$pipewire_dir" ]; then
    # Copy the PipeWire folder to /etc
    cp -r "$pipewire_dir" /etc/
    echo "PipeWire configuration successfully copied to /etc."
else
    echo "PipeWire directory not found in $pipewire_dir."
    exit 1
fi
