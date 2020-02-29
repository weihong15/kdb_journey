// Q3
d:`user1`user2`user3!("good_password";"bad_password";"rubbish_password")
.z.pw:{[user;pass]if[user in key d;if[d[user]~pass;:1b]];0b}
// Q4
add:{x+y};minus:{x-y};times:{x*y};divide:{x%y}
storedProcedure:`add`minus`times`divide
.z.pg:{if[0h = type x;if[x[0] in storedProcedure;:get x]];:"not a stored procedure call"}
