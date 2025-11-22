#!/bin/bash
set -e

TEMP_DIR=$(mktemp -d)
GUEST_ADDITIONS_ISO="$TEMP_DIR/VBoxGuestAdditions.iso"
INSTALL_DIR="/media/VBoxGuestAdditions"

sudo apt update
sudo apt install -y build-essential dkms linux-headers-$(uname -r) wget

cd "$TEMP_DIR"

echo "Fetching latest VirtualBox version..."
wget -q -O LATEST.TXT "https://download.virtualbox.org/virtualbox/LATEST.TXT"
LATEST_VERSION=$(cat LATEST.TXT)

echo "Downloading VBoxGuestAdditions $LATEST_VERSION..."
wget -q -O "$GUEST_ADDITIONS_ISO" "https://download.virtualbox.org/virtualbox/$LATEST_VERSION/VBoxGuestAdditions_${LATEST_VERSION}.iso"

sudo mkdir -p "$INSTALL_DIR"
sudo mount -o loop "$GUEST_ADDITIONS_ISO" "$INSTALL_DIR"

echo "Installing VirtualBox Guest Additions..."
sudo sh "$INSTALL_DIR/VBoxLinuxAdditions.run" || sudo "$INSTALL_DIR/VBoxLinuxAdditions.run" --nox11

sudo umount "$INSTALL_DIR"
sudo rmdir "$INSTALL_DIR"

cd /
rm -rf "$TEMP_DIR"

echo "VirtualBox Guest Additions installed successfully."
echo "Please reboot your system for the changes to take effect."
