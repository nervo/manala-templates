#!/bin/sh

printf "[\033[36mManala\033[0m] \033[32mDebian - VirtualBox - Setup\033[0m\n"

# Get debian release (wheezy,jessie,stretch,...)
RELEASE=$(cat /etc/os-release | sed -n 's/.*VERSION="[0-9] (\(.*\))"/\1/p')

case ${RELEASE} in
wheezy|jessie)
  # Disable automatic udev rules for network interfaces
  # Source: http://6.ptmc.org/164/
  rm -f /etc/udev/rules.d/70-persistent-net.rules
  mkdir -p /etc/udev/rules.d/70-persistent-net.rules
  rm -f /lib/udev/rules.d/75-persistent-net-generator.rules
  ;;
esac

rm -rf /var/lib/dhcp/*

# Add a 2 sec delay to the interface up, to make the dhclient happy
echo "pre-up sleep 2" >> /etc/network/interfaces
