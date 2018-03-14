#!/bin/bash

addr=$(dig +short wikipedia.com)

echo "" > my.tmp
sudo ./traceroute $addr >> my.tmp &
pid1=$!

traceroute -I $addr > org.tmp &
pid2=$!

wait $pid1
wait $pid2

pr -m -t -w 106 my.tmp org.tmp
echo ""

rm *.tmp
