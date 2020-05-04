#!/bin/bash
DATE=$(date +"%Y%m%d%H%M%S")
total_time=0;
count=5;
avg_sync_rsp=0;
avg_async_rsp=0;
#################################
#  Part 2.2                     #
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

echo "ASYNC Average Response Time: `echo "scale=6; $avg_async_rsp" | bc`";

gcloud functions call create-graph --project eadesign-269520 --data '{"filename":"2.2-graph-'"$DATE"'.png", "plottype":"line", "x":["2000", "10000", "20000"], "y":["0.066996","00.067789","0.067247", "0.066995", "
0.067226", "0.066946", "0.066934", "0.066439", "0.066958"], "ylab":["Door publish interval: 10ms", "Door publish interval: 50ms", "Door publish interval: 100ms"]}';
