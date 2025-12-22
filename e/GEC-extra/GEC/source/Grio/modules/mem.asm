;APS00000000000000000000000000000000000000000000000000000000000000000000000000000000


	XDEF	allocVec_size_attr

allocVec_size_attr
	move.l	4(a7),d1
	move.l	8(a7),d0
	movea.l	4.w,a6
	cmp.w	#36,20(a6)
	blo.s	.aver
	jmp	-684(a6)
.aver:
	addq.l	#4,d0
	move.l	d0,d2
	jsr	-198(a6)
	tst.l	d0
	beq.s	.quit
	movea.l	d0,a0
	move.l	d2,(a0)+
	move.l	a0,d0
.quit
	rts


	XDEF	freeVec_memptr

freeVec_memptr
	move.l	4(a7),d0
	beq.s	.quit
	movea.l	d0,a1
	movea.l	4.w,a6
	cmp.w	#36,20(a6)
	blo.s	.fver
	jmp	-690(a6)
.fver:
	move.l	-(a1),d0
	jsr	-210(a6)
.quit
	rts


	XDEF	safeFreeMem_memptr_size

safeFreeMem_memptr_size
	move.l	8(a7),d0
	beq.s	.quit
        movea.l	d0,a1
	move.l	4(a7),d0
	movea.l	4.w,a6
	jsr	-210(a6)
.quit
	rts

