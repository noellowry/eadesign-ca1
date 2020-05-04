#!/bin/bash
DATE=$(date +"%Y%m%d%H%M%S")
total_time=0;
COUNT=2;
SECS=0;
AVG_SECS=0;
SECCON_SYNC_AVG=0;
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
    total_time=$(bc <<< "$total_time + $SECS")
  done
  AVG_SECS=$(bc <<< "scale=2; $total_time/$COUNT")
  echo "AVG:$AVG_SECS"
  
  case $1 in
    seccon-sync)
      SECCON_SYNC_AVG=$AVG_SECS
      ;;
    *)
      echo -n "unknown"
      ;;
  esac      
}

kill_pod seccon-sync
#VAR=$(kill_pod seccon-sync | awk -F '  *: ' '$1=="Mode"{print $2}')
#echo "$VAR"

gcloud functions call create-graph --project eadesign-269520 --data '{"filename":"2.3-graph-'"$DATE"'.png", "plottype":"bar", "x":["seccon-sync"], "y":["'"$SECCON_SYNC_AVG"'"], "ylab": "Avg startuptime in seconds"}';
