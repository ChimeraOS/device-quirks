#!/bin/bash

# Check for root
if [[ "$(whoami)" != 'root' ]]; then
  echo "You must be root to run this script."
  exit 1
fi

# Ensure DQ_PATH is set
if [[ -z "$DQ_PATH" ]]; then
  echo "DQ_PATH is not set. Please set it before running the script."
  exit 1
fi

# Detect if the install media is running or not
if [[ ! -d /tmp/frzr_root ]]; then
  echo "Running as upgrade."
  MOUNT_PATH=""
else
  echo "Running as install."
fi

# Define the path of the Rog Ally pipewire and wireplumber configs and folders
ALLY_PIPEWIRE_CONF="$DQ_PATH/scripts/asus/rog-ally/pipewire.conf.d/filter-chain.conf"
ALLY_WIREPLUMBER_DIR="$DQ_PATH/scripts/asus/rog-ally/wireplumber.conf.d/"
PIPEWIRE_DIR="${MOUNT_PATH}/etc/pipewire/pipewire.conf.d/"
WIREPLUMBER_DIR="${MOUNT_PATH}/etc/wireplumber/wireplumber.conf.d/"

# Check if the PipeWire config file exists
if [[ -f "${ALLY_PIPEWIRE_CONF}" ]]; then
  echo "Installing pipewire config from ${ALLY_PIPEWIRE_CONF} to ${PIPEWIRE_DIR}"
  if [[ ! -d "${PIPEWIRE_DIR}" ]]; then
    mkdir -p "${PIPEWIRE_DIR}"
  fi

  # Copy the PipeWire config to /etc
  cp "${ALLY_PIPEWIRE_CONF}" "${PIPEWIRE_DIR}"
  echo "PipeWire configuration successfully copied to ${PIPEWIRE_DIR}"
else
  echo "PipeWire config not found at ${ALLY_PIPEWIRE_CONF}"
  exit 1
fi

# Check if the WirePlumber directory exists
if [[ -d "${ALLY_WIREPLUMBER_DIR}" ]]; then
  echo "Installing wireplumber configs from ${ALLY_WIREPLUMBER_DIR} to ${WIREPLUMBER_DIR}"
  if [[ ! -d "${WIREPLUMBER_DIR}" ]]; then
    mkdir -p "${WIREPLUMBER_DIR}"
  fi

  # Copy the WirePlumber configs to /etc
  cp "${ALLY_WIREPLUMBER_DIR}"/* "${WIREPLUMBER_DIR}"
  echo "WirePlumber configurations successfully copied to ${WIREPLUMBER_DIR}"
else
  echo "WirePlumber configs not found at ${ALLY_WIREPLUMBER_DIR}"
  exit 1
fi
