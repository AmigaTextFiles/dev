
*	WriteString.asm (of PCQ Pascal runtime library)
*	Copyright (c) 1989 Patrick Quaid

*	Writes a string to a text file.

*	Upon entry, d0 holds the address of the string to write.
*	The word on top of the stack holds the minimum field width,
*	and the longword below that holds the address of the file
*	record

	SECTION	PCQ_Runtime,CODE

	XREF	_p%WriteText
	XREF	_p%PadOut
	XREF	_p%IOResult

	XDEF	_p%WriteString
_p%WriteString

	tst.l	_p%IOResult	; is IO system in order?
	bne	3$
	move.l	6(sp),a0	; get the file record address
	move.l	d0,a1		; move string address
	move.w	4(sp),d0	; d0 holds the minimum field width
	ext.l	d0		; make it 32 bits
5$	move.l	#-1,d3
1$	addq.l	#1,d3		; first find the length
2$	tst.b	0(a1,d3.l)
	bne	1$		; if not null byte, loop
	sub.l	d3,d0		; subtract string length
	ble.s	4$		; if no extra padding needed, skip
	movem.l	a1/d3,-(sp)	; save string address and length
	jsr	_p%PadOut	; write padding spaces
	movem.l	(sp)+,a1/d3	; restore regs
4$	tst.l	d3		; is string zero length?
	beq.s	3$		; if so, skip the write
	jsr	_p%WriteText	; write the string
3$	rts

	END

