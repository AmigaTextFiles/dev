

	IFNE	0
;
;	>	d0	RGB
;	<	d0	YUV
;

rgb2yuv:
	movem.l	d1/d2,-(a7)

	moveq	#0,d2
	move.b	d0,d2
	move.w	d0,d1
	lsr.w	#8,d1
	swap	d0
	
	fmove.s	#0.299,fp3
	fmul.w	d0,fp6
	fmove.x	fp6,fp0
	fmove.s	#0.587,fp3
	fmul.w	d1,fp6
	fadd.x	fp6,fp0
	fmove.s	#0.114,fp3
	fmul.w	d2,fp6
	fadd.x	fp6,fp0

	fmove.s	#-0.147,fp3
	fmul.w	d0,fp6
	fmove.x	fp6,fp1
	fmove.s	#-0.289,fp3
	fmul.w	d1,fp6
	fadd.x	fp6,fp1
	fmove.s	#0.436,fp3
	fmul.w	d2,fp6
	fadd.x	fp6,fp1
	fadd.w	#111,fp1
	fmul.s	#1.14864865,fp1

	fmove.s	#0.615,fp3
	fmul.w	d0,fp6
	fmove.x	fp6,fp2
	fmove.s	#-0.515,fp3
	fmul.w	d1,fp6
	fadd.x	fp6,fp2
	fmove.s	#-0.100,fp3
	fmul.w	d2,fp6
	fadd.x	fp6,fp2
	fadd.w	#156,fp2
	fmul.s	#0.817307692,fp2
	
	moveq	#0,d0
	fmove.w	fp0,d0
	lsl.w	#8,d0
	fmove.b	fp1,d0
	lsl.w	#8,d0
	fmove.b	fp2,d0
	
	movem.l	(a7)+,d1/d2
	rts
	
	ENDC



;------------------------------------------------------------------------

	STRUCTURE	MedianKnoten,0		; Ein Knoten im Medianbaum
		APTR	mdnode_first		; erste Verzweigung
		APTR	mdnode_second		; zweite Verzweigung
		APTR	mdnode_lowerbound	; untere Grenze Feldteilung
		APTR	mdnode_upperbound	; obere Grenze Feldteilung
		ULONG	mdnode_fieldRGB		; vom Feld repräsentierter RGB
		DOUBLE	mdnode_diversity	; Diversität in 64Bit/Float
		UWORD	mdnode_separate		; zu teilende Farbkomponente
		UWORD	mdnode_min
		UWORD	mdnode_max
	LABEL		mdnode_SIZEOF

;------------------------------------------------------------------------



;         /\
;    ____/  \____   
;    \   \  /|  / 				      $VER: MedianCut v1.6
;==== \   \/ | / =========================================================
;----- \   | |/ ----------------------------------------------------------
;       \  | /
;        \ |/	MedianCut v1.6
;         \/
;
;		Farbquantisierung.
;
;	v1.5	- benutzt jetzt Zeigerfelder.
;	v1.6	- Buffer werden wieder intern gehandhabt.
;		- Datenaustausch über Mediandatenstruktur.
;
;	>	a0	APTR	Mediandatenstruktur
;	<	d0	ULONG	Rückgabewert EXTP_...
;
;------------------------------------------------------------------------

MedianCut:	movem.l	d1-d7/a0-a6,-(a7)


		lea	(mdc_split1,pc),a1
		move.l	a1,(mdd_splitfunc,a0)

		lea	(mdc_diversity1,pc),a1
		move.l	a1,(mdd_diversityfunc,a0)
		

	IFNE	USEFPU
		fmovem	fp0-fp5,-(a7)
	ENDC

		move.l	a0,a6
		
;- - - ---- -    -- ---- -    -    - -- - -- -  --- --   -- -    - -  ---
;
;		interne Puffer vorbereiten


		clr.l	(mdd_buffers,a6)
		clr.l	(mdd_sqrbuffer,a6)


		; Medianbaum- und Rekursions-Puffer:

		move.w	(mdd_destcolors,a6),d0
		add.w	d0,d0			; für Medianbaum:
		subq.w	#1,d0			; 2 × Zielfarben - 1
		mulu.w	#mdnode_SIZEOF,d0	; x Größe eines Knotens
		addq.l	#8,d0			; + 8
		
		move.l	(mdd_memhandler,a6),a0
		bsr	AllocRenderVec
		move.l	d0,(mdd_buffers,a6)
		tst.l	d0
		bne.b	.bufok
		moveq	#EXTP_NOT_ENOUGH_MEMORY,d0
		bra	mdc_abort

.bufok		move.l	d0,a3			; Medianbaum-Rootnode
		lea	(mdnode_SIZEOF,a3),a2	; Medianbaum-MemPtr


	IFEQ	USEFPU
	
		; 68020-Code: Quadratwurzel-Puffer anlegen
	
		move.l	(mdd_memhandler,a6),a0
		move.l	(mdd_histocolors,a6),d0	; Anzahl Farben im Histogramm
		add.l	d0,d0
		bsr	AllocRenderVec
		move.l	d0,(mdd_sqrbuffer,a6)
		tst.l	d0
		bne.b	.sqrbufok
		moveq	#EXTP_NOT_ENOUGH_MEMORY,d0
		bra	mdc_abort
	ENDC

.sqrbufok

;- - - ---- -    -- ---- -    -    - -- - -- -  --- --   -- -    - -  ---
;
;		initialisieren


		move.w	(mdd_destcolors,a6),d7
		subq.w	#2,d7				; Anzahl Separationen - 2

		move.l	(mdd_histocolors,a6),d1		; Anzahl Farben im Histogramm

		move.l	(mdd_hparray,a6),a0		; Zeigerfeld


;- - - ---- -    -- ---- -    -    - -- - -- -  --- --   -- -    - -  ---
;
;		Rootnode anlegen

		lea	-4(a0,d1.l*4),a1

		move.l	a0,(mdnode_lowerbound,a3)	; LowerBound
		move.l	a1,(mdnode_upperbound,a3)	; UpperBound
		clr.l	(mdnode_first,a3)
		clr.l	(mdnode_second,a3)

		jsr	([mdd_diversityfunc,a6])	;bsr	mdc_diversity

	IFNE	USEFPU
		fmove.d	fp0,(mdnode_diversity,a3)
	ELSE
		movem.l	d0/d1,(mdnode_diversity,a3)
	ENDC
		move.w	d2,(mdnode_separate,a3)		; Unterteilung
		move.l	d3,(mdnode_fieldRGB,a3)		; Feldmittelfarbe

		move.w	d2,d0
		bsr	mdc_minmax
		movem.w	d0/d1,(mdnode_min,a3)

;- - - ---- -    -- ---- -    -    - -- - -- -  --- --   -- -    - -  ---
;
;		Hauptschleife der Quantisierung


mdc_loop	move.l	a3,d0				; ab Rootnode nach Endknoten
		bsr.w	mdc_findnode			; für nächste Unterteilung suchen

		move.l	d0,a4				; an diesem Knoten
		bsr.w	mdc_separate			; Feldteilung durchführen

			move.l	(mdd_progresshook,a6),d0	;!!!!
			beq.b	mdc_skipcb
			movem.l	d1-d4,-(a7)
			move.l	(mdd_histogram,a6),d1		;!!!! Objekt
			moveq	#0,d4
			move.w	(mdd_destcolors,a6),d4		; Total
			move.l	d4,d3
			sub.w	d7,d3
			moveq	#PMSGTYPE_COLORS_CHOSEN,d2	; Messagetyp
			PROGRESSCALLBACK
			movem.l	(a7)+,d1-d4
			tst.w	d0
			beq.w	mdc_abort

mdc_skipcb	dbf	d7,mdc_loop

;- - - ---- -    -- ---- -    -    - -- - -- -  --- --   -- -    - -  ---
;
;		Zielfarbtabelle erzeugen

		move.l	a3,a0
		lea	(mdd_coltab,a6),a1
		bsr.b	mdc_makecoltab

		moveq	#EXTP_SUCCESS,d0
		bra.b	mdc_okay

;- - - ---- -    -- ---- -    -    - -- - -- -  --- --   -- -    - -  ---

mdc_abort	moveq	#EXTP_CALLBACK_ABORTED,d0

mdc_okay	move.l	d0,d7

	IFEQ	USEFPU
		move.l	(mdd_sqrbuffer,a6),d0
		beq.b	.nosqrbuf
		move.l	d0,a0
		bsr	FreeRenderVec
	ENDC

.nosqrbuf	move.l	(mdd_buffers,a6),d0
		beq.b	.nobufs
		move.l	d0,a0
		bsr	FreeRenderVec
.nobufs

		move.l	d7,d0

	IFNE	USEFPU
		fmovem	(a7)+,fp0-fp5
	ENDC
		movem.l	(a7)+,d1-d7/a0-a6
		rts

;------------------------------------------------------------------------


;------------------------------------------------------------------------
;
;		Medianbaum in Zielfarben
;		zerlegen (rekursiv)
;
;	>	a0	Startknoten
;		a1	Ziel-Farbtabelle
;
;------------------------------------------------------------------------

mdc_makecoltab	move.l	(mdnode_first,a0),d3
		bne.b	mdc_more

		move.l	(mdnode_fieldRGB,a0),d2

	;!	move.l	(mdd_filterhook,a6),d0
	;!	beq.b	.nofilt
	;!	move.l	(mdd_histogram,a6),d1
	;!
	;!	FILTERCALLBACK
	;!
	;!	move.l	d0,d2
.nofilt
		move.l	d2,(a1)+
		rts

mdc_more	move.l	(mdnode_second,a0),d1
		move.l	a0,-(a7)
		move.l	d1,-(a7)
		move.l	d3,a0
		bsr.b	mdc_makecoltab
		move.l	(a7)+,a0
		bsr.b	mdc_makecoltab
		move.l	(a7)+,a0
		rts

;------------------------------------------------------------------------
;
;		nach Endknoten mit größter
;		Diversität suchen (rekursiv)
;
;	>	d0	Knoten, bei dem Suche startet
;	<	d0	Endknoten mit größter Diversität
;
;------------------------------------------------------------------------

mdc_findnode	movem.l	a0/d1-d6,-(a7)

		move.l	d0,a0			; Suchstart

	IFNE	USEFPU
		fmove.w	#0,fp1			; bisher max. Diversität
	ELSE
		moveq	#0,d3			; bisher größte Diversität HI
		moveq	#0,d4			; bisher größte Diversität LO
	ENDC
		bsr.b	mdc_findrecurse

		movem.l	(a7)+,a0/d1-d6
		rts

mdc_findrecurse	move.l	(mdnode_first,a0),d1
		move.l	(mdnode_second,a0),d2
		beq.b	mdc_frec_nomore

		move.l	a0,-(a7)
		move.l	d2,-(a7)
		move.l	d1,a0
		bsr.b	mdc_findrecurse
		move.l	(a7)+,a0
		bsr.b	mdc_findrecurse
		move.l	(a7)+,a0
		rts

mdc_frec_nomore

	IFNE	USEFPU

		fmove.d	(mdnode_diversity,a0),fp0
		fcmp.x	fp1,fp0
		fble	mdc_frec_bye
		fmove.x	fp0,fp1

	ELSE

		move.l	(mdnode_diversity,a0),d5
		cmp.l	d3,d5
		blo.b	mdc_frec_bye
		move.l	(mdnode_diversity+4,a0),d6
		cmp.l	d4,d6
		blo.b	mdc_frec_bye

		move.l	d5,d3
		move.l	d6,d4
	
	ENDC
		move.l	a0,d0

mdc_frec_bye	rts

;------------------------------------------------------------------------
;
;		Feld unterteilen und
;		zwei neue Knoten anlegen
;
;	>	a4	Parent-Node
;		a2	MemPointer
;		a5	Rekursionspuffer
;	<	a2	neuer MemPointer
;
;------------------------------------------------------------------------

mdc_separate	movem.l	d0-d7/a0-a1,-(a7)

		move.l	(mdnode_lowerbound,a4),a0
		move.l	(mdnode_upperbound,a4),a1
		move.w	(mdnode_separate,a4),d0
		
		move.w	(mdnode_max,a4),d1
		sub.w	(mdnode_min,a4),d1
		lsr.w	#1,d1	
		add.w	(mdnode_min,a4),d1

		move.l	a0,d4			; lower first merken
		move.l	a1,d7			; upper second merken

	;	bsr.w	mdc_sortRGB		; das Feld sortieren
	;	jsr	([mdd_splitfunc,a6])	; bsr.b	mdc_split

		bsr	mdc_splitnew

		move.l	a0,d5			; upper first merken
		move.l	a1,d6			; lower second merken



		;	erste Child-Node erzeugen

		move.l	a2,(mdnode_first,a4)		; Node in Parent eintragen
		move.l	d4,(mdnode_lowerbound,a2)	; LowerBound
		move.l	d5,(mdnode_upperbound,a2)	; UpperBound
		clr.l	(mdnode_first,a2)
		clr.l	(mdnode_second,a2)
		move.l	d4,a0
		move.l	d5,a1

		jsr	([mdd_diversityfunc,a6])	;bsr	mdc_diversity
	IFNE	USEFPU
		fmove.d	fp0,(mdnode_diversity,a2)
	ELSE
		movem.l	d0/d1,(mdnode_diversity,a2)
	ENDC
		move.w	d2,(mdnode_separate,a2)
		move.l	d3,(mdnode_fieldRGB,a2)		; Feldmittelfarbe
		
		move.w	d2,d0
		bsr	mdc_minmax
		movem.w	d0/d1,(mdnode_min,a2)
		
		add.w	#mdnode_SIZEOF,a2



		;	zweite Child-Node erzeugen

		move.l	a2,(mdnode_second,a4)		; Node in Parent eintragen
		move.l	d6,(mdnode_lowerbound,a2)	; LowerBound
		move.l	d7,(mdnode_upperbound,a2)	; UpperBound
		clr.l	(mdnode_first,a2)
		clr.l	(mdnode_second,a2)
		move.l	d6,a0
		move.l	d7,a1

		jsr	([mdd_diversityfunc,a6])	;	bsr	mdc_diversity
	IFNE	USEFPU
		fmove.d	fp0,(mdnode_diversity,a2)
	ELSE
		movem.l	d0/d1,(mdnode_diversity,a2)		;!!!!!
	ENDC
		move.w	d2,(mdnode_separate,a2)
		move.l	d3,(mdnode_fieldRGB,a2)		; Feldmittelfarbe

		move.w	d2,d0
		bsr	mdc_minmax
		movem.w	d0/d1,(mdnode_min,a2)

		add.w	#mdnode_SIZEOF,a2

		movem.l	(a7)+,d0-d7/a0-a1
		rts


;------------------------------------------------------------------------
;
;		sortiert eine Histogrammtabelle aufsteigend
;		nach dem Anteil einer Farbkomponente
;
;	>	a0	Lower Bound
;		a1	Upper Bound
;		a5	Rekursionspuffer
;		d0	nach welcher Farbkomponente (R/G/B)
;
;------------------------------------------------------------------------

		cnop	0,4

mdc_sortRGB	movem.l	a0-a3/d0-d4,-(a7)
		
		tst.w	d0
		bmi.w	mdc_sortB
		bne.b	mdc_sortG

;- - - ---- -    -- ---- -    -    - -- - -- -  --- --   -- -    - -  ---

mdc_sortR	move.l	a1,(a5)+		; letzte Adresse
		move.l	a0,(a5)+		; erste Adresse
		move.l	a5,d1			; Stackptr merken

mdc_sR1		move.l	-(a5),d2		; Feldgrenzen holen
		move.l	-(a5),a0

		move.l	a0,a1
mdc_sR2		move.l	d2,a2

		move.l	d2,d0			; Feldmitte:
		sub.l	a0,d0			; Differenz in Bytes...
		asr.l	#3,d0			; ...in Einträgen / 2
		move.l	(a0,d0.l*4),a3		; Feldelement holen
		move.w	(a3),d3

mdc_sR3		move.l	(a2)+,a3
		cmp.w	(a3),d3
		bhi.b	mdc_sR3
		addq.w	#4,a1
		subq.w	#4,a2
mdc_sR4		move.l	-(a1),a3
		cmp.w	(a3),d3
		blo.b	mdc_sR4

		cmp.l	a1,a2
		bgt.b	mdc_sR6

		move.l	(a2),d4
		move.l	(a1),d0
		move.l	d4,(a1)
		subq.w	#4,a1
		move.l	d0,(a2)+

		cmp.l	a1,a2
		ble.b	mdc_sR3

mdc_sR6		cmp.l	a0,a2
		bge.b	mdc_sR5

		move.l	a0,(a5)+		; neue Feldunterteilung
		move.l	a2,(a5)+

mdc_sR5		move.l	a1,a0
		cmp.l	a0,d2
		blt.b	mdc_sR2
		
		cmp.l	d1,a5			; Rekursion beendet?
		bge.b	mdc_sR1			; nein, weiter

		movem.l	(a7)+,a0-a3/d0-d4
		rts

;- - - ---- -    -- ---- -    -    - -- - -- -  --- --   -- -    - -  ---

		cnop	0,4
mdc_sortG	move.l	a1,(a5)+		; letzte Adresse
		move.l	a0,(a5)+		; erste Adresse
		move.l	a5,d1			; Stackptr merken

mdc_sG1		move.l	-(a5),d2		; Feldgrenzen holen
		move.l	-(a5),a0

		move.l	a0,a1
mdc_sG2		move.l	d2,a2

		move.l	d2,d0			; Feldmitte:
		sub.l	a0,d0			; Differenz in Bytes...
		asr.l	#3,d0			; ...in Einträgen / 2
		move.l	(a0,d0.l*4),a3		; Feldelement holen
		move.b	2(a3),d3

mdc_sG3		move.l	(a2)+,a3
		cmp.b	2(a3),d3
		bhi.b	mdc_sG3
		addq.w	#4,a1
		subq.w	#4,a2
mdc_sG4		move.l	-(a1),a3
		cmp.b	2(a3),d3
		blo.b	mdc_sG4

		cmp.l	a1,a2
		bgt.b	mdc_sG6

		move.l	(a2),d4
		move.l	(a1),d0
		move.l	d4,(a1)
		subq.w	#4,a1
		move.l	d0,(a2)+

		cmp.l	a1,a2
		ble.b	mdc_sG3

mdc_sG6		cmp.l	a0,a2
		bge.b	mdc_sG5

		move.l	a0,(a5)+		; neue Feldunterteilung
		move.l	a2,(a5)+

mdc_sG5		move.l	a1,a0
		cmp.l	a0,d2
		blt.b	mdc_sG2
		
		cmp.l	d1,a5			; Rekursion beendet?
		bge.b	mdc_sG1			; nein, weiter
		
		movem.l	(a7)+,a0-a3/d0-d4
		rts

;- - - ---- -    -- ---- -    -    - -- - -- -  --- --   -- -    - -  ---

		cnop	0,4
mdc_sortB	move.l	a1,(a5)+		; letzte Adresse
		move.l	a0,(a5)+		; erste Adresse
		move.l	a5,d1			; Stackptr merken

mdc_sB1		move.l	-(a5),d2		; Feldgrenzen holen
		move.l	-(a5),a0

		move.l	a0,a1
mdc_sB2		move.l	d2,a2

		move.l	d2,d0			; Feldmitte:
		sub.l	a0,d0			; Differenz in Bytes...
		asr.l	#3,d0			; ...in Einträgen / 2
		move.l	(a0,d0.l*4),a3		; Feldelement holen
		move.b	3(a3),d3

mdc_sB3		move.l	(a2)+,a3
		cmp.b	3(a3),d3
		bhi.b	mdc_sB3
		addq.w	#4,a1
		subq.w	#4,a2
mdc_sB4		move.l	-(a1),a3
		cmp.b	3(a3),d3
		blo.b	mdc_sB4

		cmp.l	a1,a2
		bgt.b	mdc_sB6

		move.l	(a2),d4
		move.l	(a1),d0
		move.l	d4,(a1)
		subq.w	#4,a1
		move.l	d0,(a2)+

		cmp.l	a1,a2
		ble.b	mdc_sB3

mdc_sB6		cmp.l	a0,a2
		bge.b	mdc_sB5

		move.l	a0,(a5)+		; neue Feldunterteilung
		move.l	a2,(a5)+

mdc_sB5		move.l	a1,a0
		cmp.l	a0,d2
		blt.b	mdc_sB2
		
		cmp.l	d1,a5			; Rekursion beendet?
		bge.b	mdc_sB1			; nein, weiter

		movem.l	(a7)+,a0-a3/d0-d4
		rts

;-------------------------------------------------------------------------
;========================================================================





;////////////////////////////////////////////////////////////////////////



;========================================================================
;------------------------------------------------------------------------
;
;		Feldteilung #1
;
;		Trennung am Gleichgewichtspunkt der Diversität
;
;	>	a0	lower bound
;		a1	upper bound
;		d0	Farbkomponente (R/G/B)
;	<	a0	upper bound untere Unterteilung
;		a1	lower bound obere Unterteilung
;
;------------------------------------------------------------------------

		cnop	0,4

mdc_split1	movem.l	d0-d7/a2-a6,-(a7)

		move.l	a1,a3
		sub.l	a0,a3
		moveq	#4,d1
		cmp.l	d1,a3
		ble.b	mdc_splend

	IFEQ	CPU60
		lea	(quadtab.l,pc),a6		; Quadrat-Tabelle
	ENDC


		moveq	#24,d4
		tst.w	d0
		bmi.b	.Ok
		moveq	#16,d4
		tst.w	d0
		bne.b	.Ok
		moveq	#8,d4
.Ok

		moveq	#0,d0		; lower count HI
		moveq	#0,d1		; lower count LO
		moveq	#0,d2		; upper count HI
		moveq	#0,d3		; upper count LO
		move.l	d0,a3		; last lower LO
		move.l	d0,a5		; last upper LO



		moveq	#0,d5		; trash
		bra.b	mdc_rantasten


mdc_splitraus	cmp.l	a5,a3
		blo.b	mdc_lowbetter

mdc_upbetter	subq.w	#4,a0
		bra.b	mdc_splend

mdc_lowbetter	addq.w	#4,a1

mdc_splend	movem.l	(a7)+,d0-d7/a2-a6
		rts

;- - - ---- -    -- ---- -    -    - -- - -- -  --- --   -- -    - -  ---

		cnop	0,4

	IFNE	CPU60

mdc_useupper	move.l	([a1]),d7
		bfextu	d7{d4:8},d5
		move.l	-(a1),a4
		move.l	(a4),d7
		bfextu	d7{d4:8},d7
		sub.w	d7,d5
		muls.w	d5,d5
		move.l	d5,a5		; last upper LO
		moveq	#0,d7
		add.l	d5,d3		; upper count LO
		addx.l	d7,d2		; upper count HI

mdc_rantasten	cmp.l	a1,a0
		beq.b	mdc_splitraus

		cmp.l	d0,d2		; uppercount < lowercount?
		blo.b	mdc_useupper
		cmp.l	d1,d3
		blo.b	mdc_useupper	; ja, oben weiter
		
mdc_uselower	move.l	(a0)+,a4
		move.l	(a4),d7

		bfextu	d7{d4:8},d5
		move.l	([a0]),d7
		bfextu	d7{d4:8},d7
		sub.w	d7,d5
		muls.w	d5,d5
		move.l	d5,a3		; last lower LO
		moveq	#0,d7
		add.l	d5,d1		; lower count LO
		addx.l	d7,d0		; lower count HI
		bra.b	mdc_rantasten

	ELSE


mdc_useupper	move.l	([a1]),d7
		bfextu	d7{d4:8},d5
		move.l	-(a1),a4
		move.l	(a4),d7
		bfextu	d7{d4:8},d7
		sub.w	d7,d5
		move.w	(a6,d5.w*2),d5
		move.l	d5,a5		; last upper LO
		moveq	#0,d7
		add.l	d5,d3		; upper count LO
		addx.l	d7,d2		; upper count HI

mdc_rantasten	cmp.l	a1,a0
		beq.b	mdc_splitraus

		cmp.l	d0,d2		; uppercount < lowercount?
		blo.b	mdc_useupper
		cmp.l	d1,d3
		blo.b	mdc_useupper	; ja, oben weiter
		
mdc_uselower	move.l	(a0)+,a4
		move.l	(a4),d7

		bfextu	d7{d4:8},d5
		move.l	([a0]),d7
		bfextu	d7{d4:8},d7
		sub.w	d7,d5
		move.w	(a6,d5.w*2),d5
		move.l	d5,a3		; last lower LO
		moveq	#0,d7
		add.l	d5,d1		; lower count LO
		addx.l	d7,d0		; lower count HI
		bra.b	mdc_rantasten
	ENDC

;------------------------------------------------------------------------
;
;		Feldteilung #2
;
;		Feldteilung am Mittelpunkt der Farbkomponente
;
;	>	a0	lower bound
;		a1	upper bound
;		d0	Farbkomponente (R/G/B)
;	<	a0	upper bound untere Unterteilung
;		a1	lower bound obere Unterteilung
;
;------------------------------------------------------------------------

		cnop	0,4

mdc_split2	movem.l	d0-d7/a2-a6,-(a7)

		move.l	a1,a3
		sub.l	a0,a3
		moveq	#4,d1
		cmp.l	d1,a3
		ble.b	.raus

		moveq	#24,d4
		tst.w	d0
		bmi.b	.Ok
		moveq	#16,d4
		tst.w	d0
		bne.b	.Ok
		moveq	#8,d4
.Ok
		
		move.l	([a0]),d1
		bfextu	d1{d4:8},d1
		move.l	([a1]),d0
		bfextu	d0{d4:8},d0
		sub.w	d1,d0
		lsr.w	#1,d0
		add.w	d1,d0		; Mittelfarbe
		

		move.l	a0,a2
.vonunten	move.l	([a2]),d1
		bfextu	d1{d4:8},d1
		addq.w	#4,a2
		cmp.w	d0,d1
		blt.b	.vonunten


		move.l	a1,a3
.vonoben	move.l	([a3]),d1
		bfextu	d1{d4:8},d1
		subq.w	#4,a3
		cmp.w	d0,d1
		bgt.b	.vonoben

		cmp.l	a2,a3
		bge.b	.no1

		;	0122223356778
		;	       ^^
		;	      a3 a2

		move.l	a3,a0
		move.l	a2,a1
		bra.b	.raus

.no1		bne.b	.no2

		;	01222233456778
		;	        ^
		;		a2=a3


		lea	-4(a2),a0
		move.l	a2,a1
		bra.b	.raus	

.no2		
		;	01222233444444444456778
		;	        ^   ^^   ^
		;		a2	a3

		sub.l	a2,a3
		move.l	a3,d0
		lsr.l	#3,d0
		lea	(a2,d0.l*4),a0
		lea	4(a2),a1

.raus

		movem.l	(a7)+,d0-d7/a2-a6
		rts


;========================================================================




;========================================================================
;------------------------------------------------------------------------
;
;		Diversity #1
;
;		berechnet über ein Teilfeld die Diversität,
;		die gemittelte Feldfarbe und nach welcher
;		Farbkomponente eine Feldteilung durchzuführen ist.
;
;	>	a0		Lower Bound
;		a1		Upper Bound
;	<	d0:d1 / fp0	64Bit-Diversität Hi:Lo / FP-Diversität
;		d2		Farbkomponente 0 Rot, >0 Grün, <0 Blau
;		d3		gemittelte Feldfarbe
;
;------------------------------------------------------------------------

	IFNE	USEFPU

mdc_diversity1	movem.l	d4-d7/a0/a2-a5,-(a7)


;- - - ---- -    -- ---- -    -    - -- - -- -  --- --   -- -    - -  ---
;
;		Farbschwerpunkt berechnen


		move.l	a0,a2

		moveq	#0,d1			; Zähler
		fmove.l	d1,fp0			; Summe Rot
		fmove.l	d1,fp1			; Summe Grün
		fmove.l	d1,fp2			; Summe Blau

mdc_cdmidloop	move.l	(a2)+,a3
		movem.l	(a3),d0/d2
		fmove.l	d2,fp5
		add.l	d2,d1
		moveq	#0,d4
		move.b	d0,d4
		fmove.w	d4,fp4
		fmul.x	fp5,fp4
		fadd.x	fp4,fp2
		lsr.w	#8,d0
		move.b	d0,d4
		fmove.w	d4,fp4
		fmul.x	fp5,fp4
		fadd.x	fp4,fp1
		swap	d0
		move.b	d0,d4
		fmove.w	d4,fp4
		fmul.x	fp5,fp4
		fadd.x	fp4,fp0
		cmp.l	a1,a2
		ble.b	mdc_cdmidloop
		
		fmove.l	d1,fp3
		fdiv.x	fp3,fp0
		fdiv.x	fp3,fp1
		fdiv.x	fp3,fp2
		moveq	#0,d0
		moveq	#0,d1
		moveq	#0,d2
		moveq	#0,d3
		fmove.w	fp0,d0
		fmove.w	fp1,d1
		fmove.w	fp2,d2
		move.b	d0,d3
		swap	d3
		move.b	d1,d3
		lsl.w	#8,d3
		move.b	d2,d3

;- - - ---- -    -- ---- -    -    - -- - -- -  --- --   -- -    - -  ---
;
;		Abweichung zum Farbschwerpunkt des Feldes
;		und Farbkomponente mit der größten
;		Abweichung ermitteln


		moveq	#0,d5
		fmove.l	d5,fp0
		fmove.l	d5,fp1
		fmove.l	d5,fp2


	IFNE	CPU60

mdc_cddivlop	move.l	(a0)+,a3	
		moveq	#0,d6
		movem.l	(a3),d4/d5		; RGB/Anzahl
		move.b	d4,d6			; Blau
		fmove.l	d5,fp3			; Anzahl
		sub.w	d2,d6			; Differenz Blau
		fsqrt.x	fp3
		lsr.w	#8,d4
		muls.w	d6,d6			; Diversität Blau
		moveq	#0,d5
		fmove.l	d6,fp4
		move.b	d4,d5			; Grün
		fmul.x	fp3,fp4
		sub.w	d1,d5			; Differenz Grün
		swap	d4
		fadd.x	fp4,fp2			; Sigma BLAU
		moveq	#0,d6
		muls.w	d5,d5			; Diversität Grün
		fmove.l	d5,fp4
		move.b	d4,d6			; Rot
		fmul.x	fp3,fp4
		sub.w	d0,d6			; Differenz Rot
		fadd.x	fp4,fp1			; Sigma GRÜN
		muls.w	d6,d6			; Diversität Rot
		fmove.l	d6,fp4
		fmul.x	fp3,fp4
		fadd.x	fp4,fp0			; Sigma ROT
		cmp.l	a1,a0
		ble.b	mdc_cddivlop

	ENDC

	IFNE	CPU40

		lea	(quadtab.l,pc),a2
mdc_cddivlop	move.l	(a0)+,a3	
		moveq	#0,d6
		move.l	(a3)+,d4		; RGB
		move.l	(a3),d5			; Anzahl
		move.b	d4,d6			; Blau
		fmove.l	d5,fp3			; Anzahl
		sub.w	d2,d6			; Differenz Blau
		fsqrt.x	fp3
		lsr.w	#8,d4
		move.w	(a2,d6.w*2),d6		; Diversität Blau
		moveq	#0,d5
		fmove.l	d6,fp4
		move.b	d4,d5			; Grün
		fmul.x	fp3,fp4
		sub.w	d1,d5			; Differenz Grün
		swap	d4
		fadd.x	fp4,fp2			; Sigma BLAU
		moveq	#0,d6
		move.w	(a2,d5.w*2),d5		; Diversität Grün
		fmove.l	d5,fp4
		move.b	d4,d6			; Rot
		fmul.x	fp3,fp4
		sub.w	d0,d6			; Differenz Rot
		fadd.x	fp4,fp1			; Sigma GRÜN
		move.w	(a2,d6.w*2),d6		; Diversität Rot
		fmove.l	d6,fp4
		fmul.x	fp3,fp4
		fadd.x	fp4,fp0			; Sigma ROT
		cmp.l	a1,a0
		ble.b	mdc_cddivlop

	ENDC

		fmul.w	(mdd_redweight,a6),fp0
		fmul.w	(mdd_greenweight,a6),fp1
		fmul.w	(mdd_blueweight,a6),fp2

		moveq	#0,d2			; ROT

		fcmp.x	fp0,fp1
		fble	mdc_greenbetter

		fmove.x	fp1,fp0			; maxdiv GRÜN bis dato
		moveq	#1,d2			; GRÜN

mdc_greenbetter	fcmp.x	fp0,fp2
		fble	mdc_bluebetter

		fmove.x	fp2,fp0			; maxdiv BLAU bis dato
	;!!	moveq	#-1,d2			; BLAU
		moveq	#2,d2	;!!
		
mdc_bluebetter	movem.l	(a7)+,d4-d7/a0/a2-a5
		rts

;-------------------------------------------------------------------------

	ELSE

;-------------------------------------------------------------------------
;
;		Integer-Version
;		benutzt 64Bit-Arithmetik
;
;-------------------------------------------------------------------------

mdc_diversity1	movem.l	d4-d7/a0-a5,-(a7)


		move.l	a1,d7
		sub.l	a0,d7
		lsr.l	#3,d7

;- - - ---- -    -- ---- -    -    - -- - -- -  --- --   -- -    - -  ---
;
;		Farbschwerpunkt berechnen


		move.l	d7,d6
		move.l	a0,a2
		moveq	#0,d0			; hi Grün
		moveq	#0,d1			; lo Grün
		moveq	#0,d2			; hi Blau
		moveq	#0,d3			; lo Blau

mdc_cdmidlopRG	move.l	(a2)+,a5
		moveq	#0,d4
		move.l	4(a5),d5

		move.b	2(a5),d4
		mulu.l	d4,d4:d5		; hi:lo
		add.l	d5,d1
		addx.l	d4,d0

		moveq	#0,d4
		move.l	4(a5),d5
		move.b	3(a5),d4
		mulu.l	d4,d4:d5		; hi:lo
		add.l	d5,d3
		addx.l	d4,d2

		subq.l	#1,d6
		bpl.b	mdc_cdmidlopRG

		move.l	d0,a3			; hi Grün
		move.l	d1,a4			; lo Grün

		move.l	a0,a2
		moveq	#0,d0			; hi Rot
		moveq	#0,d1			; lo Rot
		moveq	#0,d6			; Zähler

mdc_cdmidlopB	move.l	(a2)+,a5
		moveq	#0,d4
		move.l	4(a5),d5

		move.w	(a5),d4
		add.l	d5,d6
		mulu.l	d4,d4:d5		; hi:lo
		add.l	d5,d1
		addx.l	d4,d0
		subq.l	#1,d7
		bpl.b	mdc_cdmidlopB

		move.l	d6,d7			; Runden
		lsr.l	#1,d7
		moveq	#0,d4
		add.l	d7,d3
		addx.l	d4,d2
		add.l	d7,d1
		addx.l	d4,d0

		divu.l	d6,d2:d3		; d3: Blau
		divu.l	d6,d0:d1		; d1: Rot
		move.l	a3,d0
		move.l	a4,d2

		add.l	d7,d2			; Runden
		addx.l	d4,d0
		divu.l	d6,d0:d2		; d2: Grün

		moveq	#0,d0
		move.b	d1,d0
		swap	d0
		move.b	d2,d0
		lsl.w	#8,d0
		move.b	d3,d0
		move.l	d0,-(a7)		; Schwerpunktfarbe merken


;- - - ---- -    -- ---- -    -    - -- - -- -  --- --   -- -    - -  ---
;
;		Abweichung zum Farbschwerpunkt des Feldes
;		berechnen und Farbkomponente mit der größten
;		Standardabweichung ermitteln

		move.l	(mdd_sqrbuffer,a6),a4
		lea	(quadtab.l,pc),a3

		move.l	a0,a2
		moveq	#0,d6			; Rotabweichung hi
		moveq	#0,d7			; Rotabweichung lo

mdc_cddivlopR	move.l	(a2)+,a5
		moveq	#0,d5
		move.b	1(a5),d5
		sub.w	d1,d5
		move.w	(a3,d5.w*2),d5

		move.l	4(a5),d0
		movem.l	d1-d3/d5,-(a7)
		SQRT
		movem.l	(a7)+,d1-d3/d5
		move.w	d0,(a4)+		; puffern
		mulu.l	d0,d4:d5		; hi:lo

		add.l	d5,d7
		addx.l	d4,d6
		cmp.l	a1,a2
		ble.b	mdc_cddivlopR
		moveq	#0,d5
		move.w	(mdd_redweight,a6),d5
		mulu.l	d5,d6:d7

		move.l	(mdd_sqrbuffer,a6),a4
		move.l	a0,a2
		moveq	#0,d0			; Grünabweichung hi
		moveq	#0,d1			; Grünabweichung lo
mdc_cddivlopG	move.l	(a2)+,a5
		moveq	#0,d5
		move.b	2(a5),d5
		sub.w	d2,d5
		move.w	(a3,d5.w*2),d5

		moveq	#0,d4
		move.w	(a4)+,d4
		mulu.l	d4,d4:d5		; hi:lo

		add.l	d5,d1
		addx.l	d4,d0
		cmp.l	a1,a2
		ble.b	mdc_cddivlopG
		moveq	#0,d5
		move.w	(mdd_greenweight,a6),d5
		mulu.l	d5,d0:d1

		moveq	#1,d2			; GRÜN
		cmp.l	d0,d6
		blo.b	mdc_cdRGok
		cmp.l	d1,d7
		blo.b	mdc_cdRGok
		moveq	#0,d2			; ROT
		move.l	d6,d0
		move.l	d7,d1
mdc_cdRGok

		move.l	(mdd_sqrbuffer,a6),a4
		move.l	a0,a2
		moveq	#0,d6			; Blauabweichung hi
		moveq	#0,d7			; Blauabweichung lo
mdc_cddivlopB	move.l	(a2)+,a5
		moveq	#0,d5
		move.b	3(a5),d5
		sub.w	d3,d5
		move.w	(a3,d5.w*2),d5

		moveq	#0,d4
		move.w	(a4)+,d4
		mulu.l	d4,d4:d5		; hi:lo

		add.l	d5,d7
		addx.l	d4,d6
		cmp.l	a1,a2
		ble.b	mdc_cddivlopB
		moveq	#0,d5
		move.w	(mdd_blueweight,a6),d5
		mulu.l	d5,d6:d7

		cmp.l	d0,d6
		blo.b	mdc_cdBok
		cmp.l	d1,d7
		blo.b	mdc_cdBok
	;!!	moveq	#-1,d2			; BLAU
		moveq	#2,d2	;!!!
		
		move.l	d6,d0			; Abweichung blau stärker
		move.l	d7,d1
mdc_cdBok
		move.l	(a7)+,d3		; Schwerpunkt-RGB

		movem.l	(a7)+,d4-d7/a0-a5
		rts

	ENDC

;------------------------------------------------------------------------


;========================================================================
;------------------------------------------------------------------------
;
;		Feldteilung
;
;	>	a0	lower bound
;		a1	upper bound
;		d0	Farbkomponente (R/G/B)
;		d1	mid
;	<	a0	upper bound untere Unterteilung
;		a1	lower bound obere Unterteilung
;
;------------------------------------------------------------------------

		cnop	0,4

mdc_splitnew	movem.l	d0-d3/a2,-(a7)
		move.l	a0,-(a7)

		moveq	#0,d3

		addq.w	#1,d0
		moveq	#0,d2

.loop		cmp.l	a1,a0
		bge.b	.raus

		move.l	(a0),a2
		add.w	d0,a2
		move.b	(a2),d2
		cmp.w	d1,d2
		bgt.b	.uppa
	
		addq.l	#1,d3
		addq.l	#4,a0
		bra.b	.loop		
		
.upp		subq.l	#4,a1
.uppa		move.l	(a1),a2
		add.w	d0,a2
		move.b	(a2),d2
		cmp.w	d1,d2
		bgt.b	.upp

		move.l	(a0),a2
		move.l	(a1),(a0)
		move.l	a2,(a1)
		subq.l	#4,a1

		addq.l	#1,d3
		addq.l	#4,a0
		bra.b	.loop		

.raus
		move.l	(a7)+,a1
		lsl.l	#2,d3
		add.l	d3,a1
		lea	-4(a1),a0

		movem.l	(a7)+,d0-d3/a2
		rts


;========================================================================





;========================================================================
;------------------------------------------------------------------------
;
;		MinMax
;
;	>	a0	lower bound
;		a1	upper bound
;		d0	Farbkomponente (R/G/B)
;	<	d0	min
;		d1	max
;
;------------------------------------------------------------------------

		cnop	0,4

mdc_minmax	movem.l	d2-d3/a0/a2,-(a7)

		moveq	#1,d2
		moveq	#0,d3
		add.w	d0,d2
		
		moveq	#0,d0
		not.b	d0
		moveq	#0,d1


.loop		cmp.l	a1,a0
		bge.b	.raus

		move.l	(a0),a2
		add.w	d2,a2
		move.b	(a2),d3
		cmp.w	d0,d3
		bge.b	.ok1
		move.w	d3,d0
.ok1		cmp.w	d1,d3
		ble.b	.ok2
		move.w	d3,d1
.ok2
		addq.l	#4,a0
		bra.b	.loop

.raus		movem.l	(a7)+,d2-d3/a0/a2
		rts


