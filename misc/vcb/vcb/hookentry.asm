;:ts=8

	include	'utility/hooks.i'

	cseg

	public	_HookEntry
_HookEntry
	movem.l	d2-d7/a2-a6,-(sp)
	move.l	a1,-(sp)
	move.l	a2,-(sp)
	move.l	a0,-(sp)
	move.l	h_SubEntry(a0),a0
	jsr	(a0)
	lea	12(sp),sp
	movem.l	(sp)+,d2-d7/a2-a6
	rts

	end
