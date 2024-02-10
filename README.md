# Backup script

The script copies the files via NFS. Therefore, you must ensure that your device has an NFS share on the NAS.
You need to specify the directory paths correctly in the script and enter the correct IP address of the NAS.

Disclaimer
-
It is not recommended to execute this script inside a container due to the fact that containers are not made for mounting NFS-shares.
I tested it in a LXC in Proxmox and it didn´t work.
