; output to the debug console (serial port/sushi redirection version)
;
; kPutStr('15% complete!\n')
; kPrintF('I ate %ld pies, and smelt a %s\n', [5, 'horse'])

	include	eglobs.i
	include	lvo/exec_lib.i

	xdef	kPrintF__ii
kPrintF__ii
	move.l	4.w,a6
	move.l	8(sp),a0
	move.l	4(sp),a1
	move.l	a2,-(sp)
	lea	putchar(pc),a2
	jsr	_LVORawDoFmt(a6)
	move.l	(sp)+,a2
	rts

	xdef	kPutStr__i
kPutStr__i
	move.l	4(sp),a6
.next	move.b	(a6)+,d0
	beq.s	.done
	bsr.s	putchar
	bra.s	.next
.done	rts


; putchar for serial port (or sushi/sashimi redirection)

putchar	move.l	a6,-(sp)
	move.l	4.w,a6
	jsr	-516(a6)	; RawPutChar()
	move.l	(sp)+,a6
	rts
