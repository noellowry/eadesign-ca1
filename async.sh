echo "ASYNC Response Time";
for((i=1;i<=10;i++)); 
do 
  curl http://35.228.112.214:31080/ -s -o /dev/null -w "Output: starttransfer:%{time_starttransfer}s total:%{time_total}\n" ; 
done
