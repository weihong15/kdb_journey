# Simple chat room system

Ability to join an "interest club" room and chat with everybody in that room

```
// -- Process Master/Server -- //
$ q .\chat.q

// -- Process 1 -- //
q .\client.q 
q)join`football
"Welcome to the football chat room. You are one of the 1 room members"
q)join`rugby
"Welcome to the rugby chat room. You are one of the 1 room members"

// -- Process 2 -- //
$ q client.q
q)
q)join`football
"Welcome to the football chat room. You are one of 2 room members"
q)join`rugby
"Welcome to the rugby chat room. You are one of 2 room members"

// -- Process 3 -- //
$ q client.q
q)
q)join`football
"Welcome to the football chat room. You are one of 3 room members"
q)join`rugby
"Welcome to the rugby chat room. You are one of 3 room members"

// -- Process Master/Server -- //
.u.rooms
football| 620 624 260
rugby   | 620 624 260

// -- Process 3 -- //
q)chat[`football;"hey fellas"]
// -- Process 1 -- //
"[football][kieran] hey fellas"
// -- Process 2 -- //
"[football][kieran] hey fellas"
// -- Process 3 -- // 						// the sender should not receive the message back
q)leave`football
"You have successfully left the football chat room"
q)leave`rugby
"You have successfully left the rugby chat room"

// -- Process Master/Server -- //
//whole log in server
q)"10:55:52 Somebody just JOINED the room, handle 620 Person userID: Weihon0 Person userID: Weihong"
"10:55:54 Somebody just JOINED the room, handle 624 Person userID: Weihong"
Person userID: Weihong"
"10:56:13 Somebody just JOINED the room, handle 260 Per
Person userID: Weihong"
"Running Sync querry .u.join;football"
"Running Sync querry .u.join;football"
"Running Sync querry .u.join;football"
"Running Sync querry .u.join;rugby"
"Running Sync querry .u.join;rugby"
"Running Sync querry .u.join;rugby"
.u.rooms
football| 620 624 260
rugby   | 620 624 260
q)"Running Sync querry .u.leave;football"
"Running Sync querry .u.leave;rugby"
"10:57:57 Somebody just LEFT the room, handle 260 Persorson userID: Weihong"
```