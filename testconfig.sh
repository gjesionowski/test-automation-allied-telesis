#! /usr/bin/env bash

exec 3>&1;
uut=$(dialog --title "Test Configuration" --inputbox "Enter the name of the device being tested:" 0 0 2>&1 1>&3);
host1=$(dialog --title "Test Configuration" --inputbox "Enter the hostname of the first endpoint:" 0 0 2>&1 1>&3);
host2=$(dialog --title "Test Configuration" --inputbox "Enter the hostname of the other endpoint:" 0 0 2>&1 1>&3);
date=$(dialog --title "Test Configuration" --date-format %Y%m%d --calendar "Select today's date:" 0 0 2>&1 1>&3);
duration=$(dialog --title "Test Configuration" --inputbox "Enter the duration (in minutes) of the test: [24hrs = 1440]" 0 0 2>&1 1>&3);
speed=$(dialog --title "Test Configuration" --radiolist "Select (with Space) the test speed [1000 default] and press Enter:" 14 60 3 2>&1 1>&3 \
100 "Mbps" off \
1000 "Mbps" on \
10000 "Mbps" off );
#duplex=$(dialog --inputbox "Enter the duplex of the test connection:" 0 0 2>&1 1>&3);
#cable1=$(dialog --inputbox "Enter the type of cable connecting UUT to Switch A:" 0 0 2>&1 1>&3);
#cable2=$(dialog --inputbox "Enter the type of cable connecting UUT to Switch B:" 0 0 2>&1 1>&3);
#cable1length=$(dialog --inputbox "Enter the length (meters) of the cable connecting UUT to Switch A:" 0 0 2>&1 1>&3);
#cable2length=$(dialog --inputbox "Enter the length (meters) of the cable connecting UUT to Switch B:" 0 0 2>&1 1>&3);

exitcode=$?;
exec 3>&-;
time=$(date +%H%M%S);

filenamemain=currenttestconfig.yml;
filenamebackup=$date-$time-backup-$filenamemain.old;

echo $(more $filenamemain) >> ~/testing/backups/$filenamebackup;

filename=$filenamemain;

echo "Previous Configuration data saved to $filenamebackup in ~/testing/backups/";
echo "Current Configuration data  saved to $filename in ~/testing/";
echo "Exiting with status code: $exitcode";

echo "---" > $filename;
#echo "- vars:" >> $filename;
echo "deviceid: $uut" >> $filename;
echo "speed: $speed" >> $filename;
echo "host1: $host1" >> $filename;
echo "host2: $host2" >> $filename;
echo "duration: $duration" >> $filename;
echo "date: $date" >> $filename;
echo "time: $time" >> $filename;
echo "status: $exitcode" >> $filename;

#echo "  duplex: $duplex" >> $filename;
# " " for all other variables if needed

# Backup old test configuration to backup folder, 
#   parse values from the new config
python ~/testing/python/parsetestconfig.py

# Enter the Ansible playbook. 
#   Multiple Passwords required for encryption and escalation
ansible-playbook ~/testing/test.yml --ask-become-pass --ask-vault-pass
