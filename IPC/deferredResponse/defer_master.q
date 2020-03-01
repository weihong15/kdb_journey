system "p 5000"

workerHandles:hopen each 6000 6001 / open handles to worker processes
pending:()!() / keep track of received results for each clientHandle
/ this example fn joins the results when all are received from the workers
reduceFunction: ::

/ each worker calls this with (0b;result) or (1b;errorString) 
callback:{[clientHandle;result] 
 pending[clientHandle],:enlist result; / store the received result
 / check whether we have all expected results for this client
 if[count[workerHandles]=count pending clientHandle; 
   / test whether any response (0|1b;...) included an error
   isError:0<sum pending[clientHandle][;0]; 
   result:pending[clientHandle][;1]; / grab the error strings or results
   //a::result;
   / send the first error or the reduced result
   r:$[isError;{first x where 10h=type each x};reduceFunction]result; 
   -30!(clientHandle;isError;r); 
   pending[clientHandle]:(); / clear the temp results
 ]
 }

//query come in from client, 
.z.pg:{[query]
  remoteFunction:{[clntHandle;query]
    neg[.z.w](`callback;clntHandle;@[(0b;)value@;query;{[errorString](1b;errorString)}])   //worker executive the query, and return back
  };
  neg[workerHandles]@\:(remoteFunction;.z.w;query); / send the query to each worker //(function, clientHandle,query)
  -30!(::); / defer sending a response message i.e. return value of .z.pg is ignored
 }