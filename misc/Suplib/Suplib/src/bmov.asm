
		section CODE

		;   BMOV(src, dst, len)
		;	  D0  D1    A0
		;	 4(sp) 8(sp) 12(sp)
		;
		;   The memory move algorithm is somewhat more of a mess
		;   since we must do it either ascending or decending.

		xdef	_BMov

_BMov:		movem.l 4(sp),A0/A1
		move.l	12(sp),D0

		cmp.l	A0,A1		;move to self
		beq	.bmend
		bls	.bmup
.bmdown 	adda.l	D0,A0		;descending copy
		adda.l	D0,A1
		move.w	A0,D1		;CHECK WORD ALIGNED
		btst.l	#0,D1
		bne	.bmdown1
		move.w	A1,D1
		btst.l	#0,D1
		bne	.bmdown1
		cmp.l	#259,D0 	    ;chosen by calculation.
		bcs	.bmdown8

		move.l	D0,D1		    ;overhead for bmd44: ~360
		divu	#44,D1
		bvs	.bmdown8	    ;too big (> 2,883,540)
		movem.l D2-D7/A2-A6,-(sp)   ;use D2-D7/A2-A6 (11 regs)
		move.l	#11*4,D0
		bra	.bmd44b
.bmd44a 	sub.l	D0,A0		    ;8		total 214/44bytes
		movem.l (A0),D2-D7/A2-A6    ;12 + 8*11  4.86 cycles/byte
		movem.l D2-D7/A2-A6,-(A1)   ; 8 + 8*11
.bmd44b 	dbf	D1,.bmd44a	    ;10
		swap	D1		    ;D0<15:7> already contain 0
		move.w	D1,D0		    ;D0 = remainder
		movem.l (sp)+,D2-D7/A2-A6

.bmdown8	move.w	D0,D1		    ;D1<2:0> = #bytes left later
		lsr.l	#3,D0		    ;divide by 8
		bra	.bmd8b
.bmd8a		move.l	-(A0),-(A1)         ;20         total 50/8bytes
		move.l	-(A0),-(A1)         ;20         = 6.25 cycles/byte
.bmd8b		dbf	D0,.bmd8a	    ;10
		sub.l	#$10000,D0
		bcc	.bmd8a
		move.w	D1,D0		    ;D0 = 0 to 7 bytes
		and.l	#7,D0
		bne	.bmdown1
		rts

.bmd1a		move.b	-(A0),-(A1)         ;12         total 22/byte
.bmdown1				    ;		= 22 cycles/byte
.bmd1b		dbf	D0,.bmd1a	    ;10
		sub.l	#$10000,D0
		bcc	.bmd1a
		rts

.bmup		move.w	A0,D1		    ;CHECK WORD ALIGNED
		btst.l	#0,D1
		bne	.bmup1
		move.w	A1,D1
		btst.l	#0,D1
		bne	.bmup1
		cmp.l	#259,D0 	    ;chosen by calculation
		bcs	.bmup8

		move.l	D0,D1		    ;overhead for bmu44: ~360
		divu	#44,D1
		bvs	.bmup8		    ;too big (> 2,883,540)
		movem.l D2-D7/A2-A6,-(sp)   ;use D2-D7/A2-A6 (11 regs)
		move.l	#11*4,D0
		bra	.bmu44b
.bmu44a 	movem.l (A0)+,D2-D7/A2-A6   ;12 + 8*11  ttl 214/44bytes
		movem.l D2-D7/A2-A6,(A1)    ;8  + 8*11  4.86 cycles/byte
		add.l	D0,A1		    ;8
.bmu44b 	dbf	D1,.bmu44a	    ;10
		swap	D1		    ;D0<15:7> already contain 0
		move.w	D1,D0		    ;D0 = remainder
		movem.l (sp)+,D2-D7/A2-A6

.bmup8		move.w	D0,D1		    ;D1<2:0> = #bytes left later
		lsr.l	#3,D0		    ;divide by 8
		bra	.bmu8b
.bmu8a		move.l	(A0)+,(A1)+         ;20         total 50/8bytes
		move.l	(A0)+,(A1)+         ;20         = 6.25 cycles/byte
.bmu8b		dbf	D0,.bmu8a	    ;10
		sub.l	#$10000,D0
		bcc	.bmu8a
		move.w	D1,D0		    ;D0 = 0 to 7 bytes
		and.l	#7,D0
		bne	.bmup1
		rts

.bmu1a		move.b	(A0)+,(A1)+
.bmup1
.bmu1b		dbf	D0,.bmu1a
		sub.l	#$10000,D0
		bcc	.bmu1a
.bmend		rts

		END
