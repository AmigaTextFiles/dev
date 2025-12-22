
		section CODE

		xdef	_GetPredOff	    ; sptr = GetPredOff(node:4(sp), off:8(sp))

_GetPredOff:	movem.l  4(sp),D0/D1
		move.l	D0,A0
		move.l	4(A0,D1.L),A0
		tst.l	4(A0)
		beq	.gpo0
		suba.l	D1,A0
		move.l	A0,D0
		rts
.gpo0		moveq.l #0,D0
		rts

		END


