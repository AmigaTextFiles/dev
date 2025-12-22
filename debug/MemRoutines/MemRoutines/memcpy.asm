;---------------------------------------------------------------------
; memcpy() -- a faster version
;---------------------------------------------------------------------
; toaddr = memcpy( to,from,count)

; This routine copies "count" bytes from the "from" address to the "to"
; address. It attempts to move data in longwords whenever possible. The
; "to" address is returned.

;							Robert Broughton
;							328-1027 Davie St.
;							Vancouver, BC V6E 4L2
;							Canada
;							USENet: a1040@mindlink.UUCP
;
MANX	SET		1
		IFND		MANX
		IDNT		_memcpy
		CSECT		_memcpy
		ENDC
		XDEF		_memcpy
_memcpy:
		link		a5,#.127
		move.l	8(a5),a1			;* out
      move.l   12(a5),a0   ;* in
		move.l	16(a5),d0	;* count

		cmp.l		#7,d0
		ble		finish       ;* too small, don't bother with optimization

		move.l	a0,d1
		btst		#0,d1			;*  even or odd
		beq		ineven      ;*  it's even already
		move.b	(a0)+,(a1)+ ;*  now it's even
		subq.l	#1,d0
ineven:
		move.l	a1,d1
		btst		#0,d1			;*  how about output
		beq		outeven

outodd:
;     unfortunately, the output address is not word-aligned, so we will
;     load a long word, and store it as four bytes
		cmp.l		#3,d0
		ble		finish

		move.l	(a0)+,d1
		move.b	d1,3(a1)
		lsr.w		#8,d1
		move.b	d1,2(a1)		
		swap		d1
		move.b	d1,1(a1)
		lsr.w		#8,d1
		move.b	d1,(a1)		
		addq.l	#4,a1
		subq.l	#4,d0
		bra		outodd

outeven:
;		ideal situation; we can load and store longwords
		cmp.l		#3,d0
		ble		finish

		move.l	(a0)+,(a1)+
		subq.l	#4,d0
		bra		outeven

finish:
		cmp.b		#0,d0
		ble      really
		move.b	(a0)+,(a1)+
		dbf		d0,finish

really:
		move.l	8(a5),d0		;* Lattice memcpy does this
		unlk		a5
		rts
.127	equ		0

