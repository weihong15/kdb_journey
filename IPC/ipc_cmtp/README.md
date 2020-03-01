### Question 3
//Note that there's no short-circuited expression for booleans, so better to put two if statements
```
q)if[0b and (a:3);"rah"] 
q)a
3
q)if[(bc:13) and 0b ;"rah"]
q)bc
13
```
```
q)d
user1| "good_password"
user2| "bad_password"
user3| "rubbish_password"
q).z.pw:{[user;pass]if[user in key d;if[d[user]~pass;:1b]];0b}   
q).z.pw[`user1;"good_password"]
1b
q).z.pw[`user1;"good_password1"] 
0b
q).z.pw[`user1;"bad_password"]   
0b
```
### Question 4
We only allow a list method call
```
h:hopen `::1510:user1:good_password
q)h"a:10"
"not a stored procedure call"
q)h(`dividing;8;5) 
"not a stored procedure call"
q)h(`divide;8;5)
1.6
```
### Question 8
```
/ – Process 1 --/
system "p 5000"
/ – Process 2 --/
q)h"1+5" 
6
q)h(add;7;2)
9
q)h(*;7;2)   
14
q)neg[h](*;7;2) 
/ – Process 1 --/
q)ipcLog
handle IP        username flag  timeTaken message  
---------------------------------------------------
600    127.0.0.1 Weihong  sync  0         1     + 5
600    127.0.0.1 Weihong  sync  0         {x+y} 7 2
600    127.0.0.1 Weihong  sync  0         *     7 2
600    127.0.0.1 Weihong  async 0         *     7 2
```
### Question 9
```
/ – Process 1 --/
system "p 5000"
.z.po:{`dict set x({system["f"]!value each system "f"};`)}
/ – Process 2 --/
q)add:{x+y};minus:{x-y};times:{x*y};divide:{x%y}
q)h:hopen 5000
/ – Process 1 --/
q)dict
add   | {x+y}
divide| {x%y}
minus | {x-y}
times | {x*y}
```