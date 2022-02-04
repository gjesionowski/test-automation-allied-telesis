#! /usr/bin/env bash
check12=$(date +%H%M%S)
printf "Which port data is needed [i.e. 1, 15]  -> "
read PORT
echo "Gathering and graphing data from port $PORT."
ssh manager@192.162.1.131 "copy usb:port$PORT.txt scp://pi@192.162.1.101:/home/pi/testing/data/port$PORT.dat"
echo "The data copy from switch to Ansible server finished with status $?"
awk 'BEGIN{RS="Switch Port Counters"}{print $242"/"$258","$65","$61}' /home/pi/testing/data/port$PORT.dat > /home/pi/testing/data/$check12-port$PORT.clean
echo "The data formatting finished with status $?"
cd /home/pi/testing/shell
pwd
./timelessplotgraphofdata.sh
echo "The data graphing finished with status $?"
cd /home/pi/testing/backups
pwd
xdg-open $(ls -t /home/pi/testing/backups | grep graph.png | head -n1)
echo "The graph opening has finished with status $?"
