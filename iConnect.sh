#!/bin/bash
#Version 0.4
#Variables
date=date
ilog="iDevice.log"
ipack="ifuse"
ipath=~/iDevice
#
#
#Looking for iDevice
while [ $(idevicepair validate | grep -c No) != 0 ]
do
    #Checking if application "ifuse" is installed
    if [ $(dpkg -l $ipack | grep -c $ipack) != 0 ]
    then
        echo "Packages installed! Skipping..."
    else
        echo "Installing Packages!"
        sudo apt update && sudo apt install $ipack libimobiledevice-utils -y
        sleep 5 
    fi
    echo
    echo `date` >> $ilog
    echo "- iDevice was not found! :(" && idevicepair validate >> $ilog
    echo "- Connect your iDevice and permit access!"
    echo "- Timeout for 10 seconds..."
    sleep 10
    clear
done

while true
do
    #Checking Path
    echo "Mounting iDevice to Path $ipath"
    echo `date` >> $ilog && idevicepair validate >> $ilog

    if [ -d $ipath ]
    then
        #Mount iDevice to Path
        umount -q $ipath
        ifuse $ipath >> $ilog
    else
        #Create Path
        echo "Creating Path $ipath" >> $ilog
        mkdir $ipath && ifuse $ipath
    fi
    #Open Folder
    xdg-open $ipath
    read
    
done