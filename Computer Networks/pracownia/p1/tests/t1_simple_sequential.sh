#!/bin/bash

addr=$(dig +short facebook.com)
echo "" > my.tmp
sudo ./traceroute $addr >> my.tmp
traceroute -I $addr > org.tmp

pr -m -t -w 106 my.tmp org.tmp
echo ""

rm *.tmp