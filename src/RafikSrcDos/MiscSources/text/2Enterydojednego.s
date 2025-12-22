;TOSAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
;tnie 2 entery $a,$a po porzeróbce moûe $d do $a
start
	lea	a,a0
	lea	b,a1
	move.w	#b-a-1,d0
.l	move.b	(a0)+,d1
	cmp.b	#$a,d1
	bne.s	.1
	move.b	(a0)+,(a1)+
;zmieniê!
	bra.s	.2
.1
	move.b	d1,(a1)+
.2
	dbf	d0,.l

	rts
	incdir
a:	incbin	'ram:gif'

b:

c:
	ds.b	b-a

