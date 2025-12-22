; SegTracker comes free with Enforcer.

; segtracker_is_available := segtracker()
; NOTE: this function performs some initialization,
; you must always call it before findseg().

; segmentname, hunk, offset := findseg(address)
; NOTE: You must call this from within a Forbid()/Permit() enclosure to
; ensure valid results.

	include	exec/semaphores.i
	include	exec/types.i
	include	lvo/exec_lib.i

    STRUCTURE SegSem,0
	STRUCT	seg_Semaphore, SS_SIZE
	FPTR	seg_Find
	LABEL	seg_SIZEOF

	xdef	segtracker
segtracker
	move.l	4.w,a6
	lea	st_name(pc),a1
	jsr	_LVOFindSemaphore(a6)
	tst.l	d0
	beq.s	.exit
	move.l	d0,a0
	lea	Find(pc),a1
	move.l	seg_Find(a0),(a1)
.exit	rts

	xdef	findseg__i
findseg__i
	movem.l	a2/a3,-(sp)
	move.l	Find(pc),d0
	beq.s	.exit
	move.l	d0,a3
	move.l	4+8(sp),a0
	lea	Hunk(pc),a1
	lea	Offset(pc),a2
	jsr	(a3)
	lea	Hunk(pc),a1
	move.l	(a1)+,d1
	move.l	(a1)+,d2
.exit	movem.l	(sp)+,a2/a3
	rts

Find	dc.l	0
Hunk	dc.l	0
Offset	dc.l	0

st_name	dc.b	'SegTracker',0
