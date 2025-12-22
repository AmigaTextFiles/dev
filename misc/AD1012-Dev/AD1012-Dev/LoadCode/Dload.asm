port		equ	8
buff		equ	12

*-----------------------------------------------------------------------
	csect text
*-----------------------------------------------------------------------
	XREF	_CardSoftRev
	XREF	_CardSoft
	XDEF	_SendPgm
_SendPgm:
	link	a0,#0
	movem.l	d3/a4-a5,-(a7)
	movea.l	port(a0),a5
	movea.l	buff(a0),a1

	movea.l	a5,a4
	addq.l	#2,a5

	move.l	#$03f1,d0

loopC:	move.w	(a1)+,d1
	move.w	(a1)+,d2
	lsr.w	#8,d2

waitc1:	btst.b	#0,(a4)			* wait  for write ok
	bne.s	waitc1
	move.w	d2,(a5)			* send lsb

waitc2:	btst.b	#0,(a4)			* wait  for write ok
	bne.s	waitc2
	move.w	d1,(a5)			* send msb

	subq.l	#1,d0
	bne	loopC

	move.w	d1,_CardSoftRev
	move.w	d2,_CardSoft   

	movem.l	(a7)+,d3/a4-a5		*Reset Registers
	unlk	a0
	rts
*-----------------------------------------------------------------------
*-----------------------------------------------------------------------
*-----------------------------------------------------------------------
	END
