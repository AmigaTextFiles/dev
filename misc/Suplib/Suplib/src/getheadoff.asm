
		section CODE

		xdef	_GetHeadOff	    ; sptr = GetHeadOff(list:4(sp), off:8(sp))

_GetHeadOff:	movem.l  4(sp),D0/D1
		move.l	D0,A0
		move.l	(A0),A0
		tst.l	(A0)
		beq	.gho0
		sub.l	D1,A0
		move.l	A0,D0
		rts
.gho0:		moveq.l #0,D0
		rts

		END


