#!/bin/sh

OPTIND=1

path_1="transport"
path_2="transport-fast"
bytes=1000
port=40001
file="output"

show_help(){
	echo "usage:
	-h  show help
	-t  path to tested program DEFAULT=transport
	-r  path to good program DEFAULT=transport-fast
	-b  bytes to send DEFAULT=1000
	-p  port DEFAULT=40001
	-o  output file DEFAULT=output1/2
	"
}

while getopts "ht:r:b:p:o" opt
do
	case "${opt}" in
	"h") show_help
	     exit 0            ;;
	"t") path_1="${OPTARG}";;
	"r") path_2="${OPTARG}";;
	"b")  bytes="${OPTARG}";;
	"p")   port="${OPTARG}";;
	"o")   file="${OPTARG}";;
	  *) exit 1 ;;
	esac
done

shift $((OPTIND-1))

[ "$1" = "--" ] && shift

echo "running program to check..."
exec "./${path_1}" "$port" "${file}1" "$bytes" > "/dev/null"
echo "running checker..."
exec "./${path_2}" "$port" "${file}2" "$bytes" > "/dev/null"
echo "comparing..."
#parse path to first program
#exec "diff" "${file}1" "${file}2" > $DIFF_OUT
if [ $DIFF_OUT ]
then
	echo "program to test has wrong output"
	#removing files
fi
# $bytes" 



