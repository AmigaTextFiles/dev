
		section CODE

		xdef	_GetHead    ; GetHead(list:4(sp))
		xdef	_GetSucc    ; GetSucc(node:4(sp))
	       IFD LATTICE
		xdef	@GetHead    ; Registerized Parameters (Lattice C)
		xdef	@GetSucc
	       ENDC
_GetSucc:
_GetHead:	move.l	4(sp),A0
	       IFD LATTICE
@GetSucc:
@GetHead:
	       ENDC
		move.l	(A0),A0
		tst.l	(A0)
		beq	.gh0
		move.l	A0,D0
		rts
.gh0		moveq.l #0,D0
		rts

		END

