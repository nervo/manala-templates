#!/bin/sh

printf "[\033[36mManala\033[0m] \033[32mDebian - Ansible - Install\033[0m\n"

export DEBIAN_FRONTEND=noninteractive

# Get debian release (wheezy,jessie,stretch,...)
RELEASE=$(cat /etc/os-release | sed -n 's/.*VERSION="[0-9] (\(.*\))"/\1/p')

case ${RELEASE} in
wheezy)
  apt-get --quiet --verbose-versions --yes --no-install-recommends --target-release wheezy-backports install python-cffi python-six
  ;;
esac

apt-get --quiet --verbose-versions --yes --no-install-recommends install ansible alt-galaxy
