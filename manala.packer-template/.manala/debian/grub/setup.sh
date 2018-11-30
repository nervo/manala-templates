#!/bin/sh

printf "[\033[36mManala\033[0m] \033[32mDebian - Grub - Setup\033[0m\n"

# Remove 5 sec grub timeout to speed up booting
sed -i 's/GRUB_TIMEOUT=[0-9]\+/GRUB_TIMEOUT=0/' /etc/default/grub

update-grub
