#!/bin/bash

# Configure NAS
nas_ip="192.168.1.xxx"

# Directory to be copied
source_dir="/home/data"

# Temporary directory.
# It will be also the name of the copied folder on the NAS
# Name it wisely like /Backup- the dash is for the date that will be append to the folder name
temp_dir="/home/Backup-"

# Directory on the NAS
target_dir="/volume1/Backup"

# Mountpoint on the System (the directory must exist!)
mount_point="/mnt/mount"

# Variable for the Date
date=$(date +%Y-%m-%d)

check_packages(){
  if [ "$(dpkg -l | awk '/nfs-common/ {print }'|wc -l)" -ge 1 ]; then
    echo ""
  else
    echo "nfs-common package is missing. It will be installed automatically"
    apt-get install nfs-common -y >/dev/null 2>&1
  fi
}

create_directory(){
  echo "Create a temporary directory and copy files there"
  sudo mkdir $temp_dir$date
  sudo cp -r $source_dir $temp_dir$date
  echo "Directory has been created, and files have been copied"
}

copy_files(){
  echo "Files are being copied..."
  sudo cp -r $temp_dir$date $mount_point
  echo "Files have been successfully copied"
}

clean_up(){
  sudo umount $mount_point
  echo "NAS has been unmounted"
  echo "Delete temporary directory"
  sudo rm -r $temp_dir$date
  echo "All done, script terminated"
}

mount_nas(){
sudo mount -t nfs $nas_ip:$target_dir $mount_point
if mountpoint -q $mount_point; then
  echo "$mount_point is mounted"
	echo
	create_directory
	echo
	copy_files
	echo
	clean_up
    else
        echo "NAS could not be mounted. Abort script."
  fi
}

main(){
check_packages
echo "Check if NAS is reachable"
if ping -c 1 $nas_ip &> /dev/null
then
  sleep 3
  echo
  echo "NAS is reachable"
  echo
  mount_nas
else
  echo "NAS not reachable, files were not backed up!"
fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
