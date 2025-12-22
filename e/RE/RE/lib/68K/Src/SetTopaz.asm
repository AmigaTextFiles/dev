;phxass NOEXE opt nrqbtlps re:lib/elib_68K/SetTopaz.asm
	machine mc68020
	xdef	_SetTopaz
_SetTopaz:
SetTopaz_size	equ	8
	link	a5,#-4
	movem.l	a0,-(a7)
;IF font:=OpenFont(['topaz.font',size,0,0]:TextAttr) THEN SetFont(stdrast,font)
	lea	_list1,a0
	move.l	SetTopaz_size(a5),d1
	move.w	d1,4(a0)
	movea.l	_GfxBase,a6
	jsr	-72(a6)
	tst.l	d0
	beq	SetTopaz_else1_0
	move.l	_stdrast,a1
	move.l	d0,a0
	movea.l	_GfxBase,a6
	jsr	-66(a6)			;SetFont(stdrast,font)
SetTopaz_else1_0:
	movem.l	(a7)+,a0
	unlk	a5
	rts
	cnop	0,2
_list1:
	dc.l	_str1
	dc.w	0
	dc.b	0,0
_str1:
	dc.b	"topaz.font",0
	cnop	0,2

	xref	_stdrast
	xref	_GfxBase
