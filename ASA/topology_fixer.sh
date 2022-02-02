#!/bin/bash
####################################################################################################################
#### Extract topology errors from *_policy*.html                                                                 ###
#### cat CiscoASA_policy.html | awk -F '[][]' '{print $2}' | grep Host | sort --unique > error_topology.txt 		 ###
####################################################################################################################

echo "Fixing Script for errors in topology"

i=0;
count_hosts=0;
fix_file=$1
dest_file=$2
dest_file=`echo $dest_file | sed 's/\\r//g'`


if [ ! -f "$fix_file" ]; then
	echo "Could not find file $fix_file";
	exit 1;
fi

if [ ! -f "$dest_file" ]; then
	echo "Could not find file $dest_file";
	exit 1;
fi

  cat $fix_file | while read sline

do
	line=$sline
	((i++));
#  echo $line
  fixed=`echo $line | awk '{print $3}' | tr -d '.' `
  error=`echo $line | awk '{print $7}' | tr -d '.' `
  echo "Fixing error" $error
  sed -i "s/$error/$fixed/g" $dest_file
  #sed -i -r "s/host_"$IP"/${HOSTNAME}/g" $dest_file
done
