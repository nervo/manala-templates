#!/bin/sh

printf "[\033[36mManala\033[0m] \033[32mDebian - Nfs - Install client\033[0m\n"

export DEBIAN_FRONTEND=noninteractive

apt-get --quiet --verbose-versions --yes --no-install-recommends install nfs-common cachefilesd

# Enable cachefilesd
sed -i 's/#RUN=yes/RUN=yes/' /etc/default/cachefilesd
