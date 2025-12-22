


	xdef	sprintf_buf_fmt_array

sprintf_buf_fmt_array:
	move.l	a3,-(a7)
	movea.l	4+4(a7),a1
	movem.l	8+4(a7),a0/a3
	lea	formproc(pc),a2
	movea.l	4.w,a6
	jsr	-522(a6)
	movea.l	12+4(a7),a0
	move.l	a0,d0
loop:	tst.b	(a0)+
	bne.s	loop
	sub.l	a0,d0
	not.l	d0
	movea.l	(a7)+,a3
	rts

formproc:
	move.b	d0,(a3)+
	rts


