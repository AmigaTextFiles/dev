	include	profiler.i
	
Do	ProfilerInit.TEstApP!	Ev1,Ev2,Ev3,More,Stupid

	movea.l	4.w,a6
	jsr	_LVOForbid(a6)
	jsr	_LVODisable(a6)
	
	bsr	TestThat

	movea.l	4.w,a6
	jsr	_LVOEnable(a6)
	jsr	_LVOPermit(a6)

	ProfilerLog	
	ProfilerClose
	rts

		cnop	0,4
TestThat	moveq.l	#10,d5
.do
		ProfilerCycle
		moveq.l	#127,d6
		bra.b	.entry
.loop		clr.l	-(a7)
		clr.l	-(a7)
		clr.l	-(a7)
		clr.l	-(a7)
		clr.l	-(a7)
		clr.l	-(a7)
		clr.l	-(a7)
		clr.l	-(a7)
		lea.l	32(a7),a7
		dbra	d7,.loop
.entry		moveq.l	#127,d7
		dbra	d6,.loop
		
		ProfilerEvent	;ev1

		moveq.l	#127,d6
		bra.b	.entry2
.loop2		lea.l	-32(a7),a7
		clr.l	(a7)+
		clr.l	(a7)+
		clr.l	(a7)+
		clr.l	(a7)+
		clr.l	(a7)+
		clr.l	(a7)+
		clr.l	(a7)+
		clr.l	(a7)+
		dbra	d7,.loop2
.entry2		moveq.l	#127,d7
		dbra	d6,.loop2
		ProfilerEvent	;ev2
		
		ProfilerEnd
		dbra	d5,.do
		rts
	
