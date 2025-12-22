
	opt	l+
	opt	o-
	output  callload.ao

	xdef	_main
	xref	___main
	xref	__exit
	xref	_LoadMETA
	xref	_FreeMETA

_main:	jsr	___main
	move.l	#metaname,-(a7)
	jsr	_LoadMETA
	add.l	#4,a7
	move.l	d0,-(a7)
	jsr	_FreeMETA
	add.l	#4,a7
	rts

metaname:	dc.b	'WildPJ:Support/META/BigPlatform1.meta',0
