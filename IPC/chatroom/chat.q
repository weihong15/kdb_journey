system "p 5000"
.u.conn:()
sqBracket:{"[",x,"]"}
.z.ShortT:{"v"$.z.T}
.z.po:{[h].u.conns,:h ; 0N!string[.z.ShortT`]," Somebody just JOINED the room, handle ",string[h]," Person userID: ",string .z.u}
.z.pg:{0N!"Running Sync querry ",";" sv string x; get x}
.u.rooms:()!()
.u.join:{[room].u.rooms[room],:.z.w;"Welcome to the ", string[room]," chat room. You are one of the ",string[count .u.rooms[room]], " room members"}
.u.leaveh:{[room;h] .u.rooms[room]:.u.rooms[room]except h;"You have successfully left the ",string[room]," chat room. Number of people left ",string count .u.rooms[room]}
.u.leave:{[room].u.leaveh[room;.z.w]}
.u.chat:{[room;msg]h:.u.rooms[room]except .z.w; newMsg: sqBracket[string[room]],sqBracket[string[.z.u]]," ",msg;h@\:(0N!;newMsg)}
.z.pc:{[h].u.conns,:h ; 0N!string[.z.ShortT`]," Somebody just LEFT the room, handle ",string[h]," Person userID: ",string .z.u; .u.leaveh[;h]each key .u.rooms}



