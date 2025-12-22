*
*	·C·O·D·E·X· ·D·E·S·I·G·N· ·S·O·F·T·W·A·R·E·
*	presents
*
*	Palis
*
*	FILE:	MyFunc.asm (for AsmOne)
*	TASK:	do all that asm stuff
*
*	(c)1995 by Hans Bühler
*

	XDEF	__JUMPTOOLD	; used to jump into the old one... see Main.c for more...

;
; oldfunc = JUMPTOOLD(	lib,	(A1) struct Library *
;			off,	(A0) WORD
;			entry	(D0) APTR
;			bsFunc	(A2) APTR (original func to jump-in)
;		     )
;

__JUMPTOOLD:
	movem.l	a4/a6,-(sp)
	move.l	4.w,a6
	jsr	(a2)
	movem.l	(sp)+,a4/a6
	rts
