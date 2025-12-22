
	IFND	INTERFACE_I
INTERFACE_I		SET	1

;*************************************************************************
;-------------------------------------------------------------------------
;
;		SECOND LEVEL INTERFACE
;		mainly obsolete
;
;-------------------------------------------------------------------------
;*************************************************************************



;=========================================================================
;-------------------------------------------------------------------------
;
;		_CreateRenderMemHandler
;
;		legt einen Rendermemhandler an.
;
;		Tag				Default
;		----------------------------------------------------	
;		RMHND_MemType,<type>		RMHTYPE_PUBLIC
;		RMHND_MemSize,<größe>		-
;		RMHND_MemBlock,<mem>		-
;		RND_MemFlags,MEMF_...
;
;	>	a1	taglist	
;	<	d0	memhandler oder NULL
;
;-------------------------------------------------------------------------

_CreateRenderMemHandler:

		movem.l	a4-a6/d2/d4-d7,-(a7)

		move.l	(utilitybase,pc),a6
		move.l	a1,a4

		moveq	#0,d6
		moveq	#0,d7

		GetTag	#RND_MemFlags,#MEMF_ANY,a4
		move.l	d0,d4

		GetTag	#RND_MemType,#RMHTYPE_PUBLIC,a4
		move.l	d0,d5
		cmp.l	#RMHTYPE_PRIVATE,d5
		bne.b	.typeok

		GetTag	#RND_MemBlock,#0,a4
		move.l	d0,d6
		beq.b	.error

		GetTag	#RND_MemSize,#0,a4
		move.l	d0,d7
		beq.b	.error

.typeok
		move.l	d4,d2
		move.l	d5,d1
		move.l	d6,a0
		move.l	d7,d0
		bsr	CreateRenderMemHandler

.error
		movem.l	(a7)+,a4-a6/d2/d4-d7
		rts

;=========================================================================


;=========================================================================
;-------------------------------------------------------------------------
;
;		_AddRGBImage
;
;		Tag				Beschreibung
;		--------------------------------------------------------
;		TOTALWIDTH_SOURCE,<width>	Gesamtbreite Inputdaten
;		HOOKFUNC_PROGRESS,<hook>	Callback
;
;	>	a0	Histogramm
;		a1	RGB
;		d0	width
;		d1	height
;		a2	taglist
;	<	d0	success
;
;-------------------------------------------------------------------------

_AddRGBImage:
		movem.l	d2-d7/a2-a6,-(a7)
		sub.w	#prm_SIZEOF,a7
		move.l	a7,a5
		move.l	(utilitybase,pc),a6

		move.l	a0,a4
		move.l	a0,(prm_a0,a5)
		move.l	a1,(prm_a1,a5)
		move.l	d0,(prm_d0,a5)
		move.l	d1,(prm_d1,a5)

		GetTag	#RND_SourceWidth,prm_d0(a5),a2
		move.l	d0,(prm_d2,a5)

		GetTag	#RND_ProgressHook,#0,a2
		move.l	d0,(prm_a2,a5)


		movem.l	(prm_a0,a5),a0-a2
		movem.l	(prm_d0,a5),d0-d2

		bsr	AddRGBImage

		add.w	#prm_SIZEOF,a7
		movem.l	(a7)+,d2-d7/a2-a6
		rts

;=========================================================================


;=========================================================================
;-------------------------------------------------------------------------
;
;		_Chunky2BitMap
;
;		Tag
;		---------------------------------
;		TotalSourceWidth,<breite>
;		ConversionTable,<tab>
;
;	>	a0	Chunky
;		d0	sourcex
;		d1	sourcey
;		d2	width
;		d3	height
;		a1	bitmap
;		d4	destx
;		d5	desty
;		a2	TagList
;
;-------------------------------------------------------------------------

_Chunky2BitMap:
		movem.l	d2-d7/a2-a6,-(a7)
		sub.w	#prm_SIZEOF,a7
		move.l	a7,a5
		move.l	(utilitybase,pc),a6

		
		move.l	a0,(prm_a0,a5)
		move.l	a1,(prm_a1,a5)
		move.l	d0,(prm_d1,a5)
		move.l	d1,(prm_d2,a5)
		move.l	d2,(prm_d3,a5)
		move.l	d3,(prm_d4,a5)
		move.l	d4,(prm_d5,a5)
		move.l	d5,(prm_d6,a5)

		GetTag	#RND_SourceWidth,d2,a2
		move.l	d0,(prm_d0,a5)
		
		GetTag	#RND_PenTable,#0,a2
		move.l	d0,(prm_a2,a5)

		movem.l	(prm_a0,a5),a0-a2
		movem.l	(prm_d0,a5),d0-d6

		bsr.l	Chunky2Bitmap

		add.w	#prm_SIZEOF,a7
		movem.l	(a7)+,d2-d7/a2-a6
		rts

;=========================================================================


;=========================================================================
;-------------------------------------------------------------------------
;
;		_CreateConversionTable
;
;		Tag
;		---------------------------------
;		TotalSourceWidth,<breite>
;		ConversionTable,<tab>
;
;	>	a0	Chunky Source
;		a1	oldPalette
;		d0	width
;		d1	height
;		a2	newPalette
;	[	d2	numcolors	]
;		a3	dest conversionTable
;		a4	taglist
;
;-------------------------------------------------------------------------

_CreateConversionTable:

		movem.l	d2-d7/a2-a6,-(a7)
		sub.w	#prm_SIZEOF,a7
		move.l	a7,a5
		move.l	(utilitybase,pc),a6
		
		move.l	a0,(prm_a0,a5)
		move.l	a1,(prm_a1,a5)
		move.l	a2,(prm_a2,a5)
		move.l	a3,(prm_a4,a5)
		move.l	d0,(prm_d0,a5)
		move.l	d1,(prm_d1,a5)
	;	move.l	d2,(prm_d3,a5)

		GetTag	#RND_SourceWidth,prm_d0(a5),a4
		move.l	d0,(prm_d2,a5)

		GetTag	#RND_PenTable,#0,a4
		move.l	d0,(prm_a3,a5)

		movem.l	(prm_a0,a5),a0-a4
		movem.l	(prm_d0,a5),d0-d2	;!

		bsr	CreateChunkyConversionTable

		add.w	#prm_SIZEOF,a7
		movem.l	(a7)+,d2-d7/a2-a6
		rts

;=========================================================================




;=========================================================================
;-------------------------------------------------------------------------
;
;		_Planar2Chunky
;
;		Tag
;		---------------------------------
;		RND_DestWidth
;
;	>	a0	PLANEPTR *	Planeptr-Tabelle
;		d0	UWORD		Bytewidth (gerade)
;		d1	UWORD		Höhe
;		d2	UWORD		Depth
;		d3	UWORD		TotalBytesPerRow
;		a1	UBYTE *		Chunky-Dest
;		a2			Taglist
;
;-------------------------------------------------------------------------

_Planar2Chunky:	movem.l	d6-d7/a4-a6,-(a7)
		sub.w	#prm_SIZEOF,a7
		move.l	a7,a5
		move.l	(utilitybase,pc),a6

		move.l	a0,(prm_a0,a5)
		move.l	a1,(prm_a1,a5)
		movem.l	d0-d3,(prm_d0,a5)

		move.l	(prm_d0,a5),d6
		lsl.w	#3,d6
		GetTag	#RND_DestWidth,d6,a2
		move.l	d0,(prm_d4,a5)

		movem.l	(prm_a0,a5),a0-a1
		movem.l	(prm_d0,a5),d0-d4

		bsr	Planar2Chunky

		add.w	#prm_SIZEOF,a7
		movem.l	(a7)+,d6-d7/a4-a6
		rts

;=========================================================================


	IFNE	0

//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////

;=========================================================================
;-------------------------------------------------------------------------
;
;		_ConvertChunkyImage
;
;		Tag
;		---------------------------------
;		TotalSourceWidth,<breite>
;		TotalDestWidth,<breite>
;		ConversionTable,<tab>
;
;	>	a0	Chunky Source
;		a1	sourcePalette
;		d0	Width
;		d1	Height
;		a2	Chunky Dest
;		a3	destPalette
;	[	d2	NumColors DestPalette	]
;		a4	TagList
;
;-------------------------------------------------------------------------

_ConvertChunkyImage:

		movem.l	d2-d7/a2-a6,-(a7)
		sub.w	#prm_SIZEOF,a7
		move.l	a7,a5
		move.l	(utilitybase,pc),a6

		
		move.l	a0,(prm_a0,a5)
		move.l	a1,(prm_a2,a5)
		move.l	a2,(prm_a1,a5)
		move.l	a3,(prm_a3,a5)
		move.l	d0,(prm_d0,a5)
		move.l	d1,(prm_d1,a5)
	;!	move.l	d2,(prm_d4,a5)

		GetTag	#RND_SourceWidth,prm_d0(a5),a4
		move.l	d0,(prm_d2,a5)

		GetTag	#RND_DestWidth,prm_d0(a5),a4
		move.l	d0,(prm_d3,a5)

		GetTag	#RND_PenTable,#0,a4
		move.l	d0,(prm_a4,a5)

		movem.l	(prm_a0,a5),a0-a4
		movem.l	(prm_d0,a5),d0-d3	;!

		bsr	ConvertChunkyImage


		add.w	#prm_SIZEOF,a7
		movem.l	(a7)+,d2-d7/a2-a6
		rts


;=========================================================================
	
;=========================================================================
;-------------------------------------------------------------------------
;
;		_CreateScaleEngine
;
;		Tag
;		---------------------------------
;		RenderMemHandler
;
;	>	d0	SourceWidth
;		d1	SourceHeight
;		d2	DestWidth
;		d3	DestHeight
;		a1	taglist
;
;-------------------------------------------------------------------------

_CreateScaleEngine:

		movem.l	a4-a6,-(a7)
		sub.w	#prm_SIZEOF,a7
		move.l	a7,a5
		move.l	(utilitybase,pc),a6
		
		move.l	a1,a4

		move.l	d0,(prm_d0,a5)
		move.l	d1,(prm_d1,a5)
		move.l	d2,(prm_d2,a5)
		move.l	d3,(prm_d3,a5)

		GetTag	#RND_RMHandler,#0,a4
		move.l	d0,(prm_a0,a5)


		move.l	(prm_a0,a5),a0
		movem.l	(prm_d0,a5),d0-d3

		bsr	CreateScaleEngine8

		add.w	#prm_SIZEOF,a7
		movem.l	(a7)+,a4-a6
		rts

;=========================================================================


;=========================================================================
;-------------------------------------------------------------------------
;
;		_Scale
;
;		Tag
;		---------------------------------
;		RND_SourceWidth
;		RND_DestWidth
;
;	>	a0	engine
;		a1	source
;		a2	dest
;		a3	taglist
;
;-------------------------------------------------------------------------

_Scale:		movem.l	d6-d7/a4-a6,-(a7)
		sub.w	#prm_SIZEOF,a7
		move.l	a7,a5
		move.l	(utilitybase,pc),a6

		move.l	a0,(prm_a0,a5)
		move.l	a1,(prm_a1,a5)
		move.l	a2,(prm_a2,a5)

		move.w	(sce_sourcewidth,a0),d6
		move.w	(sce_destwidth,a0),d7

		GetTag	#RND_SourceWidth,d6,a3
		move.l	d0,(prm_d0,a5)

		GetTag	#RND_DestWidth,d7,a3
		move.l	d0,(prm_d1,a5)


		movem.l	(prm_a0,a5),a0-a2
		movem.l	(prm_d0,a5),d0-d1

		bsr	Scale

		add.w	#prm_SIZEOF,a7
		movem.l	(a7)+,d6-d7/a4-a6
		rts

;=========================================================================

//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////

	ENDC





	ENDC



