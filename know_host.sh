#!/bin/bash

NAMES_FILE=$1

i=0;

run_command() {
  eval $cmd > last_output.txt 2>&1
  if [[ $? -ne 0 ]]; then
    echo $cmd >> failed_objects.txt
    cat last_output.txt >> failed_objects.txt
    echo ''
    echo $cmd
    cat last_output.txt
  fi
}

echo 'Logging in...'
if [[ -f failed_objects.txt ]]; then
  rm failed_objects.txt
fi
echo ''
mgmt_cli login -r true -v 1.1 > id.txt
if [[ $? -ne 0 ]]; then
  echo 'Login Failed'
  exit 1
fi

JQ=${CPDIR}/jq/jq
mgmt_cli show mdss -s id.txt --format json > domains.json
DOMAINS_COUNT=$($JQ -r ".total" domains.json)
if [[ $DOMAINS_COUNT -ne 0 ]]; then
  echo 'This script cannot be executed on MDS. Please specify a domain name in SmartMove tool.'
  mgmt_cli logout -s id.txt
  exit 1
fi


NAMES_FILE=$1

if [ ! -f "$NAMES_FILE" ]; then
        echo "Could not find file $NAMES_FILE";
        exit 1;
fi




mgmt_cli SmartMove_Create_Objects_CiscoASA -s id.txt > /dev/null 2>&1


cat $NAMES_FILE | while read sline
do
        line=$sline
        ((i++));
        NAME=`echo $line | cut -d " " -f4`
        IP=`echo $line | cut -d " " -f6`
    #echo $IP $NAME
    echo "create host [${NAME}] with ip-address [${IP}]"
    cmd="mgmt_cli add host name ${NAME} ip-address ${IP} tags 'CiscoASA' ignore-warnings true -s id.txt --user-agent mgmt_cli_smartmove"
    #echo $cmd
    run_command
    #arr+=(cmd)
    #run_command
        #echo add host name \"$NAME\" ip-address \"$IP\" tags \"CiscoASA\" >> hosts.txt
done


mgmt_cli publish -s id.txt
mgmt_cli logout -s id.txt

if [[ -f failed_objects.txt ]]; then
  echo ''
  echo 'Some objects were not created successfully.'
  echo 'Check file failed_objects.txt for details.'
else
  echo ''
  echo 'Done. All objects were created successfully.'
fi
