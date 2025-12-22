
		section CODE

		;   BSET(buffer, len, byte)
		;	 4(sp)   ...
		;	   D0	  D1	A0
		;   BZERO(buffer, len)
		;	  4(sp) ...
		;	    D0	  D1


		xdef	_BSet
		xdef	_BZero

_BZero: 	moveq.l #0,D1
		bra.s	.bz0
_BSet:		move.b	12+3(sp),D1
.bz0		move.l	4(sp),A0
		move.l	8(sp),D0

		add.l	D0,A0	    ; start at end of address
		cmp.l	#40,D0	    ; unscientifically chosen
		bls	.bs2
		bra	.bs10
.bs1		move.b	D1,-(A0)    ; any count < 65536
.bs2		dbf	D0,.bs1
		rts

				    ; at least 2 bytes in count (D0)
.bs10		movem.l D2-D7/A2-A6,-(sp)   ;ant count > 4
		move.l	A0,D2
		btst.l	#0,D2	    ; is it aligned?
		beq	.bs22
		move.b	D1,-(A0)    ; no, copy one byte
		subq.l	#1,D0

.bs22		andi.l	#$FF,D1     ; expand data D1.B -> D2-D7/A1-A6
		move.l	D1,D2	    ; D1 000000xx   D2 000000xx
		asl.w	#8,D2	    ;		       0000xx00
		or.w	D2,D1	    ;	 0000xxxx
		move.w	D1,D2	    ;	 0000xxxx      0000xxxx
		swap	D2	    ;	 0000xxxx      xxxx0000
		or.l	D1,D2	    ; D2.L
		move.l	D2,D3
		move.l	D2,D4
		move.l	D2,D5
		move.l	D2,D6
		move.l	D2,D7
		move.l	D2,A1
		move.l	D2,A2
		move.l	D2,A3
		move.l	D2,A4
		move.l	D2,A5
		move.l	D2,A6	    ; D2-D7/A1-A6   (12 registers)
		move.l	#12*4,D1    ; bytes per transfer (48)
.bs30		sub.l	D1,D0	    ; pre subtract
		bmi	.bs40
.bs31		movem.l D2-D7/A1-A6,-(A0)
		sub.l	D1,D0
		bpl	.bs31
.bs40		add.w	D1,D0	    ; less than 48 bytes remaining

		move.w	#4,D1	    ; by 4's
		sub.w	D1,D0
		bmi	.bs50
.bs41		move.l	D2,-(A0)
		sub.w	D1,D0
		bpl	.bs41
.bs50		add.w	D1,D0
		bra	.bs52
.bs51		move.b	D2,-(A0)    ; by 1's
.bs52		dbf	D0,.bs51
		movem.l (sp)+,D2-D7/A2-A6
		rts

		END

