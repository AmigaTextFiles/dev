

	xdef	libver_libbase_version

libver_libbase_version
	move.l	8(a7),d0
	beq.s	quit
	movea.l	d0,a0
	moveq	#0,d0
	move.l	4(a7),d1
	cmp.w	20(a0),d1
	bhi.s	quit
	moveq	#-1,d0
quit
	rts

