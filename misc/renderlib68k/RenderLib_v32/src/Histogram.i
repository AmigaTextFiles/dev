
	IFND	HISTOGRAM_I
HISTOGRAM_I		SET	1

		INCLUDE	exec/semaphores.i

;=========================================================================
;-------------------------------------------------------------------------
;
;		CreateHistogram
;
;		Alloziert und initialisiert ein Histogramm.
;
;	>	a1	taglist
;	<	d0	APTR	Histogramm-Struktur oder NULL
;
;	Tags:	RND_RMHandler	Default: NULL
;		RND_HSType	Default: HSTYPE_15BIT_TURBO
;
;-------------------------------------------------------------------------

CreateHistogram	movem.l	d2-d7/a3-a6,-(a7)

		move.l	a1,a3
		move.l	(utilitybase,pc),a6

		GetTag	#RND_RMHandler,#0,a3
		move.l	d0,a5

		GetTag	#RND_HSType,#HSTYPE_15BIT_TURBO,a3
	;move.l	#HSTYPE_18BIT_TURBO,d0	;!!!!!!!!!!
		move.l	d0,d7

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

		move.l	#dhisto_SIZEOF,d0	; Speicher für Struktur
		move.l	a5,a0
		bsr.w	AllocRenderMem
		move.l	d0,a4			; Struktur
		tst.l	d0
		beq.w	chs_failed

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

		move.l	a4,a0
		move.l	#dhisto_SIZEOF,d0
		moveq	#0,d1
		bsr	TurboFillMem		; alles nullen


		lea	(dhisto_semaphore,a4),a0
		move.l	a0,a1
		moveq	#SS_SIZE/2-1,d0
.clrsl		clr.w	(a1)+
		dbf	d0,.clrsl
		move.l	(execbase,pc),a6
		jsr	(_LVOInitSemaphore,a6)	; Semaphore einrichten


		move.l	a5,(dhisto_memhandler,a4)


		; Bitmasken erstellen

		move.b	d7,d1		
		move.b	d1,(dhisto_type,a4)
		and.b	#15,d1			; Bits per gun

		moveq	#0,d0			; AND-Maske erstellen
		not.b	d0

		moveq	#8,d2
		sub.w	d1,d2
		beq.b	chs_noshift
		lsl.b	d2,d0
chs_noshift	moveq	#0,d2
		move.b	d0,d2
		swap	d2
		move.b	d0,d2
		lsl.w	#8,d2
		move.b	d0,d2
		move.l	d2,(dhisto_andmask,a4)


		btst	#HSTYPEB_TURBO,d7
		bne.b	chs_turbo

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

chs_tree	move.b	#HSCONVTYPE_TREE,(dhisto_conversion,a4)
		clr.l	(dhisto_numcolors,a4)

		move.l	a5,a0
		bsr.w	CreateTreeBlock
		move.l	d0,(dhisto_tree,a4)
		beq.b	chs_failed

		bra.b	chs_allright

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		
chs_turbo	move.b	#HSCONVTYPE_TURBO,(dhisto_conversion,a4)
		moveq	#NUMCOLORS_NOT_DEFINED,d0
		move.l	d0,(dhisto_numcolors,a4)

		; TurboHistogramm: Speicher für die Tabelle
		; anfordern und löschen.

		move.l	d7,d0
		and.w	#15,d0		; Bits per Gun
		move.w	d0,d1
		add.w	d0,d1
		add.w	d0,d1		; Bits total (12/15/18...)

		moveq	#4,d0		; Langworte
		lsl.l	d1,d0		; ergibt Größe der Tabelle in Bytes
		move.l	d0,(dhisto_turbosize,a4)
		move.l	d0,d2

		move.l	a5,a0
		bsr.w	AllocRenderMem
		tst.l	d0
		beq.b	chs_failed

		move.l	d0,a0
		move.l	a0,(dhisto_turbo,a4)
		move.l	d2,d0
		moveq	#0,d1
		bsr.w	TurboFillMem		; Tabelle löschen


;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

chs_allright	move.l	a4,d0
		movem.l	(a7)+,d2-d7/a3-a6
		rts

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

chs_failed	move.l	a4,d0
		beq.b	chs_noallocd

		move.l	a5,a0
		move.l	a4,a1
		move.l	#dhisto_SIZEOF,d0
		bsr.w	FreeRenderMem

chs_noallocd	moveq	#0,d0
		movem.l	(a7)+,d2-d7/a3-a6
		rts
		
;=========================================================================


;=========================================================================
;-------------------------------------------------------------------------
;
;		DeleteHistogram
;
;		gibt ein dynamisches Histogramm frei.
;
;	>	a0	APTR	DynamicHistogram-Struktur
;
;-------------------------------------------------------------------------

DeleteHistogram:
		move.l	a5,-(a7)
		move.l	a0,a5

	;!!	Lock		dhisto_semaphore(a5)

		move.l	(dhisto_memhandler,a5),a0

		move.b	(dhisto_conversion,a5),d0
		cmp.b	#HSCONVTYPE_TURBO,d0
		beq.b	.freeturbo
		cmp.b	#HSCONVTYPE_TREE,d0
		beq.b	.freetree
		cmp.b	#HSCONVTYPE_TABLE,d0
		beq.b	.freetable

.illegal	illegal			; z.Zt nicht definiert

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

.freetree	move.l	(dhisto_tree,a5),d0
		beq.b	.illegal

		move.l	d0,a0
		bsr.w	DeleteRenderTree

		bra.b	.continue

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

.freetable	move.l	(dhisto_table,a5),a1
		move.l	(dhisto_tablesize,a5),d0
		bsr.w	FreeRenderMem
		bra.b	.continue
		
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

.freeturbo	move.l	(dhisto_turbo,a5),a1
		move.l	(dhisto_turbosize,a5),d0
		bsr.w	FreeRenderMem

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

.continue


	;!!	Unlock		dhisto_semaphore(a5)

		move.l	(dhisto_memhandler,a5),a0
		move.l	a5,a1
		move.l	#dhisto_SIZEOF,d0
		bsr.w	FreeRenderMem

		move.l	(a7)+,a5
		rts
		
;-------------------------------------------------------------------------
;=========================================================================



;=========================================================================
;-------------------------------------------------------------------------
;
;		CountRGB
;
;		ermittelt die Anzahl Pixel in einem Histogramm,
;		die einem RGB-Wert zugeordnet sind
;		(gemäß Genauigkeit des Histogramms)
;
;	>	a0	APTR	histogramm	Histogramm
;		d0	ULONG	RGB
;	<	d0	ULONG	Häufigkeit
;
;-------------------------------------------------------------------------

CountRGB	movem.l	d2/a2,-(a7)

		move.l	d0,d2
		move.l	a0,a2

		LockShared	dhisto_semaphore(a2)

		btst.b	#HSTYPEB_TURBO,(dhisto_type,a2)
		bne.b	.turbo

		; im Baum suchen:

		move.l	a2,a0
		bsr.w	MakeTreeHistogram
		tst.l	d0
		beq.w	.ende

		and.l	(dhisto_andmask,a2),d2
		move.l	d2,d1
		move.l	d0,a0
		add.w	#treeAnchor_SIZEOF,a0

		cmp.l	(a0),d2
		beq.b	.found

.notfnd		lsr.l	#1,d1
		bcc.b	.left

.right		move.l	(rNode_right,a0),d0
		beq.b	.raus
		move.l	d0,a0

		cmp.l	(a0),d2
		beq.b	.found

		lsr.l	#1,d1
		bcs.b	.right

.left		move.l	(rNode_left,a0),d0
		beq.b	.raus
		move.l	d0,a0

		cmp.l	(a0),d2
		bne.b	.notfnd

.found		move.l	(rNode_count,a0),d0
.raus		bra.b	.ende


		; aus der Tabelle holen:

.turbo		move.l	a2,a0
		bsr.w	MakeTurboHistogram
		tst.l	d0
		beq.b	.ende

		move.l	(dhisto_turbo,a2),a0

		moveq	#15,d0
		and.b	(dhisto_type,a2),d0
		
		cmp.b	#4,d0
		beq.b	.turbo12
		cmp.b	#5,d0
		beq.b	.turbo15
		cmp.b	#6,d0
		beq.b	.turbo18

		illegal		; nicht definiert


.turbo12	lsr.l	#4,d2
		lsl.b	#4,d2
		lsl.w	#4,d2
		lsr.l	#6,d2
		move.l	(a0,d2.l),d0
		bra.b	.ende

.turbo15	lsr.l	#3,d2
		lsl.b	#3,d2
		lsl.w	#3,d2
		lsr.l	#4,d2
		move.l	(a0,d2.l),d0
		bra.b	.ende

.turbo18	lsr.l	#2,d2
		lsl.b	#2,d2
		lsl.w	#2,d2
		lsr.l	#2,d2
		move.l	(a0,d2.l),d0

.ende
		Unlock		dhisto_semaphore(a2)

		movem.l	(a7)+,d2/a2
		rts

;=========================================================================


;=========================================================================
;-------------------------------------------------------------------------
;
;	value = QueryHistogram ( histogram, tag )
;
;		ermittelt eine Einstellung eines Histogramms.
;
;	>	a0	Histogramm
;		d0	Tag
;	<	d0	Wert
;
;		Tags
;		----------------------------------------------------	
;		RND_RMHandler
;		RND_HSType
;		RND_NumColors
;		RND_NumPixels
;
;-------------------------------------------------------------------------

QueryHistogram:
		LockShared	dhisto_semaphore(a0)

		cmp.l	#RND_RMHandler,d0
		bne.b	.no1

		move.l	(dhisto_memhandler,a0),d0
		rts

.no1		cmp.l	#RND_HSType,d0
		bne.b	.no2
		
		moveq	#0,d0
		move.b	(dhisto_type,a0),d0
		bra.b	.raus

.no2		cmp.l	#RND_NumPixels,d0
		bne.b	.no3

		move.l	(dhisto_numpixels,a0),d0
		bra.b	.raus

.no3		cmp.l	#RND_NumColors,d0
		bne.b	.no4

		bsr.b	CountHistogram
.no4

.raus		Unlock		dhisto_semaphore(a0)

		rts

;=========================================================================


;-------------------------------------------------------------------------
;
;		CountHistogram
;
;		liefert die Anzahl verschiedener Farben
;		in einem Histogramm zurück.
;
;	>	a0	APTR	Histogramm
;	<	d0	ULONG	Anzahl Einträge
;	
;-------------------------------------------------------------------------

CountHistogram:	movem.l	a1-a2,-(a7)
		move.l	a0,a2

		move.l	(dhisto_numcolors,a2),d0
		cmp.l	#NUMCOLORS_NOT_DEFINED,d0
		bne.b	.okay

		move.b	(dhisto_conversion,a2),d0
		cmp.b	#HSCONVTYPE_TURBO,d0
		beq.b	.countturbo

		illegal

.countturbo	move.l	(dhisto_turbosize,a2),d0
		move.l	(dhisto_turbo,a2),a0
		bsr.w	CountTurbo

		move.l	d0,(dhisto_numcolors,a2)

.okay		move.l	a2,a0
		movem.l	(a7)+,a1-a2
		rts

;-------------------------------------------------------------------------

;-------------------------------------------------------------------------
;
;		CountTurbo
;
;		zählt die Anzahl Einträge in einem Turbo-Histogramm
;
;	>	a0	APTR	Turbo-Histogramm
;		d0	ULONG	Größe des Histogramms [Bytes]
;	<	d0	ULONG	Anzahl Einträge im Turbo-Histogramm
;	
;-------------------------------------------------------------------------

CountTurbo:	lea	(a0,d0.l),a1
		
		moveq	#0,d0
		
cntt_loop	cmp.l	a0,a1
		beq.b	cntt_raus
		
cntt_loop2	tst.l	(a0)+
		beq.b	cntt_loop

		addq.l	#1,d0		

		cmp.l	a0,a1
		bne.b	cntt_loop2

cntt_raus	rts

;-------------------------------------------------------------------------


;=========================================================================
;-------------------------------------------------------------------------
;
;		AddRGB v1.0
;
;		fügt einem Histogramm einen
;		einzelnen RGB-Wert hinzu.
;
;	>	a0	APTR	Histogramm
;		d0	ULONG	RGB
;		d1	ULONG	Häufigkeit
;	<	d0	LONG	Returncode ADD_...
;	
;-------------------------------------------------------------------------

AddRGB:		movem.l	d2/a2/d3,-(a7)

		and.l	#$00ffffff,d0

		move.l	d1,d3
		move.l	a0,a2
		move.l	d0,d2

		Lock		dhisto_semaphore(a2)

		btst.b	#HSTYPEB_TURBO,(dhisto_type,a2)
		bne.b	adrh_turbo

		move.l	a2,a0
		bsr.w	MakeTreeHistogram
		move.l	d0,a0
		tst.l	d0
		beq.w	adrh_converror

		sf	(dhisto_treevalid,a2)

		move.l	(dhisto_andmask,a2),d0
		and.l	d2,d0
		move.l	d3,d1
		bsr.w	AddRGB2Tree
		tst.l	d0
		bmi.b	adrh_tree_error

		add.l	d0,(dhisto_numcolors,a2)
		bra.b	adrh_okay


adrh_turbo	move.l	a2,a0
		bsr.w	MakeTurboHistogram
		tst.l	d0
		beq.b	adrh_converror
		
		moveq	#NUMCOLORS_NOT_DEFINED,d0	; nicht mehr definiert
		move.l	d0,(dhisto_numcolors,a2)

		move.l	(dhisto_turbo,a2),a0

		moveq	#15,d0
		and.b	(dhisto_type,a2),d0
		
		cmp.b	#4,d0
		beq.b	adhr_turbo12
		cmp.b	#5,d0
		beq.b	adhr_turbo15
		cmp.b	#6,d0
		beq.b	adhr_turbo18

		illegal


adhr_turbo12	lsr.l	#4,d2		; %0000aaaaaaaarrrrrrrrggggggggbbbb
		lsl.b	#4,d2		; %0000aaaaaaaarrrrrrrrggggbbbb0000
		lsl.w	#4,d2		; %0000aaaaaaaarrrrggggbbbb00000000
		lsr.l	#6,d2		; %0000000000aaaaaaaarrrrggggbbbb00
		add.l	d3,(a0,d2.l)
		bra.b	adrh_okay

adhr_turbo15	lsr.l	#3,d2
		lsl.b	#3,d2
		lsl.w	#3,d2
		lsr.l	#4,d2
		add.l	d3,(a0,d2.l)
		bra.b	adrh_okay

adhr_turbo18	lsr.l	#2,d2
		lsl.b	#2,d2
		lsl.w	#2,d2
		lsr.l	#2,d2
		add.l	d3,(a0,d2.l)
		bra.b	adrh_okay

adrh_converror
adrh_tree_error	moveq	#ADDH_NOT_ENOUGH_MEMORY,d0
		bra.b	adrh_ende

adrh_okay	moveq	#ADDH_SUCCESS,d0

adrh_ende	Unlock		dhisto_semaphore(a2)

		movem.l	(a7)+,d2/a2/d3
		rts

;=========================================================================


;=========================================================================
;-------------------------------------------------------------------------
;
;		AddChunkyImage v2.0
;
;		fügt dem Histogramm ein Chunky8-Bild hinzu.
;
;	>	a0	APTR	Histogramm
;		a1	APTR	Chunky
;		d0	UWORD	width
;		d1	UWORD	height
;		a2	APTR	palette
;		a3	struct TagItem *taglist
;	<	d0	LONG	Returncode ADH_...
;
;	Tags:	RND_SourceWidth	- Default: width
;		RND_ProgressHook - Default: NULL
;	
;-------------------------------------------------------------------------

	STRUCTURE	adci_localdata,0
		APTR	adci_histogram
		APTR	adci_chunky
		APTR	adci_progresshook
		UWORD	adci_width
		UWORD	adci_height
		UWORD	adci_sourcemodulo

		UWORD	adci_width1		; Breite % 8 - 1
		UWORD	adci_width8		; Breite / 8  -1

		STRUCT	adci_table,256*4
	LABEL		adci_SIZEOF

;-------------------------------------------------------------------------

AddChunkyImage	movem.l	a3-a6/d2-d7,-(a7)

		sub.w	#adci_SIZEOF,a7
		move.l	a7,a5

		move.l	a0,(adci_histogram,a5)
		move.l	a1,(adci_chunky,a5)
		move.w	d0,(adci_width,a5)
		move.w	d1,(adci_height,a5)

		move.l	(utilitybase,pc),a6

		GetTag	#RND_ProgressHook,#0,a3
		move.l	d0,(adci_progresshook,a5)

		move.w	(adci_width,a5),d7
		GetTag	#RND_SourceWidth,d7,a3
		sub.w	d7,d0
		move.w	d0,(adci_sourcemodulo,a5)

		move.l	(adci_histogram,a5),a4

		Lock		dhisto_semaphore(a4)

		move.w	(adci_width,a5),d0
		moveq	#7,d1
		and.w	d0,d1
		lsr.w	#3,d0
		subq.w	#1,d0
		move.w	d0,(adci_width8,a5)
		subq.w	#1,d1
		move.w	d1,(adci_width1,a5)		

		lea	(adci_table,a5),a6

		move.l	a6,a0
		move.l	#256*4,d0
		moveq	#0,d1
		bsr	TurboFillMem

		move.l	(adci_chunky,a5),a1
		move.w	(adci_height,a5),d5
		subq.w	#1,d5

.yloop		moveq	#0,d0

		move.w	(adci_width1,a5),d7
		bmi.b	.nox1

.xloop1		move.b	(a1)+,d0
		addq.l	#1,(a6,d0.w*4)
		dbf	d7,.xloop1

.nox1		move.w	(adci_width8,a5),d7
		bmi.b	.nox8

		moveq	#0,d1
		moveq	#0,d2
		moveq	#0,d3

.xloop8		move.b	(a1)+,d0
		move.b	(a1)+,d1
		swap	d0
		move.b	(a1)+,d2
		swap	d1
		move.b	(a1)+,d3
		swap	d2
		move.b	(a1)+,d0
		swap	d3
		move.b	(a1)+,d1
		move.b	(a1)+,d2
		move.b	(a1)+,d3
		addq.l	#1,(a6,d0.w*4)
		addq.l	#1,(a6,d1.w*4)
		swap	d0
		addq.l	#1,(a6,d2.w*4)
		swap	d1
		addq.l	#1,(a6,d3.w*4)
		swap	d2
		addq.l	#1,(a6,d0.w*4)
		swap	d3
		addq.l	#1,(a6,d1.w*4)
		addq.l	#1,(a6,d2.w*4)
		addq.l	#1,(a6,d3.w*4)
		dbf	d7,.xloop8

.nox8		moveq	#0,d0
		move.w	(adci_width,a5),d0
		add.l	d0,([adci_histogram,a5],dhisto_numpixels)

			move.l	(adci_progresshook,a5),d0
			beq.b	.nocb
		;	movem.l	d1-d4,-(a7)
			moveq	#0,d3
			move.w	(adci_height,a5),d3
			move.l	d3,d4
			sub.w	d5,d3				; Count
			move.l	(adci_histogram,a5),d1		; Objekt
			moveq	#PMSGTYPE_LINES_ADDED,d2	; Messagetyp
			PROGRESSCALLBACK
		;	movem.l	(a7)+,d1-d4
			moveq	#ADDH_CALLBACK_ABORTED,d7
			tst.w	d0
			beq.b	.raus2

.nocb		add.w	(adci_sourcemodulo,a5),a1
		dbf	d5,.yloop


		moveq	#ADDH_SUCCESS,d5
		move.w	#255,d6
		lea	(pal_palette,a2),a3

		LockShared	pal_semaphore(a2)

.addloop	move.l	(a3)+,d0	; RGB
		move.l	(a6)+,d1	; Häufigkeit
		beq.b	.ok

		move.l	a4,a0
		bsr	AddRGB
		move.l	d0,d7
		cmp.l	d7,d5
		bne.b	.raus

.ok		dbf	d6,.addloop

.raus		Unlock		pal_semaphore(a2)

.raus2		Unlock		dhisto_semaphore(a4)

		move.l	d7,d0
		add.w	#adci_SIZEOF,a7

		movem.l	(a7)+,a3-a6/d2-d7
		rts

;=========================================================================


;=========================================================================
;-------------------------------------------------------------------------
;
;		AddRGBImage v1.0
;
;		fügt dem Histogramm ein Bild hinzu.
;
;	>	a0	APTR	Histogramm
;		a1	APTR	RGB24-Bilddaten
;		a2		ProgressHook
;		d0	UWORD	Breite [Pixel]
;		d1	UWORD	Höhe [Zeilen]
;		d2	WORD	Gesamtbreite des Bildes [Pixel]
;	<	d0	LONG	Returncode ADH_...
;	
;-------------------------------------------------------------------------

	STRUCTURE	adi_localdata,0
		UWORD	adi_height
		APTR	adi_progresshook
	LABEL		adi_SIZEOF

;-------------------------------------------------------------------------

AddRGBImage:	Lock		dhisto_semaphore(a0)

		movem.l	d2-d7/a0-a6,-(a7)

		subq.w	#adi_SIZEOF,a7
		move.l	a7,a6

		move.l	a2,(adi_progresshook,a6)
		move.w	d1,(adi_height,a6)
		move.l	a0,a5

		moveq	#0,d7
		move.w	d2,d7			; SrcWidth
		lsl.l	#2,d7			; [Bytes]

		sub.w	d0,d2
		move.w	d2,a4			; SrcModulo	

		move.w	d1,d6			; Height

		moveq	#0,d5
		move.w	d0,d5			; Width

		btst.b	#HSTYPEB_TURBO,(dhisto_type,a5)
		bne.w	adi_turbo

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;		Digitalbaum-Histogramm
;		----------------------

		move.l	a5,a0
		bsr.w	MakeTreeHistogram
		tst.l	d0
		beq.w	adi_converror

		sf	(dhisto_treevalid,a5)

		move.l	(dhisto_andmask,a5),d1

		move.l	a1,a0		; RGB
		move.l	d0,a1		; Baum

		subq.w	#1,d6


adi_treeylop	move.w	d5,d0				; Width

		bsr	AddImage2Tree			; eine Zeile hinzufügen
		tst.l	d0
		bmi.w	adi_tree_error

		add.l	d0,(dhisto_numcolors,a5)
		add.l	d5,(dhisto_numpixels,a5)	; aktualisieren

		add.l	d7,a0			; + SourceWidth

			move.l	(adi_progresshook,a6),d0
			beq.b	.nocb
			movem.l	d1-d4,-(a7)
			moveq	#0,d4
			move.w	(adi_height,a6),d4		; Total
			move.l	d4,d3
			sub.w	d6,d3				; Count
			move.l	a5,d1				; Histogramm
			moveq	#PMSGTYPE_LINES_ADDED,d2	; Messagetyp
			PROGRESSCALLBACK
			movem.l	(a7)+,d1-d4
			tst.w	d0
			beq.w	adi_cbaborted

.nocb		dbf	d6,adi_treeylop
		bra.w	adi_success

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

adi_turbo	subq.w	#1,d6

		move.l	a5,a0
		bsr.w	MakeTurboHistogram
		tst.l	d0
		beq.w	adi_converror

		move.l	d0,a0

		moveq	#NUMCOLORS_NOT_DEFINED,d0	; nicht mehr definiert
		move.l	d0,(dhisto_numcolors,a5)

		moveq	#15,d0
		and.b	(dhisto_type,a5),d0

		lea	(adi_turbo12,pc),a2
		cmp.w	#4,d0
		beq.b	adi_ylop
		lea	(adi_turbo15,pc),a2
		cmp.w	#5,d0
		beq.b	adi_ylop
		lea	(adi_turbo18,pc),a2
		cmp.w	#6,d0
		beq.b	adi_ylop
		illegal

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

adi_ylop	move.l	#$ffffff,d1
		jsr	(a2)	; eine Zeile hinzufügen

			move.l	(adi_progresshook,a6),d0	;!!!!
			beq.b	.nocb
			movem.l	d1-d4,-(a7)
			moveq	#0,d4
			move.w	(adi_height,a6),d4		; Total
			move.l	d4,d3
			sub.w	d6,d3				; Count
			move.l	a5,d1				; Histogramm
			moveq	#PMSGTYPE_LINES_ADDED,d2	; Messagetyp
			PROGRESSCALLBACK
			movem.l	(a7)+,d1-d4
			tst.w	d0
			beq.w	adi_cbaborted

.nocb		add.w	a4,a1				; + SrcMod
		add.l	d5,(dhisto_numpixels,a5)	; numpixels aktualisieren
		
		dbf	d6,adi_ylop
		bra.w	adi_success

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

adi_cbaborted	moveq	#ADDH_CALLBACK_ABORTED,d0
		bra.b	adi_ende

adi_tree_error
adi_converror	moveq	#ADDH_NOT_ENOUGH_MEMORY,d0
		bra.b	adi_ende

adi_success	moveq	#ADDH_SUCCESS,d0

adi_ende	add.w	#adi_SIZEOF,a7

		movem.l	(a7)+,d2-d7/a0-a6

		Unlock		dhisto_semaphore(a0)
		rts

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;		18Bit-Turbo-Histogramm
;		----------------------

adi_turbo18	move.w	d5,d4

		lsr.w	#2,d4
		beq.b	adi_t18xno4		; keine 4er-Durchläufe

		subq.w	#1,d4
adi_t18xlop4	movem.l	(a1)+,d0/d2/d3/d7

		and.l	d1,d0
		lsr.l	#2,d0
		and.l	d1,d2
		lsr.l	#2,d2
		and.l	d1,d3
		lsl.b	#2,d0
		and.l	d1,d7
		lsr.l	#2,d3
		lsl.w	#2,d0
		lsl.b	#2,d2
		lsl.b	#2,d3
		lsr.l	#2,d0
		lsl.w	#2,d3
		addq.l	#1,(a0,d0.l)
		lsl.w	#2,d2
		lsr.l	#2,d7
		lsr.l	#2,d2
		lsl.b	#2,d7
		addq.l	#1,(a0,d2.l)
		lsr.l	#2,d3
		lsl.w	#2,d7
		addq.l	#1,(a0,d3.l)
		lsr.l	#2,d7
		addq.l	#1,(a0,d7.l)

		dbf	d4,adi_t18xlop4

adi_t18xno4	moveq	#3,d4
		and.w	d5,d4
		subq.w	#1,d4
		bmi.b	adi_t18xno1

adi_t18xlop1	move.l	(a1)+,d0
		and.l	d1,d0
		lsr.l	#2,d0
		lsl.b	#2,d0
		lsl.w	#2,d0
		lsr.l	#2,d0
		addq.l	#1,(a0,d0.l)

		dbf	d4,adi_t18xlop1

adi_t18xno1	rts

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;		15Bit-Turbo-Histogramm
;		----------------------

adi_turbo15	move.w	d5,d4
		lsr.w	#2,d4
		beq.b	adi_t15xno4		; keine 4er-Durchläufe

		subq.w	#1,d4
adi_t15xlop4	movem.l	(a1)+,d0/d2/d3/d7

		and.l	d1,d0
		lsr.l	#3,d0
		and.l	d1,d2
		lsr.l	#3,d2
		and.l	d1,d3
		lsl.b	#3,d0
		and.l	d1,d7
		lsr.l	#3,d3
		lsl.w	#3,d0
		lsl.b	#3,d2
		lsl.b	#3,d3
		lsr.l	#4,d0
		lsl.w	#3,d3
		addq.l	#1,(a0,d0.l)		;!!!!
		lsl.w	#3,d2
		lsr.l	#3,d7
		lsr.l	#4,d2
		lsl.b	#3,d7
		addq.l	#1,(a0,d2.l)		;!!!!
		lsr.l	#4,d3
		lsl.w	#3,d7
		addq.l	#1,(a0,d3.l)		;!!!!
		lsr.l	#4,d7
		addq.l	#1,(a0,d7.l)		;!!!!

		dbf	d4,adi_t15xlop4

adi_t15xno4	moveq	#3,d4
		and.w	d5,d4
		subq.w	#1,d4
		bmi.b	adi_t15xno1

adi_t15xlop1	move.l	(a1)+,d0

		and.l	d1,d0
		lsr.l	#3,d0
		lsl.b	#3,d0
		lsl.w	#3,d0
		lsr.l	#4,d0
		addq.l	#1,(a0,d0.l)

		dbf	d4,adi_t15xlop1

adi_t15xno1	rts

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;		12Bit-Turbo-Histogramm
;		----------------------

adi_turbo12	move.w	d5,d4
		lsr.w	#2,d4
		beq.b	adi_t12xno4		; keine 4er-Durchläufe

		subq.w	#1,d4
adi_t12xlop4	movem.l	(a1)+,d0/d2/d3/d7

		and.l	d1,d0
		lsr.l	#4,d0
		and.l	d1,d2
		lsr.l	#4,d2
		and.l	d1,d3
		lsl.b	#4,d0
		lsr.l	#4,d3
		and.l	d1,d7
		lsl.w	#4,d0
		lsl.b	#4,d2
		lsl.b	#4,d3
		lsr.l	#6,d0
		lsl.w	#4,d3
		addq.l	#1,(a0,d0.l)
		lsl.w	#4,d2
		lsr.l	#4,d7
		lsr.l	#6,d2
		lsl.b	#4,d7
		addq.l	#1,(a0,d2.l)
		lsr.l	#6,d3
		lsl.w	#4,d7
		addq.l	#1,(a0,d3.l)
		lsr.l	#6,d7
		addq.l	#1,(a0,d7.l)

		dbf	d4,adi_t12xlop4

adi_t12xno4	moveq	#3,d4
		and.w	d5,d4
		subq.w	#1,d4
		bmi.b	adi_t12xno1

adi_t12xlop1	move.l	(a1)+,d0

		and.l	d1,d0
		lsr.l	#4,d0
		lsl.b	#4,d0
		lsl.w	#4,d0
		lsr.l	#6,d0
		addq.l	#1,(a0,d0.l)

		dbf	d4,adi_t12xlop1

adi_t12xno1	rts

;========================================================================

;=========================================================================
;-------------------------------------------------------------------------
;
;		AddHistogram
;
;		fügt einem Histogramm ein anderes Histogramm hinzu.
;		Quelle + Ziel -> Ziel
;
;	>	a0	APTR	Histogramm (Ziel)
;		a1	APTR	Histogramm (Quelle)
;		a2	struct TagItem *taglist
;	<	d0	LONG	Returncode ADH_...
;
;	Tags:	RND_Weight	Gewichtungsfaktor
;	
;-------------------------------------------------------------------------

AddHistogram:	movem.l	a2-a6/d2-d7,-(a7)

		move.l	a0,a3
		move.l	a1,a4
		moveq	#ADDH_NO_DATA,d7

		move.l	(utilitybase,pc),a6
		GetTag	#RND_Weight,#1,a2
		move.l	d0,d6		



		Lock		dhisto_semaphore(a4)

		move.l	a4,a0
		bsr	CountHistogram
		move.l	d0,d4
		beq.b	.error
		cmp.l	#NUMCOLORS_NOT_DEFINED,d7
		beq.b	.error


		btst.b	#HSTYPEB_TURBO,(dhisto_type,a4)
		beq.b	.tree


.table		move.l	a4,a0
		bsr	MakeTableHistogram
		tst.l	d0
		beq.b	.raus
		move.l	d0,a2

		moveq	#ADDH_SUCCESS,d3


.tabloop	move.l	(a2)+,d0	; RGB
		move.l	(a2)+,d1	; Count
		move.l	a3,a0		; Zielhistogramm

		mulu.l	d6,d1

		bsr	AddRGB
		move.l	d0,d7
		cmp.l	d3,d7
		bne.b	.raus
		
		subq.l	#1,d4
		bne.b	.tabloop

		moveq	#ADDH_SUCCESS,d7
		bra.b	.raus


.tree		move.l	(dhisto_tree,a4),a2
		add.w	#treeAnchor_SIZEOF,a2

		moveq	#ADDH_SUCCESS,d3
		moveq	#ADDH_SUCCESS,d7
		bsr.b	.recurse
		bra.b	.raus

.recurse	move.l	(a2),d0				; RGB
		move.l	4(a2),d1			; Count
		move.l	a3,a0				; ZielHistogramm

		cmp.l	d3,d7
		bne.b	.skip
		bsr	AddRGB
		move.l	d0,d7
.skip
		move.l	(rNode_left,a2),d1
		beq.b	.noleft

		move.l	a2,-(a7)
		move.l	d1,a2
		bsr.b	.recurse
		move.l	(a7)+,a2

.noleft		move.l	(rNode_right,a2),d1
		beq.b	.noright

		move.l	d1,a2
		bsr.b	.recurse

.noright	rts
		

.raus

.error		Unlock		dhisto_semaphore(a4)

		move.l	d7,d0
		movem.l	(a7)+,a2-a6/d2-d7
		rts

;=========================================================================






;-------------------------------------------------------------------------
;
;		MakeTurboHistogram
;
;		versucht aus einem Histogramm beliebigen Zustands
;		ein TurboC-Histogramm zu machen und liefert (wenn
;		erfolgreich) einen Zeiger auf die TurboC-Tabelle
;		zurück.
;
;	>	a0	APTR	Histogramm
;	<	d0	APTR	Turbo-Tabelle oder NULL, wenn
;				nicht möglich
;	
;-------------------------------------------------------------------------

MakeTurboHistogram:
		movem.l	d1/a0/a1/a5,-(a7)

		move.l	a0,a5

		move.b	(dhisto_conversion,a5),d0
		cmp.b	#HSCONVTYPE_TURBO,d0
		beq.b	mtuh_oki		; Turbo liegt bereits vor
		cmp.b	#HSCONVTYPE_TABLE,d0
		beq.b	mtuh_table		; es liegt Table vor

		illegal			; alles andere zur Zeit nicht definiert

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

mtuh_table	moveq	#15,d0
		and.b	(dhisto_type,a5),d0	; bits_per_gun
		move.w	d0,d1
		add.w	d0,d1
		add.w	d0,d1			; bits total...
		moveq	#4,d0			; ...Langworte...
		lsl.l	d1,d0			; ...Bytes
		move.l	d0,(dhisto_turbosize,a5)

		move.l	(dhisto_memhandler,a5),a0
		bsr.w	AllocRenderMem
		move.l	d0,(dhisto_turbo,a5)
		beq.w	mth_end			; Schiet

		move.l	(dhisto_turbo,a5),a0
		move.l	(dhisto_turbosize,a5),d0
		moveq	#0,d1
		bsr.w	TurboFillMem		; Turbotable löschen

		move.l	(dhisto_numcolors,a5),d0
		beq.b	mtuh_noconv

		move.l	(dhisto_table,a5),a0
		move.l	(dhisto_turbo,a5),a1
		move.b	(dhisto_type,a5),d1
		bsr.w	ConvTable2Turbo		; Table -> Turbo konvertieren

mtuh_noconv	move.l	(dhisto_memhandler,a5),a0
		move.l	(dhisto_table,a5),a1
		move.l	(dhisto_tablesize,a5),d0
		bsr.w	FreeRenderMem		; table freigeben
		clr.l	(dhisto_table,a5)
		clr.l	(dhisto_tablesize,a5)
		move.b	#HSCONVTYPE_TURBO,(dhisto_conversion,a5)

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

mtuh_oki	move.l	(dhisto_turbo,a5),d0

mtuh_end	movem.l	(a7)+,d1/a0/a1/a5
		rts

;-------------------------------------------------------------------------


;-------------------------------------------------------------------------
;
;		MakeTableHistogram
;
;		versucht aus einem Histogramm beliebigen Zustands
;		ein tabellarisches Histogramm zu machen und liefert
;		(wenn erfolgreich) einen Zeiger auf die Tabelle zurück.
;
;	>	a0	APTR	Histogramm
;	<	d0	APTR	Histogramm-Tabelle oder NULL, wenn
;				nicht möglich / keine Einträge
;	
;-------------------------------------------------------------------------

MakeTableHistogram
		movem.l	d1/a0/a1/a5,-(a7)

		move.l	a0,a5

		move.b	(dhisto_conversion,a5),d0
		cmp.b	#HSCONVTYPE_TABLE,d0
		beq.b	mth_oki			; es liegt schon Table vor
		cmp.b	#HSCONVTYPE_TURBO,d0
		beq.b	mth_turbo		; es liegt Turbo vor
	;	cmp.b	#HSCONVTYPE_TREE,d0
	;	beq.b	mth_oki			; es liegt ein Tree vor

		illegal			; alles andere zur Zeit nicht definiert

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

mth_tree

		illegal

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

mth_turbo	move.l	a5,a0
		bsr.w	CountHistogram
		tst.l	d0
		beq.b	mth_end

		lsl.l	#3,d0			; *8 Bytes pro Eintrag
		move.l	d0,(dhisto_tablesize,a5)
		move.l	(dhisto_memhandler,a5),a0
		bsr.w	AllocRenderMem
		move.l	d0,(dhisto_table,a5)		
		tst.l	d0
		beq.b	mth_end			; Schiet

		move.l	(dhisto_turbo,a5),a0
		move.l	(dhisto_table,a5),a1
		move.b	(dhisto_type,a5),d1
		bsr.w	ConvTurbo2Table		; Turbo -> Table

		move.l	(dhisto_memhandler,a5),a0
		move.l	(dhisto_turbo,a5),a1
		move.l	(dhisto_turbosize,a5),d0
		bsr.w	FreeRenderMem
		clr.l	(dhisto_turbo,a5)
		clr.l	(dhisto_turbosize,a5)
		move.b	#HSCONVTYPE_TABLE,(dhisto_conversion,a5)

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

mth_oki		move.l	(dhisto_table,a5),d0

mth_end		movem.l	(a7)+,d1/a0/a1/a5
		rts

;-------------------------------------------------------------------------


;-------------------------------------------------------------------------
;
;		MakeTreeHistogram
;
;		versucht aus einem Histogramm beliebigen Zustands
;		ein Baum-Histogramm zu machen und liefert (wenn
;		erfolgreich) einen Zeiger auf den Baum zurück.
;
;	>	a0	APTR	Histogramm
;	<	d0	APTR	Histogramm-Baum oder NULL, wenn
;				zuwenig Speicher
;	
;-------------------------------------------------------------------------

MakeTreeHistogram:
		movem.l	d1-d2/a0/a1/a5,-(a7)

		move.l	a0,a5

		move.b	(dhisto_conversion,a5),d0

		cmp.b	#HSCONVTYPE_TREE,d0
		beq.b	mtrh_oki		; es liegt schon Tree vor

		illegal			; alles andere zur Zeit nicht definiert


mtrh_oki	move.l	(dhisto_tree,a5),d0

mtrh_end	movem.l	(a7)+,d1-d2/a0/a1/a5
		rts

;-------------------------------------------------------------------------


;-------------------------------------------------------------------------
;
;		ConvTurbo2Table
;
;		konvertiert ein Turbo-Histogramm
;		in ein Tabellen-Histogramm.
;
;	>	a0	APTR	Turbo-Histogramm
;		a1	APTR	Speicher für Table-Histogramm
;		d1	UBYTE	HSTYPE
;	
;-------------------------------------------------------------------------

ConvTurbo2Table:
		movem.l	d0-d7/a0-a2,-(a7)
		move.l	a0,a2
		moveq	#15,d0		; bits_per_gun
		and.b	d1,d0

		lea	.conv,a0
		TABLEEXECUTE

		movem.l	(a7)+,d0-d7/a0-a2
		rts

.conv		move.l	(a2)+,d7	; Anzahl holen
		beq.b	.skip		; kein Eintrag - skippen
		move.l	d0,(a1)+	; RGB ablegen
		move.l	d7,(a1)+	; Anzahl ablegen
.skip		rts

;-------------------------------------------------------------------------


;-------------------------------------------------------------------------
;
;		ConvTable2Turbo
;
;		konvertiert ein Table-Histogramm
;		in ein Turbo-Histogramm.
;
;	>	a0	APTR	Table-Histogramm
;		a1	APTR	Speicher für Turbo-Histogramm (MEMF_CLEAR)
;		d0	ULONG	numcolors
;		d1	UBYTE	HSTYPE
;	
;-------------------------------------------------------------------------

ConvTable2Turbo:
		move.l	d2,-(a7)

		move.l	d0,d2

		and.b	#15,d1			; bits-per-gun raussaften
		cmp.b	#5,d1
		beq.b	cta2tu_15bitlop
		cmp.b	#6,d1
		beq.b	cta2tu_18bitlop
		cmp.b	#4,d1
		beq.b	cta2tu_12bitlop
		illegal				; nicht definiert

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

cta2tu_15bitlop	move.l	(a0)+,d0

		lsr.l	#3,d0
		lsl.b	#3,d0
		lsl.w	#3,d0
		lsr.l	#4,d0

		move.l	(a0)+,(a1,d0.l)

		subq.l	#1,d2
		bne.b	cta2tu_15bitlop
		bra.b	cta2tu_ok

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

cta2tu_18bitlop	move.l	(a0)+,d0

		lsr.l	#2,d0
		lsl.b	#2,d0
		lsl.w	#2,d0
		lsr.l	#2,d0

		move.l	(a0)+,(a1,d0.l)

		subq.l	#1,d2
		bne.b	cta2tu_18bitlop
		bra.b	cta2tu_ok

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

cta2tu_12bitlop	move.l	(a0)+,d0

		lsr.l	#4,d0
		lsl.b	#4,d0
		lsl.w	#4,d0
		lsr.l	#6,d0

		move.l	(a0)+,(a1,d0.l)

		subq.l	#1,d2
		bne.b	cta2tu_12bitlop

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

cta2tu_ok	move.l	(a7)+,d2
		rts

;-------------------------------------------------------------------------



;-------------------------------------------------------------------------
;
;		CreateTreeBlock
;
;		erzeugt einen Block eines Renderbaums.
;
;	>	a0	APTR	RenderMemHandler
;	<	d0	APTR	Zeiger auf TreeAnchor oder NULL
;	
;-------------------------------------------------------------------------

CreateTreeBlock	move.l	a0,-(a7)

		move.l	#NODESPERBLOCK*rNode_SIZEOF,d0
		bsr.b	CreateBlock
		move.l	d0,a0
		tst.l	d0
		beq.b	crtree_failed

		move.w	#NODESPERBLOCK,(treeAnchor_maxnodes,a0)
		move.w	#NODESPERBLOCK,(treeAnchor_freenodes,a0)

crtree_failed	move.l	(a7)+,a0
		rts


;-------------------------------------------------------------------------
;
;		CreateBlock
;
;		erzeugt einen TreeAnchor-Speicherblock.
;
;	>	a0	APTR	RenderMemHandler
;		d0	ULONG	Anzahl Bytes, die in den Block passen sollen
;	<	d0	APTR	Zeiger auf Blockanfang oder NULL
;	
;-------------------------------------------------------------------------

CreateBlock	movem.l	d1-d3/a0-a2,-(a7)

		move.l	a0,a2

		move.w	d0,d3
	
		add.l	#treeAnchor_SIZEOF,d0
		move.l	d0,d2
		
		bsr.w	AllocRenderMem
		move.l	d0,a0
		tst.l	d0
		beq.b	crtr_failed

		clr.l	(a0)+			; next
		clr.l	(a0)+			; prev
		move.l	a2,(a0)+		; memhandler
		move.l	d2,(a0)+		; blocksize

crtr_failed	movem.l	(a7)+,d1-d3/a0-a2
		rts

;-------------------------------------------------------------------------


;-------------------------------------------------------------------------
;
;		DeleteRenderTree
;
;		löscht einen Digitalbaum.
;
;	>	a0	APTR	Baum
;	
;-------------------------------------------------------------------------

DeleteRenderTree:
		movem.l	d0-d1/a0-a2,-(a7)

		;	Ans Listenende gehen, denn wir geben
		;	den Speicher von hinten nach vorne frei

		move.l	a0,d0

dltr_findend	move.l	d0,a2
		move.l	(a2),d0
		bne.b	dltr_findend

		;	ab Block <a2> Liste freigeben:

dltr_reverse	move.l	(treeAnchor_memhandler,a2),a0	; memhandler
		move.l	(treeAnchor_blocksize,a2),d0	; size
		move.l	a2,a1				; block
		move.l	(treeAnchor_prev,a2),a2
		bsr.w	FreeRenderMem
		move.l	a2,d0
		bne.b	dltr_reverse

		movem.l	(a7)+,d0-d1/a0-a2
		rts

;-------------------------------------------------------------------------


;-------------------------------------------------------------------------
;
;		GetRenderTreeMemPtrs
;
;		liefert den Zeiger auf freien Speicher
;		in einem Renderbaum sowie den Zeiger auf den
;		Start des aktuellen Blocks. Wenn alle Blöcke
;		vollständig belegt sind, wird versucht, den Baum
;		um einen Block zu erweitern.
;
;	>	a0	struct TreeAnchor *	Baum
;	<	d0	APTR			MemPtr oder NULL
;		d1	struct TreeAnchor *	Block oder NULL
;	
;-------------------------------------------------------------------------

GetRenderTreeMemPtrs

		;	ans Listenende gehen

		bra.b	grtmp_1
grtmp_2		move.l	d0,a0
grtmp_1		move.l	(a0),d0
		bne.b	grtmp_2

		moveq	#0,d0
		move.w	(treeAnchor_freenodes,a0),d0
		bne.b	grtmp_ok

		;	keine freien Knoten mehr

		move.w	(treeAnchor_maxnodes,a0),d0
		move.l	(treeAnchor_memhandler,a0),a0
		bsr.w	CreateTreeBlock			; neuen Block anlegen
		move.l	d0,d1
		beq.b	grtmp_raus

		add.l	#treeAnchor_SIZEOF,d0
		bra.b	grtmp_raus

grtmp_ok	move.l	a0,d1
		neg.w	d0
		add.w	(treeAnchor_maxnodes,a0),d0
		mulu.w	#rNode_SIZEOF,d0
		add.w	#treeAnchor_SIZEOF,a0	; +Header
		add.l	a0,d0			; +Block

grtmp_raus	rts

;-------------------------------------------------------------------------


;-------------------------------------------------------------------------
;
;		AddRGB2Tree
;
;		fügt einen einzelnen RGB-Wert
;		einem Renderbaum hinzu.
;
;	>	a0	APTR	Baum
;		d0	ULONG	RGB
;		d1	ULONG	Count
;	<	d0	LONG	Anzahl hinzugekommener Knoten oder
;				negativ, wenn fehlgeschlagen
;	
;-------------------------------------------------------------------------

AddRGB2Tree:	movem.l	d1-d5/a1/a2/a4-a5,-(a7)

		move.l	d0,d2
		move.l	d1,d3

		moveq	#treeAnchor_SIZEOF,d4
		add.l	a0,d4					; Rootzeiger

		bsr.w	GetRenderTreeMemPtrs
		move.l	d0,a4					; Speicherzeiger
		tst.l	d0
		beq.b	argb2t_fail
		move.l	d1,a5					; Blockzeiger

		move.w	(treeAnchor_freenodes,a5),d5		; Anzahl freier Knoten im Block
		subq.w	#1,d5

		move.l	d3,d1
		bsr.w	AddFirstNode
		bmi.b	argb2t_end

		addq.w	#1,d5
		move.w	d5,(treeAnchor_freenodes,a5)

		bra.b	argb2t_end

argb2t_fail	moveq	#-1,d0

argb2t_end	movem.l	(a7)+,d1-d5/a1/a2/a4-a5
		rts

;-------------------------------------------------------------------------


;-------------------------------------------------------------------------
;
;		AddImage2Tree
;
;		fügt ein RGB-Bild
;		einem Renderbaum hinzu.
;
;	>	a0	APTR	RGB
;		a1	APTR	Baum
;		d0	UWORD	Width
;		d1	ULONG	AND-Maske (relevante Bits)
;	<	d0	LONG	Anzahl neu hinzugekommener Knoten,
;				oder negativ: Fehler aufgetreten
;	
;-------------------------------------------------------------------------

AddImage2Tree:	movem.l	d1-d7/a0-a6,-(a7)

		lea	(treeAnchor_SIZEOF,a1),a6	; Root

		move.l	d1,d6				; Maske

		move.w	d0,d7				; Width 
		subq.w	#1,d7

		move.l	a0,a3

		move.l	a1,a0
		bsr.w	GetRenderTreeMemPtrs
		move.l	d0,a4				; Speicherzeiger
		tst.l	d0
		beq.b	aimtr_fail2
		move.l	d1,a5				; Blockzeiger

		move.w	(treeAnchor_freenodes,a5),d5	; Anzahl freier Knoten im Block
		subq.w	#1,d5

		sub.l	a2,a2

		move.l	(a3)+,d2		; RGB
		and.l	d6,d2
		move.l	a6,d4			; Root
		moveq	#1,d1			; Count
		bsr.b	AddFirstNode
		bmi.b	aimtr_end
		add.w	d0,a2
		dbf	d7,aimtr_xloop
		move.l	a2,d0
		bra.b	aimtr_end

aimtr_xloop	move.l	(a3)+,d2		; RGB holen
		and.l	d6,d2			; irrelevante Bits raus
		move.l	a6,d4			; Root
		moveq	#1,d1
		bsr.b	AddMoreNodes		; im Baum ablegen
		bmi.b	aimtr_end
		add.w	d0,a2
		dbf	d7,aimtr_xloop
		move.l	a2,d0
		bra.b	aimtr_end

aimtr_fail2	moveq	#-1,d0
		bra.b	aimtr_end2

aimtr_end	addq.w	#1,d5
		move.w	d5,(treeAnchor_freenodes,a5)

aimtr_end2	movem.l	(a7)+,d1-d7/a0-a6
		rts

;-------------------------------------------------------------------------


;-------------------------------------------------------------------------
;
;		AddFirstNode
;		AddMoreNodes
;
;		fügt einen Knoten in einen Renderbaum ein.
;		Mit dynamischer Speicherverwaltung.
;		Der zweite Einsprungspunkt spart etwas Overhead.
;
;	>	d1	ULONG	Anzahl
;		d2	ULONG	RGB
;		d4	APTR	Root
;		d5	UWORD	Anzahl freier Knoten im Block-1
;		a4	APTR	Speicherzeiger
;		a5	APTR	Blockzeiger
;
;	<	d0	WORD	Anzahl hinzugekommener Knoten, oder
;				negativ = zuwenig Speicher.
;		d5	UWORD	Anzahl freier Knoten im Block-1
;		a4	APTR	Speicherzeiger
;		a5	APTR	Blockzeiger
;
;-------------------------------------------------------------------------

AddFirstNode	cmp.l	a4,d4		; Memptr == Rootptr?
		bne.b	atn_addmore

		dbf	d5,atn_anlegen	; Root anlegen

		illegal			; darf nie hierhin gelangen

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

AddMoreNodes

atn_addmore	move.l	d2,d0

atn_sloop	move.l	d4,a0

		cmp.l	(a0),d2				; == RGB ?
		bne.b	atn_notfound

		add.l	d1,(rNode_count,a0)
		moveq	#0,d0				; eingetragen
		rts

atn_fail	moveq	#-1,d0				; zu wenig Speicher
		rts

atn_notfound	lsr.l	#1,d0
		bcc.b	atn_left
		
atn_right	move.l	(rNode_right,a0),d4		; rechts weiter
		bne.b	atn_sloop

		dbf	d5,atn_rightok

		bsr.b	atn_newblock
		beq.b	atn_fail

atn_rightok	move.l	a4,(rNode_right,a0)		; Knoten rechts anlegen

atn_anlegen	move.l	d2,(a4)+			; RGB
		move.l	d1,(a4)+			; Anzahl
		clr.l	(a4)+				; invalid Pen
		clr.l	(a4)+				; left
		clr.l	(a4)+				; right
		moveq	#1,d0				; Knoten dazugekommen
		rts

atn_left	move.l	(rNode_left,a0),d4		; links weiter
		bne.b	atn_sloop

		dbf	d5,atn_leftok

		bsr.b	atn_newblock
		beq.b	atn_fail

atn_leftok	move.l	a4,(rNode_left,a0)		; Knoten links anlegen
		move.l	d2,(a4)+			; RGB
		move.l	d1,(a4)+			; Anzahl
		clr.l	(a4)+				; invalid Pen
		clr.l	(a4)+				; left
		clr.l	(a4)+				; right
		moveq	#1,d0				; Knoten dazugekommen
		rts

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;		Ein neuer Block wird benötigt.
;		Allozieren, verketten und Header initialisieren.

atn_newblock	movem.l	a0/a1/d1,-(a7)
		clr.w	(treeAnchor_freenodes,a5)	; dieser Block ist voll
		move.w	(treeAnchor_maxnodes,a5),d0
		move.l	(treeAnchor_memhandler,a5),a0
		bsr.w	CreateTreeBlock
		move.l	d0,(treeAnchor_next,a5)
		beq.b	atn_fail2
		exg	d0,a5
		move.l	d0,(treeAnchor_prev,a5)
		move.w	(treeAnchor_freenodes,a5),d5
		subq.w	#2,d5
		lea	(treeAnchor_SIZEOF,a5),a4	; neuer Memptr
atn_fail2	movem.l	(a7)+,a0/a1/d1
		tst.l	d0				; Flags bleiben aktiv
		rts

;-------------------------------------------------------------------------

	ENDC

