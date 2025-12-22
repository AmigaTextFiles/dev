OPT NOEXE

APROC InstallHook(a0,a1)
	move.l	a1,(12,a0)
	lea		(hookentry,pc),a1
	move.l	a1,(8,a0)
	move.l	a0,d0
ENDPROC

APROC hookentry()
	movem.l	d2-d7/a2-a6,-(a7)
	move.l	a0,-(a7)
	move.l	a2,-(a7)
	move.l	a1,-(a7)
	move.l	(12,a0),a0
	jsr		(a0)
	lea		(12,a7),a7
	movem.l	(a7)+,d2-d7/a2-a6
ENDPROC
