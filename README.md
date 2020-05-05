# eadesign-ca1 
# Part 1

Part one builds on the labs provided. It uses the door example for both sync and async, modifying the news app from lab2 for the sync part.

Sync Version
http://35.228.112.214:30916/

![alt text](https://github.com/noellowry/eadesign-ca1/raw/master/images/sync.png "Sync")

Async Version
http://35.228.112.214:31080/

![alt text](https://github.com/noellowry/eadesign-ca1/raw/master/images/async.png "Async")

# Part 2

For producing report and graphs, scripts and google cloud function using provided python script are used.
Graphs are stored in /graphs

## 2.1

Script meaures avaerage response time for Sync and Async over 200 iterations. Outputs to console and creates graph using cloud function

![alt text](https://github.com/noellowry/eadesign-ca1/raw/master/images/2.1-console.png "2.1 Console Output")

![alt text](https://github.com/noellowry/eadesign-ca1/raw/master/graphs/2.1-graph-20200505172938.png "2.1 Graph")



## 2.2

Values were manually updated in manifest yaml files. kubectl replace and apply was used to update deployments. Then run script 100 times and get average response time.
The json for creating graph was manually created, and then call the graph cloud function via Postman

![alt text](https://github.com/noellowry/eadesign-ca1/raw/master/images/2.2-postman.png "2.2 Postman")
![alt text](https://github.com/noellowry/eadesign-ca1/raw/master/graphs/2.2-graph-from-postman.png "2.2 Graph")


## 2.3

Script kills pods for both sync and async. Does this 5 times to get average recovery time.
Average recovery times are printed to console and then graph created using cloud function.

![alt text](https://github.com/noellowry/eadesign-ca1/raw/master/images/2.3-console.png "2.3 Console Output")

![alt text](https://github.com/noellowry/eadesign-ca1/raw/master/graphs/2.3-graph-20200505173857.png "2.3 Graph")

