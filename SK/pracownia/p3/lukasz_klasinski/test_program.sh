#!/bin/sh

LPURPLE='\033[1;35m'
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'
OPTIND=1

path_1="transport"
path_2="transport-faster"
bytes=9999
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
	-d  default
	"
}

while getopts "ht:r:b:p:o:d" opt
do
	case "${opt}" in
	"h") show_help
	     exit 0            ;;
	"t") path_1="${OPTARG}";;
	"r") path_2="${OPTARG}";;
	"b")  bytes="${OPTARG}";;
	"p")   port="${OPTARG}";;
	"o")   file="${OPTARG}";;
	"d")   break           ;;
	  *) exit 1 ;;
	esac
done

shift $((OPTIND-1))

[ "$1" = "--" ] && shift
make > /dev/null

echo "running program to check..."
START_TIME1=$SECONDS
./${path_1} $port ${file}1 $bytes > /dev/null
runtime1=$(($SECONDS-START_TIME1))
echo -e "total time: ${LPURPLE} $runtime1 sec${NC}\n"
echo "running checker..."
START_TIME2=$SECONDS
./${path_2} $port ${file}2 $bytes > /dev/null
runtime2=$(($SECONDS-START_TIME2))
echo -e "total time: ${LPURPLE} $runtime2 sec${NC}\n"
echo "comparing..."
#parse path to first program
DIFF_OUT=$(diff ${file}1 ${file}2)
if [ $? -eq 0 ];
then
	echo -e "${GREEN}PASSED${NC}\n"
else
	echo -e "${RED}FILE DIFFER${NC}\n"
fi
if ((runtime1 < runtime2));
then
	echo -e "Program was ${GREEN}$((runtime2-runtime1)) sec${NC} faster"
else
	echo -e "Program was ${RED}$((runtime1-runtime2))${NC} sec${NC} slower"
fi
rm ${file}1 
rm ${file}2
make distclean > /dev/null
