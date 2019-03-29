#!/bin/bash

addr1=$(dig +short facebook.com)
addr2=$(dig +short wikipedia.com)

echo $addr1 >> my1.tmp
sudo ./traceroute $addr1 >> my1.tmp &
pid1=$!

echo $addr2 >> my2.tmp
sudo ./traceroute $addr2 >> my2.tmp &
pid2=$!

echo $addr2 >> my3.tmp
sudo ./traceroute $addr2 >> my3.tmp &
pid3=$!

wait $pid1
wait $pid2
wait $pid3

pr -m -t -w 160 my1.tmp my2.tmp my3.tmp
echo ""

rm *.tmp
