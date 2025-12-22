	xdef	_VWriteF
	xdef	_WriteF
_VWriteF:
_WriteF:
WriteF_a	equ	12
WriteF_b	equ	8
	link	a5,#0
	movem.l	a0,-(a7)
	move.l	_stdout,d1
	bne	.else
	lea	(.str,pc),a0
	move.l	a0,d1
	move.l	#1006,d2
	movea.l	_DOSBase,a6
	jsr	-30(a6)		;	Open()
	move.l	d0,d1
	lea	_conout,a0
	move.l	d1,(a0)
	lea	_stdout,a0
	move.l	d1,(a0)
.else
	move.l	WriteF_a(a5),d2
	move.l	WriteF_b(a5),d3
	movea.l	_DOSBase,a6
	jsr	-354(a6)	;	VFPrintF()
	movem.l	(a7)+,a0
	unlk	a5
	rts
.str
	dc.b	"con:0/11/640/80/output",0
	cnop	0,2

	xref	_DOSBase
	xref	_conout
	xref	_stdout
