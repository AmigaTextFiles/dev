	lea.l doslibname,a1
	move.l $4,a6
	jsr -408(a6)
	move.l d0,dosbase
	beq.s error

	move.l dosbase,a6
	move.l #conname,d1
	move.l #1005,d2
	jsr -30(a6)
	move.l d0,conhandle
	beq.s error
	
	move.l conhandle,d1
	move.l #text,d2
	move.l #textend-text,d3
	jsr -48(a6)

error	move.l conhandle,d1
	move.l dosbase,a6
	jsr -36(a6)

	move.l $4,a6
	move.l dosbase,a1
	jsr -414(a6)
	rts

dosbase	dc.l	0
doslibname	dc.b	"dos.library",0
text	dc.b	12
textend	dc.b	0
conname	dc.b	"*",0
	even
conhandle	dc.l	0
