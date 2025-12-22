
	IFND	CONVERSIONS_I
CONVERSIONS_I		SET	1


;         /\
;    ____/  \____   
;    \   \  /|  /
;==== \   \/ | / =========================================================
;----- \   | |/ ----------------------------------------------------------
;       \  | /
;        \ |/	ConvertChunky
;         \/	
;		konvertiert ein ChunkyImage (mit Palette) auf
;		eine neue Palette. Dabei kann zusätzlich auch
;		noch eine Pen-Konvertierung vorgenommen werden.
;
;	>	a0	UBYTE *		SourceImage
;		a1	APTR		SourcePalette
;		a2	UBYTE *		DestImage
;		a3	APTR		DestPalette
;		a4	struct TagItem *taglist
;		d0	UWORD		width
;		d1	UWORD		height
;
;	Tags:
;		RND_DitherMode		Default: DITHERMODE_NONE
;		RND_DitherAmount	Default: 40
;		RND_SourceWidth		Default: width
;		RND_DestWidth		Default: width
;		RND_PenTab		Default: NULL
;		RND_OffsetColorZero	Default: 0
;		RND_ProgressHook	Default: NULL
;		RND_LineHook		Default: NULL 
;		RND_ScaleEngine		Default: NULL 
;
;------------------------------------------------------------------------

ConvertChunky:
		LockShared	pal_semaphore(a1)
		Lock		pal_semaphore(a3)

		movem.l	d2-d7/a1-a6,-(a7)

		sub.w	#conv_SIZEOF,a7
		move.l	a7,a5
		move.w	#1,(conv_directionflipflop,a5)

		move.l	a0,(conv_source,a5)
		move.l	a1,(conv_sourcepalette,a5)
		move.l	a2,(conv_dest,a5)
		move.l	a3,(conv_destpalette,a5)
		move.w	d0,(conv_width,a5)
		move.w	d1,(conv_height,a5)
		move.w	d1,d6


		moveq	#CONV_NOT_ENOUGH_MEMORY,d7

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

		GetTag	#RND_BGPen,#-1,a4
		move.l	d0,(conv_bgpen,a5)

		GetTag	#RND_DitherAmount,#128,a4
		move.w	d0,(conv_ditheramount,a5)

		move.w	(conv_width,a5),d7
		GetTag	#RND_SourceWidth,d7,a4
		move.w	d0,(conv_totalsourcewidth,a5)
		
		move.w	(conv_width,a5),d7
		GetTag	#RND_DestWidth,d7,a4
		move.w	d0,(conv_totaldestwidth,a5)


		GetTag	#RND_ProgressHook,#0,a4
		move.l	d0,d5

		GetTag	#RND_LineHook,#0,a4
		move.l	d0,d4

		
		GetTag	#RND_DitherMode,#DITHERMODE_NONE,a4
		move.w	d0,(conv_dithermode,a5)


		GetTag	#RND_PenTable,#0,a4
		tst.l	d0
		bne.b	.makepentab

		GetTag	#RND_OffsetColorZero,#0,a4
		
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
		GetTag	#RND_MapEngine,#0,a4
		move.l	d0,(conv_mapengine,a5)

		clr.w	(conv_sourcex,a5)
		clr.w	(conv_sourcey,a5)
		clr.w	(conv_destx,a5)
		clr.w	(conv_desty,a5)

		GetTag	#RND_ScaleEngine,#0,a4

		lea	(cnv_normal,pc),a0
		move.l	d0,d6
		beq.b	.normal
		lea	(cnv_scaled,pc),a0

.normal


; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

		jsr	(a0)
		
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

.raus		add.w	#conv_SIZEOF,a7

		move.l	d7,d0

		movem.l	(a7)+,d2-d7/a1-a6

		Unlock		pal_semaphore(a3)
		Unlock		pal_semaphore(a1)
		rts

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;	Konvertieren mit Scale-Engine: 
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
;	render (linebuffer, destbuffer)
;	linehook (RENDERED, destbuffer)
;
;
;	>	d6	Scaling-Engine
;

cnv_scaled:	move.l	a2,-(a7)
		sub.w	#conv_SIZEOF,a7
		move.l	a7,a6


		moveq	#CONV_NOT_ENOUGH_MEMORY,d7


	;	Linebuffer anfordern

		move.l	d6,a0
		moveq	#0,d0
		move.w	(eng_destwidth,a0),d0
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

		move.w	(eng_sourcewidth,a0),d6
		movem.l	a6/a0,-(a7)
		move.l	(utilitybase,pc),a6
		GetTag	#RND_SourceWidth,d6,a4
		movem.l	(a7)+,a6/a0
		move.w	d0,(conv_totalsourcewidth,a6)



	;	Render modifizieren

		clr.w	(conv_totalsourcewidth,a5)		; Sourcebreite = 0
		move.l	a2,(conv_source,a5)			; Linebuffer ist Source
		move.w	(eng_destheight,a0),(conv_height,a5)
		move.w	(eng_destwidth,a0),(conv_width,a5)



		move.l	a2,-(a7)		; Linebuffer



		bsr	Init_Chunky2Chunky
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

			move.l	(conv_bgpen,a6),d0
			bmi.b	.nobgcol

			move.w	([conv_engine,a5],eng_destwidth),d1
			subq.w	#1,d1
.bgloop			move.b	d0,(a1)+
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

		moveq	#CONV_SUCCESS,d7
		bra.b	.renderok


.cbabort	moveq	#CONV_CALLBACK_ABORTED,d7

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

cnv_normal	moveq	#CONV_NOT_ENOUGH_MEMORY,d7

		bsr	Init_Chunky2Chunky
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

		moveq	#CONV_SUCCESS,d7
		bra.b	.renderok


.cbabort	moveq	#CONV_CALLBACK_ABORTED,d7

.renderok	jmp	([conv_closefunc,a5])


;------------------------------------------------------------------------




;==============================================================================
;------------------------------------------------------------------------------
;
;	Chunky2Chunky
;
;	>	a5	Conv-Struktur
;			s,d,sx,sy,dx,dy,width,tswidth,tdwidth,spalette,dpalette,pentab
;	<	a0	Source
;		a1	Dest
;
;------------------------------------------------------------------------------

Init_Chunky2Chunky

		move.l	(conv_mapengine,a5),d0
		beq.b	.nomap

		move.l	d0,a0
		Lock	map_semaphore(a0)
.nomap

		move.w	(conv_dithermode,a5),d1
		cmp.w	#DITHERMODE_NONE,d1
		beq.b	.clut_nodither


.clut_dither	bsr	AllocDitherBuffer
		move.l	d0,d7
		moveq	#REND_NOT_ENOUGH_MEMORY,d0
		tst.l	d7
		beq	.initfailed

		lea	(Func_Chunky2Chunky_close_dither,pc),a1
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

		lea	(func_Chunky2Chunky_CLUT_dither,pc),a0
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

.clut_nodither	lea	(Func_Chunky2Chunky_close,pc),a1
		move.l	a1,(conv_closefunc,a5)

		tst.l	(conv_mapengine,a5)
		bne.b	.clut_nodither_map

		move.w	([conv_destpalette,a5],pal_p2bitspergun),d0

		lea	(Func_Chunky2Chunky_CLUT12,pc),a0
		cmp.w	#4,d0
		beq.b	.cmok

		lea	(Func_Chunky2Chunky_CLUT15,pc),a0
		cmp.w	#5,d0
		beq.b	.cmok

		lea	(Func_Chunky2Chunky_CLUT18,pc),a0
		cmp.w	#6,d0
		beq.b	.cmok

.clut_nodither_map

		move.l	(conv_mapengine,a5),a0
		bsr	UpdateMappingEngine
		tst.l	d0
		beq.b	.initfailed
		
		move.w	([conv_mapengine,a5],map_bitspergun),d0

		lea	(Func_Chunky2Chunky_CLUT12_Map,pc),a0
		cmp.w	#4,d0
		beq.b	.cmok

		lea	(Func_Chunky2Chunky_CLUT15_Map,pc),a0
		cmp.w	#5,d0
		beq.b	.cmok

		lea	(Func_Chunky2Chunky_CLUT18_Map,pc),a0
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
		lea	([conv_source,a5],d0.l),a0	; Source

		move.w	(conv_desty,a5),d0
		mulu.w	(conv_totaldestwidth,a5),d0
		moveq	#0,d1
		move.w	(conv_destx,a5),d1
		add.l	d1,d0
		lea	([conv_dest,a5],d0.l),a1	; Dest

		moveq	#0,d0
		move.w	(conv_totalsourcewidth,a5),d0
		move.l	d0,(conv_sourceoffset,a5)
		
		moveq	#0,d0
		move.w	(conv_totaldestwidth,a5),d0
		move.l	d0,(conv_destoffset,a5)

		moveq	#-1,d0
		rts		

.initfailed	moveq	#0,d0
		rts

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

Func_Chunky2Chunky_close_dither

		bsr	FreeDitherBuffer

Func_Chunky2Chunky_close

		move.l	(conv_mapengine,a5),d0
		beq.b	.nomape
		move.l	d0,a0
		Unlock	map_semaphore(a0)
.nomape

		rts

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

		cnop	0,4
func_Chunky2Chunky_CLUT_dither

		movem.l	a0-a3/a6/d4-d6,-(a7)

		move.l	(conv_thislinebuffer,a5),a2
		move.l	(conv_nextlinebuffer,a5),a3
		move.l	(conv_p2table,a5),a6
		move.w	(conv_width,a5),d7

		bsr	PrepareDitherLine_Chunky
		jsr	([conv_ditherfunc,a5])

		move.l	a2,(conv_thislinebuffer,a5)
		move.l	a3,(conv_nextlinebuffer,a5)
		movem.l	(a7)+,a0-a3/a6/d4-d6
		move.l	(conv_sourceoffset,a5),d0
		move.l	(conv_destoffset,a5),d1
		rts

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

		cnop	0,4		
Func_Chunky2Chunky_CLUT12

		movem.l	a0-a2/a6/d4-d7,-(a7)

		move.l	a1,a4
		lea	([conv_sourcepalette,a5],pal_palette),a6
		move.l	([conv_destpalette,a5],pal_p2table),a2
		lea	(quadtab,pc),a3

		move.w	(conv_width,a5),d7
		subq.w	#1,d7

		moveq	#0,d1
		bra.b	.xloop

.xloop2		move.b	(conv_pentab,a5,d0.w),(a4)+

.xloop		move.b	(a0)+,d1
		move.l	(a6,d1.w*4),d2

		lsr.l	#4,d2
		lsl.b	#4,d2
		lsl.w	#4,d2
		lsr.l	#7,d2

		move.w	(a2,d2.l),d0		; Pen
		dbmi	d7,.xloop2

		tst.w	d7
		bmi.b	.xok

		movem.l	d2/d7/a2,-(a7)

		move.l	(conv_wordpalette,a5),a2
		move.w	(conv_numcolors,a5),d4

		move.l	(a6,d1.w*4),d0		; gesuchter RGB
		FINDPEN_PALETTE			; trash: d3-d7/a2/[a3]
		movem.l	(a7)+,d2/d7/a2

		moveq	#0,d1
		move.w	d0,(a2,d2.l)

		dbf	d7,.xloop2

.xok		move.b	(conv_pentab,a5,d0.w),(a4)+

		movem.l	(a7)+,a0-a2/a6/d4-d7
	
		move.l	(conv_sourceoffset,a5),d0
		move.l	(conv_destoffset,a5),d1
		rts

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

		cnop	0,4		
Func_Chunky2Chunky_CLUT15

		movem.l	a0-a2/a6/d4-d7,-(a7)

		move.l	a1,a4
		lea	([conv_sourcepalette,a5],pal_palette),a6
		move.l	([conv_destpalette,a5],pal_p2table),a2
		lea	(quadtab,pc),a3

		move.w	(conv_width,a5),d7
		subq.w	#1,d7

		moveq	#0,d1
		bra.b	.xloop

.xloop2		move.b	(conv_pentab,a5,d0.w),(a4)+

.xloop		move.b	(a0)+,d1
		move.l	(a6,d1.w*4),d2

		lsr.l	#3,d2
		lsl.b	#3,d2
		lsl.w	#3,d2
		lsr.l	#5,d2

		move.w	(a2,d2.l),d0		; Pen
		dbmi	d7,.xloop2

		tst.w	d7
		bmi.b	.xok

		movem.l	d2/d7/a2,-(a7)

		move.l	(conv_wordpalette,a5),a2
		move.w	(conv_numcolors,a5),d4

		move.l	(a6,d1.w*4),d0		; gesuchter RGB
		FINDPEN_PALETTE			; trash: d3-d7/a2/[a3]
		movem.l	(a7)+,d2/d7/a2

		moveq	#0,d1
		move.w	d0,(a2,d2.l)

		dbf	d7,.xloop2

.xok		move.b	(conv_pentab,a5,d0.w),(a4)+

		movem.l	(a7)+,a0-a2/a6/d4-d7
	
		move.l	(conv_sourceoffset,a5),d0
		move.l	(conv_destoffset,a5),d1
		rts

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

		cnop	0,4		
Func_Chunky2Chunky_CLUT18

		movem.l	a0-a2/a6/d4-d7,-(a7)

		move.l	a1,a4
		lea	([conv_sourcepalette,a5],pal_palette),a6
		move.l	([conv_destpalette,a5],pal_p2table),a2
		lea	(quadtab,pc),a3

		move.w	(conv_width,a5),d7
		subq.w	#1,d7

		moveq	#0,d1
		bra.b	.xloop

.xloop2		move.b	(conv_pentab,a5,d0.w),(a4)+

.xloop		move.b	(a0)+,d1
		move.l	(a6,d1.w*4),d2

		lsr.l	#2,d2
		lsl.b	#2,d2
		lsl.w	#2,d2
		lsr.l	#3,d2

		move.w	(a2,d2.l),d0		; Pen
		dbmi	d7,.xloop2

		tst.w	d7
		bmi.b	.xok

		movem.l	d2/d7/a2,-(a7)

		move.l	(conv_wordpalette,a5),a2
		move.w	(conv_numcolors,a5),d4

		move.l	(a6,d1.w*4),d0		; gesuchter RGB
		FINDPEN_PALETTE			; trash: d3-d7/a2/[a3]
		movem.l	(a7)+,d2/d7/a2

		moveq	#0,d1
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

Func_Chunky2Chunky_CLUT12_Map:

		movem.l	a0-a4/a6/d4-d7,-(a7)

		move.l	([conv_mapengine,a5],map_p1table),a2
		lea	(conv_pentab,a5),a6
		lea	([conv_sourcepalette,a5],pal_palette),a4

.map		move.w	(conv_width,a5),d0
		lsr.w	#3,d0
		beq	.skip8
		move.w	d0,a3

		moveq	#0,d0
		moveq	#0,d1
		moveq	#0,d2
		moveq	#0,d3
		moveq	#0,d4
		moveq	#0,d5
		moveq	#0,d6
		moveq	#0,d7

.loop8		move.b	(a0)+,d0
		move.b	(a0)+,d1
		move.b	(a0)+,d2
		move.b	(a0)+,d3
		move.b	(a0)+,d4
		move.b	(a0)+,d5
		move.b	(a0)+,d6
		move.b	(a0)+,d7
		
		move.l	(a4,d0.w*4),d0
		move.l	(a4,d1.w*4),d1
		lsr.l	#4,d0
		move.l	(a4,d2.w*4),d2
		lsr.l	#4,d1
		move.l	(a4,d3.w*4),d3
		lsr.l	#4,d2
		move.l	(a4,d4.w*4),d4
		lsr.l	#4,d3
		move.l	(a4,d5.w*4),d5
		lsr.l	#4,d4
		move.l	(a4,d6.w*4),d6
		lsr.l	#4,d5
		move.l	(a4,d7.w*4),d7

		lsr.l	#4,d6
		lsr.l	#4,d7

		lsl.b	#4,d0
		lsl.b	#4,d1
		lsl.b	#4,d2
		lsl.b	#4,d3
		lsl.b	#4,d4
		lsl.b	#4,d5
		lsl.b	#4,d6
		lsl.b	#4,d7

		lsl.w	#4,d0
		lsl.w	#4,d1
		lsl.w	#4,d2
		lsl.w	#4,d3
		lsl.w	#4,d4
		lsl.w	#4,d5
		lsl.w	#4,d6
		lsl.w	#4,d7

		lsr.l	#8,d0
		lsr.l	#8,d1

		move.b	(a2,d0.l),d0
		lsr.l	#8,d2
		move.b	(a2,d1.l),d1
		lsr.l	#8,d3
		move.b	(a2,d2.l),d2
		lsr.l	#8,d4
		move.b	(a2,d3.l),d3
		lsr.l	#8,d5
		move.b	(a2,d4.l),d4
		lsr.l	#8,d6
		move.b	(a2,d5.l),d5
		lsr.l	#8,d7
		move.b	(a2,d6.l),d6
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
		move.b	(a6,d7.w),(a1)+

		subq.w	#1,a3
		move.w	a3,d3
		bne	.loop8

.skip8		moveq	#7,d1
		and.w	(conv_width,a5),d1
		beq.b	.skip1
		subq.w	#1,d1

		moveq	#0,d0
.loop1		move.b	(a0)+,d0
		move.l	(a4,d0.w*4),d3
		lsr.l	#4,d3
		lsl.b	#4,d3
		lsl.w	#4,d3
		lsr.l	#8,d3
		move.b	(a2,d3.l),d0
		move.b	(a6,d0.w),(a1)+
		dbf	d1,.loop1

.skip1		movem.l	(a7)+,a0-a4/a6/d4-d7
		move.l	(conv_sourceoffset,a5),d0
		move.l	(conv_destoffset,a5),d1
		rts

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

Func_Chunky2Chunky_CLUT15_Map:

		movem.l	a0-a4/a6/d4-d7,-(a7)

		move.l	([conv_mapengine,a5],map_p1table),a2
		lea	(conv_pentab,a5),a6
		lea	([conv_sourcepalette,a5],pal_palette),a4

.map		move.w	(conv_width,a5),d0
		lsr.w	#3,d0
		beq	.skip8
		move.w	d0,a3

		moveq	#0,d0
		moveq	#0,d1
		moveq	#0,d2
		moveq	#0,d3
		moveq	#0,d4
		moveq	#0,d5
		moveq	#0,d6
		moveq	#0,d7

.loop8		move.b	(a0)+,d0
		move.b	(a0)+,d1
		move.b	(a0)+,d2
		move.b	(a0)+,d3
		move.b	(a0)+,d4
		move.b	(a0)+,d5
		move.b	(a0)+,d6
		move.b	(a0)+,d7
		
		move.l	(a4,d0.w*4),d0
		move.l	(a4,d1.w*4),d1
		lsr.l	#3,d0
		move.l	(a4,d2.w*4),d2
		lsr.l	#3,d1
		move.l	(a4,d3.w*4),d3
		lsr.l	#3,d2
		move.l	(a4,d4.w*4),d4
		lsr.l	#3,d3
		move.l	(a4,d5.w*4),d5
		lsr.l	#3,d4
		move.l	(a4,d6.w*4),d6
		lsr.l	#3,d5
		move.l	(a4,d7.w*4),d7

		lsr.l	#3,d6
		lsr.l	#3,d7

		lsl.b	#3,d0
		lsl.b	#3,d1
		lsl.b	#3,d2
		lsl.b	#3,d3
		lsl.b	#3,d4
		lsl.b	#3,d5
		lsl.b	#3,d6
		lsl.b	#3,d7

		lsl.w	#3,d0
		lsl.w	#3,d1
		lsl.w	#3,d2
		lsl.w	#3,d3
		lsl.w	#3,d4
		lsl.w	#3,d5
		lsl.w	#3,d6
		lsl.w	#3,d7

		lsr.l	#6,d0
		lsr.l	#6,d1

		move.b	(a2,d0.l),d0
		lsr.l	#6,d2
		move.b	(a2,d1.l),d1
		lsr.l	#6,d3
		move.b	(a2,d2.l),d2
		lsr.l	#6,d4
		move.b	(a2,d3.l),d3
		lsr.l	#6,d5
		move.b	(a2,d4.l),d4
		lsr.l	#6,d6
		move.b	(a2,d5.l),d5
		lsr.l	#6,d7
		move.b	(a2,d6.l),d6
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
		move.b	(a6,d7.w),(a1)+

		subq.w	#1,a3
		move.w	a3,d3
		bne	.loop8

.skip8		moveq	#7,d1
		and.w	(conv_width,a5),d1
		beq.b	.skip1
		subq.w	#1,d1

		moveq	#0,d0
.loop1		move.b	(a0)+,d0
		move.l	(a4,d0.w*4),d3
		lsr.l	#3,d3
		lsl.b	#3,d3
		lsl.w	#3,d3
		lsr.l	#6,d3
		move.b	(a2,d3.l),d0
		move.b	(a6,d0.w),(a1)+
		dbf	d1,.loop1

.skip1		movem.l	(a7)+,a0-a4/a6/d4-d7
		move.l	(conv_sourceoffset,a5),d0
		move.l	(conv_destoffset,a5),d1
		rts

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

Func_Chunky2Chunky_CLUT18_Map:

		movem.l	a0-a4/a6/d4-d7,-(a7)

		move.l	([conv_mapengine,a5],map_p1table),a2
		lea	(conv_pentab,a5),a6
		lea	([conv_sourcepalette,a5],pal_palette),a4

.map		move.w	(conv_width,a5),d0
		lsr.w	#3,d0
		beq	.skip8
		move.w	d0,a3

		moveq	#0,d0
		moveq	#0,d1
		moveq	#0,d2
		moveq	#0,d3
		moveq	#0,d4
		moveq	#0,d5
		moveq	#0,d6
		moveq	#0,d7

.loop8		move.b	(a0)+,d0
		move.b	(a0)+,d1
		move.b	(a0)+,d2
		move.b	(a0)+,d3
		move.b	(a0)+,d4
		move.b	(a0)+,d5
		move.b	(a0)+,d6
		move.b	(a0)+,d7
		
		move.l	(a4,d0.w*4),d0
		move.l	(a4,d1.w*4),d1
		lsr.l	#2,d0
		move.l	(a4,d2.w*4),d2
		lsr.l	#2,d1
		move.l	(a4,d3.w*4),d3
		lsr.l	#2,d2
		move.l	(a4,d4.w*4),d4
		lsr.l	#2,d3
		move.l	(a4,d5.w*4),d5
		lsr.l	#2,d4
		move.l	(a4,d6.w*4),d6
		lsr.l	#2,d5
		move.l	(a4,d7.w*4),d7

		lsr.l	#2,d6
		lsr.l	#2,d7

		lsl.b	#2,d0
		lsl.b	#2,d1
		lsl.b	#2,d2
		lsl.b	#2,d3
		lsl.b	#2,d4
		lsl.b	#2,d5
		lsl.b	#2,d6
		lsl.b	#2,d7

		lsl.w	#2,d0
		lsl.w	#2,d1
		lsl.w	#2,d2
		lsl.w	#2,d3
		lsl.w	#2,d4
		lsl.w	#2,d5
		lsl.w	#2,d6
		lsl.w	#2,d7

		lsr.l	#4,d0
		lsr.l	#4,d1

		move.b	(a2,d0.l),d0
		lsr.l	#4,d2
		move.b	(a2,d1.l),d1
		lsr.l	#4,d3
		move.b	(a2,d2.l),d2
		lsr.l	#4,d4
		move.b	(a2,d3.l),d3
		lsr.l	#4,d5
		move.b	(a2,d4.l),d4
		lsr.l	#4,d6
		move.b	(a2,d5.l),d5
		lsr.l	#4,d7
		move.b	(a2,d6.l),d6
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
		move.b	(a6,d7.w),(a1)+

		subq.w	#1,a3
		move.w	a3,d3
		bne	.loop8

.skip8		moveq	#7,d1
		and.w	(conv_width,a5),d1
		beq.b	.skip1
		subq.w	#1,d1

		moveq	#0,d0
.loop1		move.b	(a0)+,d0
		move.l	(a4,d0.w*4),d3
		lsr.l	#2,d3
		lsl.b	#2,d3
		lsl.w	#2,d3
		lsr.l	#4,d3
		move.b	(a2,d3.l),d0
		move.b	(a6,d0.w),(a1)+
		dbf	d1,.loop1

.skip1		movem.l	(a7)+,a0-a4/a6/d4-d7
		move.l	(conv_sourceoffset,a5),d0
		move.l	(conv_destoffset,a5),d1
		rts


;------------------------------------------------------------------------

		



;------------------------------------------------------------------------

;------------------------------------------------------------------------

PrepareDitherLine_Chunky

		move.l	a6,-(a7)
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


		lea	([conv_sourcepalette,a5],pal_wordpalette),a6

		lsr.w	#2,d7
		beq	.no4

		subq.w	#1,d7
	
		
.addRGBloop4	moveq	#0,d0
		move.b	(a0)+,d0
		move.w	d0,d4
		add.w	d0,d0
		add.w	d4,d0

		moveq	#0,d1
		move.b	(a0)+,d1
		move.w	d1,d4
		add.w	d1,d1
		add.w	d4,d1

		moveq	#0,d2
		move.b	(a0)+,d2
		move.w	d2,d4
		add.w	d2,d2
		add.w	d4,d2

		moveq	#0,d3
		move.b	(a0)+,d3
		move.w	d3,d4
		add.w	d3,d3
		add.w	d4,d3

		move.w	(a6,d0.w*2),d4
		swap	d4
		move.w	2(a6,d0.w*2),d5
		swap	d5
		move.w	4(a6,d0.w*2),d6
		swap	d6
		move.w	(a6,d1.w*2),d4
		swap	d4
		move.w	2(a6,d1.w*2),d5
		swap	d5
		move.w	4(a6,d1.w*2),d6
		swap	d6

		move.w	(a6,d2.w*2),d0
		swap	d0
		move.w	2(a6,d2.w*2),d1
		swap	d1
		move.w	4(a6,d2.w*2),d2
		swap	d2
		move.w	(a6,d3.w*2),d0
		swap	d0
		move.w	2(a6,d3.w*2),d1
		swap	d1
		move.w	4(a6,d3.w*2),d2
		swap	d2
		
		add.w	d4,(a4)+
		add.w	d5,(a4)+
		swap	d4
		add.w	d6,(a4)+
		swap	d5
		add.w	d4,(a4)+
		swap	d6
		add.w	d5,(a4)+
		add.w	d6,(a4)+

		add.w	d0,(a4)+
		add.w	d1,(a4)+
		swap	d0
		add.w	d2,(a4)+
		swap	d1
		add.w	d0,(a4)+
		swap	d2
		add.w	d1,(a4)+
		add.w	d2,(a4)+

		dbf	d7,.addRGBloop4

.no4		moveq	#3,d7
		and.w	(a7),d7
		beq.b	.no1

.lop1		moveq	#0,d0
		move.b	(a0)+,d0

		move.w	d0,d4
		add.w	d0,d0
		add.w	d4,d0

		movem.w	(a6,d0.w*2),d4/d5/d6
		add.w	d4,(a4)+
		add.w	d5,(a4)+
		add.w	d6,(a4)+

		subq.w	#1,d7
		bne.b	.lop1

.no1		st	(conv_firstpixel,a5)

		move.w	(a7)+,d7
		move.l	(a7)+,a6
		rts

;==============================================================================



;         /\
;    ____/  \____   
;    \   \  /|  /
;==== \   \/ | / =========================================================
;----- \   | |/ ----------------------------------------------------------
;       \  | /
;        \ |/	CreateChunkyConversionTable
;         \/	
;		erzeugt eine Konvertierungstabelle, die geeignet
;		ist, ein ChunkyImage (mit Palette) auf eine neue
;		Palette zu adaptieren. Dabei kann zusätzlich auch
;		noch eine Pen-Konvertierung vorgenommen werden.
;
;	>	a0	UBYTE *		ChunkyImage
;		a1	ULONG *		OriginalPalette
;		a2	ULONG *		NewPalette
;		a3	UBYTE *		Pentab oder NULL
;		a4	UBYTE *		Ziel-Konvertierungstabelle (256 Einträge)
;		d0	UWORD		Width
;		d1	UWORD		Height
;		d2	UWORD		TotalWidth
;	[	d3	UWORD		Anzahl Farben in der neuen Palette	]
;
;------------------------------------------------------------------------

	STRUCTURE	ccct_localdata,0
		APTR	ccct_chunky
		APTR	ccct_orgpalette
		APTR	ccct_pentab
		APTR	ccct_desttab
		STRUCT	ccct_convtab,256*2
		UWORD	ccct_width
		UWORD	ccct_height
		UWORD	ccct_modulo
		UWORD	ccct_numcolors
	LABEL		ccct_SIZEOF
	
;------------------------------------------------------------------------

CreateChunkyConversionTable:

		LockShared	pal_semaphore(a1)
		LockShared	pal_semaphore(a2)

		movem.l	d2-d7/a1-a6,-(a7)

		sub.w	#ccct_SIZEOF,a7
		move.l	a7,a6

		sub.w	d0,d2
		move.w	d2,(ccct_modulo,a6)
		move.w	d0,(ccct_width,a6)
		move.w	d1,(ccct_height,a6)
		move.w	(pal_numcolors,a2),d3
		move.w	d3,(ccct_numcolors,a6)
		move.l	a0,(ccct_chunky,a6)
		lea	(pal_palette,a1),a1
		move.l	a1,(ccct_orgpalette,a6)
		move.l	a3,(ccct_pentab,a6)
		move.l	a4,(ccct_desttab,a6)

		lea	(pal_wordpalette,a2),a2

		lea	(ccct_convtab,a6),a0
		move.l	#256*2,d0
		moveq	#-1,d1
		bsr	TurboFillMem				; convtab ungültig machen

		move.l	(ccct_chunky,a6),a0
		lea	(ccct_convtab,a6),a1
		moveq	#0,d2
		lea	(quadtab,pc),a3				; Diversitytab


.yloop		move.w	(ccct_width,a6),d7
		subq.w	#1,d7

.xloop		move.b	(a0)+,d2				; Chunky
		move.w	(a1,d2.l*2),d0				; Pen konvertieren
		dbmi	d7,.xloop

		tst.w	d7
		bmi.b	.xok

		movem.l	a2/d7,-(a7)
		move.l	([ccct_orgpalette,a6],d2.w*4),d0	; gesuchter RGB
		move.w	(ccct_numcolors,a6),d4			; anz. Farben
		FINDPEN_PALETTE
		movem.l	(a7)+,a2/d7

		moveq	#0,d2
		move.b	-1(a0),d2
		
		move.w	d0,(a1,d2.l*2)
		dbf	d7,.xloop

.xok		add.w	(ccct_modulo,a6),a0
		subq.w	#1,(ccct_height,a6)
		bne	.yloop

		lea	(ccct_convtab,a6),a0
		move.l	(ccct_desttab,a6),a1
		moveq	#256/4-1,d4

		move.l	(ccct_pentab,a6),d0
		beq.b	.coplop2
		move.l	d0,a5

		; nach Ziel kopieren (mit zusätzlicher Konvertierung)

.coplop		move.w	(a0)+,d0
		move.w	(a0)+,d1
		move.w	(a0)+,d2
		move.w	(a0)+,d3
		move.b	(a5,d0.w),(a1)+
		move.b	(a5,d1.w),(a1)+
		move.b	(a5,d2.w),(a1)+
		move.b	(a5,d3.w),(a1)+
		dbf	d4,.coplop
		bra.b	.ok

		; nach Ziel kopieren (ohne zusätzliche Konvertierung)

.coplop2	move.w	(a0)+,d0
		move.w	(a0)+,d1
		move.w	(a0)+,d2
		move.w	(a0)+,d3
		move.b	d0,(a1)+
		move.b	d1,(a1)+
		move.b	d2,(a1)+
		move.b	d3,(a1)+
		dbf	d4,.coplop2

.ok		add.w	#ccct_SIZEOF,a7
		movem.l	(a7)+,d2-d7/a1-a6

		Unlock		pal_semaphore(a2)
		Unlock		pal_semaphore(a1)
		rts

;------------------------------------------------------------------------


;         /\
;    ____/  \____   
;    \   \  /|  /
;==== \   \/ | / =========================================================
;----- \   | |/ ----------------------------------------------------------
;       \  | /
;        \ |/	Planar2Chunky
;         \/
;		Konvertiert Bitplanes in Chunky8.
;
;	>	a0	PLANEPTR *	Zeiger auf Planepointer-Tabelle
;		a1	UBYTE *		Zeiger auf Chunky-Buffer
;		d0	UWORD		Breite [Bytes, gerade]
;		d1	UWORD		Höhe [Zeilen]
;		d2	UWORD		Anzahl Bitplanes [1-8]
;		d3	UWORD		BytesPerRow [Bytes, gerade]
;		d4	UWORD		TotalChunkyWidth [Pixels]
;
;------------------------------------------------------------------------

Planar2Chunky:	movem.l	d0-d7/a0-a6,-(a7)

		move.w	d0,d7
		lsl.w	#3,d7		; Pixel
		neg.w	d7
		add.w	d4,d7		; ergibt Dest-Modulo
		move.w	d7,-(a7)	; Dest-Modulo: 12(a7) in Unterprg


		sub.w	d0,d3
		move.w	d3,d6

		subq.w	#1,d1
		move.w	d1,d5		; Durchläufe Zeilen

		lsr.w	#1,d0
		subq.w	#1,d0		; Durchläufe Words

		move.l	a1,d1
		movem.l	(a0)+,a1-a6

		move.l	(a0)+,-(a7)	; Plane 7: 8(a7) in Unterprg
		move.l	(a0)+,-(a7)	; Plane 8: 4(a7) in Unterprg
		move.l	d1,a0

		add.w	d2,d2
		move.w	(b2c_offstab-2,pc,d2.w),d2
		jsr	(bpl2chunky1,pc,d2.w)

		add.w	#10,a7
		movem.l	(a7)+,d0-d7/a0-a6
		rts

b2c_offstab	dc.w	bpl2chunky1-bpl2chunky1
		dc.w	bpl2chunky2-bpl2chunky1
		dc.w	bpl2chunky3-bpl2chunky1
		dc.w	bpl2chunky4-bpl2chunky1
		dc.w	bpl2chunky5-bpl2chunky1
		dc.w	bpl2chunky6-bpl2chunky1
		dc.w	bpl2chunky7-bpl2chunky1
		dc.w	bpl2chunky8-bpl2chunky1

;---------------------------------------------------------------------

bpl2chunky1:	move.w	d0,d4

b2c1_xlop	move.w	(a1)+,d2
		rept	16
		moveq	#0,d7
		add.w	d2,d2
		addx.b	d7,d7
		move.b	d7,(a0)+
		endr
		dbf	d4,b2c1_xlop
		add.w	12(a7),a0

		add.w	d6,a1
		dbf	d5,bpl2chunky1

		rts

;---------------------------------------------------------------------

bpl2chunky2:	move.w	d0,d7

b2c2_xlop	move.w	(a1)+,d3
		move.w	(a2)+,d2
		rept	16
		moveq	#0,d4
		add.w	d2,d2
		addx.b	d4,d4
		add.w	d3,d3
		addx.b	d4,d4
		move.b	d4,(a0)+
		endr
		dbf	d7,b2c2_xlop
		add.w	12(a7),a0

		add.w	d6,a1
		add.w	d6,a2
		dbf	d5,bpl2chunky2
		rts

;---------------------------------------------------------------------

bpl2chunky3:	move.w	d0,d1

b2c3_xlop	move.w	(a1)+,d4
		move.w	(a2)+,d3
		move.w	(a3)+,d2
		rept	16
		moveq	#0,d7
		add.w	d2,d2
		addx.b	d7,d7
		add.w	d3,d3
		addx.b	d7,d7
		add.w	d4,d4
		addx.b	d7,d7
		move.b	d7,(a0)+
		endr
		dbf	d1,b2c3_xlop
		add.w	12(a7),a0

		add.w	d6,a1
		add.w	d6,a2
		add.w	d6,a3
		dbf	d5,bpl2chunky3
		rts

;---------------------------------------------------------------------

bpl2chunky4:	swap	d5

		move.w	d0,d7

b2c4_xlop	move.w	(a1)+,d5
		move.w	(a2)+,d4
		move.w	(a3)+,d3
		move.w	(a4)+,d2
		rept	16
		moveq	#0,d1
		add.w	d2,d2
		addx.b	d1,d1
		add.w	d3,d3
		addx.b	d1,d1
		add.w	d4,d4
		addx.b	d1,d1
		add.w	d5,d5
		addx.b	d1,d1
		move.b	d1,(a0)+
		endr
		dbf	d7,b2c4_xlop
		add.w	12(a7),a0

		add.w	d6,a1
		add.w	d6,a2
		add.w	d6,a3
		add.w	d6,a4

		swap	d5
		dbf	d5,bpl2chunky4
		rts

;---------------------------------------------------------------------

bpl2chunky5:	swap	d5

		move.w	d0,d1

		swap	d6
b2c5_xlop	move.w	(a1)+,d6
		move.w	(a2)+,d5
		move.w	(a3)+,d4
		move.w	(a4)+,d3
		move.w	(a5)+,d2
		rept	16
		moveq	#0,d7
		add.w	d2,d2
		addx.b	d7,d7
		add.w	d3,d3
		addx.b	d7,d7
		add.w	d4,d4
		addx.b	d7,d7
		add.w	d5,d5
		addx.b	d7,d7
		add.w	d6,d6
		addx.b	d7,d7
		move.b	d7,(a0)+
		endr
		dbf	d1,b2c5_xlop
		add.w	12(a7),a0

		swap	d6

		add.w	d6,a1
		add.w	d6,a2
		add.w	d6,a3
		add.w	d6,a4
		add.w	d6,a5

		swap	d5
		dbf	d5,bpl2chunky5
		rts

;---------------------------------------------------------------------

bpl2chunky6:	swap	d5

		move.w	d0,d7

		swap	d6
b2c6_xlop	move.w	(a1)+,d6
		move.w	(a2)+,d5
		move.w	(a3)+,d4
		move.w	(a4)+,d3
		move.w	(a5)+,d2
		move.w	(a6)+,d1
		swap	d7
		rept	16
		clr.w	d7
		add.w	d1,d1
		addx.b	d7,d7
		add.w	d2,d2
		addx.b	d7,d7
		add.w	d3,d3
		addx.b	d7,d7
		add.w	d4,d4
		addx.b	d7,d7
		add.w	d5,d5
		addx.b	d7,d7
		add.w	d6,d6
		addx.b	d7,d7
		move.b	d7,(a0)+
		endr
		swap	d7
		dbf	d7,b2c6_xlop
		add.w	12(a7),a0

		swap	d6

		add.w	d6,a1
		add.w	d6,a2
		add.w	d6,a3
		add.w	d6,a4
		add.w	d6,a5
		add.w	d6,a6

		swap	d5
		dbf	d5,bpl2chunky6
		rts

;---------------------------------------------------------------------

bpl2chunky7:	swap	d5

		move.w	d0,d4
		swap	d0
		swap	d6
b2c7_xlop	swap	d4
		move.l	a0,d1
		move.l	8(a7),a0
		move.w	(a0)+,d7
		move.l	a0,8(a7)
		move.l	d1,a0
		move.w	(a1)+,d1
		move.w	(a2)+,d2
		move.w	(a3)+,d3
		move.w	(a4)+,d4
		move.w	(a5)+,d5
		move.w	(a6)+,d6
		rept	16
		clr.w	d0
		add.w	d7,d7
		addx.b	d0,d0
		add.w	d6,d6
		addx.b	d0,d0
		add.w	d5,d5
		addx.b	d0,d0
		add.w	d4,d4
		addx.b	d0,d0
		add.w	d3,d3
		addx.b	d0,d0
		add.w	d2,d2
		addx.b	d0,d0
		add.w	d1,d1
		addx.b	d0,d0
		move.b	d0,(a0)+
		endr
		swap	d4
		dbf	d4,b2c7_xlop
		add.w	12(a7),a0

		swap	d6
		swap	d0

		add.w	d6,a1
		add.w	d6,a2
		add.w	d6,a3
		add.w	d6,a4
		add.w	d6,a5
		add.w	d6,a6
		ext.l	d6
		add.l	d6,8(a7)

		swap	d5
		dbf	d5,bpl2chunky7
		rts

;---------------------------------------------------------------------

bpl2chunky8:	swap	d5

		move.w	d0,d4
		swap	d0
		swap	d6
b2c8_xlop	swap	d4
		move.l	a0,d1
		move.l	8(a7),a0
		move.w	(a0)+,d7
		move.l	a0,8(a7)
		move.l	4(a7),a0
		swap	d7
		move.w	(a0)+,d7
		move.l	a0,4(a7)
		move.l	d1,a0
		move.w	(a1)+,d1
		move.w	(a2)+,d2
		move.w	(a3)+,d3
		move.w	(a4)+,d4
		move.w	(a5)+,d5
		move.w	(a6)+,d6
		rept	16
		add.w	d7,d7
		addx.b	d0,d0
		swap	d7
		add.w	d7,d7
		swap	d7
		addx.b	d0,d0
		add.w	d6,d6
		addx.b	d0,d0
		add.w	d5,d5
		addx.b	d0,d0
		add.w	d4,d4
		addx.b	d0,d0
		add.w	d3,d3
		addx.b	d0,d0
		add.w	d2,d2
		addx.b	d0,d0
		add.w	d1,d1
		addx.b	d0,d0
		move.b	d0,(a0)+
		endr
		swap	d4
		dbf	d4,b2c8_xlop
		add.w	12(a7),a0

		swap	d6
		swap	d0

		add.w	d6,a1
		add.w	d6,a2
		add.w	d6,a3
		add.w	d6,a4
		add.w	d6,a5
		add.w	d6,a6
		ext.l	d6
		add.l	d6,8(a7)
		add.l	d6,4(a7)

		swap	d5
		dbf	d5,bpl2chunky8
		rts

;=====================================================================


;         /\
;    ____/  \____   
;    \   \  /|  /
;==== \   \/ | / =========================================================
;----- \   | |/ ----------------------------------------------------------
;       \  | /
;        \ |/	Chunky2Bitmap
;         \/
;		Konvertiert rohe Chunky-Daten über eine initialisierte
;		BitMap-Struktur in Bitplanes. Es kann ein Ausschnitt
;		gewählt werden, der pixelgenau in die bestehenden
;		Bitplanes verknüpft wird.
;
;	>	a0	UBYTE *		Data		Chunky-Daten
;		a1	struct BitMap *	BitMap		BitMap-Struktur
;		a2	UBYTE *		PenTab		initialisierte Pen-Tabelle oder NULL
;		d0	UWORD		TotalWidth	Breite der Chunkydaten
;		d1	UWORD		SrcX		Start-X in Chunkydaten
;		d2	UWORD		SrcY		Start-Y in Chunkydaten
;		d3	UWORD		Width		Breite des Ausschnitts
;		d4	UWORD		Height		Höhe des Ausschnitts
;		d5	UWORD		DstX		Start-X in Bitmap
;		d6	UWORD		DstY		Start-Y in Bitmap
;
;------------------------------------------------------------------------

		include	"graphics/gfx.i"

;---------------------------------------------------------------------

	STRUCTURE	c2bs_localdata,0
		APTR	c2bs_data
		APTR	c2bs_pentab
		UWORD	c2bs_totwidth
		UWORD	c2bs_srcx
		UWORD	c2bs_srcy
		UWORD	c2bs_width
		UWORD	c2bs_height
		UWORD	c2bs_dstx
		UWORD	c2bs_dsty
		UWORD	c2bs_numcolors
		UWORD	c2bs_depth
		APTR	c2bs_planetab
		UWORD	c2bs_cmodulo
		UWORD	c2bs_bmodulo
		UWORD	c2bs_bytesperrow
		APTR	c2bs_plane5
		APTR	c2bs_plane6
		APTR	c2bs_plane7
		APTR	c2bs_plane8
		STRUCT	c2bs_tab,256
	LABEL		c2bs_SIZEOF

;---------------------------------------------------------------------

Chunky2Bitmap:	movem.l	d0-d7/a0-a6,-(a7)

; -  -  -- - - -  - - --  - -- - -   - --  -  - - - -- - -- - - -- - -
;
;		Struktur anlegen und füttern


		sub.w	#c2bs_SIZEOF,a7
		move.l	a7,a6


		; Parameter eintragen (1)

		move.l	a0,(c2bs_data,a6)		; Eingangsdaten
		move.w	d0,(c2bs_totwidth,a6)		; Gesamtbreite
		sub.w	d3,d0
		move.w	d0,(c2bs_cmodulo,a6)		; Chunky-Modulo
		move.w	d4,(c2bs_height,a6)		; Höhe


		; Pentab vorhanden?

		move.l	a2,d7
		beq.b	c2b_default

		move.b	(bm_Depth,a1),d0
		cmp.b	#8,d0			; bei 8 planes
		beq.b	c2b_pentabOK		; pentab direkt benutzen


		; Eigene Pentab konvertieren


		lea	(c2bs_tab,a6),a5
		moveq	#31,d7
c2b_shiftlop	
		REPT	8
		move.b	(a2)+,d4
		ror.b	d0,d4
		move.b	d4,(a5)+
		ENDR
		dbf	d7,c2b_shiftlop

		lea	(c2bs_tab,a6),a5
		move.l	a5,d7
		bra.b	c2b_pentabOK


c2b_default	; Default-Pentab benutzen

		move.b	(bm_Depth,a1),d7
		move.l	(c2b_pentabtab-4,pc,d7.w*4),d7


c2b_pentabOK	; Parameter eintragen (2)

		move.l	d7,(c2bs_pentab,a6)
		move.w	d1,(c2bs_srcx,a6)
		move.w	d2,(c2bs_srcy,a6)
		move.w	d3,(c2bs_width,a6)
		move.w	d5,(c2bs_dstx,a6)
		move.w	d6,(c2bs_dsty,a6)

		move.w	(bm_BytesPerRow,a1),d7		; BytesPerRow
		move.w	d7,(c2bs_bytesperrow,a6)

		moveq	#0,d4				; Depth
		move.b	(bm_Depth,a1),d4
		move.w	d4,(c2bs_depth,a6)

		moveq	#1,d0				; NumColors
		lsl.w	d4,d0
		move.w	d0,(c2bs_numcolors,a6)

		addq.w	#bm_Planes,a1			; PlaneTab
		move.l	a1,(c2bs_planetab,a6)

		add.w	d5,d3				; Bitmap-Modulo
		lsr.w	#4,d5
		add.w	#15,d3
		lsr.w	#4,d3
		sub.w	d5,d3
		add.w	d3,d3
		sub.w	d3,d7
		move.w	d7,(c2bs_bmodulo,a6)

; -  -  -- - - -  - - --  - -- - -   - --  -  - - - -- - -- - - -- - -
;
;		d0: BitPlane-Startoffset berechnen
;		a0: Chunky-Startadresse berechnen


		move.w	(c2bs_dsty,a6),d0
		mulu.w	(c2bs_bytesperrow,a6),d0

		moveq	#0,d1
		move.w	(c2bs_dstx,a6),d1
		lsr.w	#4,d1
		add.w	d1,d1
		add.l	d1,d0			; Startoffset auf Bitplanes


		move.w	(c2bs_srcy,a6),d1
		mulu.w	(c2bs_totwidth,a6),d1
		move.l	(c2bs_data,a6),a0
		add.l	d1,a0
		add.w	(c2bs_srcx,a6),a0	; fertige Startadresse Chunky


; -  -  -- - - -  - - --  - -- - -   - --  -  - - - -- - -- - - -- - -
;
;		über Sprungtabelle in plane-anzahl-spezifische
;		Konvertierungsschleife springen


		move.w	(c2bs_depth,a6),d1
		add.w	d1,d1
		move.w	(c2bpl_offstab-2,pc,d1.w),d1
		jsr	(chunky2bpl1,pc,d1.w)

; -  -  -- - - -  - - --  - -- - -   - --  -  - - - -- - -- - - -- - -

		add.w	#c2bs_SIZEOF,a7

		movem.l	(a7)+,d0-d7/a0-a6
		rts

;---------------------------------------------------------------------

c2bpl_offstab	dc.w	chunky2bpl1-chunky2bpl1
		dc.w	chunky2bpl2-chunky2bpl1
		dc.w	chunky2bpl3-chunky2bpl1
		dc.w	chunky2bpl4-chunky2bpl1
		dc.w	chunky2bpl5-chunky2bpl1
		dc.w	chunky2bpl6-chunky2bpl1
		dc.w	chunky2bpl7-chunky2bpl1
		dc.w	chunky2bpl8-chunky2bpl1

;---------------------------------------------------------------------

chunky2bpl1	move.l	(c2bs_pentab,a6),a5

		move.l	(c2bs_planetab,a6),a1
		move.l	(a1),a1			; Plane 1

		add.l	d0,a1			; + Offset = Startadresse

; -  -  -- - - -  - - --  - -- - -   - --  -  - - - -- - -- - - -- - -
;
;		Zeilen-Schleife


		move.w	(c2bs_height,a6),d3	; Schleifenzähler
		subq.w	#1,d3

c2b1_lineloop	move.w	(c2bs_width,a6),d5	; Restbreite

; -  -  -- - - -  - - --  - -- - -   - --  -  - - - -- - -- - - -- - -
;
;		erstes Word behandeln


		move.w	(c2bs_dstx,a6),d6
		moveq	#15,d7
		and.w	d7,d6
		beq.b	c2b1_no1stword		; Anfang exakt auf Wordgrenze

		sub.w	d6,d7			; Anz. Pixel im ersten Word - 1

		moveq	#-2,d4
		lsl.w	d7,d4			; Maske für erstes Word

		subq.w	#1,d5
		sub.w	d7,d5			; verbleibende Pixel
		bpl.b	c2b1_1stwordok		; 0 oder mehr übrig, ok

		neg.w	d5
		sub.w	d5,d7			; Anzahl Durchläufe korrigieren
		moveq	#-1,d6
		clr.w	d6
		rol.l	d5,d6
		or.w	d6,d4			; Maske, z.B. 1110000000011111
		neg.w	d5

c2b1_1stwordok	and.w	d4,(a1)			; unsere Bits wegmaskieren

		moveq	#0,d0
		moveq	#0,d1
c2b1_1stword	move.b	(a0)+,d0		; Chunky holen
		move.b	(a5,d0.w),d0		; konvertieren
		add.b	d0,d0
		addx.w	d1,d1			; Plane 1
		dbf	d7,c2b1_1stword

		tst.w	d5			; noch Pixel übrig?
		bpl.b	c2b1_noshift		; ja, 0 oder mehr

		neg.w	d5
		lsl.w	d5,d1			; weitershiften
		moveq	#0,d5			; keine weiteren Pixel mehr

c2b1_noshift	or.w	d1,(a1)+		; unsere Bits reinmaskieren

c2b1_no1stword

; -  -  -- - - -  - - --  - -- - -   - --  -  - - - -- - -- - - -- - -
;
;		Words auf 16er-Grenzen behandeln


		move.w	d5,d7
		lsr.w	#4,d7
		subq.w	#1,d7
		bmi.w	c2b1_no16

		moveq	#0,d0
c2b1_16loop	
		REPT	16
		move.b	(a0)+,d0		; Chunky holen
		move.b	(a5,d0.w),d0		; konvertieren
		add.b	d0,d0
		addx.w	d1,d1			; Plane 1
		ENDR
		move.w	d1,(a1)+
		sub.w	#16,d5
		dbf	d7,c2b1_16loop

c2b1_no16

; -  -  -- - - -  - - --  - -- - -   - --  -  - - - -- - -- - - -- - -
;
;		letztes Word behandeln


		subq.w	#1,d5
		bmi.b	c2b1_nolastword

		moveq	#15,d7
		sub.w	d5,d7

		moveq	#-1,d4			; lastword-Maske bilden
		lsr.w	d5,d4
		lsr.w	#1,d4

		and.w	d4,(a1)			; unsere Bits wegmaskieren

		moveq	#0,d0
		moveq	#0,d1
c2b1_lastword	move.b	(a0)+,d0		; Chunky holen
		move.b	(a5,d0.w),d0		; konvertieren
		add.b	d0,d0
		addx.w	d1,d1			; Plane 1
		dbf	d5,c2b1_lastword

		lsl.w	d7,d1			; zurechtschieben
		or.w	d1,(a1)+

c2b1_nolastword

; -  -  -- - - -  - - --  - -- - -   - --  -  - - - -- - -- - - -- - -

		add.w	(c2bs_cmodulo,a6),a0	; Data + ChunkyModulo

		move.w	(c2bs_bmodulo,a6),d0	; BitmapModulo
		add.w	d0,a1
		add.w	d0,a2

		dbf	d3,c2b1_lineloop

		rts

;---------------------------------------------------------------------

chunky2bpl2	move.l	(c2bs_pentab,a6),a5

		move.l	(c2bs_planetab,a6),a3
		move.l	(a3)+,a1		; Plane 1
		move.l	(a3)+,a2		; Plane 2
		add.l	d0,a1			; fertige Startadressen
		add.l	d0,a2

; -  -  -- - - -  - - --  - -- - -   - --  -  - - - -- - -- - - -- - -
;
;		Zeilen-Schleife


		move.w	(c2bs_height,a6),d3	; Schleifenzähler
		subq.w	#1,d3

c2b2_lineloop	move.w	(c2bs_width,a6),d5	; Restbreite

; -  -  -- - - -  - - --  - -- - -   - --  -  - - - -- - -- - - -- - -
;
;		erstes Word behandeln


		move.w	(c2bs_dstx,a6),d6
		moveq	#15,d7
		and.w	d7,d6
		beq.b	c2b2_no1stword		; Anfang exakt auf Wordgrenze

		sub.w	d6,d7			; Anz. Pixel im ersten Word - 1

		moveq	#-2,d4
		lsl.w	d7,d4			; Maske für erstes Word

		subq.w	#1,d5
		sub.w	d7,d5			; verbleibende Pixel
		bpl.b	c2b2_1stwordok		; 0 oder mehr übrig, ok

		neg.w	d5
		sub.w	d5,d7			; Anzahl Durchläufe korrigieren
		moveq	#-1,d6
		clr.w	d6
		rol.l	d5,d6
		or.w	d6,d4			; Maske, z.B. 1110000000011111
		neg.w	d5

c2b2_1stwordok	and.w	d4,(a1)			; unsere Bits wegmaskieren
		and.w	d4,(a2)

		moveq	#0,d0
		moveq	#0,d1			; explizit nötig, weil weniger
		moveq	#0,d2			; als 16 Durchläufe

c2b2_1stword	move.b	(a0)+,d0		; Chunky holen
		move.b	(a5,d0.w),d0		; konvertieren
		add.b	d0,d0
		addx.w	d2,d2			; Plane 2
		add.b	d0,d0
		addx.w	d1,d1			; Plane 1
		dbf	d7,c2b2_1stword

		tst.w	d5			; noch Pixel übrig?
		bpl.b	c2b2_noshift		; ja, 0 oder mehr

		neg.w	d5
		lsl.w	d5,d1			; weitershiften
		lsl.w	d5,d2
		moveq	#0,d5			; keine weiteren Pixel mehr

c2b2_noshift	or.w	d1,(a1)+		; unsere Bits reinmaskieren
		or.w	d2,(a2)+


c2b2_no1stword

; -  -  -- - - -  - - --  - -- - -   - --  -  - - - -- - -- - - -- - -
;
;		Words auf 16er-Grenzen behandeln


		move.w	d5,d7
		lsr.w	#4,d7
		subq.w	#1,d7
		bmi.w	c2b2_no16

		moveq	#0,d0
c2b2_16loop	
		REPT	16
		move.b	(a0)+,d0		; Chunky holen
		move.b	(a5,d0.w),d0		; konvertieren
		add.b	d0,d0
		addx.w	d2,d2			; Plane 2
		add.b	d0,d0
		addx.w	d1,d1			; Plane 1
		ENDR
		move.w	d1,(a1)+
		move.w	d2,(a2)+
		sub.w	#16,d5
		dbf	d7,c2b2_16loop

c2b2_no16	

; -  -  -- - - -  - - --  - -- - -   - --  -  - - - -- - -- - - -- - -
;
;		letztes Word behandeln


		subq.w	#1,d5
		bmi.b	c2b2_nolastword

		moveq	#15,d7
		sub.w	d5,d7

		moveq	#-1,d4			; lastword-Maske bilden
		lsr.w	d5,d4
		lsr.w	#1,d4

		and.w	d4,(a1)			; unsere Bits wegmaskieren
		and.w	d4,(a2)

		moveq	#0,d0
		moveq	#0,d1
		moveq	#0,d2
c2b2_lastword	move.b	(a0)+,d0		; Chunky holen
		move.b	(a5,d0.w),d0		; konvertieren
		add.b	d0,d0
		addx.w	d2,d2			; Plane 2
		add.b	d0,d0
		addx.w	d1,d1			; Plane 1
		dbf	d5,c2b2_lastword

		lsl.w	d7,d1			; zurechtschieben
		lsl.w	d7,d2
		or.w	d1,(a1)+
		or.w	d2,(a2)+


c2b2_nolastword

; -  -  -- - - -  - - --  - -- - -   - --  -  - - - -- - -- - - -- - -

		add.w	(c2bs_cmodulo,a6),a0	; Data + ChunkyModulo

		move.w	(c2bs_bmodulo,a6),d0	; BitmapModulo
		add.w	d0,a1
		add.w	d0,a2

		dbf	d3,c2b2_lineloop

		rts

;---------------------------------------------------------------------

chunky2bpl3	move.l	(c2bs_pentab,a6),a5

; -  -  -- - - -  - - --  - -- - -   - --  -  - - - -- - -- - - -- - -
;
;		BitPlane-Startadresse berechnen


		move.l	(c2bs_planetab,a6),a4
		movem.l	(a4),a1-a3		; Planes 1,2,3
		add.l	d0,a1			; fertige Startadressen
		add.l	d0,a2
		add.l	d0,a3

; -  -  -- - - -  - - --  - -- - -   - --  -  - - - -- - -- - - -- - -
;
;		Zeilen-Schleife


		move.w	(c2bs_height,a6),a4	; Schleifenzähler


c2b3_lineloop	move.w	(c2bs_width,a6),d5	; Restbreite


; -  -  -- - - -  - - --  - -- - -   - --  -  - - - -- - -- - - -- - -
;
;		erstes Word behandeln


		move.w	(c2bs_dstx,a6),d6
		moveq	#15,d7
		and.w	d7,d6
		beq.b	c2b3_no1stword		; Anfang exakt auf Wordgrenze

		sub.w	d6,d7			; Anz. Pixel im ersten Word - 1

		moveq	#-2,d4
		lsl.w	d7,d4			; Maske für erstes Word

		subq.w	#1,d5
		sub.w	d7,d5			; verbleibende Pixel
		bpl.b	c2b3_1stwordok		; 0 oder mehr übrig, ok

		neg.w	d5
		sub.w	d5,d7			; Anzahl Durchläufe korrigieren
		moveq	#-1,d6
		clr.w	d6
		rol.l	d5,d6
		or.w	d6,d4			; Maske, z.B. 1110000000011111
		neg.w	d5

c2b3_1stwordok	and.w	d4,(a1)			; unsere Bits wegmaskieren
		and.w	d4,(a2)
		and.w	d4,(a3)


		moveq	#0,d0
		moveq	#0,d1			; explizit nötig, weil weniger
		moveq	#0,d2			; als 16 Durchläufe
		moveq	#0,d3

c2b3_1stword	move.b	(a0)+,d0		; Chunky holen
		move.b	(a5,d0.w),d0		; konvertieren
		add.b	d0,d0
		addx.w	d3,d3			; Plane 3
		add.b	d0,d0
		addx.w	d2,d2			; Plane 2
		add.b	d0,d0
		addx.w	d1,d1			; Plane 1
		dbf	d7,c2b3_1stword

		tst.w	d5			; noch Pixel übrig?
		bpl.b	c2b3_noshift		; ja, 0 oder mehr

		neg.w	d5
		lsl.w	d5,d1			; weitershiften
		lsl.w	d5,d2
		lsl.w	d5,d3
		moveq	#0,d5			; keine weiteren Pixel mehr

c2b3_noshift	or.w	d1,(a1)+		; unsere Bits reinmaskieren
		or.w	d2,(a2)+
		or.w	d3,(a3)+


c2b3_no1stword

; -  -  -- - - -  - - --  - -- - -   - --  -  - - - -- - -- - - -- - -
;
;		Words auf 16er-Grenzen behandeln


		move.w	d5,d7
		lsr.w	#4,d7
		subq.w	#1,d7
		bmi.w	c2b3_no16

		moveq	#0,d0
c2b3_16loop	moveq	#1,d6
c2b3_16loop2	
		REPT	8
		move.b	(a0)+,d0		; Chunky holen
		move.b	(a5,d0.w),d0		; konvertieren
		add.b	d0,d0
		addx.w	d3,d3			; Plane 3
		add.b	d0,d0
		addx.w	d2,d2			; Plane 2
		add.b	d0,d0
		addx.w	d1,d1			; Plane 1
		ENDR
		dbf	d6,c2b3_16loop2
		move.w	d1,(a1)+
		move.w	d2,(a2)+
		move.w	d3,(a3)+
		sub.w	#16,d5
		dbf	d7,c2b3_16loop

c2b3_no16	

; -  -  -- - - -  - - --  - -- - -   - --  -  - - - -- - -- - - -- - -
;
;		letztes Word behandeln


		subq.w	#1,d5
		bmi.b	c2b3_nolastword

		moveq	#15,d7
		sub.w	d5,d7

		moveq	#-1,d4			; lastword-Maske bilden
		lsr.w	d5,d4
		lsr.w	#1,d4

		and.w	d4,(a1)			; unsere Bits wegmaskieren
		and.w	d4,(a2)
		and.w	d4,(a3)

		moveq	#0,d0
c2b3_lastword	move.b	(a0)+,d0		; Chunky holen
		move.b	(a5,d0.w),d0		; konvertieren
		add.b	d0,d0
		addx.w	d3,d3			; Plane 3
		add.b	d0,d0
		addx.w	d2,d2			; Plane 2
		add.b	d0,d0
		addx.w	d1,d1			; Plane 1
		dbf	d5,c2b3_lastword

		lsl.w	d7,d1			; zurechtschieben
		lsl.w	d7,d2
		lsl.w	d7,d3
		or.w	d1,(a1)+
		or.w	d2,(a2)+
		or.w	d3,(a3)+


c2b3_nolastword

; -  -  -- - - -  - - --  - -- - -   - --  -  - - - -- - -- - - -- - -

		add.w	(c2bs_cmodulo,a6),a0	; Data + ChunkyModulo

		move.w	(c2bs_bmodulo,a6),d0	; BitmapModulo
		add.w	d0,a1
		add.w	d0,a2
		add.w	d0,a3

		subq.w	#1,a4
		move.w	a4,d0
		bne.w	c2b3_lineloop

		rts

;---------------------------------------------------------------------

chunky2bpl4	move.l	(c2bs_pentab,a6),a5

; -  -  -- - - -  - - --  - -- - -   - --  -  - - - -- - -- - - -- - -
;
;		BitPlane-Startadresse berechnen


		move.l	(c2bs_planetab,a6),a4
		movem.l	(a4),a1-a4		; Planes 1,2,3,4
		add.l	d0,a1			; fertige Startadressen
		add.l	d0,a2
		add.l	d0,a3
		add.l	d0,a4

; -  -  -- - - -  - - --  - -- - -   - --  -  - - - -- - -- - - -- - -
;
;		Zeilen-Schleife


		move.w	(c2bs_height,a6),d5	; Schleifenzähler
		subq.w	#1,d5

c2b4_lineloop	swap	d5
		move.w	(c2bs_width,a6),d5	; Restbreite

; -  -  -- - - -  - - --  - -- - -   - --  -  - - - -- - -- - - -- - -
;
;		erstes Word behandeln


		move.w	(c2bs_dstx,a6),d6
		moveq	#15,d7
		and.w	d7,d6
		beq.b	c2b4_no1stword		; Anfang exakt auf Wordgrenze

		sub.w	d6,d7			; Anz. Pixel im ersten Word - 1

		moveq	#-2,d4
		lsl.w	d7,d4			; Maske für erstes Word

		subq.w	#1,d5
		sub.w	d7,d5			; verbleibende Pixel
		bpl.b	c2b4_1stwordok		; 0 oder mehr übrig, ok

		neg.w	d5
		sub.w	d5,d7			; Anzahl Durchläufe korrigieren
		moveq	#-1,d6
		clr.w	d6
		rol.l	d5,d6
		or.w	d6,d4			; Maske, z.B. 1110000000011111
		neg.w	d5

c2b4_1stwordok	and.w	d4,(a1)			; unsere Bits wegmaskieren
		and.w	d4,(a2)
		and.w	d4,(a3)
		and.w	d4,(a4)


		moveq	#0,d0
		moveq	#0,d1			; explizit nötig, weil weniger
		moveq	#0,d2			; als 16 Durchläufe
		moveq	#0,d3
		moveq	#0,d4

c2b4_1stword	move.b	(a0)+,d0		; Chunky holen
		move.b	(a5,d0.w),d0		; konvertieren
		add.b	d0,d0
		addx.w	d4,d4			; Plane 4
		add.b	d0,d0
		addx.w	d3,d3			; Plane 3
		add.b	d0,d0
		addx.w	d2,d2			; Plane 2
		add.b	d0,d0
		addx.w	d1,d1			; Plane 1
		dbf	d7,c2b4_1stword

		tst.w	d5			; noch Pixel übrig?
		bpl.b	c2b4_noshift		; ja, 0 oder mehr

		neg.w	d5
		lsl.w	d5,d1			; weitershiften
		lsl.w	d5,d2
		lsl.w	d5,d3
		lsl.w	d5,d4
		clr.w	d5			; keine weiteren Pixel mehr

c2b4_noshift	or.w	d1,(a1)+		; unsere Bits reinmaskieren
		or.w	d2,(a2)+
		or.w	d3,(a3)+
		or.w	d4,(a4)+


c2b4_no1stword

; -  -  -- - - -  - - --  - -- - -   - --  -  - - - -- - -- - - -- - -
;
;		Words auf 16er-Grenzen behandeln


		move.w	d5,d7
		lsr.w	#4,d7
		subq.w	#1,d7
		bmi.w	c2b4_no16

		moveq	#0,d0
c2b4_16loop	moveq	#1,d6
c2b4_16loop2
		REPT	8
		move.b	(a0)+,d0		; Chunky holen
		move.b	(a5,d0.w),d0		; konvertieren
		add.b	d0,d0
		addx.w	d4,d4			; Plane 4
		add.b	d0,d0
		addx.w	d3,d3			; Plane 3
		add.b	d0,d0
		addx.w	d2,d2			; Plane 2
		add.b	d0,d0
		addx.w	d1,d1			; Plane 1
		ENDR
		dbf	d6,c2b4_16loop2
		move.w	d1,(a1)+
		move.w	d2,(a2)+
		move.w	d3,(a3)+
		move.w	d4,(a4)+
		sub.w	#16,d5
		dbf	d7,c2b4_16loop

c2b4_no16	

; -  -  -- - - -  - - --  - -- - -   - --  -  - - - -- - -- - - -- - -
;
;		letztes Word behandeln


		subq.w	#1,d5
		bmi.b	c2b4_nolastword

		moveq	#15,d7
		sub.w	d5,d7

		moveq	#-1,d4			; lastword-Maske bilden
		lsr.w	d5,d4
		lsr.w	#1,d4

		and.w	d4,(a1)			; unsere Bits wegmaskieren
		and.w	d4,(a2)
		and.w	d4,(a3)
		and.w	d4,(a4)

		moveq	#0,d0
c2b4_lastword	move.b	(a0)+,d0		; Chunky holen
		move.b	(a5,d0.w),d0		; konvertieren
		add.b	d0,d0
		addx.w	d4,d4			; Plane 4
		add.b	d0,d0
		addx.w	d3,d3			; Plane 3
		add.b	d0,d0
		addx.w	d2,d2			; Plane 2
		add.b	d0,d0
		addx.w	d1,d1			; Plane 1
		dbf	d5,c2b4_lastword

		lsl.w	d7,d1			; zurechtschieben
		lsl.w	d7,d2
		lsl.w	d7,d3
		lsl.w	d7,d4
		or.w	d1,(a1)+
		or.w	d2,(a2)+
		or.w	d3,(a3)+
		or.w	d4,(a4)+

c2b4_nolastword

; -  -  -- - - -  - - --  - -- - -   - --  -  - - - -- - -- - - -- - -

		add.w	(c2bs_cmodulo,a6),a0	; Data + ChunkyModulo

		move.w	(c2bs_bmodulo,a6),d0	; BitmapModulo
		add.w	d0,a1
		add.w	d0,a2
		add.w	d0,a3
		add.w	d0,a4

		swap	d5
		dbf	d5,c2b4_lineloop

		rts

;---------------------------------------------------------------------

chunky2bpl5	move.l	(c2bs_planetab,a6),a5
		movem.l	(a5),a1-a5		; Planes 1,2,3,4,5
		sub.l	a4,a5
		move.l	a5,(c2bs_plane5,a6)	; Offset plane 4 -> 5 merken
		add.l	d0,a1			; fertige Startadressen
		add.l	d0,a2
		add.l	d0,a3
		add.l	d0,a4

		move.l	(c2bs_pentab,a6),a5

; -  -  -- - - -  - - --  - -- - -   - --  -  - - - -- - -- - - -- - -
;
;		Zeilen-Schleife


		move.w	(c2bs_height,a6),d5	; Schleifenzähler
		subq.w	#1,d5

c2b5_lineloop	swap	d5
		move.w	(c2bs_width,a6),d5	; Restbreite

; -  -  -- - - -  - - --  - -- - -   - --  -  - - - -- - -- - - -- - -
;
;		erstes Word behandeln


		move.w	(c2bs_dstx,a6),d6
		moveq	#15,d7
		and.w	d7,d6
		beq.b	c2b5_no1stword		; Anfang exakt auf Wordgrenze

		sub.w	d6,d7			; Anz. Pixel im ersten Word - 1

		moveq	#-2,d4
		lsl.w	d7,d4			; Maske für erstes Word

		subq.w	#1,d5
		sub.w	d7,d5			; verbleibende Pixel
		bpl.b	c2b5_1stwordok		; 0 oder mehr übrig, ok

		neg.w	d5
		sub.w	d5,d7			; Anzahl Durchläufe korrigieren
		moveq	#-1,d6
		clr.w	d6
		rol.l	d5,d6
		or.w	d6,d4			; Maske, z.B. 1110000000011111
		neg.w	d5

c2b5_1stwordok	and.w	d4,(a1)			; unsere Bits wegmaskieren
		and.w	d4,(a2)
		and.w	d4,(a3)
		and.w	d4,(a4)
		move.l	(c2bs_plane5,a6),d0
		and.w	d4,(a4,d0.l)


		moveq	#0,d0
		moveq	#0,d1			; explizit nötig, weil weniger
		moveq	#0,d2			; als 16 Durchläufe
		moveq	#0,d3
		moveq	#0,d4

c2b5_1stword	move.b	(a0)+,d0		; Chunky holen
		move.b	(a5,d0.w),d0		; konvertieren
		swap	d4
		add.b	d0,d0
		addx.w	d4,d4			; Plane 5
		swap	d4
		add.b	d0,d0
		addx.w	d4,d4			; Plane 4
		add.b	d0,d0
		addx.w	d3,d3			; Plane 3
		add.b	d0,d0
		addx.w	d2,d2			; Plane 2
		add.b	d0,d0
		addx.w	d1,d1			; Plane 1
		dbf	d7,c2b5_1stword

		tst.w	d5			; noch Pixel übrig?
		bpl.b	c2b5_noshift		; ja, 0 oder mehr

		neg.w	d5
		lsl.w	d5,d1			; weitershiften
		lsl.w	d5,d2
		lsl.w	d5,d3
		lsl.l	d5,d4
		clr.w	d5			; keine weiteren Pixel mehr

c2b5_noshift	or.w	d1,(a1)+		; unsere Bits reinmaskieren
		or.w	d2,(a2)+
		or.w	d3,(a3)+
		or.w	d4,(a4)+
		move.l	(c2bs_plane5,a6),d0
		swap	d4
		or.w	d4,-2(a4,d0.l)

c2b5_no1stword

; -  -  -- - - -  - - --  - -- - -   - --  -  - - - -- - -- - - -- - -
;
;		Words auf 16er-Grenzen behandeln


		move.w	d5,d7
		lsr.w	#4,d7
		subq.w	#1,d7
		bmi.w	c2b5_no16

		moveq	#0,d0
c2b5_16loop	moveq	#3,d6
c2b5_16loop2
		REPT	4
		move.b	(a0)+,d0		; Chunky holen
		move.b	(a5,d0.w),d0		; konvertieren
		swap	d4
		add.b	d0,d0
		addx.w	d4,d4			; Plane 5
		swap	d4
		add.b	d0,d0
		addx.w	d4,d4			; Plane 4
		add.b	d0,d0
		addx.w	d3,d3			; Plane 3
		add.b	d0,d0
		addx.w	d2,d2			; Plane 2
		add.b	d0,d0
		addx.w	d1,d1			; Plane 1
		ENDR
		dbf	d6,c2b5_16loop2
		move.w	d1,(a1)+
		move.w	d2,(a2)+
		move.w	d3,(a3)+
		move.w	d4,(a4)+
		move.l	(c2bs_plane5,a6),d1
		swap	d4
		move.w	d4,-2(a4,d1.l)

		sub.w	#16,d5
		dbf	d7,c2b5_16loop

c2b5_no16	

; -  -  -- - - -  - - --  - -- - -   - --  -  - - - -- - -- - - -- - -
;
;		letztes Word behandeln


		subq.w	#1,d5
		bmi.b	c2b5_nolastword

		moveq	#15,d7
		sub.w	d5,d7

		moveq	#-1,d4			; lastword-Maske bilden
		lsr.w	d5,d4
		lsr.w	#1,d4

		and.w	d4,(a1)			; unsere Bits wegmaskieren
		and.w	d4,(a2)
		and.w	d4,(a3)
		and.w	d4,(a4)
		move.l	(c2bs_plane5,a6),d0
		and.w	d4,(a4,d0.l)


		moveq	#0,d0
		moveq	#0,d4
c2b5_lastword	move.b	(a0)+,d0		; Chunky holen
		move.b	(a5,d0.w),d0		; konvertieren
		swap	d4
		add.b	d0,d0
		addx.w	d4,d4			; Plane 5
		swap	d4
		add.b	d0,d0
		addx.w	d4,d4			; Plane 4
		add.b	d0,d0
		addx.w	d3,d3			; Plane 3
		add.b	d0,d0
		addx.w	d2,d2			; Plane 2
		add.b	d0,d0
		addx.w	d1,d1			; Plane 1
		dbf	d5,c2b5_lastword

		lsl.w	d7,d1			; zurechtschieben
		lsl.w	d7,d2
		lsl.w	d7,d3
		lsl.l	d7,d4			; yes
		or.w	d1,(a1)+
		or.w	d2,(a2)+
		or.w	d3,(a3)+
		or.w	d4,(a4)+
		move.l	(c2bs_plane5,a6),d0
		swap	d4
		or.w	d4,-2(a4,d0.l)

c2b5_nolastword

; -  -  -- - - -  - - --  - -- - -   - --  -  - - - -- - -- - - -- - -

		add.w	(c2bs_cmodulo,a6),a0	; Data + ChunkyModulo

		move.w	(c2bs_bmodulo,a6),d0	; BitmapModulo
		add.w	d0,a1
		add.w	d0,a2
		add.w	d0,a3
		add.w	d0,a4

		swap	d5
		dbf	d5,c2b5_lineloop

		rts

;---------------------------------------------------------------------

chunky2bpl6	move.l	(c2bs_planetab,a6),a5
		movem.l	(a5)+,a1-a4		; Planes 1,2,3,4
		move.l	(a5)+,d5		; Plane 5
		move.l	(a5)+,d6		; Plane 6

		sub.l	a4,d5
		sub.l	a4,d6
		move.l	d5,(c2bs_plane5,a6)	; Offset Plane 4 -> 5
		move.l	d6,(c2bs_plane6,a6)	; Offset Plane 4 -> 6


		add.l	d0,a1			; fertige Startadressen
		add.l	d0,a2
		add.l	d0,a3
		add.l	d0,a4

		move.l	(c2bs_pentab,a6),a5

; -  -  -- - - -  - - --  - -- - -   - --  -  - - - -- - -- - - -- - -
;
;		Zeilen-Schleife


		move.w	(c2bs_height,a6),d5	; Schleifenzähler
		subq.w	#1,d5

c2b6_lineloop	swap	d5
		move.w	(c2bs_width,a6),d5	; Restbreite

; -  -  -- - - -  - - --  - -- - -   - --  -  - - - -- - -- - - -- - -
;
;		erstes Word behandeln


		move.w	(c2bs_dstx,a6),d6
		moveq	#15,d7
		and.w	d7,d6
		beq.w	c2b6_no1stword		; Anfang exakt auf Wordgrenze

		sub.w	d6,d7			; Anz. Pixel im ersten Word - 1

		moveq	#-2,d4
		lsl.w	d7,d4			; Maske für erstes Word

		subq.w	#1,d5
		sub.w	d7,d5			; verbleibende Pixel
		bpl.b	c2b6_1stwordok		; 0 oder mehr übrig, ok

		neg.w	d5
		sub.w	d5,d7			; Anzahl Durchläufe korrigieren
		moveq	#-1,d6
		clr.w	d6
		rol.l	d5,d6
		or.w	d6,d4			; Maske, z.B. 1110000000011111
		neg.w	d5

c2b6_1stwordok	and.w	d4,(a1)			; unsere Bits wegmaskieren
		and.w	d4,(a2)
		and.w	d4,(a3)
		and.w	d4,(a4)
		move.l	(c2bs_plane5,a6),d0
		and.w	d4,(a4,d0.l)
		move.l	(c2bs_plane6,a6),d0
		and.w	d4,(a4,d0.l)


		moveq	#0,d0
		moveq	#0,d1			; explizit nötig, weil weniger
		moveq	#0,d2			; als 16 Durchläufe
		moveq	#0,d3
		moveq	#0,d4

c2b6_1stword	move.b	(a0)+,d0		; Chunky holen
		move.b	(a5,d0.w),d0		; konvertieren
		swap	d3
		add.b	d0,d0
		addx.w	d3,d3			; Plane 6
		swap	d3
		swap	d4
		add.b	d0,d0
		addx.w	d4,d4			; Plane 5
		swap	d4
		add.b	d0,d0
		addx.w	d4,d4			; Plane 4
		add.b	d0,d0
		addx.w	d3,d3			; Plane 3
		add.b	d0,d0
		addx.w	d2,d2			; Plane 2
		add.b	d0,d0
		addx.w	d1,d1			; Plane 1
		dbf	d7,c2b6_1stword

		tst.w	d5			; noch Pixel übrig?
		bpl.b	c2b6_noshift		; ja, 0 oder mehr

		neg.w	d5
		lsl.w	d5,d1			; weitershiften
		lsl.w	d5,d2
		lsl.l	d5,d3
		lsl.l	d5,d4
		clr.w	d5			; keine weiteren Pixel mehr

c2b6_noshift	or.w	d1,(a1)+		; unsere Bits reinmaskieren
		or.w	d2,(a2)+
		or.w	d3,(a3)+
		or.w	d4,(a4)+
		swap	d4
		move.l	(c2bs_plane5,a6),d0
		or.w	d4,-2(a4,d0.l)
		swap	d3
		move.l	(c2bs_plane6,a6),d0
		or.w	d3,-2(a4,d0.l)

c2b6_no1stword

; -  -  -- - - -  - - --  - -- - -   - --  -  - - - -- - -- - - -- - -
;
;		Words auf 16er-Grenzen behandeln


		move.w	d5,d7
		lsr.w	#4,d7
		subq.w	#1,d7
		bmi.w	c2b6_no16

		moveq	#0,d0

c2b6_16loop	moveq	#3,d6

c2b6_16loop2
		REPT	4
		move.b	(a0)+,d0		; Chunky holen
		move.b	(a5,d0.w),d0		; konvertieren
		swap	d3
		add.b	d0,d0
		addx.w	d3,d3			; Plane 6
		swap	d3
		swap	d4
		add.b	d0,d0
		addx.w	d4,d4			; Plane 5
		swap	d4
		add.b	d0,d0
		addx.w	d4,d4			; Plane 4
		add.b	d0,d0
		addx.w	d3,d3			; Plane 3
		add.b	d0,d0
		addx.w	d2,d2			; Plane 2
		add.b	d0,d0
		addx.w	d1,d1			; Plane 1
		ENDR
		dbf	d6,c2b6_16loop2
		move.w	d1,(a1)+
		move.w	d2,(a2)+
		move.w	d3,(a3)+
		move.w	d4,(a4)+
		swap	d4
		move.l	(c2bs_plane5,a6),d1
		move.w	d4,-2(a4,d1.l)
		swap	d3
		move.l	(c2bs_plane6,a6),d1
		move.w	d3,-2(a4,d1.l)

		sub.w	#16,d5
		dbf	d7,c2b6_16loop

c2b6_no16	

; -  -  -- - - -  - - --  - -- - -   - --  -  - - - -- - -- - - -- - -
;
;		letztes Word behandeln


		subq.w	#1,d5
		bmi.b	c2b6_nolastword

		moveq	#15,d7
		sub.w	d5,d7

		moveq	#-1,d4			; lastword-Maske bilden
		lsr.w	d5,d4
		lsr.w	#1,d4

		and.w	d4,(a1)			; unsere Bits wegmaskieren
		and.w	d4,(a2)
		and.w	d4,(a3)
		and.w	d4,(a4)
		move.l	(c2bs_plane5,a6),d0
		and.w	d4,(a4,d0.l)
		move.l	(c2bs_plane6,a6),d0
		and.w	d4,(a4,d0.l)


		moveq	#0,d0
		moveq	#0,d3
		moveq	#0,d4
c2b6_lastword	move.b	(a0)+,d0		; Chunky holen
		move.b	(a5,d0.w),d0		; konvertieren
		swap	d3
		add.b	d0,d0
		addx.w	d3,d3			; Plane 6
		swap	d3
		swap	d4
		add.b	d0,d0
		addx.w	d4,d4			; Plane 5
		swap	d4
		add.b	d0,d0
		addx.w	d4,d4			; Plane 4
		add.b	d0,d0
		addx.w	d3,d3			; Plane 3
		add.b	d0,d0
		addx.w	d2,d2			; Plane 2
		add.b	d0,d0
		addx.w	d1,d1			; Plane 1
		dbf	d5,c2b6_lastword

		lsl.w	d7,d1			; zurechtschieben
		lsl.w	d7,d2
		lsl.l	d7,d3
		lsl.l	d7,d4			; yes
		or.w	d1,(a1)+
		or.w	d2,(a2)+
		or.w	d3,(a3)+
		or.w	d4,(a4)+
		swap	d4
		move.l	(c2bs_plane5,a6),d0
		or.w	d4,-2(a4,d0.l)
		swap	d3
		move.l	(c2bs_plane6,a6),d0
		or.w	d3,-2(a4,d0.l)

c2b6_nolastword

; -  -  -- - - -  - - --  - -- - -   - --  -  - - - -- - -- - - -- - -

		add.w	(c2bs_cmodulo,a6),a0	; Data + ChunkyModulo

		move.w	(c2bs_bmodulo,a6),d0	; BitmapModulo
		add.w	d0,a1
		add.w	d0,a2
		add.w	d0,a3
		add.w	d0,a4

		swap	d5
		dbf	d5,c2b6_lineloop

		rts

;---------------------------------------------------------------------

chunky2bpl7	move.l	(c2bs_planetab,a6),a5
		movem.l	(a5)+,a1-a4		; Planes 1,2,3,4
		movem.l	(a5)+,d5-d7		; Plane 5,6,7

		sub.l	a4,d5
		sub.l	a4,d6
		sub.l	a4,d7
		movem.l	d5-d7,(c2bs_plane5,a6)	; Offsets Plane 4 -> 5/6/7


		add.l	d0,a1			; fertige Startadressen
		add.l	d0,a2
		add.l	d0,a3
		add.l	d0,a4

		move.l	(c2bs_pentab,a6),a5

; -  -  -- - - -  - - --  - -- - -   - --  -  - - - -- - -- - - -- - -
;
;		Zeilen-Schleife


		move.w	(c2bs_height,a6),d5	; Schleifenzähler
		subq.w	#1,d5

c2b7_lineloop	swap	d5
		move.w	(c2bs_width,a6),d5	; Restbreite

; -  -  -- - - -  - - --  - -- - -   - --  -  - - - -- - -- - - -- - -
;
;		erstes Word behandeln


		move.w	(c2bs_dstx,a6),d6
		moveq	#15,d7
		and.w	d7,d6
		beq.w	c2b7_no1stword		; Anfang exakt auf Wordgrenze

		sub.w	d6,d7			; Anz. Pixel im ersten Word - 1

		moveq	#-2,d4
		lsl.w	d7,d4			; Maske für erstes Word

		subq.w	#1,d5
		sub.w	d7,d5			; verbleibende Pixel
		bpl.b	c2b7_1stwordok		; 0 oder mehr übrig, ok

		neg.w	d5
		sub.w	d5,d7			; Anzahl Durchläufe korrigieren
		moveq	#-1,d6
		clr.w	d6
		rol.l	d5,d6
		or.w	d6,d4			; Maske, z.B. 1110000000011111
		neg.w	d5

c2b7_1stwordok	and.w	d4,(a1)			; unsere Bits wegmaskieren
		and.w	d4,(a2)
		and.w	d4,(a3)
		and.w	d4,(a4)
		move.l	(c2bs_plane5,a6),d0
		and.w	d4,(a4,d0.l)
		move.l	(c2bs_plane6,a6),d0
		and.w	d4,(a4,d0.l)
		move.l	(c2bs_plane7,a6),d0
		and.w	d4,(a4,d0.l)


		moveq	#0,d0
		moveq	#0,d1			; explizit nötig, weil weniger
		moveq	#0,d2			; als 16 Durchläufe
		moveq	#0,d3
		moveq	#0,d4

c2b7_1stword	move.b	(a0)+,d0		; Chunky holen
		move.b	(a5,d0.w),d0		; konvertieren
		swap	d2
		add.b	d0,d0
		addx.w	d2,d2			; Plane 7
		swap	d2
		swap	d3
		add.b	d0,d0
		addx.w	d3,d3			; Plane 6
		swap	d3
		swap	d4
		add.b	d0,d0
		addx.w	d4,d4			; Plane 5
		swap	d4
		add.b	d0,d0
		addx.w	d4,d4			; Plane 4
		add.b	d0,d0
		addx.w	d3,d3			; Plane 3
		add.b	d0,d0
		addx.w	d2,d2			; Plane 2
		add.b	d0,d0
		addx.w	d1,d1			; Plane 1
		dbf	d7,c2b7_1stword

		tst.w	d5			; noch Pixel übrig?
		bpl.b	c2b7_noshift		; ja, 0 oder mehr

		neg.w	d5
		lsl.w	d5,d1			; weitershiften
		lsl.l	d5,d2
		lsl.l	d5,d3
		lsl.l	d5,d4
		clr.w	d5			; keine weiteren Pixel mehr

c2b7_noshift	or.w	d1,(a1)+		; unsere Bits reinmaskieren
		or.w	d2,(a2)+
		or.w	d3,(a3)+
		or.w	d4,(a4)+
		swap	d4
		move.l	(c2bs_plane5,a6),d0
		or.w	d4,-2(a4,d0.l)
		swap	d3
		move.l	(c2bs_plane6,a6),d0
		or.w	d3,-2(a4,d0.l)
		swap	d2
		move.l	(c2bs_plane7,a6),d0
		or.w	d2,-2(a4,d0.l)

c2b7_no1stword

; -  -  -- - - -  - - --  - -- - -   - --  -  - - - -- - -- - - -- - -
;
;		Words auf 16er-Grenzen behandeln


		move.w	d5,d7
		lsr.w	#4,d7
		subq.w	#1,d7
		bmi.w	c2b7_no16

		moveq	#0,d0
c2b7_16loop	moveq	#3,d6
c2b7_16loop2	
		REPT	4
		move.b	(a0)+,d0		; Chunky holen
		move.b	(a5,d0.w),d0		; konvertieren
		swap	d2
		add.b	d0,d0
		addx.w	d2,d2			; Plane 7
		swap	d2
		swap	d3
		add.b	d0,d0
		addx.w	d3,d3			; Plane 6
		swap	d3
		swap	d4
		add.b	d0,d0
		addx.w	d4,d4			; Plane 5
		swap	d4
		add.b	d0,d0
		addx.w	d4,d4			; Plane 4
		add.b	d0,d0
		addx.w	d3,d3			; Plane 3
		add.b	d0,d0
		addx.w	d2,d2			; Plane 2
		add.b	d0,d0
		addx.w	d1,d1			; Plane 1
		ENDR
		dbf	d6,c2b7_16loop2
		move.w	d1,(a1)+
		move.w	d2,(a2)+
		move.w	d3,(a3)+
		move.w	d4,(a4)+
		swap	d4
		move.l	(c2bs_plane5,a6),d1
		move.w	d4,-2(a4,d1.l)
		swap	d3
		move.l	(c2bs_plane6,a6),d1
		move.w	d3,-2(a4,d1.l)
		swap	d2
		move.l	(c2bs_plane7,a6),d1
		move.w	d2,-2(a4,d1.l)

		sub.w	#16,d5
		dbf	d7,c2b7_16loop

c2b7_no16	

; -  -  -- - - -  - - --  - -- - -   - --  -  - - - -- - -- - - -- - -
;
;		letztes Word behandeln


		subq.w	#1,d5
		bmi.w	c2b7_nolastword

		moveq	#15,d7
		sub.w	d5,d7

		moveq	#-1,d4			; lastword-Maske bilden
		lsr.w	d5,d4
		lsr.w	#1,d4

		and.w	d4,(a1)			; unsere Bits wegmaskieren
		and.w	d4,(a2)
		and.w	d4,(a3)
		and.w	d4,(a4)
		move.l	(c2bs_plane5,a6),d0
		and.w	d4,(a4,d0.l)
		move.l	(c2bs_plane6,a6),d0
		and.w	d4,(a4,d0.l)
		move.l	(c2bs_plane7,a6),d0
		and.w	d4,(a4,d0.l)


		moveq	#0,d0
		moveq	#0,d2
		moveq	#0,d3
		moveq	#0,d4
c2b7_lastword	move.b	(a0)+,d0		; Chunky holen
		move.b	(a5,d0.w),d0		; konvertieren
		swap	d2
		add.b	d0,d0
		addx.w	d2,d2			; Plane 7
		swap	d2
		swap	d3
		add.b	d0,d0
		addx.w	d3,d3			; Plane 6
		swap	d3
		swap	d4
		add.b	d0,d0
		addx.w	d4,d4			; Plane 5
		swap	d4
		add.b	d0,d0
		addx.w	d4,d4			; Plane 4
		add.b	d0,d0
		addx.w	d3,d3			; Plane 3
		add.b	d0,d0
		addx.w	d2,d2			; Plane 2
		add.b	d0,d0
		addx.w	d1,d1			; Plane 1
		dbf	d5,c2b7_lastword

		lsl.w	d7,d1			; zurechtschieben
		lsl.l	d7,d2
		lsl.l	d7,d3
		lsl.l	d7,d4			; yes
		or.w	d1,(a1)+
		or.w	d2,(a2)+
		or.w	d3,(a3)+
		or.w	d4,(a4)+
		swap	d4
		move.l	(c2bs_plane5,a6),d0
		or.w	d4,-2(a4,d0.l)
		swap	d3
		move.l	(c2bs_plane6,a6),d0
		or.w	d3,-2(a4,d0.l)
		swap	d2
		move.l	(c2bs_plane7,a6),d0
		or.w	d2,-2(a4,d0.l)

c2b7_nolastword

; -  -  -- - - -  - - --  - -- - -   - --  -  - - - -- - -- - - -- - -

		add.w	(c2bs_cmodulo,a6),a0	; Data + ChunkyModulo

		move.w	(c2bs_bmodulo,a6),d0	; BitmapModulo
		add.w	d0,a1
		add.w	d0,a2
		add.w	d0,a3
		add.w	d0,a4

		swap	d5
		dbf	d5,c2b7_lineloop

		rts

;---------------------------------------------------------------------

chunky2bpl8	move.l	(c2bs_planetab,a6),a5
		movem.l	(a5)+,a1-a4		; Planes 1,2,3,4
		movem.l	(a5)+,d4-d7		; Plane 5,6,7,8

		sub.l	a4,d4
		sub.l	a4,d5
		sub.l	a4,d6
		sub.l	a4,d7
		movem.l	d4-d7,(c2bs_plane5,a6)	; Offsets Plane 4 -> 5/6/7/8


		add.l	d0,a1			; fertige Startadressen
		add.l	d0,a2
		add.l	d0,a3
		add.l	d0,a4

		move.l	(c2bs_pentab,a6),a5

; -  -  -- - - -  - - --  - -- - -   - --  -  - - - -- - -- - - -- - -
;
;		Zeilen-Schleife


		move.w	(c2bs_height,a6),d5	; Schleifenzähler
		subq.w	#1,d5

c2b8_lineloop	swap	d5
		move.w	(c2bs_width,a6),d5	; Restbreite

; -  -  -- - - -  - - --  - -- - -   - --  -  - - - -- - -- - - -- - -
;
;		erstes Word behandeln


		move.w	(c2bs_dstx,a6),d6
		moveq	#15,d7
		and.w	d7,d6
		beq.w	c2b8_no1stword		; Anfang exakt auf Wordgrenze

		sub.w	d6,d7			; Anz. Pixel im ersten Word - 1

		moveq	#-2,d4
		lsl.w	d7,d4			; Maske für erstes Word

		subq.w	#1,d5
		sub.w	d7,d5			; verbleibende Pixel
		bpl.b	c2b8_1stwordok		; 0 oder mehr übrig, ok

		neg.w	d5
		sub.w	d5,d7			; Anzahl Durchläufe korrigieren
		moveq	#-1,d6
		clr.w	d6
		rol.l	d5,d6
		or.w	d6,d4			; Maske, z.B. 1110000000011111
		neg.w	d5

c2b8_1stwordok	and.w	d4,(a1)			; unsere Bits wegmaskieren
		and.w	d4,(a2)
		and.w	d4,(a3)
		and.w	d4,(a4)
		move.l	(c2bs_plane5,a6),d0
		and.w	d4,(a4,d0.l)
		move.l	(c2bs_plane6,a6),d0
		and.w	d4,(a4,d0.l)
		move.l	(c2bs_plane7,a6),d0
		and.w	d4,(a4,d0.l)
		move.l	(c2bs_plane8,a6),d0
		and.w	d4,(a4,d0.l)


		moveq	#0,d0
		moveq	#0,d1			; explizit nötig, weil weniger
		moveq	#0,d2			; als 16 Durchläufe
		moveq	#0,d3
		moveq	#0,d4

c2b8_1stword	move.b	(a0)+,d0		; Chunky holen
		move.b	(a5,d0.w),d0		; konvertieren
		swap	d1
		add.b	d0,d0
		addx.w	d1,d1			; Plane 8
		swap	d1
		swap	d2
		add.b	d0,d0
		addx.w	d2,d2			; Plane 7
		swap	d2
		swap	d3
		add.b	d0,d0
		addx.w	d3,d3			; Plane 6
		swap	d3
		swap	d4
		add.b	d0,d0
		addx.w	d4,d4			; Plane 5
		swap	d4
		add.b	d0,d0
		addx.w	d4,d4			; Plane 4
		add.b	d0,d0
		addx.w	d3,d3			; Plane 3
		add.b	d0,d0
		addx.w	d2,d2			; Plane 2
		add.b	d0,d0
		addx.w	d1,d1			; Plane 1
		dbf	d7,c2b8_1stword

		tst.w	d5			; noch Pixel übrig?
		bpl.b	c2b8_noshift		; ja, 0 oder mehr

		neg.w	d5
		lsl.l	d5,d1			; weitershiften
		lsl.l	d5,d2
		lsl.l	d5,d3
		lsl.l	d5,d4
		clr.w	d5			; keine weiteren Pixel mehr

c2b8_noshift	or.w	d1,(a1)+		; unsere Bits reinmaskieren
		or.w	d2,(a2)+
		or.w	d3,(a3)+
		or.w	d4,(a4)+
		swap	d4
		move.l	(c2bs_plane5,a6),d0
		or.w	d4,-2(a4,d0.l)
		swap	d3
		move.l	(c2bs_plane6,a6),d0
		or.w	d3,-2(a4,d0.l)
		swap	d2
		move.l	(c2bs_plane7,a6),d0
		or.w	d2,-2(a4,d0.l)
		swap	d1
		move.l	(c2bs_plane8,a6),d0
		or.w	d1,-2(a4,d0.l)

c2b8_no1stword

; -  -  -- - - -  - - --  - -- - -   - --  -  - - - -- - -- - - -- - -
;
;		Words auf 16er-Grenzen behandeln


		move.w	d5,d7
		lsr.w	#4,d7
		subq.w	#1,d7
		bmi.w	c2b8_no16

c2b8_16loop	moveq	#0,d0
		moveq	#3,d6
c2b8_16loop2
		REPT	4
		move.b	(a0)+,d0		; Chunky holen
		move.b	(a5,d0.w),d0		; konvertieren
		swap	d1
		add.b	d0,d0
		addx.w	d1,d1			; Plane 8
		swap	d1
		swap	d2
		add.b	d0,d0
		addx.w	d2,d2			; Plane 7
		swap	d2
		swap	d3
		add.b	d0,d0
		addx.w	d3,d3			; Plane 6
		swap	d3
		swap	d4
		add.b	d0,d0
		addx.w	d4,d4			; Plane 5
		swap	d4
		add.b	d0,d0
		addx.w	d4,d4			; Plane 4
		add.b	d0,d0
		addx.w	d3,d3			; Plane 3
		add.b	d0,d0
		addx.w	d2,d2			; Plane 2
		add.b	d0,d0
		addx.w	d1,d1			; Plane 1
		ENDR
		dbf	d6,c2b8_16loop2
		move.w	d1,(a1)+
		move.w	d2,(a2)+
		move.w	d3,(a3)+
		move.w	d4,(a4)+
		swap	d4
		move.l	(c2bs_plane5,a6),d0
		move.w	d4,-2(a4,d0.l)
		swap	d3
		move.l	(c2bs_plane6,a6),d0
		move.w	d3,-2(a4,d0.l)
		swap	d2
		move.l	(c2bs_plane7,a6),d0
		move.w	d2,-2(a4,d0.l)
		swap	d1
		move.l	(c2bs_plane8,a6),d0
		move.w	d1,-2(a4,d0.l)

		sub.w	#16,d5
		dbf	d7,c2b8_16loop

c2b8_no16	

; -  -  -- - - -  - - --  - -- - -   - --  -  - - - -- - -- - - -- - -
;
;		letztes Word behandeln


		subq.w	#1,d5
		bmi.w	c2b8_nolastword

		moveq	#15,d7
		sub.w	d5,d7

		moveq	#-1,d4			; lastword-Maske bilden
		lsr.w	d5,d4
		lsr.w	#1,d4

		and.w	d4,(a1)			; unsere Bits wegmaskieren
		and.w	d4,(a2)
		and.w	d4,(a3)
		and.w	d4,(a4)
		move.l	(c2bs_plane5,a6),d0
		and.w	d4,(a4,d0.l)
		move.l	(c2bs_plane6,a6),d0
		and.w	d4,(a4,d0.l)
		move.l	(c2bs_plane7,a6),d0
		and.w	d4,(a4,d0.l)
		move.l	(c2bs_plane8,a6),d0
		and.w	d4,(a4,d0.l)


		moveq	#0,d0
		moveq	#0,d1
		moveq	#0,d2
		moveq	#0,d3
		moveq	#0,d4
c2b8_lastword	move.b	(a0)+,d0		; Chunky holen
		move.b	(a5,d0.w),d0		; konvertieren
		swap	d1
		add.b	d0,d0
		addx.w	d1,d1			; Plane 8
		swap	d1
		swap	d2
		add.b	d0,d0
		addx.w	d2,d2			; Plane 7
		swap	d2
		swap	d3
		add.b	d0,d0
		addx.w	d3,d3			; Plane 6
		swap	d3
		swap	d4
		add.b	d0,d0
		addx.w	d4,d4			; Plane 5
		swap	d4
		add.b	d0,d0
		addx.w	d4,d4			; Plane 4
		add.b	d0,d0
		addx.w	d3,d3			; Plane 3
		add.b	d0,d0
		addx.w	d2,d2			; Plane 2
		add.b	d0,d0
		addx.w	d1,d1			; Plane 1
		dbf	d5,c2b8_lastword

		lsl.l	d7,d1			; zurechtschieben
		lsl.l	d7,d2
		lsl.l	d7,d3
		lsl.l	d7,d4			; yes
		or.w	d1,(a1)+
		or.w	d2,(a2)+
		or.w	d3,(a3)+
		or.w	d4,(a4)+
		swap	d4
		move.l	(c2bs_plane5,a6),d0
		or.w	d4,-2(a4,d0.l)
		swap	d3
		move.l	(c2bs_plane6,a6),d0
		or.w	d3,-2(a4,d0.l)
		swap	d2
		move.l	(c2bs_plane7,a6),d0
		or.w	d2,-2(a4,d0.l)
		swap	d1
		move.l	(c2bs_plane8,a6),d0
		or.w	d1,-2(a4,d0.l)

c2b8_nolastword

; -  -  -- - - -  - - --  - -- - -   - --  -  - - - -- - -- - - -- - -

		add.w	(c2bs_cmodulo,a6),a0	; Data + ChunkyModulo

		move.w	(c2bs_bmodulo,a6),d0	; BitmapModulo
		add.w	d0,a1
		add.w	d0,a2
		add.w	d0,a3
		add.w	d0,a4

		swap	d5
		dbf	d5,c2b8_lineloop

		rts

;---------------------------------------------------------------------------

c2b_pentabtab	dc.l	c2b_pentab1,c2b_pentab2,c2b_pentab3,c2b_pentab4
		dc.l	c2b_pentab5,c2b_pentab6,c2b_pentab7,c2b_pentab8


c2b_pentab1
	DC.B	$00,$80,$01,$81,$02,$82,$03,$83
	DC.B	$04,$84,$05,$85,$06,$86,$07,$87
	DC.B	$08,$88,$09,$89,$0A,$8A,$0B,$8B
	DC.B	$0C,$8C,$0D,$8D,$0E,$8E,$0F,$8F
	DC.B	$10,$90,$11,$91,$12,$92,$13,$93
	DC.B	$14,$94,$15,$95,$16,$96,$17,$97
	DC.B	$18,$98,$19,$99,$1A,$9A,$1B,$9B
	DC.B	$1C,$9C,$1D,$9D,$1E,$9E,$1F,$9F
	DC.B	$20,$A0,$21,$A1,$22,$A2,$23,$A3
	DC.B	$24,$A4,$25,$A5,$26,$A6,$27,$A7
	DC.B	$28,$A8,$29,$A9,$2A,$AA,$2B,$AB
	DC.B	$2C,$AC,$2D,$AD,$2E,$AE,$2F,$AF
	DC.B	$30,$B0,$31,$B1,$32,$B2,$33,$B3
	DC.B	$34,$B4,$35,$B5,$36,$B6,$37,$B7
	DC.B	$38,$B8,$39,$B9,$3A,$BA,$3B,$BB
	DC.B	$3C,$BC,$3D,$BD,$3E,$BE,$3F,$BF
	DC.B	$40,$C0,$41,$C1,$42,$C2,$43,$C3
	DC.B	$44,$C4,$45,$C5,$46,$C6,$47,$C7
	DC.B	$48,$C8,$49,$C9,$4A,$CA,$4B,$CB
	DC.B	$4C,$CC,$4D,$CD,$4E,$CE,$4F,$CF
	DC.B	$50,$D0,$51,$D1,$52,$D2,$53,$D3
	DC.B	$54,$D4,$55,$D5,$56,$D6,$57,$D7
	DC.B	$58,$D8,$59,$D9,$5A,$DA,$5B,$DB
	DC.B	$5C,$DC,$5D,$DD,$5E,$DE,$5F,$DF
	DC.B	$60,$E0,$61,$E1,$62,$E2,$63,$E3
	DC.B	$64,$E4,$65,$E5,$66,$E6,$67,$E7
	DC.B	$68,$E8,$69,$E9,$6A,$EA,$6B,$EB
	DC.B	$6C,$EC,$6D,$ED,$6E,$EE,$6F,$EF
	DC.B	$70,$F0,$71,$F1,$72,$F2,$73,$F3
	DC.B	$74,$F4,$75,$F5,$76,$F6,$77,$F7
	DC.B	$78,$F8,$79,$F9,$7A,$FA,$7B,$FB
	DC.B	$7C,$FC,$7D,$FD,$7E,$FE,$7F,$FF
c2b_pentab2
	DC.B	$00,$40,$80,$C0,$01,$41,$81,$C1
	DC.B	$02,$42,$82,$C2,$03,$43,$83,$C3
	DC.B	$04,$44,$84,$C4,$05,$45,$85,$C5
	DC.B	$06,$46,$86,$C6,$07,$47,$87,$C7
	DC.B	$08,$48,$88,$C8,$09,$49,$89,$C9
	DC.B	$0A,$4A,$8A,$CA,$0B,$4B,$8B,$CB
	DC.B	$0C,$4C,$8C,$CC,$0D,$4D,$8D,$CD
	DC.B	$0E,$4E,$8E,$CE,$0F,$4F,$8F,$CF
	DC.B	$10,$50,$90,$D0,$11,$51,$91,$D1
	DC.B	$12,$52,$92,$D2,$13,$53,$93,$D3
	DC.B	$14,$54,$94,$D4,$15,$55,$95,$D5
	DC.B	$16,$56,$96,$D6,$17,$57,$97,$D7
	DC.B	$18,$58,$98,$D8,$19,$59,$99,$D9
	DC.B	$1A,$5A,$9A,$DA,$1B,$5B,$9B,$DB
	DC.B	$1C,$5C,$9C,$DC,$1D,$5D,$9D,$DD
	DC.B	$1E,$5E,$9E,$DE,$1F,$5F,$9F,$DF
	DC.B	$20,$60,$A0,$E0,$21,$61,$A1,$E1
	DC.B	$22,$62,$A2,$E2,$23,$63,$A3,$E3
	DC.B	$24,$64,$A4,$E4,$25,$65,$A5,$E5
	DC.B	$26,$66,$A6,$E6,$27,$67,$A7,$E7
	DC.B	$28,$68,$A8,$E8,$29,$69,$A9,$E9
	DC.B	$2A,$6A,$AA,$EA,$2B,$6B,$AB,$EB
	DC.B	$2C,$6C,$AC,$EC,$2D,$6D,$AD,$ED
	DC.B	$2E,$6E,$AE,$EE,$2F,$6F,$AF,$EF
	DC.B	$30,$70,$B0,$F0,$31,$71,$B1,$F1
	DC.B	$32,$72,$B2,$F2,$33,$73,$B3,$F3
	DC.B	$34,$74,$B4,$F4,$35,$75,$B5,$F5
	DC.B	$36,$76,$B6,$F6,$37,$77,$B7,$F7
	DC.B	$38,$78,$B8,$F8,$39,$79,$B9,$F9
	DC.B	$3A,$7A,$BA,$FA,$3B,$7B,$BB,$FB
	DC.B	$3C,$7C,$BC,$FC,$3D,$7D,$BD,$FD
	DC.B	$3E,$7E,$BE,$FE,$3F,$7F,$BF,$FF
c2b_pentab3
	DC.B	$00,$20,$40,$60,$80,$A0,$C0,$E0
	DC.B	$01,$21,$41,$61,$81,$A1,$C1,$E1
	DC.B	$02,$22,$42,$62,$82,$A2,$C2,$E2
	DC.B	$03,$23,$43,$63,$83,$A3,$C3,$E3
	DC.B	$04,$24,$44,$64,$84,$A4,$C4,$E4
	DC.B	$05,$25,$45,$65,$85,$A5,$C5,$E5
	DC.B	$06,$26,$46,$66,$86,$A6,$C6,$E6
	DC.B	$07,$27,$47,$67,$87,$A7,$C7,$E7
	DC.B	$08,$28,$48,$68,$88,$A8,$C8,$E8
	DC.B	$09,$29,$49,$69,$89,$A9,$C9,$E9
	DC.B	$0A,$2A,$4A,$6A,$8A,$AA,$CA,$EA
	DC.B	$0B,$2B,$4B,$6B,$8B,$AB,$CB,$EB
	DC.B	$0C,$2C,$4C,$6C,$8C,$AC,$CC,$EC
	DC.B	$0D,$2D,$4D,$6D,$8D,$AD,$CD,$ED
	DC.B	$0E,$2E,$4E,$6E,$8E,$AE,$CE,$EE
	DC.B	$0F,$2F,$4F,$6F,$8F,$AF,$CF,$EF
	DC.B	$10,$30,$50,$70,$90,$B0,$D0,$F0
	DC.B	$11,$31,$51,$71,$91,$B1,$D1,$F1
	DC.B	$12,$32,$52,$72,$92,$B2,$D2,$F2
	DC.B	$13,$33,$53,$73,$93,$B3,$D3,$F3
	DC.B	$14,$34,$54,$74,$94,$B4,$D4,$F4
	DC.B	$15,$35,$55,$75,$95,$B5,$D5,$F5
	DC.B	$16,$36,$56,$76,$96,$B6,$D6,$F6
	DC.B	$17,$37,$57,$77,$97,$B7,$D7,$F7
	DC.B	$18,$38,$58,$78,$98,$B8,$D8,$F8
	DC.B	$19,$39,$59,$79,$99,$B9,$D9,$F9
	DC.B	$1A,$3A,$5A,$7A,$9A,$BA,$DA,$FA
	DC.B	$1B,$3B,$5B,$7B,$9B,$BB,$DB,$FB
	DC.B	$1C,$3C,$5C,$7C,$9C,$BC,$DC,$FC
	DC.B	$1D,$3D,$5D,$7D,$9D,$BD,$DD,$FD
	DC.B	$1E,$3E,$5E,$7E,$9E,$BE,$DE,$FE
	DC.B	$1F,$3F,$5F,$7F,$9F,$BF,$DF,$FF
c2b_pentab4
	DC.B	$00,$10,$20,$30,$40,$50,$60,$70
	DC.B	$80,$90,$A0,$B0,$C0,$D0,$E0,$F0
	DC.B	$01,$11,$21,$31,$41,$51,$61,$71
	DC.B	$81,$91,$A1,$B1,$C1,$D1,$E1,$F1
	DC.B	$02,$12,$22,$32,$42,$52,$62,$72
	DC.B	$82,$92,$A2,$B2,$C2,$D2,$E2,$F2
	DC.B	$03,$13,$23,$33,$43,$53,$63,$73
	DC.B	$83,$93,$A3,$B3,$C3,$D3,$E3,$F3
	DC.B	$04,$14,$24,$34,$44,$54,$64,$74
	DC.B	$84,$94,$A4,$B4,$C4,$D4,$E4,$F4
	DC.B	$05,$15,$25,$35,$45,$55,$65,$75
	DC.B	$85,$95,$A5,$B5,$C5,$D5,$E5,$F5
	DC.B	$06,$16,$26,$36,$46,$56,$66,$76
	DC.B	$86,$96,$A6,$B6,$C6,$D6,$E6,$F6
	DC.B	$07,$17,$27,$37,$47,$57,$67,$77
	DC.B	$87,$97,$A7,$B7,$C7,$D7,$E7,$F7
	DC.B	$08,$18,$28,$38,$48,$58,$68,$78
	DC.B	$88,$98,$A8,$B8,$C8,$D8,$E8,$F8
	DC.B	$09,$19,$29,$39,$49,$59,$69,$79
	DC.B	$89,$99,$A9,$B9,$C9,$D9,$E9,$F9
	DC.B	$0A,$1A,$2A,$3A,$4A,$5A,$6A,$7A
	DC.B	$8A,$9A,$AA,$BA,$CA,$DA,$EA,$FA
	DC.B	$0B,$1B,$2B,$3B,$4B,$5B,$6B,$7B
	DC.B	$8B,$9B,$AB,$BB,$CB,$DB,$EB,$FB
	DC.B	$0C,$1C,$2C,$3C,$4C,$5C,$6C,$7C
	DC.B	$8C,$9C,$AC,$BC,$CC,$DC,$EC,$FC
	DC.B	$0D,$1D,$2D,$3D,$4D,$5D,$6D,$7D
	DC.B	$8D,$9D,$AD,$BD,$CD,$DD,$ED,$FD
	DC.B	$0E,$1E,$2E,$3E,$4E,$5E,$6E,$7E
	DC.B	$8E,$9E,$AE,$BE,$CE,$DE,$EE,$FE
	DC.B	$0F,$1F,$2F,$3F,$4F,$5F,$6F,$7F
	DC.B	$8F,$9F,$AF,$BF,$CF,$DF,$EF,$FF
c2b_pentab5
	DC.B	$00,$08,$10,$18,$20,$28,$30,$38
	DC.B	$40,$48,$50,$58,$60,$68,$70,$78
	DC.B	$80,$88,$90,$98,$A0,$A8,$B0,$B8
	DC.B	$C0,$C8,$D0,$D8,$E0,$E8,$F0,$F8
	DC.B	$01,$09,$11,$19,$21,$29,$31,$39
	DC.B	$41,$49,$51,$59,$61,$69,$71,$79
	DC.B	$81,$89,$91,$99,$A1,$A9,$B1,$B9
	DC.B	$C1,$C9,$D1,$D9,$E1,$E9,$F1,$F9
	DC.B	$02,$0A,$12,$1A,$22,$2A,$32,$3A
	DC.B	$42,$4A,$52,$5A,$62,$6A,$72,$7A
	DC.B	$82,$8A,$92,$9A,$A2,$AA,$B2,$BA
	DC.B	$C2,$CA,$D2,$DA,$E2,$EA,$F2,$FA
	DC.B	$03,$0B,$13,$1B,$23,$2B,$33,$3B
	DC.B	$43,$4B,$53,$5B,$63,$6B,$73,$7B
	DC.B	$83,$8B,$93,$9B,$A3,$AB,$B3,$BB
	DC.B	$C3,$CB,$D3,$DB,$E3,$EB,$F3,$FB
	DC.B	$04,$0C,$14,$1C,$24,$2C,$34,$3C
	DC.B	$44,$4C,$54,$5C,$64,$6C,$74,$7C
	DC.B	$84,$8C,$94,$9C,$A4,$AC,$B4,$BC
	DC.B	$C4,$CC,$D4,$DC,$E4,$EC,$F4,$FC
	DC.B	$05,$0D,$15,$1D,$25,$2D,$35,$3D
	DC.B	$45,$4D,$55,$5D,$65,$6D,$75,$7D
	DC.B	$85,$8D,$95,$9D,$A5,$AD,$B5,$BD
	DC.B	$C5,$CD,$D5,$DD,$E5,$ED,$F5,$FD
	DC.B	$06,$0E,$16,$1E,$26,$2E,$36,$3E
	DC.B	$46,$4E,$56,$5E,$66,$6E,$76,$7E
	DC.B	$86,$8E,$96,$9E,$A6,$AE,$B6,$BE
	DC.B	$C6,$CE,$D6,$DE,$E6,$EE,$F6,$FE
	DC.B	$07,$0F,$17,$1F,$27,$2F,$37,$3F
	DC.B	$47,$4F,$57,$5F,$67,$6F,$77,$7F
	DC.B	$87,$8F,$97,$9F,$A7,$AF,$B7,$BF
	DC.B	$C7,$CF,$D7,$DF,$E7,$EF,$F7,$FF
c2b_pentab6
	DC.B	$00,$04,$08,$0C,$10,$14,$18,$1C
	DC.B	$20,$24,$28,$2C,$30,$34,$38,$3C
	DC.B	$40,$44,$48,$4C,$50,$54,$58,$5C
	DC.B	$60,$64,$68,$6C,$70,$74,$78,$7C
	DC.B	$80,$84,$88,$8C,$90,$94,$98,$9C
	DC.B	$A0,$A4,$A8,$AC,$B0,$B4,$B8,$BC
	DC.B	$C0,$C4,$C8,$CC,$D0,$D4,$D8,$DC
	DC.B	$E0,$E4,$E8,$EC,$F0,$F4,$F8,$FC
	DC.B	$01,$05,$09,$0D,$11,$15,$19,$1D
	DC.B	$21,$25,$29,$2D,$31,$35,$39,$3D
	DC.B	$41,$45,$49,$4D,$51,$55,$59,$5D
	DC.B	$61,$65,$69,$6D,$71,$75,$79,$7D
	DC.B	$81,$85,$89,$8D,$91,$95,$99,$9D
	DC.B	$A1,$A5,$A9,$AD,$B1,$B5,$B9,$BD
	DC.B	$C1,$C5,$C9,$CD,$D1,$D5,$D9,$DD
	DC.B	$E1,$E5,$E9,$ED,$F1,$F5,$F9,$FD
	DC.B	$02,$06,$0A,$0E,$12,$16,$1A,$1E
	DC.B	$22,$26,$2A,$2E,$32,$36,$3A,$3E
	DC.B	$42,$46,$4A,$4E,$52,$56,$5A,$5E
	DC.B	$62,$66,$6A,$6E,$72,$76,$7A,$7E
	DC.B	$82,$86,$8A,$8E,$92,$96,$9A,$9E
	DC.B	$A2,$A6,$AA,$AE,$B2,$B6,$BA,$BE
	DC.B	$C2,$C6,$CA,$CE,$D2,$D6,$DA,$DE
	DC.B	$E2,$E6,$EA,$EE,$F2,$F6,$FA,$FE
	DC.B	$03,$07,$0B,$0F,$13,$17,$1B,$1F
	DC.B	$23,$27,$2B,$2F,$33,$37,$3B,$3F
	DC.B	$43,$47,$4B,$4F,$53,$57,$5B,$5F
	DC.B	$63,$67,$6B,$6F,$73,$77,$7B,$7F
	DC.B	$83,$87,$8B,$8F,$93,$97,$9B,$9F
	DC.B	$A3,$A7,$AB,$AF,$B3,$B7,$BB,$BF
	DC.B	$C3,$C7,$CB,$CF,$D3,$D7,$DB,$DF
	DC.B	$E3,$E7,$EB,$EF,$F3,$F7,$FB,$FF
c2b_pentab7
	DC.B	$00,$02,$04,$06,$08,$0A,$0C,$0E
	DC.B	$10,$12,$14,$16,$18,$1A,$1C,$1E
	DC.B	$20,$22,$24,$26,$28,$2A,$2C,$2E
	DC.B	$30,$32,$34,$36,$38,$3A,$3C,$3E
	DC.B	$40,$42,$44,$46,$48,$4A,$4C,$4E
	DC.B	$50,$52,$54,$56,$58,$5A,$5C,$5E
	DC.B	$60,$62,$64,$66,$68,$6A,$6C,$6E
	DC.B	$70,$72,$74,$76,$78,$7A,$7C,$7E
	DC.B	$80,$82,$84,$86,$88,$8A,$8C,$8E
	DC.B	$90,$92,$94,$96,$98,$9A,$9C,$9E
	DC.B	$A0,$A2,$A4,$A6,$A8,$AA,$AC,$AE
	DC.B	$B0,$B2,$B4,$B6,$B8,$BA,$BC,$BE
	DC.B	$C0,$C2,$C4,$C6,$C8,$CA,$CC,$CE
	DC.B	$D0,$D2,$D4,$D6,$D8,$DA,$DC,$DE
	DC.B	$E0,$E2,$E4,$E6,$E8,$EA,$EC,$EE
	DC.B	$F0,$F2,$F4,$F6,$F8,$FA,$FC,$FE
	DC.B	$01,$03,$05,$07,$09,$0B,$0D,$0F
	DC.B	$11,$13,$15,$17,$19,$1B,$1D,$1F
	DC.B	$21,$23,$25,$27,$29,$2B,$2D,$2F
	DC.B	$31,$33,$35,$37,$39,$3B,$3D,$3F
	DC.B	$41,$43,$45,$47,$49,$4B,$4D,$4F
	DC.B	$51,$53,$55,$57,$59,$5B,$5D,$5F
	DC.B	$61,$63,$65,$67,$69,$6B,$6D,$6F
	DC.B	$71,$73,$75,$77,$79,$7B,$7D,$7F
	DC.B	$81,$83,$85,$87,$89,$8B,$8D,$8F
	DC.B	$91,$93,$95,$97,$99,$9B,$9D,$9F
	DC.B	$A1,$A3,$A5,$A7,$A9,$AB,$AD,$AF
	DC.B	$B1,$B3,$B5,$B7,$B9,$BB,$BD,$BF
	DC.B	$C1,$C3,$C5,$C7,$C9,$CB,$CD,$CF
	DC.B	$D1,$D3,$D5,$D7,$D9,$DB,$DD,$DF
	DC.B	$E1,$E3,$E5,$E7,$E9,$EB,$ED,$EF
	DC.B	$F1,$F3,$F5,$F7,$F9,$FB,$FD,$FF
c2b_pentab8
	DC.B	$00,$01,$02,$03,$04,$05,$06,$07
	DC.B	$08,$09,$0A,$0B,$0C,$0D,$0E,$0F
	DC.B	$10,$11,$12,$13,$14,$15,$16,$17
	DC.B	$18,$19,$1A,$1B,$1C,$1D,$1E,$1F
	DC.B	$20,$21,$22,$23,$24,$25,$26,$27
	DC.B	$28,$29,$2A,$2B,$2C,$2D,$2E,$2F
	DC.B	$30,$31,$32,$33,$34,$35,$36,$37
	DC.B	$38,$39,$3A,$3B,$3C,$3D,$3E,$3F
	DC.B	$40,$41,$42,$43,$44,$45,$46,$47
	DC.B	$48,$49,$4A,$4B,$4C,$4D,$4E,$4F
	DC.B	$50,$51,$52,$53,$54,$55,$56,$57
	DC.B	$58,$59,$5A,$5B,$5C,$5D,$5E,$5F
	DC.B	$60,$61,$62,$63,$64,$65,$66,$67
	DC.B	$68,$69,$6A,$6B,$6C,$6D,$6E,$6F
	DC.B	$70,$71,$72,$73,$74,$75,$76,$77
	DC.B	$78,$79,$7A,$7B,$7C,$7D,$7E,$7F
	DC.B	$80,$81,$82,$83,$84,$85,$86,$87
	DC.B	$88,$89,$8A,$8B,$8C,$8D,$8E,$8F
	DC.B	$90,$91,$92,$93,$94,$95,$96,$97
	DC.B	$98,$99,$9A,$9B,$9C,$9D,$9E,$9F
	DC.B	$A0,$A1,$A2,$A3,$A4,$A5,$A6,$A7
	DC.B	$A8,$A9,$AA,$AB,$AC,$AD,$AE,$AF
	DC.B	$B0,$B1,$B2,$B3,$B4,$B5,$B6,$B7
	DC.B	$B8,$B9,$BA,$BB,$BC,$BD,$BE,$BF
	DC.B	$C0,$C1,$C2,$C3,$C4,$C5,$C6,$C7
	DC.B	$C8,$C9,$CA,$CB,$CC,$CD,$CE,$CF
	DC.B	$D0,$D1,$D2,$D3,$D4,$D5,$D6,$D7
	DC.B	$D8,$D9,$DA,$DB,$DC,$DD,$DE,$DF
	DC.B	$E0,$E1,$E2,$E3,$E4,$E5,$E6,$E7
	DC.B	$E8,$E9,$EA,$EB,$EC,$ED,$EE,$EF
	DC.B	$F0,$F1,$F2,$F3,$F4,$F5,$F6,$F7
	DC.B	$F8,$F9,$FA,$FB,$FC,$FD,$FE,$FF


;---------------------------------------------------------------------------
;===========================================================================


;==============================================================================
;
;		Aufruf der Init-Funktion:
;
;		source,dest = conv_initfunc(struc)
;		a0     a1                   a5
;
;
;		Aufruf der Zeilenfunktion:
;
;		sourceoffset,destoffset = conv_func(source,dest,struc)
;		d0           d1                     a0     a1   a5
;
;==============================================================================


;------------------------------------------------------------------------------
;
;	Init_Chunky2RGB
;
;	>	a5	Conv-Struktur
;			s,d,sx,sy,dx,dy,width,tswidth,tdwidth,scm,spalette,pentabptr
;	<	a0	Source
;		a1	Dest
;
;------------------------------------------------------------------------------

Init_Chunky2RGB

		lea	(Func_Chunky2RGB_close,pc),a1
		move.l	a1,(conv_closefunc,a5)		

		moveq	#COLORMODE_MASK,d0
		and.w	(conv_sourcecolormode,a5),d0

		lea	(Func_Chunky2RGB_clut,pc),a1
		tst.l	(conv_pentabptr,a5)
		beq.b	.ok1

		lea	(Func_Chunky2RGB_clut_pentab,pc),a1
.ok1		cmp.w	#COLORMODE_CLUT,d0
		beq.b	.ok

		lea	(Func_Chunky2RGB_ham8,pc),a1
		cmp.w	#COLORMODE_HAM8,d0
		beq.b	.ok

		lea	(Func_Chunky2RGB_ham6,pc),a1
		cmp.w	#COLORMODE_HAM6,d0
		beq.b	.ok

		illegal

.ok		move.l	a1,(conv_func,a5)

		moveq	#15,d0
		and.w	(conv_width,a5),d0
		subq.w	#1,d0
		move.w	d0,(conv_user1,a5)		; 1er Durchläufe
		
		move.w	(conv_width,a5),d0
		lsr.w	#4,d0
		subq.w	#1,d0
		move.w	d0,(conv_user2,a5)		; 16er Durchläufe

		move.w	(conv_sourcey,a5),d0
		mulu.w	(conv_totalsourcewidth,a5),d0
		lea	([conv_source,a5],d0.l),a0

		moveq	#COLORMODE_MASK,d0
		and.w	(conv_sourcecolormode,a5),d0
		cmp.w	#COLORMODE_CLUT,d0
		bne.b	.sourcexok

		add.w	(conv_sourcex,a5),a0		; SourceX bei HAM nicht addieren

.sourcexok	move.w	(conv_desty,a5),d0
		mulu.w	(conv_totaldestwidth,a5),d0
		moveq	#0,d1
		move.w	(conv_destx,a5),d1
		add.l	d1,d0
		lea	([conv_dest,a5],d0.l*4),a1	; Dest

		moveq	#0,d0
		move.w	(conv_totalsourcewidth,a5),d0
		move.l	d0,(conv_sourceoffset,a5)
		
		moveq	#0,d0
		move.w	(conv_totaldestwidth,a5),d0
		lsl.l	#2,d0
		move.l	d0,(conv_destoffset,a5)
		
		rts		

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

Func_Chunky2RGB_close
		rts

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

Func_Chunky2RGB_clut

		movem.l	a0-a2,-(a7)

		lea	([conv_sourcepalette,a5],pal_palette),a2

		moveq	#0,d0

		move.w	(conv_user2,a5),d1
		bmi	.no16er

		movem.l	d5-d7,-(a7)
		moveq	#0,d5
		moveq	#0,d6
		moveq	#0,d7
.xlop16
		REPT	2

		move.b	(a0)+,d0
		moveq	#0,d7
		move.b	(a0)+,d5
		swap	d0
		move.b	(a0)+,d6
		swap	d5
		move.b	(a0)+,d7
		swap	d6
		move.b	(a0)+,d0
		swap	d7
		move.b	(a0)+,d5
		swap	d0
		move.b	(a0)+,d6
		swap	d5
		move.b	(a0)+,d7
		swap	d6

		move.l	(a2,d0.w*4),(a1)+
		swap	d7
		move.l	(a2,d5.w*4),(a1)+
		swap	d0
		move.l	(a2,d6.w*4),(a1)+
		swap	d5
		move.l	(a2,d7.w*4),(a1)+

		swap	d6
		move.l	(a2,d0.w*4),d0
		swap	d7
		move.l	(a2,d5.w*4),d5
		move.l	(a2,d6.w*4),d6
		move.l	(a2,d7.w*4),d7

		move.l	d0,(a1)+
		move.l	d5,(a1)+
		moveq	#0,d0
		move.l	d6,(a1)+
		moveq	#0,d5
		move.l	d7,(a1)+
		moveq	#0,d6

		ENDR

		dbf	d1,.xlop16

		movem.l	(a7)+,d5-d7

.no16er		move.w	(conv_user1,a5),d1
		bmi.b	.no1er

.xlop1		move.b	(a0)+,d0
		move.l	(a2,d0.w*4),(a1)+
		dbf	d1,.xlop1

.no1er		movem.l	(a7)+,a0-a2

		move.l	(conv_sourceoffset,a5),d0
		move.l	(conv_destoffset,a5),d1
		rts

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

Func_Chunky2RGB_clut_pentab

		movem.l	a0-a3,-(a7)

		lea	([conv_sourcepalette,a5],pal_palette),a2

		move.l	(conv_pentabptr,a5),a3

		moveq	#0,d0

		move.w	(conv_user2,a5),d1
		bmi	.no16er

		movem.l	d5-d7,-(a7)
		moveq	#0,d0
.xlop16
		REPT	4
		moveq	#0,d5
		move.b	(a0)+,d0		; Konstruktion zur
		moveq	#0,d6
		move.b	(a0)+,d5		; besseren DCache-Nutzung
		moveq	#0,d7
		move.b	(a0)+,d6
		move.b	(a0)+,d7

		move.b	(a3,d0.w),d0
		move.b	(a3,d5.w),d5
		move.b	(a3,d6.w),d6
		move.b	(a3,d7.w),d7

		move.l	(a2,d0.w*4),d0
		move.l	(a2,d5.w*4),d5
		move.l	(a2,d6.w*4),d6
		move.l	(a2,d7.w*4),d7
		
		move.l	d0,(a1)+
		move.l	d5,(a1)+
		move.l	d6,(a1)+
		moveq	#0,d0
		move.l	d7,(a1)+
		ENDR

		dbf	d1,.xlop16

		movem.l	(a7)+,d5-d7

.no16er		move.w	(conv_user1,a5),d1
		bmi.b	.no1er

.xlop1		move.b	(a0)+,d0
		move.b	(a3,d0.w),d0		; PenTab!
		move.l	(a2,d0.w*4),(a1)+
		dbf	d1,.xlop1

.no1er		movem.l	(a7)+,a0-a3

		move.l	(conv_sourceoffset,a5),d0
		move.l	(conv_destoffset,a5),d1
		rts

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

Func_Chunky2RGB_ham8

		movem.l	a0-a2/d2-d4,-(a7)

		lea	([conv_sourcepalette,a5],pal_palette),a2

		moveq	#%111111,d4
		moveq	#0,d3
		moveq	#0,d0
		move.l	(a2),d1			; am Zeilenanfang: akt. RGB = Farbe 0

		move.w	(conv_sourcex,a5),d2
		beq.b	.startOK
		subq.w	#1,d2

.preploop	move.b	(a0)+,d0
		move.b	.h8chunkytab(pc,d0.w),d3
		bne.b	.prmodify

		and.w	d4,d0
		move.l	(a2,d0.w*4),d1
		dbf	d2,.preploop
		bra.b	.startOK

.prmodify	bfins	d0,d1{d3:6}
		dbf	d2,.preploop
		
.startOK	move.w	(conv_width,a5),d2
		subq.w	#1,d2

.xloop1		move.b	(a0)+,d0
		move.b	.h8chunkytab(pc,d0.w),d3
		bne.b	.modify1

		and.w	d4,d0
		move.l	(a2,d0.w*4),d1
		move.l	d1,(a1)+
		dbf	d2,.xloop1
		bra.b	.x1ok

.modify1	bfins	d0,d1{d3:6}
		move.l	d1,(a1)+
		dbf	d2,.xloop1

.x1ok		movem.l	(a7)+,a0-a2/d2-d4

		move.l	(conv_sourceoffset,a5),d0
		move.l	(conv_destoffset,a5),d1
		rts

.h8chunkytab	dcb.b	64,0
		dcb.b	64,24
		dcb.b	64,8
		dcb.b	64,16

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

Func_Chunky2RGB_ham6

		movem.l	a0-a2/d2-d4,-(a7)

		lea	([conv_sourcepalette,a5],pal_palette),a2

		moveq	#0,d3
		moveq	#%1111,d4
		moveq	#0,d0
		move.l	(a2),d1			; am Zeilenanfang: akt. RGB = Farbe 0

		move.w	(conv_sourcex,a5),d2
		beq.b	.startOK
		subq.w	#1,d2

.preploop	move.b	(a0)+,d0
		move.b	.h6chunkytab(pc,d0.w),d3
		bne.b	.prmodify

		and.w	d4,d0
		move.l	(a2,d0.w*4),d1
		dbf	d2,.preploop
		bra.b	.startOK

.prmodify	bfins	d0,d1{d3:4}
		dbf	d2,.preploop

.startOK	move.w	(conv_width,a5),d2
		subq.w	#1,d2

.xloop1		move.b	(a0)+,d0
		move.b	.h6chunkytab(pc,d0.w),d3
		bne.b	.modify1

		and.w	d4,d0
		move.l	(a2,d0.w*4),d1
		move.l	d1,(a1)+
		dbf	d2,.xloop1
		bra.b	.ok

.modify1	bfins	d0,d1{d3:4}
		move.l	d1,(a1)+
		dbf	d2,.xloop1

.ok		movem.l	(a7)+,a0-a2/d2-d4

		move.l	(conv_sourceoffset,a5),d0
		move.l	(conv_destoffset,a5),d1
		rts

.h6chunkytab	dcb.b	16,0
		dcb.b	16,24
		dcb.b	16,8
		dcb.b	16,16

;------------------------------------------------------------------------------




;         /\
;    ____/  \____   
;    \   \  /|  / 				     $VER: Chunky2RGB v2.0
;==== \   \/ | / =========================================================
;----- \   | |/ ----------------------------------------------------------
;       \  | /
;        \ |/	Chunky2RGB v2.0
;         \/
;
;		Konvertiert Chunky8 in RGB24.
;
;	>	a0	UBYTE *	Chunky-Buffer
;		d0	UWORD	width
;		d1	UWORD	height
;		a1	ULONG * RGB
;		a2	APTR	Palette
;		a3	struct TagItem *
;	Tags:
;		RND_SourceWidth
;		RND_DestWidth
;		RND_ColorMode
;		RND_LeftEdge
;		RND_ProgressHook
;		RND_PenTable
;
;------------------------------------------------------------------------

Chunky2RGB:	LockShared	pal_semaphore(a2)

		movem.l	d2-d7/a4-a6,-(a7)

		sub.w	#conv_SIZEOF,a7
		move.l	a7,a5

		moveq	#0,d5
		move.w	d1,d5				; Höhe
		move.w	d5,(conv_height,a5)

		move.l	a0,(conv_source,a5)
		move.l	a1,(conv_dest,a5)
		move.w	d0,(conv_width,a5)
		move.l	a2,(conv_sourcepalette,a5)

		move.l	(utilitybase,pc),a6

		move.w	d0,d2
		GetTag	#RND_SourceWidth,d2,a3
		move.w	d0,(conv_totalsourcewidth,a5)

		GetTag	#RND_DestWidth,d2,a3
		move.w	d0,(conv_totaldestwidth,a5)
		
		GetTag	#RND_ColorMode,#COLORMODE_CLUT,a3
		move.w	d0,(conv_sourcecolormode,a5)

		GetTag	#RND_LeftEdge,#0,a3
		move.w	d0,(conv_sourcex,a5)
		clr.w	(conv_sourcey,a5)
		clr.w	(conv_destx,a5)
		clr.w	(conv_desty,a5)

		GetTag	#RND_LineHook,#0,a3
		move.l	d0,a4

		GetTag	#RND_ProgressHook,#0,a3
		move.l	d0,d6

		GetTag	#RND_PenTable,#0,a3
		move.l	d0,(conv_pentabptr,a5)

		bsr	Init_Chunky2RGB

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

		subq.w	#1,d5


.yloop			move.l	a4,d0
			beq.b	.nolcb1

			moveq	#0,d3
			move.w	(conv_height,a5),d3
			sub.w	d5,d3				; Count
			subq.l	#1,d3
			moveq	#LMSGTYPE_LINE_FETCH,d2		; Messagetyp
			move.l	a0,d1				; Objekt
			LINECALLBACK
			moveq	#CONV_CALLBACK_ABORTED,d7
			tst.w	d0
			beq.w	.abort

.nolcb1		jsr	([conv_func,a5])
		add.l	d0,a0
		
			move.l	a4,d0
			beq.b	.nolcb2

			move.l	d1,-(a7)			
			moveq	#0,d3
			move.w	(conv_height,a5),d3
			sub.w	d5,d3				; Count
			subq.l	#1,d3
			moveq	#LMSGTYPE_LINE_RENDERED,d2	; Messagetyp
			move.l	a1,d1				; Objekt
			LINECALLBACK
			move.l	(a7)+,d1
			moveq	#CONV_CALLBACK_ABORTED,d7
			tst.w	d0
			beq.b	.abort

.nolcb2		add.l	d1,a1

			move.l	d6,d0
			beq.b	.nocb

			moveq	#0,d3
			move.w	(conv_height,a5),d3		; Gesamt
			sub.w	d5,d3				; Count
			moveq	#0,d1				; Objekt
			moveq	#PMSGTYPE_LINES_CONVERTED,d2	; Messagetyp
			PROGRESSCALLBACK
			moveq	#CONV_CALLBACK_ABORTED,d7
			tst.w	d0
			beq.b	.abort
.nocb
		dbf	d5,.yloop		

		moveq	#CONV_SUCCESS,d7

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

.abort		jsr	([conv_closefunc,a5])


		add.w	#conv_SIZEOF,a7

		move.l	d7,d0
		movem.l	(a7)+,d2-d7/a4-a6

		Unlock		pal_semaphore(a2)
		rts

;=====================================================================


;????	IFNE	0

;         /\
;    ____/  \____   
;    \   \  /|  /
;==== \   \/ | / =========================================================
;----- \   | |/ ----------------------------------------------------------
;       \  | /
;        \ |/	RGBArrayDiversity ( rgb, width, height, tags )
;         \/	
;
;		berechnet die Pixeldiversität eines RGB-Arrays.
;		Wird weder eine MappingEngine, eine Palette, noch
;		ein Histogramm übergeben, dann ... [?]
;		
;
;	>	a0	ULONG *		SourceImage
;		d0	UWORD		width
;		d1	UWORD		height
;		a1	struct TagItem *taglist
;	<	d0	LONG		Pixeldiversität
;					oder -1, wenn Fehler
;
;	Tags:
;		RND_SourceWidth
;
;		RND_Interleave
;			jeweils #Anzahl Pixel überspringen
;
;		RND_Palette
;			berechnet die Diversität gegenüber
;			einer Palette.
;		RND_MapEngine
;			berechnet die Diversität gegenüber
;			der Palette einer Mapping-Engine.
;
;------------------------------------------------------------------------

	STRUCTURE	rad_localdata,0
		APTR	rad_array
		UWORD	rad_width
		UWORD	rad_height
		ULONG	rad_totalsourcewidth	; *4 für RGB-Daten!
		ULONG	rad_numpixels
		UWORD	rad_increment
		UWORD	rad_increment4
		APTR	rad_object
		APTR	rad_palette
		APTR	rad_histogram
	LABEL		rad_SIZEOF

;------------------------------------------------------------------------

RGBArrayDiversity:

		movem.l	d2-d7/a2-a6,-(a7)

		sub.w	#rad_SIZEOF,a7
		move.l	a7,a5

		move.w	d0,(rad_width,a5)
		move.w	d1,(rad_height,a5)
		move.l	a0,(rad_array,a5)
		move.l	a1,a4

		mulu.w	d1,d0
		move.l	d0,(rad_numpixels,a5)


		move.l	(utilitybase,pc),a6

		moveq	#0,d7
		move.w	(rad_width,a5),d7
		GetTag	#RND_SourceWidth,d7,a4
		asl.l	#2,d0
		move.l	d0,(rad_totalsourcewidth,a5)


		GetTag	#RND_Interleave,#0,a4
		addq.w	#1,d0
		move.w	d0,(rad_increment,a5)
		lsl.w	#2,d0
		move.w	d0,(rad_increment4,a5)


		GetTag	#RND_MapEngine,#0,a4
		move.l	d0,(rad_object,a5)
		tst.l	d0
		bne	.mapengine

		GetTag	#RND_Palette,#0,a4
		move.l	d0,(rad_object,a5)
		tst.l	d0
		bne.b	.pal



		moveq	#-1,d7
		bra	.continue

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

.pal		move.l	(rad_object,a5),a4
		move.l	a4,a0
		
		Lock	pal_semaphore(a0)

		moveq	#-1,d7
		bsr	PAL_CreateP2Table		; p2valid
		tst.l	d0
		beq	.palraus
		move.l	d0,a1				; p2Table

		move.l	(rad_array,a5),a0		; RGBDaten
		lea	(pal_palette,a4),a2		; Palette

		moveq	#0,d4		; d4:d5		64Bit-Diversity
		moveq	#0,d5

		move.l	#$ffffff,d6			; Maske
		moveq	#8,d7
		sub.w	(pal_p2bitspergun,a4),d7	; #Bits Shift

.palyloop	move.w	(rad_width,a5),a3			; X-Zähler
		move.l	a0,-(a7)

.palxloop	move.l	(a0),d2			; RGB

		and.l	d6,d2

		move.l	d2,d0
		lsr.l	d7,d2
		lsl.b	d7,d2
		lsl.w	d7,d2
		lsr.l	d7,d2
		moveq	#0,d1
		lsr.l	d7,d2			; Tabellenoffset
		move.w	(a1,d2.l*2),d1		; best Pen
		bpl.b	.penok
		

		movem.l	d0/d2/d4-d5/a3,-(a7)
		lea	(pal_wordpalette,a4),a2
		lea	(quadtab.l,pc),a3
		move.w	(pal_numcolors,a4),d4

		FINDPEN_PALETTE			; trash: d1-d7/a2/[a3]
		move.w	d0,d1
		movem.l	(a7)+,d0/d2/d4-d5/a3

		move.w	d1,(a1,d2.l*2)			; eintragen

		lea	(pal_palette,a4),a2		; Palette
		move.l	#$ffffff,d6			; Maske
		moveq	#8,d7
		sub.w	(pal_p2bitspergun,a4),d7	; #Bits Shift


.penok		move.l	(a2,d1.w*4),d1		; RGB

		DIVERSITY

		moveq	#0,d1
		add.l	d0,d5
		addx.l	d1,d4


		add.w	(rad_increment4,a5),a0

		sub.w	(rad_increment,a5),a3
		move.w	a3,d0
		bgt	.palxloop

		move.l	(a7)+,a0

		add.l	(rad_totalsourcewidth,a5),a0

		subq.w	#1,(rad_height,a5)
		bne	.palyloop

		bsr	.ergebnis

.palraus	move.l	(rad_object,a5),a0
		Unlock	pal_semaphore(a0)
		bra	.continue

		
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

.mapengine	move.l	(rad_object,a5),a4
		move.l	a4,a0

		Lock	map_semaphore(a0)

		moveq	#-1,d7
		bsr.l	UpdateMappingEngine
		tst.l	d0
		beq	.mapraus



		move.l	(rad_array,a5),a0			; RGBDaten
		move.l	(map_p1table,a4),a1			; p1Table
		lea	([map_palette,a4],pal_palette),a2	; Palette

		moveq	#0,d4		; d4:d5		64Bit-Diversity
		moveq	#0,d5

		move.l	#$ffffff,d6		; Maske
		moveq	#8,d7
		sub.w	(map_bitspergun,a4),d7	; #Bits Shift


.mapyloop	move.w	(rad_width,a5),a3			; X-Zähler
		move.l	a0,-(a7)

.mapxloop	move.l	(a0),d2			; RGB
		and.l	d6,d2
		move.l	d2,d0
		lsr.l	d7,d2
		lsl.b	d7,d2
		lsl.w	d7,d2
		lsr.l	d7,d2
		moveq	#0,d1
		lsr.l	d7,d2			; Tabellenoffset
		move.b	(a1,d2.l),d1		; best Pen
		move.l	(a2,d1.w*4),d1		; RGB

		DIVERSITY

		moveq	#0,d1
		add.l	d0,d5
		addx.l	d1,d4


		add.w	(rad_increment4,a5),a0

		sub.w	(rad_increment,a5),a3
		move.w	a3,d0
		bgt.b	.mapxloop

		move.l	(a7)+,a0

		add.l	(rad_totalsourcewidth,a5),a0

		subq.w	#1,(rad_height,a5)
		bne.b	.mapyloop

		bsr.b	.ergebnis

.mapraus	move.l	(rad_object,a5),a0
		Unlock	map_semaphore(a0)

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

.continue	move.l	d7,d0
		add.w	#rad_SIZEOF,a7

		movem.l	(a7)+,d2-d7/a2-a6
		rts

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

.ergebnis

	IFEQ    USEFPU

		moveq	#0,d0
		move.w	(rad_increment,a5),d0
		mulu.l	d0,d4:d5
		move.l	(rad_numpixels,a5),d0
		divul.l	d0,d4:d5
		move.l	d5,d7

	ELSE
		fmove.x	fp0,-(a7)
		fmove.l	#$40000000,fp0
		fadd.x	fp0,fp0
		fadd.x	fp0,fp0
		fmul.l	d4,fp0
		lsr.l	#1,d5
		fadd.l	d5,fp0
		fadd.l	d5,fp0
		fmul.w	(rad_increment,a5),fp0
		fdiv.l	(rad_numpixels,a5),fp0
		fmove.l	fp0,d7
		fmove.x	(a7)+,fp0
	ENDC
		rts

;========================================================================

;????	ENDC


;         /\
;    ____/  \____   
;    \   \  /|  /
;==== \   \/ | / =========================================================
;----- \   | |/ ----------------------------------------------------------
;       \  | /
;        \ |/	ChunkyArrayDiversity ( chunky, palette, width, height, tags )
;         \/	
;
;		berechnet die Pixeldiversität eines RGB-Arrays.
;		Wird weder eine MappingEngine, eine Palette, noch
;		ein Histogramm übergeben, dann ... [?]
;		
;
;	>	a0	ULONG *		SourceImage
;		a1	APTR		SourcePalette
;		d0	UWORD		width
;		d1	UWORD		height
;		a2	struct TagItem *taglist
;	<	d0	LONG		Pixeldiversität
;					oder -1, wenn Fehler
;
;	Tags:
;		RND_SourceWidth
;
;		RND_Interleave
;			jeweils #Anzahl Pixel überspringen
;
;		RND_Palette
;			berechnet die Diversität gegenüber
;			einer Palette.
;		RND_MapEngine
;			berechnet die Diversität gegenüber
;			der Palette einer Mapping-Engine.
;
;------------------------------------------------------------------------

	STRUCTURE	cad_localdata,0
		APTR	cad_array
		UWORD	cad_width
		UWORD	cad_height
		ULONG	cad_totalsourcewidth	; *4 für RGB-Daten!
		ULONG	cad_numpixels
		UWORD	cad_increment
	;	UWORD	cad_increment4
		APTR	cad_object
		APTR	cad_palette
		APTR	cad_histogram
		APTR	cad_sourcepalette
	LABEL		cad_SIZEOF

;------------------------------------------------------------------------

ChunkyArrayDiversity:

		movem.l	d2-d7/a2-a6,-(a7)

		sub.w	#cad_SIZEOF,a7
		move.l	a7,a5

		move.w	d0,(cad_width,a5)
		move.w	d1,(cad_height,a5)
		move.l	a0,(cad_array,a5)
		move.l	a1,(cad_sourcepalette,a5)
		move.l	a2,a4

		mulu.w	d1,d0
		move.l	d0,(cad_numpixels,a5)


		move.l	(utilitybase,pc),a6

		moveq	#0,d7
		move.w	(cad_width,a5),d7
		GetTag	#RND_SourceWidth,d7,a4
		move.l	d0,(cad_totalsourcewidth,a5)


		GetTag	#RND_Interleave,#0,a4
		addq.w	#1,d0
		move.w	d0,(cad_increment,a5)
	;	lsl.w	#2,d0
	;	move.w	d0,(cad_increment4,a5)


		GetTag	#RND_MapEngine,#0,a4
		move.l	d0,(cad_object,a5)
		tst.l	d0
		bne	.mapengine

		GetTag	#RND_Palette,#0,a4
		move.l	d0,(cad_object,a5)
		tst.l	d0
		bne.b	.pal



		moveq	#-1,d7
		bra	.continue

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

.pal		move.l	(cad_object,a5),a4
		move.l	a4,a0
		
		Lock	pal_semaphore(a0)

		moveq	#-1,d7
		bsr	PAL_CreateP2Table		; p2valid
		tst.l	d0
		beq	.palraus
		move.l	d0,a1				; p2Table

		move.l	(cad_array,a5),a0		; Daten
		lea	(pal_palette,a4),a2			; DestPalette
		lea	([cad_sourcepalette,a5],pal_palette),a6	; SourcePalette

		moveq	#0,d4		; d4:d5		64Bit-Diversity
		moveq	#0,d5

	;	move.l	#$ffffff,d6			; Maske
		moveq	#8,d7
		sub.w	(pal_p2bitspergun,a4),d7	; #Bits Shift

.palyloop	move.w	(cad_width,a5),a3			; X-Zähler
		move.l	a0,-(a7)

.palxloop	moveq	#0,d1
		move.b	(a0),d1			; RGB
		move.l	(a6,d1.w*4),d2				

	;	and.l	d6,d2
		move.l	d2,d0
		lsr.l	d7,d2
		lsl.b	d7,d2
		lsl.w	d7,d2
		lsr.l	d7,d2
	;	moveq	#0,d1
		lsr.l	d7,d2			; Tabellenoffset
		move.w	(a1,d2.l*2),d1		; best Pen
		bpl.b	.penok
		

		movem.l	d0/d2/d4-d5/a3,-(a7)
		lea	(pal_wordpalette,a4),a2
		lea	(quadtab.l,pc),a3
		move.w	(pal_numcolors,a4),d4

		FINDPEN_PALETTE			; trash: d1-d7/a2/[a3]
		move.w	d0,d1
		movem.l	(a7)+,d0/d2/d4-d5/a3

		move.w	d1,(a1,d2.l*2)			; eintragen

		lea	(pal_palette,a4),a2		; Palette
		move.l	#$ffffff,d6			; Maske
		moveq	#8,d7
		sub.w	(pal_p2bitspergun,a4),d7	; #Bits Shift


.penok		move.l	(a2,d1.w*4),d1		; RGB

		DIVERSITY

		moveq	#0,d1
		add.l	d0,d5
		addx.l	d1,d4

		move.w	(cad_increment,a5),d1
		add.w	d1,a0

		sub.w	d1,a3
		move.w	a3,d0
		bgt	.palxloop

		move.l	(a7)+,a0

		add.l	(cad_totalsourcewidth,a5),a0

		subq.w	#1,(cad_height,a5)
		bne	.palyloop

		bsr	.ergebnis

.palraus	move.l	(cad_object,a5),a0
		Unlock	pal_semaphore(a0)
		bra	.continue

		
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

.mapengine	move.l	(cad_object,a5),a4
		move.l	a4,a0

		Lock	map_semaphore(a0)

		moveq	#-1,d7
		bsr.l	UpdateMappingEngine
		tst.l	d0
		beq	.mapraus



		move.l	(cad_array,a5),a0			; RGBDaten
		move.l	(map_p1table,a4),a1			; p1Table
		lea	([map_palette,a4],pal_palette),a2	; Palette
		lea	([cad_sourcepalette,a5],pal_palette),a6	; SourcePalette

		moveq	#0,d4		; d4:d5		64Bit-Diversity
		moveq	#0,d5

	;	move.l	#$ffffff,d6		; Maske
		moveq	#8,d7
		sub.w	(map_bitspergun,a4),d7	; #Bits Shift


.mapyloop	move.w	(cad_width,a5),a3			; X-Zähler
		move.l	a0,-(a7)

.mapxloop	moveq	#0,d1
		move.b	(a0),d1			; RGB
		move.l	(a6,d1.w*4),d2
	;	and.l	d6,d2
		move.l	d2,d0
		lsr.l	d7,d2
		lsl.b	d7,d2
		lsl.w	d7,d2
		lsr.l	d7,d2
	;	moveq	#0,d1
		lsr.l	d7,d2			; Tabellenoffset
		move.b	(a1,d2.l),d1		; best Pen
		move.l	(a2,d1.w*4),d1		; RGB

		DIVERSITY

		moveq	#0,d1
		add.l	d0,d5
		addx.l	d1,d4


		move.w	(cad_increment,a5),d1
		add.w	d1,a0

		sub.w	d1,a3
		move.w	a3,d0
		bgt.b	.mapxloop

		move.l	(a7)+,a0

		add.l	(cad_totalsourcewidth,a5),a0

		subq.w	#1,(cad_height,a5)
		bne.b	.mapyloop

		bsr.b	.ergebnis

.mapraus	move.l	(cad_object,a5),a0
		Unlock	map_semaphore(a0)

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

.continue	move.l	d7,d0
		add.w	#cad_SIZEOF,a7

		movem.l	(a7)+,d2-d7/a2-a6
		rts

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

.ergebnis

	IFEQ    USEFPU

		moveq	#0,d0
		move.w	(cad_increment,a5),d0
		mulu.l	d0,d4:d5
		move.l	(cad_numpixels,a5),d0
		divul.l	d0,d4:d5
		move.l	d5,d7

	ELSE
		fmove.x	fp0,-(a7)
		fmove.l	#$40000000,fp0
		fadd.x	fp0,fp0
		fadd.x	fp0,fp0
		fmul.l	d4,fp0
		lsr.l	#1,d5
		fadd.l	d5,fp0
		fadd.l	d5,fp0
		fmul.w	(cad_increment,a5),fp0
		fdiv.l	(cad_numpixels,a5),fp0
		fmove.l	fp0,d7
		fmove.x	(a7)+,fp0
	ENDC
		rts

;========================================================================

;====================================================================
;--------------------------------------------------------------------
;
;		RemapArray
;
;		mappt ein Chunky-Array über eine pentab
;
;	>	a0	UBYTE *	sourcearray
;		d0	UWORD	width
;		d1	UWORD	height
;		a1	UBYTE * destarray
;		a2	UBYTE * pentab
;		a3	Taglist
;
;	Tags	RND_SourceWidth		- Gesamtbreite sourceArray
;		RND_DestWidth		- Gesamtbreite destArray		
;
;--------------------------------------------------------------------

RemapArray:
		movem.l	d2-d7/a2-a6,-(a7)

		move.l	a0,a4		; source
		move.l	a1,a5		; dest
		moveq	#0,d6
		move.w	d0,d6		; width
		move.w	d1,d7		; height

		move.l	(utilitybase,pc),a6

		GetTag	#RND_SourceWidth,d6,a3
		sub.w	d6,d0
		move.w	d0,d4		; sourcemodulo

		GetTag	#RND_DestWidth,d6,a3
		sub.w	d6,d0
		move.w	d0,d5		; destmodulo


		moveq	#0,d0

.yloop		move.w	d6,d3

.xloop		move.b	(a4)+,d0

		move.b	(a2,d0.w),(a5)+

		subq.w	#1,d3
		bne.b	.xloop

		add.w	d4,a4
		add.w	d5,a5

		subq.w	#1,d7
		bne.b	.yloop


		movem.l	(a7)+,d2-d7/a2-a6
		rts

;====================================================================



	ENDC

