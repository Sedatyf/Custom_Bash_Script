#!/bin/bash

#List all the drives on the computer and save the output in df_output
df > /home/sedatyf/Documents/df_output

#Search for the word HDD in df_output.
IS_MOUNTED_CAJA=$(grep '/media/sedatyf/HDD' /home/sedatyf/Documents/df_output)
IS_MOUNTED_SCRIPT=$(grep '/hdd' /home/sedatyf/Documents/df_output)

#if IS_MOUNTED is null then
if [ -z "$IS_MOUNTED_CAJA" ] && [ -z "$IS_MOUNTED_SCRIPT" ]
then
	echo "HDD Disk is not mounted"
	echo "Listing all disk with fdisk"
	#List all disk on the computer, then search for 1.8T and delete all except the first word
	fdisk -l > /home/sedatyf/Documents/fdisk_output
	HDD_PATH=$(grep '1.8T' /home/sedatyf/Documents/fdisk_output | head -n1 | sed -e 's/\s.*$//')
	echo "HDD Disk is on $HDD_PATH"
	echo "Mounting HDD Disk"
	ntfsfix ${HDD_PATH}
	mount -t ntfs-3g ${HDD_PATH} /hdd
else
	echo "HDD Disk is mounted"
	#Search for the word HDD in df_output. Then take the first word. Then delete all except the first word
	HDD_PATH_CAJA=$(grep 'HDD' /home/sedatyf/Documents/df_output | head -n1 | sed -e 's/\s.*$//')
	HDD_PATH_SCRIPT=$(grep '/hdd' /home/sedatyf/Documents/df_output | head -n1 | sed -e 's/\s.*$//')
	
	if [[ $HDD_PATH_CAJA == *"/dev/"* ]]
	then
		echo "The HDD drive is ${HDD_PATH_CAJA}"
		echo "Unmounting Disk"
		umount -l ${HDD_PATH_CAJA}
		ntfsfix ${HDD_PATH_CAJA}
		mount -t ntfs-3g ${HDD_PATH_CAJA} /hdd
	else
		echo "The HDD drive is ${HDD_PATH_SCRIPT}"
		echo ${HDD_PATH_SCRIPT}
		echo "Unmounting Disk"
		umount -l ${HDD_PATH_SCRIPT}
		ntfsfix ${HDD_PATH_SCRIPT}
		mount -t ntfs-3g ${HDD_PATH_SCRIPT} /hdd
	fi
fi
