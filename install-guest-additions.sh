#!/bin/bash

# Exit on error
set -e

# Create a temporary directory for downloading
TEMP_DIR=$(mktemp -d)
GUEST_ADDITIONS_ISO="VBoxGuestAdditions.iso"
INSTALL_DIR="/media"

# Update package list and install required packages
sudo apt update
sudo apt install -y build-essential dkms linux-headers-$(uname -r) wget

# Change to the temporary directory
cd "$TEMP_DIR"

# Download the latest Guest Additions
echo "Downloading the latest VirtualBox Guest Additions..."
wget -O "$GUEST_ADDITIONS_ISO" "https://download.virtualbox.org/virtualbox/LATEST.TXT"
LATEST_VERSION=$(cat LATEST.TXT)
wget "https://download.virtualbox.org/virtualbox/$LATEST_VERSION/VBoxGuestAdditions_$LATEST_VERSION.iso"

# Mount the downloaded ISO
sudo mount "$GUEST_ADDITIONS_ISO" "$INSTALL_DIR"

# Install Guest Additions
echo "Installing VirtualBox Guest Additions..."
sudo sh "$INSTALL_DIR/VBoxLinuxAdditions.run"

# Unmount and cleanup
sudo umount "$INSTALL_DIR"
echo "Cleaning up installation files..."
rm -rf "$TEMP_DIR"

# Installation complete
echo "VirtualBox Guest Additions installed successfully."

# Suggest reboot
echo "Please reboot your system for the changes to take effect."
