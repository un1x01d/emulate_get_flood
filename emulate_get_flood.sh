#!/bin/bash

usage() {
  echo "$0 -x [threads] -t [time]"
}

IFS=$'\n'
url="http://192.168.102.105"
agents_list="full.txt"

while getopts "x:t:u:" arg; do
  case $arg in
    x)
       workers="${OPTARG}"
      ;;
    t)
       time="${OPTARG}"
      ;;
    u)
       url="${OPTARG}"
      ;;
    *)
       usage ; exit 1 
      ;;
  esac
done

if [ -z $url ] || [ -z $time ]; then
   echo "i need a parameter" ; exit 1 
fi

run_curl() {
     for job in `sort -R $agents_list | head -$(wc -l $agents_list| awk '{print $1}')` ;do
	     curl --silent --output /dev/null --header \
          "X-Forwarded-for: $((RANDOM % 256)).$((RANDOM % 256)).$((RANDOM % 256)).$((RANDOM % 256))" -A $job $url 
     done
}

tput setaf 6 ; echo "[+] Starting load test with $workers workers for $time seconds. `tput setaf 5; date`"
for i in $workers ; do
   for worker in `seq $workers`; do
      run_curl $i & PID="$!"
      tput setaf 3 ; echo "[+] Starting worker $(tput setaf 2)[ $(tput setaf 7 ; echo -n "$worker" ; tput setaf 2) ] - pid: $(tput setaf 7 ; echo -n "$PID" ; tput setaf 2)"
      sleep 0.05
      tput sgr0 
   done
done

sleep $time && echo "Terminating all workers" && killall bash
