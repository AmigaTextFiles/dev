**
** Startup code in assemply: include at first
**

	output	entry.o
	opt l+
	opt o-

	XDEF	__exit
	XDEF	__entry
	XREF	_starter

__entry	movem.l	d1-d7/a0-a6,-(a7)
	move.l	a7,stacksv
	bsr	_starter
__exit	move.l	4(a7),d0			; extract the err param!
	move.l	stacksv,a7
	movem.l	(a7)+,d1-d7/a0-a6
	rts
stacksv	dc.l	0