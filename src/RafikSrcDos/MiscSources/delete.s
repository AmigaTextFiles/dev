;Delete file by Rafik/RDST
;Gdynia 1994 about 19 days before practice final exam


Start
	move.l	a0,-(sp)
	lea	DosName(pc),a1
	move.l	4.w,a6
	jsr	-408(a6)	;open library
	move.l	d0,a6
;	beq.s		;no dos ?
	move.l	(sp)+,d1	;file name char
	move.l	d1,a0

.loop	cmp.b	#$a,(a0)+
	bne.s	.loop
	clr.b	-1(a0)

	jsr	-72(a6)		;delete
	tst.l	d0
	bne.s	OK
	moveq	#-1,d0
	rts
OK:	moveq	#0,d0
	rts

DosName:dc.b	'dos.library',0
