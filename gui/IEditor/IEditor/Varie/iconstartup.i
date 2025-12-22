	include dos/dosextens.i

	movem.l	d0/a0,-(sp)
	sub.l a1,a1
	move.l  4,a6
	jsr	_LVOFindTask(a6)
	move.l	d0,a4
	tst.l pr_CLI(a4)	; was it called from CLI?
	bne.s   fromCLI		; if so, skip out this bit...
	lea	pr_MsgPort(a4),a0
	move.l  4,a6
	jsr	_LVOWaitPort(A6)
	lea	pr_MsgPort(a4),a0
	jsr	_LVOGetMsg(A6)
	move.l	d0,returnMsg
fromCLI
	movem.l	(sp)+,d0/a0
go_program
	bsr.s _main 				; Calls your code..
	move.l	d0,-(sp)
	tst.l returnMsg		; Is there a message?
	beq.s exitToDOS		; if not, skip...
	move.l	4,a6
		  jsr _LVOForbid(a6) 			; note! No Permit needed!
	move.l	returnMsg(pc),a1
	jsr	_LVOReplyMsg(a6)
exitToDOS
	move.l	(sp)+,d0 	; exit code
	rts
returnMsg dc.l 0
	even				;(or cnop 0,2)
_main
