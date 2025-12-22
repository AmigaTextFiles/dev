
;-------------------------------------------------------------------------
;
;	EDD Dither
;
;-------------------------------------------------------------------------

		cnop	0,4

DitherLine_EDD_CLUT:

		movem.l	d0-d7/a0/a2-a3,-(a7)

		move.l	(conv_p2table,a5),a6
		move.w	d7,(conv_xcount,a5)

		addq.w	#6,a2
		addq.w	#6,a3

		moveq	#0,d3
		moveq	#0,d4
		moveq	#0,d5

		lea	([conv_destpalette,a5],pal_palette),a4

		neg.w	(conv_directionflipflop,a5)
		bpl	DitherLine_EDD_CLUT_2


;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

.xloop		add.w	(a2)+,d3
		add.w	(a2)+,d4
		add.w	(a2)+,d5

		move.w	(bordertab,pc,d3.w*2),d3
		move.w	(bordertab,pc,d4.w*2),d4
		move.w	(bordertab,pc,d5.w*2),d5
		
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

		move.w	(a6,d6.l*2),d0			; Eintrag holen
		bpl.b	.found				; ist gültig


		movem.l	d3-d6/a2/a3,-(a7)

		move.w	d3,d0
		move.w	d4,d1
		move.w	d5,d2

		move.l	(conv_wordpalette,a5),a2
	IFEQ	CPU60
		lea	(quadtab,pc),a3
	ENDC
		move.w	(conv_numcolors,a5),d4
		FINDPEN_PALETTE2

		movem.l	(a7)+,d3-d6/a2/a3


		move.w	d0,(a6,d6.l*2)			; eintragen


.found		;	Chunky+OffsetZero ablegen,
		;	Fehlerdifferenz berechnen

		move.b	(conv_pentab,a5,d0.w),(a1)+	; Pixel ablegen

		;	Fehlerdifferenz berechnen

		moveq	#0,d6
		move.l	(a4,d0.w*4),d0
		move.b	d0,d6
		lsr.w	#8,d0
		sub.w	d0,d4
		swap	d0
		sub.w	d6,d5
		sub.w	d0,d3

		move.w	d3,d0
		move.w	d4,d6
		asr.w	#1,d0
		move.w	d5,d7
		move.w	d0,(a3)+
		asr.w	#1,d6
		asr.w	#1,d7
		move.w	d6,(a3)+
		sub.w	d0,d3
		move.w	d7,(a3)+
		sub.w	d6,d4
		sub.w	d7,d5

		subq.w	#1,(conv_xcount,a5)
		bne	.xloop

		
		movem.l	(a7)+,d0-d7/a0/a2-a3
		rts

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

DitherLine_EDD_CLUT_2

		add.w	d7,a1
		move.l	a1,-(a7)
		
		mulu.w	#6,d7
		add.l	d7,a2
		add.l	d7,a3

.xloop		add.w	-(a2),d5
		add.w	-(a2),d4
		add.w	-(a2),d3

		move.w	(bordertab,pc,d3.w*2),d3
		move.w	(bordertab,pc,d4.w*2),d4
		move.w	(bordertab,pc,d5.w*2),d5
		
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

		move.w	(a6,d6.l*2),d0			; Eintrag holen
		bpl.b	.found				; ist gültig


		movem.l	d3-d6/a2/a3,-(a7)

		move.w	d3,d0
		move.w	d4,d1
		move.w	d5,d2

		move.l	(conv_wordpalette,a5),a2
	IFEQ	CPU60
		lea	(quadtab,pc),a3
	ENDC
		move.w	(conv_numcolors,a5),d4
		FINDPEN_PALETTE2

		movem.l	(a7)+,d3-d6/a2/a3


		move.w	d0,(a6,d6.l*2)			; eintragen


.found		;	Chunky+OffsetZero ablegen,
		;	Fehlerdifferenz berechnen

		move.b	(conv_pentab,a5,d0.w),-(a1)	; Pixel ablegen

		moveq	#0,d6
		move.l	(a4,d0.w*4),d0
		move.b	d0,d6
		lsr.w	#8,d0
		sub.w	d0,d4
		swap	d0
		sub.w	d6,d5
		sub.w	d0,d3

		move.w	d5,d6
		move.w	d4,d0
		asr.w	#1,d6
		move.w	d3,d7
		move.w	d6,-(a3)
		asr.w	#1,d0
		asr.w	#1,d7
		move.w	d0,-(a3)
		sub.w	d6,d5
		move.w	d7,-(a3)
		sub.w	d0,d4
		sub.w	d7,d3

		subq.w	#1,(conv_xcount,a5)
		bne	.xloop

		move.l	(a7)+,a1

		movem.l	(a7)+,d0-d7/a0/a2-a3
		rts

;-------------------------------------------------------------------------



;-------------------------------------------------------------------------
;
;	EDD Dither mit Mapping-Engine
;
;-------------------------------------------------------------------------

		cnop	0,4

DitherLine_EDD_CLUT_Map:

		movem.l	d0-d7/a0/a2-a3,-(a7)

		addq.w	#6,a2
		addq.w	#6,a3

		move.w	d7,(conv_xcount,a5)
		move.l	([conv_mapengine,a5],map_p1table),a6
		lea	([conv_destpalette,a5],pal_palette),a4

		moveq	#0,d3
		moveq	#0,d4
		moveq	#0,d5

		neg.w	(conv_directionflipflop,a5)
		bpl.b	DitherLine_EDD_CLUT_Map_2

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

.xloop		add.w	(a2)+,d3
		add.w	(a2)+,d4
		add.w	(a2)+,d5

		move.w	(bordertab,pc,d3.w*2),d3
		move.w	(bordertab,pc,d4.w*2),d4
		move.w	(bordertab,pc,d5.w*2),d5

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

		move.b	(conv_pentab,a5,d0.w),(a1)+	; Pixel ablegen

		moveq	#0,d6
		move.l	(a4,d0.w*4),d0
		move.b	d0,d6
		lsr.w	#8,d0
		sub.w	d0,d4
		swap	d0
		sub.w	d6,d5
		sub.w	d0,d3

		move.w	d3,d0
		move.w	d4,d6
		asr.w	#1,d0
		move.w	d5,d7
		move.w	d0,(a3)+
		asr.w	#1,d6
		asr.w	#1,d7
		move.w	d6,(a3)+
		sub.w	d0,d3
		move.w	d7,(a3)+
		sub.w	d6,d4
		sub.w	d7,d5

		subq.w	#1,(conv_xcount,a5)
		bne	.xloop

		
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		
		movem.l	(a7)+,d0-d7/a0/a2-a3
		rts


;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

DitherLine_EDD_CLUT_Map_2

		add.w	d7,a1
		move.l	a1,-(a7)

		mulu.w	#6,d7
		add.l	d7,a2
		add.l	d7,a3

.xloop
		add.w	-(a2),d5
		add.w	-(a2),d4
		add.w	-(a2),d3

		move.w	(bordertab,pc,d3.w*2),d3
		move.w	(bordertab,pc,d4.w*2),d4
		move.w	(bordertab,pc,d5.w*2),d5

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

		move.b	(conv_pentab,a5,d0.w),-(a1)	; Pixel ablegen

		moveq	#0,d6
		move.l	(a4,d0.w*4),d0
		move.b	d0,d6
		lsr.w	#8,d0
		sub.w	d0,d4
		swap	d0
		sub.w	d6,d5
		sub.w	d0,d3

		move.w	d5,d6
		move.w	d4,d0
		asr.w	#1,d6
		move.w	d3,d7
		move.w	d6,-(a3)
		asr.w	#1,d0
		asr.w	#1,d7
		move.w	d0,-(a3)
		sub.w	d6,d5
		move.w	d7,-(a3)
		sub.w	d0,d4
		sub.w	d7,d3

		subq.w	#1,(conv_xcount,a5)
		bne	.xloop

		move.l	(a7)+,a1
		
		movem.l	(a7)+,d0-d7/a0/a2-a3
		rts

;-------------------------------------------------------------------------





;-------------------------------------------------------------------------
;
;	EDD Dither auf HAM8
;
;-------------------------------------------------------------------------

		cnop	0,4

DitherLine_EDD_HAM8:

		movem.l	d0-d7/a0/a2-a3,-(a7)

		addq.w	#6,a2
		addq.w	#6,a3

		move.w	d7,(conv_xcount,a5)

		moveq	#0,d3
		moveq	#0,d4
		moveq	#0,d5

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

.xloop
		add.w	(a2)+,d3
		add.w	(a2)+,d4
		add.w	(a2)+,d5

		move.w	(bordertab,pc,d3.w*2),d3
		move.w	(bordertab,pc,d4.w*2),d4
		move.w	(bordertab,pc,d5.w*2),d5

		moveq	#0,d0
		bfins	d3,d0{8:8}
		bfins	d4,d0{16:8}
		move.b	d5,d0

		movem.l	d1-d5/d7/a2/a3,-(a7)

		lea	([conv_destpalette,a5],pal_palette),a2
		lea	(quadtab,pc),a3
		move.l	(conv_oldRGB,a5),d1		; oldRGB
		BESTPENHAM8	HAM8_THRESHOLD
		move.l	d1,(conv_oldRGB,a5)		; merken
		move.l	d1,d6

		movem.l	(a7)+,d1-d5/d7/a2/a3

		move.b	d0,(a1)+			; Chunky+OffsetZero ablegen

		bfextu	d6{16:8},d0
		sub.w	d0,d4				; Differenz Grün
		move.b	d6,d0
		sub.w	d0,d5				; Differenz Blau
		swap	d6
		sub.w	d6,d3				; Differenz Rot

		move.w	d3,d0
		move.w	d4,d6
		asr.w	#1,d0
		move.w	d5,d7
		move.w	d0,(a3)+
		asr.w	#1,d6
		asr.w	#1,d7
		move.w	d6,(a3)+
		sub.w	d0,d3
		move.w	d7,(a3)+
		sub.w	d6,d4
		sub.w	d7,d5

		subq.w	#1,(conv_xcount,a5)
		bne	.xloop

		
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		
		movem.l	(a7)+,d0-d7/a0/a2-a3
		rts

;-------------------------------------------------------------------------




;-------------------------------------------------------------------------
;
;	EDD Dither auf HAM6
;
;-------------------------------------------------------------------------

		cnop	0,4

DitherLine_EDD_HAM6:

		movem.l	d0-d7/a0/a2-a3,-(a7)

		addq.w	#6,a2
		addq.w	#6,a3

		move.w	d7,(conv_xcount,a5)

		moveq	#0,d3
		moveq	#0,d4
		moveq	#0,d5

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

.xloop
		add.w	(a2)+,d3
		add.w	(a2)+,d4
		add.w	(a2)+,d5

		move.w	(bordertab,pc,d3.w*2),d3
		move.w	(bordertab,pc,d4.w*2),d4
		move.w	(bordertab,pc,d5.w*2),d5

		moveq	#0,d0
		bfins	d3,d0{8:8}
		bfins	d4,d0{16:8}
		move.b	d5,d0

		movem.l	d1-d5/d7/a2/a3,-(a7)

		lea	([conv_destpalette,a5],pal_palette),a2
		lea	(quadtab.l,pc),a3
		move.l	(conv_oldRGB,a5),d1		; oldRGB
		BESTPENHAM6
		move.l	d1,(conv_oldRGB,a5)		; merken
		move.l	d1,d6

		movem.l	(a7)+,d1-d5/d7/a2/a3

		move.b	d0,(a1)+			; Chunky+OffsetZero ablegen

		bfextu	d6{16:8},d0
		sub.w	d0,d4				; Differenz Grün
		move.b	d6,d0
		sub.w	d0,d5				; Differenz Blau
		swap	d6
		sub.w	d6,d3				; Differenz Rot

		move.w	d3,d0
		move.w	d4,d6
		asr.w	#1,d0
		move.w	d5,d7
		move.w	d0,(a3)+
		asr.w	#1,d6
		asr.w	#1,d7
		move.w	d6,(a3)+
		sub.w	d0,d3
		move.w	d7,(a3)+
		sub.w	d6,d4
		sub.w	d7,d5

		subq.w	#1,(conv_xcount,a5)
		bne	.xloop

		
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		
		movem.l	(a7)+,d0-d7/a0/a2-a3
		rts

;-------------------------------------------------------------------------
