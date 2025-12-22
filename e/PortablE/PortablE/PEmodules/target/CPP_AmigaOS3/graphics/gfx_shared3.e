OPT NATIVE
MODULE 'target/graphics/gfx_shared2', 'target/graphics/gfx_shared4'
MODULE 'target/exec/lists', 'target/exec/ports', 'target/exec/semaphores', 'target/utility/hooks', 'target/exec/types'

NATIVE {Layer_Info} OBJECT layer_info
	{top_layer}	top_layer	:PTR TO layer
	{check_lp}	check_lp	:PTR TO layer		/* !! Private !! */
	{obs}	obs	:PTR TO cliprect
	{FreeClipRects}	freecliprects	:PTR TO cliprect		/* !! Private !! */
		{PrivateReserve1}	privatereserve1	:VALUE	/* !! Private !! */
		{PrivateReserve2}	privatereserve2	:VALUE	/* !! Private !! */
	{Lock}	lock	:ss			/* !! Private !! */
	{gs_Head}	gs_head	:mlh		/* !! Private !! */
		{PrivateReserve3}	privatereserve3	:INT	/* !! Private !! */
		{PrivateReserve4}	privatereserve4	:PTR	/* !! Private !! */
		{Flags}	flags	:UINT
		{fatten_count}	fatten_count	:BYTE		/* !! Private !! */
		{LockLayersCount}	locklayerscount	:BYTE	/* !! Private !! */
		{PrivateReserve5}	privatereserve5	:INT	/* !! Private !! */
		{BlankHook}	blankhook	:PTR		/* !! Private !! */
		{LayerInfo_extra}	layerinfo_extra	:PTR	/* !! Private !! */
ENDOBJECT


NATIVE {Layer} OBJECT layer
    {front}	front	:PTR TO layer
	{back}	back	:PTR TO layer
    {ClipRect}	cliprect	:PTR TO cliprect  /* read by roms to find first cliprect */
    {rp}	rp	:PTR TO rastport
/*    struct  Rectangle	bounds;*/
	{bounds.MinX}	minx	:INT
	{bounds.MinY}	miny	:INT
	{bounds.MaxX}	maxx	:INT
	{bounds.MaxY}	maxy	:INT
    {reserved}	reserved[4]	:ARRAY OF UBYTE
    {priority}	priority	:UINT		    /* system use only */
    {Flags}	flags	:UINT		    /* obscured ?, Virtual BitMap? */
    {SuperBitMap}	superbitmap	:PTR TO bitmap
    {SuperClipRect}	supercliprect	:PTR TO cliprect /* super bitmap cliprects if VBitMap != 0*/
				  /* else damage cliprect list for refresh */
    {Window}	window	:APTR		  /* reserved for user interface use */
    {Scroll_X}	scroll_x	:INT
	{Scroll_Y}	scroll_y	:INT
    {cr}	cr	:PTR TO cliprect
	{cr2}	cr2	:PTR TO cliprect
	{crnew}	crnew	:PTR TO cliprect	/* used by dedice */
    {SuperSaveClipRects}	supersavercliprects	:PTR TO cliprect /* preallocated cr's */
    {_cliprects}	cliprects_	:PTR TO cliprect	/* system use during refresh */
    {LayerInfo}	layerinfo	:PTR TO layer_info	/* points to head of the list */
    {Lock}	lock	:ss
    {BackFill}	backfill	:PTR TO hook
    {reserved1}	reserved1	:ULONG
    {ClipRegion}	clipregion	:PTR TO region
    {saveClipRects}	savecliprects	:PTR TO region	/* used to back out when in trouble*/
    {Width}	width	:INT
	{Height}	height	:INT		/* system use */
    {reserved2}	reserved2less[18]	:ARRAY OF UBYTE		->"width" & "height" are no-longer part of reserved2[], so subtract 4 from any index
    /* this must stay here */
    {DamageList}	damagelist	:PTR TO region    /* list of rectangles to refresh
				       through */
ENDOBJECT

NATIVE {ClipRect} OBJECT cliprect
    {Next}	next	:PTR TO cliprect	    /* roms used to find next ClipRect */
    {prev}	prev	:PTR TO cliprect	    /* Temp use in layers (private) */
    {lobs}	lobs	:PTR TO layer	    /* Private use for layers */
    {BitMap}	bitmap	:PTR TO bitmap	    /* Bitmap for layers private use */
/*    struct  Rectangle	bounds;*/     /* bounds of cliprect */
	{bounds.MinX}	minx	:INT
	{bounds.MinY}	miny	:INT
	{bounds.MaxX}	maxx	:INT
	{bounds.MaxY}	maxy	:INT
    {_p1}	p1_	:PTR		    /* Layers private use!!! */
    {_p2}	p2_	:PTR		    /* Layers private use!!! */
    {reserved}	reserved	:VALUE		    /* system use (Layers private) */
->#ifdef NEWCLIPRECTS_1_1
    {Flags}	flags	:VALUE		    /* Layers private field for cliprects */
				    /* that layers allocates... */
->#endif				    /* MUST be multiple of 8 bytes to buffer */
ENDOBJECT


NATIVE {AreaInfo} OBJECT areainfo
    {VctrTbl}	vctrtbl	:PTR TO INT	     /* ptr to start of vector table */
    {VctrPtr}	vctrptr	:PTR TO INT	     /* ptr to current vertex */
    {FlagTbl}	flagtbl	:PTR TO BYTE	      /* ptr to start of vector flag table */
    {FlagPtr}	flagptr	:PTR TO BYTE	      /* ptrs to areafill flags */
    {Count}	count	:INT	     /* number of vertices in list */
    {MaxCount}	maxcount	:INT	     /* AreaMove/Draw will not allow Count>MaxCount*/
    {FirstX}	firstx	:INT
	{FirstY}	firsty	:INT    /* first point for this polygon */
ENDOBJECT

NATIVE {TmpRas} OBJECT tmpras
    {RasPtr}	rasptr	:PTR TO BYTE
    {Size}	size	:VALUE
ENDOBJECT

NATIVE {GelsInfo} OBJECT gelsinfo
    {sprRsrvd}	sprrsrvd	:BYTE	      /* flag of which sprites to reserve from
				 vsprite system */
    {Flags}	flags	:UBYTE	      /* system use */
    {gelHead}	gelhead	:PTR TO vs
	{gelTail}	geltail	:PTR TO vs /* dummy vSprites for list management*/
    /* pointer to array of 8 WORDS for sprite available lines */
    {nextLine}	nextline	:PTR TO INT
    /* pointer to array of 8 pointers for color-last-assigned to vSprites */
    {lastColor}	lastcolor	:ARRAY OF PTR TO INT
    {collHandler}	collhandler	:PTR TO colltable     /* addresses of collision routines */
    {leftmost}	leftmost	:INT
	{rightmost}	rightmost	:INT
	{topmost}	topmost	:INT
	{bottommost}	bottommost	:INT
    {firstBlissObj}	firstblissobj	:APTR
	{lastBlissObj}	lastblissobj	:APTR    /* system use only */
ENDOBJECT

NATIVE {RastPort} OBJECT rastport
    {Layer}	layer	:PTR TO layer
    {BitMap}	bitmap	:PTR TO bitmap
    {AreaPtrn}	areaptrn	:PTR TO UINT	     /* ptr to areafill pattern */
    {TmpRas}	tmpras	:PTR TO tmpras
    {AreaInfo}	areainfo	:PTR TO areainfo
    {GelsInfo}	gelsinfo	:PTR TO gelsinfo
    {Mask}	mask	:UBYTE	      /* write mask for this raster */
    {FgPen}	fgpen	:BYTE	      /* foreground pen for this raster */
    {BgPen}	bgpen	:BYTE	      /* background pen  */
    {AOlPen}	aolpen	:BYTE	      /* areafill outline pen */
    {DrawMode}	drawmode	:BYTE	      /* drawing mode for fill, lines, and text */
    {AreaPtSz}	areaptsz	:BYTE	      /* 2^n words for areafill pattern */
    {linpatcnt}	linpatcnt	:BYTE	      /* current line drawing pattern preshift */
    {dummy}	dummy	:BYTE
    {Flags}	flags	:UINT	     /* miscellaneous control bits */
    {LinePtrn}	lineptrn	:UINT	     /* 16 bits for textured lines */
    {cp_x}	cp_x	:INT
	{cp_y}	cp_y	:INT	     /* current pen position */
    {minterms}	minterms[8]	:ARRAY OF UBYTE
    {PenWidth}	penwidth	:INT
    {PenHeight}	penheight	:INT
    {Font}	font	:PTR TO textfont   /* current font address */
    {AlgoStyle}	algostyle	:UBYTE	      /* the algorithmically generated style */
    {TxFlags}	txflags	:UBYTE	      /* text specific flags */
    {TxHeight}	txheight	:UINT	      /* text height */
    {TxWidth}	txwidth	:UINT	      /* text nominal width */
    {TxBaseline}	txbaseline	:UINT       /* text baseline */
    {TxSpacing}	txspacing	:INT	      /* text spacing (per character) */
    {RP_User}	rp_user	:PTR TO APTR
    {longreserved}	longreserved[2]	:ARRAY OF ULONG
->#ifndef GFX_RASTPORT_1_2
    {wordreserved}	wordreserved[7]	:ARRAY OF UINT  /* used to be a node */
    {reserved}	reserved[8]	:ARRAY OF UBYTE      /* for future use */
->#endif
ENDOBJECT


NATIVE {TextFont} OBJECT textfont
    {tf_Message}	mn	:mn	/* reply message for font removal */
				/* font name in LN	  \    used in this */
    {tf_YSize}	ysize	:UINT		/* font height		  |    order to best */
    {tf_Style}	style	:UBYTE		/* font style		  |    match a font */
    {tf_Flags}	flags	:UBYTE		/* preferences and flags  /    request. */
    {tf_XSize}	xsize	:UINT		/* nominal font width */
    {tf_Baseline}	baseline	:UINT	/* distance from the top of char to baseline */
    {tf_BoldSmear}	boldsmear	:UINT	/* smear to affect a bold enhancement */

    {tf_Accessors}	accessors	:UINT	/* access count */

    {tf_LoChar}	lochar	:UBYTE		/* the first character described here */
    {tf_HiChar}	hichar	:UBYTE		/* the last character described here */
    {tf_CharData}	chardata	:APTR	/* the bit character data */

    {tf_Modulo}	modulo	:UINT		/* the row modulo for the strike font data */
    {tf_CharLoc}	charloc	:APTR		/* ptr to location data for the strike font */
				/*   2 words: bit offset then size */
    {tf_CharSpace}	charspace	:APTR	/* ptr to words of proportional spacing data */
    {tf_CharKern}	charkern	:APTR	/* ptr to words of kerning data */
ENDOBJECT
