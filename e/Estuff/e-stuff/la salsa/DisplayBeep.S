	movem.l d0-a6,-(a7)

	move.l $4,a6
	lea.l  intuilibname,a1
	jsr -408(a6)
	move.l d0,intuibase
	beq.s error

	move.l intuibase,a6
	move.l 0,a0
	jsr -96(a6)

	move.l intuibase,a1
	move.l $4,a6
	jsr -414(a6)

error:
	movem.l (a7)+,d0-a6
	rts
	
intuilibname:
	dc.b	"intuition.library",0

intuibase:
	dc.l	0
