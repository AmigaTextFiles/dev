

	xdef	memsetc_addr_char_size
	xdef	memseti_addr_int_size
	xdef	memsetl_addr_long_size
	

memsetc_addr_char_size:
	movem.l	4(a7),d0/d1/a0
	bra.s	.start
.loop:
	move.b	d1,(a0)+
.start:
	dbf	d0,.loop
	rts


memseti_addr_int_size:
	movem.l	4(a7),d0/d1/a0
	bra.s	.start
.loop:
	move.w	d1,(a0)+
.start:
	dbf	d0,.loop
	rts


memsetl_addr_long_size:
	movem.l	4(a7),d0/d1/a0
	bra.s	.start
.loop:
	move.l	d1,(a0)+
.start:
	dbf	d0,.loop
	rts









	