


	xdef	strdup_str


strdup_str:

	movea.l	4(a7),a0
	movea.l	a0,d0
loop:
	tst.b	(a0)+
	bne.s	loop
	suba.l	d0,a0
	move.l	a0,d0
	subq.l	#1,d0
	beq.s	quit
	pea	(a0)
	dc.w	$4eb9,3,$1c	;	New()
	addq.w	#4,a7
	tst.l	d0
	beq.s	quit
	movea.l	4(a7),a0
	movea.l	d0,a1
copy:
	move.b	(a0)+,(a1)+
	bne.s	copy
quit:
	rts

