#!/bin/bash

total_time=0;
count=200;
echo "SYNC Response Time";
for((i=1;i<=$count;i++)); 
do 
  curl_result="$(curl http://35.228.112.214:30916/ -s -o /dev/null -w "Output: starttransfer:%{time_starttransfer}s total:%{time_total}\n")"
  echo $curl_result 

  var=$(echo $curl_result | awk -F":" '{print $1, $2, $3, $4 }')
  set -- $var
  echo "$1 $2 $3 $4 $5"
  total_time=`echo "scale=6; $total_time + $5" | bc`;
done
#echo "scale=6;total_time: $total_time"
echo "average time taken: `echo "scale=6; $total_time/$count" | bc`";
