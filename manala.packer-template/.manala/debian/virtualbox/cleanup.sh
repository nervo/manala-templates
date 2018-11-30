#!/bin/sh

printf "[\033[36mManala\033[0m] \033[32mDebian - VirtualBox - Cleanup\033[0m\n"

# Whiteout root
count=$(df --sync -kP / | tail -n1  | awk -F ' ' '{print $4}')
count=$(($count-1))
dd if=/dev/zero of=/tmp/whitespace bs=1M count=$count || echo "dd exit code $? is suppressed";
rm /tmp/whitespace

# Whiteout the swap partition to reduce box size
# Swap is disabled till reboot
swapuuid=$(/sbin/blkid -o value -l -s UUID -t TYPE=swap)
swappart=$(readlink -f /dev/disk/by-uuid/"$swapuuid")
/sbin/swapoff "$swappart"
dd if=/dev/zero of="$swappart" bs=1M || echo "dd exit code $? is suppressed"
/sbin/mkswap -U "$swapuuid" "$swappart"

# Block until the empty file has been removed, otherwise, Packer
# will try to kill the box while the disk is still full and that's bad
sync;
