*
* exit.asm -> exit.bin -> exit.e
*
	opt l-
	include	exec/exec_lib.i

	movem.l	a2-5,-(sp)
	cargs	#16,databaseptr.l

	movea.l	databaseptr(sp),a1
	move.l	(a1),d0			; database
	beq.s	end
	move.l	d0,a1
	move.l	(a1),d0			; sv_Size
	movea.l	4.w,a6
	jsr	_LVOFreeMem(a6)

end	movem.l	(sp)+,a2-5
