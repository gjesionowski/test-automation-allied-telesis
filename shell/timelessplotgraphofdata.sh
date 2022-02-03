#! /usr/bin/env bash

check=$(date +%H%M%S)
# Gets the most recent data file name
currentdata=$(ls -t ~/testing/data/*.dat | head -n1)

gnuplot -p <<EOF
set title "FCS Errors and Total Packets"
set terminal pngcairo dashed
set style data lines
set output '$check-graph.png'
set datafile sep ","
set xlabel "Elapsed Time (minutes)"
set ylabel "Total (Errors and Packets)"
set xtics 360 rotate by -30 offset -1
set mxtics 6
set ytics 100
set mytics 2
set style line 8 lc rgb "gray50" lw 0.5 lt 1
set style line 4 lc rgb "gray80" lw 0.5 lt 1
set grid mxtics mytics xtics ytics ls 8, ls 4
FACTOR=0.000000001
plot \
'$currentdata' using 0:2 t "FCS Errors" w lines, \
'$currentdata' using 0:(\$3*FACTOR) t "Packets" w lines
EOF
