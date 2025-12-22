
	IFND ENGINE_I
ENGINE_I	SET	1


;====================================================================
;--------------------------------------------------------------------
;
;		CreateScaleEngine
;
;		erzeugt eine Scale-Engine
;
;	>	d0	SourceWidth
;		d1	SourceHeight
;		d2	DestWidth
;		d3	DestHeight
;		a1	TagList
;	<	d0	ScaleEngine oder NULL
;
;	Tags	RND_RMHandler
;		RND_PixelFormat
;		RND_DestCoordinates
;
;--------------------------------------------------------------------

CreateScaleEngine
		movem.l	d2-d7/a2-a6,-(a7)
		
		move.l	a1,a3
		move.l	(utilitybase,pc),a6

		move.w	d0,d4
		move.w	d1,d5


		GetTag	#RND_DestCoordinates,#0,a3
		tst.l	d0
		beq	.normal

		;------------------------------------------------------------------

.texture	move.l	d0,a2

		GetTag	#RND_PixelFormat,#PIXFMT_CHUNKY_CLUT,a3
		move.w	d0,d6

		GetTag	#RND_RMHandler,#0,a3
		move.l	d0,a4

		move.l	a4,a0
		move.l	#txt_SIZEOF,d0
		bsr	AllocRenderVecClear
		move.l	d0,a5
		tst.l	d0
		beq.b	.txtfail

		move.l	#ENGINE_TEXTURE,(eng_ID,a5)

		move.w	d6,(eng_pixelformat,a5)
		move.w	d4,(eng_sourcewidth,a5)
		move.w	d5,(eng_sourceheight,a5)
		move.w	d2,(eng_destwidth,a5)
		move.w	d3,(eng_destheight,a5)

		lea	(Init_DrawTexture,pc),a0
		move.l	a0,(eng_initfunc,a5)

		lea	(txt_coordinates,a5),a0
		move.l	(a2)+,(a0)+	; a
		move.l	(a2)+,(a0)+	; b
		move.l	(a2)+,(a0)+	; c
		move.l	(a2)+,(a0)+	; d


		bsr	InitTextureEngine
		tst.l	d0
		beq.b	.txtfail
		
		move.l	a5,d0
		bra	.raus


.txtfail	move.l	a5,d0
		beq	.raus
		
		move.l	d0,a0
		bsr	FreeRenderVec

		moveq	#0,d0

		bra	.raus

		;------------------------------------------------------------------


.normal		lea	(GenerateScale8,pc),a5

		GetTag	#RND_PixelFormat,#PIXFMT_CHUNKY_CLUT,a3
		cmp.w	#PIXFMT_0RGB_32,d0
		bne.b	.ok

		lea	(GenerateScale24,pc),a5
.ok

		GetTag	#RND_RMHandler,#0,a3
		move.l	d0,a0

		move.w	d4,d0
		move.w	d5,d1

		jsr	(a5)
		tst.l	d0
		beq.b	.fail


		move.l	d0,a2			; Engine


		move.l	#ENGINE_SCALING,(eng_ID,a2)


		lea	(Init_Scale,pc),a1

;		cmp.w	#PIXFMT_CHUNKY_CLUT,(eng_pixelformat,a2)
;		beq.b	.noint
;
;		lea	(Init_ScaleI,pc),a1
;.noint
		move.l	a1,(eng_initfunc,a2)

		
		move.l	d0,-(a7)
		move.l	(execbase,pc),a6
		jsr	(_LVOCacheClearU,a6)
		move.l	(a7)+,d0

.fail

.raus		movem.l	(a7)+,d2-d7/a2-a6
		rts

;====================================================================


;====================================================================
;--------------------------------------------------------------------
;
;		DeleteScaleEngine
;
;	>	a0	ScaleEngine
;
;--------------------------------------------------------------------

DeleteScaleEngine:

		move.l	a0,d0
		beq.b	.noengine

		cmp.l	#ENGINE_SCALING,(eng_ID,a0)
		beq.b	.sce
		cmp.l	#ENGINE_TEXTURE,(eng_ID,a0)
		beq.b	.txt
		
		illegal

.sce		bra	FreeRenderVec

.txt		move.l	a5,-(a7)
		move.l	a0,a5

		move.l	(txt_sourcetab,a5),a0
		bsr	FreeRenderVec

		move.l	(txt_desttab,a5),a0
		bsr	FreeRenderVec

		move.l	a5,a0
		bsr	FreeRenderVec

		move.l	(a7)+,a5			; !!
.noengine
		rts


		
;--------------------------------------------------------------------
;====================================================================

	ENDC

