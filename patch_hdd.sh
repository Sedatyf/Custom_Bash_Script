#!/bin/bash

#List all the drives on the computer and save the output in df_output
df > /home/sedatyf/Documents/df_output

#Search for the word HDD in df_output. Then take the first word. Then delete all except the first word
HDD_PATH=$(grep 'HDD' /home/sedatyf/Documents/df_output | head -n1 | sed -e 's/\s.*$//')
echo "The HDD drive is ${HDD_PATH}"

umount -l ${HDD_PATH}
ntfsfix ${HDD_PATH}
mount -t ntfs-3g ${HDD_PATH} /hdd
