h:hopen 5000;	//variable please change												
join:{[room]h(`.u.join;room)}
leave:{[room]h(`.u.leave;room)}
chat:{[room;msg]neg[h](`.u.chat;room;msg);}