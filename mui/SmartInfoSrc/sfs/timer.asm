*-----------------------------------------------*
*	@AskTimerInt				*
*-----------------------------------------------*

AskTimerInt:
	move.l	exec(a4),a6
	move.l	timer_io(a4),a1
	st	bfTimerActive(a4)
	move.w	#TR_ADDREQUEST,IO_COMMAND(a1)
	addq.l	#1,IOTV_TIME+TV_SECS(a1)
	jmp	_LVOSendIO(a6)

*-----------------------------------------------*
*	@GetTimerMsg				*
*-----------------------------------------------*

GetTimerMsg:
	move.l	exec(a4),a6
	move.l	timerport(a4),a0
	jsr	_LVOGetMsg(a6)
	tst.l	d0
	beq.b	.x
	bsr	AskTimerInt
	bra	UpdateTimer
.x	rts

*-----------------------------------------------*
*	@UpdateTimer				*
*-----------------------------------------------*

UpdateTimer:
	move.l	TimerBase(a4),a6
	lea	ElapsedTime(a4),a0
	jsr	_LVOGetSysTime(a6)
	lea	StartTime(a4),a1
	jsr	_LVOSubTime(a6)
	move.l	(a0),d0
	divu.w	#60,d0
	move.l	exec(a4),a6
	move.w	d0,d1
	swap	d0
	ext.l	d1
	move.w	d0,4(a4)
	divu.w	#60,d1
	lea	TimeFormat-t(a5),a0
	move.w	d1,(a4)
	move.l	a4,a1
	swap	d1
	lea	putchar(pc),a2
	move.w	d1,2(a4)

	lea	TimeText(a4),a3
	jsr	_LVORawDoFmt(a6)

	move.l	intui(a4),a6
	move.l	TX_Defrag_Time-t(a5),a0
	SET2	#MUIA_Text_Contents,A3
	rts
