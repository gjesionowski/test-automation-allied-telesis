#! /usr/bin/env bash

exec 3>&1;
uut=$(dialog --title "Test Configuration" --inputbox "Enter the name of the device being tested:" 0 0 2>&1 1>&3);
host1=$(dialog --title "Test Configuration" --inputbox "Enter the hostname of the first endpoint:" 0 0 2>&1 1>&3);
host2=$(dialog --title "Test Configuration" --inputbox "Enter the hostname of the other endpoint:" 0 0 2>&1 1>&3);
date=$(dialog --title "Test Configuration" --date-format %Y%m%d --calendar "Select today's date:" 0 0 2>&1 1>&3);
duration=$(dialog --title "Test Configuration" --inputbox "Enter the duration (in minutes) of the test: [24hrs = 1440]" 0 0 2>&1 1>&3);
speed=$(dialog --title "Test Configuration" --radiolist "Select (with Space) the test speed and press Enter [Default: Auto-negotiate]:" 20 60 7 2>&1 1>&3 \
100 "Mbps, Full Duplex" off \
1000 "Mbps, Full Duplex" off \
10000 "Mbps, Full Duplex" off  \
auto "Auto-negotiate" on );
#duplex=$(dialog --inputbox "Enter the duplex of the test connection:" 0 0 2>&1 1>&3);
#cable1=$(dialog --inputbox "Enter the type of cable connecting UUT to Switch A:" 0 0 2>&1 1>&3);
#cable2=$(dialog --inputbox "Enter the type of cable connecting UUT to Switch B:" 0 0 2>&1 1>&3);
#cable1length=$(dialog --inputbox "Enter the length (meters) of the cable connecting UUT to Switch A:" 0 0 2>&1 1>&3);
#cable2length=$(dialog --inputbox "Enter the length (meters) of the cable connecting UUT to Switch B:" 0 0 2>&1 1>&3);

exitcode=$?;
exec 3>&-;
time=$(date +%H%M%S);

filenamemain=~/testing/yaml/currenttestconfig.yml;
filenamebackup=$date-$time-backup-$filenamemain.old;

#printf '%s' "$(cat $filenamemain)" | tee ~/testing/backups/$filenamebackup;

filename=$filenamemain;

echo " ... "
echo "Previous Configuration data saved to $filenamebackup in ~/testing/backups/";
echo "Current Configuration data  saved to $filename in ~/testing/";
echo "Exiting with status code: $exitcode";
echo " ... "

printf '%s\n' "deviceid: $uut" "speed: $speed" "host1: $host1" "host2: $host2" "duration: $duration" "date: $date" "time: $time" "status: $exitcode" | tee $filename;

# Backup old test configuration to backup folder, 
#   parse values from the new config
python ~/testing/python/parsetestconfig.py

# Enter the Ansible playbook. 
#   Multiple Passwords required for encryption and escalation
ansible-playbook ~/testing/yaml/test.yml --ask-become-pass --ask-vault-pass -v
