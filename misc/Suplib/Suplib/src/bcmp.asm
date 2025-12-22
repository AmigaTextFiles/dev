
		section CODE

		;   BCMP(src, dst, len)
		;	  D0   D1   A0
		;	 4(sp) 8(sp) 12(sp)
		;   warning: return code has changed.  Is now 0 on success
		;   and 1 on failure

		xdef	_BCmp

_BCmp:		move.l	4(sp),A0
		move.l	8(sp),A1
		move.l	12(sp),D0

		;   BCMP(src:D0, dst:D1, len:A0)

		beq	.bcsucc
		cmp.w	D0,D0	    ;force Z bit
		bra	.bc2
.bc1		cmpm.b	(A0)+,(A1)+
.bc2		dbne	D0,.bc1
		bne	.bcfail
		sub.l	#$10000,D0
		bcc	.bc1
.bcsucc 	moveq.l #0,D0	    ;success!
		rts
.bcfail 	moveq.l #1,D0	    ;failure!
		rts

		END
