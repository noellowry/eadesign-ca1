echo "SYNC Response Time";
for((i=1;i<=10;i++)); 
do 
  curl http://35.228.112.214:30916/ -s -o /dev/null -w "Output: starttransfer:%{time_starttransfer}s total:%{time_total}\n" ;
  echo %{time_total};
done
echo $sum;
