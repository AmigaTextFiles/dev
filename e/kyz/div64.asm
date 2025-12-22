; divides a 64bit number by a 32bit number
; quotient, remainder := udiv64(dividend_hi, dividend_lo, divisor)
; quotient, remainder := sdiv64(dividend_hi, dividend_lo, divisor)
;
; NOTE: requires a 68020 processor or better
;
	machine	68020

	xdef	udiv64__iii
udiv64__iii	bsr.s	getargs
		divu.l	d2,d1:d0	; D1(h):D0(l) / D2 -> D1(r):D0(q)
		rts

	xdef	sdiv64__iii
sdiv64__iii	bsr.s	getargs
		divs.l	d2,d1:d0	; D1(h):D0(l) / D2 -> D1(r):D0(q)
		rts

getargs	lea	8(sp),a0
	move.l	(a0)+,d2	; d2 = divisor
	move.l	(a0)+,d0	; d0 = dividend_lo
	move.l	(a0)+,d1	; d1 = dividend_hi
	rts
