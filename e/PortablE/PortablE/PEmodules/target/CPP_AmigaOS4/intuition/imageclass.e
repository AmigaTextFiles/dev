/* $Id: imageclass.h,v 1.16 2005/11/10 15:39:40 hjfrieden Exp $ */
OPT NATIVE, PREPROCESS
PUBLIC MODULE 'target/intuition/intuition_shared3'
MODULE 'target/intuition/intuition', 'target/intuition/iobsolete'
MODULE 'target/utility/tagitem', 'target/intuition/screens', 'target/graphics/rastport', 'target/intuition/cghooks', 'target/graphics/regions', 'target/exec/types'
{#include <intuition/imageclass.h>}
NATIVE {INTUITION_IMAGECLASS_H} CONST

NATIVE {CUSTOMIMAGEDEPTH} CONST CUSTOMIMAGEDEPTH = (-1)
/* if image.Depth is this, it's a new Image class object */

/* some convenient macros and casts */
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

/******************************************************/
NATIVE {IA_Dummy}            CONST IA_DUMMY            = (TAG_USER + $20000)
NATIVE {IA_Left}             CONST IA_LEFT             = (IA_DUMMY + $01)
NATIVE {IA_Top}              CONST IA_TOP              = (IA_DUMMY + $02)
NATIVE {IA_Width}            CONST IA_WIDTH            = (IA_DUMMY + $03)
NATIVE {IA_Height}           CONST IA_HEIGHT           = (IA_DUMMY + $04)
NATIVE {IA_FGPen}            CONST IA_FGPEN            = (IA_DUMMY + $05)
            /* IA_FGPen also means "PlanePick" */
NATIVE {IA_BGPen}            CONST IA_BGPEN            = (IA_DUMMY + $06)
            /* IA_BGPen also means "PlaneOnOff" */
NATIVE {IA_Data}             CONST IA_DATA             = (IA_DUMMY + $07)
            /* bitplanes, for classic image,
             * other image classes may use it for other things
             */
NATIVE {IA_LineWidth}        CONST IA_LINEWIDTH        = (IA_DUMMY + $08)
NATIVE {IA_Pens}             CONST IA_PENS             = (IA_DUMMY + $0E)
            /* pointer to UWORD pens[],
             * ala DrawInfo.Pens, MUST be
             * terminated by ~0.  Some classes can
             * choose to have this, or SYSIA_DrawInfo,
             * or both.
             */
NATIVE {IA_Resolution}       CONST IA_RESOLUTION       = (IA_DUMMY + $0F)
            /* packed uwords for x/y resolution into a longword
             * ala DrawInfo.Resolution
             */

/**** see class documentation to learn which *****/
/**** classes recognize these                *****/
NATIVE {IA_APattern}         CONST IA_APATTERN         = (IA_DUMMY + $10)
NATIVE {IA_APatSize}         CONST IA_APATSIZE         = (IA_DUMMY + $11)
NATIVE {IA_Mode}             CONST IA_MODE             = (IA_DUMMY + $12)
NATIVE {IA_Font}             CONST IA_FONT             = (IA_DUMMY + $13)
NATIVE {IA_Outline}          CONST IA_OUTLINE          = (IA_DUMMY + $14)
NATIVE {IA_Recessed}         CONST IA_RECESSED         = (IA_DUMMY + $15)
NATIVE {IA_DoubleEmboss}     CONST IA_DOUBLEEMBOSS     = (IA_DUMMY + $16)
NATIVE {IA_EdgesOnly}        CONST IA_EDGESONLY        = (IA_DUMMY + $17)

/**** "sysiclass" attributes                 *****/
NATIVE {SYSIA_Size}          CONST SYSIA_SIZE          = (IA_DUMMY + $0B)
            /* #define's below */
NATIVE {SYSIA_Depth}         CONST SYSIA_DEPTH         = (IA_DUMMY + $0C)
            /* this is unused by Intuition.  SYSIA_DrawInfo
             * is used instead for V36
             */
NATIVE {SYSIA_Which}         CONST SYSIA_WHICH         = (IA_DUMMY + $0D)
            /* see #define's below */
NATIVE {SYSIA_DrawInfo}      CONST SYSIA_DRAWINFO      = (IA_DUMMY + $18)
            /* pass to sysiclass, please */

/***** obsolete: don't use these, use IA_Pens *****/
NATIVE {SYSIA_Pens}          CONST SYSIA_PENS          = IA_PENS
NATIVE {IA_ShadowPen}        CONST IA_SHADOWPEN        = (IA_DUMMY + $09)
NATIVE {IA_HighlightPen}     CONST IA_HIGHLIGHTPEN     = (IA_DUMMY + $0A)

/* New for V39: */
NATIVE {SYSIA_ReferenceFont} CONST SYSIA_REFERENCEFONT = (IA_DUMMY + $19)
            /* Font to use as reference for scaling
             * certain sysiclass images
             */
NATIVE {IA_SupportsDisable}  CONST IA_SUPPORTSDISABLE  = (IA_DUMMY + $1a)
            /* By default, Intuition ghosts gadgets itself,
             * instead of relying on IDS_DISABLED or
             * IDS_SELECTEDDISABLED.  An imageclass that
             * supports these states should return this attribute
             * as TRUE.  You cannot set or clear this attribute,
             * however.
             */

NATIVE {IA_FrameType}        CONST IA_FRAMETYPE        = (IA_DUMMY + $1b)
            /* Starting with V39, FrameIClass recognizes
             * several standard types of frame.  Use one
             * of the FRAME_ specifiers below.    Defaults
             * to FRAME_DEFAULT.
             */

NATIVE {IA_Underscore}       CONST IA_UNDERSCORE       = (IA_DUMMY + $1c)
            /* V44, Indicate underscore keyboard shortcut for image labels.
             * (UBYTE) Defaults to '_'
             */

NATIVE {IA_Scalable}         CONST IA_SCALABLE         = (IA_DUMMY + $1d)
            /* V44, Attribute indicates this image is allowed
             * to/can scale its rendering.
             * (BOOL) Defaults to FALSE.
             */

NATIVE {IA_ActivateKey}      CONST IA_ACTIVATEKEY      = (IA_DUMMY + $1e)
            /* V44, Used to get an underscored label shortcut.
             * Useful for labels attached to string gadgets.
             * (UBYTE) Defaults to NULL.
             */

NATIVE {IA_Screen}           CONST IA_SCREEN           = (IA_DUMMY + $1f)
            /* V44 Screen pointer, may be useful/required by certain classes.
             * (struct Screen *)
             */

NATIVE {IA_Precision}        CONST IA_PRECISION        = (IA_DUMMY + $20)
            /* V44 Precision value, typically pen precision but may be
             * used for similar custom purposes.
             * (ULONG)
             */

/* New for V50: */
NATIVE {SYSIA_FullFrame}     CONST SYSIA_FULLFRAME     = (IA_DUMMY + $21)
            /* Specifies whether the sysiclass image must have an
             * inner frame, if the current style normally has one.
             * This is useful only with TBFRAMEIMAGE images.
             * Set this to FALSE to get an image suitable as
             * background for text, or TRUE if you want a normal
             * titlebar gadget image which you can add graphic
             * contents to. Defaults to FALSE. (V50)
             */
NATIVE {SYSIA_ContentsBox}   CONST SYSIA_CONTENTSBOX   = (IA_DUMMY + $22)
            /* Read-only attribute: pass a (struct IBox *) to
             * inquire about the position and size of the inner
             * area of a TBFRAMEIMAGE image, in order to bound
             * your custom imagery inside that area and avoid
             * overwriting the image's borders. (V50)
             */
NATIVE {IA_Orientation}      CONST IA_ORIENTATION      = (IA_DUMMY + $23)
            /* Defines orientation, for images needing this kind
             * of information, such as the PROPKNOB frameiclass
             * type or gaugeiclass. As of V50, the values can be
             * 0 (horizontal) or 1 (vertical). Defaults to 0. (V50)
             */
NATIVE {IA_Simple}           CONST IA_SIMPLE           = (IA_DUMMY + $24)
            /* This boolean attribute indicates whether the image
             * should be drawn with the most plain graphic
             * appearance it supports. For frameiclass, this means
             * to drop fancy styles like XEN or rounded corners.
             * Defaults to FALSE (user-selected style). (V50)
             */
NATIVE {SYSIA_VectorInfo}    CONST SYSIA_VECTORINFO    = (IA_DUMMY + $25)
            /* Custom vector definition for a sysiclass image. (V50)
             */
NATIVE {SYSIA_RenderHook}    CONST SYSIA_RENDERHOOK    = (IA_DUMMY + $26)
            /* Custom rendering hook for a sysiclass image. (V50)
             */
NATIVE {SYSIA_BitMapCache}   CONST SYSIA_BITMAPCACHE   = (IA_DUMMY + $27)
            /* Level of bitmap caching for sysiclass images (0 = none,
             * 1 = deferred, 2 = immediate). Defaults to 2. (V50)
             */
NATIVE {IA_Label}            CONST IA_LABEL            = (IA_DUMMY + $28)
NATIVE {SYSIA_Label}         CONST SYSIA_LABEL         = IA_LABEL
            /* Pointer to a string to be used as the image's text
             * label, if it supports one. (V50)
             */
NATIVE {IA_BackFill}         CONST IA_BACKFILL         = (IA_DUMMY + $29)
NATIVE {IA_SelectedBackFill} CONST IA_SELECTEDBACKFILL = (IA_DUMMY + $2A)
NATIVE {IA_DisabledBackFill} CONST IA_DISABLEDBACKFILL = (IA_DUMMY + $2B)
NATIVE {IA_InactiveBackFill} CONST IA_INACTIVEBACKFILL = (IA_DUMMY + $2C)
            /* Pointer to a backfill hook the image can use to fill
             * its background, if it supports this attribute. (V50)
             */
NATIVE {IA_EraseBackground}  CONST IA_ERASEBACKGROUND  = (IA_DUMMY + $2D)
            /* Erase the background before rendering the image?
             * Defaults to TRUE for images having a non-rectangular
             * or anti-aliased shape, FALSE otherwise. (V51)
             */
NATIVE {IA_InBorder}         CONST IA_INBORDER         = (IA_DUMMY + $2E)
            /* Is this image to be drawn inside a window border?
             * Defaults to FALSE. (V51)
             */
/**** "gaugeiclass" attributes               *****/
NATIVE {GAUGEIA_Min}         CONST GAUGEIA_MIN         = (IA_DUMMY + $2F)
            /* Minimum level of a gaugeiclass image. (V51)
             */
NATIVE {GAUGEIA_Max}         CONST GAUGEIA_MAX         = (IA_DUMMY + $30)
            /* Maximum level of a gaugeiclass image. (V51)
             */
NATIVE {GAUGEIA_Level}       CONST GAUGEIA_LEVEL       = (IA_DUMMY + $31)
            /* Current level of a gaugeiclass image. (V51)
             */
NATIVE {GAUGEIA_Ticks}       CONST GAUGEIA_TICKS       = (IA_DUMMY + $32)
            /* Number of tick marks to be drawn for a gaugeiclass
             * image. Defaults to 0 (no tick marks). (V51)
             */
NATIVE {GAUGEIA_TickSize}    CONST GAUGEIA_TICKSIZE    = (IA_DUMMY + $33)
            /* Length of tick marks for a gaugeiclass image, if
             * they are present. Defaults to 4. (V51)
             */
NATIVE {GAUGEIA_ShortTicks}  CONST GAUGEIA_SHORTTICKS  = (IA_DUMMY + $34)
            /* Should half-length tick marks be drawn in-between
             * the normal tick marks of a gaugeiclass image?
             * Defaults to FALSE. (V51)
                     */
NATIVE {GAUGEIA_InnerTicks}  CONST GAUGEIA_INNERTICKS  = (IA_DUMMY + $35)
            /* Should tick marks be drawn inside the gauge,
             * rather than alongside it? Defaults to FALSE. (V51)
             */
NATIVE {GAUGEIA_ScaleHook}   CONST GAUGEIA_SCALEHOOK   = (IA_DUMMY + $36)
            /* Custom hook for calculating the size of the filled
             * part of the gauge, relative to the container's size;
             * object is the image, message is a pointer to an
             * array of 3 uint32s. The scale hook must calculate
             * (number[0] * number[1]) / number[2] and return the
             * result, or zero if it can't perform the calculation.
             * Passing NULL means an internal scaling routine will
             * be used. Defaults to NULL. (V51)
             */
NATIVE {IA_Justification}    CONST IA_JUSTIFICATION    = (IA_DUMMY + $37)
            /* Justification of the image's text label, if it
             * supports one. Use one of the IJ_ constants below.
             * Defaults to IJ_LEFT, unless otherwise specified
             * in the documentation for the image class. (V51)
             */
NATIVE {IA_LabelPen}         CONST IA_LABELPEN         = (IA_DUMMY + $38)
            /* Color of the image's text label, if it supports one.
             * Defaults to the TEXTPEN color. (V51)
             */
/** next attribute:         (IA_DUMMY + $39) **/
/***********************************************/

/* data values for SYSIA_Size */
NATIVE {SYSISIZE_MEDRES} CONST SYSISIZE_MEDRES = (0)
NATIVE {SYSISIZE_LOWRES} CONST SYSISIZE_LOWRES = (1)
NATIVE {SYSISIZE_HIRES}  CONST SYSISIZE_HIRES  = (2)

/*
 * SYSIA_Which tag data values:
 * Specifies which system gadget you want an image for.
 * Some numbers correspond to internal Intuition #defines
 */
NATIVE {DEPTHIMAGE}     CONST DEPTHIMAGE     = ($00) /* Window depth gadget image */
NATIVE {ZOOMIMAGE}      CONST ZOOMIMAGE      = ($01) /* Window zoom gadget image */
NATIVE {SIZEIMAGE}      CONST SIZEIMAGE      = ($02) /* Window sizing gadget image */
NATIVE {CLOSEIMAGE}     CONST CLOSEIMAGE     = ($03) /* Window close gadget image */
NATIVE {SDEPTHIMAGE}    CONST SDEPTHIMAGE    = ($05) /* Screen depth gadget image */
NATIVE {LEFTIMAGE}      CONST LEFTIMAGE      = ($0A) /* Window left-arrow gadget image */
NATIVE {UPIMAGE}        CONST UPIMAGE        = ($0B) /* Window up-arrow gadget image */
NATIVE {RIGHTIMAGE}     CONST RIGHTIMAGE     = ($0C) /* Window right-arrow gadget image */
NATIVE {DOWNIMAGE}      CONST DOWNIMAGE      = ($0D) /* Window down-arrow gadget image */
NATIVE {CHECKIMAGE}     CONST CHECKIMAGE     = ($0E) /* GT/RA checkbox image */
NATIVE {MXIMAGE}        CONST MXIMAGE        = ($0F) /* GT/RA mutual exclude "button" image */
/* New for V39: */
NATIVE {MENUCHECK}      CONST MENUCHECK      = ($10) /* Menu checkmark image */
NATIVE {AMIGAKEY}       CONST AMIGAKEY       = ($11) /* Menu Amiga-key image */
/* New for V50: */
NATIVE {SBARLOGO}       CONST SBARLOGO       = ($12) /* Screen titlebar logo */
NATIVE {POPUPIMAGE}     CONST POPUPIMAGE     = ($13) /* Window pop-up gadget image */
NATIVE {SETTINGSIMAGE}  CONST SETTINGSIMAGE  = ($14) /* Window settings gadget image */
NATIVE {SNAPSHOTIMAGE}  CONST SNAPSHOTIMAGE  = ($15) /* Window snapshot gadget image */
NATIVE {ICONIFYIMAGE}   CONST ICONIFYIMAGE   = ($16) /* Window iconify gadget image */
NATIVE {PADLOCKIMAGE}   CONST PADLOCKIMAGE   = ($17) /* Window padlock gadget image */
NATIVE {TBFRAMEIMAGE}   CONST TBFRAMEIMAGE   = ($18) /* Window titlebar frame image */
NATIVE {HKHANDLEIMAGE}  CONST HKHANDLEIMAGE  = ($19) /* Window horizontal knob handle symbol */
NATIVE {VKHANDLEIMAGE}  CONST VKHANDLEIMAGE  = ($1A) /* Window vertical knob handle symbol */
NATIVE {MENUMX}         CONST MENUMX         = ($1B) /* Menu mutualexclude image */
NATIVE {MENUSUB}        CONST MENUSUB        = ($1C) /* Menu sub-panel indicator */
NATIVE {CYCLEIMAGE}     CONST CYCLEIMAGE     = ($1D) /* GT/RA cycle symbol */
NATIVE {CHECKMARKIMAGE} CONST CHECKMARKIMAGE = ($1E) /* GT/RA checkmark symbol */
NATIVE {GLEFTIMAGE}     CONST GLEFTIMAGE     = ($1F) /* GT/RA left-arrow symbol */
NATIVE {GUPIMAGE}       CONST GUPIMAGE       = ($20) /* GT/RA up-arrow symbol */
NATIVE {GRIGHTIMAGE}    CONST GRIGHTIMAGE    = ($21) /* GT/RA right-arrow symbol */
NATIVE {GDOWNIMAGE}     CONST GDOWNIMAGE     = ($22) /* GT/RA down-arrow symbol */
NATIVE {GHKHANDLEIMAGE} CONST GHKHANDLEIMAGE = ($23) /* GT/RA horizontal knob handle symbol */
NATIVE {GVKHANDLEIMAGE} CONST GVKHANDLEIMAGE = ($24) /* GT/RA vertical knob handle symbol */
/* New for V51: */
NATIVE {SCLOSEIMAGE}    CONST SCLOSEIMAGE    = ($25) /* Screen close gadget image */
NATIVE {SCREENSIMAGE}   CONST SCREENSIMAGE   = ($26) /* Window screen-jump gadget image */

/* Additional system image types recognized by DrawSysImageA() (V50)
 */
NATIVE {SI_HPROPBACKGROUND} CONST SI_HPROPBACKGROUND = $1001 /* Background of an horizontal scroller */
NATIVE {SI_VPROPBACKGROUND} CONST SI_VPROPBACKGROUND = $1002 /* Background of a vertical scroller */

/* Data values for IA_FrameType (recognized by FrameIClass)
 *
 * FRAME_DEFAULT:  The standard V37-type frame, which has
 *    thin edges.
 * FRAME_BUTTON:  Standard button gadget frames, having thicker
 *    sides and nicely edged corners.
 * FRAME_RIDGE:  A ridge such as used by standard string gadgets.
 *    You can recess the ridge to get a groove image.
 * FRAME_ICONDROPBOX: A broad ridge which is the standard imagery
 *    for areas in AppWindows where icons may be dropped.
 * FRAME_PROPBORDER: A frame suitable for use as border of a
 *    proportional gadget container. (V50)
 * FRAME_PROPKNOB: A frame suitable for use as knob of a
 *    proportional gadget. (V50)
 * FRAME_DISPLAY: A recessed frame for display elements, such as
 *    read-only text or number gadgets. (V50)
 */

NATIVE {FRAME_DEFAULT}     CONST FRAME_DEFAULT     = 0
NATIVE {FRAME_BUTTON}      CONST FRAME_BUTTON      = 1
NATIVE {FRAME_RIDGE}       CONST FRAME_RIDGE       = 2
NATIVE {FRAME_ICONDROPBOX} CONST FRAME_ICONDROPBOX = 3
NATIVE {FRAME_PROPBORDER}  CONST FRAME_PROPBORDER  = 4
NATIVE {FRAME_PROPKNOB}    CONST FRAME_PROPKNOB    = 5
NATIVE {FRAME_DISPLAY}     CONST FRAME_DISPLAY     = 6

/* IA_Justification tag data values */

NATIVE {IJ_LEFT}   CONST IJ_LEFT   = 0
NATIVE {IJ_CENTER} CONST IJ_CENTER = 1
NATIVE {IJ_RIGHT}  CONST IJ_RIGHT  = 2


/* image message id's */
NATIVE {IM_DRAW}        CONST IM_DRAW        = $202 /* draw yourself, with "state" */
NATIVE {IM_HITTEST}     CONST IM_HITTEST     = $203 /* return TRUE if click hits image */
NATIVE {IM_ERASE}       CONST IM_ERASE       = $204 /* erase yourself */
NATIVE {IM_MOVE}        CONST IM_MOVE        = $205 /* draw new and erase old, smoothly */

NATIVE {IM_DRAWFRAME}   CONST IM_DRAWFRAME   = $206 /* draw with specified dimensions */
NATIVE {IM_FRAMEBOX}    CONST IM_FRAMEBOX    = $207 /* get recommended frame around some box */
NATIVE {IM_HITFRAME}    CONST IM_HITFRAME    = $208 /* hittest with dimensions */
NATIVE {IM_ERASEFRAME}  CONST IM_ERASEFRAME  = $209 /* erase with dimensions */

NATIVE {IM_DOMAINFRAME} CONST IM_DOMAINFRAME = $20A /* query image for its domain info (V44) */

NATIVE {IM_EXTENT}      CONST IM_EXTENT      = $20B /* inquire about rendering extent (V51) */
NATIVE {IM_EXTENTFRAME} CONST IM_EXTENTFRAME = $20C /* as IM_EXTENT, with dimensions (V51) */

/* image draw states or styles, for IM_DRAW */
/* Note that they have no bitwise meanings (unfortunately) */
NATIVE {IDS_NORMAL}           CONST IDS_NORMAL           = (0)
NATIVE {IDS_SELECTED}         CONST IDS_SELECTED         = (1) /* for selected gadgets */
NATIVE {IDS_DISABLED}         CONST IDS_DISABLED         = (2) /* for disabled gadgets */
NATIVE {IDS_BUSY}             CONST IDS_BUSY             = (3) /* for future functionality */
NATIVE {IDS_INDETERMINATE}    CONST IDS_INDETERMINATE    = (4) /* for future functionality */
NATIVE {IDS_INACTIVENORMAL}   CONST IDS_INACTIVENORMAL   = (5) /* normal, in inactive window border */
NATIVE {IDS_INACTIVESELECTED} CONST IDS_INACTIVESELECTED = (6) /* selected, in inactive border */
NATIVE {IDS_INACTIVEDISABLED} CONST IDS_INACTIVEDISABLED = (7) /* disabled, in inactive border */
NATIVE {IDS_SELECTEDDISABLED} CONST IDS_SELECTEDDISABLED = (8) /* disabled and selected */

/* oops, please forgive spelling error by jimm */
NATIVE {IDS_INDETERMINANT} CONST IDS_INDETERMINANT = IDS_INDETERMINATE

/* IM_FRAMEBOX    */
NATIVE {impFrameBox} OBJECT impframebox
    {MethodID}	methodid	:ULONG
    {imp_ContentsBox}	contentsbox	:PTR TO ibox /* input: relative box of contents */
    {imp_FrameBox}	framebox	:PTR TO ibox    /* output: rel. box of encl frame  */
    {imp_DrInfo}	drinfo	:PTR TO drawinfo      /* NB: May be NULL */
    {imp_FrameFlags}	frameflags	:ULONG
ENDOBJECT

->"CONST FRAMEF_SPECIFY" is on-purposely missing from here (it can be found in 'intuition/intuition_shared3')

/* IM_DRAW, IM_DRAWFRAME */
NATIVE {impDraw} OBJECT impdraw
    {MethodID}	methodid	:ULONG
    {imp_RPort}	rport	:PTR TO rastport
    {imp_Offset.X}	offsetx	:INT
    {imp_Offset.Y}	offsety	:INT

    {imp_State}	state	:ULONG
    {imp_DrInfo}	drinfo	:PTR TO drawinfo /* NB: May be NULL */

    /* these parameters only valid for IM_DRAWFRAME */
    {imp_Dimensions.Width}	dimensionswidth	:INT
    {imp_Dimensions.Height}	dimensionsheight	:INT
ENDOBJECT

/* IM_ERASE, IM_ERASEFRAME */
/* NOTE: This is a subset of impDraw */
NATIVE {impErase} OBJECT imperase
    {MethodID}	methodid	:ULONG
    {imp_RPort}	rport	:PTR TO rastport
    {imp_Offset.X}	offsetx	:INT
    {imp_Offset.Y}	offsety	:INT

    /* these parameters only valid for IM_ERASEFRAME */
    {imp_Dimensions.Width}	dimensionswidth	:INT
    {imp_Dimensions.Height}	dimensionsheight	:INT
ENDOBJECT

/* IM_HITTEST, IM_HITFRAME */
NATIVE {impHitTest} OBJECT imphittest
    {MethodID}	methodid	:ULONG
    {imp_Point.X}	pointx	:INT
    {imp_Point.Y}	pointy	:INT

    /* these parameters only valid for IM_HITFRAME */
    {imp_Dimensions.Width}	dimensionswidth	:INT
    {imp_Dimensions.Height}	dimensionsheight	:INT
ENDOBJECT


/* The IM_DOMAINFRAME method is used to obtain the sizing
 * requirements of an image object within a layout group.
 */

/* IM_DOMAINFRAME */
NATIVE {impDomainFrame} OBJECT impdomainframe
    {MethodID}	methodid	:ULONG
    {imp_DrInfo}	drinfo	:PTR TO drawinfo /* DrawInfo */
    {imp_RPort}	rport	:PTR TO rastport  /* RastPort to layout for */
    {imp_Which}	which	:VALUE  /* what size - min/nominal/max */
    {imp_Domain}	domain	:ibox /* Resulting domain */
    {imp_Attrs}	attrs	:ARRAY OF tagitem  /* Additional attributes */
ENDOBJECT

/* Accepted vales for imp_Which.
 */
NATIVE {IDOMAIN_MINIMUM} CONST IDOMAIN_MINIMUM = (0)
NATIVE {IDOMAIN_NOMINAL} CONST IDOMAIN_NOMINAL = (1)
NATIVE {IDOMAIN_MAXIMUM} CONST IDOMAIN_MAXIMUM = (2)


/* The IM_EXTENT/IM_EXTENTFRAME method is used to ask the
 * image what pixels or areas (at least) it will fully
 * overwrite in its IM_DRAW/IM_DRAWFRAME method.
 *
 * See the description of gadgetclass/GM_EXTENT for more
 * detailed information about this topic.
 */

/* IM_EXTENT, IM_EXTENTFRAME */
NATIVE {impExtent} OBJECT impextent
    {MethodID}	methodid	:ULONG
    {imp_DrInfo}	drinfo	:PTR TO drawinfo /* May be NULL */
    {imp_RPort}	rport	:PTR TO rastport  /* NULL if masking not supported */
    {imp_Region}	region	:PTR TO region /* NULL if clipping not supported */
    {imp_Action}	action	:ULONG /* Requested operation */
    {imp_Flags}	flags	:ULONG  /* Control flags, see below */
    {imp_Attrs}	attrs	:ARRAY OF tagitem  /* Additional attributes */
    {imp_State}	state	:ULONG  /* Rendering state */
    {imp_Frame}	frame	:ibox  /* Sizes only valid for IM_EXTENTFRAME */
ENDOBJECT

/* Possible operations requested by IM_EXTENT/IM_EXTENTFRAME
 */
NATIVE {IEXTENT_REMOVE} CONST IEXTENT_REMOVE = (0) /* You should CLEAR shapes from region/mask */
NATIVE {IEXTENT_ADD}    CONST IEXTENT_ADD    = (1) /* You should OR shapes into region/mask */
NATIVE {IEXTENT_INVERT} CONST IEXTENT_INVERT = (2) /* You should XOR shapes into region/mask */
NATIVE {IEXTENT_SECT}   CONST IEXTENT_SECT   = (3) /* You should AND shapes into region/mask */

/* Control flags defined for IM_EXTENT/IM_EXTENTFRAME
 */
NATIVE {IMPF_ALLOWSUPER} CONST IMPF_ALLOWSUPER = ($01) /* Allow superclass to handle the method */

/* Possible return codes for IM_EXTENT/IM_EXTENTFRAME
 */
NATIVE {IMR_INVALID}  CONST IMR_INVALID  = ($00) /* Couldn't provide any information */
NATIVE {IMR_CLIPDONE} CONST IMR_CLIPDONE = ($40) /* Added to the region all areas I fully cover */
NATIVE {IMR_MASKDONE} CONST IMR_MASKDONE = ($80) /* Wrote into the mask all pixels I fully cover */
