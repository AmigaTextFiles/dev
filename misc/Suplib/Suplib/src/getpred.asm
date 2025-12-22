
		section CODE

		xdef	_GetPred	    ; node = GetPred(node:4(sp))
	       IFD LATTICE
		xdef	@GetPred
	       ENDC

_GetPred:	move.l	4(sp),A0
	       IFD LATTICE
@GetPred:				    ; Registerized parameters Lattice C 5.02
	       ENDC
		move.l	4(A0),A0
		tst.l	4(A0)
		beq	.gp0
		move.l	A0,D0
		rts
.gp0		moveq.l #0,D0
		rts

		END


