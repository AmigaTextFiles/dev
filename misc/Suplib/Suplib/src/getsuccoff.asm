
		section CODE

		xdef	_GetSuccOff	    ; sptr = GetSuccOff(node:4(sp), off:8(sp))

_GetSuccOff:	movem.l  4(sp),D0/D1
		move.l	D0,A0
		move.l	0(A0,D1.L),A0
		tst.l	(A0)
		beq	.gso0
		suba.l	D1,A0
		move.l	A0,D0
		rts
.gso0:		moveq.l #0,D0
		rts

		END


