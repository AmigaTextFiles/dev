
;-------------------------------------------------------------------------
;
;	Floyd-Steinberg Dither
;
;	  P D
;	A B C
;
;-------------------------------------------------------------------------

		cnop	0,4

FSDitherLine_CLUT:

		movem.l	d0-d7/a0/a2-a3,-(a7)

		move.l	(conv_p2table,a5),a6
		lea	([conv_destpalette,a5],pal_palette),a4

		move.l	a3,a0

		move.w	d7,(conv_xcount,a5)

		neg.w	(conv_directionflipflop,a5)
		bpl	FSDitherLine_CLUT2

		addq.w	#6,a2
		addq.w	#6,a3

		moveq	#0,d0			; Ab löschen
		moveq	#0,d7			; Ag:r löschen

		move.w	(a3)+,d1		; Br holen
		asl.w	#4,d1
		move.w	(a3)+,d2		; Bg
		asl.w	#4,d2
		swap	d2
		move.w	(a3)+,d2		; Bb
		asl.w	#4,d2

		movem.w	(a3)+,d3/d4/d5		; C holen, D löschen
		asl.w	#4,d3
		asl.w	#4,d4
		asl.w	#4,d5

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

.xloop		swap	d3
		swap	d4
		asr.w	#4,d3
		swap	d5
		asr.w	#4,d4
		add.w	(a2)+,d3
		asr.w	#4,d5
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

		movem.l	d1-d7/a2/a3,-(a7)

		move.w	d3,d0
		move.w	d4,d1
		move.w	d5,d2

		lea	(quadtab,pc),a3
		move.l	(conv_wordpalette,a5),a2
		move.w	(conv_numcolors,a5),d4
		FINDPEN_PALETTE2

		movem.l	(a7)+,d1-d7/a2/a3

		move.w	d0,(a6,d6.l*2)			; eintragen
.found
		;	Chunky über Pentab ablegen

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
		
		
		;	Fehlerverteilung nach Floyd-Steinberg

		move.w	d3,d6		; n/16
		swap	d5
		add.w	d6,d6		; 2n/16

		add.w	d3,d5		; 1
		add.w	d6,d3
		swap	d5

		add.w	d3,d7		; 3
		add.w	d6,d3
		asr.w	#4,d7

		add.w	d3,d1		; 5
		swap	d7		
		add.w	d6,d3		; 7


		move.w	d4,d6		; n/16
		swap	d3
		add.w	d6,d6		; 2n/16

		add.w	d4,d3		; 1
		swap	d1
		add.w	d6,d4

		add.w	d4,d7		; 3
		add.w	d6,d4

		asr.w	#4,d7

		add.w	d4,d2		; 5
		add.w	d6,d4		; 7


		move.w	d5,d6
		swap	d4
		add.w	d6,d6

		add.w	d5,d4		; 1
		swap	d2
		add.w	d6,d5

		add.w	d5,d1		; 3
		add.w	d6,d5

		add.w	d5,d2		; 5
		asr.w	#4,d1
		add.w	d6,d5		


		;	Fehlerpuffer cyclen

		move.l	d7,(a0)+		; Ar:g ablegen
		swap	d5
		move.w	d1,(a0)+		; Ab ablegen

		move.w	d2,d1			; Bb -> Ab
		move.w	d4,d2			; Cb -> Bb
		swap	d1
		swap	d2
		move.w	d2,d7			; Bg -> A.:g
		swap	d7
		move.w	d3,d2			; Cg -> Bg
		move.w	(a3)+,d3
		move.w	d1,d7			; Br -> Ag:r
		move.w	(a3)+,d4
		move.w	d5,d1			; Cr -> Br
		move.w	(a3)+,d5
		
		subq.w	#1,(conv_xcount,a5)
		bne	.xloop
		
		movem.l	(a7)+,d0-d7/a0/a2-a3
		rts

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

FSDitherLine_CLUT2:

		add.w	d7,a1
		move.l	a1,-(a7)

		addq.w	#6,a2
		
		mulu.w	#6,d7
		add.l	d7,a2
		add.l	d7,a3
		add.l	d7,a0
		add.w	#12,a0

		moveq	#0,d0			; Ab löschen
		moveq	#0,d7			; Ag:r löschen

		move.w	(a3),d1			; Br holen
		asl.w	#4,d1
		move.w	2(a3),d2		; Bg
		asl.w	#4,d2
		swap	d2
		move.w	4(a3),d2		; Bb
		asl.w	#4,d2

		subq.w	#6,a3
		movem.w	(a3),d3/d4/d5		; C holen, D löschen
		asl.w	#4,d3
		asl.w	#4,d4
		asl.w	#4,d5


.xloop		swap	d3
		swap	d4
		swap	d5
		asr.w	#4,d3
		asr.w	#4,d4
		asr.w	#4,d5

		add.w	-(a2),d5
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

		movem.l	d1-d7/a2/a3,-(a7)

		move.w	d3,d0
		move.w	d4,d1
		move.w	d5,d2

		lea	(quadtab,pc),a3
		move.l	(conv_wordpalette,a5),a2
		move.w	(conv_numcolors,a5),d4
		FINDPEN_PALETTE2

		movem.l	(a7)+,d1-d7/a2/a3

		move.w	d0,(a6,d6.l*2)			; eintragen
.found
		;	Chunky über Pentab ablegen

		move.b	(conv_pentab,a5,d0.w),-(a1)	; Pixel ablegen

		;	Fehlerdifferenz berechnen

		moveq	#0,d6
		move.l	(a4,d0.w*4),d0
		move.b	d0,d6
		lsr.w	#8,d0
		sub.w	d0,d4
		swap	d0
		sub.w	d6,d5
		sub.w	d0,d3
		
		
		;	Fehlerverteilung nach Floyd-Steinberg

		move.w	d3,d6		; n/16
		swap	d5
		add.w	d6,d6		; 2n/16

		add.w	d3,d5		; 1
		add.w	d6,d3
		swap	d5

		add.w	d3,d7		; 3
		add.w	d6,d3
		asr.w	#4,d7

		add.w	d3,d1		; 5
		swap	d7		
		add.w	d6,d3		; 7


		move.w	d4,d6		; n/16
		swap	d3
		add.w	d6,d6		; 2n/16

		add.w	d4,d3		; 1
		swap	d1
		add.w	d6,d4

		add.w	d4,d7		; 3
		add.w	d6,d4

		asr.w	#4,d7

		add.w	d4,d2		; 5
		add.w	d6,d4		; 7


		move.w	d5,d6
		swap	d4
		add.w	d6,d6

		add.w	d5,d4		; 1
		swap	d2
		add.w	d6,d5

		add.w	d5,d1		; 3
		add.w	d6,d5

		add.w	d5,d2		; 5
		asr.w	#4,d1
		add.w	d6,d5		


		;	Fehlerpuffer cyclen


		move.w	d1,-(a0)
		swap	d5
		move.l	d7,-(a0)

		move.w	d2,d1			; Bb -> Ab
		move.w	d4,d2			; Cb -> Bb
		swap	d1
		swap	d2
		move.w	d2,d7			; Bg -> A.:g
		swap	d7
		move.w	d3,d2			; Cg -> Bg

		subq.w	#6,a3
		move.w	(a3),d3
		move.w	d1,d7			; Br -> Ag:r
		move.w	2(a3),d4
		move.w	d5,d1			; Cr -> Br
		move.w	4(a3),d5


		subq.w	#1,(conv_xcount,a5)
		bne	.xloop

		move.l	(a7)+,a1
		
		movem.l	(a7)+,d0-d7/a0/a2-a3
		rts


;-------------------------------------------------------------------------


;-------------------------------------------------------------------------
;
;	Floyd-Steinberg Dither mit Mapping-Engine
;
;-------------------------------------------------------------------------

		cnop	0,4

FSDitherLine_CLUT_Map:

		movem.l	d0-d7/a0/a2-a3,-(a7)

		move.l	([conv_mapengine,a5],map_p1table),a6
		lea	([conv_destpalette,a5],pal_palette),a4

		move.l	a3,a0

		move.w	d7,(conv_xcount,a5)

		neg.w	(conv_directionflipflop,a5)
		bpl	FSDitherLine_CLUT_Map2

		addq.w	#6,a2
		addq.w	#6,a3

		moveq	#0,d0			; Ab löschen
		moveq	#0,d7			; Ag:r löschen

		move.w	(a3)+,d1		; Br holen
		asl.w	#4,d1
		move.w	(a3)+,d2		; Bg
		asl.w	#4,d2
		swap	d2
		move.w	(a3)+,d2		; Bb
		asl.w	#4,d2

		movem.w	(a3)+,d3/d4/d5		; C holen, D löschen
		asl.w	#4,d3
		asl.w	#4,d4
		asl.w	#4,d5

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

.xloop
		swap	d3
		swap	d4
		swap	d5
		asr.w	#4,d3
		asr.w	#4,d4
		asr.w	#4,d5
		add.w	(a2)+,d3
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
		move.b	(a6,d6.l),d0

		;	Chunky über Pentab ablegen

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
		
		
		;	Fehlerverteilung nach Floyd-Steinberg

		move.w	d3,d6		; n/16
		swap	d5
		add.w	d6,d6		; 2n/16

		add.w	d3,d5		; 1
		add.w	d6,d3
		swap	d5

		add.w	d3,d7		; 3
		add.w	d6,d3
		asr.w	#4,d7

		add.w	d3,d1		; 5
		swap	d7		
		add.w	d6,d3		; 7


		move.w	d4,d6		; n/16
		swap	d3
		add.w	d6,d6		; 2n/16

		add.w	d4,d3		; 1
		swap	d1
		add.w	d6,d4

		add.w	d4,d7		; 3
		add.w	d6,d4

		asr.w	#4,d7

		add.w	d4,d2		; 5
		add.w	d6,d4		; 7


		move.w	d5,d6
		swap	d4
		add.w	d6,d6

		add.w	d5,d4		; 1
		swap	d2
		add.w	d6,d5

		add.w	d5,d1		; 3
		add.w	d6,d5

		add.w	d5,d2		; 5
		asr.w	#4,d1
		add.w	d6,d5		


		;	Fehlerpuffer cyclen

		move.l	d7,(a0)+		; Ar:g ablegen
		swap	d5
		move.w	d1,(a0)+		; Ab ablegen

		move.w	d2,d1			; Bb -> Ab
		move.w	d4,d2			; Cb -> Bb
		swap	d1
		swap	d2
		move.w	d2,d7			; Bg -> A.:g
		swap	d7
		move.w	d3,d2			; Cg -> Bg
		move.w	(a3)+,d3
		move.w	d1,d7			; Br -> Ag:r
		move.w	(a3)+,d4
		move.w	d5,d1			; Cr -> Br
		move.w	(a3)+,d5
		

		subq.w	#1,(conv_xcount,a5)
		bne	.xloop
		
		
		movem.l	(a7)+,d0-d7/a0/a2-a3
		rts


;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

FSDitherLine_CLUT_Map2:

		add.w	d7,a1
		move.l	a1,-(a7)

		addq.w	#6,a2
		
		mulu.w	#6,d7
		add.l	d7,a2
		add.l	d7,a3
		add.l	d7,a0
		add.w	#12,a0

		moveq	#0,d0			; Ab löschen
		moveq	#0,d7			; Ag:r löschen

		move.w	(a3),d1			; Br holen
		asl.w	#4,d1
		move.w	2(a3),d2		; Bg
		asl.w	#4,d2
		swap	d2
		move.w	4(a3),d2		; Bb
		asl.w	#4,d2

		subq.w	#6,a3
		movem.w	(a3),d3/d4/d5		; C holen, D löschen
		asl.w	#4,d3
		asl.w	#4,d4
		asl.w	#4,d5

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

.xloop
		swap	d3
		swap	d4
		swap	d5

		asr.w	#4,d3
		asr.w	#4,d4
		asr.w	#4,d5

		add.w	-(a2),d5
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
		move.b	(a6,d6.l),d0

		;	Chunky über Pentab ablegen

		move.b	(conv_pentab,a5,d0.w),-(a1)	; Pixel ablegen


		;	Fehlerdifferenz berechnen

		moveq	#0,d6
		move.l	(a4,d0.w*4),d0
		move.b	d0,d6
		lsr.w	#8,d0
		sub.w	d0,d4
		swap	d0
		sub.w	d6,d5
		sub.w	d0,d3
		
		
		;	Fehlerverteilung nach Floyd-Steinberg

		move.w	d3,d6		; n/16
		swap	d5
		add.w	d6,d6		; 2n/16

		add.w	d3,d5		; 1
		add.w	d6,d3
		swap	d5

		add.w	d3,d7		; 3
		add.w	d6,d3
		asr.w	#4,d7

		add.w	d3,d1		; 5
		swap	d7		
		add.w	d6,d3		; 7


		move.w	d4,d6		; n/16
		swap	d3
		add.w	d6,d6		; 2n/16

		add.w	d4,d3		; 1
		swap	d1
		add.w	d6,d4

		add.w	d4,d7		; 3
		add.w	d6,d4

		asr.w	#4,d7

		add.w	d4,d2		; 5
		add.w	d6,d4		; 7


		move.w	d5,d6
		swap	d4
		add.w	d6,d6

		add.w	d5,d4		; 1
		swap	d2
		add.w	d6,d5

		add.w	d5,d1		; 3
		add.w	d6,d5

		add.w	d5,d2		; 5
		asr.w	#4,d1
		add.w	d6,d5		


		;	Fehlerpuffer cyclen

		move.w	d1,-(a0)		; Ab ablegen
		swap	d5
		move.l	d7,-(a0)		; Ar:g ablegen

		move.w	d2,d1			; Bb -> Ab
		move.w	d4,d2			; Cb -> Bb
		swap	d1
		swap	d2
		move.w	d2,d7			; Bg -> A.:g
		swap	d7
		move.w	d3,d2			; Cg -> Bg

		subq.w	#6,a3
		move.w	(a3),d3
		move.w	d1,d7			; Br -> Ag:r
		move.w	2(a3),d4
		move.w	d5,d1			; Cr -> Br
		move.w	4(a3),d5

		subq.w	#1,(conv_xcount,a5)
		bne	.xloop

		move.l	(a7)+,a1
		
		movem.l	(a7)+,d0-d7/a0/a2-a3
		rts

;-------------------------------------------------------------------------


;-------------------------------------------------------------------------
;
;	Floyd-Steinberg Dither HAM8
;
;-------------------------------------------------------------------------

		cnop	0,4

FSDitherLine_HAM8:

		movem.l	d0-d7/a0/a2-a3,-(a7)

	;!	move.l	([conv_mapengine,a5],map_p1table),a6
		lea	([conv_destpalette,a5],pal_palette),a4

		move.l	a3,a0

		addq.w	#6,a2
		addq.w	#6,a3

		move.w	d7,(conv_xcount,a5)

		moveq	#0,d0			; Ab löschen
		moveq	#0,d7			; Ag:r löschen

		move.w	(a3)+,d1		; Br holen
		asl.w	#4,d1
		move.w	(a3)+,d2		; Bg
		asl.w	#4,d2
		swap	d2
		move.w	(a3)+,d2		; Bb
		asl.w	#4,d2

		movem.w	(a3)+,d3/d4/d5		; C holen, D löschen
		asl.w	#4,d3
		asl.w	#4,d4
		asl.w	#4,d5

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

.xloop
		swap	d3
		swap	d4
		asr.w	#4,d3
		swap	d5
		add.w	(a2)+,d3
		asr.w	#4,d4
		add.w	(a2)+,d4
		asr.w	#4,d5
		add.w	(a2)+,d5

		move.w	(bordertab,pc,d3.w*2),d3
		move.w	(bordertab,pc,d4.w*2),d4
		move.w	(bordertab,pc,d5.w*2),d5

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

		
		;	Fehlerverteilung nach Floyd-Steinberg

		move.w	d3,d6		; n/16
		swap	d5
		add.w	d6,d6		; 2n/16

		add.w	d3,d5		; 1
		add.w	d6,d3
		swap	d5

		add.w	d3,d7		; 3
		add.w	d6,d3
		asr.w	#4,d7

		add.w	d3,d1		; 5
		swap	d7		
		add.w	d6,d3		; 7


		move.w	d4,d6		; n/16
		swap	d3
		add.w	d6,d6		; 2n/16

		add.w	d4,d3		; 1
		swap	d1
		add.w	d6,d4

		add.w	d4,d7		; 3
		add.w	d6,d4

		asr.w	#4,d7

		add.w	d4,d2		; 5
		add.w	d6,d4		; 7


		move.w	d5,d6
		swap	d4
		add.w	d6,d6

		add.w	d5,d4		; 1
		swap	d2
		add.w	d6,d5

		add.w	d5,d1		; 3
		add.w	d6,d5

		add.w	d5,d2		; 5
		asr.w	#4,d1
		add.w	d6,d5		


		;	Fehlerpuffer cyclen

		move.l	d7,(a0)+		; Ar:g ablegen
		swap	d5
		move.w	d1,(a0)+		; Ab ablegen

		move.w	d2,d1			; Bb -> Ab
		move.w	d4,d2			; Cb -> Bb
		swap	d1
		swap	d2
		move.w	d2,d7			; Bg -> A.:g
		swap	d7
		move.w	d3,d2			; Cg -> Bg
		move.w	(a3)+,d3
		move.w	d1,d7			; Br -> Ag:r
		move.w	(a3)+,d4
		move.w	d5,d1			; Cr -> Br
		move.w	(a3)+,d5
		

		subq.w	#1,(conv_xcount,a5)
		bne	.xloop
		
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		
		movem.l	(a7)+,d0-d7/a0/a2-a3
		rts

;-------------------------------------------------------------------------


;-------------------------------------------------------------------------
;
;	Floyd-Steinberg Dither HAM6
;
;-------------------------------------------------------------------------

		cnop	0,4

FSDitherLine_HAM6:

		movem.l	d0-d7/a0/a2-a3,-(a7)

		lea	([conv_destpalette,a5],pal_palette),a4

		move.l	a3,a0

		addq.w	#6,a2
		addq.w	#6,a3

		move.w	d7,(conv_xcount,a5)

		moveq	#0,d0			; Ab löschen
		moveq	#0,d7			; Ag:r löschen

		move.w	(a3)+,d1		; Br holen
		asl.w	#4,d1
		move.w	(a3)+,d2		; Bg
		asl.w	#4,d2
		swap	d2
		move.w	(a3)+,d2		; Bb
		asl.w	#4,d2

		movem.w	(a3)+,d3/d4/d5		; C holen, D löschen
		asl.w	#4,d3
		asl.w	#4,d4
		asl.w	#4,d5

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

.xloop
		swap	d3
		swap	d4
		asr.w	#4,d3
		swap	d5
		add.w	(a2)+,d3
		asr.w	#4,d4
		add.w	(a2)+,d4
		asr.w	#4,d5
		add.w	(a2)+,d5

		move.w	(bordertab,pc,d3.w*2),d3
		move.w	(bordertab,pc,d4.w*2),d4
		move.w	(bordertab,pc,d5.w*2),d5

		moveq	#0,d0
		bfins	d3,d0{8:8}
		bfins	d4,d0{16:8}
		move.b	d5,d0

		movem.l	d1-d5/d7/a2-a4,-(a7)

		lea	([conv_destpalette,a5],pal_palette),a2
		lea	(quadtab,pc),a3
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

		
		;	Fehlerverteilung nach Floyd-Steinberg

		move.w	d3,d6		; n/16
		swap	d5
		add.w	d6,d6		; 2n/16

		add.w	d3,d5		; 1
		add.w	d6,d3
		swap	d5

		add.w	d3,d7		; 3
		add.w	d6,d3
		asr.w	#4,d7

		add.w	d3,d1		; 5
		swap	d7		
		add.w	d6,d3		; 7


		move.w	d4,d6		; n/16
		swap	d3
		add.w	d6,d6		; 2n/16

		add.w	d4,d3		; 1
		swap	d1
		add.w	d6,d4

		add.w	d4,d7		; 3
		add.w	d6,d4

		asr.w	#4,d7

		add.w	d4,d2		; 5
		add.w	d6,d4		; 7


		move.w	d5,d6
		swap	d4
		add.w	d6,d6

		add.w	d5,d4		; 1
		swap	d2
		add.w	d6,d5

		add.w	d5,d1		; 3
		add.w	d6,d5

		add.w	d5,d2		; 5
		asr.w	#4,d1
		add.w	d6,d5		


		;	Fehlerpuffer cyclen

		move.l	d7,(a0)+		; Ar:g ablegen
		swap	d5
		move.w	d1,(a0)+		; Ab ablegen

		move.w	d2,d1			; Bb -> Ab
		move.w	d4,d2			; Cb -> Bb
		swap	d1
		swap	d2
		move.w	d2,d7			; Bg -> A.:g
		swap	d7
		move.w	d3,d2			; Cg -> Bg
		move.w	(a3)+,d3
		move.w	d1,d7			; Br -> Ag:r
		move.w	(a3)+,d4
		move.w	d5,d1			; Cr -> Br
		move.w	(a3)+,d5
		

		subq.w	#1,(conv_xcount,a5)
		bne	.xloop
		
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		
		movem.l	(a7)+,d0-d7/a0/a2-a3
		rts

;-------------------------------------------------------------------------
