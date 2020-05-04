#!/bin/bash
DATE=$(date +"%Y%m%d%H%M%S")
total_time=0;
count=5;
avg_sync_rsp=0;
avg_async_rsp=0;
#################################
#  Part 2.3                     #
#################################
kubectl delete pod -l app=seccon-sync -n ca-dev 
# kubectl delete pod -l app=door1-sync -n ca-dev 
# kubectl delete pod -l app=door2-sync -n ca-dev 

CREATE_TIME=$(kubectl get pod -l app=seccon-sync -n ca-dev -o json | jq -r '.items[0].metadata.creationTimestamp'| awk -FT '{print $2}'|awk -FZ '{print $1}')
START_TIME=$(kubectl get pod -l app=seccon-sync -n ca-dev -o json | jq -r '.items[0].status.containerStatuses[0].state.running.startedAt'| awk -FT '{print $2}'|awk -FZ '{print $1}')

echo $CREATE_TIME;
echo $START_TIME;
# kubectl delete pod -l app=seccon -n ca-dev 
# kubectl delete pod -l app=door1 -n ca-dev 
# kubectl delete pod -l app=door2 -n ca-dev 

# kubectl get all -n ca-dev

#gcloud functions call create-graph --project eadesign-269520 --data '{"filename":"2.3-graph-'"$DATE"'.png", "plottype":"line", "x":["2000", "10000", "20000"], "y":["0.066996","00.067789","0.067247", "0.066995", "0.067226", "0.066946", "0.066934", "0.066439", "0.066958"], "ylab":["Door publish interval: 10ms", "Door publish interval: 50ms", "Door publish interval: 100ms"]}';
