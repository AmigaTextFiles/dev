OPT NATIVE
MODULE 'target/graphics/gfx_shared2', 'target/graphics/gfx_shared4'
MODULE 'target/exec/lists', 'target/exec/ports', 'target/exec/semaphores', 'target/utility/hooks', 'target/exec/types'

NATIVE {layer_info} OBJECT layer_info
	{top_layer}	top_layer	:PTR TO layer
	{check_lp}	check_lp	:PTR TO layer		/* !! Private !! */
	{obs}	obs	:PTR TO cliprect
	{freecliprects}	freecliprects	:PTR TO cliprect		/* !! Private !! */
		{privatereserve1}	privatereserve1	:VALUE	/* !! Private !! */
		{privatereserve2}	privatereserve2	:VALUE	/* !! Private !! */
	{lock}	lock	:ss			/* !! Private !! */
	{gs_head}	gs_head	:mlh		/* !! Private !! */
		{privatereserve3}	privatereserve3	:INT	/* !! Private !! */
		{privatereserve4}	privatereserve4	:PTR	/* !! Private !! */
		{flags}	flags	:UINT
		{fatten_count}	fatten_count	:BYTE		/* !! Private !! */
		{locklayerscount}	locklayerscount	:BYTE	/* !! Private !! */
		{privatereserve5}	privatereserve5	:INT	/* !! Private !! */
		{blankhook}	blankhook	:PTR		/* !! Private !! */
		{layerinfo_extra}	layerinfo_extra	:PTR	/* !! Private !! */
ENDOBJECT


NATIVE {layer} OBJECT layer
    {front}	front	:PTR TO layer
	{back}	back	:PTR TO layer
    {cliprect}	cliprect	:PTR TO cliprect  /* read by roms to find first cliprect */
    {rp}	rp	:PTR TO rastport
/*    struct  Rectangle	bounds;*/
	{minx}	minx	:INT
	{miny}	miny	:INT
	{maxx}	maxx	:INT
	{maxy}	maxy	:INT
    {reserved}	reserved[4]	:ARRAY OF UBYTE
    {priority}	priority	:UINT		    /* system use only */
    {flags}	flags	:UINT		    /* obscured ?, Virtual BitMap? */
    {superbitmap}	superbitmap	:PTR TO bitmap
    {supercliprect}	supercliprect	:PTR TO cliprect /* super bitmap cliprects if VBitMap != 0*/
				  /* else damage cliprect list for refresh */
    {window}	window	:APTR		  /* reserved for user interface use */
    {scroll_x}	scroll_x	:INT
	{scroll_y}	scroll_y	:INT
    {cr}	cr	:PTR TO cliprect
	{cr2}	cr2	:PTR TO cliprect
	{crnew}	crnew	:PTR TO cliprect	/* used by dedice */
    {supersavecliprects}	supersavercliprects	:PTR TO cliprect /* preallocated cr's */
    {cliprects_}	cliprects_	:PTR TO cliprect	/* system use during refresh */
    {layerinfo}	layerinfo	:PTR TO layer_info	/* points to head of the list */
    {lock}	lock	:ss
    {backfill}	backfill	:PTR TO hook
    {reserved1}	reserved1	:ULONG
    {clipregion}	clipregion	:PTR TO region
    {savecliprects}	savecliprects	:PTR TO region	/* used to back out when in trouble*/
    {width}	width	:INT
	{height}	height	:INT		/* system use */
    {reserved2}	reserved2less[18]	:ARRAY OF UBYTE		->"width" & "height" are no-longer part of reserved2[], so subtract 4 from any index
    /* this must stay here */
    {damagelist}	damagelist	:PTR TO region    /* list of rectangles to refresh
				       through */
ENDOBJECT

NATIVE {cliprect} OBJECT cliprect
    {next}	next	:PTR TO cliprect	    /* roms used to find next ClipRect */
    {prev}	prev	:PTR TO cliprect	    /* Temp use in layers (private) */
    {lobs}	lobs	:PTR TO layer	    /* Private use for layers */
    {bitmap}	bitmap	:PTR TO bitmap	    /* Bitmap for layers private use */
/*    struct  Rectangle	bounds;*/     /* bounds of cliprect */
	{minx}	minx	:INT
	{miny}	miny	:INT
	{maxx}	maxx	:INT
	{maxy}	maxy	:INT
    {p1_}	p1_	:PTR		    /* Layers private use!!! */
    {p2_}	p2_	:PTR		    /* Layers private use!!! */
    {reserved}	reserved	:VALUE		    /* system use (Layers private) */
->#ifdef NEWCLIPRECTS_1_1
    {flags}	flags	:VALUE		    /* Layers private field for cliprects */
				    /* that layers allocates... */
->#endif				    /* MUST be multiple of 8 bytes to buffer */
ENDOBJECT


NATIVE {areainfo} OBJECT areainfo
    {vctrtbl}	vctrtbl	:PTR TO INT	     /* ptr to start of vector table */
    {vctrptr}	vctrptr	:PTR TO INT	     /* ptr to current vertex */
    {flagtbl}	flagtbl	:PTR TO BYTE	      /* ptr to start of vector flag table */
    {flagptr}	flagptr	:PTR TO BYTE	      /* ptrs to areafill flags */
    {count}	count	:INT	     /* number of vertices in list */
    {maxcount}	maxcount	:INT	     /* AreaMove/Draw will not allow Count>MaxCount*/
    {firstx}	firstx	:INT
	{firsty}	firsty	:INT    /* first point for this polygon */
ENDOBJECT

NATIVE {tmpras} OBJECT tmpras
    {rasptr}	rasptr	:PTR TO BYTE
    {size}	size	:VALUE
ENDOBJECT

NATIVE {gelsinfo} OBJECT gelsinfo
    {sprrsrvd}	sprrsrvd	:BYTE	      /* flag of which sprites to reserve from
				 vsprite system */
    {flags}	flags	:UBYTE	      /* system use */
    {gelhead}	gelhead	:PTR TO vs
	{geltail}	geltail	:PTR TO vs /* dummy vSprites for list management*/
    /* pointer to array of 8 WORDS for sprite available lines */
    {nextline}	nextline	:PTR TO INT
    /* pointer to array of 8 pointers for color-last-assigned to vSprites */
    {lastcolor}	lastcolor	:ARRAY OF PTR TO INT
    {collhandler}	collhandler	:PTR TO colltable     /* addresses of collision routines */
    {leftmost}	leftmost	:INT
	{rightmost}	rightmost	:INT
	{topmost}	topmost	:INT
	{bottommost}	bottommost	:INT
    {firstblissobj}	firstblissobj	:APTR
	{lastblissobj}	lastblissobj	:APTR    /* system use only */
ENDOBJECT

NATIVE {rastport} OBJECT rastport
    {layer}	layer	:PTR TO layer
    {bitmap}	bitmap	:PTR TO bitmap
    {areaptrn}	areaptrn	:PTR TO UINT	     /* ptr to areafill pattern */
    {tmpras}	tmpras	:PTR TO tmpras
    {areainfo}	areainfo	:PTR TO areainfo
    {gelsinfo}	gelsinfo	:PTR TO gelsinfo
    {mask}	mask	:UBYTE	      /* write mask for this raster */
    {fgpen}	fgpen	:BYTE	      /* foreground pen for this raster */
    {bgpen}	bgpen	:BYTE	      /* background pen  */
    {aolpen}	aolpen	:BYTE	      /* areafill outline pen */
    {drawmode}	drawmode	:BYTE	      /* drawing mode for fill, lines, and text */
    {areaptsz}	areaptsz	:BYTE	      /* 2^n words for areafill pattern */
    {linpatcnt}	linpatcnt	:BYTE	      /* current line drawing pattern preshift */
    {dummy}	dummy	:BYTE
    {flags}	flags	:UINT	     /* miscellaneous control bits */
    {lineptrn}	lineptrn	:UINT	     /* 16 bits for textured lines */
    {cp_x}	cp_x	:INT
	{cp_y}	cp_y	:INT	     /* current pen position */
    {minterms}	minterms[8]	:ARRAY OF UBYTE
    {penwidth}	penwidth	:INT
    {penheight}	penheight	:INT
    {font}	font	:PTR TO textfont   /* current font address */
    {algostyle}	algostyle	:UBYTE	      /* the algorithmically generated style */
    {txflags}	txflags	:UBYTE	      /* text specific flags */
    {txheight}	txheight	:UINT	      /* text height */
    {txwidth}	txwidth	:UINT	      /* text nominal width */
    {txbaseline}	txbaseline	:UINT       /* text baseline */
    {txspacing}	txspacing	:INT	      /* text spacing (per character) */
    {rp_user}	rp_user	:PTR TO APTR
    {longreserved}	longreserved[2]	:ARRAY OF ULONG
->#ifndef GFX_RASTPORT_1_2
    {wordreserved}	wordreserved[7]	:ARRAY OF UINT  /* used to be a node */
    {reserved}	reserved[8]	:ARRAY OF UBYTE      /* for future use */
->#endif
ENDOBJECT


NATIVE {textfont} OBJECT textfont
    {mn}	mn	:mn	/* reply message for font removal */
				/* font name in LN	  \    used in this */
    {ysize}	ysize	:UINT		/* font height		  |    order to best */
    {style}	style	:UBYTE		/* font style		  |    match a font */
    {flags}	flags	:UBYTE		/* preferences and flags  /    request. */
    {xsize}	xsize	:UINT		/* nominal font width */
    {baseline}	baseline	:UINT	/* distance from the top of char to baseline */
    {boldsmear}	boldsmear	:UINT	/* smear to affect a bold enhancement */

    {accessors}	accessors	:UINT	/* access count */

    {lochar}	lochar	:UBYTE		/* the first character described here */
    {hichar}	hichar	:UBYTE		/* the last character described here */
    {chardata}	chardata	:APTR	/* the bit character data */

    {modulo}	modulo	:UINT		/* the row modulo for the strike font data */
    {charloc}	charloc	:APTR		/* ptr to location data for the strike font */
				/*   2 words: bit offset then size */
    {charspace}	charspace	:APTR	/* ptr to words of proportional spacing data */
    {charkern}	charkern	:APTR	/* ptr to words of kerning data */
ENDOBJECT
