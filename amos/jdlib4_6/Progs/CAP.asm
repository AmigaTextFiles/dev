	lea	$70000,a1
	subi.l	#1,d0
	cmp.l	#0,d0
	beq	no.parameters
	move.w	d0,(a1)+
	subi.l	#1,d0
copy:	move.b	(a0)+,(a1)+
	dbra	d0,copy
	move.b	#0,(a1)+
	move.l	4,a6
	lea	dosname,a1
	jsr	-408(a6)
	move.l	d0,a6
	move.l	#compiled,d1
	clr.l	d2
	clr.l	d3
	move.l	a6,-(sp)
	jsr	-222(a6)
	clr.l	d1
	move.l	(sp)+,a6
	jmp	-144(a6)
no.parameters:
	clr.l	d0
	rts
dosname:
	dc.b	'dos.library',0
	even
compiled:
	dc.b	'SYS:C/AMOSExamine',0
	even
	
