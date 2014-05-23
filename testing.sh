#!/bin/bash
#This is my first attempt at a testing framework, which will return all information/errors from a script to log files
#the logs files should be self explainitory. You can use this script to troubleshoot other scripts easier (hopefully).
#This should only be run in a VM with a fresh installation of ubuntu
#Written by Theory5, with help from April and Ziggy. Use as you will, just give me some credit!
#define all variables needed for entire script
ROOT_UID=0     # Only users with $UID 0 have root privileges.
E_NOTROOT=87   # Non-root exit error.


# Run as root, of course.
if [ "$UID" -ne "$ROOT_UID" ]; then
	echo "Must be root to run this script."
	exit $E_NOTROOT
fi  

#define working directory for future use, add to variable $workdir
WORKDIR=$(pwd)

#define directory list for find to exclude
DIRLIST1=$(/var/log /mnt /lost+found /dev /var)

#Get package list and add to new file. Will be used for comparison later. Strip everything but package name

dpkg-query -W -f='${Package}\n' > $WORKDIR/packlist1.txt

#Get script to run via command line by using script to be tested as argument

if [ -n "$1" ];then
	#FIXME this does not make the script round up, the shell built in math does not support floating point
	# See suggestion below with calculation.  For scripts that take less than one second to process, you
	# are likely to find setting a minimum value better
	STARTT=$(date +%s%N)
	file="$1"
	/bin/bash "$file" tee echo >stdout.txt 2>stderr.txt
	ENDT=$(date +%s%N)
	TIME1=$(($ENDT - $STARTT))
else

	echo "No File Or Script Specified. Please Try Again With 'script.sh'"

	#FIXME return is for use in a function, try exit 1 for error or exit 0 for non-error
	return

fi  

# FIXME This does not appear to be the correct calculation, perhaps for short running scripts, you would want to
# set a minimum of 1 minute
TIME2=$(($TIME1 / 60))

#Suggested fix (with date +%s above instead):
#if [ "${TIME2}" -lt "1" ]; then
#	TIME2=1
#fi

#find all files modified in the time of $TIME1 and print to new file for logging purposes
#FIXME With -mmin -$TIME2 does is the -mmin $TIME2 actually needed?
find -ignore_readdir_race -mmin $TIME2 -mmin -$TIME2 -path $WORKDIR $DIRLIST1 -prune -o -print > findtime.log

#get list of all packages with modified permissions
ls -la "$(<findtime.log)" tee echo > $WORKDIR/modfiles.txt 2> /dev/null
#run dpkg again to get 2nd list for comparison, again strip everything but package name

dpkg-query -W -f='${Package}\n' > $WORKDIR/packlist2.txt

#compare the two files and add anything that doesn't match to new file
PKG1=$(<packlist1.txt)
PKG2=$(<packlist2.txt)

if [ "PKG1" != "PKG2" ];then
	#FIXME compare the output of these commands for the desired format:
	#comm -13 packlist1.txt packlist2.txt > packexc.txt
	diff packlist1.txt packlist2.txt > packexc.txt

else

	echo "No Package Have Been Altered"

fi
#clean up, remove packages, remove all added files

#FIXME I belive that it is dangerous to assume that all modified files from your find command above
# are directly related to running your test script.  It MAY work OK in a VM that does nothing else,
# however I think the risk of dammage is very high with this command.  Perhaps outputing the list
# for review/confirmation is more advisable.
read -p "Do you want to delete all files created during the running of $file? (y/n)" ANS1
#FIXME Best practices for scripting style keeps if, elif, else and fi at the same indent level
if [ "$ANS1" =  "y" ]; then
	echo "Deleting Files... Please Wait"
	rm -rf "$(< findtime.txt)"
elif [ "$ANS1" = "n" ]; then
	echo "Nothing Will Be Deleted. Good Day!"     
else
	echo "I do not understand that value, please choose yes or no"
fi
            
read -p "Do you want to remove all packages that were installed during the running of $file? (y/n)" ANS2
if [ "$ANS2" = "y" ]; then
	echo "Uninstalling/Removing Packages... Please Wait"
	apt-get -y remove "$(<packexc.txt)"
	apt-get -y purge "$(<packexc.txt)"
elif [ "$ANS2" = "n" ]; then
	echo "Nothing Will Be Deleted. Good Day!"     
else
	echo "I do not understand that value, please choose yes or no"
fi

read -p "Do you want to initiate final cleanup? All log files will be moved to the backup directory? (y/n)" ANS3
if [ "$ANS3" =  "y" ]; then
	echo "Moving Log Files... Please Wait"
	#FIXME $(( )) is for math, it appears to me that this will not work.  Consider setting FOLD
	# and creating fold into two commands:
	#FOLD=$(date +%k%M%a)
	#mkdir $WORKDIR/$FOLD
	FOLD=$((mkdir "$WORKDIR/`date +%k%M%a`"))
	mv 'packlist1.txt packlist2.txt packexc.txt findtime.txt stdout.txt stderr.txt' '$WORKDIR/$FOLD'
elif [ "$ANS3" = "n" ]; then
	echo "Nothing Will Be Moved, The Files Will Stay in $WORKDIR"     
else
	echo "I do not understand that value, please choose yes or no"
fi
