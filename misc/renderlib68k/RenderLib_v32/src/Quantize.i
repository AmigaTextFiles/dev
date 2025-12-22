
	IFND	QUANTIZE_I
QUANTIZE_I		SET	1

;-------------------------------------------------------------------------
;
;	Mediancut-Parameterstruktur
;
;-------------------------------------------------------------------------

	STRUCTURE	MedianCut_LocalData,0

		UWORD	mdd_destcolors		; Anzahl Zielfarben

		UWORD	mdd_redweight		; Gewichtung
		UWORD	mdd_greenweight
		UWORD	mdd_blueweight

		APTR	mdd_filterhook		; RGB-Filter-Hook

		APTR	mdd_progresshook	; Progress-Hook
		APTR	mdd_histogram		; das Objekt des Progress-Hooks
						; (ausschließlich zur Identifikation)

		APTR	mdd_memhandler		; Memhandler für interne Puffer
		ULONG	mdd_histocolors		; Anzahl Farben im Histogramm
		APTR	mdd_hparray		; Histogram-Pointer-Array


		APTR	mdd_sqrbuffer		; intern - nicht zu initialisieren
		APTR	mdd_buffers		; intern - nicht zu initialisieren


		STRUCT	mdd_coltab,256*4	; Farbtabelle


		APTR	mdd_splitfunc		; Split-Funktion
		APTR	mdd_diversityfunc	; Diversity-Funktion

	LABEL		mdd_SIZEOF

;-------------------------------------------------------------------------



;=========================================================================
;-------------------------------------------------------------------------
;
;		ExtractPalette 2.0
;
;	>	a0	APTR	Histogramm
;		a1	APTR	Palette
;		d0	UWORD	Anzahl Farben
;		a2	struct TagItem *Taglist
;	<	d0	ULONG	Returncode EXTP_...
;
;	Tags:	RND_ColorMode		Default:	COLORMODE_CLUT
;		RND_RGBWeight		Default:	0x00010101
;		RND_ProgressHook	Default:	NULL
;		RND_RMHandler		Default:	Memhandler des Histogramms
;
;------------------------------------------------------------------------

ExtractPalette:	movem.l	d2-d7/a2-a6,-(a7)

		move.l	a0,a3
		move.l	a1,a4
		moveq	#0,d6
		move.w	d0,d6
		move.l	(utilitybase,pc),a6

		Lock		dhisto_semaphore(a3)


		;- - - -- - - - -- --   ----      - - - -- --   -- -- 

		; Memhandler ermitteln

		move.l	(dhisto_memhandler,a3),d7		; Default
		GetTag	#RND_RMHandler,d7,a2
		move.l	d0,d5


		;- - - -- - - - -- --   ----      - - - -- --   -- -- 

		; Parameterstruktur anlegen

		moveq	#EXTP_NOT_ENOUGH_MEMORY,d7
		
		move.l	d5,a0
		move.l	#mdd_SIZEOF,d0
		bsr	AllocRenderVec
		tst.l	d0
		beq	.raus
		move.l	d0,a5

		move.l	a3,(mdd_histogram,a5)
		move.w	d6,(mdd_destcolors,a5)
		move.l	d5,(mdd_memhandler,a5)


		;- - - -- - - - -- --   ----      - - - -- --   -- -- 

		; Anzahl Farben im Histogramm

		moveq	#EXTP_NO_DATA,d7

		move.l	a3,a0
		bsr	CountHistogram
		move.l	d0,(mdd_histocolors,a5)
		beq	.ende
		cmp.l	#NUMCOLORS_NOT_DEFINED,d0
		beq	.ende
		cmp.l	d6,d0
		bhi.b	.extract

		;- - - -- - - - -- --   ----      - - - -- --   -- -- 

		; Palette einfach aus Histogramm ziehen

		move.l	a3,a0
		lea	(mdd_coltab,a5),a1
		move.l	d6,d0
		bsr	CopyHistogram2Palette

		clr.l	(mdd_hparray,a5)

		moveq	#EXTP_SUCCESS,d7
		bra.b	.paletteok

		;- - - -- - - - -- --   ----      - - - -- --   -- -- 

.extract	moveq	#EXTP_NOT_ENOUGH_MEMORY,d7

		move.l	a3,a0
		bsr	CreateHistogramPointerArray
		tst.l	d0
		beq	.noarray
		move.l	d0,(mdd_hparray,a5)

		GetTag	#RND_ProgressHook,#0,a2
		move.l	d0,(mdd_progresshook,a5)

		GetTag	#RND_RGBWeight,#$010101,a2
		bfextu	d0{8:8},d1
		move.w	d1,(mdd_redweight,a5)
		bfextu	d0{16:8},d1
		move.w	d1,(mdd_greenweight,a5)
		bfextu	d0{24:8},d1
		move.w	d1,(mdd_blueweight,a5)
		
		
		; Medianschnitt durchführen

		move.l	a5,a0
		bsr	MedianCut

		move.l	d0,d7			; Ergebnis merken
		cmp.l	#EXTP_SUCCESS,d7
		bne	.error
		

.paletteok	; Palette kopieren und nachbehandeln

		Lock		pal_semaphore(a4)

		move.l	a4,a0
		bsr	PAL_DeleteP2Table

		GetTag	#RND_NewPalette,#-1,a2		; TRUE
		tst.l	d0
		beq.b	.nonewpalette
		clr.w	(pal_numcolors,a4)
.nonewpalette
		GetTag	#RND_FirstColor,#0,a2
		move.w	d0,d5

		add.w	d6,d0			; Anzahl Farben + StartIndex
		cmp.w	(pal_numcolors,a4),d0
		ble.b	.notgrow
		move.w	d0,(pal_numcolors,a4)	; Palettengröße aktualisieren

.notgrow	GetTag	#RND_ColorMode,#COLORMODE_CLUT,a2
		
		move.l	#$ffffff,d2		; Maske
		cmp.w	#COLORMODE_HAM6,d0
		bne.b	.maskok
		move.l	#$f0f0f0,d2		; HAM6-Maske

.maskok		lea	(mdd_coltab,a5),a0
		lea	(pal_palette,a4,d5.w*4),a1
		move.w	d6,d0
		subq.w	#1,d0
.loop		move.l	(a0)+,d1
		and.l	d2,d1
		move.l	d1,(a1)+
		dbf	d0,.loop

		; Wordpalette erzeugen

		lea	(pal_palette,a4),a0
		lea	(pal_wordpalette,a4),a1
		move.w	(pal_numcolors,a4),d0
		bsr	ConvertWordPalette

		Unlock		pal_semaphore(a4)

.error
		move.l	(mdd_histogram,a5),a0
		bsr	RemoveTreeInterpolation

		move.l	(mdd_hparray,a5),d0
		beq.b	.noarray
		move.l	d0,a0
		bsr	FreeRenderVec

.noarray

.ende		move.l	a5,a0
		bsr	FreeRenderVec

.raus		move.l	d7,d0


		Unlock		dhisto_semaphore(a3)		

		movem.l	(a7)+,d2-d7/a2-a6
		rts

;=========================================================================


;-------------------------------------------------------------------------
;
;		CopyHistogram2Palette
;
;		kopiert den Inhalt eines Histogramms in eine
;		Tabelle. Ohne Prüfung auf ausreichend Platz.
;
;	>	a0	Histogramm
;		a1	Colortable
;		d0	Anzahl Einträge in der Palette
;
;-------------------------------------------------------------------------

CopyHistogram2Palette:

		movem.l	d0-d2/a0-a2,-(a7)

		move.l	a0,a2

		move.l	a1,a0
		subq.w	#1,d0
.fillop		move.l	#$00ff00ff,(a0)+
		dbf	d0,.fillop


		move.l	a2,a0
		bsr	CountHistogram
		cmp.l	#NUMCOLORS_NOT_DEFINED,d0
		beq.b	.illegal
		move.l	d0,d2
		beq.b	.ok

		btst	#HSTYPEB_TURBO,(dhisto_type,a2)
		bne.b	.copyturbo

		move.l	(dhisto_tree,a2),a0
		add.w	#treeAnchor_SIZEOF,a0

		bsr.b	.recurse
		bra.b	.ok


		; Farben aus Baum rekursiv auslesen

.recurse	move.l	(a0),(a1)+		; RGB hoeln

		move.l	(rNode_left,a0),d1
		beq.b	.noleft

		move.l	a0,-(a7)
		move.l	d1,a0
		bsr.b	.recurse
		move.l	(a7)+,a0

.noleft		move.l	(rNode_right,a0),d1
		beq.b	.noright

		move.l	d1,a0
		bsr.b	.recurse

.noright	rts

.illegal	illegal

.copyturbo	move.l	a2,a0
		bsr	MakeTableHistogram
		tst.l	d0
		beq.b	.illegal

		move.l	d0,a0

		subq.w	#1,d2
.coploop	move.l	(a0),(a1)+
		addq.w	#8,a0
		dbf	d2,.coploop

.ok		movem.l	(a7)+,d0-d2/a0-a2
		rts

;-------------------------------------------------------------------------


;-------------------------------------------------------------------------
;
;		CreateHistogramPointerArray
;
;		Erzeugt ein Array mit Zeigern auf die Einträge
;		im Histogramm. Das Pointerarray kann einfach mit
;		FreeRenderVec() gelöscht werden.
;
;		ACHTUNG: Diese Funktion wird nur vor der Quantisierung
;		benötigt. In der Baumversion wird daher noch eine andere
;		quantisierungsspezifische Aufgabe miterledigt: Alle
;		Knoten erhalten die Interpolierungsmaske. WICHTIG: Nach
;		der Quantisierung muß RemoveTreeInterpolation aufgerufen
;		werden, damit diese wieder entfernt wird.
;
;	>	a0	Histogramm
;	<	d0	HistogrammPointerArray oder NULL
;
;-------------------------------------------------------------------------

CreateHistogramPointerArray

		movem.l	d1-d6/a0/a1/a5/a6,-(a7)

		move.l	a0,a5

		bsr	CountHistogram
		move.l	d0,d2
		beq.b	chpa_raus

		move.l	(dhisto_memhandler,a5),a0
		lsl.l	#2,d0
		bsr	AllocRenderVec
		move.l	d0,a6
		tst.l	d0
		beq.b	chpa_raus

		btst.b	#HSTYPEB_TURBO,(dhisto_type,a5)
		bne.b	chpa_turbo

		move.l	a5,a0
		bsr	MakeTreeHistogram
		move.l	d0,a0
		tst.l	d0
		beq.b	chpa_raus2

		move.l	(dhisto_andmask,a5),d4		; Relevanzmaske
		not.l	d4
		moveq	#15,d5
		and.b	(dhisto_type,a5),d5		; Bitspergun

		lea	(treeAnchor_SIZEOF,a0),a0
		move.l	a6,a1
		bsr.b	chpa_recurse
		bra.b	chpa_raus

chpa_turbo	move.l	a5,a0
		bsr	MakeTableHistogram
		tst.l	d0
		beq.b	chpa_raus2

		move.l	a6,a1
chpa_turboloop	move.l	d0,(a1)+
		addq.l	#8,d0
		subq.l	#1,d2
		bne.b	chpa_turboloop
		bra.b	chpa_raus

chpa_raus2	move.l	a6,a0
		bsr	FreeRenderVec

chpa_raus	move.l	a6,d0

		movem.l	(a7)+,d1-d6/a0/a1/a5/a6
		rts

;-------------------------------------------------------------------------
;
;		Baum rekursiv abarbeiten

chpa_recurse	move.l	a0,(a1)+		; Pointer eintragen

		move.l	(a0),d3			; RGB interpolieren
		move.l	d3,d6
		lsr.l	d5,d3
		and.l	d4,d3
		or.l	d6,d3
		move.l	d3,(a0)

		move.l	(rNode_left,a0),d1
		beq.b	chpa_noleft

		move.l	a0,-(a7)
		move.l	d1,a0
		bsr.b	chpa_recurse
		move.l	(a7)+,a0

chpa_noleft	move.l	(rNode_right,a0),d1
		beq.b	chpa_noright

		move.l	d1,a0
		bsr.b	chpa_recurse

chpa_noright	rts

;-------------------------------------------------------------------------

;-------------------------------------------------------------------------
;
;		RemoveTreeInterpolation
;
;		entfernt etwaige Rundungsbits
;		aus einem etwaigen Baum.
;		
;	>	a0	Histogramm
;
;-------------------------------------------------------------------------

RemoveTreeInterpolation

		movem.l	d0/d1/a0,-(a7)

		move.l	(dhisto_tree,a0),d0
		beq.b	rtri_notree

		bsr.b	rtri_tree

rtri_notree	movem.l	(a7)+,d0/d1/a0
		rts

rtri_tree	move.l	(dhisto_andmask,a0),d1

		move.w	#treeAnchor_SIZEOF,a0
		add.l	d0,a0

rtri_recurse	and.l	d1,(a0)			; Maskieren

		move.l	(rNode_left,a0),d0
		beq.b	rtri_noleft

		move.l	a0,-(a7)
		move.l	d0,a0
		bsr.b	rtri_recurse
		move.l	(a7)+,a0

rtri_noleft	move.l	(rNode_right,a0),d0
		beq.b	rtri_noright

		move.l	d0,a0
		bsr.b	rtri_recurse

rtri_noright	rts

;-------------------------------------------------------------------------


	ENDC
