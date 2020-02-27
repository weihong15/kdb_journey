# Learning kdb

References use, Month 1 resource, Q4M
Table of Contents
=================
* Listening on a port



## Listening on a port
``` Option 1: specifiy at command line
q -p 1510       // this will start q and listen on port 1510
```
```Option 2:speicify within Q session
\p 1510
```

## Check Listening Port
``` q)\p
1510
```
## Opening handle to another location
```
/ – Process 1 --/ 
q)\p 5000
q).u.conns:()
q).z.po:{[h].u.conns,:h}					// logic adds handles to a list when they connect
q).z.pc:{[h].u.conns:.u.conns except h}		// and removes them when they disconnect

/ – Process 2 --/							// open a connection from a second process
q)h:hopen 5000

```

## Open and close connections (.z.po .z.pc)
``` 
.u.conns:() //empty list
.z.po:{0N!"Connection opened on handle ",string x; .u.conns,:x}   //the handle will be passed as an arguement
.z.pc:{0N!"Connection closed on handle ",string x; .u.conns:.u.conns except x}
```

