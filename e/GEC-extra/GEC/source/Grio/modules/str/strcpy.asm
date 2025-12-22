


	xdef	strcpy_dest_sour_size


strcpy_dest_sour_size:

	movem.l	4(a7),d0/a0/a1
	move.l	d0,d1
	addq.l	#1,d1
loop:
	subq.l	#1,d1
	bne.s	copy
	clr.b	(a1)
	bra.s	quit
copy:
	move.b	(a0)+,(a1)+
	bne.s	loop
	subq.w	#1,a1
quit:
	sub.l	d1,d0
	move.l	a1,d1
	rts
	
