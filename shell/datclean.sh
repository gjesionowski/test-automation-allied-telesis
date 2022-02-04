#! /usr/bin/env bash
check12=$(date +%H%M%S)

ssh manager@192.162.1.131 "copy usb:port15.txt scp://pi@192.162.1.101:/home/pi/testing/data/port15.dat"
echo "The data copy from switch to Ansible server finished with status $?"
awk 'BEGIN{RS="Switch Port Counters"}{print $242"/"$258","$65","$61}' /home/pi/testing/data/port15.dat > /home/pi/testing/data/$check12-port15.clean
echo "The data formatting finished with status $?"
cd /home/pi/testing/shell
pwd
./timelessplotgraphofdata.sh
echo "The data graphing finished with status $?"
cd /home/pi/testing/backups
pwd
xdg-open $(ls -t /home/pi/testing/backups | grep graph.png | head -n1)
echo "The graph opening has finished with status $?"
