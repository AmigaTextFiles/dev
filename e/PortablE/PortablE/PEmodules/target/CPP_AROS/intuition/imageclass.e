/* $Id: imageclass.h 25583 2007-03-26 23:38:53Z dariusb $ */
OPT NATIVE, PREPROCESS
MODULE 'target/utility/tagitem'
MODULE 'target/intuition/intuition', 'target/graphics/rastport', 'target/exec/types'
{#include <intuition/imageclass.h>}
NATIVE {INTUITION_IMAGECLASS_H} CONST

/* Image.depth for IMAGECLASS objects */
NATIVE {CUSTOMIMAGEDEPTH}	CONST CUSTOMIMAGEDEPTH	= (-1)

/* Macros */
NATIVE {GADGET_BOX} CONST	->GADGET_BOX( g ) ( (struct IBox *) &((struct Gadget *)(g))->LeftEdge )
NATIVE {IM_BOX} CONST	->IM_BOX( im )    ( (struct IBox *) &((struct Image *)(im))->LeftEdge )
NATIVE {IM_FGPEN} CONST	->IM_FGPEN( im )  ( (im)->PlanePick )
NATIVE {IM_BGPEN} CONST	->IM_BGPEN( im )  ( (im)->PlaneOnOff )

#define GADGET_BOX(g) ((g)+GD_LEFTEDGE)
#define IM_BOX(im)    ((im)+IG_LEFTEDGE)
#define IM_FGPEN(im) Im_fgpen(im)
PROC Im_fgpen(im:PTR TO image) IS im.planepick
#define IM_BGPEN(im) Im_bgpen(im)
PROC Im_bgpen(im:PTR TO image) IS im.planeonoff

/* Pack two UWORDs into one ULONG */
NATIVE {IAM_Resolution} CONST	->IAM_Resolution(x,y)     ((ULONG)(((UWORD)(x))<<16 | ((UWORD)(y))))

/* Attributes for IMAGECLASS */
NATIVE {IA_Dummy}		CONST IA_DUMMY		= (TAG_USER + $20000)
NATIVE {IA_Left} 		CONST IA_LEFT 		= (IA_DUMMY + $01)
NATIVE {IA_Top}			CONST IA_TOP			= (IA_DUMMY + $02)
NATIVE {IA_Width}		CONST IA_WIDTH		= (IA_DUMMY + $03)
NATIVE {IA_Height}		CONST IA_HEIGHT		= (IA_DUMMY + $04)
NATIVE {IA_FGPen}		CONST IA_FGPEN		= (IA_DUMMY + $05) /* Alias: PlanePick */
NATIVE {IA_BGPen}		CONST IA_BGPEN		= (IA_DUMMY + $06) /* Alias: PlaneOnOff */
NATIVE {IA_Data} 		CONST IA_DATA 		= (IA_DUMMY + $07) /* Image data or similar */
NATIVE {IA_LineWidth}		CONST IA_LINEWIDTH		= (IA_DUMMY + $08)
NATIVE {IA_Pens} 		CONST IA_PENS 		= (IA_DUMMY + $0E) /* UWORD pens[] with ~0 as
						     the last element */
NATIVE {IA_Resolution}		CONST IA_RESOLUTION		= (IA_DUMMY + $0F) /* Packed UWORDs with x/y
						     resolution ala
						     DrawInfo.Resolution */


/* Not all classes support these */
NATIVE {IA_APattern}		CONST IA_APATTERN		= (IA_DUMMY + $10)
NATIVE {IA_APatSize}		CONST IA_APATSIZE		= (IA_DUMMY + $11)
NATIVE {IA_Mode} 		CONST IA_MODE 		= (IA_DUMMY + $12)
NATIVE {IA_Font} 		CONST IA_FONT 		= (IA_DUMMY + $13)
NATIVE {IA_Outline}		CONST IA_OUTLINE		= (IA_DUMMY + $14)
NATIVE {IA_Recessed}		CONST IA_RECESSED		= (IA_DUMMY + $15)
NATIVE {IA_DoubleEmboss} 	CONST IA_DOUBLEEMBOSS 	= (IA_DUMMY + $16)
/* to specify that the interior of a frame should not be cleared */
NATIVE {IA_EdgesOnly}		CONST IA_EDGESONLY		= (IA_DUMMY + $17)

/* SYSICLASS attributes */
NATIVE {SYSIA_Size}		CONST SYSIA_SIZE		= (IA_DUMMY + $0B) /* See #define's below */
NATIVE {SYSIA_Depth}		CONST SYSIA_DEPTH		= (IA_DUMMY + $0C)
NATIVE {SYSIA_Which}		CONST SYSIA_WHICH		= (IA_DUMMY + $0D) /* See #define's below */
NATIVE {SYSIA_DrawInfo}		CONST SYSIA_DRAWINFO		= (IA_DUMMY + $18) /* Must be specified */

NATIVE {SYSIA_ReferenceFont}	CONST SYSIA_REFERENCEFONT	= (IA_DUMMY + $19)
NATIVE {IA_SupportsDisable}	CONST IA_SUPPORTSDISABLE	= (IA_DUMMY + $1a) /* Tell intuition to
						     use IDS_*DISABLED instead
						     of own code */
NATIVE {IA_FrameType}		CONST IA_FRAMETYPE		= (IA_DUMMY + $1b) /* See FRAME_* */

/* Private AROS sysiclass tags and defines*/

NATIVE {SYSIA_WithBorder}  CONST ->SYSIA_WITHBORDER  = IA_FGPen	/* default: TRUE */
NATIVE {SYSIA_Style}       CONST ->SYSIA_STYLE       = IA_BGPen	/* default: SYSISTYLE_NORMAL */

NATIVE {SYSISTYLE_NORMAL}   CONST SYSISTYLE_NORMAL   = 0
NATIVE {SYSISTYLE_GADTOOLS} CONST SYSISTYLE_GADTOOLS = 1		/* to get arrow images in gadtools look */

/* next attribute: (IA_Dummy + $1c) */

/* Values for SYSIA_Size */
NATIVE {SYSISIZE_MEDRES} CONST SYSISIZE_MEDRES = (0)
NATIVE {SYSISIZE_LOWRES} CONST SYSISIZE_LOWRES = (1)
NATIVE {SYSISIZE_HIRES}	CONST SYSISIZE_HIRES	= (2)

/* Values for SYSIA_Which */
NATIVE {DEPTHIMAGE}	CONST DEPTHIMAGE	= ($00) /* Window depth gadget image */
NATIVE {ZOOMIMAGE}	CONST ZOOMIMAGE	= ($01) /* Window zoom gadget image */
NATIVE {SIZEIMAGE}	CONST SIZEIMAGE	= ($02) /* Window sizing gadget image */
NATIVE {CLOSEIMAGE}	CONST CLOSEIMAGE	= ($03) /* Window close gadget image */
NATIVE {SDEPTHIMAGE}	CONST SDEPTHIMAGE	= ($05) /* Screen depth gadget image */
NATIVE {LEFTIMAGE}	CONST LEFTIMAGE	= ($0A) /* Left-arrow gadget image */
NATIVE {UPIMAGE} 	CONST UPIMAGE 	= ($0B) /* Up-arrow gadget image */
NATIVE {RIGHTIMAGE}	CONST RIGHTIMAGE	= ($0C) /* Right-arrow gadget image */
NATIVE {DOWNIMAGE}	CONST DOWNIMAGE	= ($0D) /* Down-arrow gadget image */
NATIVE {CHECKIMAGE}	CONST CHECKIMAGE	= ($0E) /* GadTools checkbox image */
NATIVE {MXIMAGE} 	CONST MXIMAGE 	= ($0F) /* GadTools mutual exclude "button" image */
NATIVE {MENUCHECK}	CONST MENUCHECK	= ($10) /* Menu checkmark image */
NATIVE {AMIGAKEY}	CONST AMIGAKEY	= ($11) /* Menu Amiga-key image */

/* Values for IA_FrameType (FrameIClass)

    FRAME_DEFAULT: The standard V37-type frame, which has thin edges.
    FRAME_BUTTON:  Standard button gadget frames, having thicker
	sides and nicely edged corners.
    FRAME_RIDGE:  A ridge such as used by standard string gadgets.
	You can recess the ridge to get a groove image.
    FRAME_ICONDROPBOX: A broad ridge which is the standard imagery
	for areas in AppWindows where icons may be dropped.
*/
NATIVE {FRAME_DEFAULT}		CONST FRAME_DEFAULT		= 0
NATIVE {FRAME_BUTTON}		CONST FRAME_BUTTON		= 1
NATIVE {FRAME_RIDGE}		CONST FRAME_RIDGE		= 2
NATIVE {FRAME_ICONDROPBOX}	CONST FRAME_ICONDROPBOX	= 3


/* image message id's   */
NATIVE {IM_DRAW}       CONST IM_DRAW       = $202  /* draw yourself, with "state" */
NATIVE {IM_HITTEST}    CONST IM_HITTEST    = $203  /* return TRUE if click hits image */
NATIVE {IM_ERASE}      CONST IM_ERASE      = $204  /* erase yourself */
NATIVE {IM_MOVE}       CONST IM_MOVE       = $205  /* draw new and erase old, smoothly */
NATIVE {IM_DRAWFRAME}  CONST IM_DRAWFRAME  = $206  /* draw with specified dimensions */
NATIVE {IM_FRAMEBOX}   CONST IM_FRAMEBOX   = $207  /* get recommended frame around some box */
NATIVE {IM_HITFRAME}   CONST IM_HITFRAME   = $208  /* hittest with dimensions */
NATIVE {IM_ERASEFRAME} CONST IM_ERASEFRAME = $209  /* hittest with dimensions */

/* image draw states or styles, for IM_DRAW */
NATIVE {IDS_NORMAL}	     CONST IDS_NORMAL	     = (0)
NATIVE {IDS_SELECTED}	     CONST IDS_SELECTED	     = (1)   /* for selected gadgets */
NATIVE {IDS_DISABLED}	     CONST IDS_DISABLED	     = (2)   /* for disabled gadgets */
NATIVE {IDS_BUSY}	     CONST IDS_BUSY	     = (3)   /* for future functionality */
NATIVE {IDS_INDETERMINATE}    CONST IDS_INDETERMINATE    = (4)   /* for future functionality */
NATIVE {IDS_INACTIVENORMAL}   CONST IDS_INACTIVENORMAL   = (5)   /* normal, in inactive window border */
NATIVE {IDS_INACTIVESELECTED} CONST IDS_INACTIVESELECTED = (6)   /* selected, in inactive border */
NATIVE {IDS_INACTIVEDISABLED} CONST IDS_INACTIVEDISABLED = (7)   /* disabled, in inactive border */
NATIVE {IDS_SELECTEDDISABLED} CONST IDS_SELECTEDDISABLED = (8)   /* disabled and selected */

/* IM_FRAMEBOX	*/
NATIVE {impFrameBox} OBJECT impframebox
    {MethodID}	methodid	:/*STACKULONG*/ ULONG
    {imp_ContentsBox}	contentsbox	:PTR TO ibox	/* in: relative box of contents */
    {imp_FrameBox}	framebox	:PTR TO ibox	/* out: rel. box of enclosing frame */
    {imp_DrInfo}	drinfo	:PTR TO drawinfo	/* May be NULL */
    {imp_FrameFlags}	frameflags	:/*STACKULONG*/ ULONG
ENDOBJECT

NATIVE {FRAMEF_SPECIFY}	CONST FRAMEF_SPECIFY	= $1

NATIVE {impPos} OBJECT imppos
    {X}	x	:STACKWORD
    {Y}	y	:STACKWORD
ENDOBJECT

NATIVE {impSize} OBJECT impsize
    {Width}	width	:STACKWORD
    {Height}	height	:STACKWORD
ENDOBJECT

/* IM_DRAW, IM_DRAWFRAME */
NATIVE {impDraw} OBJECT impdraw
    {MethodID}	methodid	:/*STACKULONG*/ ULONG
    {imp_RPort}	rport	:PTR TO rastport
    {imp_Offset.X}	offsetx	:STACKWORD
    {imp_Offset.Y}	offsety	:STACKWORD
    {imp_State}	state	:/*STACKULONG*/ ULONG
    {imp_DrInfo}	drinfo	:PTR TO drawinfo    /* May be NULL */

    /* Only valid for IM_DRAWFRAME */
    {imp_Dimensions.Width}	dimensionswidth	:STACKWORD
    {imp_Dimensions.Height}	dimensionsheight	:STACKWORD
ENDOBJECT

/* IM_ERASE, IM_ERASEFRAME	*/
/* NOTE: This is a subset of impDraw	*/
NATIVE {impErase} OBJECT imperase
    {MethodID}	methodid	:/*STACKULONG*/ ULONG
    {imp_RPort}	rport	:PTR TO rastport
    {imp_Offset.X}	offsetx	:STACKWORD
    {imp_Offset.Y}	offsety	:STACKWORD

    /* Only valid for IM_ERASEFRAME */
    {imp_Dimensions.Width}	dimensionswidth	:STACKWORD
    {imp_Dimensions.Height}	dimensionsheight	:STACKWORD
ENDOBJECT

/* IM_HITTEST, IM_HITFRAME	*/
NATIVE {impHitTest} OBJECT imphittest
    {MethodID}	methodid	:/*STACKULONG*/ ULONG
    {imp_Point.X}	pointx	:STACKWORD
    {imp_Point.Y}	pointy	:STACKWORD

    /* Only valid for IM_HITFRAME */
    {imp_Dimensions.Width}	dimensionswidth	:STACKWORD
    {imp_Dimensions.Height}	dimensionsheight	:STACKWORD
ENDOBJECT
