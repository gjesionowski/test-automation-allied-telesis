#! /usr/bin/env bash

# Stream 3 into 1 ;; Then stream 2 into 1 + 1 into 3 ;; Gives stderror and stdout
exec 3>&1;
uut=$(dialog --title "Test Configuration" --inputbox "Enter the name of the device being tested:" 0 0 2>&1 1>&3);
host1=$(dialog --title "Test Configuration" --inputbox "Enter the hostname of the first endpoint:" 0 0 2>&1 1>&3);
host2=$(dialog --title "Test Configuration" --inputbox "Enter the hostname of the other endpoint:" 0 0 2>&1 1>&3);
duration=$(dialog --title "Test Configuration" --inputbox "Enter the duration (in minutes) of the test: [24hrs = 1440]" 0 0 2>&1 1>&3);
speed=$(dialog --title "Test Configuration" --radiolist "Select (with Space) the test speed and press Enter [Default: Auto-negotiate]:" 20 60 7 2>&1 1>&3 \
100 "Mbps, Full Duplex" off \
1000 "Mbps, Full Duplex" off \
10000 "Mbps, Full Duplex" off  \
auto "Auto-negotiate" on );
##### These values are not needed yet ;; Will need to add port number options for data trigger automation
#duplex=$(dialog --inputbox "Enter the duplex of the test connection:" 0 0 2>&1 1>&3);
#cable1=$(dialog --inputbox "Enter the type of cable connecting UUT to Switch A:" 0 0 2>&1 1>&3);
#cable2=$(dialog --inputbox "Enter the type of cable connecting UUT to Switch B:" 0 0 2>&1 1>&3);
#cable1length=$(dialog --inputbox "Enter the length (meters) of the cable connecting UUT to Switch A:" 0 0 2>&1 1>&3);
#cable2length=$(dialog --inputbox "Enter the length (meters) of the cable connecting UUT to Switch B:" 0 0 2>&1 1>&3);

# Store exit code for later debugging purposes
exitcode=$?;
# Close stream 3
exec 3>&-;
# Time/date used to create unique filenames for now
time=$(date +%H%M%S);
date=$(date +%y%m%d);
# Directory variables
backupdir="/home/pi/testing/backups/"
yamldir="/home/pi/testing/yaml/"
# Setup for file backup and writing
filenamemain=currenttestconfig.yml;
filenamebackup=$date-$time-backup-$filenamemain.old;
filename=$filenamemain;

# Backs up old config -> Remains to be seen if this is necessary
printf '%s\n' "$(cat $yamldir$filenamemain)" | tee $backupdir$filenamebackup;
# Writes the new config
printf '%s\n' "deviceid: $uut" "host1: $host1" "host2: $host2" "duration: $duration" "speed: $speed" "date: $date" "time: $time" "status: $exitcode" | tee $yamldir$filename;

# Debugging and user benefit
echo " ... "
echo "Previous Configuration data saved to $backupdir$filenamebackup";
echo "Current Configuration data saved to $yamldir$filename";
echo "Exiting with status code: $exitcode";
echo " ... "

## Backup old test configuration to backup folder, 
## Parse values from the new config
python ~/testing/python/parsetestconfig.py

## Enter the Ansible playbook. 
## Multiple Passwords required for encryption and escalation
ansible-playbook ~/testing/yaml/test.yml --ask-become-pass --ask-vault-pass -v
