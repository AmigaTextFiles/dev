/* $Id: gui.h,v 1.28 2006/01/13 18:42:39 mtantignone Exp $ */
OPT NATIVE
MODULE 'target/exec/types', 'target/intuition/intuition', 'target/utility/tagitem'
{#include <intuition/gui.h>}
NATIVE {INTUITION_GUI_H} CONST

/********************** GUI element base types ***********************/
/*                                                                   */
/*  Some Intuition rendering functions require specification of the  */
/*  type of GUI element they are going to operate on. The following  */
/*  is a list of the currently known GUI elements, which may grow    */
/*  with future Intuition releases.                                  */
/*                                                                   */
/*  Note: the BT_DRIPEN type can be ORed with a DrawInfo pen index   */
/*  to explicitly indicate a particular base (background) color on   */
/*  which the rendering will occur, not tied to a specific element.  */
/*                                                                   */
/*  Similarly, other base types might in the future accept modifier  */
/*  flags in the low word.                                           */
/*                                                                   */
/*********************************************************************/

NATIVE {BT_BACKGROUND}  CONST BT_BACKGROUND  = $00000000  /* Generic background */
NATIVE {BT_DRIPEN}      CONST BT_DRIPEN      = $00100000  /* A base DrawInfo pen */
NATIVE {BT_WINBORDER}   CONST BT_WINBORDER   = $00200000  /* Window border */
NATIVE {BT_GADGET}      CONST BT_GADGET      = $00300000  /* Generic gadget */
NATIVE {BT_PROPKNOB}    CONST BT_PROPKNOB    = $00400000  /* Proportional gadget knob */
NATIVE {BT_PROPBG}      CONST BT_PROPBG      = $00500000  /* Proportional gadget background */
NATIVE {BT_WINPROPKNOB} CONST BT_WINPROPKNOB = $00600000  /* Prop. gadget knob in window border */
NATIVE {BT_WINPROPBG}   CONST BT_WINPROPBG   = $00700000  /* Prop. gadget backgr. in window border */
NATIVE {BT_MENU}        CONST BT_MENU        = $00800000  /* Menu panel background */
NATIVE {BT_SCREENBAR}   CONST BT_SCREENBAR   = $00900000  /* Screen titlebar */
NATIVE {BT_WINDOWBAR}   CONST BT_WINDOWBAR   = $00A00000  /* Window titlebar */
NATIVE {BT_WINDOWBG}    CONST BT_WINDOWBG    = $00B00000  /* Window background */
NATIVE {BT_REQUESTERBG} CONST BT_REQUESTERBG = $00C00000  /* Requester background */
NATIVE {BT_TABPAGE}     CONST BT_TABPAGE     = $00D00000  /* Tab page background */

NATIVE {BT_FLAGSMASK}   CONST BT_FLAGSMASK   = $000F0000  /* Flags valid for ALL base types */
NATIVE {BT_OFFSETRECT}  CONST BT_OFFSETRECT  = $00010000  /* Left, top contain backfill offsets */
NATIVE {BT_DIRECTSHADE} CONST BT_DIRECTSHADE = $00020000  /* Flag for ShadeRectA(), see autodoc */


/************************** Shading levels ***************************/
/*                                                                   */
/*  Many Intuition GUI elements feature "bright" and "dark" details  */
/*  in order to achieve a pseudo-3D embossed look. The following is  */
/*  a list of the currently supported levels of shading for the 3D   */
/*  GUI elements. Some Intuition rendering functions accept one of   */
/*  these shading levels as a parameter, allowing you to perform     */
/*  custom 3D effects in a way consistent with the Intuition look.   */
/*                                                                   */
/*********************************************************************/

NATIVE {LEVEL_BRIGHT}     CONST LEVEL_BRIGHT     = 0  /* Full-intensity bright details */
NATIVE {LEVEL_HALFBRIGHT} CONST LEVEL_HALFBRIGHT = 1  /* Half-intensity bright details */
NATIVE {LEVEL_NORMAL}     CONST LEVEL_NORMAL     = 2  /* Normal imagery                */
NATIVE {LEVEL_HALFDARK}   CONST LEVEL_HALFDARK   = 3  /* Half-intensity dark details   */
NATIVE {LEVEL_DARK}       CONST LEVEL_DARK       = 4  /* Full-intensity dark details   */


/********************* Contrast levels and flags *********************/
/*                                                                   */
/*  Some Intuition rendering functions require specification of a    */
/*  contrast level, which determines how much any brighter/darker    */
/*  graphic details stand out from the background imagery.           */
/*  The contrast levels are 8-bit values, but they can be ORed with  */
/*  any of the following modifier flags.                             */
/*                                                                   */
/*  Note: the CNTR_CORRECT flag can be used to adapt the contrast    */
/*  of full-intensity bright details according to the actual color   */
/*  they are derived from. This does usually yield better optical    */
/*  results. This flag is ignored for dark details contrast, and it  */
/*  is also ignored if the CNTR_ABSOLUTE flag is specified.          */
/*                                                                   */
/*********************************************************************/

NATIVE {STD_DISABLE_CONTRAST} CONST STD_DISABLE_CONTRAST = ($1000)  /* For disabled imagery */

NATIVE {CNTR_CORRECT}  CONST CNTR_CORRECT  = $0100  /* Correct contrast of bright details */
NATIVE {CNTR_ABSOLUTE} CONST CNTR_ABSOLUTE = $0200  /* Absolute (non-percentage) shading  */


/************************* ShadeRectA() tags *************************/
/*                                                                   */
/*  These are the tags recognized by the ShadeRectA() function.      */
/*                                                                   */
/*********************************************************************/

NATIVE {SRA_Dummy}       CONST SRA_DUMMY       = ($03800000)

NATIVE {SRA_OffsetX}     CONST SRA_OFFSETX     = (SRA_DUMMY + 1)
   /* (WORD) Logical rendering offset on the X axis. */

NATIVE {SRA_OffsetY}     CONST SRA_OFFSETY     = (SRA_DUMMY + 2)
   /* (WORD) Logical rendering offset on the Y axis. */

NATIVE {SRA_DeltaX}      CONST SRA_DELTAX      = (SRA_DUMMY + 3)
   /* (WORD) Delta increment for SRA_OffsetX. */

NATIVE {SRA_DeltaY}      CONST SRA_DELTAY      = (SRA_DUMMY + 4)
   /* (WORD) Delta increment for SRA_OffsetY. */

NATIVE {SRA_Domain}      CONST SRA_DOMAIN      = (SRA_DUMMY + 5)
   /* (struct Rectangle *) Logical rendering container. */

NATIVE {SRA_DirectShade} CONST SRA_DIRECTSHADE = (SRA_DUMMY + 6)
   /* (BOOL) Force on-the-fly shading */

NATIVE {SRA_RefreshBG}   CONST SRA_REFRESHBG   = (SRA_DUMMY + 7)
   /* (BOOL) Redraw background first to avoid overshading */


/**************** DisableTemplate() data types (V51) *****************/
/*                                                                   */
/*  These are the template types accepted by the DisableTemplate()   */
/*  function. The first one is a planar mask, the others are chunky  */
/*  alpha blending maps (arrays).                                    */
/*  Note: if an alpha map has a modulo > 1 (more than one byte per   */
/*  pixel, e.g. ARGB) it MUST be aligned to the first 'alpha' byte!  */
/*                                                                   */
/*********************************************************************/

NATIVE {TT_BITPLANE} CONST TT_BITPLANE = 0  /* Template is a 16-bit-aligned bitplane */
NATIVE {TT_ALPHA8}   CONST TT_ALPHA8   = 1  /* Template is an alpha map (modulo = 1) */
NATIVE {TT_ALPHA16}  CONST TT_ALPHA16  = 2  /* Template is an alpha map (modulo = 2) */
NATIVE {TT_ALPHA24}  CONST TT_ALPHA24  = 3  /* Template is an alpha map (modulo = 3) */
NATIVE {TT_ALPHA32}  CONST TT_ALPHA32  = 4  /* Template is an alpha map (modulo = 4) */


/************************** GUI attributes ***************************/
/*                                                                   */
/*  These attributes are not intended for direct usage by software   */
/*  applications. They should only be used by the system or by       */
/*  system-level components and add-ons like preferences editors,    */
/*  GUI style plugins, rendering hooks, BOOPSI classes and the like. */
/*  Also, other than for the system itself, the attributes listed    */
/*  here should be considered READ-ONLY.                             */
/*                                                                   */
/*  Applications should honor user preferences for their GUI. They   */
/*  can allow users to select and save local GUI preferences for     */
/*  specific screen(s) by using the standard GUI editor provided by  */
/*  the system. In particular, applications should NEVER override    */
/*  GUI settings at global level -- only IPrefs is allowed to do so. */
/*                                                                   */
/*  If you think you have a good reason to access GUI attributes:    */
/*                                                                   */
/*  The applicability flags fields indicate how an attribute can be  */
/*  used with windows, with screens and globally (in this order).    */
/*  GUI attributes can be applied by using SetGUIAttrsA(), and read  */
/*  with GetGUIAttrsA(). For screens and windows, they can also be   */
/*  passed at creation time.                                         */
/*                                                                   */
/*  Note: the window-level attributes can't actually be set at       */
/*  window level yet, but rather just at screen level; this will be  */
/*  changed in a future Intuition release. Check the applicability   */
/*  flags to learn if and when they can be set at window level.      */
/*                                                                   */
/*********************************************************************/

NATIVE {GUIA_Dummy}                CONST GUIA_DUMMY                = (TAG_USER + $4400000)

/********* Window-, screen- and global-level GUI attributes **********/

NATIVE {GUIA_DefaultStyle}         CONST GUIA_DEFAULTSTYLE         = (GUIA_DUMMY + 1)
   /* (APTR) Default style plugin, may be overridden (G/IG/SG). */

NATIVE {GUIA_WindowBorderStyle}    CONST GUIA_WINDOWBORDERSTYLE    = (GUIA_DUMMY + 2)
   /* (APTR) Style plugin to be used to render window borders (G/G/G). */

NATIVE {GUIA_WindowGadgetStyle}    CONST GUIA_WINDOWGADGETSTYLE    = (GUIA_DUMMY + 3)
   /* (APTR) Style plugin to be used to render border gadgets (G/G/G). */

NATIVE {GUIA_SizeGadgetWidth}      CONST GUIA_SIZEGADGETWIDTH      = (GUIA_DUMMY + 4)
   /* (BYTE) Width of window sizing gadget; -1 = automatic (G/IG/SG). */

NATIVE {GUIA_SizeGadgetHeight}     CONST GUIA_SIZEGADGETHEIGHT     = (GUIA_DUMMY + 5)
   /* (BYTE) Height of window sizing gadget; -1 = automatic (G/IG/SG). */

NATIVE {GUIA_ArrowGadgetWidth}     CONST GUIA_ARROWGADGETWIDTH     = (GUIA_DUMMY + 6)
   /* (BYTE) Width of border arrow gadgets; -1 = automatic (G/IG/SG). */

NATIVE {GUIA_ArrowGadgetHeight}    CONST GUIA_ARROWGADGETHEIGHT    = (GUIA_DUMMY + 7)
   /* (BYTE) Height of border arrow gadgets; -1 = automatic (G/IG/SG). */

NATIVE {GUIA_WindowBorderLeft}     CONST GUIA_WINDOWBORDERLEFT     = (GUIA_DUMMY + 8)
   /* (BYTE) Thickness of left window border, without gadgets (G/IG/SG). */

NATIVE {GUIA_WindowBorderTop}      CONST GUIA_WINDOWBORDERTOP      = (GUIA_DUMMY + 9)
   /* (BYTE) Thickness of top window border, without gadgets (G/IG/SG). */

NATIVE {GUIA_WindowBorderRight}    CONST GUIA_WINDOWBORDERRIGHT    = (GUIA_DUMMY + 10)
   /* (BYTE) Thickness of right window border, without gadgets (G/IG/SG). */

NATIVE {GUIA_WindowBorderBottom}   CONST GUIA_WINDOWBORDERBOTTOM   = (GUIA_DUMMY + 11)
   /* (BYTE) Thickness of bottom window border, without gadgets (G/IG/SG). */

NATIVE {GUIA_WindowTitlePosition}  CONST GUIA_WINDOWTITLEPOSITION  = (GUIA_DUMMY + 12)
   /* (UBYTE) Position of titles in window titlebars (G/IG/SG). */

NATIVE {GUIA_WindowBarPadding}     CONST GUIA_WINDOWBARPADDING     = (GUIA_DUMMY + 13)
   /* (UBYTE) Added to the font height to set titlebar height (G/IG/SG). */

NATIVE {GUIA_WindowReserved}       CONST GUIA_WINDOWRESERVED       = (GUIA_DUMMY + 14)
   /* (BOOL) Reserved for now, don't use. */

NATIVE {GUIA_WindowPropKnobHandle} CONST GUIA_WINDOWPROPKNOBHANDLE = (GUIA_DUMMY + 15)
   /* (UWORD) Type of handle for window border scroller knobs (G/ISG/SG). */

NATIVE {GUIA_WindowPropKnobColor}  CONST GUIA_WINDOWPROPKNOBCOLOR  = (GUIA_DUMMY + 16)
   /* (BOOL) Do border scroller knobs use window border color? (G/ISG/SG). */

NATIVE {GUIA_WindowPropBackground} CONST GUIA_WINDOWPROPBACKGROUND = (GUIA_DUMMY + 17)
   /* (UWORD) Type of background for window border scrollers (G/ISG/SG). */

NATIVE {GUIA_PropBackground}       CONST GUIA_PROPBACKGROUND       = (GUIA_DUMMY + 18)
   /* (UWORD) Type of background for proportional gadgets (G/ISG/SG). */

NATIVE {GUIA_WindowPropKnobBackfill} CONST GUIA_WINDOWPROPKNOBBACKFILL = (GUIA_DUMMY + 19)
   /* (struct Hook *) Backfill hook for border scroller knobs (G/ISG/SG). */

NATIVE {GUIA_PropKnobBackfill}     CONST GUIA_PROPKNOBBACKFILL     = (GUIA_DUMMY + 20)
   /* (struct Hook *) Backfill hook for prop gadget knobs (G/ISG/SG). */

NATIVE {GUIA_WindowPropSelKnobBackfill} CONST GUIA_WINDOWPROPSELKNOBBACKFILL = (GUIA_DUMMY + 21)
   /* (struct Hook *) Backfill hook for selected border knobs (G/ISG/SG). */

NATIVE {GUIA_PropSelKnobBackfill}  CONST GUIA_PROPSELKNOBBACKFILL  = (GUIA_DUMMY + 22)
   /* (struct Hook *) Backfill hook for selected prop knobs (G/ISG/SG). */

NATIVE {GUIA_WindowPropInactKnobBackfill} CONST GUIA_WINDOWPROPINACTKNOBBACKFILL = (GUIA_DUMMY + 23)
   /* (struct Hook *) Backfill hook for inactive border knobs (G/ISG/SG). */

NATIVE {GUIA_WindowPropBackfill}   CONST GUIA_WINDOWPROPBACKFILL   = (GUIA_DUMMY + 24)
   /* (struct Hook *) Backfill hook for border scrollers (G/ISG/SG). */

NATIVE {GUIA_WindowPropInactBackfill} CONST GUIA_WINDOWPROPINACTBACKFILL = (GUIA_DUMMY + 25)
   /* (struct Hook *) Backfill hook for inactive border scrollers
      (G/ISG/SG). */

NATIVE {GUIA_PropBackfill}         CONST GUIA_PROPBACKFILL         = (GUIA_DUMMY + 26)
   /* (struct Hook *) Backfill hook for proportional gadgets (G/ISG/SG). */

NATIVE {GUIA_SysImageFrameType}    CONST GUIA_SYSIMAGEFRAMETYPE    = (GUIA_DUMMY + 27)
   /* (UWORD) Type of frame for screen and window system gadgets (G/IG/SG). */

NATIVE {GUIA_WindowPropBorder}     CONST GUIA_WINDOWPROPBORDER     = (GUIA_DUMMY + 28)
   /* (BOOL) Do window border scrollers have a double border? (G/ISG/SG). */

NATIVE {GUIA_PropBorder}           CONST GUIA_PROPBORDER           = (GUIA_DUMMY + 29)
   /* (BOOL) Do GT/RA scrollers have a double border? (G/ISG/SG). */

NATIVE {GUIA_WindowPropSpacing}    CONST GUIA_WINDOWPROPSPACING    = (GUIA_DUMMY + 30)
   /* (UBYTE) Thickness of window scrollers borders (G/ISG/SG). */

NATIVE {GUIA_PropSpacing}          CONST GUIA_PROPSPACING          = (GUIA_DUMMY + 31)
   /* (UBYTE) Thickness of GT/RA scrollers borders (G/ISG/SG). */

NATIVE {GUIA_PropKnobHandle}       CONST GUIA_PROPKNOBHANDLE       = (GUIA_DUMMY + 32)
   /* (UWORD) Type of handle for scroller knobs (G/ISG/SG). */

NATIVE {GUIA_PropKnobColor}        CONST GUIA_PROPKNOBCOLOR        = (GUIA_DUMMY + 33)
   /* (BOOL) Do scroller knobs use FILLPEN as their color? (G/ISG/SG). */

NATIVE {GUIA_WindowSizeBorder}     CONST GUIA_WINDOWSIZEBORDER     = (GUIA_DUMMY + 34)
   /* (UWORD) Preferred border(s) to place the sizing gadget in (G/IG/SG). */

NATIVE {GUIA_WindowGadgetFrameStyle} CONST GUIA_WINDOWGADGETFRAMESTYLE = (GUIA_DUMMY + 35)
   /* (APTR) Style plugin to be used to render border gadget frames (G/G/G). */

NATIVE {GUIA_GadgetStyle}          CONST GUIA_GADGETSTYLE          = (GUIA_DUMMY + 36)
   /* (APTR) Style plugin to be used to render GT/RA gadgets (G/G/G). */

NATIVE {GUIA_DefaultGeometry}      CONST GUIA_DEFAULTGEOMETRY      = (GUIA_DUMMY + 37)
   /* (APTR) Style plugin defining geometry of GUI elements (G/IG/SG). */

NATIVE {GUIA_WindowGadgetGeometry} CONST GUIA_WINDOWGADGETGEOMETRY = (GUIA_DUMMY + 38)
   /* (APTR) Style plugin defining geometry of border gadgets (G/G/G). */

NATIVE {GUIA_GadgetGeometry}       CONST GUIA_GADGETGEOMETRY       = (GUIA_DUMMY + 39)
   /* (APTR) Style plugin defining geometry of GT/RA gadgets (G/G/G). */

NATIVE {GUIA_ScreenBarGadgetSize}  CONST GUIA_SCREENBARGADGETSIZE  = (GUIA_DUMMY + 40)
   /* (APTR) Size of gadgets in the screen titlebar (G/IG/SG). */

NATIVE {GUIA_WindowBarGadgetSize}  CONST GUIA_WINDOWBARGADGETSIZE  = (GUIA_DUMMY + 41)
   /* (APTR) Size of gadgets in the window titlebar (G/ISG/SG). */

NATIVE {GUIA_GadgetArrowType}      CONST GUIA_GADGETARROWTYPE      = (GUIA_DUMMY + 42)
   /* (ULONG) Type of arrow symbols to be used in arrow buttons (G/IG/SG). */

NATIVE {GUIA_GadgetCycleType}      CONST GUIA_GADGETCYCLETYPE      = (GUIA_DUMMY + 43)
   /* (ULONG) Type of cycle symbol to be used in cycle gadgets (G/IG/SG). */

NATIVE {GUIA_GadgetArrowStyle}     CONST GUIA_GADGETARROWSTYLE     = (GUIA_DUMMY + 44)
   /* (APTR) Style plugin to be used to render GT/RA arrow buttons (G/G/G). */

NATIVE {GUIA_GadgetCycleStyle}     CONST GUIA_GADGETCYCLESTYLE     = (GUIA_DUMMY + 45)
   /* (APTR) Style plugin to be used to render GT/RA cycle gadgets (G/G/G). */

NATIVE {GUIA_SysImageSymbolType}   CONST GUIA_SYSIMAGESYMBOLTYPE   = (GUIA_DUMMY + 46)
   /* (UWORD) Type of symbols for screen and window system gadgets
      (G/IG/SG). */

NATIVE {GUIA_SysIGeometryType}     CONST GUIA_SYSIGEOMETRYTYPE     = (GUIA_DUMMY + 47)
   /* (UWORD) Type of geometry for screen and window system gadgets
      (G/IG/SG). */

NATIVE {GUIA_WindowBarBackfill}    CONST GUIA_WINDOWBARBACKFILL    = (GUIA_DUMMY + 48)
   /* (struct Hook *) Backfill hook for active window titlebars (G/ISG/SG). */

NATIVE {GUIA_WindowBarInactBackfill} CONST GUIA_WINDOWBARINACTBACKFILL = (GUIA_DUMMY + 49)
   /* (struct Hook *) Backfill hook for inactive window titlebars
      (G/ISG/SG). */

NATIVE {GUIA_WindowBorderBackfill} CONST GUIA_WINDOWBORDERBACKFILL = (GUIA_DUMMY + 50)
   /* (struct Hook *) Backfill hook for active window borders (G/ISG/SG). */

NATIVE {GUIA_WindowBorderInactBackfill} CONST GUIA_WINDOWBORDERINACTBACKFILL = (GUIA_DUMMY + 51)
   /* (struct Hook *) Backfill hook for inactive window borders (G/ISG/SG). */

NATIVE {GUIA_WindowPropLook}       CONST GUIA_WINDOWPROPLOOK       = (GUIA_DUMMY + 52)
   /* (BOOL) Use the GUIA_FramePropLook also for border scrollers?
      (G/ISG/SG). */

NATIVE {GUIA_EvenRequesterButtons} CONST GUIA_EVENREQUESTERBUTTONS = (GUIA_DUMMY + 53)
   /* (BOOL) Make all buttons of system requesters equally wide? (G/ISG/SG). */

NATIVE {GUIA_RequestersPosition}   CONST GUIA_REQUESTERSPOSITION   = (GUIA_DUMMY + 54)
   /* (UWORD) Opening position of system requesters (G/ISG/SG). */

NATIVE {GUIA_WindowBorderLook}     CONST GUIA_WINDOWBORDERLOOK     = (GUIA_DUMMY + 55)
   /* (UWORD) Type of window border (3D, framed, flat...) (G/ISG/SG). */

NATIVE {GUIA_Reserved1}            CONST GUIA_RESERVED1            = (GUIA_DUMMY + 56)
NATIVE {GUIA_Reserved2}            CONST GUIA_RESERVED2            = (GUIA_DUMMY + 57)
NATIVE {GUIA_Reserved3}            CONST GUIA_RESERVED3            = (GUIA_DUMMY + 58)
   /* (APTR) System reserved attributes, don't use. */

NATIVE {GUIA_WindowBarFrameThickness} CONST GUIA_WINDOWBARFRAMETHICKNESS = (GUIA_DUMMY + 59)
   /* (UWORD) Thickness of 3D edges of window titlebar frames (1 or 2)
      (G/ISG/SG). */

NATIVE {GUIA_WindowFrameThickness} CONST GUIA_WINDOWFRAMETHICKNESS = (GUIA_DUMMY + 60)
   /* (UWORD) Thickness of 3D edges of window frames (1 or 2) (G/ISG/SG). */

NATIVE {GUIA_PropOuterSpacing}     CONST GUIA_PROPOUTERSPACING     = (GUIA_DUMMY + 61)
   /* (UWORD) Make scrollers detached from lists and/or buttons? (G/ISG/SG). */

NATIVE {GUIA_SliderDisplayMode}    CONST GUIA_SLIDERDISPLAYMODE    = (GUIA_DUMMY + 62)
   /* (UWORD) Preferred position of slider level display (G/ISG/SG). */

NATIVE {GUIA_CycleLabelJustify}    CONST GUIA_CYCLELABELJUSTIFY    = (GUIA_DUMMY + 63)
   /* (UWORD) Justification of cycle/chooser labels (G/ISG/SG). */

NATIVE {GUIA_ClickTabLook}         CONST GUIA_CLICKTABLOOK         = (GUIA_DUMMY + 64)
   /* (ULONG) Various flags affecting the look of clicktabs (G/ISG/SG). */

NATIVE {GUIA_GadgetHorizPadding}   CONST GUIA_GADGETHORIZPADDING   = (GUIA_DUMMY + 65)
NATIVE {GUIA_GadgetVertPadding}    CONST GUIA_GADGETVERTPADDING    = (GUIA_DUMMY + 66)
   /* (UWORD) Horizontal and vertical padding for ReAction gadgets
      (G/ISG/SG). */

NATIVE {GUIA_WindowBackfill}       CONST GUIA_WINDOWBACKFILL       = (GUIA_DUMMY + 67)
   /* (struct Hook *) Backfill hook for window background (G/ISG/SG). */

NATIVE {GUIA_RequesterBackfill}    CONST GUIA_REQUESTERBACKFILL    = (GUIA_DUMMY + 68)
   /* (struct Hook *) Backfill hook for requester background (G/ISG/SG). */

NATIVE {GUIA_TabTitleBackfill}     CONST GUIA_TABTITLEBACKFILL     = (GUIA_DUMMY + 69)
   /* (struct Hook *) Backfill hook for active tab header (G/ISG/SG). */

NATIVE {GUIA_TabActiveBackfill}    CONST GUIA_TABACTIVEBACKFILL    = (GUIA_DUMMY + 70)
   /* (struct Hook *) Backfill hook for active tab page (G/ISG/SG). */

NATIVE {GUIA_TabInactiveBackfill}  CONST GUIA_TABINACTIVEBACKFILL  = (GUIA_DUMMY + 71)
   /* (struct Hook *) Backfill hook for inactive tabs (G/ISG/SG). */

NATIVE {GUIA_LayoutHorizSpacing}   CONST GUIA_LAYOUTHORIZSPACING   = (GUIA_DUMMY + 72)
NATIVE {GUIA_LayoutVertSpacing}    CONST GUIA_LAYOUTVERTSPACING    = (GUIA_DUMMY + 73)
   /* (UWORD) Horizontal and vertical spacing in ReAction layouts
      (G/ISG/SG). */

NATIVE {GUIA_GroupLabelPlace}      CONST GUIA_GROUPLABELPLACE      = (GUIA_DUMMY + 74)
   /* (ULONG) Position of group labels (left/center/right) (G/ISG/SG). */

NATIVE {GUIA_GroupLabelLook}       CONST GUIA_GROUPLABELLOOK       = (GUIA_DUMMY + 75)
   /* (ULONG) Appearance of group labels (plain, 3D, bold...) (G/ISG/SG). */

NATIVE {GUIA_GroupLabelTextAttr}   CONST GUIA_GROUPLABELTEXTATTR   = (GUIA_DUMMY + 76)
   /* (struct TextAttr *) Font specification for group labels (G/ISG/SG). */

NATIVE {GUIA_FallbackTextAttr}     CONST GUIA_FALLBACKTEXTATTR     = (GUIA_DUMMY + 77)
   /* (struct TextAttr *) Font specification for fallback layout (G/ISG/SG). */

NATIVE {GUIA_GadgetTextAttr}       CONST GUIA_GADGETTEXTATTR       = (GUIA_DUMMY + 78)
   /* (struct TextAttr *) Font specification for RA gadgets (G/ISG/SG). */

NATIVE {GUIA_LabelTextAttr}        CONST GUIA_LABELTEXTATTR        = (GUIA_DUMMY + 79)
   /* (struct TextAttr *) Font specification for RA labels (G/ISG/SG). */

NATIVE {GUIA_WindowRefresh}        CONST GUIA_WINDOWREFRESH        = (GUIA_DUMMY + 80)
   /* (ULONG) Preferred window refresh type (1 = simple, 0 = smart)
      (G/ISG/SG). */

NATIVE {GUIA_GroupLabelVertAlign}  CONST GUIA_GROUPLABELVERTALIGN  = (GUIA_DUMMY + 81)
   /* (ULONG) Vertical alignment of group labels (center, baseline...)
      (G/ISG/SG). */

NATIVE {GUIA_ListHierNodeStyle}    CONST GUIA_LISTHIERNODESTYLE    = (GUIA_DUMMY + 82)
   /* (UWORD) Style of hierarchical list nodes (+/- boxes, arrows)
      (G/ISG/SG). */

NATIVE {GUIA_ListHierConnectType}  CONST GUIA_LISTHIERCONNECTTYPE  = (GUIA_DUMMY + 83)
   /* (UWORD) How to connect hierarchical list nodes (lines, nothing)
      (G/ISG/SG). */

NATIVE {GUIA_Reserved4}            CONST GUIA_RESERVED4            = (GUIA_DUMMY + 84)
   /* (APTR) System reserved attribute, don't use. */

NATIVE {GUIA_WindowOuterFlatThickness} CONST GUIA_WINDOWOUTERFLATTHICKNESS = (GUIA_DUMMY + 85)
   /* (UWORD) Thickness of outer flat borders for framed/flat window look
      (1 or 2) (G/ISG/SG). */

NATIVE {GUIA_WindowInnerFlatThickness} CONST GUIA_WINDOWINNERFLATTHICKNESS = (GUIA_DUMMY + 86)
   /* (UWORD) Thickness of inner flat borders for framed/flat window look
      (1 or 2) (G/ISG/SG). */

NATIVE {GUIA_CycleLook}            CONST GUIA_CYCLELOOK            = (GUIA_DUMMY + 87)
   /* (ULONG) Various flags affecting the look of cycle/chooser gadgets
      (G/ISG/SG). */

NATIVE {GUIA_WindowGaugeLook}      CONST GUIA_WINDOWGAUGELOOK      = (GUIA_DUMMY + 88)
   /* (ULONG) Various flags affecting the look of window fill gauge gadgets
      (G/ISG/SG). */

NATIVE {GUIA_GaugeLook}            CONST GUIA_GAUGELOOK            = (GUIA_DUMMY + 89)
   /* (ULONG) Various flags affecting the look of fill gauge gadgets
      (G/ISG/SG). */

NATIVE {GUIA_ClearBackground}      CONST GUIA_CLEARBACKGROUND      = (GUIA_DUMMY + 90)
   /* (BOOL) Always erase background before redrawing GUI elements?
      (G/ISG/SG). */

NATIVE {GUIA_Reserved5}            CONST GUIA_RESERVED5            = (GUIA_DUMMY + 91)
   /* (APTR) System reserved attribute, don't use. */

/************** Screen- and global-level GUI attributes **************/

NATIVE {GUIA_ScreenTitlePosition}  CONST GUIA_SCREENTITLEPOSITION  = (GUIA_DUMMY + 1001)
   /* (UBYTE) Position of titles in screen titlebars (G/IG/SG). */

NATIVE {GUIA_ScreenBarPadding}     CONST GUIA_SCREENBARPADDING     = (GUIA_DUMMY + 1002)
   /* (UBYTE) Added to the font height to set titlebar height (G/IG/SG). */

NATIVE {GUIA_MenuType}             CONST GUIA_MENUTYPE             = (GUIA_DUMMY + 1003)
   /* (UWORD) Type of menu: MT_PULLDOWN, MT_POPUP or MT_RELATIVE (G/ISG/SG). */

NATIVE {GUIA_MenuFlags}            CONST GUIA_MENUFLAGS            = (GUIA_DUMMY + 1004)
   /* (ULONG) Menu flags (see definitions below) (G/ISG/SG). */

NATIVE {GUIA_MenuDropShadows}      CONST GUIA_MENUDROPSHADOWS      = (GUIA_DUMMY + 1005)
   /* (BOOL) Do menus cast drop shadows? (G/ISG/SG). */

NATIVE {GUIA_MenuTransparency}     CONST GUIA_MENUTRANSPARENCY     = (GUIA_DUMMY + 1006)
   /* (BOOL) Do menus have transparency? (G/ISG/SG). */

NATIVE {GUIA_MenuRenderHook}       CONST GUIA_MENURENDERHOOK       = (GUIA_DUMMY + 1007)
   /* (struct Hook *) Rendering hook for menus (G/ISG/SG). */

NATIVE {GUIA_MenuBackfill}         CONST GUIA_MENUBACKFILL         = (GUIA_DUMMY + 1008)
   /* (struct Hook *) Backfill hook for menus (G/ISG/SG). */

NATIVE {GUIA_MenuStyle}            CONST GUIA_MENUSTYLE            = (GUIA_DUMMY + 1009)
   /* (APTR) Style plugin to import menu rendering hook from (G/ISG/SG). */

NATIVE {GUIA_BrightContrast}       CONST GUIA_BRIGHTCONTRAST       = (GUIA_DUMMY + 1010)
NATIVE {GUIA_DarkContrast}         CONST GUIA_DARKCONTRAST         = (GUIA_DUMMY + 1011)
   /* (UBYTE) Default contrast for edges brightening/darkening (G/IG/SG). */

NATIVE {GUIA_FillBrightContrast}   CONST GUIA_FILLBRIGHTCONTRAST   = (GUIA_DUMMY + 1012)
NATIVE {GUIA_FillDarkContrast}     CONST GUIA_FILLDARKCONTRAST     = (GUIA_DUMMY + 1013)
   /* (UBYTE) Contrast of FILLSHINEPEN/FILLSHADOWPEN (G/IG/SG). */

NATIVE {GUIA_InactiveFillBrightContrast} CONST GUIA_INACTIVEFILLBRIGHTCONTRAST = (GUIA_DUMMY + 1014)
NATIVE {GUIA_InactiveFillDarkContrast}   CONST GUIA_INACTIVEFILLDARKCONTRAST   = (GUIA_DUMMY + 1015)
   /* (UBYTE) Contrast of INACTIVEFILLSHINEPEN/INACTIVEFILLSHADOWPEN
      (G/IG/SG). */

NATIVE {GUIA_MenuBrightContrast}   CONST GUIA_MENUBRIGHTCONTRAST   = (GUIA_DUMMY + 1016)
NATIVE {GUIA_MenuDarkContrast}     CONST GUIA_MENUDARKCONTRAST     = (GUIA_DUMMY + 1017)
   /* (UBYTE) Contrast of MENUSHINEPEN/MENUSHADOWPEN (G/IG/SG). */

NATIVE {GUIA_SelectBrightContrast} CONST GUIA_SELECTBRIGHTCONTRAST = (GUIA_DUMMY + 1018)
NATIVE {GUIA_SelectDarkContrast}   CONST GUIA_SELECTDARKCONTRAST   = (GUIA_DUMMY + 1019)
   /* (UBYTE) Contrast of SELECTSHINEPEN/SELECTSHADOWPEN (G/IG/SG). */

NATIVE {GUIA_BarBlockBrightContrast} CONST GUIA_BARBLOCKBRIGHTCONTRAST = (GUIA_DUMMY + 1020)
NATIVE {GUIA_BarBlockDarkContrast}   CONST GUIA_BARBLOCKDARKCONTRAST   = (GUIA_DUMMY + 1021)
   /* (UBYTE) Contrast of BARCONTOURPEN/BARTRIMPEN (G/IG/SG). */

NATIVE {GUIA_DisabledBrightContrast} CONST GUIA_DISABLEDBRIGHTCONTRAST = (GUIA_DUMMY + 1022)
NATIVE {GUIA_DisabledDarkContrast}   CONST GUIA_DISABLEDDARKCONTRAST   = (GUIA_DUMMY + 1023)
   /* (UBYTE) Contrast of DISABLEDSHINEPEN/DISABLEDSHADOWPEN (G/IG/SG). */

NATIVE {GUIA_ForeBrightContrast}     CONST GUIA_FOREBRIGHTCONTRAST     = (GUIA_DUMMY + 1024)
NATIVE {GUIA_ForeDarkContrast}       CONST GUIA_FOREDARKCONTRAST       = (GUIA_DUMMY + 1025)
   /* (UBYTE) Contrast of FORESHINEPEN/FORESHADOWPEN (G/IG/SG). */

NATIVE {GUIA_AutomaticEdgesContrast} CONST GUIA_AUTOMATICEDGESCONTRAST = (GUIA_DUMMY + 1026)
   /* (BOOL) Enable/disable automatic computation of shine/shadow pens
      (G/IG/SG). */

NATIVE {GUIA_BrightCurve}          CONST GUIA_BRIGHTCURVE          = (GUIA_DUMMY + 1028)
NATIVE {GUIA_DarkCurve}            CONST GUIA_DARKCURVE            = (GUIA_DUMMY + 1029)
   /* (UBYTE) Default curve for shine/shadow colors gradients (G/IG/SG). */

NATIVE {GUIA_FillBrightCurve}      CONST GUIA_FILLBRIGHTCURVE      = (GUIA_DUMMY + 1030)
NATIVE {GUIA_FillDarkCurve}        CONST GUIA_FILLDARKCURVE        = (GUIA_DUMMY + 1031)
   /* (UBYTE) Curve for FILLSHINEPEN/FILLSHADOWPEN gradients (G/IG/SG). */

NATIVE {GUIA_InactiveFillBrightCurve} CONST GUIA_INACTIVEFILLBRIGHTCURVE = (GUIA_DUMMY + 1032)
NATIVE {GUIA_InactiveFillDarkCurve}   CONST GUIA_INACTIVEFILLDARKCURVE   = (GUIA_DUMMY + 1033)
   /* (UBYTE) Curve for INACTIVEFILLSHINEPEN/INACTIVEFILLSHADOWPEN gradients
      (G/IG/SG). */

NATIVE {GUIA_MenuBrightCurve}      CONST GUIA_MENUBRIGHTCURVE      = (GUIA_DUMMY + 1034)
NATIVE {GUIA_MenuDarkCurve}        CONST GUIA_MENUDARKCURVE        = (GUIA_DUMMY + 1035)
   /* (UBYTE) Curve for MENUSHINEPEN/MENUSHADOWPEN gradients (G/IG/SG). */

NATIVE {GUIA_SelectBrightCurve}    CONST GUIA_SELECTBRIGHTCURVE    = (GUIA_DUMMY + 1036)
NATIVE {GUIA_SelectDarkCurve}      CONST GUIA_SELECTDARKCURVE      = (GUIA_DUMMY + 1037)
   /* (UBYTE) Curve for SELECTSHINEPEN/SELECTSHADOWPEN gradients (G/IG/SG). */

NATIVE {GUIA_BarBlockBrightCurve}  CONST GUIA_BARBLOCKBRIGHTCURVE  = (GUIA_DUMMY + 1038)
NATIVE {GUIA_BarBlockDarkCurve}    CONST GUIA_BARBLOCKDARKCURVE    = (GUIA_DUMMY + 1039)
   /* (UBYTE) Curve for BARCONTOURPEN/BARTRIMPEN gradients (G/IG/SG). */

NATIVE {GUIA_DisabledBrightCurve}  CONST GUIA_DISABLEDBRIGHTCURVE  = (GUIA_DUMMY + 1040)
NATIVE {GUIA_DisabledDarkCurve}    CONST GUIA_DISABLEDDARKCURVE    = (GUIA_DUMMY + 1041)
   /* (UBYTE) Curve for DISABLEDSHINEPEN/DISABLEDSHADOWPEN gradients
      (G/IG/SG). */

NATIVE {GUIA_ForeBrightCurve}      CONST GUIA_FOREBRIGHTCURVE      = (GUIA_DUMMY + 1042)
NATIVE {GUIA_ForeDarkCurve}        CONST GUIA_FOREDARKCURVE        = (GUIA_DUMMY + 1043)
   /* (UBYTE) Curve for FORESHINEPEN/FORESHADOWPEN gradients (G/IG/SG). */

NATIVE {GUIA_PropKnobHighlight}    CONST GUIA_PROPKNOBHIGHLIGHT    = (GUIA_DUMMY + 1044)
   /* (UBYTE) Selected knob look: 0 = raised, 1 = recessed (G/ISG/SG). */

NATIVE {GUIA_PaletteRGBTable}      CONST GUIA_PALETTERGBTABLE      = (GUIA_DUMMY + 1045)
   /* (ULONG *) Initial 256-color palette for the screens (G/IG/SG). */

NATIVE {GUIA_PaletteLockTable}     CONST GUIA_PALETTELOCKTABLE     = (GUIA_DUMMY + 1046)
   /* (UBYTE *) Array of locking information for each palette entry
      (G/IG/SG). */

NATIVE {GUIA_DRIPens}              CONST GUIA_DRIPENS              = (GUIA_DUMMY + 1047)
   /* (UWORD *) Array of DrawInfo pens for the screen (G/IG/SG). */

NATIVE {GUIA_FrameForceThinEdges}  CONST GUIA_FRAMEFORCETHINEDGES  = (GUIA_DUMMY + 1048)
   /* (UBYTE) Flag mask, see definitions below (G/ISG/SG). */

NATIVE {GUIA_FrameSelectedColor}   CONST GUIA_FRAMESELECTEDCOLOR   = (GUIA_DUMMY + 1049)
   /* (UBYTE) Fill pen for selected buttons, see values below (G/ISG/SG). */

NATIVE {GUIA_FrameDisabledColors}  CONST GUIA_FRAMEDISABLEDCOLORS  = (GUIA_DUMMY + 1050)
   /* (UBYTE) Pens for disabled frame edges, see values below (G/ISG/SG). */

NATIVE {GUIA_FrameButtonLook}      CONST GUIA_FRAMEBUTTONLOOK      = (GUIA_DUMMY + 1051)
   /* (UBYTE) Look of button frames, see values below (G/ISG/SG). */

NATIVE {GUIA_FramePressedLook}     CONST GUIA_FRAMEPRESSEDLOOK     = (GUIA_DUMMY + 1052)
   /* (UBYTE) Look of pressed (selected) buttons, see values below
      (G/ISG/SG). */

NATIVE {GUIA_FrameCornersType}     CONST GUIA_FRAMECORNERSTYPE     = (GUIA_DUMMY + 1053)
   /* (UBYTE) Type of frame corners (0 = square, 1 = rounded) (G/ISG/SG). */

NATIVE {GUIA_FrameBackfill}        CONST GUIA_FRAMEBACKFILL        = (GUIA_DUMMY + 1054)
   /* (struct Hook *) Backfill hook for unselected frames (G/ISG/SG). */

NATIVE {GUIA_FrameSelBackfill}     CONST GUIA_FRAMESELBACKFILL     = (GUIA_DUMMY + 1055)
   /* (struct Hook *) Backfill hook for selected frames (G/ISG/SG). */

NATIVE {GUIA_FrameStringLook}      CONST GUIA_FRAMESTRINGLOOK      = (GUIA_DUMMY + 1056)
   /* (UBYTE) Look of string gadget frames, see values below (G/ISG/SG). */

NATIVE {GUIA_FramePropLook}        CONST GUIA_FRAMEPROPLOOK        = (GUIA_DUMMY + 1057)
   /* (UBYTE) Look of prop gadget frames, see values below (G/ISG/SG). */

NATIVE {GUIA_FrameDisplayLook}     CONST GUIA_FRAMEDISPLAYLOOK     = (GUIA_DUMMY + 1058)
   /* (UBYTE) Look of display gadget frames, see values below (G/ISG/SG). */

NATIVE {GUIA_WindowPropKnobHighlight} CONST GUIA_WINDOWPROPKNOBHIGHLIGHT = (GUIA_DUMMY + 1059)
   /* (UBYTE) Selected window knob look: 0 = raised, 1 = recessed
      (G/ISG/SG). */

NATIVE {GUIA_OffScreenDragging}    CONST GUIA_OFFSCREENDRAGGING    = (GUIA_DUMMY + 1060)
   /* (BOOL) Is off-screen window dragging allowed on this screen?
      (G/ISG/SG). */

NATIVE {GUIA_FrameDisBackfill}     CONST GUIA_FRAMEDISBACKFILL     = (GUIA_DUMMY + 1061)
   /* (struct Hook *) Backfill hook for disabled frames (G/ISG/SG). */

NATIVE {GUIA_RealShading}          CONST GUIA_REALSHADING          = (GUIA_DUMMY + 1062)
   /* (BOOL) Realistic bitmap shading on hicolor/truecolor screens?
      (G/ISG/SG). */

NATIVE {GUIA_ScreenBarBackfill}    CONST GUIA_SCREENBARBACKFILL    = (GUIA_DUMMY + 1063)
   /* (struct Hook *) Backfill hook for screen titlebars (G/ISG/SG). */

NATIVE {GUIA_MenuSelItemFrame}     CONST GUIA_MENUSELITEMFRAME     = (GUIA_DUMMY + 1064)
   /* (UBYTE) Type of frame for selected menu items (G/ISG/SG). */

NATIVE {GUIA_OffScreenSizing}      CONST GUIA_OFFSCREENSIZING      = (GUIA_DUMMY + 1065)
   /* (BOOL) Is off-screen window sizing allowed on this screen? (G/ISG/SG). */

NATIVE {GUIA_OffScreenResistance}  CONST GUIA_OFFSCREENRESISTANCE  = (GUIA_DUMMY + 1066)
   /* (UWORD) Amount of resistance screen edges offer to window crossing
      them (G/ISG/SG). */

NATIVE {GUIA_MenuTransparencyLevel} CONST GUIA_MENUTRANSPARENCYLEVEL = (GUIA_DUMMY + 1067)
   /* (UBYTE) Level of menu transparency (if transparency is turned on)
      (G/ISG/SG). */

/*********************** Global GUI attributes ***********************/

NATIVE {GUIA_GlobalFlags}          CONST GUIA_GLOBALFLAGS          = (GUIA_DUMMY + 5001)
   /* (ULONG) Global GUI flags (see definitions below) (G/G/SG). */

NATIVE {GUIA_ScreenDragging}       CONST GUIA_SCREENDRAGGING       = (GUIA_DUMMY + 5002)
   /* (BOOL) Enable/disable screen dragging (defaults to TRUE) (G/G/SG). */

NATIVE {GUIA_DefaultDRIPens}       CONST GUIA_DEFAULTDRIPENS       = (GUIA_DUMMY + 5003)
   /* (UWORD *) Default four-color DrawInfo pen array (G/G/G). */


/* Global GUI flags */

NATIVE {GGPF_SCREENDRAGGING} CONST GGPF_SCREENDRAGGING = $00000001  /* Enable screen dragging */

/* Values for GUIA_WindowBorderLook */

NATIVE {FRAMEWINDOW_3D}     CONST FRAMEWINDOW_3D     = 0  /* Standard 3D bevelled frame */
NATIVE {FRAMEWINDOW_FRAMED} CONST FRAMEWINDOW_FRAMED = 1  /* Dark frame with 3D inner frame */
NATIVE {FRAMEWINDOW_FLAT}   CONST FRAMEWINDOW_FLAT   = 2  /* Thin or thick dark frame */

/* Flags for GUIA_FrameForceThinEdges */

NATIVE {FRAMETHIN_FILLEDRAISED}      CONST FRAMETHIN_FILLEDRAISED      = $01
NATIVE {FRAMETHIN_FILLEDRECESSED}    CONST FRAMETHIN_FILLEDRECESSED    = $02
NATIVE {FRAMETHIN_EDGESONLYRAISED}   CONST FRAMETHIN_EDGESONLYRAISED   = $04
NATIVE {FRAMETHIN_EDGESONLYRECESSED} CONST FRAMETHIN_EDGESONLYRECESSED = $08

/* Values for GUIA_FrameSelectedColor */

NATIVE {FRAMESELCOL_FILL}   CONST FRAMESELCOL_FILL   = 0  /* Fill pen */
NATIVE {FRAMESELCOL_SELECT} CONST FRAMESELCOL_SELECT = 1  /* Select pen */
NATIVE {FRAMESELCOL_FOREG}  CONST FRAMESELCOL_FOREG  = 2  /* Foreground pen */
NATIVE {FRAMESELCOL_BACKG}  CONST FRAMESELCOL_BACKG  = 3  /* Background pen */

/* Values for GUIA_FrameDisabledColors */

NATIVE {FRAMEDISCOL_FOREG} CONST FRAMEDISCOL_FOREG = 0  /* Foreground shine/shadow pens */
NATIVE {FRAMEDISCOL_BACKG} CONST FRAMEDISCOL_BACKG = 1  /* Background shine/shadow pens */
NATIVE {FRAMEDISCOL_DISAB} CONST FRAMEDISCOL_DISAB = 2  /* Disabled shine/shadow pens */

/* Values for GUIA_FrameButtonLook */

NATIVE {FRAMEBUTTON_3D}     CONST FRAMEBUTTON_3D     = 0  /* Standard 3D bevelled frame */
NATIVE {FRAMEBUTTON_FRAMED} CONST FRAMEBUTTON_FRAMED = 1  /* Dark frame with 3D inner frame */
NATIVE {FRAMEBUTTON_FLAT}   CONST FRAMEBUTTON_FLAT   = 2  /* Thin or thick dark frame */

/* Values for GUIA_FrameStringLook */

NATIVE {FRAMESTRING_3D}      CONST FRAMESTRING_3D      = 0  /* Standard 3D ridge */
NATIVE {FRAMESTRING_FRAMED}  CONST FRAMESTRING_FRAMED  = 1  /* Dark frame with inner recessed frame */
NATIVE {FRAMESTRING_FLAT}    CONST FRAMESTRING_FLAT    = 2  /* Thin or thick dark frame */
NATIVE {FRAMESTRING_FRAMED2} CONST FRAMESTRING_FRAMED2 = 3  /* Recessed frame with inner dark frame */

/* Values for GUIA_FramePropLook */

NATIVE {FRAMEPROP_3D}     CONST FRAMEPROP_3D     = 0  /* Standard 3D bevelled frame */
NATIVE {FRAMEPROP_FRAMED} CONST FRAMEPROP_FRAMED = 1  /* Dark frame */
NATIVE {FRAMEPROP_FLAT}   CONST FRAMEPROP_FLAT   = 2  /* Thin or thick dark frame */
NATIVE {FRAMEPROP_NONE}   CONST FRAMEPROP_NONE   = 3  /* No frame (only applies to container) */

/* Values for GUIA_FrameDisplayLook */

NATIVE {FRAMEDISPLAY_3D}      CONST FRAMEDISPLAY_3D      = 0  /* Standard 3D recessed frame */
NATIVE {FRAMEDISPLAY_FRAMED}  CONST FRAMEDISPLAY_FRAMED  = 1  /* Dark frame with inner recessed frame */
NATIVE {FRAMEDISPLAY_FLAT}    CONST FRAMEDISPLAY_FLAT    = 2  /* Thin or thick dark frame */
NATIVE {FRAMEDISPLAY_FRAMED2} CONST FRAMEDISPLAY_FRAMED2 = 3  /* Recessed frame with inner dark frame */

/* Values for GUIA_FramePressedLook */

NATIVE {FRAMEPRESSED_PUSHED}   CONST FRAMEPRESSED_PUSHED   = 0  /* Pushed in */
NATIVE {FRAMEPRESSED_INVERTED} CONST FRAMEPRESSED_INVERTED = 1  /* Inverted edges colors */

/* Values for GUIA_ClickTabLook */

NATIVE {CLICKTAB_ACTIVEBOLD}       CONST CLICKTAB_ACTIVEBOLD       = $00000001
NATIVE {CLICKTAB_EVENWIDTH}        CONST CLICKTAB_EVENWIDTH        = $00000002
NATIVE {CLICKTAB_INACTIVEDARK}     CONST CLICKTAB_INACTIVEDARK     = $00000004
NATIVE {CLICKTAB_ACTIVEFILLGRAD}   CONST CLICKTAB_ACTIVEFILLGRAD   = $00000008
NATIVE {CLICKTAB_ACTIVEPENMASK}    CONST CLICKTAB_ACTIVEPENMASK    = $000000F0
NATIVE {CLICKTAB_ACTIVEPENTEXT}    CONST CLICKTAB_ACTIVEPENTEXT    = $00000000
NATIVE {CLICKTAB_ACTIVEPENHLTEXT}  CONST CLICKTAB_ACTIVEPENHLTEXT  = $00000010
NATIVE {CLICKTAB_ACTIVEPENTITLE}   CONST CLICKTAB_ACTIVEPENTITLE   = $00000020
NATIVE {CLICKTAB_ACTIVEFILLMASK}   CONST CLICKTAB_ACTIVEFILLMASK   = $00000F00
NATIVE {CLICKTAB_ACTIVEFILLFILL}   CONST CLICKTAB_ACTIVEFILLFILL   = $00000000
NATIVE {CLICKTAB_ACTIVEFILLSHINE}  CONST CLICKTAB_ACTIVEFILLSHINE  = $00000100
NATIVE {CLICKTAB_ACTIVEFILLSELECT} CONST CLICKTAB_ACTIVEFILLSELECT = $00000200
NATIVE {CLICKTAB_ACTIVEFILLNONE}   CONST CLICKTAB_ACTIVEFILLNONE   = $00000F00
NATIVE {CLICKTAB_ACTIVEBRIGHT}     CONST CLICKTAB_ACTIVEBRIGHT     = $00001000

/* Values for GUIA_GaugeLook and GUIA_WindowGaugeLook */

NATIVE {GAUGE_FILL_STYLEMASK}  CONST GAUGE_FILL_STYLEMASK  = $00000007
NATIVE {GAUGE_FILL_BORDERLESS} CONST GAUGE_FILL_BORDERLESS = $00000000
NATIVE {GAUGE_FILL_3D}         CONST GAUGE_FILL_3D         = $00000001
NATIVE {GAUGE_FILL_FRAMED}     CONST GAUGE_FILL_FRAMED     = $00000002
NATIVE {GAUGE_FILL_FLAT}       CONST GAUGE_FILL_FLAT       = $00000003
NATIVE {GAUGE_FILL_AUTOSTYLE}  CONST GAUGE_FILL_AUTOSTYLE  = $00000007
NATIVE {GAUGE_FILL_GRADIENT}   CONST GAUGE_FILL_GRADIENT   = $00000010
NATIVE {GAUGE_CONT_STYLEMASK}  CONST GAUGE_CONT_STYLEMASK  = $00000700
NATIVE {GAUGE_CONT_BORDERLESS} CONST GAUGE_CONT_BORDERLESS = $00000000
NATIVE {GAUGE_CONT_3D}         CONST GAUGE_CONT_3D         = $00000100
NATIVE {GAUGE_CONT_FRAMED}     CONST GAUGE_CONT_FRAMED     = $00000200
NATIVE {GAUGE_CONT_FLAT}       CONST GAUGE_CONT_FLAT       = $00000300
NATIVE {GAUGE_CONT_FRAMED2}    CONST GAUGE_CONT_FRAMED2    = $00000400
NATIVE {GAUGE_CONT_AUTOSTYLE}  CONST GAUGE_CONT_AUTOSTYLE  = $00000700
NATIVE {GAUGE_CONT_GRADIENT}   CONST GAUGE_CONT_GRADIENT   = $00001000
NATIVE {GAUGE_SPACINGMASK}     CONST GAUGE_SPACINGMASK     = $00030000
NATIVE {GAUGE_INNERTICKS}      CONST GAUGE_INNERTICKS      = $00040000
NATIVE {GAUGE_UNUSED}          CONST GAUGE_UNUSED          = $00080000
NATIVE {GAUGE_BORDERPENS}      CONST GAUGE_BORDERPENS      = $00100000
NATIVE {GAUGE_RESERVED}        CONST GAUGE_RESERVED        = $80000000

/* Special value for GUIA_PaletteRGBTable */

NATIVE {PALETTERGB_IGNORE} CONST PALETTERGB_IGNORE = (NOT 0)

/* Special value for GUIA_PaletteLockTable */

NATIVE {PALETTELOCK_IGNORE} CONST PALETTELOCK_IGNORE = (NOT 0)

/* Special value for GUIA_DRIPens */

NATIVE {DRIPENS_IGNORE} CONST DRIPENS_IGNORE = (NOT 0)

/* Window title positions */

NATIVE {WTPOS_LEFT}      CONST WTPOS_LEFT      = 0  /* Left side (default) */
NATIVE {WTPOS_CENTERREL} CONST WTPOS_CENTERREL = 1  /* Centered in dragbar */
NATIVE {WTPOS_CENTERABS} CONST WTPOS_CENTERABS = 2  /* Centered in whole titlebar */

/* Menu types */

NATIVE {MT_PULLDOWN} CONST MT_PULLDOWN = 0  /* Always pulldown (default) */
NATIVE {MT_POPUP}    CONST MT_POPUP    = 1  /* Always pop-up */
NATIVE {MT_RELATIVE} CONST MT_RELATIVE = 2  /* Pulldown or pop-up depending on position */

/* Menu flags */

NATIVE {MENUTRANSP}   CONST MENUTRANSP   = $00000001  /* Menus have transparency */
NATIVE {MENUSHADOW}   CONST MENUSHADOW   = $00000002  /* Menus have drop shadows */
NATIVE {MENUALTERN}   CONST MENUALTERN   = $00000010  /* Alternative look (rounded corners) */
NATIVE {MENUFRAMED}   CONST MENUFRAMED   = $00000020  /* Framed style for menu edges */
NATIVE {MENUFLAT}     CONST MENUFLAT     = $00000040  /* Never use embossed effects */
NATIVE {MENUTRACK}    CONST MENUTRACK    = $00000100  /* Remember last selections */
NATIVE {MENUSTICKYPD} CONST MENUSTICKYPD = $00000200  /* Use sticky pulldown menu panels */
NATIVE {MENUSTICKYPU} CONST MENUSTICKYPU = $00000400  /* Use sticky pop-up menu panels */
NATIVE {MENUNBPD}     CONST MENUNBPD     = $00001000  /* Use non-blocking pulldown menu panels */
NATIVE {MENUNBPU}     CONST MENUNBPU     = $00002000  /* Use non-blocking pop-up menu panels */

/****************************************************************************/

/* Obsolete definitions, here only for compatibility, don't use in new code */

NATIVE {FRAMEBUTTON_XEN}   CONST FRAMEBUTTON_XEN   = FRAMEBUTTON_FRAMED
NATIVE {FRAMESTRING_XEN}   CONST FRAMESTRING_XEN   = FRAMESTRING_FRAMED
NATIVE {FRAMESTRING_MIXED} CONST FRAMESTRING_MIXED = FRAMESTRING_FRAMED2
NATIVE {FRAMEPROP_XEN}     CONST FRAMEPROP_XEN     = FRAMEPROP_FRAMED
NATIVE {FRAMEDISPLAY_XEN}  CONST FRAMEDISPLAY_XEN  = FRAMEDISPLAY_FRAMED
NATIVE {MENUXEN}           CONST MENUXEN           = MENUFRAMED
