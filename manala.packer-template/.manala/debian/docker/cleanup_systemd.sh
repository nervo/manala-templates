#!/bin/sh

printf "[\033[36mManala\033[0m] \033[32mDebian - Docker - Cleanup - Systemd\033[0m\n"

# Get debian release (wheezy,jessie,stretch,...)
RELEASE=$(cat /etc/os-release | sed -n 's/.*VERSION="[0-9] (\(.*\))"/\1/p')

# Ensure "multi-user" (and not "graphical") is default target
systemctl set-default multi-user.target

systemctl mask \
  systemd-ask-password-wall.path \
  systemd-ask-password-console.path \
  systemd-logind.service

# Disable useless mount units
systemctl mask \
  dev-hugepages.mount \
  proc-sys-fs-binfmt_misc.automount \
  sys-fs-fuse-connections.mount \
  sys-kernel-debug.mount

# Disable local/remote file systems, swap & encrypted volumes target units
systemctl mask \
  local-fs.target \
  remote-fs.target \
  swap.target \
  cryptsetup.target

## Disable useless timers
systemctl mask \
  systemd-tmpfiles-clean.timer

# Disable getty (cause login issues in docker privileged mode)
systemctl mask getty.target

case ${RELEASE} in
stretch)
  # Disable useless mount units
  systemctl mask \
    sys-kernel-config.mount

  # Disable system time synchronization
  systemctl mask time-sync.target

  ## Disable useless timers
  systemctl mask \
    apt-daily-upgrade.timer \
    apt-daily.timer
  ;;
esac
