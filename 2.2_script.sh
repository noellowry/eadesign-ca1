#!/bin/bash
DATE=$(date +"%Y%m%d%H%M%S")
total_time=0;
count=5;
avg_sync_rsp=0;
avg_async_rsp=0;
#################################
#  Part 2.1                     #
#################################
# get_response_time(){
#   for((i=1;i<=$1;i++)); 
#   do 
#     curl_result="$(curl $2 -s -o /dev/null -w "total:%{time_total}\n")"
#     #echo $curl_result 

#     var=$(echo $curl_result | awk -F":" '{print $1, $2}')
#     set -- $var
#     echo "$1 $2"
#     total_time=$(bc <<< "scale=6; $total_time + $2")
#   done

#   echo $total_time
# }
# get_response_time $count, "http://35.228.112.214:30916"

#Get SYNC RESPONSE TIME
for((i=1;i<=$count;i++)); 
do 
  curl_result="$(curl http://35.228.112.214:30916/ -s -o /dev/null -w "total:%{time_total}\n")"
  #echo $curl_result 

  var=$(echo $curl_result | awk -F":" '{print $1, $2}')
  set -- $var
  echo "$1 $2"
  total_time=$(bc <<< "scale=6; $total_time + $2")
done

avg_sync_rsp=$(bc <<< "scale=6; $total_time/$count")
#echo $avg_sync_rsp;
#echo "SYNC Average Response Time: `echo "scale=6; $avg_sync_rsp" | bc`";

#Get ASYNC RESPONSE TIME
for((i=1;i<=$count;i++)); 
do 
  curl_result="$(curl http://35.228.112.214:31080/ -s -o /dev/null -w "total:%{time_total}\n")"
  #echo $curl_result 

  var=$(echo $curl_result | awk -F":" '{print $1, $2}')
  set -- $var
  echo "$1 $2"
  total_time=$(bc <<< "scale=6; $total_time + $2")
done
avg_async_rsp=$(bc <<< "scale=6; $total_time/$count")

echo "SYNC Average Response Time: `echo "scale=6; $avg_sync_rsp" | bc`";
echo "ASYNC Average Response Time: `echo "scale=6; $avg_async_rsp" | bc`";

gcloud functions call create-graph --project eadesign-269520 --data '{"filename":"2.1-graph-'"$DATE"'.png", "plottype":"bar", "x":["SYNC", "ASYNC"], "y":["'"$avg_sync_rsp"'", "'"$avg_async_rsp"'"], "ylab":"Time in Seconds"}';

#################################
#  Part 2.2                     #
#################################