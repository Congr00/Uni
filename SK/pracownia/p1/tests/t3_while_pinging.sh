#!/bin/bash

addr=$(dig +short google.com)

echo "Alone traceroute"

sudo ./traceroute $addr

echo "Start pinging..."

ping $addr > trash.tmp &
pid=$!

sudo ./traceroute $addr

kill $pid

rm *.tmp
