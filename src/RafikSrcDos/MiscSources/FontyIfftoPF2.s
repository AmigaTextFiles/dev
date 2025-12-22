;TOSAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
;Change if fonts to something like Power Fonts 8jednego potm 2 3 4
;R.The.K./RDST/Suspect
;Gdynia 95.01.23


EkranSize:	equ	40
FontsX:		equ	8
FontsY:		equ	8
FontsDepth:	equ	1
LineNr:		equ	6	;ilosc lini fontów

		Addwatch a1,M,40

		Addwatch a2,M,1
		Addwatch a2-8,M,1
		Addwatch FontyRaw,M,1

FontsAdr:
	lea	FontsTable(pc),a0
	lea	FontyIff,a1
	move.l	#EkranSize*FontsY*FontsDepth-EkranSize,d1

	moveq	#LineNr-1,d2
.loop2
	moveq	#[EkranSize*8/FontsX]-1,d0
.loop
	move.l	a1,(a0)+
	addq.l	#FontsX/8,a1
	dbf	d0,.loop
	add.l	d1,a1
	dbf	d2,.loop2

	moveq	#' ',d1

	lea	FontyRaw,a2
.cpoy
	bsr	ShowFonts
	addq.b	#1,d1
	cmp.b	#255,d1
	bne.s	.cpoy


	moveq	#0,d0
	rts
FontsTable:
	blk.l	256,0
	blk.l	256,0

ShowFonts:

.nexttext
	moveq	#0,d0
	move.b	d1,d0
.noend
	sub.b	#' ',d0
	add.l	d0,d0
	add.l	d0,d0
	lea	FontsTable(pc),a1
	move.l	(a1,d0.w),a1
	moveq	#FontsY*FontsDepth-1,d0
.loop
	move.b	(a1),(a2)+
	lea	40(a1),a1
	dbf	d0,.loop

	rts
		incdir	'dh1:sources/diamondsmine/'
FontyIff:
		inciff	'BoulderFonts2+.pic'
FontyRaw:
a
		blk.b	FontyRaw-FontyIff
b
c=['û'-' '+1]*8


