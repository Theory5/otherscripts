#! /bin/bash

## this is a script for automating monthly PCI Vulnerability scans
## All issues must properly log to error file during scans and sent to email

##ping all servers from server.list
## $IPL variable for IP Server List

rm success.log

cat pciserver.list | while read -r line;
do
        ping -c1 "$line"
        if [[ $? -eq 0 ]];
        then
                echo "$line" >> success.log 
        else
                echo "host is down"
        fi
done 
