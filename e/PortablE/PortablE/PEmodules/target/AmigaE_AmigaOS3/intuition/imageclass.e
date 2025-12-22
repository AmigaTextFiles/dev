/* $VER: imageclass.h 44.1 (19.10.1999) */
OPT NATIVE, PREPROCESS
PUBLIC MODULE 'target/intuition/intuition_shared3'
MODULE 'target/intuition/intuition', 'target/intuition/iobsolete'
MODULE 'target/utility/tagitem', 'target/intuition/screens', 'target/graphics/rastport', 'target/intuition/cghooks', 'target/exec/types'
{MODULE 'intuition/imageclass'}

NATIVE {CUSTOMIMAGEDEPTH}	CONST CUSTOMIMAGEDEPTH	= (-1)
/* if image.Depth is this, it's a new Image class object */

/* some convenient macros and casts */
NATIVE {GADGET_BOX} CONST	->GADGET_BOX( g )	( (struct IBox *) &((struct Gadget *)(g))->LeftEdge )
NATIVE {IM_BOX} CONST	->IM_BOX( im )	( (struct IBox *) &((struct Image *)(im))->LeftEdge )
NATIVE {IM_FGPEN} CONST	->IM_FGPEN( im )	( (im)->PlanePick )
NATIVE {IM_BGPEN} CONST	->IM_BGPEN( im )	( (im)->PlaneOnOff )

#define GADGET_BOX(g) ((g)+GD_LEFTEDGE)
#define IM_BOX(im)    ((im)+IG_LEFTEDGE)
#define IM_FGPEN(im) Im_fgpen(im)
PROC Im_fgpen(im:PTR TO image) IS im.planepick
#define IM_BGPEN(im) Im_bgpen(im)
PROC Im_bgpen(im:PTR TO image) IS im.planeonoff

/******************************************************/
CONST IA_DUMMY		= (TAG_USER + $20000)
NATIVE {IA_LEFT}			CONST IA_LEFT			= (IA_DUMMY + $01)
NATIVE {IA_TOP}			CONST IA_TOP			= (IA_DUMMY + $02)
NATIVE {IA_WIDTH}		CONST IA_WIDTH		= (IA_DUMMY + $03)
NATIVE {IA_HEIGHT}		CONST IA_HEIGHT		= (IA_DUMMY + $04)
NATIVE {IA_FGPEN}		CONST IA_FGPEN		= (IA_DUMMY + $05)
NATIVE {IA_BGPEN}		CONST IA_BGPEN		= (IA_DUMMY + $06)
NATIVE {IA_DATA}			CONST IA_DATA			= (IA_DUMMY + $07)
NATIVE {IA_LINEWIDTH}		CONST IA_LINEWIDTH		= (IA_DUMMY + $08)
NATIVE {IA_PENS}			CONST IA_PENS			= (IA_DUMMY + $0E)
NATIVE {IA_RESOLUTION}		CONST IA_RESOLUTION		= (IA_DUMMY + $0F)

/**** see class documentation to learn which	*****/
/**** classes recognize these			*****/
NATIVE {IA_APATTERN}		CONST IA_APATTERN		= (IA_DUMMY + $10)
NATIVE {IA_APATSIZE}		CONST IA_APATSIZE		= (IA_DUMMY + $11)
NATIVE {IA_MODE}			CONST IA_MODE			= (IA_DUMMY + $12)
NATIVE {IA_FONT}			CONST IA_FONT			= (IA_DUMMY + $13)
NATIVE {IA_OUTLINE}		CONST IA_OUTLINE		= (IA_DUMMY + $14)
NATIVE {IA_RECESSED}		CONST IA_RECESSED		= (IA_DUMMY + $15)
NATIVE {IA_DOUBLEEMBOSS}		CONST IA_DOUBLEEMBOSS		= (IA_DUMMY + $16)
NATIVE {IA_EDGESONLY}		CONST IA_EDGESONLY		= (IA_DUMMY + $17)

/**** "sysiclass" attributes			*****/
NATIVE {SYSIA_SIZE}		CONST SYSIA_SIZE		= (IA_DUMMY + $0B)
NATIVE {SYSIA_DEPTH}		CONST SYSIA_DEPTH		= (IA_DUMMY + $0C)
NATIVE {SYSIA_WHICH}		CONST SYSIA_WHICH		= (IA_DUMMY + $0D)
NATIVE {SYSIA_DRAWINFO}		CONST SYSIA_DRAWINFO		= (IA_DUMMY + $18)

/*****	obsolete: don't use these, use IA_Pens	*****/
NATIVE {SYSIA_PENS}		CONST SYSIA_PENS		= IA_PENS
NATIVE {IA_SHADOWPEN}		CONST IA_SHADOWPEN		= (IA_DUMMY + $09)
NATIVE {IA_HIGHLIGHTPEN}		CONST IA_HIGHLIGHTPEN		= (IA_DUMMY + $0A)

/* New for V39: */
NATIVE {SYSIA_REFERENCEFONT}	CONST SYSIA_REFERENCEFONT	= (IA_DUMMY + $19)
NATIVE {IA_SUPPORTSDISABLE}	CONST IA_SUPPORTSDISABLE	= (IA_DUMMY + $1a)

NATIVE {IA_FRAMETYPE}		CONST IA_FRAMETYPE		= (IA_DUMMY + $1b)

CONST IA_UNDERSCORE		= (IA_DUMMY + $1c)

CONST IA_SCALABLE			= (IA_DUMMY + $1d)

CONST IA_ACTIVATEKEY			= (IA_DUMMY + $1e)

CONST IA_SCREEN			= (IA_DUMMY + $1f)

CONST IA_PRECISION			= (IA_DUMMY + $20)

/** next attribute: (IA_DUMMY + $21)	**/
/*************************************************/

/* data values for SYSIA_Size	*/
NATIVE {SYSISIZE_MEDRES}	CONST SYSISIZE_MEDRES	= (0)
NATIVE {SYSISIZE_LOWRES}	CONST SYSISIZE_LOWRES	= (1)
NATIVE {SYSISIZE_HIRES}	CONST SYSISIZE_HIRES	= (2)

NATIVE {DEPTHIMAGE}	CONST DEPTHIMAGE	= ($00)	/* Window depth gadget image */
NATIVE {ZOOMIMAGE}	CONST ZOOMIMAGE	= ($01)	/* Window zoom gadget image */
NATIVE {SIZEIMAGE}	CONST SIZEIMAGE	= ($02)	/* Window sizing gadget image */
NATIVE {CLOSEIMAGE}	CONST CLOSEIMAGE	= ($03)	/* Window close gadget image */
NATIVE {SDEPTHIMAGE}	CONST SDEPTHIMAGE	= ($05)	/* Screen depth gadget image */
NATIVE {LEFTIMAGE}	CONST LEFTIMAGE	= ($0A)	/* Left-arrow gadget image */
NATIVE {UPIMAGE}		CONST UPIMAGE		= ($0B)	/* Up-arrow gadget image */
NATIVE {RIGHTIMAGE}	CONST RIGHTIMAGE	= ($0C)	/* Right-arrow gadget image */
NATIVE {DOWNIMAGE}	CONST DOWNIMAGE	= ($0D)	/* Down-arrow gadget image */
NATIVE {CHECKIMAGE}	CONST CHECKIMAGE	= ($0E)	/* GadTools checkbox image */
NATIVE {MXIMAGE}		CONST MXIMAGE		= ($0F)	/* GadTools mutual exclude "button" image */
/* New for V39: */
NATIVE {MENUCHECK}	CONST MENUCHECK	= ($10)	/* Menu checkmark image */
NATIVE {AMIGAKEY}	CONST AMIGAKEY	= ($11)	/* Menu Amiga-key image */

NATIVE {FRAME_DEFAULT}		CONST FRAME_DEFAULT		= 0
NATIVE {FRAME_BUTTON}		CONST FRAME_BUTTON		= 1
NATIVE {FRAME_RIDGE}		CONST FRAME_RIDGE		= 2
NATIVE {FRAME_ICONDROPBOX}	CONST FRAME_ICONDROPBOX	= 3


/* image message id's	*/
NATIVE {IM_DRAW}	CONST IM_DRAW	= $202	/* draw yourself, with "state" */
NATIVE {IM_HITTEST}	CONST IM_HITTEST	= $203	/* return TRUE if click hits image	*/
NATIVE {IM_ERASE}	CONST IM_ERASE	= $204	/* erase yourself */
NATIVE {IM_MOVE}	CONST IM_MOVE	= $205	/* draw new and erase old, smoothly	*/

NATIVE {IM_DRAWFRAME}	CONST IM_DRAWFRAME	= $206	/* draw with specified dimensions */
NATIVE {IM_FRAMEBOX}	CONST IM_FRAMEBOX	= $207	/* get recommended frame around some box*/
NATIVE {IM_HITFRAME}	CONST IM_HITFRAME	= $208	/* hittest with dimensions */
NATIVE {IM_ERASEFRAME} CONST IM_ERASEFRAME = $209	/* erase with dimensions */
CONST IM_DOMAINFRAME	= $20A  /* query image for its domain info (V44) */


/* image draw states or styles, for IM_DRAW */
NATIVE {IDS_NORMAL}		CONST IDS_NORMAL		= (0)
NATIVE {IDS_SELECTED}		CONST IDS_SELECTED		= (1)	/* for selected gadgets	    */
NATIVE {IDS_DISABLED}		CONST IDS_DISABLED		= (2)	/* for disabled gadgets	    */
NATIVE {IDS_BUSY}		CONST IDS_BUSY		= (3)	/* for future functionality */
NATIVE {IDS_INDETERMINATE}	CONST IDS_INDETERMINATE	= (4)	/* for future functionality */
NATIVE {IDS_INACTIVENORMAL}	CONST IDS_INACTIVENORMAL	= (5)	/* normal, in inactive window border */
NATIVE {IDS_INACTIVESELECTED}	CONST IDS_INACTIVESELECTED	= (6)	/* selected, in inactive border */
NATIVE {IDS_INACTIVEDISABLED}	CONST IDS_INACTIVEDISABLED	= (7)	/* disabled, in inactive border */
CONST IDS_SELECTEDDISABLED = (8)	/* disabled and selected    */

/* oops, please forgive spelling error by jimm */
NATIVE {IDS_INDETERMINANT} CONST IDS_INDETERMINANT = IDS_INDETERMINATE

/* IM_FRAMEBOX	*/
NATIVE {impframebox} OBJECT impframebox
    {methodid}	methodid	:ULONG
    {contentsbox}	contentsbox	:PTR TO ibox	/* input: relative box of contents */
    {framebox}	framebox	:PTR TO ibox		/* output: rel. box of encl frame  */
    {drinfo}	drinfo	:PTR TO drawinfo	/* NB: May be NULL */
    {frameflags}	frameflags	:ULONG
ENDOBJECT

->"CONST FRAMEF_SPECIFY" is on-purposely missing from here (it can be found in 'intuition/intuition_shared3')

/* IM_DRAW, IM_DRAWFRAME	*/
NATIVE {impdraw} OBJECT impdraw
    {methodid}	methodid	:ULONG
    {rport}	rport	:PTR TO rastport
	{offsetx}	offsetx	:INT
	{offsety}	offsety	:INT

    {state}	state	:ULONG
    {drinfo}	drinfo	:PTR TO drawinfo	/* NB: May be NULL */

    /* these parameters only valid for IM_DRAWFRAME */
	{dimensionswidth}	dimensionswidth	:INT
	{dimensionsheight}	dimensionsheight	:INT
ENDOBJECT

/* IM_ERASE, IM_ERASEFRAME	*/
NATIVE {imperase} OBJECT imperase
    {methodid}	methodid	:ULONG
    {rport}	rport	:PTR TO rastport
	{offsetx}	offsetx	:INT
	{offsety}	offsety	:INT

    /* these parameters only valid for IM_ERASEFRAME */
	{dimensionswidth}	dimensionswidth	:INT
	{dimensionsheight}	dimensionsheight	:INT
ENDOBJECT

/* IM_HITTEST, IM_HITFRAME	*/
NATIVE {imphittest} OBJECT imphittest
    {methodid}	methodid	:ULONG
	{pointx}	pointx	:INT
	{pointy}	pointy	:INT

    /* these parameters only valid for IM_HITFRAME */
	{dimensionswidth}	dimensionswidth	:INT
	{dimensionsheight}	dimensionsheight	:INT
ENDOBJECT


/* IM_DOMAINFRAME */
/*NATIVE {impdomainframe} OBJECT impdomainframe
    {methodid}	methodid	:ULONG
    {drinfo}	drinfo	:PTR TO drawinfo	/* DrawInfo */
    {rport}	rport	:PTR TO rastport	/* RastPort to layout for */
    {which}	which	:VALUE	/* what size - min/nominal/max */
    {domain}	domain	:ibox	/* Resulting domain */
    {attrs}	attrs	:ARRAY OF tagitem	/* Additional attributes */
ENDOBJECT*/

/* Accepted vales for imp_Which.
 */
CONST IDOMAIN_MINIMUM		= (0)
CONST IDOMAIN_NOMINAL		= (1)
CONST IDOMAIN_MAXIMUM		= (2)


NATIVE {impdrawframe} OBJECT impdrawframe OF impdraw
ENDOBJECT
NATIVE {imperaseframe} OBJECT imperaseframe OF imperase
ENDOBJECT
NATIVE {imphitframe} OBJECT imphitframe OF imphittest
ENDOBJECT
