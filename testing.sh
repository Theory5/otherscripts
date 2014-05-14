#This is my first attempt at a testing framework, which will return all information/errors from a script
#This should only be run in a VM with a fresh installation of ubuntu

#define all variables needed for entire script
ROOT_UID=0     # Only users with $UID 0 have root privileges.
E_NOTROOT=87   # Non-root exit error.

#define working directory for future use, add to variable $workdir
WORKDIR=$(pwd)

#define directory list for find to exclude

DIRLIST1=$(("$WORKDIR /var/log /mnt /lost+found /dev /var"))


# Run as root, of course.
if [ "$UID" -ne "$ROOT_UID" ]
then
  echo "Must be root to run this script."
  exit $E_NOTROOT
fi  


#Get package list and add to new file. Will be used for comparison later

dpkg-query -l &> $WORKDIR/packlist1.txt

#Get script to run via command line

STARTT=$(date +%M)
file="$1"
sh ./"$file" | read line echo  1>& stdout.log 2>& stderr.log
ENDT=$(date +%M)

TIME1=$(( $ENDT - $STARTT ))

#find all files modified in the time of $TIME1 and print to new file for logging purposes
find -ignore_readdir_race -mmin $TIME1 -path $DIRLIST1 -prune -o -print &> findtime.log

#run dpkg again to get 2nd list for comparison

dpkg-query -l &> $WORKDIR/packlist2.txt

#compare the two files and add anything that doesn't match to new file
grep -Fxvf $WORKDIR/packlist1.txt $WORKDIR/packlist2.txt &> packexc.txt

#clean up, remove packages, remove all added files

read -p "Do you want to delete all files created during the running of $file? (Yes/No)" $ANS
  if (( $ANS =  "yes" )); then
                echo "Deleting Files... Please Wait"
                rm -rf "$(< findtime.txt)"
      elif (( $ANS = "no" )); then
           echo "Nothing Will Be Deleted. Good Day!"     
            else
                echo "I do not understand that value, please choose yes or no"
            fi
            
