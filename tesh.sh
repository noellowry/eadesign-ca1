#!/bin/bash
 
CURL="/usr/bin/curl"
echo -n "http://35.228.112.214:31080/"
read url
URL="$url"
count=1;
total_connect=0
total_start=0 
total_time=0
    echo " Time_Connect Time_startTransfer Time_total ";
while [ $count -le 100 ]
do
    result=`$CURL -o /dev/null -s -w %{time_connect}:%{time_starttransfer}:%{time_total} $URL`
    echo $result;
 
    var=$(echo $result | awk -F":" '{print $1, $2, $3}')
    set -- $var
 
    total_connect=`echo "scale=2; $total_connect + $1"  | bc`;
    total_start=`echo "scale=2; $total_start + $2" | bc`;
    total_time=`echo "scale=2; $total_time + $3" | bc`;
    count=$((count+1))
done
echo "average time connect: `echo "scale=2; $total_connect/100" | bc`";
echo "average time start: `echo "scale=2; $total_start/100" | bc`";
echo "average time taken: `echo "scale=2; $total_time/100" | bc`";
