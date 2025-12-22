	movem.l	d3-d5/a0-a2,-(sp)
wtblit	btst	#14,$dff002
	bne.s	wtblit
	move.l	d2,d3
	mulu	#40,d3
	add.l	d3,a1
	move.l	#300,d3
	sub.l	d2,d3
	moveq.l	#0,d4
nxtline	add.w	d0,d4
	move.w	d4,d5
	divu	d1,d5
	cmp.w	d0,d5
	bge.s	exit
	ext.l	d5
	mulu	#40,d5
	move.l	a0,a2
	add.l	d5,a2
	move.l	(a2)+,(a1)+
	move.l	(a2)+,(a1)+
	move.l	(a2)+,(a1)+
	move.l	(a2)+,(a1)+
	move.l	(a2)+,(a1)+
	move.l	(a2)+,(a1)+
	move.l	(a2)+,(a1)+
	move.l	(a2)+,(a1)+
	move.l	(a2)+,(a1)+
	move.l	(a2)+,(a1)+
	dbra	d3,nxtline
exit	movem.l	(sp)+,d3-d5/a0-a2
	rts	
