#!/usr/bin/env bash

# only do all of this once
if [ ! -f /swapfile ]; then
  # create a 1GB swap space
  fallocate -l 1G /swapfile
  ls -lh /swapfile

  # secure the swapfile
  chown root:root /swapfile
  chmod 0600 /swapfile
  ls -lh /swapfile

  # turn the swapfile on
  mkswap /swapfile
  swapon /swapfile

  # verify the swapfile
  swapon -s
  grep -i --color swap /proc/meminfo

  # add it to the fstab
  echo "\n/swapfile none            swap    sw              0       0" >> /etc/fstab
fi
