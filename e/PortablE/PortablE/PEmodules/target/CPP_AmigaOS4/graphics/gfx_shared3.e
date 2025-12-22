OPT NATIVE
MODULE 'target/graphics/gfx_shared2', 'target/graphics/gfx_shared4'
MODULE 'target/exec/lists', 'target/exec/ports', 'target/exec/semaphores', 'target/utility/hooks', 'target/exec/types'

NATIVE {Layer_Info} OBJECT layer_info
{top_layer}	top_layer	:PTR TO layer      /* Frontmost layer */
        {resPtr1}	resPtr1	:PTR        /* V45 spare */
        {resPtr2}	resPtr2	:PTR        /* Another V45 spare */
{FreeClipRects}	freecliprects	:PTR TO cliprect  /* Implements a backing store
                                          * of cliprects to avoid
                                          * frequent re-allocation
                                          * of cliprects. Private.
                                          */
{bounds}	bounds	:rectangle          /* clipping bounds of
                                          * this layer info. All layers
                                          * are clipped against this
                                          */
		->Object member "privatereserve2" has been removed by OS4
{Lock}	lock	:ss            /* Layer_Info lock */
{gs_Head}	gs_head	:mlh         /* linked list of all semaphores
                                          * of all layers within this layer
                                          * info
                                          */
        {PrivateReserve3}	privatereserve3	:INT /* !! Private !! */
        {ClipRectPool}	cliprectpool	:APTR    /* V45: Pool for cliprects
                                          * (private use only)
                                          */
        {Flags}	flags	:UINT
        {res_count}	res_count	:BYTE       /* V45 spare, no longer used */
        {LockLayersCount}	locklayerscount	:BYTE /* Counts # times LockLayers
                                          * has been called
                                          */
        {PrivateReserve5}	privatereserve5	:INT /* !! Private !! */
  {BlankHook}	blankhook	:NATIVE {CONST struct Hook*} PTR TO hook       /* LayerInfo backfill hook */
        {resPtr5}	resptr5	:PTR         /* !! Private !! */
ENDOBJECT


NATIVE {Layer} OBJECT layer
    {front}	front	:PTR TO layer
	{back}	back	:PTR TO layer
    {ClipRect}	cliprect	:PTR TO cliprect      /* singly linked list of active cliprects */
    {rp}	rp	:PTR TO rastport            /* rastport to draw into. Its layer is me */
/*    struct  Rectangle	bounds;*/         /* screen bounds of this layer */
	{bounds.MinX}	minx	:INT
	{bounds.MinY}	miny	:INT
	{bounds.MaxX}	maxx	:INT
	{bounds.MaxY}	maxy	:INT
    {nlink}	nlink	:PTR TO layer         /* new in V45:
                                         * next back layer for display
                                         * reorganization
                                         */
    {priority}	priority	:UINT                   /* internal use: on layer front/back move,
                                         * relative priority of the layers.
                                         * Topmost layer has lowest priority.
                                         */
    {Flags}	flags	:UINT                      /* see <graphics/layers.h> */
    {SuperBitMap}	superbitmap	:PTR TO bitmap   /* if non-NULL, superbitmap layer */
    {SuperClipRect}	supercliprect	:PTR TO cliprect /* super bitmap cliprects if VBitMap != 0*/
                                        /* else damage cliprect list for refresh */
    {Window}	window	:APTR                     /* Intuition keeps its window here */
    {Scroll_X}	scroll_x	:INT
	{Scroll_Y}	scroll_y	:INT          /* layer displacement */
    {cr}	cr	:PTR TO cliprect
	{cr2}	cr2	:PTR TO cliprect
	{cr3}	cr3	:PTR TO cliprect     /* used by moveinfrontof
                                         * cr,cr2 are the new on- and off-
                                         * screen cliprects to combine.
                                         * cr3 keeps the new templates that
                                         * are not clipped by user/damage list
                                         */
    {SuperSaveClipRects}	supersavercliprects	:PTR TO cliprect /* five preallocated super cr's */
    {_cliprects}	cliprects_	:PTR TO cliprect       /* templates that are not clipped
                                         * by damage list or user clip rect
                                         */
    {LayerInfo}	layerinfo	:PTR TO layer_info     /* points to head of the list */
    {Lock}	lock	:ss       /* access to this layer */
    {BackFill}	backfill	:NATIVE {CONST struct Hook*} PTR TO hook      /* backfill hook */
    {ShapeRegion}	shaperegion	:NATIVE {CONST struct Region*} PTR TO region /* the region that compromises the shape
                                         * of this layer */
    {ClipRegion}	clipregion	:NATIVE {CONST struct Region*} PTR TO region   /* user InstallClipRegion()'d region */
    {clipped}	clipped	:PTR TO cliprect          /* clipped away by damage list or
                                         * user clip rect
                                         */
    {Width}	width	:INT
	{Height}	height	:INT               /* system use */
    {ShapeHook}	shapehook	:PTR TO hook             /* hook used to generate the shaperegion */
    {reserved2}	reserved2[14]	:ARRAY OF UBYTE              /* more reserved fields */		->"width" & "height" are no-longer part of reserved2[], so subtract 4 from any index
    {DamageList}	damagelist	:PTR TO region        /* list of rectangles to refresh */
ENDOBJECT

NATIVE {ClipRect} OBJECT cliprect
    {Next}	next	:PTR TO cliprect           /* roms used to find next ClipRect */
    {reservedlink}	reservedlink	:PTR TO cliprect   /* Currently unused */
    {lobs}	lobs	:PTR TO layer           /* If non-NULL, this is a backing store
                                         * cliprect that is currently obscured.
                                         * NEW: In V45, this is no longer a
                                         * valid pointer since a cliprect
                                         * can be obscured by more than one
                                         * layer. Just test for NULL or non-
                                         * NULL, do *NOT* dereference.
                                         */
    {BitMap}	bitmap	:PTR TO bitmap         /* backing store bitmap if lobs != NULL */
/*    struct  Rectangle   bounds;*/         /* bounds of this cliprect */
    {bounds.MinX}	minx	:INT
    {bounds.MinY}	miny	:INT
    {bounds.MaxX}	maxx	:INT
    {bounds.MaxY}	maxy	:INT
    {vlink}	vlink	:PTR TO cliprect          /* Layers private use!!! */
    {home}	home	:PTR TO layer_info           /* where this cliprect belongs to.
                                         * If you *MUST* hack in your private
                                         * cliprects, ensure that you set this
                                         * field to NULL. If you don't, layers
                                         * will pool your cliprect and will
                                         * release it when it "feels like".
                                         * For NULL, V40 behaivour is
                                         * re-established.
                                         */
    {Flags}	flags	:VALUE          /* Layers private field for cliprects */
/*
 * For below V45, the flags field used to be below
 * this point and cliprects used to be four bytes
 * larger internally. This is no longer the case
 * now for V45.
 */
ENDOBJECT


NATIVE {AreaInfo} OBJECT areainfo
    {VctrTbl}	vctrtbl	:PTR TO INT        /* ptr to start of vector table */
    {VctrPtr}	vctrptr	:PTR TO INT        /* ptr to current vertex */
    {FlagTbl}	flagtbl	:PTR TO BYTE        /* ptr to start of vector flag table */
    {FlagPtr}	flagptr	:PTR TO BYTE        /* ptrs to areafill flags */
    {Count}	count	:INT          /* number of vertices in list */
    {MaxCount}	maxcount	:INT       /* AreaMove/Draw will not allow Count>MaxCount*/
    {FirstX}	firstx	:INT
	{FirstY}	firsty	:INT /* first point for this polygon */
ENDOBJECT

NATIVE {TmpRas} OBJECT tmpras
    {RasPtr}	rasptr	:PLANEPTR
    {Size}	size	:VALUE
ENDOBJECT

NATIVE {GelsInfo} OBJECT gelsinfo
    {sprRsrvd}	sprrsrvd	:BYTE       /* flag of which sprites to reserve from
                            vsprite system */
    {Flags}	flags	:UBYTE         /* system use */
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
	{lastBlissObj}	lastblissobj	:APTR   /* system use only */
ENDOBJECT

NATIVE {RastPort} OBJECT rastport
    {Layer}	layer	:PTR TO layer
    {BitMap}	bitmap	:PTR TO bitmap
    {AreaPtrn}	areaptrn	:PTR TO UINT         /* ptr to areafill pattern */
    {TmpRas}	tmpras	:PTR TO tmpras
    {AreaInfo}	areainfo	:PTR TO areainfo
    {GelsInfo}	gelsinfo	:PTR TO gelsinfo
    {Mask}	mask	:UBYTE              /* write mask for this raster */
    {FgPen}	fgpen	:BYTE             /* foreground pen for this raster */
    {BgPen}	bgpen	:BYTE             /* background pen  */
    {AOlPen}	aolpen	:BYTE            /* areafill outline pen */
    {DrawMode}	drawmode	:BYTE          /* drawing mode for fill, lines, and text */
    {AreaPtSz}	areaptsz	:BYTE          /* 2^n words for areafill pattern */
    {linpatcnt}	linpatcnt	:BYTE         /* current line drawing pattern preshift */
    {dummy}	dummy	:BYTE
    {Flags}	flags	:UINT             /* miscellaneous control bits */
    {LinePtrn}	lineptrn	:UINT          /* 16 bits for textured lines */
    {cp_x}	cp_x	:INT
	{cp_y}	cp_y	:INT        /* current pen position */
    {minterms}	minterms[8]	:ARRAY OF UBYTE
    {PenWidth}	penwidth	:INT
    {PenHeight}	penheight	:INT
    {Font}	font	:PTR TO textfont    /* current font address */
    {AlgoStyle}	algostyle	:UBYTE         /* the algorithmically generated style */
    {TxFlags}	txflags	:UBYTE           /* text specific flags */
    {TxHeight}	txheight	:UINT          /* text height */
    {TxWidth}	txwidth	:UINT           /* text nominal width */
    {TxBaseline}	txbaseline	:UINT        /* text baseline */
    {TxSpacing}	txspacing	:INT         /* text spacing (per character) */
    {RP_User}	rp_user	:PTR TO APTR
    {LongFlags}	longreserved	:ULONG         /* V51: private */
    {Extension}	extension	:APTR         /* V51: private rastport extension pointer - reserved */
/* #ifndef GFX_RASTPORT_1_2 */ /* Obsolete */
    {RenderDomain}	renderdomain	:rectangle /* V51: private */
    {FGColor}	fgcolor	:ULONG           /* V51: foreground color, don't peek or poke directly! */
    {BGColor}	bgcolor	:ULONG           /* V51: background color, don't peek or poke directly! */
    {OColor}	ocolor	:ULONG            /* V51: outline color, don't peek or poke directly!    */
    {wordreserved}	wordreserved	:UINT      /* for future use */
/* #endif */
ENDOBJECT


NATIVE {TextFont} OBJECT textfont
    {tf_Message}	mn	:mn   /* font name in LN       \    used in this  */
                                 /* charset in taglist    |    order to best */
    {tf_YSize}	ysize	:UINT     /* font height           |    match a font  */
    {tf_Style}	style	:UBYTE     /* font style            |    request.      */
    {tf_Flags}	flags	:UBYTE     /* preferences and flags /                  */
    {tf_XSize}	xsize	:UINT     /* nominal font width */
    {tf_Baseline}	baseline	:UINT  /* distance from the top of char to baseline*/
    {tf_BoldSmear}	boldsmear	:UINT /* smear to affect a bold enhancement */

    {tf_Accessors}	accessors	:UINT /* access count */

    {tf_LoChar}	lochar	:UBYTE    /* the first character described here */
    {tf_HiChar}	hichar	:UBYTE    /* the last character described here */
    {tf_CharData}	chardata	:APTR  /* the bit character data */

    {tf_Modulo}	modulo	:UINT    /* the row modulo for the strike font data */
    {tf_CharLoc}	charloc	:APTR   /* ptr to location data for the strike font */
                                 /*   2 words: bit offset then size */
    {tf_CharSpace}	charspace	:APTR /* ptr to words of proportional spacing data */
    {tf_CharKern}	charkern	:APTR  /* ptr to words of kerning data */
ENDOBJECT


NATIVE {PixieRenderMsg} OBJECT pixierendermsg
    {RastPort}	rastport	:PTR TO rastport /* where to render to        */
    {Bounds}	bounds	:rectangle   /* limits of where to render */
    {OffsetX}	offsetx	:INT  /* horizontal offset         */
    {OffsetY}	offsety	:INT  /* vertical offset           */

    {Image}	image	:APTR    /* PIXIE_Image/PIXIE_BitMap  */
    {Mask}	mask	:PLANEPTR     /* PIXIE_Mask                */
ENDOBJECT
