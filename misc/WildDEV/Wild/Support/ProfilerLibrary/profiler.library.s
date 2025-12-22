
		include PyperLibMaker.i
		include	PyperMacro.i
		include	profiler.i
		include	devices/timer_lib.i
		include	exec/memory.i
		include	utility/utility_lib.i
		include	devices/timer.i

		output	libs:profiler.library

		Lib	profiler,1,0,20.11.1998,prob_SIZEOF+128

		Lib	FUNCTIONS
		Lib	OpenLib
		Lib	CloseLib
		Lib	ExpugneLib
		Lib	ExtFuncLib

		Lib	CreateProfilerHandler
		Lib	DeleteProfilerHandler
		Lib	AddEvent
		Lib	RemEvent
		Lib	NewCycle
		Lib	EventReached
		Lib	EndCycle
		Lib	CreateLog

		Lib	CODE

		Lib	Init
		exg	a0,d0
		move.l	d0,LIB_SIZE(a0)
		
		movem.l	d0/d1/a0/a1/a5/a6,-(a7)
		movea.l	a0,a5
		movea.l	4.w,a6
		lea.l	utyname,a1
		moveq.l	#36,d0
		Call	OpenLibrary
		move.l	d0,prob_UtilityBase(a5)
		beq.b	.fail
		lea.l	dosname,a1
		moveq.l	#36,d0
		Call	OpenLibrary
		move.l	d0,prob_DOSBase(a5)
		beq.b	.fail
	
.fail		movem.l	(a7)+,d0/d1/a0/a1/a5/a6		; if Z flag, fail!
		beq.b	.fail2
		exg	a0,d0
		bra.b	.ok
.fail2		moveq.l	#0,d0
.ok		rts

		Lib	OpenLib
		add.w	#1,LIB_OPENCNT(a6)
		bset	#LIBB_DELEXP,LIB_FLAGS(a6)	; MODULES DEFAULT ARE WANTED TO FREE THEIR MEMORY WHEN CLOSED SO THE EXPUGNE FLAG IS SET ,USUALLY. CLEAR IT ONLY IF REALLY NEEDED.
				
		move.l	a6,d0
		rts

		Lib	CloseLib
		subq.w	#1,LIB_OPENCNT(a6)
		bne.b	ExtFuncLib
		btst	#LIBB_DELEXP,LIB_FLAGS(a6)
		beq.b	ExtFuncLib

		Lib	ExpugneLib
		movem.l	d2/a5/a6,-(sp)
		tst.w	LIB_OPENCNT(a6) 
		bne.b	.still_openned

		movem.l	a5/a6,-(a7)
		movea.l	a6,a5
		Exec
		movea.l	prob_UtilityBase(a5),a1
		Call	CloseLibrary
		movea.l	prob_DOSBase(a5),a1
		Call	CloseLibrary
		movem.l	(a7)+,a5/a6

		move.l	LIB_SIZE(a6),d2
		move.l	a6,a5
		move.l	4.w,a6
		move.l	a5,a1
		jsr	_LVORemove(a6)
		move.l	a5,a1
		moveq	#0,d0
		move.w	LIB_NEGSIZE(a5),d0
		sub.w	d0,a1
		add.w	LIB_POSSIZE(a5),d0
		jsr	_LVOFreeMem(a6)
		move.l	d2,d0
		movem.l	(sp)+,d2/a5/a6
		rts
.still_openned
		Lib	ExtFuncLib
		moveq	#0,d0
		rts

**************************************************************************************
**************************************************************************************
** The real code...

		Lib	CreateProfilerHandler 	; a0:tags
		movem.l	d2/a2-a6,-(a7)
		suba.l	a3,a3
		movea.l	a6,a5			; a5:probase
		Exec
		movea.l	a0,a2			; a2:tags
		moveq.l	#MEMF_ANY,d0
		move.l	#1024,d1
		move.l	#768,d2
		Call	CreatePool
		move.l	d0,d2			; d2:pool
		beq	.fail
		moveq.l	#ph_SIZEOF,d0
		movea.l	d2,a0
		Call	AllocPooled
		movea.l	d0,a3			; a3:ph
		tst.l	d0
		beq	.fail
		move.l	d2,ph_Pool(a3)

		Call	CreateMsgPort
		move.l	d0,ph_TimerMSG(a3)
		movea.l	d0,a0
		moveq.l	#IOTV_SIZE,d0
		Call	CreateIORequest
		move.l	d0,ph_TimerIO(a3)
		lea.l	timername,a0
		movea.l	d0,a1
		moveq.l	#0,d0
		move.l	d0,d1
		Call	OpenDevice
		tst.l	d0
		bne	.fail
		moveq.l	#-1,d1
		movea.l	ph_TimerIO(a3),a0
		move.l	IO_DEVICE(a0),ph_TimerBase(a3)

		move.l	prob_UtilityBase(a5),a6		
		GetTagData	PRF_Name,unp,a2
		move.l	d0,ph_Name(a3)
		GetTagData	PRF_Output,0,a2
		move.l	d0,ph_Output(a3)
		clr.l	ph_Cycles(a3)
		lea.l	ph_EventList(a3),a0
		NEWLIST	a0
		
		GetTagData	PRF_EventsArray,0,a2
		tst.l	d0
		beq.b	.nar
		movea.l	d0,a4
		clr.l	-(a7)
		clr.l	-(a7)
		movea.l	a5,a6			; probase!
		move.l	#PRF_Name,-(a7)		; simulated tagitem for addevent 
		bra.b	.arentry
.arloop		move.l	a3,a0
		move.l	d0,4(a7)
		movea.l	a7,a1
		bsr	AddEvent
.arentry	move.l	(a4)+,d0
		bne.b	.arloop
.nar		addq.l	#8,a7
		addq.l	#4,a7
		move.l	a3,d0
		
		movem.l	(a7)+,d2/a2-a6
		rts
.fail		move.l	a3,a0
		movem.l	(a7)+,d2/a2-a6

		Lib	DeleteProfilerHandler
		move.l	a0,d0
		beq.b	.no
		movem.l	a2/a6,-(a7)
		Exec
		movea.l	a0,a2
		movea.l	ph_TimerIO(a2),a1
		Call	CloseDevice
		movea.l	ph_TimerIO(a2),a0
		Call	DeleteIORequest
		movea.l	ph_TimerMSG(a2),a0
		Call	DeleteMsgPort
		movea.l	ph_Pool(a2),a0
		Call	DeletePool
		movem.l	(a7)+,a2/a6
.no		rts

		Lib	AddEvent
		movem.l	a2-a6,-(a7)
		movea.l	a6,a5		; a5:probase
		Exec
		movea.l	a1,a2		; a2:tags
		movea.l	a0,a3		; a3:ph
		movea.l	ph_Pool(a3),a0
		moveq.l	#pe_SIZE,d0
		Call	AllocPooled
		move.l	d0,a4		; a4:pe
		tst.l	d0
		beq.b	.fail
		movea.l	prob_UtilityBase(a5),a6
		GetTagData	PRF_Name,une,a2
		move.l	d0,pe_Name(a4)		
		clr.l	pe_Sum(a4)
		clr.l	pe_Sum+4(a4)
		movea.l	a4,a1
		lea.l	ph_EventList(a3),a0
		ADDTAIL
		move.l	a4,d0
.fail		movem.l	(a7)+,a2-a6
		rts
		
		Lib	RemEvent	; a0:ph,a1:pe
		movem.l	a3/a6,-(a7)
		movea.l	a0,a3
		move.l	a1,d0
		REMOVE
		movea.l	d0,a1
		movea.l	ph_Pool(a3),a0
		moveq.l	#pe_SIZE,d0
		Call	FreePooled
		movem.l	(a7)+,a3/a6
		rts

		Lib	NewCycle	; a0:ph
		move.l	a6,-(a7)
		move.l	ph_EventList+MLH_HEAD(a0),ph_NextEvent(a0)
		movea.l	ph_TimerBase(a0),a6
		lea.l	ph_LastShot(a0),a0
		Call	ReadEClock
		movea.l	(a7)+,a6
		rts

		Lib	EventReached	; a0:ph
		movea.l	ph_NextEvent(a0),a1	; a1:pe
		move.l	MLN_SUCC(a1),ph_NextEvent(a0)	
		beq.b	EndCycle			; cycle ended!
		move.l	a6,-(a7)
		movea.l	ph_TimerBase(a0),a6
		exg	a0,a1			; a0:pe a1:ph
		movem.l	a0/a1,-(a7)
		addq.l	#pe_ETime,a0
		Call	ReadEClock
		movem.l	(a7)+,a0/a1
		move.l	pe_ETime+4(a0),d1
		move.l	ph_LastShot+4(a1),d0
		move.l	d1,ph_LastShot+4(a1)
		sub.l	d0,d1
		movea.l	d2,a6
		move.l	pe_ETime(a0),d0
		move.l	ph_LastShot(a1),d2
		move.l	d0,ph_LastShot(a1)
 		subx.l	d2,d0
 		move.l	a6,d2
 		movem.l	d0/d1,pe_Duration(a0)
 		add.l	d1,pe_Sum+4(a0)
 		move.l	pe_Sum(a0),d1
 		addx.l	d0,d1
		move.l	d1,pe_Sum(a0)
		movea.l	(a7)+,a6
		rts	

		Lib	EndCycle		; a0:ph
		addq.l	#1,ph_Cycles(a0)
		rts

		Lib	CreateLog		; a0:ph a1:tags
		movem.l	d2-d7/a2-a6,-(a7)
		movea.l	a6,a5			; a5:probase
		movea.l	a1,a2			; a2:tags
		movea.l	a0,a3			; a3:ph
		
		movea.l	ph_TimerBase(a3),a6
		subq.l	#8,a7
		movea.l	a7,a0
		Call	ReadEClock
		addq.l	#8,a7
 		move.l	d0,d6			; d6=e_freq
		
		movea.l	prob_UtilityBase(a5),a6
		movea.l	a2,a0
		move.l	ph_Output(a3),d1
		move.l	#PRF_Output,d0
		Call	GetTagData	
		movea.l	prob_DOSBase(a5),a6
		move.l	d0,d7			; d7:fh
		bne.b	.okfh
		Call	Output
		move.l	d0,d7			; d7:default output
.okfh		
		move.l	d7,d1
		move.l	#log_intro,d2
		Call	FPuts
		move.l	d7,d1
		move.l	ph_Name(a3),d2		
		Call	FPuts

WNHam		MACRO
		move.l	d7,d1
		move.l	#log_\1,d2
		Call	FPuts
		BrowseList	cl_Last\1,a4,ph_EventList(a3)
		move.l	pe_Name(a4),d0
		moveq.l	#32,d1
		bsr	WriteName		
		ENDM
WNBurger	MACRO
		mulu.l	#1000000,d2:d1
		mulu.l	#1000000,d0
		add.l	d2,d0			; d0:d1=1^6*ticks
		divu.l	d6,d0:d1
		move.l	d1,d0
		moveq.l	#9,d1			; d0 must be 0 (or overflow)
		lea.l	num,a0
		bsr	WriteDec
		move.l	d7,d1
		move.l	#num,d2
		Call	FPuts
		move.l	d7,d1
		move.l	#log_eventum,d2
		Call	FPuts
		BrowseListEnd	cl_Last\1,a4
		ENDM
				
		WNHam		last
		movem.l	pe_Duration(a4),d0/d1
		WNBurger	last

		WNHam		sum
		movem.l	pe_Sum(a4),d0/d1
		WNBurger	sum

		WNHam		avg
		movem.l	pe_Sum(a4),d0/d1
		divu.l	ph_Cycles(a3),d0:d1
		moveq.l	#0,d0
		WNBurger	avg
			
		movem.l	(a7)+,d2-d7/a2-a6	
		rts	

; d0:name d1:totlen d7:fh a6:dosbase
WriteName	move.l	d6,-(a7)
		move.l	d0,a0
.loop		subq.l	#1,d1
		tst.b	(a0)+
		bne.b	.loop
		move.l	d1,d6
		move.l	d7,d1
		move.l	d0,d2
		Call	FPuts
.points		move.l	d7,d1
		move.l	#'.',d2
		Call	FPutC
		dbra	d6,.points
		move.l	(a7)+,d6
		rts

; A0=buffer,D0=Num,D1=Cyfs
Cyf		dc.b	'xx987654321'
zc		dc.b	'0'
		cnop	0,4
WriteDec	movem.l	d2-d3,-(a7)
		move.b	#'.',zc
		moveq.l	#1,d2
		moveq.l	#10,d3
		clr.l	-(a7)
		bra.b	.entry
.divs		move.l	d2,-(a7)
		mulu.l	d3,d2
.entry		dbra	d1,.divs
.dodivs		move.l	(a7)+,d1
		beq.b	.end
		moveq.l	#10,d2
		bra.b	.dodiv
.dodivp		move.b	#'0',zc
.dodiv		sub.l	d1,d0
		dbmi	d2,.dodivp
		add.l	d1,d0
		move.b	Cyf+1(pc,d2.w),(a0)+
		bra.b	.dodivs
.end		movem.l	(a7)+,d2-d3
		rts
				
utyname		dc.b	'utility.library',0
dosname		dc.b	'dos.library',0
timername	dc.b	'timer.device',0
unp		dc.b	'None!',0
une		dc.b	'Unknow',0

log_intro	dc.b	'profiler.library results.',10
		dc.b	'profiled ',0
log_last	dc.b	10,'last cycle results:',10,0
log_sum		dc.b	10,'all cycles sum results:',10,0
log_avg		dc.b	10,'average results:',10,0
log_eventum	dc.b	' µs',10,0
num		dc.b	'.........',0

		Lib	END