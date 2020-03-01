// Q3
d:`user1`user2`user3!("good_password";"bad_password";"rubbish_password")
.z.pw:{[user;pass]if[user in key d;if[d[user]~pass;:1b]];0b}
// Q4
add:{x+y};minus:{x-y};times:{x*y};divide:{x%y}
storedProcedure:`add`minus`times`divide
.z.pg:{if[0h = type x;if[x[0] in storedProcedure;:get x]];:"not a stored procedure call"}
//Q8
ipcLog:([] handle:`int$(); IP:`$(); username:`$(); flag:`$(); timeTaken:`long$(); message:());
.z.pg:{time:system "t";`ipcLog insert (.z.w; `$"." sv string "i"$0x0 vs .z.a; .z.u; `sync; time; x); value x};
.z.ps:{`ipcLog insert (.z.w; `$"." sv string "i"$0x0 vs .z.a; .z.u; `async; system "t"; x); value x};
//Q9
.z.po:{`dict set x({system["f"]!value each system "f"};`)}
