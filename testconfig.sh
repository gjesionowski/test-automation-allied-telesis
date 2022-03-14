#! /usr/bin/env bash

# Stream 3 into 1 ;; Then stream 2 into 1 + 1 into 3 ;; Gives stderror and stdout
exec 3>&1;
uut=$(dialog --title "Test Configuration" --inputbox "Enter the name of the device being tested:" 0 0 2>&1 1>&3);
host1=$(dialog --title "$uut Test Configuration: Host A" --radiolist "Select (with Space) the OS family of Test PC 1:" 20 60 7 2>&1 1>&3 \
Windows "(All versions)" on \
Linux "(All versions)" off \
);
host2=$(dialog --title "$uut Test Configuration: Host B" --radiolist "Select (with Space) the OS family of Test PC 2:" 20 60 7 2>&1 1>&3 \
Windows "(All versions)" on \
Linux "(All versions)" off \
);
duration=$(dialog --title "$uut Test Configuration: Test Duration" --radiolist "Select (with Space) the test duration (in minutes) of the test: [Default: 15 Minutes]" 20 60 7 2>&1 1>&3 \
1 "Minute" off \
15 "Minutes" on \
30 "Minutes" off  \
60 "Minutes" off \
120 "Minutes" off \
720 "Minutes (12 hours)" off \
1440 "Minutes (1 day)" off \
2880 "Minutes (2 days)" off \
5760 "Minutes (4 days)" off \
);
testlist=$(dialog --title "$uut Test Configuration: Test Duration" --separate-output --checklist "Select (with Space) the tests to be ran: [Default: 15 Minutes]" 20 60 15 2>&1 1>&3 \
1 "Jumbo Frames" on \
2 Wake-on-LAN on \
3 Throughput on
4 HLK off  \
);
speed=$(dialog --title "$uut Test Configuration: Speed Setting" --radiolist "Select (with Space) the test speed and press Enter [Default: Auto-negotiate]:" 20 60 7 2>&1 1>&3 \
100 "Mbps, Full Duplex" off \
1000 "Mbps, Full Duplex" off \
10000 "Mbps, Full Duplex" off  \
auto "Auto-negotiate" on \
);
octet=$(dialog --title "$uut Test Configuration: Switch IP" --inputbox "Enter the last octet of Switch IP [i.e. xx in 192.162.1.xx]:" 0 0 2>&1 1>&3);
port1=$(dialog --title "$uut Test Configuration: Port IDs" --inputbox "Enter the first switch port to monitor [i.e. x in port1.0.x]:" 0 0 2>&1 1>&3);
#cable1=$(dialog --inputbox "Type of cable connected to port1.0.$port1:" 0 0 2>&1 1>&3);
#cable1length=$(dialog --inputbox "Length (meters) of the cable connected to port1.0.$port1:" 0 0 2>&1 1>&3);
port2=$(dialog --title "$uut Test Configuration: Port IDs" --inputbox "Enter the second switch port to monitor [i.e. x in port1.0.x]:" 0 0 2>&1 1>&3);
#cable2=$(dialog --inputbox "Type of cable connected to port1.0.$port2" 0 0 2>&1 1>&3);
#cable2length=$(dialog --inputbox "Length (meters) of the cable connected to port1.0.$port2:" 0 0 2>&1 1>&3);
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
echo " ... "
echo "Previous Configuration data"
printf '%s\n' "$(cat $yamldir$filenamemain)" | tee $backupdir$filenamebackup;
echo " ... "
# Writes the new config
echo " ... "
echo "Current Configuration data"
printf '%s\n' "deviceid: $uut" "host1: $host1" "host2: $host2" "duration: $duration" "speed: $speed" "date: $date" "time: $time" "switch1: switch$octet" "port1: $port1" "port2: $port2" "options: $testlist" | tee $yamldir$filename;
#ORIGINAL: printf '%s\n' "deviceid: $uut" "host1: $host1" "host2: $host2" "duration: $duration" "speed: $speed" "date: $date" "time: $time" "switch1: switch$octet" "port1: $port1" "port2: $port2" | tee $yamldir$filename;
echo " ... "
# Debugging and user benefit
echo " ... "
echo "Previous Configuration data saved to $backupdir$filenamebackup";
echo "Current Configuration data saved to $yamldir$filename";
echo " ... "

## Enter the main testing Ansible playbook. This may be split up into multiple playbooks soon because of increasing complexity. 
## Multiple Passwords required for encryption and escalation (--ask-become-pass & --ask-vault-pass)
## Ask permission for each step of the way (--step)
ansible-playbook --ask-become-pass --ask-vault-pass -vvv ~/testing/yaml/test.yml
