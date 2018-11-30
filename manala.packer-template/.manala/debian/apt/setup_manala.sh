#!/bin/sh

printf "[\033[36mManala\033[0m] \033[32mDebian - Apt - Setup - Manala\033[0m\n"

# Get debian release (wheezy,jessie,stretch,...)
RELEASE=$(cat /etc/os-release | sed -n 's/.*VERSION="[0-9] (\(.*\))"/\1/p')

DIR=$(cd $(dirname $0) && pwd)

eval "cat > /etc/apt/sources.list.d/debian_manala_io.list << EOF
deb [arch=amd64] http://debian.manala.io ${RELEASE} main
EOF"

apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 1394DEA3

apt-get --quiet update
