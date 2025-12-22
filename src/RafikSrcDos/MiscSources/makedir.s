;
;Make dir
;dla lharków....800-850
_CreateDir	EQU	-120

	move.l	4.w,a6
	lea	DosName,a1
	jsr	-408(a6)
	move.l	d0,a6

.loop
	move.l	#Name,d1
	jsr	_CreateDir(a6)

	lea	Name+2,a0
	addq.b	#1,(a0)
	cmp.b	#'9'+1,(a0)
	bne.s	.skip
	move.b	#'0',(a0)
	addq.b	#1,-(a0)
	cmp.b	#'9'+1,(a0)
	bne.s	.skip
	move.b	#'0',(a0)
	addq.b	#1,-(a0)
.skip

	cmp.l	#'948'<<8,Name	;+1
	bne.s	.loop


	moveq	#0,d0
	rts


Name:		dc.b	'876',0

DosName:	dc.b	'dos.library',0

