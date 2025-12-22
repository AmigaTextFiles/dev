
;-------------------------------------------------------------------------
;
;	Random Dither
;
;
;	Rx Gx Bx    Ra Ga Ba
;
;	Rb Gb Bb
;
;	z = rnd(0,min(amount,255-Ra))
;	Ra += z
;	Rx -= z
;
;	z = rnd(0,min(amount,255-Ga))
;	Ga += z
;	Gx -= z
;
;-------------------------------------------------------------------------

		cnop	0,4

DitherLine_Random_CLUT:

		movem.l	d0-d7/a0/a2-a3,-(a7)

		addq.w	#6,a2
		addq.w	#6,a3

		move.l	(conv_p2table,a5),a6
		move.w	d7,(conv_xcount,a5)

		moveq	#0,d3
		moveq	#0,d4
		moveq	#0,d5

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

.xloop
		move.w	#255,d6

		add.w	(a2)+,d3			; Rot (NEU)
		add.w	(a2)+,d4			; Grün
		add.w	(a2)+,d5			; Blau


		move.w	(conv_ditheramount,a5),d7
		move.l	a2,a0

		moveq	#0,d0
		move.w	d6,d1
		sub.w	(a0),d1		; 255 - Rot
		beq.b	.Rno
		cmp.w	d7,d1
		ble.b	.Rok
		move.w	d7,d1
.Rok	;	cmp.w	d3,d1
	;	ble.b	.Rok2
	;	move.w	d3,d1
.Rok2		bsr	GetRandom
.Rno		add.w	d0,(a0)+
		sub.w	d0,d3


		moveq	#0,d0
		move.w	d6,d1
		sub.w	(a0),d1
		beq.b	.Gno
		cmp.w	d7,d1
		ble.b	.Gok
		move.w	d7,d1
.Gok	;	cmp.w	d4,d1
	;	ble.b	.Gok2
	;	move.w	d4,d1
.Gok2		bsr	GetRandom
.Gno		add.w	d0,(a0)+
		sub.w	d0,d4

		moveq	#0,d0
		move.w	d6,d1
		sub.w	(a0),d1
		beq.b	.Bno
		cmp.w	d7,d1
		ble.b	.Bok
		move.w	d7,d1
.Bok	;	cmp.w	d5,d1
	;	ble.b	.Bok2
	;	move.w	d5,d1
.Bok2		bsr	GetRandom
.Bno		add.w	d0,(a0)+
		sub.w	d0,d5

		tst.w	d3
		bge.b	.rok1
		clr.w	d3
		bra.b	.rok2
.rok1		cmp.w	d6,d3
		ble.b	.rok2
		move.w	d6,d3
.rok2
		tst.w	d4
		bge.b	.gok1
		clr.w	d4
		bra.b	.gok2
.gok1		cmp.w	d6,d4
		ble.b	.gok2
		move.w	d6,d4
.gok2
		tst.w	d5
		bge.b	.bok1
		clr.w	d5
		bra.b	.bok2
.bok1		cmp.w	d6,d5
		ble.b	.bok2
		move.w	d6,d5
.bok2

		moveq	#0,d6
		move.w	(conv_p2bitspergun,a5),d0
		move.b	d3,d6
		lsl.w	d0,d6
		move.b	d4,d6
		lsl.l	d0,d6
		move.b	d5,d6
		neg.w	d0
		addq.w	#8,d0
		lsr.l	d0,d6

	;	lea	(conv_p2CLUT1,a5),a0
	;	moveq	#0,d6
	;	move.w	(a0)+,d0
	;	bfins	d3,d6{d0:8}
	;	move.w	(a0)+,d0
	;	bfins	d4,d6{d0:8}
	;	move.b	d5,d6
	;	move.w	(a0)+,d0
	;	lsr.l	d0,d6

		move.w	(a6,d6.l*2),d0			; Eintrag holen
		bpl.b	.found				; ist gültig


		movem.l	d1-d7/a2-a3,-(a7)

		move.w	d3,d0
		move.w	d4,d1
		move.w	d5,d2

		move.l	(conv_wordpalette,a5),a2
	IFEQ	CPU60
		lea	(quadtab,pc),a3
	ENDC
		move.w	(conv_numcolors,a5),d4
		FINDPEN_PALETTE2

		movem.l	(a7)+,d1-d7/a2-a3


		move.w	d0,(a6,d6.l*2)			; eintragen


.found		;	Chunky+OffsetZero ablegen,
		;	Fehlerdifferenz berechnen

		move.w	d0,d6
		add.w	d0,d6
		add.w	d0,d6
		move.b	(conv_pentab,a5,d0.w),(a1)+	; Pixel ablegen

		lea	([conv_wordpalette,a5],d6.w*2),a0
		sub.w	(a0)+,d3
		sub.w	(a0)+,d4
		sub.w	(a0)+,d5		; Fehlerdifferenzen


		subq.w	#1,(conv_xcount,a5)
		bne	.xloop
		
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		
		movem.l	(a7)+,d0-d7/a0/a2-a3
		rts

;-------------------------------------------------------------------------



;-------------------------------------------------------------------------
;
;	Random Dither mit Mapping-Engine
;
;-------------------------------------------------------------------------

		cnop	0,4

DitherLine_Random_CLUT_Map:

		movem.l	d0-d7/a0/a2-a3,-(a7)

		addq.w	#6,a2
		addq.w	#6,a3

		move.l	([conv_mapengine,a5],map_p1table),a6

		move.w	d7,(conv_xcount,a5)

		moveq	#0,d3
		moveq	#0,d4
		moveq	#0,d5

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

.xloop		move.w	#255,d6

		add.w	(a2)+,d3			; Rot (NEU)
		add.w	(a2)+,d4			; Grün
		add.w	(a2)+,d5			; Blau

		move.w	(conv_ditheramount,a5),d7
		move.l	a2,a0

		moveq	#0,d0
		move.w	d6,d1
		sub.w	(a0),d1		; 255 - Rot
		beq.b	.Rno
		cmp.w	d7,d1
		ble.b	.Rok
		move.w	d7,d1
.Rok	;	cmp.w	d3,d1
	;	ble.b	.Rok2
	;	move.w	d3,d1
.Rok2		bsr	GetRandom
.Rno		add.w	d0,(a0)+
		sub.w	d0,d3


		moveq	#0,d0
		move.w	d6,d1
		sub.w	(a0),d1
		beq.b	.Gno
		cmp.w	d7,d1
		ble.b	.Gok
		move.w	d7,d1
.Gok	;	cmp.w	d4,d1
	;	ble.b	.Gok2
	;	move.w	d4,d1
.Gok2		bsr	GetRandom
.Gno		add.w	d0,(a0)+
		sub.w	d0,d4

		moveq	#0,d0
		move.w	d6,d1
		sub.w	(a0),d1
		beq.b	.Bno
		cmp.w	d7,d1
		ble.b	.Bok
		move.w	d7,d1
.Bok	;	cmp.w	d5,d1
	;	ble.b	.Bok2
	;	move.w	d5,d1
.Bok2		bsr	GetRandom
.Bno		add.w	d0,(a0)+
		sub.w	d0,d5

		tst.w	d3
		bge.b	.rok1
		clr.w	d3
		bra.b	.rok2
.rok1		cmp.w	d6,d3
		ble.b	.rok2
		move.w	d6,d3
.rok2
		tst.w	d4
		bge.b	.gok1
		clr.w	d4
		bra.b	.gok2
.gok1		cmp.w	d6,d4
		ble.b	.gok2
		move.w	d6,d4
.gok2
		tst.w	d5
		bge.b	.bok1
		clr.w	d5
		bra.b	.bok2
.bok1		cmp.w	d6,d5
		ble.b	.bok2
		move.w	d6,d5
.bok2
		moveq	#0,d6
		move.w	(conv_p2bitspergun,a5),d0
		move.b	d3,d6
		lsl.w	d0,d6		; %.................RRRRRrrr.....
		move.b	d4,d6		; %.................RRRRRGGGGGggg
		lsl.l	d0,d6		; %            RRRRRGGGGGggg.....
		move.b	d5,d6		; %            RRRRRGGGGGBBBBBbbb
		neg.w	d0
		addq.w	#8,d0
		lsr.l	d0,d6		; %               RRRRRGGGGGBBBBB
		move.b	(a6,d6.l),d0

		;	Chunky+OffsetZero ablegen,
		;	Fehlerdifferenz berechnen

		move.w	d0,d6
		add.w	d0,d6
		add.w	d0,d6
		move.b	(conv_pentab,a5,d0.w),(a1)+	; Pixel ablegen

		lea	([conv_wordpalette,a5],d6.w*2),a0
		sub.w	(a0)+,d3
		sub.w	(a0)+,d4
		sub.w	(a0)+,d5		; Fehlerdifferenzen


		subq.w	#1,(conv_xcount,a5)
		bne	.xloop
		
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		
		movem.l	(a7)+,d0-d7/a0/a2-a3
		rts

;-------------------------------------------------------------------------

		cnop	0,4

DitherLine_Random_HAM8:

		movem.l	d0-d7/a0/a2-a3,-(a7)

		addq.w	#6,a2
		addq.w	#6,a3

		move.w	d7,(conv_xcount,a5)

		moveq	#0,d3
		moveq	#0,d4
		moveq	#0,d5

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

.xloop
		move.w	#255,d6

		add.w	(a2)+,d3			; Rot (NEU)
		add.w	(a2)+,d4			; Grün
		add.w	(a2)+,d5			; Blau


		move.w	(conv_ditheramount,a5),d7
		move.l	a2,a0

		moveq	#0,d0
		move.w	d6,d1
		sub.w	(a0),d1		; 255 - Rot
		beq.b	.Rno
		cmp.w	d7,d1
		ble.b	.Rok
		move.w	d7,d1
.Rok	;	cmp.w	d3,d1
	;	ble.b	.Rok2
	;	move.w	d3,d1
.Rok2		bsr	GetRandom
.Rno		add.w	d0,(a0)+
		sub.w	d0,d3


		moveq	#0,d0
		move.w	d6,d1
		sub.w	(a0),d1
		beq.b	.Gno
		cmp.w	d7,d1
		ble.b	.Gok
		move.w	d7,d1
.Gok	;	cmp.w	d4,d1
	;	ble.b	.Gok2
	;	move.w	d4,d1
.Gok2		bsr	GetRandom
.Gno		add.w	d0,(a0)+
		sub.w	d0,d4

		moveq	#0,d0
		move.w	d6,d1
		sub.w	(a0),d1
		beq.b	.Bno
		cmp.w	d7,d1
		ble.b	.Bok
		move.w	d7,d1
.Bok	;	cmp.w	d5,d1
	;	ble.b	.Bok2
	;	move.w	d5,d1
.Bok2		bsr	GetRandom
.Bno		add.w	d0,(a0)+
		sub.w	d0,d5

		tst.w	d3
		bge.b	.rok1
		clr.w	d3
		bra.b	.rok2
.rok1		cmp.w	d6,d3
		ble.b	.rok2
		move.w	d6,d3
.rok2
		tst.w	d4
		bge.b	.gok1
		clr.w	d4
		bra.b	.gok2
.gok1		cmp.w	d6,d4
		ble.b	.gok2
		move.w	d6,d4
.gok2
		tst.w	d5
		bge.b	.bok1
		clr.w	d5
		bra.b	.bok2
.bok1		cmp.w	d6,d5
		ble.b	.bok2
		move.w	d6,d5
.bok2


		moveq	#0,d0
		bfins	d3,d0{8:8}
		bfins	d4,d0{16:8}
		move.b	d5,d0

		movem.l	d1-d5/d7/a2-a4,-(a7)

		lea	([conv_destpalette,a5],pal_palette),a2
		lea	(quadtab,pc),a3
		move.l	(conv_oldRGB,a5),d1		; oldRGB
		BESTPENHAM8	HAM8_THRESHOLD
		move.l	d1,(conv_oldRGB,a5)		; merken
		move.l	d1,d6

		movem.l	(a7)+,d1-d5/d7/a2-a4

		move.b	d0,(a1)+			; Chunky+OffsetZero ablegen


		bfextu	d6{16:8},d0
		sub.w	d0,d4				; Differenz Grün
		move.b	d6,d0
		sub.w	d0,d5				; Differenz Blau
		swap	d6
		sub.w	d6,d3				; Differenz Rot


		subq.w	#1,(conv_xcount,a5)
		bne	.xloop
		
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		
		movem.l	(a7)+,d0-d7/a0/a2-a3
		rts

;-------------------------------------------------------------------------


;-------------------------------------------------------------------------

		cnop	0,4

DitherLine_Random_HAM6:

		movem.l	d0-d7/a0/a2-a3,-(a7)

		addq.w	#6,a2
		addq.w	#6,a3

		move.w	d7,(conv_xcount,a5)

		moveq	#0,d3
		moveq	#0,d4
		moveq	#0,d5

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

.xloop
		move.w	#255,d6

		add.w	(a2)+,d3			; Rot (NEU)
		add.w	(a2)+,d4			; Grün
		add.w	(a2)+,d5			; Blau


		move.w	(conv_ditheramount,a5),d7
		move.l	a2,a0

		moveq	#0,d0
		move.w	d6,d1
		sub.w	(a0),d1		; 255 - Rot
		beq.b	.Rno
		cmp.w	d7,d1
		ble.b	.Rok
		move.w	d7,d1
.Rok	;	cmp.w	d3,d1
	;	ble.b	.Rok2
	;	move.w	d3,d1
.Rok2		bsr	GetRandom
.Rno		add.w	d0,(a0)+
		sub.w	d0,d3


		moveq	#0,d0
		move.w	d6,d1
		sub.w	(a0),d1
		beq.b	.Gno
		cmp.w	d7,d1
		ble.b	.Gok
		move.w	d7,d1
.Gok	;	cmp.w	d4,d1
	;	ble.b	.Gok2
	;	move.w	d4,d1
.Gok2		bsr	GetRandom
.Gno		add.w	d0,(a0)+
		sub.w	d0,d4

		moveq	#0,d0
		move.w	d6,d1
		sub.w	(a0),d1
		beq.b	.Bno
		cmp.w	d7,d1
		ble.b	.Bok
		move.w	d7,d1
.Bok	;	cmp.w	d5,d1
	;	ble.b	.Bok2
	;	move.w	d5,d1
.Bok2		bsr	GetRandom
.Bno		add.w	d0,(a0)+
		sub.w	d0,d5

		tst.w	d3
		bge.b	.rok1
		clr.w	d3
		bra.b	.rok2
.rok1		cmp.w	d6,d3
		ble.b	.rok2
		move.w	d6,d3
.rok2
		tst.w	d4
		bge.b	.gok1
		clr.w	d4
		bra.b	.gok2
.gok1		cmp.w	d6,d4
		ble.b	.gok2
		move.w	d6,d4
.gok2
		tst.w	d5
		bge.b	.bok1
		clr.w	d5
		bra.b	.bok2
.bok1		cmp.w	d6,d5
		ble.b	.bok2
		move.w	d6,d5
.bok2


		moveq	#0,d0
		bfins	d3,d0{8:8}
		bfins	d4,d0{16:8}
		move.b	d5,d0

		movem.l	d1-d5/d7/a2-a4,-(a7)

		lea	([conv_destpalette,a5],pal_palette),a2
		lea	(quadtab.l,pc),a3
		move.l	(conv_oldRGB,a5),d1		; oldRGB
		BESTPENHAM6
		move.l	d1,(conv_oldRGB,a5)		; merken
		move.l	d1,d6

		movem.l	(a7)+,d1-d5/d7/a2-a4

		move.b	d0,(a1)+			; Chunky+OffsetZero ablegen


		bfextu	d6{16:8},d0
		sub.w	d0,d4				; Differenz Grün
		move.b	d6,d0
		sub.w	d0,d5				; Differenz Blau
		swap	d6
		sub.w	d6,d3				; Differenz Rot


		subq.w	#1,(conv_xcount,a5)
		bne	.xloop
		
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		
		movem.l	(a7)+,d0-d7/a0/a2-a3
		rts

;-------------------------------------------------------------------------

