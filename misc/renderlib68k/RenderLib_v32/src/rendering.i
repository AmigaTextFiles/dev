
	IFND	RENDERING_I
RENDERING_I		SET	1

;=========================================================================
;-------------------------------------------------------------------------
;
;		Render v3.0
;
;	v2.0	- nicht	mehr abhängig von einem Histogramm,
;		  sondern von einer Palette
;
;	v3.0	- alle Modi laufen über ein internes Interface
;
;	>	a0	ULONG	*rgb
;		d0	UWORD	width
;		d1	UWORD	height
;		a1	UBYTE	*chunky
;		a2	APTR	palette
;		a3	struct TagItem *taglist
;	<	d0	ULONG	Returncode REND_...
;
;	Tags:	RND_ColorMode		Default: COLORMODE_CLUT
;		RND_DitherMode		Default: DITHERMODE_NONE
;		RND_SourceWidth		Default: width
;		RND_DestWidth		Default: width
;		RND_ProgressHook	Default: NULL
;		RND_OffsetColorZero	Default: 0
;		RND_DitherAmount	Default: 40
;		RND_PenTab		Default: NULL
;		RND_LineHook		Default: NULL
;		RND_ScaleEngine		Default: NULL
;		RND_BGColor		Default: -1
;
;-------------------------------------------------------------------------

Render:		Lock		pal_semaphore(a2)

		movem.l	d2-d7/a2-a6,-(a7)

		sub.w	#conv_SIZEOF,a7
		move.l	a7,a5
		move.w	#-1,(conv_directionflipflop,a5)

		move.l	a0,(conv_source,a5)
		move.l	a1,(conv_dest,a5)
		move.l	a2,(conv_destpalette,a5)
		move.w	d0,(conv_width,a5)
		move.w	d1,(conv_height,a5)

		moveq	#REND_NOT_ENOUGH_MEMORY,d7

		move.l	(conv_destpalette,a5),a0
		bsr	PAL_CreateP2Table
		tst.l	d0
		beq	.raus
		move.l	d0,(conv_p2table,a5)


		move.l	(conv_destpalette,a5),a0
		movem.w	(pal_p2HAM1,a0),d0-d1			; p2Parameter übertragen
		movem.w	d0-d1,(conv_p2HAM1,a5)
		move.w	(pal_bitspergun,a0),(conv_p2bitspergun,a5)

		lea	(pal_wordpalette,a0),a1
		move.l	a1,(conv_wordpalette,a5)
		move.w	(pal_numcolors,a0),(conv_numcolors,a5)

		move.l	(pal_memhandler,a0),(conv_memhandler,a5)


		move.l	(utilitybase,pc),a6

		GetTag	#RND_BGColor,#-1,a3
		move.l	d0,(conv_bgcolor,a5)

		GetTag	#RND_DitherAmount,#128,a3
		move.w	d0,(conv_ditheramount,a5)

		move.w	(conv_width,a5),d7
		GetTag	#RND_SourceWidth,d7,a3
		move.w	d0,(conv_totalsourcewidth,a5)
		
		move.w	(conv_width,a5),d7
		GetTag	#RND_DestWidth,d7,a3
		move.w	d0,(conv_totaldestwidth,a5)

		GetTag	#RND_ProgressHook,#0,a3
		move.l	d0,d5

		GetTag	#RND_LineHook,#0,a3
		move.l	d0,d4
		
		GetTag	#RND_DitherMode,#DITHERMODE_NONE,a3
		move.w	d0,(conv_dithermode,a5)


		GetTag	#RND_PenTable,#0,a3
		tst.l	d0
		bne.b	.makepentab

		GetTag	#RND_OffsetColorZero,#0,a3
		
		lea	(conv_pentab,a5),a0
		moveq	#31,d1
.makepentablop1
		REPT	8
		move.b	d0,(a0)+
		addq.w	#1,d0
		ENDR
		dbf	d1,.makepentablop1
		bra.b	.nopentab	

.makepentab	move.l	d0,a0
		lea	(conv_pentab,a5),a1
		moveq	#31,d1
.makepentablop2
		REPT	8
		move.b	(a0)+,(a1)+
		ENDR
		dbf	d1,.makepentablop2

.nopentab
		GetTag	#RND_ColorMode,#COLORMODE_CLUT,a3
		move.w	d0,(conv_colormode,a5)


		GetTag	#RND_MapEngine,#0,a3
		move.l	d0,(conv_mapengine,a5)

		clr.w	(conv_sourcex,a5)
		clr.w	(conv_sourcey,a5)
		clr.w	(conv_destx,a5)
		clr.w	(conv_desty,a5)

		GetTag	#RND_ScaleEngine,#0,a3

		lea	(rnd_normal,pc),a0
		move.l	d0,d6
		beq.b	.normal
		lea	(rnd_scaled,pc),a0

.normal

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

		jsr	(a0)			; Rendern

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

.raus		add.w	#conv_SIZEOF,a7

		move.l	d7,d0

		movem.l	(a7)+,d2-d7/a2-a6

		Unlock		pal_semaphore(a2)
		rts

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;	Rendern mit Scale-Engine: 
;		- Scale() wird einmal pro Destzeile aufgerufen
;		- Die Argumente width und height werden ignoriert, 
;		  Breite und Höhe sind Destbreite und Desthöhe der
;		  Scaleengine
;
;
;	Schema:
;
;	linehook (FETCH, sourcebuffer)
;	scale (sourcebuffer, linebuffer)
;  [	linehook (SCALED, linebuffer)    ]
;	render (linebuffer, destbuffer)
;	linehook (RENDERED, destbuffer)
;
;
;	>	d6	Scaling-Engine
;

rnd_scaled:	move.l	a2,-(a7)
		sub.w	#conv_SIZEOF,a7
		move.l	a7,a6


		moveq	#REND_NOT_ENOUGH_MEMORY,d7


	;	Linebuffer anfordern

		move.l	d6,a0
		moveq	#0,d0
		move.w	(eng_destwidth,a0),d0
		lsl.l	#2,d0
		move.l	(conv_memhandler,a5),a0
		bsr	AllocRenderVec
		tst.l	d0
		beq	.error
		move.l	d0,a2


	; 	Scaling vorbereiten

		move.l	d6,a0
		move.l	a0,(conv_engine,a6)		; Scale-Engine eintragen
		move.l	(conv_source,a5),(conv_source,a6)
		move.l	a2,(conv_dest,a6)		; Linebuffer ist Dest

		move.l	(conv_memhandler,a5),(conv_memhandler,a6)
		move.w	(eng_destwidth,a0),(conv_width,a6)
		move.w	(eng_destheight,a0),(conv_height,a6)
		move.w	(eng_pixelformat,a0),(conv_colormode,a6)

		clr.w	(conv_sourcex,a6)
		clr.w	(conv_sourcey,a6)
		clr.w	(conv_destx,a6)
		clr.w	(conv_desty,a6)

		clr.w	(conv_totaldestwidth,a6)	; Destbreite = 0
	;	move.w	(conv_totalsourcewidth,a5),(conv_totalsourcewidth,a6)

		move.w	(eng_sourcewidth,a0),d6
		movem.l	a6/a0,-(a7)
		move.l	(utilitybase,pc),a6
		GetTag	#RND_SourceWidth,d6,a3
		movem.l	(a7)+,a6/a0
		move.w	d0,(conv_totalsourcewidth,a6)



	;	Render modifizieren

		clr.w	(conv_totalsourcewidth,a5)		; Sourcebreite = 0
		move.l	a2,(conv_source,a5)			; Linebuffer ist Source
		move.w	(eng_destheight,a0),(conv_height,a5)
		move.w	(eng_destwidth,a0),(conv_width,a5)



		move.l	a2,-(a7)		; Linebuffer



		bsr	Init_RGB2Chunky
		tst.l	d0
		beq	.renderok

		;	a0		linebuffer
		;	a1		destbuffer

		move.l	a1,a2


		exg	a5,a6
		move.l	(conv_engine,a5),a4
		jsr	([eng_initfunc,a4])
		exg	a5,a6
		tst.l	d0
		beq	.renderok

		move.l	a2,a1


		;	a0		sourcebuffer
		;	a1		destbuffer

		move.w	(conv_height,a5),d6
		subq.w	#1,d6


.yloop
			move.l	d4,d0
			beq.b	.nolcb1

			moveq	#0,d3
			move.w	(conv_sourceline,a5),d3		; !!!

			moveq	#LMSGTYPE_LINE_FETCH,d2		; Messagetyp
			move.l	a0,d1				; Objekt = Sourcebuffer
			LINECALLBACK
			tst.w	d0
			beq.w	.cbabort

.nolcb1
		;	a0: source
		;	a1: dest

		move.l	a1,a2					; destbuffer merken
		move.l	(a7),a1					; dest=linebuffer
		exg	a5,a6

			move.l	(conv_bgcolor,a6),d0
			bmi.b	.nobgcol

			move.w	([conv_engine,a5],eng_destwidth),d1
			subq.w	#1,d1
.bgloop			move.l	d0,(a1)+
			dbf	d1,.bgloop

			move.l	(a7),a1		
.nobgcol

		jsr	([conv_func,a5])			; scale
		add.l	d0,a0
		exg	a5,a6

		move.l	a2,a1					; destbuffer
		move.l	a0,a2					; sourcebuffer merken
		move.l	(a7),a0					; source=linebuffer

		jsr	([conv_func,a5])			; render

		move.l	a2,a0					; sourcebuffer

			move.l	d4,d0
			beq.b	.nolcb2

			move.l	d1,-(a7)			
			moveq	#0,d3
			move.w	(conv_height,a5),d3
			sub.w	d6,d3				; Count
			subq.l	#1,d3
			moveq	#LMSGTYPE_LINE_RENDERED,d2	; Messagetyp
			move.l	a1,d1				; Objekt
			LINECALLBACK
			move.l	(a7)+,d1
			tst.w	d0
			beq.b	.cbabort

.nolcb2

		add.l	d1,a1

			move.l	d5,d0
			beq.b	.nopcb

			move.l	d4,-(a7)
			moveq	#0,d4
			move.w	(conv_height,a5),d4		; Total
			move.l	d4,d3
			sub.w	d6,d3				; Count
			move.l	(conv_destpalette,a5),d1	; Objekt
			moveq	#PMSGTYPE_LINES_RENDERED,d2	; Messagetyp
			PROGRESSCALLBACK
			move.l	(a7)+,d4
			tst.w	d0		
			beq.b	.cbabort

.nopcb
		dbf	d6,.yloop		

		moveq	#REND_SUCCESS,d7
		bra.b	.renderok


.cbabort	moveq	#REND_CALLBACK_ABORTED,d7

.renderok	exg	a5,a6
		jsr	([conv_closefunc,a5])		; Scale
		exg	a5,a6

		jsr	([conv_closefunc,a5])		; Render


		move.l	(a7)+,a0
		bsr	FreeRenderVec			; Linebuffer freigeben

.error		add.w	#conv_SIZEOF,a7
		move.l	(a7)+,a2
		rts

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

rnd_normal	moveq	#REND_NOT_ENOUGH_MEMORY,d7

		bsr	Init_RGB2Chunky
		tst.l	d0
		beq	.renderok

		move.w	(conv_height,a5),d6
		subq.w	#1,d6

.yloop
			move.l	d4,d0
			beq.b	.nolcb1

			moveq	#0,d3
			move.w	(conv_height,a5),d3
			sub.w	d6,d3				; Count
			subq.l	#1,d3
			moveq	#LMSGTYPE_LINE_FETCH,d2		; Messagetyp
			move.l	a0,d1				; Objekt
			LINECALLBACK
			tst.w	d0
			beq.w	.cbabort

.nolcb1

		jsr	([conv_func,a5])
		add.l	d0,a0

			move.l	d4,d0
			beq.b	.nolcb2

			move.l	d1,-(a7)			
			moveq	#0,d3
			move.w	(conv_height,a5),d3
			sub.w	d6,d3				; Count
			subq.l	#1,d3
			moveq	#LMSGTYPE_LINE_RENDERED,d2	; Messagetyp
			move.l	a1,d1				; Objekt
			LINECALLBACK
			move.l	(a7)+,d1
			tst.w	d0
			beq.b	.cbabort

.nolcb2

		add.l	d1,a1

			move.l	d5,d0
			beq.b	.nopcb

			move.l	d4,-(a7)
			moveq	#0,d4
			move.w	(conv_height,a5),d4		; Total
			move.l	d4,d3
			sub.w	d6,d3				; Count
			move.l	(conv_destpalette,a5),d1	; Objekt
			moveq	#PMSGTYPE_LINES_RENDERED,d2	; Messagetyp
			PROGRESSCALLBACK
			move.l	(a7)+,d4
			tst.w	d0		
			beq.b	.cbabort

.nopcb
		dbf	d6,.yloop		

		moveq	#REND_SUCCESS,d7
		bra.b	.renderok


.cbabort	moveq	#REND_CALLBACK_ABORTED,d7

.renderok	jmp	([conv_closefunc,a5])


;=========================================================================


;==============================================================================
;------------------------------------------------------------------------------
;
;	RGB2Chunky
;
;	>	a5	Conv-Struktur
;			s,d,sx,sy,dx,dy,width,tswidth,tdwidth,colormode,dpalette,pentab,mapengine
;	<	a0	Source
;		a1	Dest
;
;------------------------------------------------------------------------------

Init_RGB2Chunky
		move.l	(conv_mapengine,a5),d0
		beq.b	.nomap

		move.l	d0,a0
		Lock	map_semaphore(a0)
.nomap

		lea	(Func_RGB2Chunky_close,pc),a1
		move.l	a1,(conv_closefunc,a5)


		moveq	#COLORMODE_MASK,d0
		and.w	(conv_colormode,a5),d0


		;---------------------------------------------------

		cmp.w	#COLORMODE_HAM6,d0
		bne.b	.notham6

.ham6		cmp.w	#DITHERMODE_NONE,(conv_dithermode,a5)
		beq.b	.ham6_nodither

.ham6_dither
		bsr	AllocDitherBuffer
		move.l	d0,d7
		moveq	#REND_NOT_ENOUGH_MEMORY,d0
		tst.l	d7
		beq	.initfailed

		lea	(Func_RGB2Chunky_close_dither,pc),a1
		move.l	a1,(conv_closefunc,a5)

		lea	(DitherLine_EDD_HAM6,pc),a0
		cmp.w	#DITHERMODE_EDD,(conv_dithermode,a5)
		beq.b	.ham6_d_ok

		lea	(DitherLine_Random_HAM6,pc),a0
		cmp.w	#DITHERMODE_RANDOM,(conv_dithermode,a5)
		beq.b	.ham6_d_ok

		lea	(FSDitherLine_HAM6,pc),a0
		
.ham6_d_ok	move.l	a0,(conv_ditherfunc,a5)

		lea	(Func_RGB2Chunky_HAM_dither,pc),a0
		bra	.cmok

.ham6_nodither	lea	(Func_RGB2Chunky_HAM6,pc),a0
		bra	.cmok

.notham6
		;---------------------------------------------------

		cmp.w	#COLORMODE_HAM8,d0
		bne.b	.notham8

.ham8		cmp.w	#DITHERMODE_NONE,(conv_dithermode,a5)
		beq.b	.ham8_nodither

.ham8_dither
		bsr	AllocDitherBuffer
		move.l	d0,d7
		moveq	#REND_NOT_ENOUGH_MEMORY,d0
		tst.l	d7
		beq	.initfailed

		lea	(Func_RGB2Chunky_close_dither,pc),a1
		move.l	a1,(conv_closefunc,a5)

		lea	(DitherLine_EDD_HAM8,pc),a0
		cmp.w	#DITHERMODE_EDD,(conv_dithermode,a5)
		beq.b	.ham8_d_ok

		lea	(DitherLine_Random_HAM8,pc),a0
		cmp.w	#DITHERMODE_RANDOM,(conv_dithermode,a5)
		beq.b	.ham8_d_ok
		
		lea	(FSDitherLine_HAM8,pc),a0
		
.ham8_d_ok	move.l	a0,(conv_ditherfunc,a5)

		lea	(Func_RGB2Chunky_HAM_dither,pc),a0
		bra	.cmok

.ham8_nodither	lea	(Func_RGB2Chunky_HAM8,pc),a0
		bra	.cmok

		;---------------------------------------------------

.notham8	cmp.w	#COLORMODE_CLUT,d0
		bne	.ill

		;---------------------------------------------------

.clut		move.w	(conv_dithermode,a5),d1
		cmp.w	#DITHERMODE_NONE,d1
		beq.b	.clut_nodither

.clut_dither	bsr	AllocDitherBuffer
		move.l	d0,d7
		moveq	#REND_NOT_ENOUGH_MEMORY,d0
		tst.l	d7
		beq	.initfailed

		lea	(Func_RGB2Chunky_close_dither,pc),a1
		move.l	a1,(conv_closefunc,a5)

		tst.l	(conv_mapengine,a5)
		bne.b	.clut_dither_map

		lea	(DitherLine_EDD_CLUT,pc),a0
		cmp.w	#DITHERMODE_EDD,d1
		beq.b	.clut_d_ok

		lea	(DitherLine_Random_CLUT,pc),a0
		cmp.w	#DITHERMODE_RANDOM,d1
		beq.b	.clut_d_ok

		lea	(FSDitherLine_CLUT,pc),a0
	
.clut_d_ok	move.l	a0,(conv_ditherfunc,a5)

		lea	(func_RGB2Chunky_CLUT_dither,pc),a0
		bra	.cmok

.clut_dither_map
		move.l	(conv_mapengine,a5),a0
		bsr	UpdateMappingEngine
		tst.l	d0
		beq	.initfailed

		lea	(DitherLine_Random_CLUT_Map,pc),a0
		cmp.w	#DITHERMODE_RANDOM,d1
		beq.b	.clut_d_ok

		lea	(DitherLine_EDD_CLUT_Map,pc),a0
		cmp.w	#DITHERMODE_EDD,d1
		beq.b	.clut_d_ok

		lea	(FSDitherLine_CLUT_Map,pc),a0
		bra.b	.clut_d_ok

		;---------------------------------------------------

.clut_nodither	tst.l	(conv_mapengine,a5)
		bne.b	.clut_nodither_map

		move.w	([conv_destpalette,a5],pal_p2bitspergun),d0

		lea	(Func_RGB2Chunky_CLUT12,pc),a0
		cmp.w	#4,d0
		beq.b	.cmok

		lea	(Func_RGB2Chunky_CLUT15,pc),a0
		cmp.w	#5,d0
		beq.b	.cmok

		lea	(Func_RGB2Chunky_CLUT18,pc),a0
		cmp.w	#6,d0
		beq.b	.cmok

.clut_nodither_map

		move.l	(conv_mapengine,a5),a0
		bsr	UpdateMappingEngine
		tst.l	d0
		beq.b	.initfailed
		
		move.w	([conv_destpalette,a5],pal_p2bitspergun),d0

		lea	(Func_RGB2Chunky_CLUT12_Map,pc),a0
		cmp.w	#4,d0
		beq.b	.cmok

		lea	(Func_RGB2Chunky_CLUT15_Map,pc),a0
		cmp.w	#5,d0
		beq.b	.cmok

		lea	(Func_RGB2Chunky_CLUT18_Map,pc),a0
		cmp.w	#6,d0
		beq.b	.cmok
		
		
		;---------------------------------------------------

.ill		illegal

.cmok		move.l	a0,(conv_func,a5)

		move.w	(conv_sourcey,a5),d0
		mulu.w	(conv_totalsourcewidth,a5),d0
		moveq	#0,d1
		move.w	(conv_sourcex,a5),d1
		add.l	d1,d0
		lea	([conv_source,a5],d0.l*4),a0	; Source

		move.w	(conv_desty,a5),d0
		mulu.w	(conv_totaldestwidth,a5),d0
		moveq	#0,d1
		move.w	(conv_destx,a5),d1
		add.l	d1,d0
		lea	([conv_dest,a5],d0.l),a1	; Dest

		move.w	(conv_totalsourcewidth,a5),d0
		ext.l	d0
		asl.l	#2,d0
		move.l	d0,(conv_sourceoffset,a5)
		
		moveq	#0,d0
		move.w	(conv_totaldestwidth,a5),d0
		move.l	d0,(conv_destoffset,a5)


		moveq	#-1,d0
		rts		

.initfailed	moveq	#0,d0
		rts

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

Func_RGB2Chunky_close_dither
		bsr	FreeDitherBuffer

Func_RGB2Chunky_close

		move.l	(conv_mapengine,a5),d0
		beq.b	.nomape
		move.l	d0,a0
		Unlock	map_semaphore(a0)
.nomape
		rts

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

		cnop	0,4
func_RGB2Chunky_CLUT_dither

		movem.l	a0-a3/a6/d4-d6,-(a7)

		move.l	(conv_thislinebuffer,a5),a2
		move.l	(conv_nextlinebuffer,a5),a3
		move.w	(conv_width,a5),d7

		bsr	PrepareDitherLine_RGB
		jsr	([conv_ditherfunc,a5])

		move.l	a2,(conv_thislinebuffer,a5)
		move.l	a3,(conv_nextlinebuffer,a5)
		movem.l	(a7)+,a0-a3/a6/d4-d6
		move.l	(conv_sourceoffset,a5),d0
		move.l	(conv_destoffset,a5),d1
		rts

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

		cnop	0,4
Func_RGB2Chunky_HAM_dither

		movem.l	a0-a6/d0-d7,-(a7)

		move.l	(conv_thislinebuffer,a5),a2
		move.l	(conv_nextlinebuffer,a5),a3

		move.w	(conv_width,a5),d7

		bsr	PrepareDitherLine_RGB

	;	moveq	#0,d0
	;	move.b	([conv_pentab,a5]),d0
	;	move.l	([conv_destpalette,a5],pal_palette,d0.w*4),(conv_oldRGB,a5)
		move.l	([conv_destpalette,a5],pal_palette),(conv_oldRGB,a5)

		jsr	([conv_ditherfunc,a5])

		move.l	a2,(conv_thislinebuffer,a5)
		move.l	a3,(conv_nextlinebuffer,a5)
		movem.l	(a7)+,a0-a6/d0-d7
		move.l	(conv_sourceoffset,a5),d0
		move.l	(conv_destoffset,a5),d1
		rts

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

		cnop	0,4
Func_RGB2Chunky_HAM8

		movem.l	a0-a6/d0-d7,-(a7)

		lea	([conv_destpalette,a5],pal_palette),a2
		lea	(quadtab,pc),a3		

	;	moveq	#0,d1
	;	move.b	([conv_pentab,a5]),d1
	;	move.l	(a2,d1.w*4),d1			; basisfarbe
		move.l	(a2),d1

		st	(conv_firstpixel,a5)
		move.w	(conv_width,a5),a4		; Loop-Count

.xloop		move.l	(a0)+,d0
		BESTPENHAM8	HAM8_THRESHOLD
		move.b	d0,(a1)+
		subq.w	#1,a4
		move.w	a4,d0
		bne	.xloop

		movem.l	(a7)+,a0-a6/d0-d7
		move.l	(conv_sourceoffset,a5),d0
		move.l	(conv_destoffset,a5),d1
		rts

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

		cnop	0,4
Func_RGB2Chunky_HAM6

		movem.l	a0-a6/d0-d7,-(a7)

		lea	([conv_destpalette,a5],pal_palette),a2
		lea	(quadtab,pc),a3		

	;	moveq	#0,d1
	;	move.b	([conv_pentab,a5]),d1
	;	move.l	(a2,d1.w*4),d1			; basisfarbe
		move.l	(a2),d1

		st	(conv_firstpixel,a5)
		move.w	(conv_width,a5),a4		; Loop-Count

.xloop		move.l	(a0)+,d0
		BESTPENHAM6
		move.b	d0,(a1)+
		subq.w	#1,a4
		move.w	a4,d0
		bne	.xloop

		movem.l	(a7)+,a0-a6/d0-d7
		move.l	(conv_sourceoffset,a5),d0
		move.l	(conv_destoffset,a5),d1
		rts

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		
		cnop	0,4		
Func_RGB2Chunky_CLUT12

		movem.l	a0-a2/a6/d4-d7,-(a7)

		move.l	a1,a4

		move.l	([conv_destpalette,a5],pal_p2table),a6
		move.l	a6,a2
		lea	(quadtab,pc),a3
		

		move.w	(conv_width,a5),d7
		subq.w	#1,d7


		move.l	#$ffffff,d1
		moveq	#0,d2
		bra.b	.xloop

.xloop2		move.b	(conv_pentab,a5,d0.w),(a4)+

.xloop		move.l	(a0)+,d2		; RrGgBb

		and.l	d1,d2
		lsr.l	#4,d2		; %....RRRRrrrrGGGGggggBBBB
		lsl.b	#4,d2		; %....RRRRrrrrGGGGBBBB....
		lsl.w	#4,d2		; %....RRRRGGGGBBBB........
		lsr.l	#7,d2		; %...........RRRRGGGGBBBB.

		move.w	(a2,d2.l),d0		; Pen
		dbmi	d7,.xloop2

		tst.w	d7
		bmi.b	.xok

		movem.l	d2/d7,-(a7)

		move.l	(conv_wordpalette,a5),a2
		move.w	(conv_numcolors,a5),d4

		move.l	-4(a0),d0				; gesuchter RGB
		and.l	d1,d0
		FINDPEN_PALETTE
		movem.l	(a7)+,d2/d7
		
		move.l	a6,a2
		move.l	#$ffffff,d1
		move.w	d0,(a2,d2.l)

		dbf	d7,.xloop2

.xok		move.b	(conv_pentab,a5,d0.w),(a4)+

		movem.l	(a7)+,a0-a2/a6/d4-d7
		move.l	(conv_sourceoffset,a5),d0
		move.l	(conv_destoffset,a5),d1
		rts

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		
		cnop	0,4		
Func_RGB2Chunky_CLUT15

		movem.l	a0-a2/a6/d4-d7,-(a7)

		move.l	a1,a4

		move.l	([conv_destpalette,a5],pal_p2table),a6
		move.l	a6,a2
		lea	(quadtab,pc),a3

		move.w	(conv_width,a5),d7
		subq.w	#1,d7

		move.l	#$ffffff,d1
		moveq	#0,d2
		bra.b	.xloop

.xloop2		move.b	(conv_pentab,a5,d0.w),(a4)+

.xloop		move.l	(a0)+,d2	; %RRRRRrrrGGGGGgggBBBBBbbb

		and.l	d1,d2
		lsr.l	#3,d2		; %...RRRRRrrrGGGGGgggBBBBB
		lsl.b	#3,d2		; %...RRRRRrrrGGGGGBBBBB...
		lsl.w	#3,d2		; %...RRRRRGGGGGBBBBB......
		lsr.l	#5,d2		; %........RRRRRGGGGGBBBBB.

		move.w	(a2,d2.l),d0		; Pen
		dbmi	d7,.xloop2

		tst.w	d7
		bmi.b	.xok

		movem.l	d2/d7,-(a7)
		
		move.l	(conv_wordpalette,a5),a2
		move.w	(conv_numcolors,a5),d4

		move.l	-4(a0),d0				; gesuchter RGB
		and.l	d1,d0
		FINDPEN_PALETTE
		movem.l	(a7)+,d2/d7

		move.l	a6,a2
		move.l	#$ffffff,d1
		move.w	d0,(a2,d2.l)

		dbf	d7,.xloop2

.xok		move.b	(conv_pentab,a5,d0.w),(a4)+

		movem.l	(a7)+,a0-a2/a6/d4-d7
		move.l	(conv_sourceoffset,a5),d0
		move.l	(conv_destoffset,a5),d1
		rts

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

		cnop	0,4		
Func_RGB2Chunky_CLUT18

		movem.l	a0-a2/a6/d4-d7,-(a7)

		move.l	a1,a4

		move.l	([conv_destpalette,a5],pal_p2table),a6
		move.l	a6,a2
		lea	(quadtab,pc),a3

		move.w	(conv_width,a5),d7
		subq.w	#1,d7

		move.l	#$ffffff,d1
		moveq	#0,d2
		bra.b	.xloop

.xloop2		move.b	(conv_pentab,a5,d0.w),(a4)+
		
.xloop		move.l	(a0)+,d2		; RGB

		and.l	d1,d2
		lsr.l	#2,d2		; %..RRRRRRrrGGGGGGggBBBBBB
		lsl.b	#2,d2		; %..RRRRRRrrGGGGGGBBBBBB..
		lsl.w	#2,d2		; %..RRRRRRGGGGGGBBBBBB....
		lsr.l	#3,d2		; %.....RRRRRRGGGGGGBBBBBB.

		move.w	(a2,d2.l),d0		; Pen
		dbmi	d7,.xloop2

		tst.w	d7
		bmi.b	.xok

		movem.l	d2/d7,-(a7)

		move.l	(conv_wordpalette,a5),a2
		move.w	(conv_numcolors,a5),d4

		move.l	-4(a0),d0				; gesuchter RGB
		and.l	d1,d0
		FINDPEN_PALETTE
		movem.l	(a7)+,d2/d7

		move.l	a6,a2
		move.l	#$ffffff,d1
		move.w	d0,(a2,d2.l)

		dbf	d7,.xloop2

.xok		move.b	(conv_pentab,a5,d0.w),(a4)+

		movem.l	(a7)+,a0-a2/a6/d4-d7
		move.l	(conv_sourceoffset,a5),d0
		move.l	(conv_destoffset,a5),d1
		rts



;==============================================================================
;
;		Funktionsobjekte zum Rendern mit Mapping-Engine
;
;==============================================================================

Func_RGB2Chunky_CLUT12_Map:

		movem.l	a0-a4/a6/d4-d7,-(a7)

		move.l	([conv_mapengine,a5],map_p1table),a2
		lea	(conv_pentab,a5),a6
		move.l	#$ffffff,a4

.map		move.w	(conv_width,a5),d0
		lsr.w	#3,d0
		beq	.skip8
		move.w	d0,a3

.loop8		move.l	a4,d0
		move.l	a4,d1
		and.l	(a0)+,d0
		move.l	a4,d2
		lsr.l	#4,d0
		and.l	(a0)+,d1
		move.l	a4,d3
		lsr.l	#4,d1
		and.l	(a0)+,d2
		move.l	a4,d4
		lsr.l	#4,d2
		and.l	(a0)+,d3
		move.l	a4,d5
		lsr.l	#4,d3
		and.l	(a0)+,d4
		move.l	a4,d6
		lsr.l	#4,d4
		and.l	(a0)+,d5
		move.l	a4,d7
		lsr.l	#4,d5
		and.l	(a0)+,d6
		lsr.l	#4,d6
		and.l	(a0)+,d7
		lsr.l	#4,d7

		lsl.b	#4,d0
		lsl.b	#4,d1
		lsl.b	#4,d2
		lsl.b	#4,d3
		lsl.b	#4,d4
		lsl.b	#4,d5
		lsl.b	#4,d6
		lsl.w	#4,d0
		lsl.b	#4,d7

		lsr.l	#8,d0
		lsl.w	#4,d1
		move.b	(a2,d0.l),d0
		lsr.l	#8,d1
		lsl.w	#4,d2
		move.b	(a2,d1.l),d1
		lsr.l	#8,d2
		lsl.w	#4,d3
		move.b	(a2,d2.l),d2
		lsr.l	#8,d3
		lsl.w	#4,d4
		move.b	(a2,d3.l),d3
		lsr.l	#8,d4
		lsl.w	#4,d5
		move.b	(a2,d4.l),d4
		lsr.l	#8,d5
		lsl.w	#4,d6
		move.b	(a2,d5.l),d5
		lsr.l	#8,d6
		lsl.w	#4,d7
		move.b	(a2,d6.l),d6
		lsr.l	#8,d7
		move.b	(a2,d7.l),d7

		and.w	#$00ff,d0
		move.b	(a6,d0.w),(a1)+
		move.w	#$00ff,d0
		and.w	d0,d1
		move.b	(a6,d1.w),(a1)+
		and.w	d0,d2
		move.b	(a6,d2.w),(a1)+
		and.w	d0,d3
		move.b	(a6,d3.w),(a1)+
		and.w	d0,d4
		move.b	(a6,d4.w),(a1)+
		and.w	d0,d5
		move.b	(a6,d5.w),(a1)+
		and.w	d0,d6
		move.b	(a6,d6.w),(a1)+
		and.w	d0,d7
		subq.w	#1,a3
		move.b	(a6,d7.w),(a1)+
		move.w	a3,d3
		bne	.loop8

.skip8		moveq	#7,d1
		and.w	(conv_width,a5),d1
		beq.b	.skip1
		subq.w	#1,d1

		move.w	#$00ff,d2
.loop1		move.l	a4,d0
		and.l	(a0)+,d0
		lsr.l	#4,d0
		lsl.b	#4,d0
		lsl.w	#4,d0
		lsr.l	#8,d0
		move.b	(a2,d0.l),d0
		and.w	d2,d0
		move.b	(a6,d0.w),(a1)+
		dbf	d1,.loop1

.skip1		movem.l	(a7)+,a0-a4/a6/d4-d7
		move.l	(conv_sourceoffset,a5),d0
		move.l	(conv_destoffset,a5),d1
		rts

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

Func_RGB2Chunky_CLUT15_Map:

		movem.l	a0-a4/a6/d4-d7,-(a7)

		move.l	([conv_mapengine,a5],map_p1table),a2
		lea	(conv_pentab,a5),a6
		move.l	#$ffffff,a4

.map		move.w	(conv_width,a5),d0
		lsr.w	#3,d0
		beq	.skip8
		move.w	d0,a3

.loop8		move.l	a4,d0
		move.l	a4,d1
		and.l	(a0)+,d0
		move.l	a4,d2
		lsr.l	#3,d0
		and.l	(a0)+,d1
		move.l	a4,d3
		lsr.l	#3,d1
		and.l	(a0)+,d2
		move.l	a4,d4
		lsr.l	#3,d2
		and.l	(a0)+,d3
		move.l	a4,d5
		lsr.l	#3,d3
		and.l	(a0)+,d4
		move.l	a4,d6
		lsr.l	#3,d4
		and.l	(a0)+,d5
		move.l	a4,d7
		lsr.l	#3,d5
		and.l	(a0)+,d6
		lsr.l	#3,d6
		and.l	(a0)+,d7
		lsr.l	#3,d7

		lsl.b	#3,d0
		lsl.b	#3,d1
		lsl.b	#3,d2
		lsl.b	#3,d3
		lsl.b	#3,d4
		lsl.b	#3,d5
		lsl.b	#3,d6
		lsl.w	#3,d0
		lsl.b	#3,d7

		lsr.l	#6,d0
		lsl.w	#3,d1
		move.b	(a2,d0.l),d0
		lsr.l	#6,d1
		lsl.w	#3,d2
		move.b	(a2,d1.l),d1
		lsr.l	#6,d2
		lsl.w	#3,d3
		move.b	(a2,d2.l),d2
		lsr.l	#6,d3
		lsl.w	#3,d4
		move.b	(a2,d3.l),d3
		lsr.l	#6,d4
		lsl.w	#3,d5
		move.b	(a2,d4.l),d4
		lsr.l	#6,d5
		lsl.w	#3,d6
		move.b	(a2,d5.l),d5
		lsr.l	#6,d6
		lsl.w	#3,d7
		move.b	(a2,d6.l),d6
		lsr.l	#6,d7
		move.b	(a2,d7.l),d7

		and.w	#$00ff,d0
		move.b	(a6,d0.w),(a1)+
		move.w	#$00ff,d0
		and.w	d0,d1
		move.b	(a6,d1.w),(a1)+
		and.w	d0,d2
		move.b	(a6,d2.w),(a1)+
		and.w	d0,d3
		move.b	(a6,d3.w),(a1)+
		and.w	d0,d4
		move.b	(a6,d4.w),(a1)+
		and.w	d0,d5
		move.b	(a6,d5.w),(a1)+
		and.w	d0,d6
		move.b	(a6,d6.w),(a1)+
		and.w	d0,d7
		subq.w	#1,a3
		move.b	(a6,d7.w),(a1)+
		move.w	a3,d3
		bne	.loop8

.skip8		moveq	#7,d1
		and.w	(conv_width,a5),d1
		beq.b	.skip1
		subq.w	#1,d1

		move.w	#$00ff,d2
.loop1		move.l	a4,d0
		and.l	(a0)+,d0
		lsr.l	#3,d0
		lsl.b	#3,d0
		lsl.w	#3,d0
		lsr.l	#6,d0
		move.b	(a2,d0.l),d0
		and.w	d2,d0
		move.b	(a6,d0.w),(a1)+
		dbf	d1,.loop1

.skip1		movem.l	(a7)+,a0-a4/a6/d4-d7
		move.l	(conv_sourceoffset,a5),d0
		move.l	(conv_destoffset,a5),d1
		rts

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

Func_RGB2Chunky_CLUT18_Map:

		movem.l	a0-a4/a6/d4-d7,-(a7)

		move.l	([conv_mapengine,a5],map_p1table),a2
		lea	(conv_pentab,a5),a6
		move.l	#$ffffff,a4

.map		move.w	(conv_width,a5),d0
		lsr.w	#3,d0
		beq	.skip8
		move.w	d0,a3

.loop8		move.l	a4,d0
		move.l	a4,d1
		and.l	(a0)+,d0
		move.l	a4,d2
		lsr.l	#2,d0
		and.l	(a0)+,d1
		move.l	a4,d3
		lsr.l	#2,d1
		and.l	(a0)+,d2
		move.l	a4,d4
		lsr.l	#2,d2
		and.l	(a0)+,d3
		move.l	a4,d5
		lsr.l	#2,d3
		and.l	(a0)+,d4
		move.l	a4,d6
		lsr.l	#2,d4
		and.l	(a0)+,d5
		move.l	a4,d7
		lsr.l	#2,d5
		and.l	(a0)+,d6
		lsr.l	#2,d6
		and.l	(a0)+,d7
		lsr.l	#2,d7

		lsl.b	#2,d0
		lsl.b	#2,d1
		lsl.b	#2,d2
		lsl.b	#2,d3
		lsl.b	#2,d4
		lsl.b	#2,d5
		lsl.b	#2,d6
		lsl.w	#2,d0
		lsl.b	#2,d7

		lsr.l	#4,d0
		lsl.w	#2,d1
		move.b	(a2,d0.l),d0
		lsr.l	#4,d1
		lsl.w	#2,d2
		move.b	(a2,d1.l),d1
		lsr.l	#4,d2
		lsl.w	#2,d3
		move.b	(a2,d2.l),d2
		lsr.l	#4,d3
		lsl.w	#2,d4
		move.b	(a2,d3.l),d3
		lsr.l	#4,d4
		lsl.w	#2,d5
		move.b	(a2,d4.l),d4
		lsr.l	#4,d5
		lsl.w	#2,d6
		move.b	(a2,d5.l),d5
		lsr.l	#4,d6
		lsl.w	#2,d7
		move.b	(a2,d6.l),d6
		lsr.l	#4,d7
		move.b	(a2,d7.l),d7

		and.w	#$00ff,d0
		move.b	(a6,d0.w),(a1)+
		move.w	#$00ff,d0
		and.w	d0,d1
		move.b	(a6,d1.w),(a1)+
		and.w	d0,d2
		move.b	(a6,d2.w),(a1)+
		and.w	d0,d3
		move.b	(a6,d3.w),(a1)+
		and.w	d0,d4
		move.b	(a6,d4.w),(a1)+
		and.w	d0,d5
		move.b	(a6,d5.w),(a1)+
		and.w	d0,d6
		move.b	(a6,d6.w),(a1)+
		and.w	d0,d7
		subq.w	#1,a3
		move.b	(a6,d7.w),(a1)+
		move.w	a3,d3
		bne	.loop8

.skip8		moveq	#7,d1
		and.w	(conv_width,a5),d1
		beq.b	.skip1
		subq.w	#1,d1

		move.w	#$00ff,d2
.loop1		move.l	a4,d0
		and.l	(a0)+,d0
		lsr.l	#2,d0
		lsl.b	#2,d0
		lsl.w	#2,d0
		lsr.l	#4,d0
		move.b	(a2,d0.l),d0
		and.w	d2,d0
		move.b	(a6,d0.w),(a1)+
		dbf	d1,.loop1

.skip1		movem.l	(a7)+,a0-a4/a6/d4-d7
		move.l	(conv_sourceoffset,a5),d0
		move.l	(conv_destoffset,a5),d1
		rts


;#########################################################################
;#########################################################################

	
;------------------------------------------------------------------------

FreeDitherBuffer
		movem.l	d0/d1/a0/a1,-(a7)

		move.l	(conv_nextlinebuffer,a5),d0
		beq.b	.nonextbuf
		move.l	d0,a0
		bsr	FreeRenderVec
		clr.l	(conv_nextlinebuffer,a5)
.nonextbuf	move.l	(conv_thislinebuffer,a5),d0
		beq.b	.nothisbuf
		move.l	d0,a0
		bsr	FreeRenderVec
		clr.l	(conv_thislinebuffer,a5)
.nothisbuf
		movem.l	(a7)+,d0/d1/a0/a1
		rts
		
;------------------------------------------------------------------------

AllocDitherBuffer		
		movem.l	d1/a0/a1,-(a7)
		
		moveq	#2,d0
		add.w	(conv_width,a5),d0
		mulu.l	#6,d0
		move.l	d0,(conv_fsbufsize,a5)
	
		move.l	(conv_memhandler,a5),a0
		bsr	AllocRenderVec
		move.l	d0,(conv_thislinebuffer,a5)
		beq.b	.raus

		move.l	(conv_fsbufsize,a5),d0
		move.l	(conv_memhandler,a5),a0
		bsr	AllocRenderVec
		move.l	d0,(conv_nextlinebuffer,a5)
		beq.b	.raus

		;	NextLineBuffer löschen

		move.l	(conv_nextlinebuffer,a5),a0
		move.l	(conv_fsbufsize,a5),d0
		moveq	#0,d1
		bsr	TurboFillMem

		moveq	#-1,d0

.raus		movem.l	(a7)+,d1/a0/a1
		rts

;------------------------------------------------------------------------

PrepareDitherLine_RGB

		move.w	d7,-(a7)

		; ThisLineBuffer löschen

		move.l	a0,a4
		move.l	a2,a0
		move.l	(conv_fsbufsize,a5),d0
		moveq	#0,d1
		bsr	TurboFillMem
		move.l	a4,a0		

		; ThisLineBuffer und NextLineBuffer vertauschen

		exg	a2,a3

		; RGB auf ThisLineBuffer addieren

		lea	6(a2),a4

		lsr.w	#2,d7
		beq.b	.no4

		subq.w	#1,d7

		moveq	#0,d1
		moveq	#0,d2
		moveq	#0,d3
		moveq	#0,d4
		moveq	#0,d5
		moveq	#0,d6
		
.addRGBloop4	move.l	(a0)+,d0
		move.b	d0,d3
		lsr.w	#8,d0
		swap	d3		
		move.b	d0,d2
		swap	d0
		swap	d2
		move.b	d0,d1
		swap	d1		

		move.l	(a0)+,d0
		move.b	d0,d6
		lsr.w	#8,d0
		swap	d6		
		move.b	d0,d5
		swap	d0
		swap	d5
		move.b	d0,d4
		swap	d4		

		move.l	(a0)+,d0
		move.b	d0,d3
		lsr.w	#8,d0
		swap	d3		
		move.b	d0,d2
		swap	d0
		swap	d2
		move.b	d0,d1
		swap	d1		

		move.l	(a0)+,d0
		move.b	d0,d6
			add.w	d1,(a4)+
		lsr.w	#8,d0
		swap	d6		
		move.b	d0,d5
			add.w	d2,(a4)+
		swap	d0
		swap	d5
		move.b	d0,d4
			add.w	d3,(a4)+
		swap	d4		
			add.w	d4,(a4)+
			swap	d1
			add.w	d5,(a4)+
			swap	d2
			add.w	d6,(a4)+
			swap	d3
			add.w	d1,(a4)+
			swap	d4
			add.w	d2,(a4)+
			swap	d5
			add.w	d3,(a4)+
	
			add.w	d4,(a4)+
			swap	d6
			add.w	d5,(a4)+
			add.w	d6,(a4)+

		dbf	d7,.addRGBloop4

.no4		moveq	#3,d7
		and.w	(a7),d7
		beq.b	.no1

.lop1		move.l	(a0)+,d0
		moveq	#0,d3
		move.b	d0,d3
		lsr.l	#8,d0
		moveq	#0,d2
		move.b	d0,d2
		lsr.w	#8,d0
		moveq	#0,d1
		move.b	d0,d1

		add.w	d1,(a4)+
		add.w	d2,(a4)+
		add.w	d3,(a4)+

		subq.w	#1,d7
		bne.b	.lop1

.no1		st	(conv_firstpixel,a5)

		move.w	(a7)+,d7
		rts

;=========================================================================

	ENDC
