#!/bin/bash
#############################################
#### Extract name line from ciscoasa.cfg ####
#############################################
NAMES_FILE=$1

if [ ! -f "$NAMES_FILE" ]; then
	echo "Could not find file $NAMES_FILE";
	exit 1;
fi

i=0;

delimiter="description"

cat $NAMES_FILE | while read sline
do
	line=$sline
	((i++));
	IP=`echo $line | cut -d " " -f2`
	NAME=`echo $line | cut -d " " -f3`
	DESCRIPTION=''
	if [[ $line == *"$delimiter"* ]]; then
		aline=$line
		DESCR=${aline#*$delimiter}
		DESCRIPTION=${DESCR##*( \r)}
	fi
	#echo " $i :  '$line'"
	#echo "Item $i) IP : $IP, NAME: $NAME, DESCRIPTION : $DESCRIPTION";
	echo add host name \"$NAME\" ip-address \"$IP\" tags \"CiscoASA\" >> hosts.txt
done
