#!/bin/bash
TOTAL_TIME=0;
COUNT=2;
SECS=0;
AVG_SECS=0;
SECCON_SYNC_AVG=0;
DOOR1_SYNC_AVG=0;
DOOR2_SYNC_AVG=0;
SECCON_ASYNC_AVG=0;
DOOR1_ASYNC_AVG=0;
DOOR2_ASYNC_AVG=0;
#################################
#  Part 2.3                     #
#################################
kill_pod(){
  for((i=1;i<=$COUNT;i++));
  do
    kubectl delete pod -l app="$1" -n ca-dev
    sleep 10

    CREATE_TIME=$(kubectl get pod -l app=$1 -n ca-dev -o json | jq -r '.items[0].metadata.creationTimestamp'| awk -FT '{print $1} {print $2}'| awk -FZ '{print $1}')
    START_TIME=$(kubectl get pod -l app=$1 -n ca-dev -o json | jq -r '.items[0].status.containerStatuses[0].state.running.startedAt'| awk -FT '{print $1} {print $2}'|awk -FZ '{print $1}')

    SECS=$(bc <<< "$(date -d "$START_TIME" +%s) - $(date -d "$CREATE_TIME" +%s)")
    TOTAL_TIME=$(bc <<< "$TOTAL_TIME + $SECS")
  done
  AVG_SECS=$(bc <<< "scale=2; $TOTAL_TIME/$COUNT")
  #echo "AVG:$AVG_SECS"
  
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

echo "Average SYNC Recovery times - seccon: $SECCON_SYNC_AVG door1: $DOOR1_SYNC_AVG door2: $DOOR2_SYNC_AVG"
echo "Average ASYNC Recovery times - seccon: $SECCON_ASYNC_AVG door1: $DOOR1_ASYNC_AVG door2: $DOOR2_ASYNC_AVG"

gcloud functions call create-graph --project eadesign-269520 --data '{"filename":"2.3-graph-'"$DATE"'.png", "plottype":"bar", "x":["seccon-sync","door1-sync","door2-sync","seccon-async","door1-async","door2-async"], "y":["'"$SECCON_SYNC_AVG"'","'"$DOOR1_SYNC_AVG"'","'"$DOOR2_SYNC_AVG"'","'"$SECCON_ASYNC_AVG"'","'"$DOOR1_ASYNC_AVG"'","'"$DOOR2_ASYNC_AVG"'"], "ylab": "Avg startup time in seconds"}';
