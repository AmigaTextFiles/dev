;--------------------------------------------------------------------
; memcmp() -- a faster version
;--------------------------------------------------------------------
; x = memcmp( s1,s2,count)

; This routine compares the data pointed to by "s1" and "s2" for "count"
; bytes, and returns 0 if they are identical, a negative number if s1 < s2,
; or a positive number if s1 > s2.

;							Robert Broughton
;							328-1027 Davie St.
;							Vancouver, BC V6E 4L2
;							Canada
;							USENet: a1040@mindlink.UUCP

MANX	SET		1
		IFND		MANX
		IDNT		_memcmp
		CSECT		_memcmp
		ENDC
		XDEF		_memcmp
_memcmp:
		link		a5,#.127
		move.l	12(a5),a1			;* s2
      move.l   8(a5),a0   ;* s1
		move.l	16(a5),d0	;* count

		cmp.l		#7,d0
		ble		finish       ;* too small, don't bother with optimization

		move.l	a0,d1
		btst		#0,d1			;*  even or odd
		beq		ineven      ;*  it's even already
		subq.l	#1,d0
		move.b	(a0)+,d1
		cmp.b		(a1)+,d1		 ;*  now it's even
		bne		lowout

ineven:
		move.l	a1,d1
		btst		#0,d1			;*  how about output
		beq		outeven

outodd:
;     unfortunately, the output address is not word-aligned, so we will
;     load a long word from s1 into d1, load four bytes from s2 into d2,
;     and compare the two registers
		cmp.l		#3,d0
		ble		finish

		move.l	(a0)+,d1
		move.b	(a1)+,d2
		ext.w		d2
		swap		d2
		move.w	(a1)+,d2
		lsl.l		#8,d2
		move.b	(a1)+,d2
		subq.l	#4,d0
		cmp.l		d1,d2
		beq		outodd
		sub.l		d2,d1
		move.l	d1,d0
		bra		really

outeven:
;		ideal situation; we can load and compare longwords
		cmp.l		#3,d0
		ble		finish

		subq.l	#4,d0
		cmp.l		(a0)+,(a1)+
		beq		outeven
		move.l	-(a0),d0
		sub.l		-(a1),d0
		bra		really

finish:
		cmp.b		#0,d0
		ble		really
		subq.l	#1,d0
finishloop:
		move.b	(a0)+,d1
		cmp.b		(a1)+,d1		 
		dbne		d0,finishloop
		bra		lowout

really:
		unlk		a5
		rts

lowout:
		sub.b		-(a1),d1
		ext.w		d1
		ext.l		d1
		move.l	d1,d0
		bra		really

.127	equ		0

