//defer sync
//Pinging
//Ask master to send all it workers, ask them get time and return back

getT:{.z.T} //function for workers to call

//Open handle to master
h:hopen 5000

h(getT;`)

