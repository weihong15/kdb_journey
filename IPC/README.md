References use, Month 1 resource, Q4M  
Note to self, Clients connect to server(Master)

Table of Contents
=================

- [Table of Contents](#table-of-contents)
  - [Listening on a port](#listening-on-a-port)
  - [Check Listening Port](#check-listening-port)
  - [Opening and closing handle to another location](#opening-and-closing-handle-to-another-location)
  - [Open and close connections (.z.po .z.pc)](#open-and-close-connections-zpo-zpc)
  - [Port Get(Synchronous) and Port Set(Async) .z.pg  .z.ps](#port-getsynchronous-and-port-setasync-zpg-zps)
  - [How to do a sync/async call](#how-to-do-a-syncasync-call)
  - [Different method for sync/async call](#different-method-for-syncasync-call)
  - [Expunging/Removing Values](#expungingremoving-values)
  - [Executing across multiple handles](#executing-across-multiple-handles)
  - [.z namespace for IPC](#z-namespace-for-ipc)
  - [News agency case study](#news-agency-case-study)

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
When process die, all handle close too
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
Positive is sync while negative handles are async
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

## Different method for sync/async call
Method 1: string method
```
h"a:10"         //defining 10 across the handle
```
Method 2: symbol method, only useful for getting values
```
q)h`a         //retrieve value of a form across the server
10
```
Method 3: list method
```
q)h(`dividing;8;5)   //dividing must exist on the server, so add symbol
1.6
q)h("dividing";8;5)     //same as the symbol of it, exist on server
1.6
q)h(dividing;8;5)    //will error out if dividing does not exist locally. i.e. local call
```

## Expunging/Removing Values

```
\x .z.po     \\this will expunge the value, default no actions
\x .z.ps     \\this will expunge the value too, default .z.ps:value
```

## Executing across multiple handles
process 1: main or client  
process 2,3,4: listening on port 5001,5002,5003 respectively , server
```
q)h:hopen each 5001 5002 5003
q)h
3 4 5i
q)h[0]"a:1"         //define a in first process only
q)h@\:"a:15"        //define a:15 on all processes @\:
::
::
::
q)h@\:"a+15"            //sync call across handles
20 20 20
q)neg[h]@\:"a:15"       //async call across handles
::
::
::
q)neg[h]@\:(0N!;"Hello")    //async call using list method, all other process print hello
::
::
::
```

## .z namespace for IPC
.z.w will normally return 0, if triggered by other process, return handle number //on server //even if nested function, but called by .z.pg,.z.ps will work
.z.W will return each handle opened for that process, and the data left to transmit //can be called by client or server

## News agency case study
Imagine u are a news agency and you have different users subscribing to you  
Process 1: News agency
Process 2,3: Users
```
/ – Process 1 --/
\p 5000
.u.news:()!()           /dictionary, (topics)!(handles)
.u.register:{[topic] .u.new[topic],:.z.w;}          /for users to call to register for news
.z.pc:{[h] .u.news:.u.news except\:h}               /if handle close by user(forcefully or intentionally), remove from news

/ – Process 2 --/
q)h:hopen 5000          //handle 10
q)h(`.u.register;`sport)

/ – Process 3 --/
q)h:hopen 5000          //handle 15
q)h(`.u.register;`sport)
q)h(`.u.register;`weather)

/ – Process 1 --/
q).u.news
sport   | 10 15i
weather | 15i

q)msg:"wa lao, refree kayu for soccer"
q).u.news[`sport]@\:(0N!;msg)           //msg will be printed to both Process 2,3
```
