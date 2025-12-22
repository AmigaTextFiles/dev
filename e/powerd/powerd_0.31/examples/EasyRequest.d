// simple requesters

OPT OSVERSION=37

PROC main()
	request('Your selection: \d','what do i care ...',[request('Ahem...','Sure|Nope',NIL)])
ENDPROC

PROC request(body,gadgets,args)(LONG) IS EasyRequestArgs(0,[20,0,0,body,gadgets],0,args)
