#!/bin/bash

#script to enable Firmware password so main admin/root PW cannot be reset arbitrarily
#only used/tested on latest El Capitan, previous OS X OS’s may have difficulties

#this should not be used on Linux or Unix systems besides OS X, El Capitan Recommended!

#mount recovery HD to get at BaseSystem.dmg, mount BaseSystem.dmg (diskutil does not allow 
#mount, hence hdiutil usage)

sudo diskutil mount Recovery\ HD

sudo hdiutil mount /volumes/Recovery\ HD/com.apple.recovery.boot/BaseSystem.dmg

#find firmware utility and run PW check



EXIT_CODE=‘sudo /volumes/OS\ X\ Base\ System/Applications/Utilities/Firmware\ Password\ Utility.app/Contents/Resources/setregproptool -c’

EXIT_GET=$?

if [[ $EXIT_GET == 1 ]]; then
	echo “No Firmware Password Detected, Proceeding”
	
	sudo /volumes/OS\ X\ Base\ System/Applications/Utilities/Firmware\ Password\ Utility.app/Contents/Resources/setregproptool -m command -p mIle@l0w

	echo “You now have your firmware protected! Exiting!”

else
	if [[ $EXIT_GET == 0 ]]; then
		echo “Firmware Password Detected, Stopping”
	fi
fi

sudo hdiutil unmount /Volumes/OS\ X\ Base\ System/

sudo diskutil unmount force /Volumes/Recovery\ HD/
