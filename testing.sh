#!/bin/bash
#This is my first attempt at a testing framework, which will return all information/errors from a script
#This should only be run in a VM with a fresh installation of ubuntu

#define all variables needed for entire script
ROOT_UID=0     # Only users with $UID 0 have root privileges.
E_NOTROOT=87   # Non-root exit error.
UID=$(id -u)

# Run as root, of course.
if [ "$UID" -ne "$ROOT_UID" ]; then
  echo "Must be root to run this script."
  exit $E_NOTROOT
fi  

#define working directory for future use, add to variable $workdir
WORKDIR=$(pwd)

#define directory list for find to exclude
DIRLIST1=$($WORKDIR /var/log /mnt /lost+found /dev /var)

#Get package list and add to new file. Will be used for comparison later. Strip everything but package name

dpkg-query -W -f='${Package}\n' > $WORKDIR/packlist1.txt

#Get script to run via command line by using script to be tested as argument

if [ -n "$1" ];then
STARTT=$(date +%M)
file="$1"
/bin/bash "$file" | readline echo 1> stdout.txt 2> stderr.txt
ENDT=$(date +%M)
TIME1=$($ENDT - $STARTT)
else

echo "No File Or Script Specified. Please Try Again With 'script.sh'"

return

fi  



#find all files modified in the time of $TIME1 and print to new file for logging purposes
find -ignore_readdir_race -mmin $TIME1 -path $DIRLIST1 -prune -o -print > findtime.log

#get list of all packages with modified permissions
ls -la "$(<findtime.log)"
#run dpkg again to get 2nd list for comparison, again strip everything but package name

dpkg-query -W -f='${Package}\n' > $WORKDIR/packlist2.txt

#compare the two files and add anything that doesn't match to new file
grep -Fxvf packlist1.txt packlist2.txt > packexc.txt



#clean up, remove packages, remove all added files

read -p "Do you want to delete all files created during the running of $file? (Yes/No)" ANS1
  if [ "$ANS1" =  "yes" ]; then
                echo "Deleting Files... Please Wait"
                rm -rf "$(< findtime.txt)"
      elif [ "$ANS1" = "no" ]; then
           echo "Nothing Will Be Deleted. Good Day!"     
            else
                echo "I do not understand that value, please choose yes or no"
            fi
            
read -p "Do you want to remove all packages that were installed during the running of $file? (Yes/No)" ANS2
  if [ "$ANS2" = "yes" ]; then
                echo "Uninstalling/Removing Packages... Please Wait"
                apt-get -y remove "$(<packexc.txt)"
                apt-get -y purge "$(<packexc.txt)"
      elif [ "$ANS2" = "no" ]; then
           echo "Nothing Will Be Deleted. Good Day!"     
            else
                echo "I do not understand that value, please choose yes or no"
            fi

read -p "Do you want to initiate final cleanup? All log files will be moved to the backup directory? (Yes/No)" ANS3
if [ "$ANS3" =  "yes" ]; then
                echo "Moving Log Files... Please Wait"
                FOLD=$((mkdir "$WORKDIR/`date +%k%M%a`"))
                mv 'packlist1.txt packlist2.txt packexc.txt findtime.txt stdout.txt stderr.txt' '$WORKDIR/$FOLD'
      elif [ "$ANS3" = "no" ]; then
           echo "Nothing Will Be Moved, The Files Will Stay in $WORKDIR"     
            else
                echo "I do not understand that value, please choose yes or no"
            fi
