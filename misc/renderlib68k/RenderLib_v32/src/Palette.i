
	IFND RENDER_PALETTE_I
RENDER_PALETTE_I	SET	1

		INCLUDE	exec/semaphores.i

;=========================================================================
;-------------------------------------------------------------------------
;
;		BestPen
;
;		ermittelt den besten Pen einer Palette
;
;	>	a0	APTR	Palette
;		d0	ULONG	RGB
;	<	d0	LONG	pen oder -1
;
;-------------------------------------------------------------------------

BestPen:	Lock		pal_semaphore(a0)

		movem.l	d2-d7/a0/a2-a4,-(a7)

		move.l	a0,a2
		move.l	d0,d2

		moveq	#-1,d0
		move.w	(pal_numcolors,a2),d4
		beq	.ok

		lea	(quadtab,pc),a3

		bsr	PAL_AttemptP2Table
		tst.l	d0
		beq.b	.notable		

		move.l	d0,a4

		moveq	#8,d3
		sub.w	(pal_p2bitspergun,a2),d3
		move.l	d2,d1
		lsr.l	d3,d1
		lsl.b	d3,d1
		lsl.w	d3,d1
		add.w	d3,d3
		lsr.l	d3,d1

		move.w	(a4,d1.l*2),d3
		bpl	.found

		move.l	d1,-(a7)

		move.l	d2,d0
		add.w	#pal_wordpalette,a2

		FINDPEN_PALETTE

		move.l	(a7)+,d1
		move.w	d0,(a4,d1.l*2)

		move.w	d0,d3
		bra.b	.found


.notable	move.l	d2,d0
		add.w	#pal_wordpalette,a2
		FINDPEN_PALETTE
		move.w	d0,d3

.found		moveq	#0,d0
		move.b	d3,d0
	
.ok		movem.l	(a7)+,d2-d7/a0/a2-a4

		Unlock		pal_semaphore(a0)
		rts

;=========================================================================


;=========================================================================
;-------------------------------------------------------------------------
;
;		CreatePalette
;
;		Erzeugt eine Palette
;
;	>	a1	struct TagItem *TagList
;	<	d0	APTR	Palette oder NULL
;
;	Tags:	RND_HSType
;		RND_RMHandler
;
;-------------------------------------------------------------------------

CreatePalette:	movem.l	d7/a2-a4/a6,-(a7)

		move.l	(utilitybase,pc),a6
		move.l	a1,a3

		GetTag	#RND_RMHandler,#0,a3
		move.l	d0,a4
		
		GetTag	#RND_HSType,#HSTYPE_15BIT,a3
		moveq	#15,d7
		and.w	d0,d7

		cmp.w	#6,d7
		ble.b	.ok
.illegal	illegal
.ok		cmp.w	#4,d7
		blt.b	.illegal

		move.l	a4,a0
		move.l	#pal_SIZEOF,d0
		bsr	AllocRenderVec
		tst.l	d0
		beq.b	.error
		move.l	d0,a2


		clr.w	(pal_numcolors,a2)
		move.w	d7,(pal_bitspergun,a2)

		move.l	a4,(pal_memhandler,a2)
		clr.l	(pal_p2table,a2)
		sf	(pal_p2valid,a2)


		lea	(pal_maplist,a2),a0	; Liste der Map-Engines initialisieren
		NEWLIST	a0

		move.l	(execbase,pc),a6

		lea	(pal_semaphore,a2),a0
		move.l	a0,a1
		moveq	#SS_SIZE/2-1,d0
.clrsl		clr.w	(a1)+
		dbf	d0,.clrsl
		jsr	(_LVOInitSemaphore,a6)

		move.l	a2,d0

.error
		movem.l	(a7)+,d7/a2-a4/a6
		rts

;=========================================================================


;=========================================================================
;-------------------------------------------------------------------------
;
;		DeletePalette
;
;		Entfernt eine Palette.
;
;	>	a0	APTR	Palette
;
;-------------------------------------------------------------------------

DeletePalette:	movem.l	a2/a6,-(a7)
		move.l	a0,a2

	;!	Lock		pal_semaphore(a2)
		
		move.l	a2,a0
		bsr	PAL_DeleteP2Table

	;!	Unlock		pal_semaphore(a2)	;!!!

		move.l	a2,a0
		bsr	FreeRenderVec
		movem.l	(a7)+,a2/a6
		rts

;=========================================================================




;-------------------------------------------------------------------------
;
;		InvalidatePalette
;
;		macht eine Palette ungültig und setzt das
;		modified-Flag in allen Map-Engines. Die
;		Palette muß exklusiv gelockt sein.
;
;	>	a0	Palette
;
;-------------------------------------------------------------------------
;-------------------------------------------------------------------------
;
;		InvalidateMapList
;
;		setzt das modified-Flag in allen Map-Engines. Die
;		Palette muß exklusiv gelockt sein.
;
;	>	a0	Palette
;
;-------------------------------------------------------------------------

InvalidatePalette:
		sf	(pal_p2valid,a0)

InvalidateMapList:
		movem.l	d0/a0,-(a7)

		TSTLST2	pal_maplist(a0),a0
		beq.b	.raus

.loop		st	(map_modified,a0)
		TSTNODE	a0,a0
		bne.b	.loop
.raus
		movem.l	(a7)+,d0/a0
		rts


;-------------------------------------------------------------------------
;
;		PAL_CreateP2Table
;		Pal_AttemptP2Table
;
;		legt eine P2Table an und trägt sie in eine
;		Palette ein. Ist eine P2Table vorhanden, wird
;		geprüft, ob sie gültig ist. Wenn nicht, wird sie
;		initialisiert.
;
;		Die zweite Variante liefert Null, wenn keine
;		oder keine gültige p2Table vorliegt.
;
;		Die Palette muß exklusiv gelockt sein!
;
;	Anm.:	Zunächst wird versucht, eine P2Table in der
;		Auflösung der Palette anzulegen, bei Mißerfolg
;		wird runterskaliert.
;
;	>	a0	Palette
;	<	d0	P2Table oder NULL
;
;-------------------------------------------------------------------------

PAL_AttemptP2Table:

		move.l	(pal_p2table,a0),d0
		beq.b	.raus

		tst.b	(pal_p2valid,a0)
		bne.b	.raus

		moveq	#0,d0

.raus		rts


PAL_CreateP2Table:

		movem.l	d1-d7/a0-a1/a5,-(a7)

		move.l	a0,a5

		move.l	(pal_p2table,a5),d0

		tst.b	(pal_p2valid,a5)
		bne.b	.raus

		tst.l	d0
		bne.b	.p2present


		move.w	(pal_bitspergun,a5),d7

.tryagain	move.w	d7,d1

		move.w	d1,d6
		add.w	d6,d1
		add.w	d6,d1

		moveq	#2,d2
		lsl.l	d1,d2
		move.l	d2,(pal_p2size,a5)		; Größe der p2table

		move.l	(pal_memhandler,a5),a0
		move.l	d2,d0
		bsr.w	AllocRenderVec
		move.l	d0,(pal_p2table,a5)
		bne.b	.memok

		subq.w	#1,d7
		cmp.w	#4,d7
		bge.b	.tryagain

		move.l	a5,a0
		bsr	InvalidatePalette		; sf (pal_p2valid,a5)
		bra.b	.raus

.memok		move.w	d7,(pal_p2bitspergun,a5)	; tatsächliche Bitspergun eintragen

		moveq	#8,d4
		sub.w	d7,d4
		move.w	d4,(pal_p2HAM2,a5)
		moveq	#15,d4
		sub.w	d7,d4
		sub.w	d7,d4
		move.w	d4,(pal_p2HAM1,a5)
		

.p2present	move.l	d0,a0

		; p2table validieren (mit -1 füllen)

		move.l	(pal_p2size,a5),d0	; Größe der p2tab [Bytes]
		moveq	#-1,d1
		bsr.w	TurboFillMem
		move.l	a0,d0
		st	(pal_p2valid,a5)

.raus		movem.l	(a7)+,d1-d7/a0-a1/a5
		rts

;-------------------------------------------------------------------------



;-------------------------------------------------------------------------
;
;		PAL_DeleteP2Table
;
;		entfernt eine P2Table aus einer Palette.
;		Die Palette muß exklusiv gelockt sein!
;
;	>	a0	Palette
;
;-------------------------------------------------------------------------

PAL_DeleteP2Table:

		movem.l	d0/d1/a0/a1,-(a7)

		move.l	(pal_p2table,a0),d0
		beq.b	.none

		bsr	InvalidatePalette	;sf (pal_p2valid,a0)

		clr.l	(pal_p2table,a0)	;!!!

		move.l	d0,a0
		bsr.w	FreeRenderVec
.none
		movem.l	(a7)+,d0/d1/a0/a1
		rts

;-------------------------------------------------------------------------




;=========================================================================
;-------------------------------------------------------------------------
;
;		FlushPalette
;
;	>	a0	Palette
;	
;-------------------------------------------------------------------------

FlushPalette:	Lock	pal_semaphore(a0)
		bsr	PAL_DeleteP2Table
		Unlock	pal_semaphore(a0)
		rts

;=========================================================================


;=========================================================================
;-------------------------------------------------------------------------
;
;		ImportPalette
;
;		lädt eine Farbtabelle in eine Palette
;
;	>	a0	APTR	Palette
;		a1	APTR	Tabelle
;		d0	UWORD	Anzahl
;		a2	struct TagItem *taglist
;	<	d0	Anzahl farben in der Palette (inoffiziell!)
;
;	Tags:	RND_PaletteFormat	Default: PALFMT_RGB8
;		RND_EHBPalette		Default: FALSE
;		RND_FirstColor		Default: 0
;		
;-------------------------------------------------------------------------

ImportPalette:	movem.l	d2-d4/a0/a3/a4/a6,-(a7)

		move.l	a0,a3
		move.l	a1,a4
		move.w	d0,d3

		Lock		pal_semaphore(a3)

		move.l	a3,a0
 		bsr	PAL_DeleteP2Table

		; Tags ermitteln

		move.l	(utilitybase,pc),a6

		GetTag	#RND_NewPalette,#-1,a2		; neue Palette erzeugen?
		tst.l	d0
		beq.b	.nonew
		clr.w	(pal_numcolors,a3)
.nonew
		GetTag	#RND_FirstColor,#0,a2		; Index d. ersten Eintrags
		move.w	d0,d4

		GetTag	#RND_PaletteFormat,#PALFMT_RGB8,a2



		; prüfen, ob die Palette wächst

		move.w	d3,d1
		add.w	d4,d1
		move.w	(pal_numcolors,a3),d2
		cmp.w	d2,d1
		ble.b	.nogrow
		move.w	d1,(pal_numcolors,a3)		
.nogrow		

		; umwandeln

		subq.w	#1,d3
		lea	(pal_palette,a3,d4.w*4),a0		; Ziel

		cmp.w	#PALFMT_RGB8,d0
		beq.b	.rgb8
		cmp.w	#PALFMT_RGB32,d0
		beq.b	.rgb32
		cmp.w	#PALFMT_RGB4,d0
		beq.b	.rgb4
		cmp.w	#PALFMT_PALETTE,d0
		beq.b	.pal
		illegal

.rgb8		move.l	#$ffffff,d1
.rgb8lop	move.l	(a4)+,d0
		and.l	d1,d0
		move.l	d0,(a0)+
		dbf	d3,.rgb8lop
		bra.b	.ok

.rgb32		move.b	(a4),d0
		move.b	4(a4),d1
		moveq	#0,d2
		move.b	8(a4),d2
		bfins	d0,d2{8:8}
		bfins	d1,d2{16:8}
		move.l	d2,(a0)+
		add.w	#12,a4
		dbf	d3,.rgb32
		bra.b	.ok

.rgb4		moveq	#0,d1
		move.w	(a4)+,d0
		bfins	d0,d1{24:4}
	;	bfins	d0,d1{28:4}
		lsr.w	#4,d0
		bfins	d0,d1{16:4}
	;	bfins	d0,d1{20:4}
		lsr.w	#4,d0
		bfins	d0,d1{8:4}
	;	bfins	d0,d1{12:4}
		move.l	d1,(a0)+
		dbf	d3,.rgb4
		bra.b	.ok

.pal		lea	(pal_palette,a4),a4
.palop		move.l	(a4)+,(a0)+
		dbf	d3,.palop

.ok		; EHB-Palette importieren?

		move.w	(pal_numcolors,a3),d3

		GetTag	#RND_EHBPalette,#0,a2
		tst.w	d0
		beq.b	.noehb

		add.w	d3,(pal_numcolors,a3)		; Anzahl Farben verdoppeln
		lea	(pal_palette,a3),a0
		lea	(pal_palette+32*4,a3),a1

		move.l	#$7f7f7f,d1
		subq.w	#1,d3
.ehbloop	move.l	(a0)+,d0
		lsr.l	#1,d0
		and.l	d1,d0
		move.l	d0,(a1)+
		dbf	d3,.ehbloop

.noehb		; Wordpalette erzeugen

		lea	(pal_palette,a3),a0
		lea	(pal_wordpalette,a3),a1
		move.w	(pal_numcolors,a3),d0
		bsr	ConvertWordPalette


		Unlock		pal_semaphore(a3)

		movem.l	(a7)+,d2-d4/a0/a3/a4/a6

		moveq	#0,d0
		move.w	(pal_numcolors,a0),d0
		rts

;=========================================================================



;=========================================================================
;-------------------------------------------------------------------------
;
;		ExportPalette
;
;		exportiert eine Palette in eine Farbtabelle.
;
;	>	a0	APTR	Palette
;		a1	APTR	ZielTabelle
;		a2	struct TagItem * Taglist
;
;	Tags:	RND_PaletteFormat	Default: PALFMT_RGB8
;		RND_FirstColor		Default: 0
;		RND_NumColors		Default: alle
;		
;-------------------------------------------------------------------------

ExportPalette:	movem.l	d2-d6/a2-a4/a6,-(a7)

		move.l	a0,a3
		move.l	a1,a4

		LockShared	pal_semaphore(a3)

		move.l	(utilitybase,pc),a6

		move.w	(pal_numcolors,a3),d6

		GetTag	#RND_NumColors,d6,a2		; Anzahl Einträge
		move.w	d0,d3

		GetTag	#RND_FirstColor,#0,a2		; Index d. ersten Eintrags
		move.w	d0,d5

		GetTag	#RND_PaletteFormat,#PALFMT_RGB8,a2


		; umwandeln

		lea	(pal_palette,a3,d5.w*4),a0		; Quelle
		subq.w	#1,d3

		cmp.w	#PALFMT_RGB8,d0
		beq.b	.rgb8
		cmp.w	#PALFMT_RGB32,d0
		beq.b	.rgb32
		cmp.w	#PALFMT_RGB4,d0
		beq.b	.rgb4
		illegal

.rgb8		move.l	(a0)+,(a4)+
		dbf	d3,.rgb8
		bra.b	.ok

.rgb32		move.l	(a0)+,d4

		bfins	d4,d2{16:8}
		bfins	d4,d2{24:8}
		move.w	d2,d0
		swap	d2
		move.w	d0,d2

		lsr.w	#8,d4
		bfins	d4,d1{16:8}
		bfins	d4,d1{24:8}
		bfins	d1,d1{0:16}
		move.w	d1,d0
		swap	d1
		move.w	d0,d1

		swap	d4
		bfins	d4,d0{16:8}
		bfins	d4,d0{24:8}
		move.w	d0,d4
		swap	d0
		move.w	d4,d0

		move.l	d0,(a4)+
		move.l	d1,(a4)+
		move.l	d2,(a4)+
		dbf	d3,.rgb32
		bra.b	.ok

.rgb4		move.l	(a0)+,d0
		bfextu	d0{24:4},d1		; -> $000b
		lsl.l	#4,d0
		swap	d0			; -> $gbb00rrg
		bfins	d0,d1{24:4}		; -> $00gb
		lsr.l	#8,d0			; -> $00gbb00r
		bfins	d0,d1{20:4}		; -> $0rgb
		move.l	d1,(a4)+
		dbf	d3,.rgb4

.ok		Unlock		pal_semaphore(a3)

		movem.l	(a7)+,d2-d6/a2-a4/a6
		rts

;=========================================================================



;=========================================================================
;-------------------------------------------------------------------------
;
;		SortPalette
;
;		sortiert eine Palette
;
;	>	a0	APTR	Palette
;		d0	ULONG	Modus
;		a1	struct TagItem * Taglist
;	<	d0	BOOL	success
;
;	Tags:	RND_Histogram		Default: 0
;		
;-------------------------------------------------------------------------

SortPalette:	Lock	pal_semaphore(a0)

		movem.l	a0-a6/d1-d7,-(a7)


		moveq	#SORTP_NOT_ENOUGH_MEMORY,d7

		move.l	a0,a2
		move.l	a1,a3
		moveq	#PALMODE_SORTMASK,d2
		and.l	d0,d2


		;	Indextabelle anlegen

		move.l	(pal_memhandler,a2),a0
		move.l	#256*4*2,d0
		bsr	AllocRenderVecClear
		move.l	d0,a5
		tst.l	d0
		beq	.noindextab

		lea	(4*256,a5),a0
		move.l	#255,d6
.indxlop	move.l	d6,-(a0)
		dbf	d6,.indxlop
		



		move.l	(utilitybase,pc),a6
		GetTag	#RND_Histogram,#0,a3

		move.l	d0,a0			; histogramm
		move.l	a2,a1			; Palette



		tst.l	d0
		beq.b	.noh

		moveq	#SORTP_NOT_IMPLEMENTED,d7
		btst.b	#HSTYPEB_TURBO,(dhisto_type,a0)
		beq	.raus


.noh
		moveq	#SORTP_SUCCESS,d7

		moveq	#PALMODE_ASCENDING,d1
		and.w	d2,d1
		sne	d1
		and.w	#~PALMODE_ASCENDING,d2

		;   a0	histogram
		;   a1	Palette
		;   d1  Ascending?
		;   d2  Modus


		cmp.w	#PALMODE_NONE,d2
		beq	.raus

		lea	(SortPaletteB,pc),a2		
		cmp.w	#PALMODE_BRIGHTNESS,d2
		beq.b	.sort

		lea	(SortPaletteS,pc),a2
		cmp.w	#PALMODE_SATURATION,d2
		beq.b	.sort


		; für die folgenden Modi wird ein Histogramm benötigt:

		moveq	#SORTP_NO_DATA,d7
		move.l	a0,d0
		beq	.raus


		lea	(SortPaletteP3,pc),a2		
		cmp.w	#PALMODE_SIGNIFICANCE,d2
		beq.b	.sort

		lea	(SortPaletteP2,pc),a2
		cmp.w	#PALMODE_POPULARITY,d2
		beq.b	.sort

		lea	(SortPaletteP1,pc),a2
		cmp.w	#PALMODE_REPRESENTATION,d2
		bne.b	.raus

.sort		jsr	(a2)
		move.l	d0,d7


		cmp.l	#SORTP_SUCCESS,d7
		bne.b	.raus	; Fehler aufgetreten


		;	Umkehrung der indextable bilden

		move.l	a5,a2
		lea	4*256(a5),a3
		move.w	#0,d0
.lop		move.l	(a2)+,d1
		move.l	d0,(a3,d1.l*4)
		addq.w	#1,d0
		cmp.w	#256,d0
		bne.b	.lop


		;	p2table konvertieren. Die p2Table bleibt gültig!

		lea	(.swapfunc,pc),a0
		exg	a0,a1
		lea	4*256(a5),a2
		bsr	PAL_P2TableCallback
		exg	a0,a1


		;	Palette über Indextabelle konvertieren
		
		move.w	(pal_numcolors,a1),d0
		subq.w	#1,d0
		move.w	d0,d1
		lea	(pal_palette,a1),a0
		move.l	a0,a3
		lea	(4*256,a5),a2
.convlop	move.l	(a0)+,(a2)+		; in Buffer kopieren
		dbf	d0,.convlop

		lea	(4*256,a5),a0
		move.l	a5,a2
.convlop2	move.l	(a2)+,d0		; konvertieren
		move.l	(a0,d0.l*4),(a3)+	; über Indextab
		dbf	d1,.convlop2


		;	Maplist ungültig machen

		move.l	a1,a0
		bsr	InvalidateMapList


		;	Wordpalette erzeugen

		move.w	(pal_numcolors,a1),d0
		lea	(pal_palette,a1),a0
		lea	(pal_wordpalette,a1),a1
		bsr	ConvertWordPalette



.raus		move.l	a5,a0		; indextab freigeben
		bsr	FreeRenderVec

.noindextab	move.l	d7,d0
		movem.l	(a7)+,a0-a6/d1-d7

		Unlock	pal_semaphore(a0)
		rts

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

.swapfunc	move.w	(2,a5,d1.w*4),d1
		rts

;------------------------------------------------------------------------


;-------------------------------------------------------------------------
;
;		SortPaletteB
;		sortiert eine Palette nach Helligkeit
;
;	>	a1	Palette
;		a5	IndexTab
;		d1	BOOL	Aufsteigend (Ascending)
;	<	d0	BOOL	immer TRUE
;
;------------------------------------------------------------------------

SortPaletteB:	movem.l	d1-d4/d7/a0-a2/a5-a6,-(a7)

		move.w	(pal_numcolors,a1),d0
		move.w	d0,d7
		lsl.w	#2,d0
		sub.w	d0,a7
		move.l	a7,a6

		lea	(pal_palette,a1),a1

		move.l	a6,a0
		move.w	d7,d0
		subq.w	#1,d0
.brlop		move.l	(a1)+,d4
		bfextu	d4{16:8},d2
		moveq	#0,d3
		move.b	d4,d3
		add.w	d3,d2
		swap	d4
		move.b	d4,d3
		add.w	d3,d2
		move.l	d2,(a0)+
		dbf	d0,.brlop
		
		move.l	a6,a0		; Feld
		move.l	a5,a1		; Korrespondenzfeld
		moveq	#0,d0
		move.w	d7,d0

		lea	(SortDescending,pc),a2
		tst.w	d1
		beq.b	.sortok
		lea	(SortAscending,pc),a2
.sortok		jsr	(a2)

		lsl.w	#2,d7
		add.w	d7,a7
		
		moveq	#SORTP_SUCCESS,d0
		movem.l	(a7)+,d1-d4/d7/a0-a2/a5-a6
		rts

;------------------------------------------------------------------------


;-------------------------------------------------------------------------
;
;		SortPaletteS
;		sortiert eine Palette nach Farbsättigung
;
;	>	a1	Palette
;		a5	IndexTab
;		d0	Anzahl Farben in der Palette (max. 256)
;		d1	BOOL	Aufsteigend (Ascending)
;	<	d0	BOOL	immer TRUE
;
;------------------------------------------------------------------------

SortPaletteS:	movem.l	d1-d5/d7/a0-a2/a5-a6,-(a7)

		move.w	d1,d5

		move.w	(pal_numcolors,a1),d0
		move.w	d0,d7
		lsl.w	#2,d0
		sub.w	d0,a7
		move.l	a7,a6

		lea	(pal_palette,a1),a1

		move.l	a6,a0
		move.w	d7,d0
		subq.w	#1,d0
.brlop		move.l	(a1)+,d1
		bfextu	d1{8:8},d2
		bfextu	d1{16:8},d3
		bfextu	d1{24:8},d4
		moveq	#0,d1
		move.w	d2,d1
		add.w	d3,d1
		add.w	d4,d1
		divu.w	#3,d1
		sub.w	d1,d2
		sub.w	d1,d3
		sub.w	d1,d4
		muls.w	d2,d2
		muls.w	d3,d3
		muls.w	d4,d4
		add.l	d4,d3
		add.l	d3,d2
		move.l	d2,(a0)+
		dbf	d0,.brlop
		
		move.l	a6,a0		; Feld
		move.l	a5,a1		; Korrespondenzfeld
		moveq	#0,d0
		move.w	d7,d0

		lea	(SortDescending,pc),a2
		tst.w	d5
		beq.b	.sortok
		lea	(SortAscending,pc),a2
.sortok		jsr	(a2)

		lsl.w	#2,d7
		add.w	d7,a7
		
		moveq	#SORTP_SUCCESS,d0
		movem.l	(a7)+,d1-d5/d7/a0-a2/a5-a6
		rts

;------------------------------------------------------------------------



;-------------------------------------------------------------------------
;
;		SortPaletteP1
;		sortiert eine Palette nach Häufigkeit
;		der zugewiesenen Histogramm-Einträge. (Representation)
;
;	>	a0		Histogramm
;		a1		Palette
;		a5		IndexTab
;		d1	BOOL	Aufsteigend (Ascending)
;	<	d0		SORTP_...
;
;------------------------------------------------------------------------

	STRUCTURE	spp1_localdata,0
		STRUCT	spp1_table,256*4	; Zähltabelle
		APTR	spp1_indextab
	LABEL		spp1_SIZEOF

;------------------------------------------------------------------------

SortPaletteP1:
		Lock	dhisto_semaphore(a0)

		movem.l	d1-d7/a0-a6,-(a7)

		move.l	a5,a3		; indextab
		move.w	d1,d6		; ascending
		move.l	a0,a4		; histo
		move.l	a1,a6		; palette

		moveq	#SORTP_NOT_ENOUGH_MEMORY,d7

		move.l	(dhisto_memhandler,a4),a0
		move.l	#spp1_SIZEOF,d0
		bsr	AllocRenderVecClear
		move.l	d0,a5				; Struktur
		tst.l	d0
		beq.b	.raus

		move.l	a3,(spp1_indextab,a5)

		move.l	a4,a0
		move.l	a6,a1
		lea	(.countfunc,pc),a2
		move.l	a5,a3
		bsr	PAL_CreateHistoP2Table
		tst.l	d0
		beq.b	.raus


		;	sortieren:

		lea	(spp1_table,a5),a0
		move.l	(spp1_indextab,a5),a1
		moveq	#0,d0
		move.w	(pal_numcolors,a6),d0

		lea	(SortDescending,pc),a2
		tst.w	d6
		beq.b	.sortok
		lea	(SortAscending,pc),a2
.sortok		jsr	(a2)

		moveq	#SORTP_SUCCESS,d7

.raus		move.l	a5,a0
		bsr	FreeRenderVec

		move.l	d7,d0

		movem.l	(a7)+,d1-d7/a0-a6
		Unlock	dhisto_semaphore(a0)
		rts		

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;		newbestpen = Callback(RGB,anzahl,bestpen,data)
;		d2	              d0  d1     d2      a5

.countfunc	addq.l	#1,(spp1_table,a5,d2.w*4)
		rts

;------------------------------------------------------------------------




;-------------------------------------------------------------------------
;
;		SortPaletteP2
;		sortiert eine Palette nach Häufigkeit
;		der zugehörigen Pixel (Popularität)
;
;	>	a0		Histogramm
;		a1		Palette
;		a5		IndexTab
;		d1	BOOL	Aufsteigend (Ascending)
;	<	d0		SORTP_...
;
;------------------------------------------------------------------------

SortPaletteP2:
		Lock	dhisto_semaphore(a0)

		movem.l	d1-d7/a0-a6,-(a7)

		move.l	a5,a3		; indextab
		move.w	d1,d6		; ascending
		move.l	a0,a4		; histo
		move.l	a1,a6		; palette

		moveq	#SORTP_NOT_ENOUGH_MEMORY,d7

		move.l	(dhisto_memhandler,a4),a0
		move.l	#spp1_SIZEOF,d0
		bsr	AllocRenderVecClear
		move.l	d0,a5				; Struktur
		tst.l	d0
		beq.b	.raus

		move.l	a3,(spp1_indextab,a5)

		move.l	a4,a0
		move.l	a6,a1
		lea	(.countfunc,pc),a2
		move.l	a5,a3
		bsr	PAL_CreateHistoP2Table
		tst.l	d0
		beq.b	.raus


		;	sortieren:

		lea	(spp1_table,a5),a0
		move.l	(spp1_indextab,a5),a1
		moveq	#0,d0
		move.w	(pal_numcolors,a6),d0

		lea	(SortDescending,pc),a2
		tst.w	d6
		beq.b	.sortok
		lea	(SortAscending,pc),a2
.sortok		jsr	(a2)

		moveq	#SORTP_SUCCESS,d7

.raus		move.l	a5,a0
		bsr	FreeRenderVec

		move.l	d7,d0

		movem.l	(a7)+,d1-d7/a0-a6
		Unlock	dhisto_semaphore(a0)
		rts		

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;		newbestpen = Callback(RGB,anzahl,bestpen,data)
;		d2	              d0  d1     d2      a5

.countfunc	add.l	d1,(spp1_table,a5,d2.w*4)
		rts

;------------------------------------------------------------------------



;-------------------------------------------------------------------------
;
;		SortPaletteP3
;		sortiert eine Palette nach optischer
;		Signifikanz
;
;	>	a0		Histogramm
;		a1		Palette
;		a5		IndexTab
;		d1	BOOL	Aufsteigend (Ascending)
;	<	d0		SORTP_...
;
;------------------------------------------------------------------------

	STRUCTURE	spp3_localdata,0
		STRUCT	spp3_table1,256*4	; Zähltabelle1
		STRUCT	spp3_table2,256*4	; Zähltabelle2
		APTR	spp3_indextab
	LABEL		spp3_SIZEOF

;------------------------------------------------------------------------

SortPaletteP3:
		Lock	dhisto_semaphore(a0)

		movem.l	d1-d7/a0-a6,-(a7)
	IFNE	USEFPU
		fmovem.x	fp0/fp1,-(a7)
	ENDC

		move.l	a5,a3		; indextab
		move.w	d1,d6		; ascending
		move.l	a0,a4		; histo
		move.l	a1,a6		; palette

		moveq	#SORTP_NOT_ENOUGH_MEMORY,d7

		move.l	(dhisto_memhandler,a4),a0
		move.l	#spp3_SIZEOF,d0
		bsr	AllocRenderVecClear
		move.l	d0,a5				; Struktur
		tst.l	d0
		beq	.raus

		move.l	a3,(spp3_indextab,a5)

		move.l	a4,a0
		move.l	a6,a1
		lea	(.countfunc,pc),a2
		move.l	a5,a3
		bsr	PAL_CreateHistoP2Table
		tst.l	d0
		beq	.raus


		;	ausmultiplizieren gemäß
		;	historepresentation * popularity * saturation * helligkeit

		lea	(spp3_table1,a5),a0		; Anzahl Zuweisungen
		lea	(spp3_table2,a5),a1		; Anzahl Pixel
		lea	(pal_wordpalette,a6),a2
		move.w	(pal_numcolors,a6),d7
		subq.w	#1,d7

.mullop		movem.w	(a2)+,d0-d2		; Farbsättigung berechnen:
		moveq	#0,d3
		move.w	d0,d3
		add.w	d1,d3
		add.w	d2,d3
		divu.w	#3,d3			; Helligkeit
		ext.l	d3

		sub.w	d3,d0
		sub.w	d3,d1
		sub.w	d3,d2
		muls.w	d2,d1
		muls.w	d1,d0
		bpl.b	.ok1
		neg.l	d0
.ok1
	;	muls.w	d0,d0
	;	muls.w	d1,d1
	;	muls.w	d2,d2
	;	add.l	d2,d0
	;	add.l	d1,d0			; Farbsättigungsfaktor			

	IFNE    USEFPU
		fmove.l	d0,fp0
		fsqrt.x	fp0
		fmul.l	(a1)+,fp0
		fmove.l	fp0,d0
	ELSE
		SQRT
		moveq	#0,d1
		mulu.l	(a1)+,d1:d0
		divu.l	#442,d1:d0
	ENDC
		move.l	d0,(a0)+
		dbf	d7,.mullop


		;	sortieren:

		lea	(spp3_table1,a5),a0
		move.l	(spp3_indextab,a5),a1
		moveq	#0,d0
		move.w	(pal_numcolors,a6),d0

		lea	(SortDescending,pc),a2
		tst.w	d6
		beq.b	.sortok
		lea	(SortAscending,pc),a2
.sortok		jsr	(a2)

		moveq	#SORTP_SUCCESS,d7

.raus		move.l	a5,a0
		bsr	FreeRenderVec

		move.l	d7,d0

	IFNE    USEFPU
		fmovem.x	(a7)+,fp0/fp1
	ENDC
		movem.l	(a7)+,d1-d7/a0-a6
		Unlock	dhisto_semaphore(a0)
		rts		

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;		newbestpen = Callback(RGB,anzahl,bestpen,data)
;		d2	              d0  d1     d2      a5

.countfunc	addq.l	#1,(spp3_table1,a5,d2.w*4)
		add.l	d1,(spp3_table2,a5,d2.w*4)

		rts

;------------------------------------------------------------------------



;-------------------------------------------------------------------------
;
;		SortDescending
;		sortiert ein Langwortfeld, absteigend,
;		mit Korrespondenzfeld, ebenfalls Langwort
;
;	>	a0	Feld
;		a1	korrespondierendes Feld
;		d0	Anzahl Elemente
;
;-------------------------------------------------------------------------

SortDescending:	movem.l	a0-a2/d0-d4,-(a7)

		move.l	a1,d4
		sub.l	a0,d4			; Distanz zu korr. Feld

		pea	-4(a0,d0.l*4)		; letzte Adresse
		move.l	a0,-(a7)		; erste Adresse
		move.l	a7,d1			; Stackptr merken

.sod1		move.l	(a7)+,d2		; Feldgrenzen holen
		move.l	(a7)+,a0

.sod2		move.l	d2,a2
		move.l	a0,a1

		move.l	d2,d0			; Feldmitte:
		sub.l	a0,d0			; Differenz in Bytes...
		asr.l	#3,d0			; ...in Langworten / 2
		move.l	(a0,d0.l*4),d3		; Feldelement holen

.sod3		cmp.l	(a2)+,d3		; von unten rantasten
		blt.b	.sod3			; absteigend: blt

		subq.w	#4,a2
		addq.w	#4,a1

.sod4		cmp.l	-(a1),d3		; von oben rantasten
		bgt.b	.sod4			; absteigend: bgt

		cmp.l	a1,a2
		bgt.b	.sod6

		move.l	(a1,d4.l),d0		; Dreieckstausch im
		move.l	(a2,d4.l),(a1,d4.l)	; korrespondierenden
		move.l	d0,(a2,d4.l)		; Feld

		move.l	(a1),d0			; Dreieckstausch im
		move.l	(a2),(a1)		; zu sortierenden
		move.l	d0,(a2)+		; Feld
		subq.w	#4,a1

		cmp.l	a1,a2
		ble.b	.sod3

.sod6		cmp.l	a0,a2
		bge.b	.sod5

		move.l	a0,-(a7)		; neue Feldunterteilung
		move.l	a2,-(a7)

.sod5		move.l	a1,a0
		cmp.l	a0,d2
		blt.b	.sod2
		
		cmp.l	d1,a7			; Rekursion beendet?
		ble.b	.sod1			; nein, weiter

		movem.l	(a7)+,a0-a2/d0-d4
		rts

;-------------------------------------------------------------------------


;-------------------------------------------------------------------------
;
;		SortAscending
;		sortiert ein Langwortfeld, aufsteigend,
;		mit Korrespondenzfeld, ebenfalls Langwort
;
;	>	a0	Feld
;		a1	korrespondierendes Feld
;		d0	Anzahl Elemente
;
;-------------------------------------------------------------------------

SortAscending:	movem.l	a0-a2/d0-d4,-(a7)

		move.l	a1,d4
		sub.l	a0,d4			; Distanz zu korr. Feld

		pea	-4(a0,d0.l*4)		; letzte Adresse
		move.l	a0,-(a7)		; erste Adresse
		move.l	a7,d1			; Stackptr merken

.soa1		move.l	(a7)+,d2		; Feldgrenzen holen
		move.l	(a7)+,a0

.soa2		move.l	d2,a2
		move.l	a0,a1

		move.l	d2,d0			; Feldmitte:
		sub.l	a0,d0			; Differenz in Bytes...
		asr.l	#3,d0			; ...in Langworten / 2
		move.l	(a0,d0.l*4),d3		; Feldelement holen

.soa3		cmp.l	(a2)+,d3		; von unten rantasten
		bgt.b	.soa3			; absteigend: blt

		subq.w	#4,a2
		addq.w	#4,a1

.soa4		cmp.l	-(a1),d3		; von oben rantasten
		blt.b	.soa4			; absteigend: bgt

		cmp.l	a1,a2
		bgt.b	.soa6

		move.l	(a1,d4.l),d0		; Dreieckstausch im
		move.l	(a2,d4.l),(a1,d4.l)	; korrespondierenden
		move.l	d0,(a2,d4.l)		; Feld

		move.l	(a1),d0			; Dreieckstausch im
		move.l	(a2),(a1)		; zu sortierenden
		move.l	d0,(a2)+		; Feld
		subq.w	#4,a1

		cmp.l	a1,a2
		ble.b	.soa3

.soa6		cmp.l	a0,a2
		bge.b	.soa5

		move.l	a0,-(a7)		; neue Feldunterteilung
		move.l	a2,-(a7)

.soa5		move.l	a1,a0
		cmp.l	a0,d2
		blt.b	.soa2
		
		cmp.l	d1,a7			; Rekursion beendet?
		ble.b	.soa1			; nein, weiter

		movem.l	(a7)+,a0-a2/d0-d4
		rts

;------------------------------------------------------------------------
;
;		ConvertWordPalette
;
;		Konvertiert eine Langwort-Palette
;		in eine Palette aus Wort-Tripletts
;
;	>	a0	Palette
;		a1	Wordpalette
;		d0.w	Anzahl Farben
;
;-------------------------------------------------------------------------

ConvertWordPalette:
		movem.l	a0/a1/d0/d1,-(a7)

		subq.w	#1,d0
cowp_preppalop	move.w	(a0)+,(a1)+
		moveq	#0,d1
		move.b	(a0)+,d1
		move.w	d1,(a1)+
		move.b	(a0)+,d1
		move.w	d1,(a1)+
		dbf	d0,cowp_preppalop
		
		movem.l	(a7)+,a0/a1/d0/d1
		rts

;-------------------------------------------------------------------------


	IFNE	0

;-------------------------------------------------------------------------
;
;		PAL_CreateFullP2Table
;
;		berechnet die p2table für den gesamten Farbraum
;
;	>	a0	APTR	Palette
;	<	d0	BOOL	success
;
;-------------------------------------------------------------------------

PAL_CreateFullP2Table:

		Lock	pal_semaphore(a0)

		movem.l	d1-d7/a0-a6,-(a7)

		moveq	#0,d7

		move.l	a0,a6

		cmp.w	#2,(pal_numcolors,a6)	; weniger als 2 Farben?
		blt.b	.raus

		bsr	PAL_CreateP2Table
		tst.l	d0
		beq.b	.raus
		move.l	d0,a4			; p2tab

		move.w	(pal_bitspergun,a0),d0	; bits per gun

		lea	(.loopfunc,pc),a0	; Funktion

		TABLEEXECUTE
		
		moveq	#-1,d7

.raus		move.l	d7,d0
		movem.l	(a7)+,d1-d7/a0-a6

		Unlock	pal_semaphore(a0)
		rts

.loopfunc	move.w	(a4),d7
		bpl.b	.skip

		movem.l	d0-d5,-(a7)
		lea	(pal_wordpalette,a6),a2
		move.w	(pal_numcolors,a6),d4
	IFEQ	CPU60
		lea	(quadtab,pc),a3
	ENDC
		FINDPEN_PALETTE			; trash: d1-d7/a2/[a3]¹
		move.w	d0,d7
		movem.l	(a7)+,d0-d5

		move.w	d7,(a4)+		; in p2tab updaten
		rts

.skip		addq.w	#2,a4
		rts

;-------------------------------------------------------------------------

	ENDC

;-------------------------------------------------------------------------
;
;		PAL_CreateHistoP2Table
;
;		berechnet die p2table für alle Einträge im Histogramm
;		und ruft für jeden Eintrag im Histogramm einen Callback
;		auf
;
;	>	a0	APTR	Histogramm
;		a1	APTR	Palette
;		a2	APTR	Callbackfunktion oder NULL
;		a3	APTR	Callbackdaten
;	<	d0	BOOL	success
;
;		Konventionen für den Callback:
;
;		newbestpen = Callback(RGB,anzahl,bestpen,data)
;		d2	              d0  d1     d2      a5
;
;		es müssen keine Register gerettet werden
;
;-------------------------------------------------------------------------

	STRUCTURE	chpt_localdata,0
		ULONG	chpt_entries
		ULONG	chpt_andmask
		ULONG	chpt_ormask
		UWORD	chpt_bitspergun
		UWORD	chpt_numcolors
		APTR	chpt_wordpalette
		APTR	chpt_histo
		APTR	chpt_p2table
		APTR	chpt_callback
		APTR	chpt_callbackdata
	LABEL		chpt_SIZEOF
	
;-------------------------------------------------------------------------

PAL_CreateHistoP2Table:

		Lock	pal_semaphore(a1)
		Lock	dhisto_semaphore(a0)

		movem.l	d1-d7/a0-a6,-(a7)
		sub.w	#chpt_SIZEOF,a7
		move.l	a7,a5

		moveq	#0,d7

		move.l	a2,(chpt_callback,a5)
		move.l	a3,(chpt_callbackdata,a5)
		move.l	a0,(chpt_histo,a5)

		move.l	a1,a0
		bsr	PAL_CreateP2Table
		tst.l	d0
		beq	.raus
		move.l	d0,(chpt_p2table,a5)

		move.w	(pal_numcolors,a1),(chpt_numcolors,a5)
		add.w	#pal_wordpalette,a1
		move.l	a1,(chpt_wordpalette,a5)

		move.l	(chpt_histo,a5),a0

		move.l	(dhisto_andmask,a0),(chpt_andmask,a5)

		moveq	#15,d0
		and.b	(dhisto_type,a0),d0		; Bitspergun
		move.w	d0,(chpt_bitspergun,a5)

		bsr.w	CountHistogram
		tst.l	d0
		beq	.raus
		move.l	d0,(chpt_entries,a5)

		lea	(quadtab,pc),a3
		move.l	(chpt_p2table,a5),a6

		btst.b	#HSTYPEB_TURBO,(dhisto_type,a0)
		beq	.tree

		; - - - - - - - - - - - - - - - - - - 

		bsr	MakeTableHistogram
		tst.l	d0
		beq	.raus
		move.l	d0,a4

.tabloop	move.l	#$ffffff,d4

		and.l	(a4)+,d4			; RGB

		moveq	#8,d3
		move.w	(chpt_bitspergun,a5),d2
		sub.w	d2,d3

		move.l	d4,d6
		move.l	d4,d7
		lsr.l	d3,d7
		lsl.b	d3,d7
		lsl.w	d3,d7
		add.w	d3,d3
		lsr.l	d3,d7				; p2-TabellenOffset
		move.w	(a6,d7.l*2),d0
		bpl.b	.oki

		move.l	(chpt_andmask,a5),d3		; $f0f0f0
		move.l	d4,d0				; interpolieren
		and.l	d3,d4
		lsr.l	d2,d0
		not.l	d3
		and.l	d3,d0
		or.l	d4,d0

		movem.l	d6/d7,-(a7)
		move.l	(chpt_wordpalette,a5),a2
		move.w	(chpt_numcolors,a5),d4
		FINDPEN_PALETTE				; trash: d1-d7/a2/[a3]¹

		movem.l	(a7)+,d6/d7
		move.w	d0,(a6,d7.l*2)

.oki		move.l	(chpt_callback,a5),d3
		beq.b	.nocb

		;	newbestpen = Callback(RGB,anzahl,bestpen,data)
		;	d2	              d0  d1     d2      a5

		move.w	d0,d2		; bestpen
		move.l	(a4),d1		; Anzahl
		move.l	d6,d0		; RGB
		movem.l	a4-a6/d7,-(a7)
		move.l	(chpt_callbackdata,a5),a5
		jsr	(d3.l)
		movem.l	(a7)+,a4-a6/d7
		move.w	d2,(a6,d7.l*2)
		lea	(quadtab,pc),a3

.nocb		addq.l	#4,a4

		subq.l	#1,(chpt_entries,a5)
		bne	.tabloop
		bra	.cont

		; - - - - - - - - - - - - - - - - - - 

.tree		move.l	(dhisto_tree,a0),a0
		add.w	#treeAnchor_SIZEOF,a0
		bsr.b	.recurse
		bra	.cont

.recurse	move.l	#$ffffff,d4

		and.l	(a0),d4			; RGB

		moveq	#8,d3
		move.w	(chpt_bitspergun,a5),d2
		sub.w	d2,d3

		move.l	d4,d7
		move.l	d4,d6
		lsr.l	d3,d7
		lsl.b	d3,d7
		lsl.w	d3,d7
		add.w	d3,d3
		lsr.l	d3,d7				; p2-TabellenOffset
		move.w	(a6,d7.l*2),d0
		bpl.b	.oki2

		move.l	(chpt_andmask,a5),d3		; $f0f0f0
		move.l	d4,d0				; interpolieren
		and.l	d3,d4
		lsr.l	d2,d0
		not.l	d3
		and.l	d3,d0
		or.l	d4,d0

		movem.l	d6/d7,-(a7)

		move.l	(chpt_wordpalette,a5),a2
		move.w	(chpt_numcolors,a5),d4
		FINDPEN_PALETTE				; trash: d1-d7/a2/[a3]¹

		movem.l	(a7)+,d6/d7
		move.w	d0,(a6,d7.l*2)

.oki2		move.l	(chpt_callback,a5),d3
		beq.b	.nocb2

		;	newbestpen = Callback(RGB,anzahl,bestpen)
		;	d2	              d0  d1     d2

		move.w	d0,d2			; bestpen
		move.l	4(a0),d1		; Anzahl
		move.l	d6,d0			; RGB
		movem.l	a0/a4-a6/d7,-(a7)
		move.l	(chpt_callbackdata,a5),a5
		jsr	(d3.l)
		movem.l	(a7)+,a0/a4-a6/d7
		move.w	d2,(a6,d7.l*2)
		lea	(quadtab,pc),a3

.nocb2		addq.l	#4,a4


		move.l	(rNode_left,a0),d1
		beq.b	.noleft

		move.l	a0,-(a7)
		move.l	d1,a0
		bsr	.recurse
		move.l	(a7)+,a0

.noleft		move.l	(rNode_right,a0),d1
		beq.b	.noright

		move.l	d1,a0
		bsr	.recurse

.noright	rts

		; - - - - - - - - - - - - - - - - - - 

.cont		moveq	#-1,d7

.raus		move.l	d7,d0
		add.w	#chpt_SIZEOF,a7
		movem.l	(a7)+,d1-d7/a0-a6

		Lock	dhisto_semaphore(a0)
		Lock	pal_semaphore(a1)
		rts

;-------------------------------------------------------------------------


;-------------------------------------------------------------------------
;
;		PAL_P2TableCallback
;
;		ruft für jeden gültigen Eintrag der p2Table
;		einer Palette einen Callback auf
;
;	>	a0	APTR	Palette
;		a1	APTR	Callbackfunktion oder NULL
;		a2	APTR	Callbackdaten
;	<	d0	BOOL	success
;
;		Konventionen für den Callback:
;
;		newbestpen = Callback(RGB,bestpen,data)
;		d1	              d0  d1      a5
;
;		es müssen keine Register gerettet werden
;
;-------------------------------------------------------------------------

PAL_P2TableCallback:

		movem.l	d1-d7/a0-a6,-(a7)

		move.l	a2,a3
		move.l	a0,a2

		Lock	pal_semaphore(a2)
		
		moveq	#0,d7
		
		bsr	PAL_AttemptP2Table
		tst.l	d0
		beq.b	.fail
		move.l	d0,a6		; p2table


		subq.w	#8,a7
		move.l	a7,a5
		move.l	a1,(a5)		; Funktion
		move.l	a3,(4,a5)	; Daten

		move.w	(pal_bitspergun,a2),d0
		lea	(.func,pc),a0

		TABLEEXECUTE

		moveq	#-1,d7
		addq.w	#8,a7

.fail		Unlock	pal_semaphore(a2)

		move.l	d7,d0
		movem.l	(a7)+,d1-d7/a0-a6
		rts


.func		movem.l	d0-d5/a0/a5,-(a7)

		move.w	(a6),d1		; bestpen
		bmi.b	.skip

		move.l	(a5),a0
		move.l	(4,a5),a5
		jsr	(a0)

.skip		move.w	d1,(a6)+

		movem.l	(a7)+,d0-d5/a0/a5
		rts

;-------------------------------------------------------------------------


;=========================================================================
;-------------------------------------------------------------------------
;
;		GetPaletteAttrs
;
;	>	a0	APTR	Palette
;		d0	ULONG	identifier
;	<	d0	ULONG	anzahl Farben
;		
;-------------------------------------------------------------------------

GetPaletteAttrs:
		moveq	#0,d0
		move.w	(pal_numcolors,a0),d0
		rts

;=========================================================================

	ENDC

