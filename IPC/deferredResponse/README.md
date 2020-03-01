References  used:
https://code.kx.com/v2/kb/deferred-response/  
https://kx.com/blog/kdb-q-insights-deferred-response/  
Note that -30! is only avaliable after kdb 3.6

## Example 1

Problem: clients want to ping two busy processes. But the client only have access to a gw but not directly with the two processes. The gw is mission critical and we will not want it to be idling while waiting. The gw has open handles to both the processes

Solution:  
1. Client make Sync call to the gateway
2. The GW receive the sync call. Edit .z.pg such that GW will make two async calls to the busy processes, and .z.pg will exit with -30!(::)
3. Note that -30!(::) will not cause the GW to be "busy waiting", but able to return the sync call in the future
4. Each of the two processes will receive an async call from GW. The two processes will perform the query, or error message as either (0b;query_returned) or (1b;"error message")
5. After performing the query, the processes will make an async callback to the GW, passing on the result
6. In the GW, the callback will append the result and wait for all callback to be in
7. if all processes has replied, it will join the result together and call -30!(clientHandle;0b;res)  //-30!(handle;isError;msg)  //note that msg does not have to be string
8. The client will receive the result through the sync call(1) in has make earlier

Code Review
```
//Point number 2; async call to the busy processes
remoteFunction:{[clntHandle;query]
    neg[.z.w](`callback;clntHandle;@[(0b;)value@;query;{[errorString](1b;errorString)}])   //worker executive the query, and return back
neg[workerHandles]@\:(remoteFunction;.z.w;query); / send the query to each worker //(function, clientHandle,query)
```
The remoteFunction can be define on the two proceses, but it is easier to define in the GW and pass it on.(else u need to define twice(n times))  
The last line of above code, at it's first step, is asking the processes to run value(remoteFunction;.z.w;query)  //this first .z.w refers to handle back to client  
When the processes are free, it will run remoteFunction, the .z.w in the remote function refers to the handle back to the GW and not the client  
it will make an async call to the GW, running `callback function, with 2 arguements, a) handle of GW to client b)either (0b;results of query) or (1b;error happen during query)

```
pending:()!()
callback:{[clientHandle;result] 
 pending[clientHandle],:enlist result; / store the received result
 / check whether we have all expected results for this client
 if[count[workerHandles]=count pending clientHandle; 
   / test whether any response (0|1b;...) included an error
   isError:0<sum pending[clientHandle][;0]; 
   result:pending[clientHandle][;1]; / grab the error strings or results
   //a::result;
   / send the first error or the reduced result
   r:$[isError;{first x where 10h=type each x};::]result; 
   -30!(clientHandle;isError;r); 
   pending[clientHandle]:(); / clear the temp results
 ] }
 ```
Now we are back to the GW, with processes making an async call with callback function  
pending is a dictionary, where the key is clientHandle, and value as information needed to be given to client(or part of it, can be parse before -30!)  
we first append the results we have gotten to pending  
once all information from all processes has been receive we can proceed to part 2 of callback  
we check whether there's at least one error  
next, we get the second column of data, all result or some error(remember that our data is stored as (0b;result of query1);(0b;result of query2);(1b;errorMsg))  
We next join all the results together or return the first error(join results by reduceFunction)  
we return the joined result or first error back to the client using -30!  
we will clear the pending queue




