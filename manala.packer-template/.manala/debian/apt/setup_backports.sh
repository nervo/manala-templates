#!/bin/sh

printf "[\033[36mManala\033[0m] \033[32mDebian - Apt - Setup - Manala\033[0m\n"

# Get debian release (wheezy,jessie,stretch,...)
RELEASE=$(cat /etc/os-release | sed -n 's/.*VERSION="[0-9] (\(.*\))"/\1/p')

DIR=$(cd $(dirname $0) && pwd)

eval "cat > /etc/apt/sources.list.d/deb_debian_org_debian.list << EOF
deb http://deb.debian.org/debian ${RELEASE}-backports main
EOF"

apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 1394DEA3

apt-get --quiet update
