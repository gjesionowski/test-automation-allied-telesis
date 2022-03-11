#! /usr/bin/env bash

# Gets time to avoid overwriting data with 24hrs
check12=$(date +%H%M%S)

# Sets the data file name
currentdata='/home/pi/testing/data/090657-port12.clean'
echo $currentdata

# Graphs the data file, saves result
gnuplot -p <<EOF
set title "FCS Errors and Total Packets\n{/*0.6 From datafile $currentdata}" # Set subtitle at half font size
set terminal pngcairo dashed
set style data lines
set output '/home/pi/testing/backups/focused-$check12-graph.png'
FACTOR=0.000000001
set datafile sep ","
set xlabel "Elapsed Time (minutes)"
set ylabel "Total Packets (billions)"
set y2label "Total FCS Errors"
set xtics 360 rotate by -30 offset -0.5
set mxtics 6
set y2tics 10
set my2tics 10
#set yrange [0:100]
set xrange [0:1440]
set y2range [0:*]
set ytics nomirror
#set mytics 2
set style line 8 lc rgb "gray50" lw 0.5 lt 1
set style line 4 lc rgb "gray80" lw 0.5 lt 1
set grid mxtics xtics ls 8, ls 4
plot \
'$currentdata' using 0:2 t "FCS Errors" w steps axes x1y2, \
'$currentdata' using 0:(\$3*FACTOR) t "Packets" w lines
EOF
echo "Data graphing finished"

# Opens the finished graph, or most recent graph in directory
cd /home/pi/testing/backups
xdg-open $(ls -t /home/pi/testing/backups | grep graph.png | head -n1)
echo "Graph opening finished"
