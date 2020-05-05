#!/bin/bash
#################################
#  Part 2.2                     #
#################################
# DATE=$(date +"%Y%m%d%H%M%S")
# total_time=0;
# count=5;
# avg_sync_rsp=0;
# avg_async_rsp=0;

# #Get ASYNC RESPONSE TIME
# for((i=1;i<=$count;i++)); 
# do 
#   curl_result="$(curl http://35.228.112.214:31080/ -s -o /dev/null -w "total:%{time_total}\n")"
#   #echo $curl_result 

#   var=$(echo $curl_result | awk -F":" '{print $1, $2}')
#   set -- $var
#   echo "$1 $2"
#   total_time=$(bc <<< "scale=6; $total_time + $2")
# done
# avg_async_rsp=$(bc <<< "scale=6; $total_time/$count")

# echo "ASYNC Average Response Time: `echo "scale=6; $avg_async_rsp" | bc`";

gcloud functions call create-graph --project eadesign-269520 --data '{"filename":"2.2-graph-'"$DATE"'.png", "plottype":"line", "x":["2000", "10000"], "y":["0.06696", "0.067789", "0.06695", "0.067226, "0.066934", "0.066439"], "ylab":["Poll 10ms", "Poll 20ms", "Poll 50ms"}';
# download image
gsutil cp gs://eades_msvcs_nlowry/2.2-graph-$DATE.png graphs
