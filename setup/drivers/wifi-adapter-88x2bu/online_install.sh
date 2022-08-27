#!/bin/bash
# Linux Driver for USB WiFi Adapters that are based on the RTL8812AU Chipset.
# https://github.com/morrownr/8812au-20210629
#
# Use this script when the computer has an internet connection.
# Otherwise, use the OFFLINE installer instead.

scratch=$(mktemp -d -t tmp.XXXXXXXXXX)
trap 'rm -rf "$scratch"' EXIT

set -e

REPO_OWNER="morrownr"
DRIVER="88x2bu-20210702"


# obtain sudo permissions beforehand
sudo echo "" > /dev/null

# warn about auto reboot
echo "Computer will reboot automatically after installation."
read -p "? Continue? (Y/n) " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "Abort." >&2
  exit 1
fi

# install packages
echo "Upgrading and installing packages"
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y dkms git build-essential

# clone repository
if [ ! -d "$scratch/$DRIVER" ]
then
  echo "Cloning repo in: $scratch/$DRIVER"
  git clone "https://github.com/$REPO_OWNER/$DRIVER.git" "$scratch/$DRIVER" \
            --recurse-submodules -j"$(nproc)"
else
  echo "Pulling latest changes."
  if ! git -C "$scratch/$DRIVER" pull; then
    printf "%s\n%s\n" "$scratch/$DRIVER not empty and not a repo." "Abort." >&2
    exit 1
  fi
fi

# install driver and reboot
cd "$scratch/$DRIVER"
bash ./cmode-on.sh
echo "Installing driver"
echo "WILL REBOOT IMMEDIATELY AFTER INSTALLATION FINISHES"
sleep 3
echo "NN" | sudo bash ./install-driver.sh

rm -rf "$scratch"
reboot
