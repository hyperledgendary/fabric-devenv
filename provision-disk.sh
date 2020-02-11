#!/usr/bin/env bash

set -o errexit
set -o pipefail

if ! grep -Fxq "/dev/vagrant/home /home ext4 defaults 0 0" /etc/fstab; then
  # Add some disk space for opt and home directories
  pvcreate /dev/sdc
  vgcreate vagrant /dev/sdc
  lvcreate -L 5G -n opt vagrant
  lvcreate -L 5G -n home vagrant
  mkfs -t ext4 /dev/vagrant/opt
  mkfs -t ext4 /dev/vagrant/home

  # Preserve home directory contents
  mount /dev/vagrant/home /mnt
  cp -aR /home/* /mnt
  umount /mnt

  # Mount the new volumes
  echo '/dev/vagrant/opt /opt ext4 defaults 0 0' >> /etc/fstab
  echo '/dev/vagrant/home /home ext4 defaults 0 0' >> /etc/fstab
  mount -a
fi
