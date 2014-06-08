#!/bin/bash

#This script will accept a list of files in single line format and output the MD5 #as well as check if said file exists on a remote target.

ROOT_UID=0 # Only users with $UID 0 have root privileges.
E_NOTROOT=87 # Non-root exit error.


# Run as root, of course.
if [ "$UID" -ne "$ROOT_UID" ]; then
	echo "Must be root to run this script."
	exit $E_NOTROOT
fi 

read -p "Please provide the path and name for your list." VARLIST

if [ -f $VARLIST ];
then 

	if [ -f 
	echo -n "$(<$VARLIST)"| md5sum

else
	echo "No Such Input File, please try again"
fi
