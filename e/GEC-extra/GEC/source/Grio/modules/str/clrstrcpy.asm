


	xdef	clrstrcpy_dest_sour_size


clrstrcpy_dest_sour_size:

	movem.l	4(a7),d1/a0/a1
	move.l	a1,d0
loop:
	subq.l	#1,d1
	bmi.s	loop2
	move.b	(a0)+,(a1)+
	bne.s	loop
loop2:
	subq.l	#1,d1
	bmi.s	quit
	clr.b	(a1)+
	bra.s	loop2
quit:
	rts	

