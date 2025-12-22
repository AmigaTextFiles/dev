
*	WriteShort.asm (of PCQ Pascal runtime library)
*	Copyright (c) 1989 Patrick Quaid

*	Write a short integer to a text file.  The only difference between
*	this and WriteInt is that this routine uses the 68000 div operation.

*	Upon entry, d0 holds the value to write.  The word on top of
*	the stack holds the minumum field width, and the long word
*	below that holds the file record address
*

	SECTION	PCQ_Runtime,CODE

	XREF	_p%PadOut
	XREF	outbuffer
	XREF	_p%WriteText
	XREF	_p%IOResult

	XDEF	_p%WriteShort
_p%WriteShort:

	tst.l	_p%IOResult		; is IO system OK?
	bne	5$
	move.l	#outbuffer+31,a1	; get the last position
	tst.l	d0			; is integer < 0 ?
	bge.s	1$			; if not, skip ahead
	move.w	#-1,-(sp)		; put -1 on stack
	neg.l	d0			; and make d0 positive
	bra.s	2$			; go around
1$	move.w	#1,-(sp)		; d0 is positive, so mark it
2$	divu	#10,d0			; base 10
	move.l	d0,d1			; d0 := d0 div 10
	ext.l	d0			; make d0 32 bits
	swap	d1			; d1 := d0 mod 10
	add.b	#'0',d1			; make value a char digit
	move.b	d1,(a1)			; put it into buffer
	subq.l	#1,a1			; and move buffer pointer
	tst.l	d0			; is d0 zero yet?
	bgt	2$			; if not, continue
	move.w	(sp)+,d0		; was it negative?
	bgt.s	3$			; if not, go on
	move.b	#'-',(a1)		; append minus sign
	subq.l	#1,a1			; advance pointer
3$	move.l	a1,d3			; move pointer to d3
	sub.l	#outbuffer+31,d3	; subtract the original position
	neg.l	d3			; get the length
	move.l	6(sp),a0		; a0 := file record address
	move.w	4(sp),d0		; get the field width
	ext.l	d0			; make it an integer
	sub.l	d3,d0			; how many extras?
	ble	4$			; if none, skip this
	move.l	a1,-(sp)		; save first buffer position
	jsr	_p%PadOut		; write d0 spaces to a0 file rec
	move.l	(sp)+,a1		; retrieve position
4$	adda.l	#1,a1			; point to actual first char
	jsr	_p%WriteText		; write d3 bytes at a1 to a0

5$	rts

	END
