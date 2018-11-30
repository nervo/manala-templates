#!/bin/sh

printf "[\033[36mManala\033[0m] \033[32mDebian - Systemd - Install\033[0m\n"

export DEBIAN_FRONTEND=noninteractive

# See: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=751636
apt-get --quiet --verbose-versions --yes --no-install-recommends install systemd systemd-sysv dbus libpam-systemd
