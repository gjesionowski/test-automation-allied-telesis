#! /usr/bin/env bash

# Gets time to avoid overwriting data with 24hrs
check12=$(date +%H%M%S)

# Gets user input
printf "Which switch is being monitored? [i.e. 131, 133]  -> "
read SWITCH
printf "Which port data is needed [i.e. 1, 15]  -> "
read PORT
echo "Gathering and graphing data from port $PORT on switch @ 192.162.1.$SWITCH ..."

# Connects to Switch and gets the port data
ssh manager@192.162.1.$SWITCH "copy usb:port$PORT.txt scp://pi@192.162.1.101:/home/pi/testing/data/port$PORT.dat"
echo "Data copy from switch to Ansible server finished. If connection has been refused, check SSH service on Ansible server."

# Sifts the relevant counter data from full output. Filtering output on switch is not possible with AlliedWare+ scripting
awk 'BEGIN{RS="Switch Port Counters"}{print $242"/"$258","$65","$61}' /home/pi/testing/data/port$PORT.dat > /home/pi/testing/data/$check12-port$PORT.clean
echo "Data formatting finished"
cd /home/pi/testing/shell
pwd

# Gets the most recent data file name
currentdata=$(ls -t ~/testing/data/ | grep clean | head -n1)
echo $currentdata
pwd

# Graphs the most recent data file, saves with switch/port/time
gnuplot -p <<EOF
set title "FCS Errors and Total Packets\n{/*0.6 Switch $SWITCH - Port $PORT - from datafile $currentdata}" # Set subtitle at half font size
set terminal pngcairo dashed
set style data lines
set output '/home/pi/testing/backups/switch$SWITCH-port$PORT-$check12-graph.png'
set datafile sep ","
set xlabel "Elapsed Time (minutes)"
set ylabel "Total Packets (millions)"
set y2label "Total FCS Errors"
set xtics 60 rotate by -30 offset -0.5
set mxtics 4
set y2tics 10
set my2tics
set y2range [0:*]
set ytics nomirror
#set mytics 2
set style line 8 lc rgb "gray50" lw 0.5 lt 1
set style line 4 lc rgb "gray80" lw 0.5 lt 1
set grid mxtics xtics ls 8, ls 4
FACTOR=0.000001
plot \
'/home/pi/testing/data/$currentdata' using 0:2 t "FCS Errors" w lines axes x1y2, \
'/home/pi/testing/data/$currentdata' using 0:(\$3*FACTOR) t "Packets" w lines
EOF
echo "Data graphing finished"

# Opens the finished graph, or most recent graph in directory
cd /home/pi/testing/backups
pwd
xdg-open $(ls -t /home/pi/testing/backups | grep graph.png | head -n1)
echo "Graph opening finished"
