#!/bin/bash
###################################
#  Part 2.1                       #
#  Measure average response times  #
###################################
DATE=$(date +"%Y%m%d%H%M%S")
TOTAL_TIME=0;
COUNT=200;
AVG_SYNC_RSP=0;
AVG_ASYNC_RSP=0;

#Get SYNC RESPONSE TIME
for((i=1;i<=$COUNT;i++)); 
do 
  # curl to get response time
  curl_result="$(curl http://35.228.112.214:30916/ -s -o /dev/null -w "total:%{time_total}\n")"

  var=$(echo $curl_result | awk -F":" '{print $1, $2}')
  set -- $var
  echo "$1 $2"
  # get total time using bc - binary calc
  TOTAL_TIME=$(bc <<< "scale=6; $TOTAL_TIME + $2")
done
# get average time
AVG_SYNC_RSP=$(bc <<< "scale=6; $TOTAL_TIME/$COUNT")

TOTAL_TIME=0
#Get ASYNC RESPONSE TIME
for((i=1;i<=$COUNT;i++)); 
do 
  curl_result="$(curl http://35.228.112.214:31080/ -s -o /dev/null -w "total:%{time_total}\n")"
  #echo $curl_result 

  var=$(echo $curl_result | awk -F":" '{print $1, $2}')
  set -- $var
  echo "$1 $2"
  TOTAL_TIME=$(bc <<< "scale=6; $TOTAL_TIME + $2")
done
AVG_ASYNC_RSP=$(bc <<< "scale=6; $TOTAL_TIME/$COUNT")

# write output to console
echo "SYNC Average Response Time: `echo "scale=6; $AVG_SYNC_RSP" | bc`";
echo "ASYNC Average Response Time: `echo "scale=6; $AVG_ASYNC_RSP" | bc`";

# call google cloud function
gcloud functions call create-graph --project eadesign-269520 --data '{"filename":"2.1-graph-'"$DATE"'.png", "plottype":"bar", "x":["SYNC", "ASYNC"], "y":["'"$AVG_SYNC_RSP"'", "'"$AVG_ASYNC_RSP"'"], "ylab":"Time in Seconds"}';
# download image
gsutil cp gs://eades_msvcs_nlowry/2.1-graph-$DATE.png graphs
