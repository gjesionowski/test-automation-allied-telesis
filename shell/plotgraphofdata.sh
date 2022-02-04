#! /usr/bin/env bash
currentdata=$(ls -t ~/testing/data/ | grep clean | head -n1)
# Gets the first field (time data) from the first record in the data
startdate=$(echo $(head -n1 $currentdata) | sed 's/,.*//')
enddate=$(echo $(head -n1 $currentdata) | sed 's/,.*//')

gnuplot -p <<EOF
set title "FCS Errors and Total Packets"
set terminal png
set style data lines
set output 'barebones.png'
set datafile sep ","
set xdata time
set timefmt "%Y/%m/%d/%H:%M:%S"
set format x "%m/%d\n%H:%M"
set xlabel "Elapsed Time"
set ylabel "Total (Errors and Packets)"
set xrange [$startdate : $enddate]
FACTOR=0.000000001
set grid xtics lc rgb "#888888" lw 1 lt 0    #grey grid on background
set grid ytics lc rgb "#888888" lw 1 lt 0    #grey grid on background
plot \
'$currentdata' using 1:2 t "FCS Errors" w lines, \
'$currentdata' using 1:(\$3*FACTOR) t "Packets" w lines
EOF
