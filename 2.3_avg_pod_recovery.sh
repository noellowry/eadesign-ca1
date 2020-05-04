#!/bin/bash
#################################
#  Part 2.3                     #
#  Measure recovery times       #
#################################
DATE=$(date +"%Y%m%d%H%M%S")
COUNT=1;
SECS=0;
SECCON_SYNC_AVG=0
DOOR1_SYNC_AVG=0
DOOR2_SYNC_AVG=0
SECCON_ASYNC_AVG=0
DOOR1_ASYNC_AVG=0
DOOR2_ASYNC_AVG=0

# kill pod function
kill_pod(){
  # initialise values
  TOTAL_TIME=0
  AVG_SECS=0

  # iterate based on COUNT
  for((i=1;i<=$COUNT;i++));
  do
    # delete pod
    kubectl delete pod -l app="$1" -n ca-dev
    # give pod chance to heal
    sleep 5

    # extract times from json
    CREATE_TIME=$(kubectl get pod -l app=$1 -n ca-dev -o json | jq -r '.items[0].metadata.creationTimestamp'| awk -FT '{print $1} {print $2}'| awk -FZ '{print $1}')
    START_TIME=$(kubectl get pod -l app=$1 -n ca-dev -o json | jq -r '.items[0].status.containerStatuses[0].state.running.startedAt'| awk -FT '{print $1} {print $2}'|awk -FZ '{print $1}')

    # use inbuilt date function to convert and calculate time taken
    SECS=$(bc <<< "$(date -d "$START_TIME" +%s) - $(date -d "$CREATE_TIME" +%s)")
    TOTAL_TIME=$(bc <<< "$TOTAL_TIME + $SECS")
  done
  # get average
  AVG_SECS=$(bc <<< "scale=2; $TOTAL_TIME/$COUNT")
  
  # assign average values to variables
  case $1 in
    seccon-sync)
      SECCON_SYNC_AVG=$AVG_SECS
      ;;
    door1-sync)
      DOOR1_SYNC_AVG=$AVG_SECS
      ;;
    door2-sync)
      DOOR2_SYNC_AVG=$AVG_SECS
      ;;
    seccon)
      SECCON_ASYNC_AVG=$AVG_SECS
      ;;
    door1)
      DOOR1_ASYNC_AVG=$AVG_SECS
      ;;
    door2)
      DOOR2_ASYNC_AVG=$AVG_SECS
      ;;
    *)
      echo -n "unknown"
      ;;
  esac      
}

# Kill SYNC Pods
kill_pod seccon-sync
kill_pod door1-sync
kill_pod door2-sync
# Kill ASYNC Pods
kill_pod seccon
kill_pod door1
kill_pod door2

# output results
echo "Average SYNC Recovery times - seccon: $SECCON_SYNC_AVG door1: $DOOR1_SYNC_AVG door2: $DOOR2_SYNC_AVG"
echo "Average ASYNC Recovery times - seccon: $SECCON_ASYNC_AVG door1: $DOOR1_ASYNC_AVG door2: $DOOR2_ASYNC_AVG"

# call google cloud function
gcloud functions call create-graph --project eadesign-269520 --data '{"filename":"2.3-graph-'"$DATE"'.png", "plottype":"bar", "x":["seccon-sync","door1-sync","door2-sync","seccon-async","door1-async","door2-async"], "y":["'"$SECCON_SYNC_AVG"'","'"$DOOR1_SYNC_AVG"'","'"$DOOR2_SYNC_AVG"'","'"$SECCON_ASYNC_AVG"'","'"$DOOR1_ASYNC_AVG"'","'"$DOOR2_ASYNC_AVG"'"], "xlab":["seccon-sync","door1-sync","door2-sync","seccon-async","door1-async","door2-async"], "ylab": "Avg startup time in seconds"}';
