/* $Id: sysiclass.h,v 1.12 2005/11/10 15:39:41 hjfrieden Exp $ */
OPT NATIVE
MODULE 'target/intuition/intuition', 'target/intuition/imageclass'
MODULE 'target/exec/nodes', 'target/utility/tagitem', 'target/utility/hooks', 'target/graphics/rastport', 'target/intuition/screens', 'target/exec/types'
{#include <intuition/sysiclass.h>}
NATIVE {INTUITION_SYSICLASS_H} CONST

/***************************************************/
/*** Common structures for simple vector drawing ***/
/***************************************************/

NATIVE {Vector} OBJECT vector
   {Operation}	operation	:UBYTE /* Type of rendering operation */
   {Type}	type	:UBYTE      /* Type of environment (monochrome/color) */
   {DRIPen}	dripen	:UINT    /* DrawInfo pen for this rendering */
   {States}	states	:ULONG    /* States this rendering applies to */
   {X}	x	:INT
	{Y}	y	:INT      /* Offsets for rendering */
   {Data}	data	:PTR TO UINT      /* Rendering specifications */
ENDOBJECT

NATIVE {VectorInfo} OBJECT vectorinfo
   {VectorID}	vectorid	:ULONG     /* To identify the image, if needed */
   {Vectors}	vectors	:PTR TO vector      /* VO_END-terminated array of vectors */
   {DesignWidth}	designwidth	:UINT  /* Reference width for scaling */
   {DesignHeight}	designheight	:UINT /* Reference height for scaling */
   {Flags}	flags	:ULONG        /* Additional information */
   {States}	states	:ULONG       /* Supported states */
ENDOBJECT

/* Values for Vector.Operation */

NATIVE {VO_LINE} CONST VO_LINE = $00  /* Outline only */
NATIVE {VO_FILL} CONST VO_FILL = $01  /* Filled, not outline */
NATIVE {VO_RECT} CONST VO_RECT = $00  /* Rectangle */
NATIVE {VO_POLY} CONST VO_POLY = $02  /* Polygon */
NATIVE {VO_ELPS} CONST VO_ELPS = $04  /* Ellipse */

NATIVE {VO_LINERECT} CONST VO_LINERECT = (VO_LINE OR VO_RECT)
NATIVE {VO_FILLRECT} CONST VO_FILLRECT = (VO_FILL OR VO_RECT)
NATIVE {VO_LINEPOLY} CONST VO_LINEPOLY = (VO_LINE OR VO_POLY)
NATIVE {VO_FILLPOLY} CONST VO_FILLPOLY = (VO_FILL OR VO_POLY)
NATIVE {VO_LINEELPS} CONST VO_LINEELPS = (VO_LINE OR VO_ELPS)
NATIVE {VO_FILLELPS} CONST VO_FILLELPS = (VO_FILL OR VO_ELPS)

NATIVE {VO_END}      CONST VO_END      = $FF  /* End marker for Vector array */

/* Values for Vector.Type */

NATIVE {VT_MONO}  CONST VT_MONO  = $01  /* Vector is used for monochrome rendering */
NATIVE {VT_COLOR} CONST VT_COLOR = $02  /* Vector is used for color rendering */
NATIVE {VT_BOTH}  CONST VT_BOTH  = $03  /* Vector is used for both types of rendering */

/* Special values for Vector.DRIPen */

NATIVE {PEN_BRIGHT}      CONST PEN_BRIGHT      = $1000  /* Bright shade of the background */
NATIVE {PEN_HALFBRIGHT}  CONST PEN_HALFBRIGHT  = $1001  /* Half-bright shade of the background */
NATIVE {PEN_HALFDARK}    CONST PEN_HALFDARK    = $1003  /* Half-dark shade of the background */
NATIVE {PEN_DARK}        CONST PEN_DARK        = $1004  /* Dark shade of the background */
NATIVE {PEN_ALPHASHINE}  CONST PEN_ALPHASHINE  = $2000  /* OR with 0..255 for bright alpha shading */
NATIVE {PEN_ALPHASHADOW} CONST PEN_ALPHASHADOW = $3000  /* OR with 0..255 for dark alpha shading */
NATIVE {PEN_ALPHA}       CONST PEN_ALPHA       = $4000  /* OR with 0..255 for alpha blending */

/* State flags. Sysiclass doesn't support INACTIVEDISABLED for now. */

NATIVE {IDSF_NORMAL}           CONST IDSF_NORMAL           = $1
NATIVE {IDSF_SELECTED}         CONST IDSF_SELECTED         = $2
NATIVE {IDSF_DISABLED}         CONST IDSF_DISABLED         = $4
NATIVE {IDSF_INACTIVENORMAL}   CONST IDSF_INACTIVENORMAL   = $20
NATIVE {IDSF_INACTIVESELECTED} CONST IDSF_INACTIVESELECTED = $40
NATIVE {IDSF_SELECTEDDISABLED} CONST IDSF_SELECTEDDISABLED = $100

NATIVE {IDSF_MASK}             CONST IDSF_MASK             = ($10000000) /* Use for image mask */
NATIVE {IDSF_DISABLEDMASK}     CONST IDSF_DISABLEDMASK     = ($20000000) /* Use for normal disabled mask */
NATIVE {IDSF_SELDISABLEDMASK}  CONST IDSF_SELDISABLEDMASK  = ($40000000) /* Use for selected disabled mask*/
NATIVE {IDSF_ERASEMASK}        CONST IDSF_ERASEMASK        = ($80000000) /* Draw mask with color zero */

/* Values for VectorInfo.Flags */

NATIVE {VIF_WMULTIPLY}      CONST VIF_WMULTIPLY      = $0000000F /* Multiplier for width (VIF_REFFONT) */
NATIVE {VIF_REFFONT}        CONST VIF_REFFONT        = $00000010 /* Allows reference font
                                         to be specified */
NATIVE {VIF_IGNOREWIDTH}    CONST VIF_IGNOREWIDTH    = $00000020 /* Ignore IA_Width */
NATIVE {VIF_IGNOREHEIGHT}   CONST VIF_IGNOREHEIGHT   = $00000040 /* Ignore IA_Height */
NATIVE {VIF_ROUNDEDSCALING} CONST VIF_ROUNDEDSCALING = $00000100 /* Needs rounded scaling */
NATIVE {VIF_KEEPASPECT}     CONST VIF_KEEPASPECT     = $00000200 /* Preserve aspect ratio of
                                         reference size */
NATIVE {VIF_3DDISABLE}      CONST VIF_3DDISABLE      = $00000400 /* Uses 3D (embossed) disable effects */
NATIVE {VIF_NOBUFFER}       CONST VIF_NOBUFFER       = $00000800 /* Render without using off-screen
                                         bitmaps */
NATIVE {VIF_PENSHADE}       CONST VIF_PENSHADE       = $00001000 /* Uses pen shading, needs a map */
NATIVE {VIF_ALPHASHINE}     CONST VIF_ALPHASHINE     = $00002000 /* Uses bright alpha shading,
                                         needs a map */
NATIVE {VIF_ALPHASHADOW}    CONST VIF_ALPHASHADOW    = $00004000 /* Uses dark alpha shading,
                                         needs a map */
NATIVE {VIF_ALPHASHADE}     CONST VIF_ALPHASHADE     = $00006000 /* Uses both bright and dark
                                         alpha shading */
NATIVE {VIF_ALPHABLEND}     CONST VIF_ALPHABLEND     = $00008000 /* Uses alpha blending, needs a map */
NATIVE {VIF_BORDERMASK}     CONST VIF_BORDERMASK     = $00FF0000 /* Specifications for image borders */
NATIVE {VIF_TBLEFT}         CONST VIF_TBLEFT         = $00010000 /* Image is for left side of titlebar */
NATIVE {VIF_TBRIGHT}        CONST VIF_TBRIGHT        = $00020000 /* Image is for right side of titlebar */
NATIVE {VIF_VERTARROW}      CONST VIF_VERTARROW      = $00040000 /* Image is for right window border */
NATIVE {VIF_HORIZARROW}     CONST VIF_HORIZARROW     = $00080000 /* Image is for bottom window border */
NATIVE {VIF_BRCORN}         CONST VIF_BRCORN         = $00100000 /* Image is for bottom-right
                                         window corner */
NATIVE {VIF_SCREENBAR}      CONST VIF_SCREENBAR      = $00200000 /* Image is for screen titlebar */
NATIVE {VIF_MENU}           CONST VIF_MENU           = $00400000 /* Image is for menu panel */
NATIVE {VIF_BUTTON}         CONST VIF_BUTTON         = $00800000 /* Image must have a button-like
                                         border */


/**********************************************/
/*** The sysiclass rendering hook interface ***/
/**********************************************/

/* Starting with Intuition V50, sysiclass supports custom rendering hooks.   */
/* The rendering hook message structure is defined in <intuition/plugins.h>; */
/* object is a struct Image * (the image instance to be drawn).              */
/* Please note that the object may be NULL, in which case the rm_Flags field */
/* will hold information on what to render (see flags defined below).        */

/* These are the different types of messages that a sysiclass rendering hook */
/* can see; more might be added in future Intuition releases.                */
/*                                                                           */
/* NOTE WELL: in a pen shade level map, you render with colors 0-4, which    */
/* correspond to the LEVEL_#? constants defined in <intuition/gui.h>.        */
/* In an alpha shading map, instead, you render with colors 0-255 which are  */
/* interpreted as alpha intensity percentages (darkest to brightest).        */
/* The former method allows to produce 3D effects consistent with the user   */
/* contrast settings for the GUI; the latter allows for fancy/artistic       */
/* 3D rendering, but can only be used on hicolor/truecolor screenmodes.      */

NATIVE {SR_DRAW}           CONST SR_DRAW           = 801 /* Render symbol imagery for this state        */
NATIVE {SR_DRAWMASK}       CONST SR_DRAWMASK       = 802 /* Render symbol shape mask for this state     */
NATIVE {SR_DRAWDISMASK}    CONST SR_DRAWDISMASK    = 803 /* Render outline mask for disabling, normal   */
NATIVE {SR_DRAWSELDISMASK} CONST SR_DRAWSELDISMASK = 804 /* Render outline mask for disabling, selected */
NATIVE {SR_DRAWLEVELMAP}   CONST SR_DRAWLEVELMAP   = 805 /* Render pen shade level map (if any)         */
NATIVE {SR_DRAWSHINEMAP}   CONST SR_DRAWSHINEMAP   = 806 /* Render bright alpha shading map (if any)    */
NATIVE {SR_DRAWSHADOWMAP}  CONST SR_DRAWSHADOWMAP  = 807 /* Render dark alpha shading map (if any)      */
NATIVE {SR_DRAWALPHAMAP}   CONST SR_DRAWALPHAMAP   = 808 /* Render alpha blending map (if any)          */
NATIVE {SR_DRAWIMAGEFRAME} CONST SR_DRAWIMAGEFRAME = 809 /* Render frame for this image, if any         */

/* These are the sysiclass-specific values for RenderMsg.rm_Flags */

NATIVE {SRF_MONOCHROME}     CONST SRF_MONOCHROME     = $00000001 /* Render as monochrome                */
NATIVE {SRF_ISBITMAP}       CONST SRF_ISBITMAP       = $00000002 /* A bitmap will later be applied      */
NATIVE {SRF_HSCROLLERFRAME} CONST SRF_HSCROLLERFRAME = $00000004 /* Render frame for horizontal scroller*/
NATIVE {SRF_VSCROLLERFRAME} CONST SRF_VSCROLLERFRAME = $00000008 /* Render frame for vertical scroller  */


/****************************************************/
/***        The sysiclass plugin interface        ***/
/*** -------------------------------------------- ***/
/*** Warning: for style plugin implementors only! ***/
/****************************************************/

/* A sysiclass plugin can export graphic styles for system  */
/* imagery (in the form of a rendering hook and/or an array */
/* of struct VectorInfo) as well as geometry information    */
/* for system gadgets and images (in the form of a geometry */
/* hook, see below). As of V50, the style and geometry      */
/* categories known by sysiclass are the following:         */

NATIVE {SC_GLOBALSTYLE}      CONST SC_GLOBALSTYLE      = (0)  /* Default (fallback) graphic style */
NATIVE {SC_GLOBALGEOMETRY}   CONST SC_GLOBALGEOMETRY   = (1)  /* Default (fallback) geometry      */
NATIVE {SC_WINBORDERSTYLE}   CONST SC_WINBORDERSTYLE   = (2)  /* Style for window borders         */
NATIVE {SC_WINBFRAMESTYLE}   CONST SC_WINBFRAMESTYLE   = (3)  /* Style for border gadget frames   */
NATIVE {SC_WINBGADSTYLE}     CONST SC_WINBGADSTYLE     = (4)  /* Style for border gadget symbols  */
NATIVE {SC_GADGETSTYLE}      CONST SC_GADGETSTYLE      = (5)  /* Style for generic gadget symbols */
NATIVE {SC_ARROWGSTYLE}      CONST SC_ARROWGSTYLE      = (6)  /* Style for arrow gadget symbols   */
NATIVE {SC_CYCLEGSTYLE}      CONST SC_CYCLEGSTYLE      = (7)  /* Style for cycle gadget symbols   */
NATIVE {SC_KHANDLESTYLE}     CONST SC_KHANDLESTYLE     = (8)  /* Style for knob handle symbols    */
NATIVE {SC_MENUSTYLE}        CONST SC_MENUSTYLE        = (9)  /* Style for menu images            */
NATIVE {SC_WINBGADGEOMETRY} CONST SC_WINBGADGEOMETRY = (10)  /* Geometry for border gadgets      */
NATIVE {SC_GADGETGEOMETRY}  CONST SC_GADGETGEOMETRY  = (11)  /* Geometry for inner gadgets       */

/* Each plugin can export one or more sub-styles for each   */
/* of the above style categories. It informs clients about  */
/* this by initializing its SubStyles field: it must point  */
/* to an array of struct SubStyle, each of which represents */
/* a specific sub-style for a given category, and gives its */
/* name and unique ID number (uniqueness only needs to be   */
/* relative to the plugin and category). The array must be  */
/* terminated by way of a NULL Name field.                  */
/* Specialized categories should contain at least all the   */
/* sub-styles of their parent category. The style category  */
/* hierarchy (as of V50) is as follows:                     */
/*                                                          */
/* +--SC_GLOBALSTYLE                                        */
/* |  |                                                     */
/* |  +--SC_WINBORDERSTYLE                                  */
/* |  +--SC_WINBFRAMESTYLE                                  */
/* |  +--SC_WINBGADSTYLE                                    */
/* |  +--SC_MENUSTYLE                                       */
/* |  +--SC_GADGETSTYLE                                     */
/* |     |                                                  */
/* |     +--SC_ARROWGSTYLE                                  */
/* |     +--SC_CYCLEGSTYLE                                  */
/* |     +--SC_KHANDLESTYLE                                 */
/* |                                                        */
/* +--SC_GLOBALGEOMETRY                                     */
/*    |                                                     */
/*    +--SC_WINBGADGEOMETRY                                 */
/*    +--SC_GADGETGEOMETRY                                  */
/*                                                          */

NATIVE {SubStyle} OBJECT substyle
   {Name}	name	:/*STRPTR*/ ARRAY OF CHAR      /* Name of the sub-style           */
   {Category}	category	:UINT  /* Category it belongs to          */
   {ID}	id	:UINT        /* Unique style ID for this plugin */
ENDOBJECT

/* The main structure exported by a style plugin library: */
/* it is a generic GUIPlugin structure followed by fields */
/* specific to sysiclass.                                 */
/* Note: the (sparse) VectorInfo array, if present, needs */
/* to be terminated by an element with VectorID == ~0L.   */

NATIVE {SysIPlugin} OBJECT sysiplugin
   {Node}	node	:ln          /* Reserved, don't use                  */
   {Version}	version	:ULONG       /* Version of the plugin                */
   {Type}	type	:ULONG          /* PLUGIN_SYSI                          */
   {Attrs}	attrs	:ULONG         /* Type-specific attributes (see below) */
   {Flags}	flags	:ULONG         /* Additional information               */
   {AttrList}	attrlist	:ARRAY OF tagitem      /* Optional list of GUI attributes      */
   {Reserved}	reserved[4]	:ARRAY OF ULONG   /* For future expansion                 */
   {RenderHook}	renderhook	:PTR TO hook    /* Optional rendering hook              */
   {VIArray}	viarray	:PTR TO vectorinfo       /* Optional array of struct VectorInfo  */
   {Reserved1}	reserved1	:UINT     /* For future expansion                 */
   {GeometryHook}	geometryhook	:PTR TO hook  /* Optional geometry hook (see below)   */
   {SubStyles}	substyles	:PTR TO substyle     /* Table of available sub-styles        */
   {Reserved2}	reserved2[4]	:ARRAY OF ULONG  /* For future expansion                 */
ENDOBJECT

/* Plugin type */

NATIVE {PLUGIN_SYSI} CONST PLUGIN_SYSI = 1  /* Identifies a system imagery plugin */

/* Plugin attributes (flags) */

NATIVE {SPA_WINBORDERSTYLE}  CONST SPA_WINBORDERSTYLE  = $00000004  /* NOT SUPPORTED YET */
NATIVE {SPA_WINBFRAMESTYLE}  CONST SPA_WINBFRAMESTYLE  = $00000008  /* Plugin exports style for
                                         * border gadget frames
                                         */
NATIVE {SPA_WINBGADSTYLE}    CONST SPA_WINBGADSTYLE    = $00000010  /* Plugin exports style for
                                         * border gadget symbols
                                         */
NATIVE {SPA_GADGETSTYLE}     CONST SPA_GADGETSTYLE     = $00000020  /* Plugin exports style for
                                         * normal gadget symbols
                                         */
NATIVE {SPA_MENUSTYLE}       CONST SPA_MENUSTYLE       = $00000200  /* Plugin exports style for
                                         * menu symbols
                                         */
NATIVE {SPA_WINBGADGEOMETRY} CONST SPA_WINBGADGEOMETRY = $00000400  /* Plugin exports geometry for
                                         * border gadgets
                                         */
NATIVE {SPA_GADGETGEOMETRY}  CONST SPA_GADGETGEOMETRY  = $00000800  /* Plugin exports geometry for
                                         * normal gadgets
                                         */


/***********************************/
/*** The geometry hook interface ***/
/***********************************/

/* The different types of messages that a geometry hook can see */

NATIVE {SG_IMAGEBOX}  CONST SG_IMAGEBOX  = 901  /* Compute box for this (sysiclass) image */
NATIVE {SG_GADGETBOX} CONST SG_GADGETBOX = 902  /* Compute box for this gadget            */

/* Possible return values from a geometry hook */

NATIVE {GCB_OK}      CONST GCB_OK      = 0  /* Hook understands this message type    */
NATIVE {GCB_UNKNOWN} CONST GCB_UNKNOWN = 1  /* Hook does not understand this message */

/* Structure of SG_ messages for geometry hooks: object is a      */
/* struct Image * or a struct Gadget * according to message type. */
/* The hook must calculate position and size for the specified    */
/* object and store them into the appropriate IBox structures in  */
/* the message body. Do NOT change the object directly!           */
/* For images, igm_ImageBox represents the extent of the whole    */
/* image while igm_RenderBox is the area where actual rendering   */
/* will occur (useful for inner button imagery, for instance).    */
/* For gadgets, ggm_HitBox and ggm_BoundingBox are (as you might  */
/* have guessed) the hit box and the bounding box.                */

NATIVE {ImageGeometryMsg} OBJECT imagegeometrymsg
    {igm_MethodID}	methodid	:ULONG   /* One of the SG_ definitions above  */
    {igm_RastPort}	rastport	:PTR TO rastport   /* Reference RastPort (for the font) */
    {igm_DrawInfo}	drawinfo	:PTR TO drawinfo   /* Context information               */
    {igm_ImageBox}	imagebox	:ibox   /* (Output) Box computed by the hook */
    {igm_RenderBox}	renderbox	:ibox  /* (Output) Box computed by the hook */
    {igm_Reserved}	reserved	:ULONG   /* Reserved for future use           */
    {igm_Flags}	flags	:ULONG      /* More information                  */
ENDOBJECT

/* Values for igm_Flags */

NATIVE {IGF_WBARLEFT}   CONST IGF_WBARLEFT   = $00000001 /* Image for left side of window titlebar  */
NATIVE {IGF_WBARRIGHT}  CONST IGF_WBARRIGHT  = $00000002 /* Image for right side of window titlebar */
NATIVE {IGF_SBARLEFT}   CONST IGF_SBARLEFT   = $00000004 /* Image for left side of screen titlebar  */
NATIVE {IGF_SBARRIGHT}  CONST IGF_SBARRIGHT  = $00000008 /* Image for right side of screen titlebar */
NATIVE {IGF_VERTARROW}  CONST IGF_VERTARROW  = $00000010 /* Image for right window border           */
NATIVE {IGF_HORIZARROW} CONST IGF_HORIZARROW = $00000020 /* Image for bottom window border          */
NATIVE {IGF_BRCORN}     CONST IGF_BRCORN     = $00000040 /* Image for bottom-right window corner    */
NATIVE {IGF_KEEPLEFT}   CONST IGF_KEEPLEFT   = $00001000 /* Use the supplied igm_ImageBox.Left      */
NATIVE {IGF_KEEPTOP}    CONST IGF_KEEPTOP    = $00002000 /* Use the supplied igm_ImageBox.Top       */
NATIVE {IGF_KEEPWIDTH}  CONST IGF_KEEPWIDTH  = $00004000 /* Use the supplied igm_ImageBox.Width     */
NATIVE {IGF_KEEPHEIGHT} CONST IGF_KEEPHEIGHT = $00008000 /* Use the supplied igm_ImageBox.Height    */

NATIVE {GadgetGeometryMsg} OBJECT gadgetgeometrymsg
    {ggm_MethodID}	methodid	:ULONG     /* One of the SG_ definitions above  */
    {ggm_Window}	window	:PTR TO window       /* Reference window (may be NULL)    */
    {ggm_DrawInfo}	drawinfo	:PTR TO drawinfo     /* Context information               */
    {ggm_BoundingBox}	boundingbox	:ibox  /* (Output) Box computed by the hook */
    {ggm_HitBox}	hitbox	:ibox       /* (Output) Box computed by the hook */
    {ggm_IAddress}	iaddress	:APTR     /* Gadget-specific data (see below)  */
    {ggm_Flags}	flags	:ULONG        /* More information                  */
ENDOBJECT

/* Values for ggm_Flags */

NATIVE {GGF_INITIAL}       CONST GGF_INITIAL       = $00000001 /* We are at OpenWindow() time */
NATIVE {GGF_CALCHSCROLLER} CONST GGF_CALCHSCROLLER = $00000002 /* Compute scroller hit box from
                                      * bounding box
                                      */
NATIVE {GGF_CALCVSCROLLER} CONST GGF_CALCVSCROLLER = $00000004 /* Compute scroller hit box from
                                      * bounding box
                                      */
NATIVE {GGF_CALCHSOVERLAP} CONST GGF_CALCHSOVERLAP = $00000008 /* Compute scroller/button overlap
                                      * (in borders)
                                      */
NATIVE {GGF_CALCVSOVERLAP} CONST GGF_CALCVSOVERLAP = $00000010 /* Compute scroller/button overlap
                                      * (in borders)
                                      */
NATIVE {GGF_BOUNDED}       CONST GGF_BOUNDED       = $00000020 /* Container size is passed in
                                      * ggm_BoundingBox
                                      */

/* Specific data for GTYP_TBARGADGET gadgets (pointed to by ggm_IAddress) */
/*                                                                        */
/* The geometry hook will use this information to determine the correct   */
/* position of the gadget passed as object. Both the gadgets already in   */
/* the window (or screen) and those in the separate list (which always    */
/* contains at least the object itself) contribute to the calculation.    */
/* For this kind of gadgets the geometry hook shouldn't depend on the     */
/* ggm_Window address, since it could be invoked in situations where no   */
/* window information is available and therefore the address is NULL.     */
/* New for V51: if GGF_BOUNDED is set in ggm_Flags, your hook can read a  */
/* "nominal" window size (or screen titlebar size, for GTYP_SCRGADGET     */
/* gadgets) from ggm_BoundingBox. Note that the hook is still expected to */
/* initialize ggm_BoundingBox after having read that initial information! */

NATIVE {TBGadgetData} OBJECT tbgadgetdata
   {DomainGadgetList}	domaingadgetlist	:PTR TO gadget  /* Gadgets already attached to
                                      * window/screen
                                      * Note: this may be NULL
                                      */
   {GadgetGadgetList}	gadgetgadgetlist	:PTR TO gadget  /* The gadget list containing the gadget
                                      * we receive as object
                                      * (this cannot be NULL)
                                      */
ENDOBJECT
