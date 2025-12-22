
	IFND ALPHA_I
ALPHA_I	SET	1

;====================================================================
;--------------------------------------------------------------------
;
;		InsertAlphaChannel
;
;		insert an alpha channel array to an
;		RGB array
;
;	>	a0	UBYTE *	alphaarray
;		d0	UWORD	width
;		d1	UWORD	height
;		a1	ULONG *	RGBArray
;		a2	Taglist
;
;	Tags	RND_SourceWidth	- total width of alpha array [pixels]
;		RND_DestWidth	- total width of rgb array [pixels]
;
;--------------------------------------------------------------------

	STRUCTURE	isac_local,0
		APTR	isac_rgb
		APTR	isac_mask
		UWORD	isac_width1
		UWORD	isac_width16
		UWORD	isac_height
		ULONG	isac_rgbmodulo
		ULONG	isac_maskmodulo
	LABEL		isac_sizeof

;--------------------------------------------------------------------

InsertAlphaChannel:
		movem.l	d2-d7/a2/a5-a6,-(a7)

		sub.w	#isac_sizeof,a7
		move.l	a7,a5
		
		move.l	a0,(isac_mask,a5)
		move.l	a1,(isac_rgb,a5)
		move.w	d1,(isac_height,a5)

		moveq	#0,d7
		move.w	d0,d7
		moveq	#15,d1
		and.w	d0,d1
		subq.w	#1,d1
		move.w	d1,(isac_width1,a5)
		lsr.w	#4,d0
		move.w	d0,(isac_width16,a5)

		move.l	(utilitybase,pc),a6


		GetTag	#RND_SourceWidth,d7,a2
		sub.l	d7,d0
		move.l	d0,(isac_maskmodulo,a5)

		GetTag	#RND_DestWidth,d7,a2
		sub.l	d7,d0
		lsl.l	#2,d0
		move.l	d0,(isac_rgbmodulo,a5)


		move.l	(isac_rgb,a5),a0
		move.l	(isac_mask,a5),a1

.ylop		move.w	(isac_width16,a5),d0
		beq	.no16	
		move.w	d0,a2

.lop16		move.b	(a1)+,d0
		move.b	(a1)+,d1
		swap	d0
		move.b	(a1)+,d2
		swap	d1
		move.b	(a1)+,d3
		swap	d2
		move.b	(a1)+,d4
		swap	d3
		move.b	(a1)+,d5
		swap	d4
		move.b	(a1)+,d6
		swap	d5
		move.b	(a1)+,d7
		swap	d6
		move.b	(a1)+,d0
		swap	d7
		move.b	(a1)+,d1
		swap	d0
		move.b	(a1)+,d2
		swap	d1
		move.b	(a1)+,d3
		swap	d2
		move.b	(a1)+,d4
		swap	d3
		move.b	(a1)+,d5
		swap	d4
		move.b	(a1)+,d6
		swap	d5
		move.b	(a1)+,d7
		swap	d6
		move.b	d0,(a0)
		addq.w	#4,a0
		swap	d7
		move.b	d1,(a0)
		addq.w	#4,a0
		swap	d0
		move.b	d2,(a0)
		addq.w	#4,a0
		swap	d1
		move.b	d3,(a0)
		addq.w	#4,a0
		swap	d2
		move.b	d4,(a0)
		addq.w	#4,a0
		swap	d3
		move.b	d5,(a0)
		addq.w	#4,a0
		swap	d4
		move.b	d6,(a0)
		addq.w	#4,a0
		swap	d5
		move.b	d7,(a0)
		addq.w	#4,a0
		swap	d6
		move.b	d0,(a0)
		addq.w	#4,a0
		swap	d7
		move.b	d1,(a0)
		addq.w	#4,a0
		move.b	d2,(a0)
		addq.w	#4,a0
		move.b	d3,(a0)
		addq.w	#4,a0
		move.b	d4,(a0)
		addq.w	#4,a0
		move.b	d5,(a0)
		addq.w	#4,a0
		move.b	d6,(a0)
		addq.w	#4,a0
		move.b	d7,(a0)
		subq.w	#1,a2
		addq.w	#4,a0
		move.w	a2,d0
		bne	.lop16

.no16		move.w	(isac_width1,a5),d0
		bmi.b	.no1

.lop1		move.b	(a1)+,(a0)
		addq.w	#4,a0
		dbf	d0,.lop1

.no1		add.l	(isac_rgbmodulo,a5),a0
		add.l	(isac_maskmodulo,a5),a1

		subq.w	#1,(isac_height,a5)
		bne	.ylop

		add.w	#isac_sizeof,a7
		movem.l	(a7)+,d2-d7/a2/a5-a6
		rts

;====================================================================


;====================================================================
;--------------------------------------------------------------------
;
;		ExtractAlphaChannel
;
;		extract an alpha channel array from
;		an RGB array
;
;	>	a0	ULONG *	RGBarray
;		d0	UWORD	width
;		d1	UWORD	height
;		a1	UBYTE *	alphaarray
;		a2	Taglist
;
;	Tags	RND_SourceWidth	- total width of RGB array [pixels]
;		RND_DestWidth	- total widtg of alpha array [pixels]
;
;--------------------------------------------------------------------

ExtractAlphaChannel:
		movem.l	d2-d7/a2/a5-a6,-(a7)

		sub.w	#isac_sizeof,a7
		move.l	a7,a5
		
		move.l	a0,(isac_rgb,a5)
		move.l	a1,(isac_mask,a5)
		move.w	d1,(isac_height,a5)

		moveq	#0,d7
		move.w	d0,d7
		moveq	#15,d1
		and.w	d0,d1
		subq.w	#1,d1
		move.w	d1,(isac_width1,a5)
		lsr.w	#4,d0
		move.w	d0,(isac_width16,a5)

		move.l	(utilitybase,pc),a6


		GetTag	#RND_SourceWidth,d7,a2
		sub.l	d7,d0
		lsl.l	#2,d0
		move.l	d0,(isac_rgbmodulo,a5)

		GetTag	#RND_DestWidth,d7,a2
		sub.l	d7,d0
		move.l	d0,(isac_maskmodulo,a5)


		move.l	(isac_rgb,a5),a0
		move.l	(isac_mask,a5),a1

.ylop		move.w	(isac_width16,a5),d0
		beq	.no16	
		move.w	d0,a2

.lop16
		move.b	(a0),d0
		addq.w	#4,a0
		swap	d0
		move.b	(a0),d1
		addq.w	#4,a0
		swap	d1
		move.b	(a0),d2
		addq.w	#4,a0
		swap	d2
		move.b	(a0),d3
		addq.w	#4,a0
		swap	d3
		move.b	(a0),d4
		addq.w	#4,a0
		swap	d4
		move.b	(a0),d5
		addq.w	#4,a0
		swap	d5
		move.b	(a0),d6
		addq.w	#4,a0
		swap	d6
		move.b	(a0),d7
		addq.w	#4,a0
		swap	d7
		move.b	(a0),d0
		addq.w	#4,a0
		swap	d0
		move.b	(a0),d1
		addq.w	#4,a0
		swap	d1
		move.b	(a0),d2
		addq.w	#4,a0
		swap	d2
		move.b	(a0),d3
		addq.w	#4,a0
		swap	d3
		move.b	(a0),d4
		addq.w	#4,a0
		swap	d4
		move.b	(a0),d5
		addq.w	#4,a0
		swap	d5
		move.b	(a0),d6
		addq.w	#4,a0
		swap	d6
		move.b	(a0),d7
		addq.w	#4,a0
		move.b	d0,(a1)+
		swap	d7
		move.b	d1,(a1)+
		swap	d0
		move.b	d2,(a1)+
		swap	d1
		move.b	d3,(a1)+
		swap	d2
		move.b	d4,(a1)+
		swap	d3
		move.b	d5,(a1)+
		swap	d4
		move.b	d6,(a1)+
		swap	d5
		move.b	d7,(a1)+
		swap	d6
		move.b	d0,(a1)+
		swap	d7
		move.b	d1,(a1)+
		move.b	d2,(a1)+
		move.b	d3,(a1)+
		move.b	d4,(a1)+
		move.b	d5,(a1)+
		move.b	d6,(a1)+
		subq.w	#1,a2
		move.b	d7,(a1)+
		move.w	a2,d0
		bne	.lop16

.no16		move.w	(isac_width1,a5),d0
		bmi.b	.no1

.lop1		move.b	(a0),(a1)+
		addq.w	#4,a0
		dbf	d0,.lop1

.no1		add.l	(isac_rgbmodulo,a5),a0
		add.l	(isac_maskmodulo,a5),a1
		subq.w	#1,(isac_height,a5)
		bne	.ylop

		add.w	#isac_sizeof,a7
		movem.l	(a7)+,d2-d7/a2/a5-a6
		rts

;====================================================================


;====================================================================
;--------------------------------------------------------------------
;
;		ApplyAlphaChannel
;
;		mix a source array via alphachannel to
;		a destination array. put the result to
;		the destination array.
;
;	>	a0	ULONG *	sourcearray
;		d0	UWORD	width
;		d1	UWORD	height
;		a1	ULONG *	destarray
;		a2	Taglist
;
;	Tags	RND_SourceWidth		- Gesamtbreite RGBArray
;		RND_DestWidth		- Gesamtbreite destarray
;		RND_AlphaChannel	- Default: sourcearray
;		RND_AlphaModulo		- Bytes per Pixel, Default: 4
;		RND_AlphaWidth		- [Pixel] default: width
;
;--------------------------------------------------------------------

	STRUCTURE	alpha_localdata,0
		APTR	alpha_source
		APTR	alpha_dest
		UWORD	alpha_width
		UWORD	alpha_height
		ULONG	alpha_sourcemodulo
		ULONG	alpha_destmodulo
		APTR	alpha_alphaarray
		ULONG	alpha_alphaarraymodulo	; (alphawidth-width)*pixelmodulo
		UWORD	alpha_alphapixelmodulo
	LABEL		alpha_SIZEOF

;--------------------------------------------------------------------

ApplyAlphaChannel:

		movem.l	d2-d7/a3-a6,-(a7)

		sub.w	#alpha_SIZEOF,a7
		move.l	a7,a5

		move.l	a0,(alpha_source,a5)
		move.l	a1,(alpha_dest,a5)
		move.w	d0,(alpha_width,a5)
		move.w	d1,(alpha_height,a5)


		moveq	#0,d7
		move.w	d0,d7

		move.l	(utilitybase,pc),a6

		move.l	(alpha_source,a5),a4
		GetTag	#RND_AlphaChannel,a4,a2
		move.l	d0,(alpha_alphaarray,a5)

		GetTag	#RND_AlphaModulo,#4,a2
		move.w	d0,(alpha_alphapixelmodulo,a5)
		move.l	d0,d6

		GetTag	#RND_AlphaWidth,d7,a2
		sub.l	d7,d0
		mulu.l	d6,d0
		move.l	d0,(alpha_alphaarraymodulo,a5)

		GetTag	#RND_SourceWidth,d7,a2
		sub.l	d7,d0
		lsl.l	#2,d0
		move.l	d0,(alpha_sourcemodulo,a5)

		GetTag	#RND_DestWidth,d7,a2
		sub.l	d7,d0
		lsl.l	#2,d0
		move.l	d0,(alpha_destmodulo,a5)


		move.l	(alpha_source,a5),a0
		move.l	(alpha_dest,a5),a1
		move.l	(alpha_alphaarray,a5),a4
		
		move.w	(alpha_height,a5),d6
		subq.w	#1,d6

.yloop		move.w	(alpha_width,a5),a3

		moveq	#0,d2
		moveq	#0,d3
		moveq	#0,d4
		moveq	#0,d7

.xloop		move.l	(a0)+,d0		; AARRGGBB
	
		move.b	d0,d3			; b1
		
		lsr.l	#8,d0
		moveq	#0,d1
		move.b	d0,d2			; g1
	
		lsr.w	#8,d0
		move.l	(a1),d5
		move.b	d0,d1			; r1

		swap	d5	; %ggbb00rr
			moveq	#0,d0
		move.b	d5,d4
			move.b	(a4),d0			; Alpha-Channel
		sub.w	d4,d1
			add.w	(alpha_alphapixelmodulo,a5),a4
		muls.w	d0,d1
			rol.l	#8,d5	; %bb00rrgg
		asr.l	#8,d1
			move.b	d5,d7
		add.w	d4,d1
			sub.w	d7,d2
		lsl.w	#8,d1
			muls.w	d0,d2
		rol.l	#8,d5	; %00rrggbb
			asr.l	#8,d2
		move.b	d5,d4
			add.w	d7,d2
		sub.w	d4,d3
			move.b	d2,d1
		muls.w	d0,d3
			lsl.l	#8,d1
		asr.l	#8,d3
		add.w	d4,d3
			subq.w	#1,a3
		move.b	d3,d1

		move.l	d1,(a1)+

			move.w	a3,d0
			bne.b	.xloop		


		add.l	(alpha_sourcemodulo,a5),a0
		add.l	(alpha_destmodulo,a5),a1
		add.l	(alpha_alphaarraymodulo,a5),a4

		dbf	d6,.yloop
		
		
		add.w	#alpha_SIZEOF,a7
		movem.l	(a7)+,d2-d7/a3-a6
		rts

;====================================================================



;====================================================================
;--------------------------------------------------------------------
;
;		MixRGBArray
;
;		mix two rgb arrays,
;		put the result to the dest array.
;		alpha channel is not considered.
;
;	>	a0	ULONG *	sourcearray
;		d0	UWORD	width
;		d1	UWORD	height
;		d2	UWORD	mixing ratio Source:Dest (0-255)
;		a1	ULONG *	destarray
;		a2	Taglist
;
;	Tags	RND_SourceWidth		- Gesamtbreite sourceArray
;		RND_DestWidth		- Gesamtbreite destArray		
;
;--------------------------------------------------------------------

MixRGBArray:

		movem.l	d2-d7/a3-a6,-(a7)

		sub.w	#alpha_SIZEOF,a7
		move.l	a7,a5

		move.l	a0,(alpha_source,a5)
		move.l	a1,(alpha_dest,a5)
		move.w	d0,(alpha_width,a5)
		move.w	d1,(alpha_height,a5)

		move.w	d2,a4			; a

		moveq	#0,d7
		move.w	d0,d7

		move.l	(utilitybase,pc),a6

		GetTag	#RND_SourceWidth,d7,a2
		sub.l	d7,d0
		lsl.l	#2,d0
		move.l	d0,(alpha_sourcemodulo,a5)

		GetTag	#RND_DestWidth,d7,a2
		sub.l	d7,d0
		lsl.l	#2,d0
		move.l	d0,(alpha_destmodulo,a5)


		move.l	(alpha_source,a5),a0
		move.l	(alpha_dest,a5),a1
		
		move.w	(alpha_height,a5),d6
		subq.w	#1,d6

.yloop		move.w	(alpha_width,a5),a3


	;	r' = a * (r1 - r2) / 256 + r2

		moveq	#0,d2
		moveq	#0,d3
		moveq	#0,d4
		moveq	#0,d7

.xloop		move.l	(a0)+,d0		; AARRGGBB
	
		move.b	d0,d3			; b1
		
		lsr.l	#8,d0
		moveq	#0,d1
		move.b	d0,d2			; g1
	
		lsr.w	#8,d0
		move.l	(a1),d5
		move.b	d0,d1			; r1

		swap	d5	; %ggbb00rr
		move.b	d5,d4
			move.w	a4,d0			; a
		sub.w	d4,d1
		muls.w	d0,d1
			rol.l	#8,d5	; %bb00rrgg
		asr.l	#8,d1
			move.b	d5,d7
		add.w	d4,d1
			sub.w	d7,d2
		lsl.w	#8,d1
			muls.w	d0,d2
		rol.l	#8,d5	; %00rrggbb
			asr.l	#8,d2
		move.b	d5,d4
			add.w	d7,d2
		sub.w	d4,d3
			move.b	d2,d1
		muls.w	d0,d3
			lsl.l	#8,d1
		asr.l	#8,d3
		add.w	d4,d3
			subq.w	#1,a3
		move.b	d3,d1

		move.l	d1,(a1)+

			move.w	a3,d0
			bne.b	.xloop		


		add.l	(alpha_sourcemodulo,a5),a0
		add.l	(alpha_destmodulo,a5),a1

		dbf	d6,.yloop
		
		
		add.w	#alpha_SIZEOF,a7
		movem.l	(a7)+,d2-d7/a3-a6
		rts

;====================================================================


;====================================================================
;--------------------------------------------------------------------
;
;		CreateAlphaArray(rgbarray, width, height, tags);
;
;		create alpha channel by calculating the difference
;		between the rgbarray and a given rgb value.
;
;	>	a0	ULONG *	rgbarray
;		d0	UWORD	width
;		d1	UWORD	height
;		a1	Taglist
;
;	Tags	RND_SourceWidth	 - total width of rgbArray, default: width
;		RND_AlphaChannel - destination, default: rgbarray
;		RND_AlphaWidth	 - total width of alphaarray, default: width
;		RND_AlphaModulo  - Bytes Skip, default: 4
;		RND_MaskRGB	 - difference rgb, default: $000000
;
;--------------------------------------------------------------------

	STRUCTURE	caa_localdata,0
		APTR	caa_source
		UWORD	caa_width
		UWORD	caa_height
		ULONG	caa_sourcemodulo
		APTR	caa_alphaarray
		ULONG	caa_alphaarraymodulo	; (alphawidth-width)*pixelmodulo
		UWORD	caa_alphapixelmodulo
	LABEL		caa_SIZEOF

;--------------------------------------------------------------------

CreateAlphaArray:

		movem.l	d2-d7/a2-a6,-(a7)

		sub.w	#caa_SIZEOF,a7
		move.l	a7,a5

		move.l	a0,(caa_source,a5)
		move.w	d0,(caa_width,a5)
		move.w	d1,(caa_height,a5)

		move.l	a1,a2

		moveq	#0,d7
		move.w	d0,d7


		move.l	(utilitybase,pc),a6

		GetTag	#RND_MaskRGB,#0,a2
		moveq	#0,d5
		move.b	d0,d5			; blau
		lsr.l	#8,d0
		moveq	#0,d4
		move.b	d0,d4			; grün
		lsr.w	#8,d0
		moveq	#0,d3
		move.b	d0,d3			; rot

		GetTag	#RND_SourceWidth,d7,a2
		sub.l	d7,d0
		lsl.l	#2,d0
		move.l	d0,(caa_sourcemodulo,a5)

		move.l	(caa_source,a5),a4
		GetTag	#RND_AlphaChannel,a4,a2
		move.l	d0,(caa_alphaarray,a5)

		GetTag	#RND_AlphaModulo,#4,a2
		move.w	d0,(caa_alphapixelmodulo,a5)
		move.l	d0,d6

		GetTag	#RND_AlphaWidth,d7,a2
		sub.l	d7,d0
		mulu.l	d6,d0
		move.l	d0,(caa_alphaarraymodulo,a5)

		move.l	(caa_source,a5),a0
		move.l	(caa_alphaarray,a5),a1
		
		move.w	(caa_height,a5),d6
		subq.w	#1,d6

.yloop		move.w	(caa_width,a5),a3
		move.l	#$00ff,d7

.xloop		move.l	(a0)+,d0		; AARRGGBB

		moveq	#0,d2
		moveq	#0,d1

		move.b	d0,d2		; B
		lsr.l	#8,d0
		move.b	d0,d1		; G
		lsr.w	#8,d0		; R
		
		and.l	d7,d0

		sub.w	d3,d0
		bpl.b	.okr
		neg.w	d0

.okr		sub.w	d4,d1
		bpl.b	.okg
		neg.w	d1

.okg		sub.w	d5,d2
		bpl.b	.okb
		neg.w	d2
.okb
		add.w	d2,d1
		add.w	d1,d0
		
		divu.w	#3,d0

		move.b	d0,(a1)

		subq.w	#1,a3
		add.w	(caa_alphapixelmodulo,a5),a1

		move.w	a3,d0
		bne.b	.xloop

		add.l	(caa_sourcemodulo,a5),a0
		add.l	(caa_alphaarraymodulo,a5),a1

		dbf	d6,.yloop
		
		
		add.w	#caa_SIZEOF,a7
		movem.l	(a7)+,d2-d7/a2-a6
		rts

;====================================================================


;====================================================================
;--------------------------------------------------------------------
;
;		MixAlpha(source1, source2, width, height, dest, tags);
;
;		generalized mixing routine.
;
;		mix two rgb arrays via zero, one, or two
;		alpha channels to a destination array.
;
;	>	a0	ULONG *	source1
;		a1	ULONG * source2
;		d0	UWORD	width
;		d1	UWORD	height
;		a2	ULONG * dest
;		a3	Taglist
;
;					default
;
;	Tags	RND_SourceWidth		width
;		RND_DestWidth		width
;		RND_SourceWidth2	width
;		
;		RND_AlphaChannel	source1	(NULL: ignore)
;		RND_AlphaWidth		RND_SourceWidth
;		RND_AlphaModulo		4
;
;		RND_AlphaChannel2	source2 (NULL: ignore)
;		RND_AlphaWidth2		RND_SourceWidth2
;		RND_AlphaModulo2	4
;
;--------------------------------------------------------------------

	STRUCTURE	mxa_localdata,0

		APTR	mxa_source1
		APTR	mxa_source2
		APTR	mxa_dest
		UWORD	mxa_width
		UWORD	mxa_height
		ULONG	mxa_sourcemodulo1
		ULONG	mxa_sourcemodulo2
		ULONG	mxa_destmodulo

		APTR	mxa_alphaarray1
		ULONG	mxa_alphaarraymodulo1	; (alphawidth-width)*pixelmodulo
		UWORD	mxa_alphapixelmodulo1

		APTR	mxa_alphaarray2
		ULONG	mxa_alphaarraymodulo2	; (alphawidth-width)*pixelmodulo
		UWORD	mxa_alphapixelmodulo2

	LABEL		mxa_SIZEOF

;--------------------------------------------------------------------

MixAlphaChannel:

		movem.l	d2-d7/a2-a6,-(a7)

		sub.w	#mxa_SIZEOF,a7
		move.l	a7,a5

		move.l	a0,(mxa_source1,a5)
		move.l	a1,(mxa_source2,a5)
		move.l	a2,(mxa_dest,a5)
		move.w	d0,(mxa_width,a5)
		move.w	d1,(mxa_height,a5)

		moveq	#0,d7			; WIDTH
		move.w	d0,d7

		move.l	(utilitybase,pc),a6

		GetTag	#RND_DestWidth,d7,a3		; Default: width
		sub.l	d7,d0
		lsl.l	#2,d0
		move.l	d0,(mxa_destmodulo,a5)

		GetTag	#RND_SourceWidth,d7,a3		; Default: width
		move.l	d0,d5				; RND_SourceWidth
		sub.l	d7,d0
		lsl.l	#2,d0
		move.l	d0,(mxa_sourcemodulo1,a5)

		GetTag	#RND_SourceWidth2,d7,a3		; Default: width
		move.l	d0,d4				; RND_SourceWidth2
		sub.l	d7,d0
		lsl.l	#2,d0
		move.l	d0,(mxa_sourcemodulo2,a5)

		GetTag	#RND_AlphaModulo,#4,a3
		move.w	d0,(mxa_alphapixelmodulo1,a5)
		move.l	d0,d6

		GetTag	#RND_AlphaWidth,d5,a3		; Default: RND_SourceWidth
		sub.l	d5,d0
		mulu.l	d6,d0
		move.l	d0,(mxa_alphaarraymodulo1,a5)

		GetTag	#RND_AlphaModulo2,#4,a3
		move.w	d0,(mxa_alphapixelmodulo2,a5)
		move.l	d0,d6

		GetTag	#RND_AlphaWidth2,d4,a3		; Default: RND_SourceWidth2
		sub.l	d4,d0
		mulu.l	d6,d0
		move.l	d0,(mxa_alphaarraymodulo2,a5)

		move.l	(mxa_source1,a5),a4
		GetTag	#RND_AlphaChannel,a4,a3
		move.l	d0,(mxa_alphaarray1,a5)

		move.l	(mxa_source2,a5),a4
		GetTag	#RND_AlphaChannel2,a4,a3
		move.l	d0,(mxa_alphaarray2,a5)


		move.l	(mxa_source1,a5),a0
		move.l	(mxa_source2,a5),a1
		move.l	(mxa_alphaarray1,a5),a2
		move.l	(mxa_alphaarray2,a5),a3
		move.l	(mxa_dest,a5),a4


		move.w	(mxa_height,a5),d7
		subq.w	#1,d7

.yloop		move.w	(mxa_width,a5),a6

		moveq	#0,d2
		moveq	#0,d3

.xloop		move.l	(a0)+,d0	; source1

			move.b	d0,d3			; b1
			
			lsr.l	#8,d0
			moveq	#0,d1
			move.b	d0,d2			; g1
	
			lsr.w	#8,d0

		move.l	(a1)+,d5	; source2

				moveq	#0,d6

			move.b	d0,d1			; r1

		moveq	#0,d4
				not.b	d6
				move.l	a3,d0
				beq.b	.noalpha2
				moveq	#0,d0
				move.b	(a3),d0		; Alpha-Channel2
				sub.w	d0,d6
				add.w	(mxa_alphapixelmodulo2,a5),a3
				addq.w	#1,d4

.noalpha2			move.l	a2,d0
				beq.b	.noalpha1
				moveq	#0,d0
				move.b	(a2),d0		; Alpha-Channel1
				add.w	(mxa_alphapixelmodulo1,a5),a2
				addq.w	#1,d4

.noalpha1			add.w	d6,d0


			cmp.w	#2,d4
			bne.b	.not2channels

				lsr.w	#1,d0
.not2channels

			swap	d5			; %ggbb00rr
		moveq	#0,d6
			move.b	d5,d4
			sub.w	d4,d1
			muls.w	d0,d1
				rol.l	#8,d5	; %bb00rrgg
			asr.l	#8,d1
				move.b	d5,d6
			add.w	d4,d1
				sub.w	d6,d2
			lsl.w	#8,d1
				muls.w	d0,d2
			rol.l	#8,d5	; %00rrggbb
				asr.l	#8,d2
			move.b	d5,d4
				add.w	d6,d2
			sub.w	d4,d3
				move.b	d2,d1
			muls.w	d0,d3
				lsl.l	#8,d1
			asr.l	#8,d3
			add.w	d4,d3
			move.b	d3,d1

		subq.w	#1,a6

			move.l	d1,(a4)+

		move.w	a6,d0
		bne.b	.xloop


		add.l	(mxa_sourcemodulo1,a5),a0
		add.l	(mxa_sourcemodulo2,a5),a1
		
		move.l	a2,d0
		beq.b	.noa1
		add.l	(mxa_alphaarraymodulo1,a5),a2
.noa1		move.l	a3,d0
		beq.b	.noa2
		add.l	(mxa_alphaarraymodulo2,a5),a3
.noa2
		add.l	(mxa_destmodulo,a5),a4

		dbf	d7,.yloop
		
		
		add.w	#mxa_SIZEOF,a7
		movem.l	(a7)+,d2-d7/a2-a6
		rts

;====================================================================

;====================================================================
;--------------------------------------------------------------------
;
;		TintRGBArray
;
;		tint a source array with a given RGB and
;		store the result in a destination array		
;
;	>	a0	ULONG *	array
;		d0	UWORD	width
;		d1	UWORD	height
;		d2	ULONG	RGB
;		d3	UWORD	mixing ratio Source:Dest (0-255)
;		a1	ULONG *	destarray
;		a2	Taglist
;
;	Tags	RND_SourceWidth		- Gesamtbreite sourceArray
;		RND_DestWidth		- Gesamtbreite destArray		
;
;--------------------------------------------------------------------

TintRGBArray:

		movem.l	d2-d7/a3-a6,-(a7)

		sub.w	#alpha_SIZEOF,a7
		move.l	a7,a5

		move.l	a0,(alpha_source,a5)
		move.l	a1,(alpha_dest,a5)
		move.w	d0,(alpha_width,a5)
		move.w	d1,(alpha_height,a5)

		moveq	#0,d7
		move.w	d0,d7

		move.l	(utilitybase,pc),a6

		GetTag	#RND_SourceWidth,d7,a2
		sub.l	d7,d0
		lsl.l	#2,d0
		move.l	d0,(alpha_sourcemodulo,a5)

		GetTag	#RND_DestWidth,d7,a2
		sub.l	d7,d0
		lsl.l	#2,d0
		move.l	d0,(alpha_destmodulo,a5)

		moveq	#0,d6
		moveq	#0,d5
		moveq	#0,d4

		move.b	d2,d6
		lsr.w	#8,d2
		move.b	d2,d5
		swap	d2
		move.b	d2,d4

		move.l	(alpha_source,a5),a0
		move.l	(alpha_dest,a5),a1
		
		move.w	#255,d7
		sub.w	d3,d7			; mix-ratio
		
		
.yloop		move.w	(alpha_width,a5),a3


	;	r' = a * (r1 - r2) / 256 + r2


.xloop		moveq	#0,d3
		move.l	(a0)+,d0		; AARRGGBB
		moveq	#0,d2
	
		move.b	d0,d3			; b1
		
		lsr.w	#8,d0
		moveq	#0,d1
		move.b	d0,d2			; g1
	
		swap	d0
		move.b	d0,d1			; r1
		
		sub.w	d4,d1
		sub.w	d5,d2
		sub.w	d6,d3
		muls.w	d7,d1
		muls.w	d7,d2
		muls.w	d7,d3
		asr.l	#8,d1
		asr.l	#8,d2
		asr.l	#8,d3
		add.w	d4,d1
		add.w	d5,d2
		add.w	d6,d3

		addq.w	#1,a1

		move.b	d1,(a1)+
		move.b	d2,(a1)+
		move.b	d3,(a1)+

		subq.w	#1,a3
		move.w	a3,d0
		bne.b	.xloop		


		add.l	(alpha_sourcemodulo,a5),a0
		add.l	(alpha_destmodulo,a5),a1

		subq.w	#1,(alpha_height,a5)
		bne.b	.yloop
		
		
		add.w	#alpha_SIZEOF,a7
		movem.l	(a7)+,d2-d7/a3-a6
		rts

;====================================================================


	ENDC
	
