;TOSAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
;change 13 to 10
;zamienia entery ibm na nasze..
;rtk

Start:
	lea	StartT,a0
	move.l	#End-StartT,d0
	moveq	#10,d1
	moveq	#13,d2
.loop	cmp.b	(a0),d2
	bne.s	.1
	move.b	d1,(a0)
.1	addq.l	#1,a0
	subq.l	#1,d0
	bne.s	.loop
	rts
StartT:
	incdir
	incbin	'dh1:my.sitelist.short'
End
