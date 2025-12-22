;-------------------------------------------------------------
; memset() -- a faster version
;-------------------------------------------------------------
; toaddr = memset( to,char,count)

; This routine copies "char" to the "to" address "count" times. It attempts
; to be more efficient that the Lattice function and the Aztec function 
; "setmem" by moving data a long word at a time, instead of a byte at a time.
; The "to" address is returned.

;							Robert Broughton
;							328-1027 Davie St.
;							Vancouver, BC V6E 4L2
;							Canada
;							USENet: a1040@mindlink.UUCP

;MANX	SET	0
	IFND	MANX
	IDNT	_memset
	CSECT	_memset
	ENDC
	XDEF	_memset
_memset:
	link	a5,#.127
	move.l	d2,-(a7)
	move.l	8(a5),a1			;* out
;	the next two lines are for Lattice
	IFND	MANX
		move.l   12(a5),d1   ;* char
		move.l	16(a5),d0	;* count
	ELSE
;	the next two lines are for Manx
		move.w	12(a5),d1   ;* char
		move.l	14(a5),d0	;* count
	ENDC

		cmp.l		#7,d0
		ble		finish       ;* too small, don't bother with optimization

		move.l	a1,d2
		btst		#0,d2			;*  even or odd
		beq		ok		      ;*  it's even already
		move.b	d1,(a1)+ 	;*  now it's even
		subq.l	#1,d0

ok:
;     make all four bytes of d1 the same
		move.b	d1,d2
		lsl.w		#8,d2
		move.b	d1,d2
		move.w	d2,d1
		swap		d1
		move.w	d2,d1
outeven:
		cmp.l		#3,d0
		ble		finish

		move.l	d1,(a1)+
		subq.l	#4,d0
		bra		outeven

finish:
		cmp.b		#0,d0
		ble      really
		move.b	d1,(a1)+
		dbf		d0,finish

really:
		move.l	8(a5),d0		;* because Lattice does this
		move.l	(a7)+,d2
	unlk	a5
	rts
.127	equ	0

