
		section CODE

		xdef	_GetTailOff	    ; sptr = GetTailOff(list:4(sp), off:8(sp))

_GetTailOff:	movem.l  4(sp),D0/D1
		move.l	D0,A0
		move.l	8(A0),A0
		tst.l	4(A0)
		beq	.gto0
		sub.l	D1,A0
		move.l	A0,D0
		rts
.gto0:		moveq.l #0,D0
		rts

		END


