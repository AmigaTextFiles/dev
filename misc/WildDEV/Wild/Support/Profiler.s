
	include	exec/exec_lib.i
	include	libraries/dos_lib.i
	include	exec/io.i
	include	dos/dos.i
	include	devices/timer.i
	include	devices/timer_lib.i
	include	pypermacro.i

Timer	MACRO
	movea.l	TimerBase,a6
	ENDM

Dos	MACRO
	movea.l	DOSBase,a6
	ENDM

	bsr	InitTimerDevice
	bsr	Profiler
	bsr	FlushTimerDevice	
	rts

		cnop	0,4
Routines	dc.l	null,r1,r2
RoutinesEnd	dc.l	0

		cnop	0,4
null		rts

		cnop	0,4
r1		move.l	a7,a0
		move.l	d2,-(a7)
		move.l	d2,-(a7)
		moveq.l	#1,d0
		moveq.l	#1,d1
		add.l	d0,d0
		add.l	d1,d1
		move.l	a0,a7
		rts

		cnop	0,4
r2		move.l	a7,a0
		move.l	d2,-(a7)
		move.l	d2,-(a7)
		moveq.l	#1,d0
		moveq.l	#1,d1
		add.l	d0,d0
		add.l	d1,d1
		move.l	a0,a7
		rts

***************************************************************************************
*** Profiler 									*******
***************************************************************************************

		cnop	0,4
DOSBase		dc.l	0
OutFH		dc.l	0
RDArgs		dc.l	0
Args
NTests		dc.l	0
Forbid		dc.l	0
Disable		dc.l	0
StartTime	dc.l	0,0
EndTime		dc.l	0,0
Times		dc.l	0
Tests		dc.l	0

OutNum	MACRO	; \1=ea (of num) \2=4char
	movem.l	d0-d3/a0-a1/a6,-(a7)
	Dos
	move.l	#'\2',tmp
	lea.l	tmpn,a0
	move.l	\1,d0
	moveq.l	#10,d1
	bsr	WriteDec
	move.l	OutFH,d1
	move.l	#tmp,d2
	move.l	#tmpend-tmp,d3
	Call	Write
	movem.l	(a7)+,d0-d3/a0-a1/a6
	ENDM

Profiler	Exec
		move.l	#4*256,d0
		moveq.l	#0,d1
		Call	AllocVec
		move.l	d0,Times
		lea.l	DosName,a1
		moveq.l	#33,d0
		Call	OpenLibrary
		move.l	d0,DOSBase
		beq	exit
		movea.l	d0,a6
		Call	Output
		move.l	d0,OutFH
		move.l	#Template,d1
		move.l	#Args,d2
		moveq.l	#0,d3
		Call	ReadArgs
		move.l	d0,RDArgs
		beq	exit
		move.l	OutFH,d1
		move.l	#Intro,d2
		move.l	#IntroEnd-Intro,d3
		Call	Write
		move.l	NTests,a0
		move.l	(a0),Tests

		Exec
		tst.l	Forbid
		beq.b	.nf
		Call	Forbid
.nf		tst.l	Disable
		beq.b	.nd
		Call	Disable
.nd
					; a2:testnum
Prof		move.l	Times,a3	; a3:time storing
		lea.l	Routines,a4	; a4:routines
.loop		move.l	(a4)+,d0
		beq	.end
		move.l	d0,a2		; a2:routine
		move.l	Tests,d7	; d7:count
		
*		OutNum	d7,TEST
		
		subq.l	#1,d7
		movem.l	a3/a4,-(a7)
		Exec
		Call	CacheClearE
		bra.b	.entry

		cnop	0,4
.entry		movea.l	TimerBase(pc),a6
		lea.l	StartTime,a0
		Call	ReadEClock
.redo		movem.l	d7/a2,-(a7)
		jsr	(a2)
		movem.l	(a7)+,d7/a2
		subq.l	#1,d7
		bpl.b	.redo
		movea.l	TimerBase(pc),a6
		lea.l	EndTime,a0
		Call	ReadEClock 
		movem.l	(a7)+,a3/a4

*		OutNum	StartTime,STd0
*		OutNum	StartTime+4,STd1
*		OutNum	EndTime,ENd0
*		OutNum	EndTime+4,ENd1

		movea.l	TimerBase(pc),a6
		lea.l	StartTime,a1
		lea.l	EndTime,a0
		Call	SubTime

		lea.l	EndTime,a0
		move.l	(a0)+,(a3)+
		move.l	(a0)+,(a3)+

		bra	.loop
.end	
		Exec
		tst.l	Forbid
		beq.b	.np
		Call	Permit	
.np		tst.l	Disable
		beq.b	.ne
		Call	Enable
.ne
		Dos
		move.l	OutFH,d1
		move.l	#Real,d2
		move.l	#RealEnd-Real,d3
		Call	Write
		lea.l	Routines,a2
		movea.l	Times,a3
		lea.l	Units,a4
		moveq.l	#0,d7		; d7=routine cnt
View		move.l	(a2)+,d0
		beq	.end
		move.l	d7,d2
		lea.l	Result_rt,a0
		move.l	(a3)+,d0
		move.l	(a3)+,d1
		bsr	WriteResult
		addq.w	#1,d7
		bra	View
.end
		Dos
		move.l	OutFH,d1
		move.l	#Pure,d2
		move.l	#PureEnd-Pure,d3
		Call	Write
		lea.l	Routines+4,a2
		movea.l	Times,a3
		move.l	(a3)+,d3
		move.l	(a3)+,d4	; d3/d4: NULL ROUTINE times.
		lea.l	Units,a4
		moveq.l	#1,d7		; d7=routine cnt
ViewPure	move.l	(a2)+,d0
		beq	.end
		move.l	d7,d2
		lea.l	Result_rt,a0
		move.l	(a3)+,d0
		move.l	(a3)+,d1
		sub.l	d4,d1
		subx.l	d3,d0
		bsr	WriteResult
		addq.w	#1,d7
		bra	ViewPure
.end	
		Dos
		move.l	OutFH,d1
		move.l	#Single,d2
		move.l	#SingleEnd-Single,d3
		Call	Write
		lea.l	Routines+4,a2
		movea.l	Times,a3
		move.l	(a3)+,d3
		move.l	(a3)+,d4	; d3/d4: NULL ROUTINE times.
		move.l	Tests,d5	; d5:N of tests
		lea.l	Units,a4
		moveq.l	#1,d7		; d7=routine cnt
ViewSingle	move.l	(a2)+,d0
		beq	.end
		move.l	d7,d2
		lea.l	Result_rt,a0
		move.l	(a3)+,d0
		move.l	(a3)+,d1
		sub.l	d4,d1
		subx.l	d3,d0
		divs.l	d5,d0:d1
		moveq.l	#0,d0		; ERROR IF A SINGLE CALL USES MORE THAN $ffffffff E Clocks. I THINK WILL NEVER HAPPEN !!!!		
		bsr	WriteResult
		addq.w	#1,d7
		bra	ViewSingle
.end	


exit		Dos
		move.l	a6,d0
		beq.b	.ndos
***		move.l	RDArgs,d0
***		beq.b	.narg
***		Call	FreeArgs		
.narg		Exec
		movea.l	DOSBase,a1
		Call	CloseLibrary
.ndos		Exec
		move.l	Times,d0
		beq.b	.nstk
		movea.l	d0,a1
		Call	FreeVec
.nstk		rts

; in: d0/d1:EClock d2:ResNumber

WriteResult	movem.l	d2-d3/a6,-(a7)
		tst.l	d0
		bpl.b	.nbad
		move.l	OutFH,d1
		move.l	#Bad,d2
		move.l	#BadEnd-Bad,d3
		Call	Write
		bra.b	.exit		
.nbad		lea.l	Result_rt,a0
		exg	d0,d2
		move.l	d1,d3
		moveq.l	#3,d1
		bsr	WriteDec
		move.l	d3,d1
		move.l	d2,d0
		moveq.l	#0,d3		; d3=unit
		bra.b	.entry1
.unit		ror.l	#8,d0
		ror.l	#2,d0
		lsr.l	#8,d1
		lsr.l	#2,d1
		move.l	d0,d2
		andi.l	#$007fffff,d2
		or.l	d2,d1
		andi.l	#$ffc00000,d0
		addq.w	#1,d3
.entry1		tst.l	d0
		bne.b	.unit		
		move.b	(a4,d3.l),Result_un
		move.l	d1,d0
		moveq.l	#10,d1
		lea.l	Result_et,a0
		bsr	WriteDec
		Dos
		move.l	OutFH,d1
		move.l	#Result,d2
		move.l	#ResultEnd-Result,d3
		Call	Write
.exit		movem.l	(a7)+,d2-d3/a6
		rts				
		
***************************************************************************************
*** WriteDec: A0=buffer,D0=Num,D1=Cyfs						*******
***************************************************************************************

Cyf		dc.b	'xx9876543210'
WriteDec	movem.l	d2-d3,-(a7)
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
.dodiv		sub.l	d1,d0
		dbmi	d2,.dodiv
		add.l	d1,d0
		move.b	Cyf+1(pc,d2.w),(a0)+
		bra.b	.dodivs
.end		movem.l	(a7)+,d2-d3
		rts

***************************************************************************************
*** Timer device init								*******
***************************************************************************************

TimerMsg	dc.l	0
TimerIO		dc.l	0
TimerBase	dc.l	0
InitTimerDevice	Exec
		Call	CreateMsgPort
		move.l	d0,TimerMsg
		movea.l	d0,a0
		moveq.l	#IOTV_SIZE,d0
		Call	CreateIORequest
		move.l	d0,TimerIO
		lea.l	TimerName,a0
		movea.l	d0,a1
		moveq.l	#0,d0
		move.l	d0,d1
		Call	OpenDevice
		tst.l	d0
		bne.b	ITD_Error
		moveq.l	#-1,d1
		movea.l	TimerIO(pc),a0
		move.l	IO_DEVICE(a0),TimerBase
		rts
ITD_Error	moveq.l	#0,d0
		rts

FlushTimerDevice Exec
		movea.l	TimerIO(pc),a1
		Call	CloseDevice
		movea.l	TimerIO(pc),a0
		Call	DeleteIORequest
		movea.l	TimerMsg(pc),a0
		Call	DeleteMsgPort
		rts


NL	EQU	10		
TimerName	dc.b	'timer.device',0
DosName		dc.b	'dos.library',0
		dc.b	0,'$VER:'
Intro		dc.b	'Pyper Profiler System. V0.8 (12.09.98)',0,NL
IntroEnd
Template	dc.b	'TESTS/N/A,FORBID/S,DISABLE/S',0		
Bad		dc.b	'Bad result of this routine.',NL
BadEnd
Result		dc.b	'Routine '
Result_rt	dc.b	'___ took '
Result_et	dc.b	'__________ E Clock '
Result_un	dc.b	' ticks.',NL
ResultEnd
Pure		dc.b	NL,'Pure results:',NL
PureEnd
Real		dc.b	NL,'Real results:',NL
RealEnd
Single		dc.b	NL,'Single call results:',NL
SingleEnd
Units		dc.b	' kMGT***'

tmp		dc.b	'xxxx'
tmpn		dc.b	'xxxxxxxxxx',NL
tmpend
