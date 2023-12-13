#!/bin/bash

# Configure NAS
nas_ip="192.168.1.xxx"

# Directory to be copied
source_dir="/home/user/Documents"

# Temporary directory
temp_dir="/home/user/temp"

# Directory on the NAS
target_dir="/volume1/Backups/"

# Mountpoint on the PC (the directory must exist!)
mount_point="/home/user/mount"

# Variable for the Date
date=$(date +%Y-%m-%d)


if ping -c 1 $nas_ip &> /dev/null
then
  sleep 3
  echo
  echo "NAS reachable"
  echo
  echo "Create a temporary directory and copy files there"
  sudo mkdir $temp_dir$date
  sudo cp -r $source_dir $temp_dir$date
  echo "Directory has been created, and files have been copied"
  echo
  sudo mount -t nfs $nas_ip:$target_dir $mount_point
  echo "NAS has been mounted"
  echo
  echo "Files are being copied..."
  sudo cp -r $temp_dir$date $mount_point
  echo
  echo "Files have been successfully copied"
  echo
  sudo umount $mount_point
  echo "NAS has been unmounted"
  echo
  echo "Delete temporary directory"
  sudo rm -r $temp_dir$date
  echo
  echo "All done, script terminated"

else
  echo "NAS not reachable, files were not backed up!"
fi
