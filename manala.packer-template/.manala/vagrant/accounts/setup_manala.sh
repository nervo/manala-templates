#!/bin/sh

printf "[\033[36mManala\033[0m] \033[32mVagrant - Accounts - Setup - Manala\033[0m\n"

DIR=$(cd $(dirname $0) && pwd)

mkdir --parents --mode 0700 /home/manala/.ssh
chown manala:manala /home/manala/.ssh

cat ${DIR}/../keys/vagrant.pub >> /home/manala/.ssh/authorized_keys
chmod 0600 /home/manala/.ssh/authorized_keys
chown manala:manala /home/manala/.ssh/authorized_keys
