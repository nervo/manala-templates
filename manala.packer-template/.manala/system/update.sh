#!/bin/sh

printf "[\033[36mManala\033[0m] \033[32mSystem - Update\033[0m\n"

export DEBIAN_FRONTEND=noninteractive

apt-get --quiet update

apt-get --quiet --verbose-versions --yes --option Dpkg::Options::="--force-confold" --option Dpkg::Options::="--force-confdef" dist-upgrade
