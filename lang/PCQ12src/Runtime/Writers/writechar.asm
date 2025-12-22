
*	WriteChar.asm (of PCQ Pascal runtime library)
*	Copyright (c) 1989 Patrick Quaid

*	This routine writes a single character to a text file

	SECTION	PCQ_Runtime,CODE

	XREF	outbuffer
	XREF	_p%PadOut
	XREF	_p%WriteText
	XREF	_p%IOResult

	XDEF	_p%WriteChar
_p%WriteChar:

	tst.l	_p%IOResult	; is everything OK
	bne	2$		; if not, skip
	move.b	d0,outbuffer	; put the character into the buffer
	move.l	6(sp),a0	; load up the file record address
	move.w	4(sp),d0	; get number of pads
	ext.l	d0		; make it 32 bits for safety
	subq.l	#1,d0		; minus one for the character itself
	ble.s	1$		; if it's <= 0 then skip
	jsr	_p%PadOut	; write pad spaces
1$	move.l	#outbuffer,a1	; get address of buffer
	moveq.l	#1,d3		; one character long
	jsr	_p%WriteText	; write the character
2$	rts

	END
