#!/bin/bash
# Linux Driver for USB WiFi Adapters that are based on the RTL8812AU Chipset.
# https://github.com/morrownr/8812au-20210629
#
# Use this script when the computer has NO internet connection.
# Otherwise, use the ONLINE installer instead.

scratch=$(mktemp -d -t tmp.XXXXXXXXXX)
trap 'rm -rf "$scratch"' EXIT

set -e

DRIVER="88x2bu-20210702"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"


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

# install all dependencies using dkpg
echo "Installing dependencies"
mkdir -p "$scratch/pckgs"
tar -zxf "$DIR/dependencies.tar.gz" -C "$scratch/pckgs"
cd "$scratch/pckgs"
sudo dpkg -i -- *.deb

# extract driver archive
echo "Extracting driver in: $scratch/$DRIVER"
tar -zxf "$DIR/$DRIVER.tar.gz" -C "$scratch/$DRIVER"

# install driver
cd "$scratch/$DRIVER"
bash "./cmode-on.sh"
echo "Installing driver"
echo "WILL REBOOT IMMEDIATELY AFTER INSTALLATION FINISHES"
sleep 3
echo "NN" | sudo bash "./install-driver.sh"

rm -rf "$scratch"
reboot
