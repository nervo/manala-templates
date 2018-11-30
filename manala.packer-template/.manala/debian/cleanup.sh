#!/bin/sh

printf "[\033[36mManala\033[0m] \033[32mDebian - Cleanup\033[0m\n"

# Remove specific Linux headers, such as linux-headers-3.11.0-15 but
# keeps the current kernel and does not touch the virtual packages,
# e.g. 'linux-headers-amd64', etc.
dpkg --list \
  | awk '{ print $2 }' \
  | grep 'linux-headers-[2345].*' \
  | grep -v `uname -r | sed -e 's/-[^-]*$//'` \
  | xargs apt-get --yes purge;

# Remove specific Linux kernels, such as linux-image-3.11.0-15 but
# keeps the current kernel and does not touch the virtual packages,
# e.g. 'linux-image-amd64', etc.
dpkg --list \
  | awk '{ print $2 }' \
  | grep 'linux-image-[2345].*' \
  | grep -v `uname -r | sed -e 's/-[^-]*$//'` \
  | xargs apt-get --yes purge;

# Delete Linux source
dpkg --list \
  | awk '{ print $2 }' \
  | grep linux-source \
  | xargs apt-get --yes purge;

# Delete X11 libraries
apt-get --yes purge libx11-data xauth libxmuu1 libxcb1 libx11-6 libxext6

# Delete obsolete networking
apt-get --yes purge ppp pppconfig pppoeconf

# Delete oddities
apt-get --yes purge popularity-contest

apt-get --yes --purge autoremove
apt-get --yes clean

rm --force --recursive /var/lib/apt/lists/*

# Delete any logs that have built up during the install
find /var/log/ \
  -name *.log \
  -exec rm --force {} \;

# Delete any non relevant user's dotfiles
find /root /home/ \
  \( -name '.bash_history' -o -name '.zsh_history' -o -name '.zcompdump-*' -o -name '.ansible' \) \
  -prune -exec rm --force --recursive {} \;
