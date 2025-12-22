		EXEOBJ
		OBJFILE	"test"
		ADDSYM
		DEBUG
		INCDIR	"include:"

		INCLUDE	"lvo/exec.lvo"

		jmp	main

		XDEF	exitSP
exitSP		dc.l	0

		XDEF	main
main		movem.l	d0-d7/a0-a6,-(sp)
		move.l	a7,exitSP

		move.l	4,a6
		moveq	#10,d0
.loop		nop
		dbra	d0,.loop

		XDEF	exit
exit		move.l	exitSP,a7
		movem.l	(sp)+,d0-d7/a0-a6
		rts

		XDEF	Test
Test		jsr	_LVODispatch(a6)
		rts
