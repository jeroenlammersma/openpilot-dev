#!/bin/bash

if [ -n "$WSL_ENV" ]; then
  yellowprint "WSL detected..."
  cyanprint "Skipping task."
  sleep 1
  return
fi

if [ -z "$OPENPILOT_SETUP" ]; then
  sudo apt-get update > /dev/null
  sudo apt-get upgrade -y > /dev/null
fi

# add the repository for ubuntu-drivers
if ! command -v "ubuntu-drivers" > /dev/null 2>&1; then
  echo "Installing ubuntu-drivers-common..."
  sudo apt-get install -y ubuntu-drivers-common
fi

# get current driver
read -r label version <<< "$(find /usr/lib/modules -name nvidia.ko -exec modinfo {} \; | grep ^version)"
current=$(cut -d '.' -f 1 <<< "$version")
printf "%s\t\t%s\n" "Current driver:" "$(whiteboldprint "nvidia-driver-$current")"

# get recommended driver
recommended=$(sudo ubuntu-drivers devices | grep 'recommended' | tr -d -c 0-9) || :
printf "%s\t%s\n" "Recommended driver:" "$(whiteboldprint "nvidia-driver-$recommended")"
sleep 1

if [ "$current" == "$recommended" ] && [ -z "$TEST_MODE" ]; then
  echo "Recommended driver already installed."
  sleep 1
  echo "Skipping task."
  sleep 1
  return
fi

cyanprint "Newer recommended driver version available."
sleep 1
printf "\n%s\n" "Updating driver..."
sleep 1

# delete all from nvidia
sudo apt-get purge -y 'nvidia*' > /dev/null

# install driver
sudo apt-get install -y "libnvidia-gl-$recommended" "nvidia-driver-$recommended"


# blacklist the Nouveau driver so it doesn't initialize:
sudo bash -c "echo blacklist nouveau > /etc/modprobe.d/blacklist-nvidia-nouveau.conf"
sudo bash -c "echo options nouveau modeset=0 >> /etc/modprobe.d/blacklist-nvidia-nouveau.conf"
sleep 1
cat /etc/modprobe.d/blacklist-nvidia-nouveau.conf
echo

# update the kernel to reflect changes:
echo "Updating initramfs..."
sleep 1
sudo update-initramfs -u

if [ -z "$OPENPILOT_SETUP" ]; then
  echo
  echo "Script completed - NVIDIA drivers installed"
  echo "please restart your machine to initialize correctly"
  read -p "? Reboot now? (recommended) (Y/n) " -n 1 -r
  echo ""
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "REBOOTING NOW"
    sleep 1
    reboot
  fi
fi

DID_NVIDIA_INSTALL=1
