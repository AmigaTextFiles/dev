
		section CODE

		xdef	_GetTail	    ; node = GetTail(list:4(sp))
	       IFD LATTICE
		xdef	@GetTail
	       ENDC

_GetTail:	move.l	4(sp),A0
	       IFD LATTICE
@GetTail:				    ; Lattice C V5.02 registerized params
	       ENDC
		move.l	8(A0),A0
		tst.l	4(A0)
		beq	.gt0
		move.l	A0,D0
		rts
.gt0		moveq.l #0,D0
		rts

		END

