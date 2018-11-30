#!/bin/sh

printf "[\033[36mManala\033[0m] \033[32mDebian - Docker - Cleanup\033[0m\n"

# Remove apt docker related configurations
rm -rf /etc/apt/apt.conf.d/docker-*

# Remove init scripts prevention
rm -rf /usr/sbin/policy-rc.d

# Remove upstart scripts prevention
# See: https://github.com/tianon/docker-brew-debian/issues/64
dpkg-divert --local --rename --remove /sbin/initctl
rm -rf /sbin/initctl
