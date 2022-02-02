#!/bin/bash

#########################################
##### Error object or IP to hostname ####
#########################################
i=0;
count_hosts=0;
NAMES_FILE=$1
DEST_FILE=$2


if [ ! -f "$NAMES_FILE" ]; then
	echo "Could not find file $NAMES_FILE";
	exit 1;
fi

if [ ! -f "$DEST_FILE" ]; then
	echo "Could not find file $DEST_FILE";
	exit 1;
fi


  cat $NAMES_FILE | while read sline
do
	line=$sline
	((i++));
    HOSTNAME=`echo $line | cut -d " " -f4 | tr -d '"'`
	IP=`echo $line | cut -d " " -f6| tr -d '"'`


    sed -i -r "s/host_${IP}\"/${HOSTNAME}\"/g" $DEST_FILE
    #sed -i -r "s/host_"$IP"/${HOSTNAME}/g" $DEST_FILE
done
