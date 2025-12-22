; output to the debug console (parallel port version)
;
; dPutStr('15% complete!\n')
; dPrintF('I ate %ld pies, and smelt a %s\n', [15, 'horse'])

	include	eglobs.i
	include	lvo/exec_lib.i

	xdef	dPrintF__ii
dPrintF__ii
	move.l	4.w,a6
	move.l	8(sp),a0
	move.l	4(sp),a1
	move.l	a2,-(sp)
	lea	putchar(pc),a2
	jsr	_LVORawDoFmt(a6)
	move.l	(sp)+,a2
	rts

	xdef	dPutStr__i
dPutStr__i
	move.l	4(sp),a6
.next	move.b	(a6)+,d0
	beq.s	.done
	bsr.s	putchar
	bra.s	.next
.done	rts


; putchar for parallel port

	include	hardware/cia.i

_ciaa=$bfe001
_ciab=$bfd000

putchar	cmp.b	#10,d0
	bne.s	.out
	move.b	#13,d0	; output LF as CRLF
	bsr.s	.out
	moveq	#10,d0
	bsr.s	.tst
.out	bsr.s	.tst
	bsr.s	.tst
.wait	btst.b	#CIAB_PRTRBUSY,_ciab+ciapra	
	bne.s	.wait
	move.b	#-1,_ciaa+ciaddra
	move.b	d0,_ciaa+ciaprb		; output char to parallel port
	bsr.s	.tst
	bsr.s	.tst
	rts
.tst	tst.b	_ciab+ciapra		; request update of register?
	rts
