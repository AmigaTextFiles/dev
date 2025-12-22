; a highly cut-down version of stealchip.e

; dat:=steallong(mem) works like dat:=Long(mem)
; placelong(mem,dat)  works like PutLong(mem,dat)

; except they both only work on word-aligned chip memory,
; and do not cause MMU traps

	include	exec/memory.i
	include	hardware/blit.i
	include	hardware/custom.i
	include	hardware/dmabits.i

	include	lvo/exec_lib.i
	include	lvo/graphics_lib.i

	include	eglobs.i

_custom=$dff000
A_TO_D=$F0

	xdef	steallong__i
	xdef	placelong__ii
steallong__i
	movem.l	d2/a2-a3/a6,-(sp)	; 16 onto stack
	lea	steal(pc),a3
	bra.s	_main
placelong__ii
	movem.l	d2/a2-a3/a6,-(sp)	; 16 onto stack
	lea	place(pc),a3

_main	moveq	#16,d0
	moveq	#MEMF_CHIP,d1
	move.l	execbase(a4),a6
	jsr	_LVOAllocMem(a6)
	tst.l	d0
	beq.s	.exit
	move.l	d0,a2
	addq.l	#8,a2	; protection

	move.l	gfxbase(a4),a6
	jsr	_LVOOwnBlitter(a6)
	jsr	_LVOWaitBlit(a6)

	lea	_custom,a0
	moveq	#0,d0
	moveq	#-1,d1

	move.w	#DMAF_SETCLR!DMAF_MASTER!DMAF_BLITTER,dmacon(a0)
	move.l	#(BC0F_SRCA!BC0F_DEST!A_TO_D)<<16,bltcon0(a0) ; and bltcon1=0
	move.l	d0,bltamod(a0)		; bltamod and bltdmod = 0
	move.l	d1,bltafwm(a0)		; bltafwm and bltalwm = -1

	jsr	(a3)		; 4 onto stack
	jsr	_LVODisownBlitter(a6)

	subq.l	#8,a2
	move.l	a2,a1
	moveq	#16,d0
	move.l	execbase(a4),a6
	jsr	_LVOFreeMem(a6)

	move.l	d2,d0
.exit	movem.l	(sp)+,d2/a2-a3/a6
	rts

steal	move.l	[4+20](sp),bltapt(a0)	; bltapt = src
	move.l	a2,bltdpt(a0)		; bltdpt = mem
	move.w	#1<<6+2,bltsize(a0)	; start blit (2x1 words = 4 bytes)
	jsr	_LVOWaitBlit(a6)
	move.l	(a2),d2			; result = Long(mem)
	rts

place	move.l	[8+20](sp),bltdpt(a0)	; bltdpt = dst
	move.l	[4+20](sp),(a2)		; PutLong(mem, dat)
	move.l	a2,bltapt(a0)		; bltapt = mem
	move.w	#1<<6+2,bltsize(a0)	; start blit (2x1 words = 4 bytes)
	jmp	_LVOWaitBlit(a6)
