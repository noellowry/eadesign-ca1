#!/bin/bash
DATE=$(date +"%Y%m%d%H%M%S")
total_time=0;
count=10;
avg_sync_rsp=0;
avg_async_rsp=0;
#################################
#  Part 2.1                     #
#################################
#Get ASYNC RESPONSE TIME
echo "ASYNC Response Time";
for((i=1;i<=$count;i++)); 
do 
  curl_result="$(curl http://35.228.112.214:31080/ -s -o /dev/null -w "Output: starttransfer:%{time_starttransfer}s total:%{time_total}\n")"
  #echo $curl_result 

  var=$(echo $curl_result | awk -F":" '{print $1, $2, $3, $4 }')
  set -- $var
  echo "$1 $2 $3 $4 $5"
  total_time=`echo "scale=6; $total_time + $5" | bc`;
done
#echo "scale=6;total_time: $total_time"
echo "SYNC average time taken: `echo "scale=6; $total_time/$count" | bc`";
#echo $DATE
echo "SYNC Response Time";
for((i=1;i<=$count;i++)); 
do 
  curl_result="$(curl http://35.228.112.214:30916/ -s -o /dev/null -w "Output: starttransfer:%{time_starttransfer}s total:%{time_total}\n")"
  #echo $curl_result 

  var=$(echo $curl_result | awk -F":" '{print $1, $2, $3, $4 }')
  set -- $var
  echo "$1 $2 $3 $4 $5"
  total_time=`echo "scale=6; $total_time + $5" | bc`;
done
#echo "scale=6;total_time: $total_time"
avg_sync_rsp=$total_time/$count;
echo $avg_async_rsp;
echo "SYNC average time taken: `echo "scale=6; $total_time/$count" | bc`";

gcloud functions call create-graph --project eadesign-269520 --data '{"filename":"graph-'"$DATE"'.png", "plottype":"line", "x":["2000", "10000", "20000"], "y":["0.066996","00.067789","0.067247", "0.066995", "0.067226", "0.066946", "0.066934", "0.066439", "0.066958"], "ylab":["Door publish interval: 10ms", "Door publish interval: 50ms", "Door publish interval: 100ms"]}';

#################################
#  Part 2.2                     #
#################################