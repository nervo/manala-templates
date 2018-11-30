#!/bin/sh

printf "[\033[36mManala\033[0m] \033[32mDebian - VirtualBox - Install additions\033[0m\n"

export DEBIAN_FRONTEND=noninteractive

# Remove standard virtualbox packages
apt-get --yes purge --auto-remove virtualbox-\*

# Install dependencies
apt-get --quiet --verbose-versions --yes --no-install-recommends install bzip2 dkms linux-headers-amd64

# Install the virtualbox guest additions
mkdir -p /mnt/VBoxGuestAdditions
mount --options loop ~/VBoxGuestAdditions.iso /mnt/VBoxGuestAdditions
sh /mnt/VBoxGuestAdditions/VBoxLinuxAdditions.run
umount /mnt/VBoxGuestAdditions
rm -Rf /mnt/VBoxGuestAdditions
rm -f VBoxGuestAdditions.iso
