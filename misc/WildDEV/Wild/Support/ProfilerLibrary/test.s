
		include	PyperMacro.i
		include	exec/exec_lib.i
		include	profiler.i

profilethis	moveq.l	#0,d0
		lea.l	proname,a1
		Exec
		Call	OpenLibrary
		move.l	d0,_ProfilerBase
		
		movea.l	d0,a6
		lea.l	ct,a0
		Call	CreateProfilerHandler
		move.l	d0,prh
				
		bsr	TestThat

		movea.l	_ProfilerBase,a6
		move.l	prh,a0
		suba.l	a1,a1
		Call	CreateLog
		
		movea.l	_ProfilerBase,a6
		move.l	prh,a0
		Call	DeleteProfilerHandler
		
		move.l	a6,a1
		Exec
		Call	CloseLibrary
		moveq.l	#0,d0
		rts

TestThat	moveq.l	#10,d7
		movea.l	_ProfilerBase,a6
.looping	move.l	prh,a0
		Call	NewCycle

		move.l	#60000,d0
.loop1		clr.l	-(a7)
		clr.l	(a7)+
		dbra	d0,.loop1
		move.l	prh,a0
		Call	EventReached

		move.l	#60000,d0
.loop2		move.l	d1,d2
		move.l	d2,-(a7)
		move.l	d2,d3
		move.l	d3,-(a7)
		move.l	d3,d4
		move.l	d4,(a7)+
		move.l	d4,d5
		move.l	d5,(a7)+
		dbra	d0,.loop2
		move.l	prh,a0
		Call	EventReached

		move.l	#60000,d0
.loop3		move.l	d0,d1
		add.l	d1,d1
		move.l	d1,-(a7)
		add.l	d1,(a7)+
		dbra	d0,.loop3
		move.l	prh,a0
		Call	EventReached
		move.l	prh,a0
		Call	EndCycle
		dbra	d7,.looping
		rts		

_ProfilerBase	dc.l	0
prh		dc.l	0
ct		dc.l	PRF_Name,tname
		dc.l	PRF_EventsArray,ea
		dc.l	0
ea		dc.l	ev1n,ev2n,ev3n,0
proname		dc.b	'profiler.library',0		
tname		dc.b	'Testing...',0
ev1n		dc.b	'Event1',0
ev2n		dc.b	'Event2',0
ev3n		dc.b	'Event3',0

