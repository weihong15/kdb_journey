# Learning kdb

References use, Month 1 resource, Q4M
Table of Contents
=================

* [Listening on a port](#listening-on-a-port)
* [Check what port is it listening to](#check-listening-port)
* [How to open handle and close handle](#opening-and-closing-handle-to-another-location)
* [.z.po .z.pc](#open-and-close-connections-zpo-zpc)
* [synchronous and async actions](#port-getsynchronous-and-port-setasync-zpg--zps)
* [How to do an sync/async call](#how-to-do-a-syncasync-call)


## Listening on a port

``` 
Option 1: specifiy at command line
q -p 1510       // this will start q and listen on port 1510
```
```
Option 2:speicify within Q session
\p 1510
```

## Check Listening Port

```
q)\p
1510
```

## Opening and closing handle to another location

```
/ – Process 1 --/
q)\p 5000
q).u.conns:()
q).z.po:{[h].u.conns,:h}					// logic adds handles to a list when they connect
q).z.pc:{[h].u.conns:.u.conns except h}		// and removes them when they disconnect

/ – Process 2 --/							// open a connection from a second process
q)h:hopen 5000
q)h:hclose h                                // close a connection

```

## Open and close connections (.z.po .z.pc)

``` 
.u.conns:() //empty list
.z.po:{0N!"Connection opened on handle ",string x; .u.conns,:x}   //the handle will be passed as an arguement
.z.pc:{0N!"Connection closed on handle ",string x; .u.conns:.u.conns except x}
```

## Port Get(Synchronous) and Port Set(Async) .z.pg  .z.ps

```
.z.pg:{0N!"Running Sync querry ",string x; get x}
.z.ps:{0N!"Running async querry ",string x;get x}
```

## How to do a sync/async call

```
/ – Process 1 --/
q)\p 5000
q)add:{x+y}
q).z.pg:{15}

/ – Process 2 --/
q)h:hopen 5000
q)h"add[4;5]"				// Synchronous call
15 							// Not 9 as expected!

/ – Process 1 --/
q).z.pg:{get x}				// If I want to run the incoming query I just do get x (or value x)

/ – Process 2 --/
q)h"add[4;5]"				// Synchronous call
9							// This actually runs the query I send

/ – Process 1 --/
q)\x .z.pg					// If I expunge my custom definition of .z.pg
q).z.pg
'.z.pg						// It's gone, q doesn't find any custom definitions

/ – Process 2 --/
q)h"add[4;5]" 
9							// Still runs fine because q runs get under the covers by default

/ – Process 1 --/
q)\p 5000
q).z.ps:{}

/ – Process 2 --/
q)h:hopen 5000
q)neg[h]"a:10"				// asynch call

/ – Process 1 --/
q)a
'a							// a has not been defined, because .z.ps didn't run my call

/ – Process 1 --/
q).z.ps:{a::5}

/ – Process 2 --/
q)neg[h]"a:10" 

/ – Process 1 --/
q)a							// a has been set to 5, not 10 like I asked
5

/ – Process 1 --/
q).z.ps:get					// I could also have done .z.ps:{get x} or expunged using \x

/ – Process 2 --/
q)neg[h]"a:10" 

/ – Process 1 --/
q)a 
10
```
