; 1.3 compatible CreateMsgPort() and DeleteMsgPort()
; (interchangable with the v36+ ROM routines)

	include	exec/execbase.i
	include	exec/lists.i
	include	exec/memory.i
	include	exec/nodes.i
	include	exec/ports.i
	include	lvo/exec_lib.i
	include	eglobs.i

	xdef	createmsgport
createmsgport
	move.l	execbase(a4),a6

	; allocate memory for the port
	moveq	#MP_SIZE,d0
	move.l	#MEMF_PUBLIC!MEMF_CLEAR,d1
	jsr	_LVOAllocMem(a6)
	move.l	d0,-(sp)
	beq.s	.exit

	; allocate a signal bit
	moveq	#-1,d0
	jsr	_LVOAllocSignal(a6)	; d0 = signal (0-31) or failure (-1)

	; initialise the port
	move.l	(sp),a0
	move.b	#NT_MSGPORT,LN_TYPE(a0)
;	move.b	#PA_SIGNAL,MP_FLAGS(a0)
	move.l	ThisTask(a6),MP_SIGTASK(a0)

	; initialise the msglist
	lea	MP_MSGLIST(a0),a1
	NEWLIST	a1

	; set signal bit. fail if sigbit = -1
	move.b	d0,MP_SIGBIT(a0)
	bmi.s	.nosig

.exit	move.l	(sp)+,d0
	rts
.nosig	move.l	(sp)+,a1
	bsr.s	_free
	moveq	#0,d0
	rts


	XDEF	deletemsgport__i
deletemsgport__i
	move.l	execbase(a4),a6
	move.l	4(sp),a0		; get port
	move.b	MP_SIGBIT(a0),d0
	jsr	_LVOFreeSignal(a6)
	move.l	4(sp),a1		; get port
_free	moveq	#MP_SIZE,d0
	jmp	_LVOFreeMem(a6)
