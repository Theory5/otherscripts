#This is my first attempt at a testing framework, which will return all information/errors from a script
#This should only be run in a VM with a fresh installation of ubuntu

# Run as root, of course.
if [ "$UID" -ne "$ROOT_UID" ]
then
  echo "Must be root to run this script."
  exit $E_NOTROOT
fi  

#define working directory for future use, add to variable $workdir

workdir=$(pwd)

#Get package list and add to new file. Will be used for comparison later

dpkg-query -l &> $workdir/packlist1.txt

#Get script to run via command line

