#!/bin/bash
if [ $(whoami) != 'root' ]; then
  echo "You must be root to run this script."
  exit 1
fi

if [ -d /tmp/frzr_root ]; then
  source ${MOUNT_PATH}/etc/device-quirks/device-quirks.conf
else
  source /etc/device-quirks/device-quirks.conf
fi

# Create an equalizer for pipewire.
mkdir -p ~/.config/pipewire/pipewire.conf.d
cp $DQ_PATH/scripts/asus/ally/sink-eq6.conf ~/.config/pipewire/pipewire.conf.d/sink-eq6.conf