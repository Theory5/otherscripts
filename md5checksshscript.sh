#!/bin/bash

#This script will accept a list of files fromatted to show MD5 and then file name.

echo "Please specify the two text files you wish to compare."
read -e -p "Specify The First text file: " input
read -e -p "Specify The Second text file: " input2

file1="${input}"
file2="${input2}"

#For temp file storage append number to filename starting at 1 for temporary use
name=$(($file1_tmp))
name2=$(($file2_tmp))

#strip numbered lines from each file
sed 's/ *[0-9]*.//' $file1 > "$name.txt"
sed 's/ *[0-9]*.//' $file1 > "$name2.txt"

join <(sort "$name.txt") <(sort "$name2.txt") &> comb.txt

awk '{print $2}' comb.txt &> final.txt

sed '/^$/d' final.txt > final2.txt

sed -e 's/^/rm /' final2.txt > finalized.txt
