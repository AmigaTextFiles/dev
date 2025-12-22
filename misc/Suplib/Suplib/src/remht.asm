
		section CODE

		xdef	_RemHeadOff	    ; sptr = RemHeadOff(list:4(sp), off:8(sp))

_RemHeadOff:	movem.l  4(sp),D0/D1

		move.l	D0,A0
		move.l	(A0),A0     ; first node, (A0) == NULL if EOL
		tst.l	(A0)
		beq.s	.rho0
.rhok		move.l	A0,D0
		sub.l	D1,D0	    ; subtract offset (D0 = return value)
		move.l	(A0),A1     ; A1 = successor (or &lh_Tail)
		move.l	4(A0),A0    ; A0 = predecess (or &lh_Head)
		move.l	A0,4(A1)    ; succ->pred = pred
		move.l	A1,(A0)     ; pred->succ = succ
		rts
.rho0:		moveq.l #0,D0
		rts

		xdef	_RemTailOff	    ; sptr = RemTailOff(list:4(sp), off:8(sp))

_RemTailOff:	movem.l  4(sp),D0/D1
		move.l	D0,A0
		move.l	8(A0),A0    ; last node, 4(A0) == NULL if EOL
		tst.l	4(A0)
		bne.s	.rhok
		moveq.l #0,D0
		rts

		END

