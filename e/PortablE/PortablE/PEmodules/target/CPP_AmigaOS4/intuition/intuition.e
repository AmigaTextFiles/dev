/* $Id: intuition.h,v 1.34 2005/12/23 19:38:25 mtantignone Exp $ */
OPT NATIVE, POINTER, PREPROCESS
PUBLIC MODULE 'target/intuition/intuition_shared1'
MODULE 'target/exec/types', 'target/graphics/gfx', 'target/graphics/clip', 'target/graphics/view', 'target/graphics/rastport', 'target/graphics/layers', 'target/graphics/text', 'target/exec/ports', 'target/devices/inputevent', 'target/utility/tagitem', 'target/intuition/screens', 'target/intuition/preferences' /*, 'target/intuition/iobsolete'*/
MODULE 'target/intuition/intuition_shared2', 'target/devices/keymap', 'target/utility/hooks'
{#include <intuition/intuition.h>}
NATIVE {INTUITION_INTUITION_H} CONST

/* ======================================================================== */
/* === Menu =============================================================== */
/* ======================================================================== */
->"OBJECT menu" is on-purposely missing from here (it can be found in 'intuition/intuition_shared1')

/* FLAGS SET BY BOTH THE APPLIPROG AND INTUITION */
NATIVE {MENUENABLED} CONST MENUENABLED = $0001 /* whether or not this menu is enabled */

/* FLAGS SET BY INTUITION */
NATIVE {MIDRAWN}     CONST MIDRAWN     = $0100 /* this menu's items are currently drawn */

/* ======================================================================== */
/* === MenuItem =========================================================== */
/* ======================================================================== */
->"OBJECT menuitem" is on-purposely missing from here (it can be found in 'intuition/intuition_shared1')


/* FLAGS SET BY THE APPLIPROG */
NATIVE {CHECKIT}     CONST CHECKIT     = $0001 /* set to indicate checkmarkable item */
NATIVE {ITEMTEXT}    CONST ITEMTEXT    = $0002 /* set if textual, clear if graphical item */
NATIVE {COMMSEQ}     CONST COMMSEQ     = $0004 /* set if there's an command sequence */
NATIVE {MENUTOGGLE}  CONST MENUTOGGLE  = $0008 /* set for toggling checks (else mut. exclude) */
NATIVE {ITEMENABLED} CONST ITEMENABLED = $0010 /* set if this item is enabled */
NATIVE {SUBMENU}     CONST SUBMENU     = $0200 /* set to get standard submenu indicator (V50) */

/* these are the SPECIAL HIGHLIGHT FLAG state meanings */
NATIVE {HIGHFLAGS}   CONST HIGHFLAGS   = $00C0 /* see definitions below for these bits */
NATIVE {HIGHIMAGE}   CONST HIGHIMAGE   = $0000 /* use the user's "select image" */
NATIVE {HIGHCOMP}    CONST HIGHCOMP    = $0040 /* highlight by complementing the selectbox */
NATIVE {HIGHBOX}     CONST HIGHBOX     = $0080 /* highlight by "boxing" the selectbox */
NATIVE {HIGHNONE}    CONST HIGHNONE    = $00C0 /* don't highlight */

/* FLAGS SET BY BOTH APPLIPROG AND INTUITION */
NATIVE {CHECKED}     CONST CHECKED     = $0100 /* state of the checkmark */

/* FLAGS SET BY INTUITION */
NATIVE {ISDRAWN}     CONST ISDRAWN     = $1000 /* this item's subs are currently drawn */
NATIVE {HIGHITEM}    CONST HIGHITEM    = $2000 /* this item is currently highlighted */
NATIVE {MENUTOGGLED} CONST MENUTOGGLED = $4000 /* this item was already toggled */

/* ======================================================================== */
/* === Requester ========================================================== */
/* ======================================================================== */
->"OBJECT requester" is on-purposely missing from here (it can be found in 'intuition/intuition_shared1')


/* FLAGS SET BY THE APPLIPROG */
NATIVE {POINTREL}      CONST POINTREL      = $0001
              /* if POINTREL set, TopLeft is relative to pointer
               * for DMRequester, relative to window center
               * for Request().
               */
NATIVE {PREDRAWN}      CONST PREDRAWN      = $0002
    /* set if Requester.ImageBMap points to predrawn Requester imagery */
NATIVE {NOISYREQ}      CONST NOISYREQ      = $0004
    /* if you don't want requester to filter input */
NATIVE {SIMPLEREQ}     CONST SIMPLEREQ     = $0010
    /* to use SIMPLEREFRESH layer (recommended) */

/* New for V36        */
NATIVE {USEREQIMAGE}   CONST USEREQIMAGE   = $0020
    /* render linked list ReqImage after BackFill
     * but before gadgets and text
     */
NATIVE {NOREQBACKFILL} CONST NOREQBACKFILL = $0040
    /* don't bother filling requester with Requester.BackFill pen */

/* FLAGS SET BY INTUITION */
NATIVE {REQOFFWINDOW}  CONST REQOFFWINDOW  = $1000    /* part of one of the Gadgets was offwindow */
NATIVE {REQACTIVE}     CONST REQACTIVE     = $2000    /* this requester is active */
NATIVE {SYSREQUEST}    CONST SYSREQUEST    = $4000    /* (unused) this requester caused by system */
NATIVE {DEFERREFRESH}  CONST DEFERREFRESH  = $8000    /* this Requester stops a Refresh broadcast */

/* ======================================================================== */
/* === Gadget ============================================================= */
/* ======================================================================== */
->"OBJECT gadget" is on-purposely missing from here (it can be found in 'intuition/intuition_shared1')

NATIVE {ExtGadget} OBJECT extgadget
    /* The first fields match struct Gadget exactly */
    {NextGadget}	nextgadget	:PTR TO extgadget /* Matches struct Gadget */
    {LeftEdge}	leftedge	:INT
	{TopEdge}	topedge	:INT       /* Matches struct Gadget */
    {Width}	width	:INT
	{Height}	height	:INT           /* Matches struct Gadget */
    {Flags}	flags	:UINT                  /* Matches struct Gadget */
    {Activation}	activation	:UINT             /* Matches struct Gadget */
    {GadgetType}	gadgettype	:UINT             /* Matches struct Gadget */
    {GadgetRender}	gadgetrender	:APTR            /* Matches struct Gadget */
    {SelectRender}	selectrender	:APTR            /* Matches struct Gadget */
    {GadgetText}	gadgettext	:PTR TO intuitext /* Matches struct Gadget */
    {MutualExclude}	mutualexclude	:VALUE           /* Matches struct Gadget */
    {SpecialInfo}	specialinfo	:APTR             /* Matches struct Gadget */
    {GadgetID}	gadgetid	:UINT               /* Matches struct Gadget */
    {UserData}	userdata	:APTR                /* Matches struct Gadget */

    /* These fields only exist under V39 and only if GFLG_EXTENDED is set */
    {MoreFlags}	moreflags	:ULONG              /* see GMORE_ flags below */
    {BoundsLeftEdge}	boundsleftedge	:INT          /* Bounding extent for gadget, valid */
    {BoundsTopEdge}	boundstopedge	:INT           /* only if GMORE_BOUNDS is set.  The */
    {BoundsWidth}	boundswidth	:INT             /* GFLG_RELxxx flags affect these    */
    {BoundsHeight}	boundsheight	:INT            /* coordinates as well.              */
ENDOBJECT

/* --- Gadget.Flags values    --- */
/* combinations in these bits describe the highlight technique to be used */
NATIVE {GFLG_GADGHIGHBITS} CONST GFLG_GADGHIGHBITS = $0003
NATIVE {GFLG_GADGHCOMP}    CONST GFLG_GADGHCOMP    = $0000 /* Complement the select box */
NATIVE {GFLG_GADGHBOX}     CONST GFLG_GADGHBOX     = $0001 /* Draw a box around the image */
NATIVE {GFLG_GADGHIMAGE}   CONST GFLG_GADGHIMAGE   = $0002 /* Blast in this alternate image */
NATIVE {GFLG_GADGHNONE}    CONST GFLG_GADGHNONE    = $0003 /* don't highlight */

NATIVE {GFLG_GADGIMAGE}    CONST GFLG_GADGIMAGE    = $0004 /* set if GadgetRender and SelectRender
                                  * point to an Image structure, clear
                                  * if they point to Border structures
                                  */

/* combinations in these next two bits specify to which corner the gadget's
 *  Left & Top coordinates are relative.  If relative to Top/Left,
 *  these are "normal" coordinates (everything is relative to something in
 *  this universe).
 *
 * Gadget positions and dimensions are relative to the window or
 * requester which contains the gadget
 */
NATIVE {GFLG_RELBOTTOM}    CONST GFLG_RELBOTTOM    = $0008 /* vert. pos. is relative to bottom edge */
NATIVE {GFLG_RELRIGHT}     CONST GFLG_RELRIGHT     = $0010 /* horiz. pos. is relative to right edge */
NATIVE {GFLG_RELWIDTH}     CONST GFLG_RELWIDTH     = $0020 /* width is relative to req/window       */
NATIVE {GFLG_RELHEIGHT}    CONST GFLG_RELHEIGHT    = $0040 /* height is relative to req/window      */

/* New for V39: GFLG_RELSPECIAL allows custom gadget implementors to
 * make gadgets whose position and size depend in an arbitrary way
 * on their window's dimensions.  The GM_LAYOUT method will be invoked
 * for such a gadget (or any other GREL_xxx gadget) at suitable times,
 * such as when the window opens or the window's size changes.
 */
NATIVE {GFLG_RELSPECIAL}   CONST GFLG_RELSPECIAL   = $4000 /* custom gadget has special relativity.
                                  * Gadget box values are absolutes, but
                                  * can be changed via the GM_LAYOUT method.
                                  */
NATIVE {GFLG_SELECTED}     CONST GFLG_SELECTED     = $0080 /* you may initialize and look at this    */

/* the GFLG_DISABLED flag is initialized by you and later set by Intuition
 * according to your calls to On/OffGadget().  It specifies whether or not
 * this Gadget is currently disabled from being selected
 */
NATIVE {GFLG_DISABLED}     CONST GFLG_DISABLED     = $0100

/* These flags specify the type of text field that Gadget.GadgetText
 * points to.  In all normal (pre-V36) gadgets which you initialize
 * this field should always be zero.  Some types of gadget objects
 * created from classes will use these fields to keep track of
 * types of labels/contents that different from IntuiText, but are
 * stashed in GadgetText.
 */

NATIVE {GFLG_LABELMASK}    CONST GFLG_LABELMASK    = $3000
NATIVE {GFLG_LABELITEXT}   CONST GFLG_LABELITEXT   = $0000 /* GadgetText points to IntuiText      */
NATIVE {GFLG_LABELSTRING}  CONST GFLG_LABELSTRING  = $1000 /* GadgetText points to STRPTR         */
NATIVE {GFLG_LABELIMAGE}   CONST GFLG_LABELIMAGE   = $2000 /* GadgetText points to Image (object) */

/* New for V37: GFLG_TABCYCLE */
NATIVE {GFLG_TABCYCLE}     CONST GFLG_TABCYCLE     = $0200 /* (string or custom) gadget participates in
                                  * cycling activation with Tab or Shift-Tab
                                  */
/* New for V37: GFLG_STRINGEXTEND.  We discovered that V34 doesn't properly
 * ignore the value we had chosen for the Gadget->Activation flag
 * GACT_STRINGEXTEND.  NEVER SET THAT FLAG WHEN RUNNING UNDER V34.
 * The Gadget->Flags bit GFLG_STRINGEXTEND is provided as a synonym which is
 * safe under V34, and equivalent to GACT_STRINGEXTEND under V37.
 * (Note that the two flags are not numerically equal)
 */
NATIVE {GFLG_STRINGEXTEND} CONST GFLG_STRINGEXTEND = $0400 /* this String Gadget has StringExtend */

/* New for V39: GFLG_IMAGEDISABLE.  This flag is automatically set if
 * the custom image of this gadget knows how to do disabled rendering
 * (more specifically, if its IA_SupportsDisable attribute is TRUE).
 * Intuition uses this to defer the ghosting to the image-class,
 * instead of doing it itself (the old compatible way).
 * Do not set this flag yourself - Intuition will do it for you.
 */

NATIVE {GFLG_IMAGEDISABLE} CONST GFLG_IMAGEDISABLE = $0800 /* Gadget's image knows how to do disabled
                                  * rendering
                                  */

/* New for V39:  If set, this bit means that the Gadget is actually
 * a struct ExtGadget, with new fields and flags.  All V39 boopsi
 * gadgets are ExtGadgets.  Never ever attempt to read the extended
 * fields of a gadget if this flag is not set.
 */
NATIVE {GFLG_EXTENDED}     CONST GFLG_EXTENDED     = $8000 /* Gadget is extended */

/* ---    Gadget.Activation flag values    --- */
/* Set GACT_RELVERIFY if you want to verify that the pointer was still over
 * the gadget when the select button was released.  Will cause
 * an IDCMP_GADGETUP message to be sent if so.
 */
NATIVE {GACT_RELVERIFY}    CONST GACT_RELVERIFY    = $0001

/* the flag GACT_IMMEDIATE, when set, informs the caller that the gadget
 *  was activated when it was activated.  This flag works in conjunction with
 *  the GACT_RELVERIFY flag
 */
NATIVE {GACT_IMMEDIATE}    CONST GACT_IMMEDIATE    = $0002

/* the flag GACT_ENDGADGET, when set, tells the system that this gadget,
 * when selected, causes the Requester to be ended.  Requesters
 * that are ended are erased and unlinked from the system.
 */
NATIVE {GACT_ENDGADGET}    CONST GACT_ENDGADGET    = $0004

/* the GACT_FOLLOWMOUSE flag, when set, specifies that you want to receive
 * reports on mouse movements while this gadget is active.
 * You probably want to set the GACT_IMMEDIATE flag when using
 * GACT_FOLLOWMOUSE, since that's the only reasonable way you have of
 * learning why Intuition is suddenly sending you a stream of mouse
 * movement events.  If you don't set GACT_RELVERIFY, you'll get at
 * least one Mouse Position event.
 * Note: boolean FOLLOWMOUSE gadgets require GACT_RELVERIFY to get
 * _any_ mouse movement events (this unusual behavior is a compatibility
 * hold-over from the old days).
 */
NATIVE {GACT_FOLLOWMOUSE}  CONST GACT_FOLLOWMOUSE  = $0008

/* if any of the BORDER flags are set in a Gadget that's included in the
 * Gadget list when a Window is opened, the corresponding Border will
 * be adjusted to make room for the Gadget
 */
NATIVE {GACT_RIGHTBORDER}  CONST GACT_RIGHTBORDER  = $0010
NATIVE {GACT_LEFTBORDER}   CONST GACT_LEFTBORDER   = $0020
NATIVE {GACT_TOPBORDER}    CONST GACT_TOPBORDER    = $0040
NATIVE {GACT_BOTTOMBORDER} CONST GACT_BOTTOMBORDER = $0080
NATIVE {GACT_BORDERSNIFF}  CONST GACT_BORDERSNIFF  = $8000 /* neither set nor rely on this bit    */

NATIVE {GACT_TOGGLESELECT} CONST GACT_TOGGLESELECT = $0100 /* this bit for toggle-select mode     */
NATIVE {GACT_BOOLEXTEND}   CONST GACT_BOOLEXTEND   = $2000 /* this Boolean Gadget has a BoolInfo  */

/* should properly be in StringInfo, but aren't */
NATIVE {GACT_STRINGLEFT}   CONST GACT_STRINGLEFT   = $0000 /* NOTE WELL: that this has value zero */
NATIVE {GACT_STRINGCENTER} CONST GACT_STRINGCENTER = $0200
NATIVE {GACT_STRINGRIGHT}  CONST GACT_STRINGRIGHT  = $0400
NATIVE {GACT_LONGINT}      CONST GACT_LONGINT      = $0800 /* this String Gadget is for Long Ints */
NATIVE {GACT_ALTKEYMAP}    CONST GACT_ALTKEYMAP    = $1000 /* this String has an alternate keymap */
NATIVE {GACT_STRINGEXTEND} CONST GACT_STRINGEXTEND = $2000 /* this String Gadget has StringExtend */
                  /* NOTE: NEVER SET GACT_STRINGEXTEND IF YOU
                   * ARE RUNNING ON LESS THAN V36!  SEE
                   * GFLG_STRINGEXTEND (ABOVE) INSTEAD
                   */

NATIVE {GACT_ACTIVEGADGET} CONST GACT_ACTIVEGADGET = $4000 /* this gadget is "active".  This flag
                                  * is maintained by Intuition, and you
                                  * cannot count on its value persisting
                                  * while you do something on your program's
                                  * task.  It can only be trusted by
                                  * people implementing custom gadgets
                                  */

/* note 0x8000 is used above (GACT_BORDERSNIFF);
 * all Activation flags defined */

/* --- GADGET TYPES ------------------------------------------------------- */
/* These are the Gadget Type definitions for the variable GadgetType
 * gadget number type MUST start from one.  NO TYPES OF ZERO ALLOWED.
 * first comes the mask for Gadget flags reserved for Gadget typing
 */
NATIVE {GTYP_GADGETTYPE}   CONST GTYP_GADGETTYPE   = $FC00 /* all Gadget Global Type flags (padded) */

NATIVE {GTYP_SCRGADGET}    CONST GTYP_SCRGADGET    = $4000 /* 1 = ScreenGadget, 0 = WindowGadget */
NATIVE {GTYP_GZZGADGET}    CONST GTYP_GZZGADGET    = $2000 /* 1 = for WFLG_GIMMEZEROZERO borders */
NATIVE {GTYP_REQGADGET}    CONST GTYP_REQGADGET    = $1000 /* 1 = this is a Requester Gadget */

/* GTYP_SYSGADGET means that Intuition ALLOCATED the gadget.
 * GTYP_SYSTYPEMASK is the mask you can apply to tell what type of
 * system-gadget it is.  The possible types follow.
 */
NATIVE {GTYP_SYSGADGET}    CONST GTYP_SYSGADGET    = $8000
NATIVE {GTYP_SYSTYPEMASK}  CONST GTYP_SYSTYPEMASK  = $00F0

/* These definitions describe system gadgets in V36 and higher: */
NATIVE {GTYP_SIZING}       CONST GTYP_SIZING       = $0010 /* Window sizing gadget */
NATIVE {GTYP_WDRAGGING}    CONST GTYP_WDRAGGING    = $0020 /* Window drag bar */
NATIVE {GTYP_SDRAGGING}    CONST GTYP_SDRAGGING    = $0030 /* Screen drag bar */
NATIVE {GTYP_WDEPTH}       CONST GTYP_WDEPTH       = $0040 /* Window depth gadget */
NATIVE {GTYP_SDEPTH}       CONST GTYP_SDEPTH       = $0050 /* Screen depth gadget */
NATIVE {GTYP_WZOOM}        CONST GTYP_WZOOM        = $0060 /* Window zoom gadget */
NATIVE {GTYP_SUNUSED}      CONST GTYP_SUNUSED      = $0070 /* Unused screen gadget */
NATIVE {GTYP_CLOSE}        CONST GTYP_CLOSE        = $0080 /* Window close gadget */

/* These definitions describe system gadgets prior to V36: */
NATIVE {GTYP_WUPFRONT}     CONST GTYP_WUPFRONT     = GTYP_WDEPTH  /* Window to-front gadget */
NATIVE {GTYP_SUPFRONT}     CONST GTYP_SUPFRONT     = GTYP_SDEPTH  /* Screen to-front gadget */
NATIVE {GTYP_WDOWNBACK}    CONST GTYP_WDOWNBACK    = GTYP_WZOOM   /* Window to-back gadget */
NATIVE {GTYP_SDOWNBACK}    CONST GTYP_SDOWNBACK    = GTYP_SUNUSED /* Screen to-back gadget */

/* GTYP_GTYPEMASK is a mask you can apply to tell what class
 * of gadget this is.  The possible classes follow.
 */
NATIVE {GTYP_GTYPEMASK}    CONST GTYP_GTYPEMASK    = $0007

NATIVE {GTYP_BOOLGADGET}   CONST GTYP_BOOLGADGET   = $0001
NATIVE {GTYP_GADGET0002}   CONST GTYP_GADGET0002   = $0002
NATIVE {GTYP_PROPGADGET}   CONST GTYP_PROPGADGET   = $0003
NATIVE {GTYP_STRGADGET}    CONST GTYP_STRGADGET    = $0004
NATIVE {GTYP_CUSTOMGADGET} CONST GTYP_CUSTOMGADGET = $0005

/* This bit in GadgetType is reserved for undocumented internal use
 * by the Gadget Toolkit, and cannot be used nor relied on by
 * applications:          0x0100
 */

/* New for V50. By setting this flag in GadgetType, you ask Intuition
 * to automatically position your gadget (according to its size) so
 * that it appears at the left or right side of the window titlebar, in
 * the same vein as the close or depth gadgets. If the GFLG_RELRIGHT flag
 * is set, the gadget is placed at the right side, otherwise at the left.
 * The gadget's size is not changed, only its position is; this is done
 * in such a way that the gadget is always placed correctly no matter
 * what particular gadget style and geometry is being used.
 * This automatic layout happens either upon window opening (if your
 * gadget is already in the gadget list of the window) or when you add
 * the gadget with AddGadget() or AddGList().
 * Note well: you MUST also set GACT_TOPBORDER in Activation for this
 * feature to work. Also note that, after this automatic layout,
 * GM_LAYOUT will still be invoked for the gadget, so you have a chance
 * to override parts of it if needed (although it's not recommended, as
 * it defies the purpose of using this flag in the first place).
 * It is strongly advised that you only use this feature with gadgets
 * whose imagery is a sysiclass instance of a type suitable for a window
 * titlebar gadget (such as ICONIFYIMAGE or TBFRAMEIMAGE).
 */

NATIVE {GTYP_TBARGADGET}   CONST GTYP_TBARGADGET   = $0200

/* New for V39.  Gadgets which have the GFLG_EXTENDED flag set are
 * actually ExtGadgets, which have more flags.    The GMORE_xxx
 * identifiers describe those flags.  For GMORE_SCROLLRASTER, see
 * important information in the ScrollWindowRaster() autodoc.
 * NB: GMORE_SCROLLRASTER must be set before the gadget is
 * added to a window.
 */

NATIVE {GMORE_BOUNDS}           CONST GMORE_BOUNDS           = $00000001 /* ExtGadget has valid Bounds */
NATIVE {GMORE_GADGETHELP}       CONST GMORE_GADGETHELP       = $00000002 /* This gadget responds
                                           * to gadget help
                                           */
NATIVE {GMORE_SCROLLRASTER}     CONST GMORE_SCROLLRASTER     = $00000004 /* This (custom) gadget uses
                                           * ScrollRaster
                                           */
NATIVE {GMORE_NOFILTERMENUKEYS} CONST GMORE_NOFILTERMENUKEYS = $00000008 /* Set this flag to make menu
                                           * shortcuts work even when
                                           * the gadget is active. V50.
                                           */
NATIVE {GMORE_HIDDEN}           CONST GMORE_HIDDEN           = $00000010 /* This gadgets is hidden/
                                           * can't be drawn. V50.
                                           */
->NATIVE {GMORE_HIDDEN}           CONST GMORE_HIDDEN           = $00000010 /* This gadgets is hidden/can't be drawn. V50. */
NATIVE {GMORE_PRIVATE}          CONST GMORE_PRIVATE          = $00000020 /* Reserved for ReAction use. V50. */
NATIVE {GMORE_PRIVATE2}         CONST GMORE_PRIVATE2         = $00000040 /* Reserved for ReAction use. V51. */
NATIVE {GMORE_NOFILTERWHEEL}    CONST GMORE_NOFILTERWHEEL    = $00000080 /* Your window will receive mouse wheel events
                                           * even when the gadget is active. V51.
                                           */

/* Domain types recognized by GadgetBox() */

NATIVE {GBD_WINDOW}    CONST GBD_WINDOW    = 0 /* Domain is a Window */
NATIVE {GBD_BOX}       CONST GBD_BOX       = 1 /* Domain is an IBox */
NATIVE {GBD_RECTANGLE} CONST GBD_RECTANGLE = 2 /* Domain is a Rectangle */
NATIVE {GBD_GINFO}     CONST GBD_GINFO     = 3 /* Domain is a GadgetInfo (V51) */

/* Flags for GadgetBox() */

NATIVE {GBF_BOUNDS}   CONST GBF_BOUNDS   = $00000001 /* Return bounding box, not hit box */
NATIVE {GBF_MAKERECT} CONST GBF_MAKERECT = $00000002 /* Return a Rectangle, not an IBox */

/* ======================================================================== */
/* === BoolInfo     ======================================================= */
/* ======================================================================== */
/* This is the special data needed by an Extended Boolean Gadget
 * Typically this structure will be pointed to by the Gadget field SpecialInfo
 */
NATIVE {BoolInfo} OBJECT boolinfo
    {Flags}	flags	:UINT    /* defined below */
    {Mask}	mask	:PTR TO UINT     /* bit mask for highlighting and selecting
                      * mask must follow the same rules as an Image
                      * plane.  Its width and height are determined
                      * by the width and height of the gadget's
                      * select box. (i.e. Gadget.Width and .Height).
                      */
    {Reserved}	reserved	:ULONG /* set to 0 */
ENDOBJECT

/* set BoolInfo.Flags to this flag bit.
 * in the future, additional bits might mean more stuff hanging
 * off of BoolInfo.Reserved.
 */
NATIVE {BOOLMASK} CONST BOOLMASK = $0001 /* extension is for masked gadget */

/* ======================================================================== */
/* === PropInfo =========================================================== */
/* ======================================================================== */
/* this is the special data required by the proportional Gadget
 * typically, this data will be pointed to by the Gadget variable SpecialInfo
 */
NATIVE {PropInfo} OBJECT propinfo
    {Flags}	flags	:UINT     /* general purpose flag bits (see defines below) */

    /* You initialize the Pot variables before the Gadget is added to
     * the system.  Then you can look here for the current settings
     * any time, even while User is playing with this Gadget.  To
     * adjust these after the Gadget is added to the System, use
     * ModifyProp();  The Pots are the actual proportional settings,
     * where a value of zero means zero and a value of MAXPOT means
     * that the Gadget is set to its maximum setting.
     */
    {HorizPot}	horizpot	:UINT  /* 16-bit FixedPoint horizontal quantity percentage */
    {VertPot}	vertpot	:UINT   /* 16-bit FixedPoint vertical quantity percentage */

    /* the 16-bit FixedPoint Body variables describe what percentage of
     * the entire body of stuff referred to by this Gadget is actually
     * shown at one time.  This is used with the AUTOKNOB routines,
     * to adjust the size of the AUTOKNOB according to how much of
     * the data can be seen.  This is also used to decide how far
     * to advance the Pots when User hits the Container of the Gadget.
     * For instance, if you were controlling the display of a 5-line
     * Window of text with this Gadget, and there was a total of 15
     * lines that could be displayed, you would set the VertBody value to
     *       (MAXBODY / (TotalLines / DisplayLines)) = MAXBODY / 3.
     * Therefore, the AUTOKNOB would fill 1/3 of the container, and
     * if User hits the Cotainer outside of the knob, the pot would
     * advance 1/3 (plus or minus) If there's no body to show, or
     * the total amount of displayable info is less than the display area,
     * set the Body variables to the MAX.  To adjust these after the
     * Gadget is added to the System, use ModifyProp();
     */
    {HorizBody}	horizbody	:UINT /* horizontal Body */
    {VertBody}	vertbody	:UINT  /* vertical Body */

    /* these are the variables that Intuition sets and maintains */
    {CWidth}	cwidth	:UINT    /* Container width (with any relativity absoluted) */
    {CHeight}	cheight	:UINT   /* Container height (with any relativity absoluted) */
    {HPotRes}	hpotres	:UINT
	{VPotRes}	vpotres	:UINT /* pot increments */
    {LeftBorder}	leftborder	:UINT       /* Container borders */
    {TopBorder}	topborder	:UINT        /* Container borders */
ENDOBJECT


/* --- FLAG BITS ---------------------------------------------------------- */
NATIVE {AUTOKNOB}       CONST AUTOKNOB       = $0001 /* this flag sez:  gimme that old auto-knob */
/* NOTE: if you do not use an AUTOKNOB for a proportional gadget,
 * you are currently limited to using a single Image of your own
 * design: Intuition won't handle a linked list of images as
 * a proportional gadget knob.
 */

NATIVE {FREEHORIZ}      CONST FREEHORIZ      = $0002 /* if set, the knob can move horizontally */
NATIVE {FREEVERT}       CONST FREEVERT       = $0004 /* if set, the knob can move vertically */
NATIVE {PROPBORDERLESS} CONST PROPBORDERLESS = $0008 /* if set, no border will be rendered */
NATIVE {KNOBHIT}        CONST KNOBHIT        = $0100 /* set when this Knob is hit */
NATIVE {PROPNEWLOOK}    CONST PROPNEWLOOK    = $0010 /* set this if you want to get the new
                               * V36 look
                               */

NATIVE {KNOBHMIN} CONST KNOBHMIN = 6       /* minimum horizontal size of the Knob */
NATIVE {KNOBVMIN} CONST KNOBVMIN = 4       /* minimum vertical size of the Knob */
NATIVE {MAXBODY}  CONST MAXBODY  = $FFFF  /* maximum body value */
NATIVE {MAXPOT}   CONST MAXPOT   = $FFFF  /* maximum pot value */


/* ======================================================================== */
/* === StringInfo ========================================================= */
/* ======================================================================== */
/* this is the special data required by the string Gadget
 * typically, this data will be pointed to by the Gadget variable SpecialInfo
 */
NATIVE {StringInfo} OBJECT stringinfo
    /* you initialize these variables, and then Intuition maintains them */
    {Buffer}	buffer	:/*STRPTR*/ ARRAY OF CHAR     /* the buffer containing the start and final string */
    {UndoBuffer}	undobuffer	:/*STRPTR*/ ARRAY OF CHAR /* optional buffer for undoing current entry */
    {BufferPos}	bufferpos	:INT    /* character position in Buffer */
    {MaxChars}	maxchars	:INT     /* max number of chars in Buffer (including NULL) */
    {DispPos}	disppos	:INT      /* Buffer position of first displayed character */

    /* Intuition initializes and maintains these variables for you */
    {UndoPos}	undopos	:INT      /* character position in the undo buffer */
    {NumChars}	numchars	:INT     /* number of characters currently in Buffer */
    {DispCount}	dispcount	:INT    /* number of whole characters visible in Container */
    {CLeft}	cleft	:INT
	{CTop}	ctop	:INT  /* topleft offset of the container */

    /* This unused field is changed to allow extended specification
     * of string gadget parameters.  It is ignored unless the flag
     * GACT_STRINGEXTEND is set in the Gadget's Activation field
     * or the GFLG_STRINGEXTEND flag is set in the Gadget Flags field.
     * (See GFLG_STRINGEXTEND for an important note)
     */
    /* struct Layer *LayerPtr;    --- obsolete --- */
    {Extension}	extension	:PTR TO stringextend

    /* you can initialize this variable before the gadget is submitted to
     * Intuition, and then examine it later to discover what integer
     * the user has entered (if the user never plays with the gadget,
     * the value will be unchanged from your initial setting)
     */
    {LongInt}	longint	:VALUE

    /* If you want this Gadget to use your own Console keymapping, you
     * set the GACT_ALTKEYMAP bit in the Activation flags of the Gadget,
     * and then set this variable to point to your keymap.  If you don't
     * set the GACT_ALTKEYMAP, you'll get the standard ASCII keymapping.
     */
    {AltKeyMap}	altkeymap	:PTR TO keymap
ENDOBJECT

/* ======================================================================== */
/* === IntuiText ========================================================== */
/* ======================================================================== */
/* IntuiText is a series of strings that start with a location
 *  (always relative to the upper-left corner of something) and then the
 *  text of the string.  The text is null-terminated.
 */
->"OBJECT intuitext" is on-purposely missing from here (it can be found in 'intuition/intuition_shared1')

/* ======================================================================== */
/* === Border ============================================================= */
/* ======================================================================== */
/* Data type Border, used for drawing a series of lines which is intended for
 *  use as a border drawing, but which may, in fact, be used to render any
 *  arbitrary vector shape.
 *  The routine DrawBorder sets up the RastPort with the appropriate
 *  variables, then does a Move to the first coordinate, then does Draws
 *  to the subsequent coordinates.
 *  After all the Draws are done, if NextBorder is non-zero we call DrawBorder
 *  on NextBorder
 */
->"OBJECT border" is on-purposely missing from here (it can be found in 'intuition/intuition_shared1')

/* ======================================================================== */
/* === Image ============================================================== */
/* ======================================================================== */
/* This is a brief image structure for very simple transfers of
 * image data to a RastPort
 */
->"OBJECT image" is on-purposely missing from here (it can be found in 'intuition/intuition_shared1')

/* ======================================================================== */
/* === IntuiMessage ======================================================= */
/* ======================================================================== */
->"OBJECT intuimessage" is on-purposely missing from here (it can be found in 'intuition/intuition_shared1')

/* New for V39:
 * All IntuiMessages are now slightly extended.  The ExtIntuiMessage
 * structure has an additional field for tablet data, which is usually
 * NULL.  If a tablet driver which is sending IESUBCLASS_NEWTABLET
 * events is installed in the system, windows with the WA_TabletMessages
 * property set will find that eim_TabletData points to the TabletData
 * structure.  Applications must first check that this field is non-NULL;
 * it will be NULL for certain kinds of message, including mouse activity
 * generated from other than the tablet (i.e. the keyboard equivalents
 * or the mouse itself).
 *
 * NEVER EVER examine any extended fields when running under pre-V39!
 *
 * NOTE: This structure is subject to grow in the future.  Making
 * assumptions about its size is A BAD IDEA.
 */

NATIVE {ExtIntuiMessage} OBJECT extintuimessage
    {eim_IntuiMessage}	intuimessage	:intuimessage
    {eim_TabletData}	tabletdata	:PTR TO tabletdata
    /*
     * The following fields are new for V50,
     * don't access it under V40 and earlier!
     */
    {eim_LongCode}	longcode	:ULONG /* 32bit version of IntuiMessage.Code */
    {eim_TagList}	taglist	:ARRAY OF tagitem  /* optional taglist */
ENDOBJECT

/* New for V51:
 * The IAddress field of IDCMP_EXTENDEDMOUSE messages points to the
 * following structure. Always check the Code field of the IntuiMessage
 * against IMSGCODE_INTUIWHEELDATA, future versions of Intuition may introduce
 * additional structures!
 */

NATIVE {IntuiWheelData} OBJECT intuiwheeldata
    {Version}	version	:UINT  /* version of this structure (see below) */
    {Reserved}	reserved	:UINT /* always 0, reserved for future use     */
    {WheelX}	wheelx	:INT   /* horizontal wheel movement delta       */
    {WheelY}	wheely	:INT   /* vertical wheel movement delta         */
ENDOBJECT

NATIVE {INTUIWHEELDATA_VERSION} CONST INTUIWHEELDATA_VERSION = 1 /* current version of the structure above */

/* New for V51:
 * The IAddress field of IDCMP_EXTENDEDKEYBOARD messages points to the
 * following structure. Always check the Code field of the IntuiMessage
 * against IMSGCODE_RAWKEYDATA, future versions of Intuition may introduce
 * additional structures!
 */

NATIVE {IntuiRawKeyData} OBJECT intuirawkeydata
    {Version}	version	:UINT  /* version of this structure (see below) */
    {Reserved}	reserved	:UINT /* always 0, reserved for future use     */
    {Class}	class	:UINT    /* copy of ie_SubClass (see IECLASS_EXTENDED_RAWKEY) */
    {Code}	code	:UINT     /* rawkey code */
    {DeadKeys}	deadkeys	:extendeddeadkey /* deadkey information */
ENDOBJECT

NATIVE {INTUIRAWKEYDATA_VERSION} CONST INTUIRAWKEYDATA_VERSION = 1 /* current version of the structure above */


NATIVE {IMSGCODE_INTUIWHEELDATA}  CONST IMSGCODE_INTUIWHEELDATA  = $8000
NATIVE {IMSGCODE_INTUIRAWKEYDATA} CONST IMSGCODE_INTUIRAWKEYDATA = $4000


/* --- IDCMP Classes ------------------------------------------------------ */
/* Please refer to the Autodoc for OpenWindow() and to the Rom Kernel
 * Manual for full details on the IDCMP classes.
 */
NATIVE {IDCMP_SIZEVERIFY}       CONST IDCMP_SIZEVERIFY       = $00000001
NATIVE {IDCMP_NEWSIZE}          CONST IDCMP_NEWSIZE          = $00000002
NATIVE {IDCMP_REFRESHWINDOW}    CONST IDCMP_REFRESHWINDOW    = $00000004
NATIVE {IDCMP_MOUSEBUTTONS}     CONST IDCMP_MOUSEBUTTONS     = $00000008
NATIVE {IDCMP_MOUSEMOVE}        CONST IDCMP_MOUSEMOVE        = $00000010
NATIVE {IDCMP_GADGETDOWN}       CONST IDCMP_GADGETDOWN       = $00000020
NATIVE {IDCMP_GADGETUP}         CONST IDCMP_GADGETUP         = $00000040
NATIVE {IDCMP_REQSET}           CONST IDCMP_REQSET           = $00000080
NATIVE {IDCMP_MENUPICK}         CONST IDCMP_MENUPICK         = $00000100
NATIVE {IDCMP_CLOSEWINDOW}      CONST IDCMP_CLOSEWINDOW      = $00000200
NATIVE {IDCMP_RAWKEY}           CONST IDCMP_RAWKEY           = $00000400
NATIVE {IDCMP_REQVERIFY}        CONST IDCMP_REQVERIFY        = $00000800
NATIVE {IDCMP_REQCLEAR}         CONST IDCMP_REQCLEAR         = $00001000
NATIVE {IDCMP_MENUVERIFY}       CONST IDCMP_MENUVERIFY       = $00002000
NATIVE {IDCMP_NEWPREFS}         CONST IDCMP_NEWPREFS         = $00004000
NATIVE {IDCMP_DISKINSERTED}     CONST IDCMP_DISKINSERTED     = $00008000
NATIVE {IDCMP_DISKREMOVED}      CONST IDCMP_DISKREMOVED      = $00010000
NATIVE {IDCMP_WBENCHMESSAGE}    CONST IDCMP_WBENCHMESSAGE    = $00020000 /* System use only */
NATIVE {IDCMP_ACTIVEWINDOW}     CONST IDCMP_ACTIVEWINDOW     = $00040000
NATIVE {IDCMP_INACTIVEWINDOW}   CONST IDCMP_INACTIVEWINDOW   = $00080000
NATIVE {IDCMP_DELTAMOVE}        CONST IDCMP_DELTAMOVE        = $00100000
NATIVE {IDCMP_VANILLAKEY}       CONST IDCMP_VANILLAKEY       = $00200000
NATIVE {IDCMP_INTUITICKS}       CONST IDCMP_INTUITICKS       = $00400000
/*  for notifications from "boopsi" gadgets    */
NATIVE {IDCMP_IDCMPUPDATE}      CONST IDCMP_IDCMPUPDATE      = $00800000 /* new for V36     */
/* for getting help key report during menu session    */
NATIVE {IDCMP_MENUHELP}         CONST IDCMP_MENUHELP         = $01000000 /* new for V36     */
/* for notification of any move/size/zoom/change window       */
NATIVE {IDCMP_CHANGEWINDOW}     CONST IDCMP_CHANGEWINDOW     = $02000000 /* new for V36     */
NATIVE {IDCMP_GADGETHELP}       CONST IDCMP_GADGETHELP       = $04000000 /* new for V39     */
NATIVE {IDCMP_EXTENDEDMOUSE}    CONST IDCMP_EXTENDEDMOUSE    = $08000000 /* new for V51     */
NATIVE {IDCMP_EXTENDEDKEYBOARD} CONST IDCMP_EXTENDEDKEYBOARD = $10000000 /* new for V51     */
NATIVE {IDCMP_RESERVED1}        CONST IDCMP_RESERVED1        = $20000000 /* reserved for IDCMP
                                            * extension scheme */
NATIVE {IDCMP_RESERVED2}        CONST IDCMP_RESERVED2        = $40000000 /* reserved for IDCMP
                                            * extension scheme */

/* NOTEZ-BIEN:                 0x80000000 is reserved for internal use */

/* the IDCMP Flags do not use this special bit, which is cleared when
 * Intuition sends its special message to the Task, and set when Intuition
 * gets its Message back from the Task.  Therefore, I can check here to
 * find out fast whether or not this Message is available for me to send
 */
NATIVE {IDCMP_LONELYMESSAGE}    CONST IDCMP_LONELYMESSAGE    = $80000000


/* --- IDCMP Codes -------------------------------------------------------- */
/* This group of codes is for the IDCMP_CHANGEWINDOW message */
NATIVE {CWCODE_MOVESIZE} CONST CWCODE_MOVESIZE = $0000 /* Window was moved and/or sized */
NATIVE {CWCODE_DEPTH}    CONST CWCODE_DEPTH    = $0001 /* Window was depth-arranged (new for V39) */

/* New for V51: these codes are for the IDCMP_(IN)ACTIVEWINDOW messages */
NATIVE {AWCODE_NORMAL}   CONST AWCODE_NORMAL   = $0000 /* Window did actually change its activation */
NATIVE {AWCODE_INTERIM}  CONST AWCODE_INTERIM  = $0001 /* Window state changed due to toolbox usage */

/* This group of codes is for the IDCMP_MENUVERIFY message */
NATIVE {MENUHOT}         CONST MENUHOT         = $0001 /* IntuiWants verification or MENUCANCEL    */
NATIVE {MENUCANCEL}      CONST MENUCANCEL      = $0002 /* HOT Reply of this cancels Menu operation */
NATIVE {MENUWAITING}     CONST MENUWAITING     = $0003 /* Intuition simply wants a ReplyMsg() ASAP */

/* These are internal tokens to represent state of verification attempts
 * shown here as a clue.
 */
NATIVE {OKOK}            CONST OKOK            = MENUHOT    /* guy didn't care               */
NATIVE {OKABORT}         CONST OKABORT         = $0004     /* window rendered question moot */
NATIVE {OKCANCEL}        CONST OKCANCEL        = MENUCANCEL /* window sent cancel reply      */

/* This group of codes is for the IDCMP_WBENCHMESSAGE messages */
NATIVE {WBENCHOPEN}      CONST WBENCHOPEN      = $0001
NATIVE {WBENCHCLOSE}     CONST WBENCHCLOSE     = $0002

/* A data structure common in V36 Intuition processing */
NATIVE {IBox} OBJECT ibox
    {Left}	left	:INT
    {Top}	top	:INT
    {Width}	width	:INT
    {Height}	height	:INT
ENDOBJECT

/* ======================================================================== */
/* === Window ============================================================= */
/* ======================================================================== */
->"OBJECT window" is on-purposely missing from here (it can be found in 'intuition/intuition_shared1')


/* --- Flags requested at OpenWindow() time by the application --------- */
NATIVE {WFLG_SIZEGADGET}     CONST WFLG_SIZEGADGET     = $00000001 /* include sizing system-gadget?     */
NATIVE {WFLG_DRAGBAR}        CONST WFLG_DRAGBAR        = $00000002 /* include dragging system-gadget?   */
NATIVE {WFLG_DEPTHGADGET}    CONST WFLG_DEPTHGADGET    = $00000004 /* include depth arrangement gadget? */
NATIVE {WFLG_CLOSEGADGET}    CONST WFLG_CLOSEGADGET    = $00000008 /* include close-box system-gadget?  */

NATIVE {WFLG_SIZEBRIGHT}     CONST WFLG_SIZEBRIGHT     = $00000010 /* size gadget uses right border     */
NATIVE {WFLG_SIZEBBOTTOM}    CONST WFLG_SIZEBBOTTOM    = $00000020 /* size gadget uses bottom border    */

/* --- refresh modes ------------------------------------------------------ */
/* combinations of the WFLG_REFRESHBITS select the refresh type */
NATIVE {WFLG_REFRESHBITS}    CONST WFLG_REFRESHBITS    = $000000C0
NATIVE {WFLG_SMART_REFRESH}  CONST WFLG_SMART_REFRESH  = $00000000
NATIVE {WFLG_SIMPLE_REFRESH} CONST WFLG_SIMPLE_REFRESH = $00000040
NATIVE {WFLG_SUPER_BITMAP}   CONST WFLG_SUPER_BITMAP   = $00000080
NATIVE {WFLG_OTHER_REFRESH}  CONST WFLG_OTHER_REFRESH  = $000000C0

NATIVE {WFLG_BACKDROP}       CONST WFLG_BACKDROP       = $00000100 /* this is a backdrop window      */

NATIVE {WFLG_REPORTMOUSE}    CONST WFLG_REPORTMOUSE    = $00000200 /* to hear about every mouse move */

NATIVE {WFLG_GIMMEZEROZERO}  CONST WFLG_GIMMEZEROZERO  = $00000400 /* a GimmeZeroZero window         */

NATIVE {WFLG_BORDERLESS}     CONST WFLG_BORDERLESS     = $00000800 /* to get a Window sans border    */

NATIVE {WFLG_ACTIVATE}       CONST WFLG_ACTIVATE       = $00001000 /* when Window opens, it's Active */

/* --- Other User Flags -------------------------------------------------- */
NATIVE {WFLG_RMBTRAP}        CONST WFLG_RMBTRAP        = $00010000 /* Catch RMB events for your own   */
NATIVE {WFLG_NOCAREREFRESH}  CONST WFLG_NOCAREREFRESH  = $00020000 /* not to be bothered with REFRESH */

/* - V36 new Flags which the programmer may specify in NewWindow.Flags    */
NATIVE {WFLG_NW_EXTENDED}    CONST WFLG_NW_EXTENDED    = $00040000 /* extension data provided        */
                                        /* see struct ExtNewWindow        */

/* - V39 new Flags which the programmer may specify in NewWindow.Flags    */
NATIVE {WFLG_NEWLOOKMENUS}   CONST WFLG_NEWLOOKMENUS   = $00200000 /* window has NewLook menus       */

/* These flags are set only by Intuition.  YOU MAY NOT SET THEM YOURSELF! */
NATIVE {WFLG_WINDOWACTIVE}   CONST WFLG_WINDOWACTIVE   = $00002000 /* this window is the active one  */
NATIVE {WFLG_INREQUEST}      CONST WFLG_INREQUEST      = $00004000 /* this window is in request mode */
NATIVE {WFLG_MENUSTATE}      CONST WFLG_MENUSTATE      = $00008000 /* Window is active with Menus on */
NATIVE {WFLG_WINDOWREFRESH}  CONST WFLG_WINDOWREFRESH  = $01000000 /* Window is currently refreshing */
NATIVE {WFLG_WBENCHWINDOW}   CONST WFLG_WBENCHWINDOW   = $02000000 /* WorkBench tool ONLY Window     */
NATIVE {WFLG_WINDOWTICKED}   CONST WFLG_WINDOWTICKED   = $04000000 /* only one timer tick at a time  */

NATIVE {WFLG_VISITOR}        CONST WFLG_VISITOR        = $08000000 /* visitor window                 */
NATIVE {WFLG_ZOOMED}         CONST WFLG_ZOOMED         = $10000000 /* identifies "zoom state"        */
NATIVE {WFLG_HASZOOM}        CONST WFLG_HASZOOM        = $20000000 /* window has a zoom gadget       */

/* --- Other Window Values ---------------------------------------------- */
NATIVE {DEFAULTMOUSEQUEUE}   CONST DEFAULTMOUSEQUEUE   = (5) /* no more mouse messages */

/* --- see struct IntuiMessage for the IDCMP Flag definitions ------------- */

/* ======================================================================== */
/* === NewWindow ========================================================== */
/* ======================================================================== */
/*
 * Note that the new extension fields have been removed.  Use ExtNewWindow
 * structure below to make use of these fields
 */
NATIVE {NewWindow} OBJECT nw
    {LeftEdge}	leftedge	:INT
	{TopEdge}	topedge	:INT    /* screen dimensions of window */
    {Width}	width	:INT
	{Height}	height	:INT        /* screen dimensions of window */

    {DetailPen}	detailpen	:UBYTE
	{BlockPen}	blockpen	:UBYTE /* for bar/border/gadget rendering */

    {IDCMPFlags}	idcmpflags	:ULONG          /* User-selected IDCMP flags */

    {Flags}	flags	:ULONG               /* see Window struct for defines */

    /* You supply a linked-list of Gadgets for your Window.
     *    This list DOES NOT include system Gadgets.  You get the standard
     *    system Window Gadgets by setting flag-bits in the variable Flags
     *    (see the bit definitions under the Window structure definition)
     */
    {FirstGadget}	firstgadget	:PTR TO gadget

    /* the CheckMark is a pointer to the imagery that will be used when
     * rendering MenuItems of this Window that want to be checkmarked
     * if this is equal to NULL, you'll get the default imagery
     */
    {CheckMark}	checkmark	:PTR TO image

    {Title}	title	:/*STRPTR*/ ARRAY OF CHAR              /* the title text for this window */

    /* the Screen pointer is used only if you've defined a CUSTOMSCREEN and
     * want this Window to open in it.    If so, you pass the address of the
     * Custom Screen structure in this variable.  Otherwise, this variable
     * is ignored and doesn't have to be initialized.
     */
    {Screen}	screen	:PTR TO screen

    /* WFLG_SUPER_BITMAP Window?  If so, put the address of your BitMap
     * structure in this variable.  If not, this variable is ignored and
     * doesn't have to be initialized
     */
    {BitMap}	bitmap	:PTR TO bitmap

    /* the values describe the minimum and maximum sizes of your Windows.
     * these matter only if you've chosen the WFLG_SIZEGADGET option,
     * which means that you want to let the User to change the size of
     * this Window.  You describe the minimum and maximum sizes that the
     * Window can grow by setting these variables.  You can initialize
     * any one these to zero, which will mean that you want to duplicate
     * the setting for that dimension (if MinWidth == 0, MinWidth will be
     * set to the opening Width of the Window).
     * You can change these settings later using SetWindowLimits().
     * If you haven't asked for a SIZING Gadget, you don't have to
     * initialize any of these variables.
     */
    {MinWidth}	minwidth	:INT
	{MinHeight}	minheight	:INT  /* minimums */
    {MaxWidth}	maxwidth	:UINT
	{MaxHeight}	maxheight	:UINT /* maximums */

    /* the type variable describes the Screen in which you want this Window to
     * open.  The type value can either be CUSTOMSCREEN or one of the
     * system standard Screen Types such as WBENCHSCREEN.  See the
     * type definitions under the Screen structure.
     */
    {Type}	type	:UINT
ENDOBJECT

/* The following structure is the future NewWindow.  Compatibility
 * issues require that the size of NewWindow not change.
 * Data in the common part (NewWindow) indicates the the extension
 * fields are being used.
 * NOTE WELL: This structure may be subject to future extension.
 * Writing code depending on its size is not allowed.
 */
NATIVE {ExtNewWindow} OBJECT extnewwindow
    {LeftEdge}	leftedge	:INT
	{TopEdge}	topedge	:INT
    {Width}	width	:INT
	{Height}	height	:INT

    {DetailPen}	detailpen	:UBYTE
	{BlockPen}	blockpen	:UBYTE
    {IDCMPFlags}	idcmpflags	:ULONG
    {Flags}	flags	:ULONG
    {FirstGadget}	firstgadget	:PTR TO gadget

    {CheckMark}	checkmark	:PTR TO image

    {Title}	title	:/*STRPTR*/ ARRAY OF CHAR
    {Screen}	screen	:PTR TO screen
    {BitMap}	bitmap	:PTR TO bitmap

    {MinWidth}	minwidth	:INT
	{MinHeight}	minheight	:INT
    {MaxWidth}	maxwidth	:UINT
	{MaxHeight}	maxheight	:UINT

    /* the type variable describes the Screen in which you want this Window to
     * open.  The type value can either be CUSTOMSCREEN or one of the
     * system standard Screen Types such as WBENCHSCREEN.  See the
     * type definitions under the Screen structure.
     * A new possible value for this field is PUBLICSCREEN, which
     * defines the window as a 'visitor' window.  See below for
     * additional information provided.
     */
    {Type}	type	:UINT

    /* ------------------------------------------------------- *
     * extensions for V36
     * if the NewWindow Flag value WFLG_NW_EXTENDED is set, then
     * this field is assumed to point to an array ( or chain of arrays)
     * of TagItem structures.  See also ExtNewScreen for another
     * use of TagItems to pass optional data.
     *
     * see below for tag values and the corresponding data.
     */
    {Extension}	extension	:ARRAY OF tagitem
ENDOBJECT

/*
 * The TagItem ID's (ti_Tag values) for OpenWindowTagList() follow.
 * They are values in a TagItem array passed as extension/replacement
 * values for the data in NewWindow.  OpenWindowTagList() can actually
 * work well with a NULL NewWindow pointer.
 */

NATIVE {WA_Dummy}             CONST WA_DUMMY             = (TAG_USER + 99) /* 0x80000063 */

/* these tags simply override NewWindow parameters */
NATIVE {WA_Left}              CONST WA_LEFT              = (WA_DUMMY + $01)
NATIVE {WA_Top}               CONST WA_TOP               = (WA_DUMMY + $02)
NATIVE {WA_Width}             CONST WA_WIDTH             = (WA_DUMMY + $03)
NATIVE {WA_Height}            CONST WA_HEIGHT            = (WA_DUMMY + $04)
NATIVE {WA_DetailPen}         CONST WA_DETAILPEN         = (WA_DUMMY + $05)
NATIVE {WA_BlockPen}          CONST WA_BLOCKPEN          = (WA_DUMMY + $06)
NATIVE {WA_IDCMP}             CONST WA_IDCMP             = (WA_DUMMY + $07)
                /* "bulk" initialization of NewWindow.Flags */
NATIVE {WA_Flags}             CONST WA_FLAGS             = (WA_DUMMY + $08)
NATIVE {WA_Gadgets}           CONST WA_GADGETS           = (WA_DUMMY + $09)
NATIVE {WA_Checkmark}         CONST WA_CHECKMARK         = (WA_DUMMY + $0A)
NATIVE {WA_Title}             CONST WA_TITLE             = (WA_DUMMY + $0B)
                /* means you don't have to call SetWindowTitles
                 * after you open your window
                 */
NATIVE {WA_ScreenTitle}       CONST WA_SCREENTITLE       = (WA_DUMMY + $0C)
NATIVE {WA_CustomScreen}      CONST WA_CUSTOMSCREEN      = (WA_DUMMY + $0D)
NATIVE {WA_SuperBitMap}       CONST WA_SUPERBITMAP       = (WA_DUMMY + $0E)
                /* also implies WFLG_SUPER_BITMAP property */
NATIVE {WA_MinWidth}          CONST WA_MINWIDTH          = (WA_DUMMY + $0F)
NATIVE {WA_MinHeight}         CONST WA_MINHEIGHT         = (WA_DUMMY + $10)
NATIVE {WA_MaxWidth}          CONST WA_MAXWIDTH          = (WA_DUMMY + $11)
NATIVE {WA_MaxHeight}         CONST WA_MAXHEIGHT         = (WA_DUMMY + $12)

/* The following are specifications for new features    */

NATIVE {WA_InnerWidth}        CONST WA_INNERWIDTH        = (WA_DUMMY + $13)
NATIVE {WA_InnerHeight}       CONST WA_INNERHEIGHT       = (WA_DUMMY + $14)
                /* You can specify the dimensions of the interior
                 * region of your window, independent of what
                 * the border widths will be.  You probably want
                 * to also specify WA_AutoAdjust to allow
                 * Intuition to move your window or even
                 * shrink it so that it is completely on screen.
                 */

NATIVE {WA_PubScreenName}     CONST WA_PUBSCREENNAME     = (WA_DUMMY + $15)
                /* declares that you want the window to open as
                 * a visitor on the public screen whose name is
                 * pointed to by (STRPTR) ti_Data
                 */
NATIVE {WA_PubScreen}         CONST WA_PUBSCREEN         = (WA_DUMMY + $16)
                /* open as a visitor window on the public screen
                 * whose address is in (struct Screen *) ti_Data.
                 * To ensure that this screen remains open, you
                 * should either be the screen's owner, have a
                 * window open on the screen, or use LockPubScreen().
                 */
NATIVE {WA_PubScreenFallBack} CONST WA_PUBSCREENFALLBACK = (WA_DUMMY + $17)
                /* A Boolean, specifies whether a visitor window
                 * should "fall back" to the default public screen
                 * (or Workbench) if the named public screen isn't
                 * available
                 */
NATIVE {WA_WindowName}        CONST WA_WINDOWNAME        = (WA_DUMMY + $18)
                /* optional name for your window, useful for input
                 * helpers and diagnostic tools to identify the window
                 * when it doesn't have a proper title. (V51)
                 */
NATIVE {WA_Colors}            CONST WA_COLORS            = (WA_DUMMY + $19)
                /* a ColorSpec array for colors to be set
                 * when this window is active.    This is not
                 * implemented, and may not be, since the default
                 * values to restore would be hard to track.
                 * We'd like to at least support per-window colors
                 * for the mouse pointer sprite.
                 */
NATIVE {WA_Zoom}              CONST WA_ZOOM              = (WA_DUMMY + $1A)
                /* ti_Data points to an array of four WORD's,
                 * the initial Left/Top/Width/Height values of
                 * the "alternate" zoom position/dimensions.
                 * It also specifies that you want a Zoom gadget
                 * for your window, whether or not you have a
                 * sizing gadget.
                 */
NATIVE {WA_MouseQueue}        CONST WA_MOUSEQUEUE        = (WA_DUMMY + $1B)
                /* ti_Data contains initial value for the mouse
                 * message backlog limit for this window.
                 */
NATIVE {WA_BackFill}          CONST WA_BACKFILL          = (WA_DUMMY + $1C)
                /* provides a "backfill hook" for your window's Layer.
                 * See layers.library/CreateUpfrontHookLayer().
                 */
NATIVE {WA_RptQueue}          CONST WA_RPTQUEUE          = (WA_DUMMY + $1D)
                /* initial value of repeat key backlog limit */

    /* These Boolean tag items are alternatives to the NewWindow.Flags
     * boolean flags with similar names.
     */
NATIVE {WA_SizeGadget}        CONST WA_SIZEGADGET        = (WA_DUMMY + $1E)
NATIVE {WA_DragBar}           CONST WA_DRAGBAR           = (WA_DUMMY + $1F)
NATIVE {WA_DepthGadget}       CONST WA_DEPTHGADGET       = (WA_DUMMY + $20)
NATIVE {WA_CloseGadget}       CONST WA_CLOSEGADGET       = (WA_DUMMY + $21)
NATIVE {WA_Backdrop}          CONST WA_BACKDROP          = (WA_DUMMY + $22)
NATIVE {WA_ReportMouse}       CONST WA_REPORTMOUSE       = (WA_DUMMY + $23)
NATIVE {WA_NoCareRefresh}     CONST WA_NOCAREREFRESH     = (WA_DUMMY + $24)
NATIVE {WA_Borderless}        CONST WA_BORDERLESS        = (WA_DUMMY + $25)
NATIVE {WA_Activate}          CONST WA_ACTIVATE          = (WA_DUMMY + $26)
NATIVE {WA_RMBTrap}           CONST WA_RMBTRAP           = (WA_DUMMY + $27)
NATIVE {WA_WBenchWindow}      CONST WA_WBENCHWINDOW      = (WA_DUMMY + $28) /* PRIVATE!! */
NATIVE {WA_SimpleRefresh}     CONST WA_SIMPLEREFRESH     = (WA_DUMMY + $29)
                /* only specify if TRUE    */
NATIVE {WA_SmartRefresh}      CONST WA_SMARTREFRESH      = (WA_DUMMY + $2A)
                /* only specify if TRUE    */
NATIVE {WA_SizeBRight}        CONST WA_SIZEBRIGHT        = (WA_DUMMY + $2B)
NATIVE {WA_SizeBBottom}       CONST WA_SIZEBBOTTOM       = (WA_DUMMY + $2C)

    /* New Boolean properties    */
NATIVE {WA_AutoAdjust}        CONST WA_AUTOADJUST        = (WA_DUMMY + $2D)
                /* shift or squeeze the window's position and
                 * dimensions to fit it on screen.
                 */

NATIVE {WA_GimmeZeroZero}     CONST WA_GIMMEZEROZERO     = (WA_DUMMY + $2E)
                /* equiv. to NewWindow.Flags WFLG_GIMMEZEROZERO */

/* New for V37: WA_MenuHelp (ignored by V36) */

NATIVE {WA_MenuHelp}          CONST WA_MENUHELP          = (WA_DUMMY + $2F)
                /* Enables IDCMP_MENUHELP:  Pressing HELP during menus
                 * will return IDCMP_MENUHELP message.
                 */

/* New for V39:  (ignored by V37 and earlier) */

NATIVE {WA_NewLookMenus}      CONST WA_NEWLOOKMENUS      = (WA_DUMMY + $30)
                /* Set to TRUE if you want NewLook menus */
NATIVE {WA_AmigaKey}          CONST WA_AMIGAKEY          = (WA_DUMMY + $31)
                /* Pointer to image for Amiga-key equiv in menus */
NATIVE {WA_NotifyDepth}       CONST WA_NOTIFYDEPTH       = (WA_DUMMY + $32)
                /* Requests IDCMP_CHANGEWINDOW message when
                 * window is depth arranged
                 * (imsg->Code = CWCODE_DEPTH)
                 */

                           /* WA_DUMMY + $33 is obsolete */

NATIVE {WA_Pointer}           CONST WA_POINTER           = (WA_DUMMY + $34)
                /* Allows you to specify a custom pointer
                 * for your window.  ti_Data points to a
                 * pointer object you obtained via
                 * "pointerclass". NULL signifies the
                 * default pointer.
                 * This tag may be passed to OpenWindowTags()
                 * or SetWindowPointer().
                 */

NATIVE {WA_BusyPointer}       CONST WA_BUSYPOINTER       = (WA_DUMMY + $35)
                /* ti_Data is boolean.    Set to TRUE to
                 * request the standard busy pointer.
                 * This tag may be passed to OpenWindowTags()
                 * or SetWindowPointer().
                 */

NATIVE {WA_PointerDelay}      CONST WA_POINTERDELAY      = (WA_DUMMY + $36)
                /* ti_Data is boolean.    Set to TRUE to
                 * request that the changing of the
                 * pointer be slightly delayed.  The change
                 * will be called off if you call NewSetPointer()
                 * before the delay expires.  This allows
                 * you to post a busy-pointer even if you think
                 * the busy-time may be very short, without
                 * fear of a flashing pointer.
                 * This tag may be passed to OpenWindowTags()
                 * or SetWindowPointer().
                 */

NATIVE {WA_TabletMessages}    CONST WA_TABLETMESSAGES    = (WA_DUMMY + $37)
                /* ti_Data is a boolean.  Set to TRUE to
                 * request that tablet information be included
                 * in IntuiMessages sent to your window.
                 * Requires that something (i.e. a tablet driver)
                 * feed IESUBCLASS_NEWTABLET InputEvents into
                 * the system.    For a pointer to the TabletData,
                 * examine the ExtIntuiMessage->eim_TabletData
                 * field.  It is UNSAFE to check this field
                 * when running on pre-V39 systems.  It's always
                 * safe to check this field under V39 and up,
                 * though it may be NULL.
                 */

NATIVE {WA_HelpGroup}         CONST WA_HELPGROUP         = (WA_DUMMY + $38)
                /* When the active window has gadget help enabled,
                 * other windows of the same HelpGroup number
                 * will also get GadgetHelp.  This allows GadgetHelp
                 * to work for multi-windowed applications.
                 * Use GetGroupID() to get an ID number.  Pass
                 * this number as ti_Data to all your windows.
                 * See also the HelpControl() function.
                 */

NATIVE {WA_HelpGroupWindow}   CONST WA_HELPGROUPWINDOW   = (WA_DUMMY + $39)
                /* When the active window has gadget help enabled,
                 * other windows of the same HelpGroup will also get
                 * GadgetHelp.    This allows GadgetHelp to work
                 * for multi-windowed applications.  As an alternative
                 * to WA_HelpGroup, you can pass a pointer to any
                 * other window of the same group to join its help
                 * group.  Defaults to NULL, which has no effect.
                 * See also the HelpControl() function.
                 */

/* New for V50:  (ignored by V40 and earlier) */

NATIVE {WA_UserPort}          CONST WA_USERPORT          = (WA_DUMMY + $3a)
                /* (struct MsgPort *) A shared idcmp port, Intuition will not
                 * attempt to delete this port in ModifyIDCMP() or
                 * CloseWindow(). The CloseWindow() routine also takes care of
                 * stripping off all intuimessages that belong to the
                 * given window. V50.
                 */

NATIVE {WA_WindowBox}         CONST WA_WINDOWBOX         = (WA_DUMMY + $3b)
                /* (struct IBox *) An alternative way of specifying the
                 * window position and size. V50.
                 */

NATIVE {WA_Hidden}            CONST WA_HIDDEN            = (WA_DUMMY + $3c)
                /* (BOOL) if TRUE, the window will open in hidden state.
                 * V50.
                 */

NATIVE {WA_ToolBox}           CONST WA_TOOLBOX           = (WA_DUMMY + $3d)
                /* (BOOL) if TRUE, the window can't be activated. ToolBox
                 * windows send gadget messages. V50.
                 */

NATIVE {WA_Reserved1}         CONST WA_RESERVED1         = (WA_DUMMY + $3e)
                /* Reserved for system use. V50. */

NATIVE {WA_MenuHook}          CONST WA_MENUHOOK          = (WA_DUMMY + $3f)
                /* (struct Hook *) Hook to call when user requests the
                 * menu of the window. V50.
                 * a0 (struct Hook *)       - your hook
                 * a2 (APTR)                - reserved for future use.
                 * a1 (struct IntuiMessage) - an intuimessage.
                 */

NATIVE {WA_AutoAdjustDClip}   CONST WA_AUTOADJUSTDCLIP   = (WA_DUMMY + $40)
                /* (BOOL) Like WA_AutoAdjust but moves the window
                 * onto the DClip. V50.
                 */

NATIVE {WA_ShapeRegion}       CONST WA_SHAPEREGION       = (WA_DUMMY + $41)
                /* (struct Region *) Region describing the shape of the
                 * window. See layers.library. V50.
                 */

NATIVE {WA_ShapeHook}         CONST WA_SHAPEHOOK         = (WA_DUMMY + $42)
                /* (struct Hook *) Hook providing the shape of the window
                 * on the fly. V50.
                 */

NATIVE {WA_InFrontOf}         CONST WA_INFRONTOF         = (WA_DUMMY + $43)
                /* (struct Window *) Open the window in front of the given
                 * window. V50.
                 */

NATIVE {WA_GrabFocus}         CONST WA_GRABFOCUS         = (WA_DUMMY + $44)
                /* (ULONG) When the window is active, limit mousepointer
                 * movements to the window area. The number given is the
                 * time (in intuiticks) this restriction will apply. This
                 * is so to give back full control to the user even when
                 * your application has crashed. The SetWindowAttrs()
                 * function allows you to set this feature at any time.
                 * A value of 0 disables it. The maximum value is 100.
                 */

NATIVE {WA_StayTop}           CONST WA_STAYTOP           = (WA_DUMMY + $45)
                /* (BOOL) Make this window to always stay in front of all
                 * others. V50.
                 */

NATIVE {WA_MouseLimits}       CONST WA_MOUSELIMITS       = (WA_DUMMY + $46)
                /* (struct IBox *) This tag works together with WA_GrabFocus
                 * and allows you to specify the working area of the mouse
                 * pointer. The coordinates are relative to the upper left
                 * corner of the window.
                 */

NATIVE {WA_NoMenuKeyVerify}   CONST WA_NOMENUKEYVERIFY   = (WA_DUMMY + $47)
                /* (BOOL) Restrict usage of menu verification for this window
                 * to mouse menu events only, letting keyboard shortcuts pass
                 * through. Ignored if IDCMP_MENUVERIFY is not set. V51.
                 */

NATIVE {WA_Reserved2}         CONST WA_RESERVED2         = (WA_DUMMY + $48)
                /* Reserved for system use. V51. */

/*
 * Special codes for ShowWindow() and WA_InFrontOf:
 * Give this as target window where to move your window to.
 */

NATIVE {WINDOW_BACKMOST}  CONST WINDOW_BACKMOST  = 0!!VALUE!!PTR TO window
NATIVE {WINDOW_FRONTMOST} CONST WINDOW_FRONTMOST = 1!!VALUE!!PTR TO window

/* HelpControl() flags:
 *
 * HC_GADGETHELP - Set this flag to enable Gadget-Help for one or more
 * windows.
 */

NATIVE {HC_GADGETHELP} CONST HC_GADGETHELP = (1)

/* IntuitionControlA() tags:
 */

NATIVE {ICTRL_Dummy} CONST ICTRL_DUMMY = (TAG_USER + $1C000)

/* No public tags defined so far */


/* ======================================================================== */
/* === Remember =========================================================== */
/* ======================================================================== */
/* this structure is used for remembering what memory has been allocated to
 * date by a given routine, so that a premature abort or systematic exit
 * can deallocate memory cleanly, easily, and completely
 */
NATIVE {Remember} OBJECT remember
    {NextRemember}	nextremember	:PTR TO remember
    {RememberSize}	remembersize	:ULONG
    {Memory}	memory	:PTR TO UBYTE
ENDOBJECT

/* === Color Spec ====================================================== */
/* How to tell Intuition about RGB values for a color table entry.
 * NOTE:  The way the structure was defined, the color value was
 * right-justified within each UWORD.  This poses problems for
 * extensibility to more bits-per-gun.    The SA_Colors32 tag to
 * OpenScreenTags() provides an alternate way to specify colors
 * with greater precision.
 */
NATIVE {ColorSpec} OBJECT colorspec
    {ColorIndex}	colorindex	:INT /* -1 terminates an array of ColorSpec */
    {Red}	red	:UINT        /* only the _bottom_ 4 bits recognized */
    {Green}	green	:UINT      /* only the _bottom_ 4 bits recognized */
    {Blue}	blue	:UINT       /* only the _bottom_ 4 bits recognized */
ENDOBJECT

/* === Easy Requester Specification ======================================= */
/* see also autodocs for EasyRequest and BuildEasyRequest */
/* NOTE: This structure may grow in size in the future    */
/* NOTE: This structure actually grew in size for V50     */

NATIVE {EasyStruct} OBJECT easystruct
    {es_StructSize}	structsize	:ULONG   /* should be sizeof (struct EasyStruct) */
    {es_Flags}	flags	:ULONG        /* see definitions below                */
    {es_Title}	title	:/*STRPTR*/ ARRAY OF CHAR        /* title of requester window            */
    {es_TextFormat}	textformat	:/*STRPTR*/ ARRAY OF CHAR   /* 'printf' style formatting string     */
    {es_GadgetFormat}	gadgetformat	:/*STRPTR*/ ARRAY OF CHAR /* 'printf' style formatting string     */
    {es_Screen}	screen	:PTR TO screen       /* screen to open on (new for V50)      */
    {es_TagList}	taglist	:ARRAY OF tagitem      /* additional information (new for V50) */
ENDOBJECT

/* EasyRequester flags */
NATIVE {ESF_SCREEN}   CONST ESF_SCREEN   = $00000001 /* Open on the screen specified in es_Screen */
NATIVE {ESF_TAGGED}   CONST ESF_TAGGED   = $00000002 /* Apply attributes specified in es_TagList  */
NATIVE {ESF_EVENSIZE} CONST ESF_EVENSIZE = $00000004 /* Make all requester buttons equally wide   */
NATIVE {ESF_INACTIVE} CONST ESF_INACTIVE = $00000008 /* Open requester window in inactive state   */

/* EasyRequester tags */
NATIVE {ESA_Dummy}      CONST ESA_DUMMY      = ($00340000)
NATIVE {ESA_Position}   CONST ESA_POSITION   = (ESA_DUMMY + 1) /* Where the requester will open */
NATIVE {ESA_Underscore} CONST ESA_UNDERSCORE = (ESA_DUMMY + 2) /* Underscore character          */

/* Values for ESA_Position */

NATIVE {REQPOS_DEFAULT}      CONST REQPOS_DEFAULT      = 0 /* Place according to user's GUI preferences  */
NATIVE {REQPOS_CORNER}       CONST REQPOS_CORNER       = 1 /* Place at top left corner                   */
NATIVE {REQPOS_BELOWBAR}     CONST REQPOS_BELOWBAR     = 2 /* Place at top left corner, below screen bar */
NATIVE {REQPOS_CENTERMOUSE}  CONST REQPOS_CENTERMOUSE  = 3 /* Center under mouse pointer                 */
NATIVE {REQPOS_CENTERSCREEN} CONST REQPOS_CENTERSCREEN = 4 /* Center in visible screen clip              */
NATIVE {REQPOS_CENTERWINDOW} CONST REQPOS_CENTERWINDOW = 5 /* Center in reference window                 */


/* === Gradient Specification ========================================== */
/* This is the structure you pass to DrawGradient(). The Direction field */
/* tells Intuition the orientation of the gradient; the Mode field is a  */
/* combination of gradient type and flags (see definitions below).       */
/* Depending on the type, either the Rel or Abs specifications are used; */
/* Rel is used for the SIMPLE and SHADE types, Abs for the COLOR type.   */
/* In the case of Rel, the Contrast values indicate the dark and bright  */
/* shading percentages for the opposite ends of the gradient, to be      */
/* applied to the BasePen color (SIMPLE) or to the background (SHADE).   */
/* Contrast values of 0, 0 produce no gradient at all, whereas contrast  */
/* values of 255, 255 produce a black-to-white gradient.                 */

NATIVE {GradientSpec} OBJECT gradientspec
    {Direction}	direction	:ULONG /* X:Y ratio as returned by DirectionVector(angle) */
    {Mode}	mode	:UINT      /* See definitions below */
    {Specs.Rel.BasePen}	relbasepen	:UINT     /* Base DrawInfo pen to be shaded */
    {Specs.Rel.Contrast}	relcontrast[2]	:ARRAY OF UBYTE /* Shade levels for gradient ends */
    {Specs.Abs.RGBStart}	absrgbstart[3]	:ARRAY OF UBYTE /* Starting color of gradient */
    {Specs.Abs.RGBEnd}	absrgbend[3]	:ARRAY OF UBYTE   /* Ending color of gradient */
    {Reserved}	reserved[4]	:ARRAY OF UBYTE         /* For future use, leave to zero */
ENDOBJECT

NATIVE {GRADSPEC} CONST

/* Gradient modes (type and flags packed in a single word) */

NATIVE {GRADMODE_TYPEMASK} CONST GRADMODE_TYPEMASK = $000F  /* Mask for type extraction */

NATIVE {GRADMODE_NONE}      CONST GRADMODE_NONE      = $0000
   /* Don't draw any gradient */

NATIVE {GRADMODE_SIMPLE}    CONST GRADMODE_SIMPLE    = $0001
   /* Shades of BasePen, from Contrast[0] to Contrast[1] */

NATIVE {GRADMODE_COLOR}     CONST GRADMODE_COLOR     = $0002
   /* Shades of color, from RGBStart to RGBEnd */

NATIVE {GRADMODE_SHADE}     CONST GRADMODE_SHADE     = $0003
   /* Shades of background, from Contrast[0] to Contrast[1] */

NATIVE {GRADMODE_IMPOSE}    CONST GRADMODE_IMPOSE    = $0100
   /* Superimpose gradient to existing background */

NATIVE {GRADMODE_KEEPRATIO} CONST GRADMODE_KEEPRATIO = $0200
   /* Don't scale gradient to domain aspect ratio */

NATIVE {GRADMODE_PALETTE}   CONST GRADMODE_PALETTE   = $0400
   /* Rel.BasePen is a palette index, not a DrawInfo pen index */

NATIVE {GRADMODE_INVERT1}   CONST GRADMODE_INVERT1   = $1000
   /* Invert the meaning of Contrast[0] (brighten rather than darken) */

NATIVE {GRADMODE_INVERT2}   CONST GRADMODE_INVERT2   = $2000
   /* Invert the meaning of Contrast[1] (darken rather than brighten) */

/* ======================================================================== */
/* === Miscellaneous ====================================================== */
/* ======================================================================== */

/* = MACROS =============================================================== */
NATIVE {MENUNUM} CONST	->MENUNUM(n)   (n & 0x1F)
NATIVE {ITEMNUM} CONST	->ITEMNUM(n)   ((n >> 5) & 0x003F)
NATIVE {SUBNUM} CONST	->SUBNUM(n)    ((n >> 11) & 0x001F)

NATIVE {SHIFTMENU} CONST	->SHIFTMENU(n) (n & 0x1F)
NATIVE {SHIFTITEM} CONST	->SHIFTITEM(n) ((n & 0x3F) << 5)
NATIVE {SHIFTSUB} CONST	->SHIFTSUB(n)  ((n & 0x1F) << 11)

NATIVE {FULLMENUNUM} CONST	->FULLMENUNUM( menu, item, sub ) ( SHIFTSUB(sub) | SHIFTITEM(item) | SHIFTMENU(menu) )

NATIVE {SRBNUM} CONST	->SRBNUM(n)    (0x08 - (n >> 4))  /* SerRWBits  -> read bits per char */
NATIVE {SWBNUM} CONST	->SWBNUM(n)    (0x08 - (n & 0x0F))/* SerRWBits  -> write bits per chr */
NATIVE {SSBNUM} CONST	->SSBNUM(n)    (0x01 + (n >> 4))  /* SerStopBuf -> stop bits per chr  */
NATIVE {SPARNUM} CONST	->SPARNUM(n)   (n >> 4)           /* SerParShk  -> parity setting     */
NATIVE {SHAKNUM} CONST	->SHAKNUM(n)   (n & 0x0F)         /* SerParShk  -> handshake mode     */

#define MENUNUM(n) ((n) AND $1F)
#define ITEMNUM(n) (Shr((n),5) AND $3F)
#define SUBNUM(n)  (Shr((n),11) AND $1F)

#define SHIFTMENU(n) ((n) AND $1F)
#define SHIFTITEM(n) (Shl((n) AND $3F,5))
#define SHIFTSUB(n)  (Shl((n) AND $1F,11))

#define FULLMENUNUM(menu,item,sub) (SHIFTSUB(sub) OR SHIFTITEM(item) OR SHIFTMENU(menu))

#define SRBNUM(n)  (8-Shr((n),4))
#define SWBNUM(n)  (8-((n) AND $F))
#define SSBNUM(n)  (1+Shr((n),4))
#define SPARNUM(n) (Shr((n),4))
#define SHAKNUM(n) ((n) AND $F)

/* = MENU STUFF =========================================================== */
NATIVE {NOMENU}   CONST NOMENU   = $001F
NATIVE {NOITEM}   CONST NOITEM   = $003F
NATIVE {NOSUB}    CONST NOSUB    = $001F
NATIVE {MENUNULL} CONST MENUNULL = $FFFF

/* = =RJ='s peculiarities ================================================= */
 /* Note that these macros may one day go away! */
 NATIVE {FOREVER} CONST ->FOREVER = for(;;)
 NATIVE {SIGN} CONST	->SIGN(x) ( ((x) > 0) - ((x) < 0) )
 NATIVE {NOT} CONST ->NOT = !

/* these defines are for the COMMSEQ and CHECKIT menu stuff.  If CHECKIT,
 * I'll use a generic Width (for all resolutions) for the CheckMark.
 * If COMMSEQ, likewise I'll use this generic stuff
 */
NATIVE {CHECKWIDTH}    CONST CHECKWIDTH    = 19
NATIVE {COMMWIDTH}     CONST COMMWIDTH     = 27
NATIVE {LOWCHECKWIDTH} CONST LOWCHECKWIDTH = 13
NATIVE {LOWCOMMWIDTH}  CONST LOWCOMMWIDTH  = 16

/* these are the AlertNumber defines.  if you are calling DisplayAlert()
 * the AlertNumber you supply must have the ALERT_TYPE bits set to one
 * of these patterns
 */
NATIVE {ALERT_TYPE}     CONST ALERT_TYPE     = $80000000
NATIVE {RECOVERY_ALERT} CONST RECOVERY_ALERT = $00000000 /* the system can recover from this */
NATIVE {DEADEND_ALERT}  CONST DEADEND_ALERT  = $80000000 /* no recovery possible, this is it */

/* When you're defining IntuiText for the Positive and Negative Gadgets
 * created by a call to AutoRequest(), these defines will get you
 * reasonable-looking text.  The only field without a define is the IText
 * field; you decide what text goes with the Gadget
 */
NATIVE {AUTOFRONTPEN}  CONST AUTOFRONTPEN  = 0
NATIVE {AUTOBACKPEN}   CONST AUTOBACKPEN   = 1
NATIVE {AUTODRAWMODE}  CONST AUTODRAWMODE  = RP_JAM2
NATIVE {AUTOLEFTEDGE}  CONST AUTOLEFTEDGE  = 6
NATIVE {AUTOTOPEDGE}   CONST AUTOTOPEDGE   = 3
NATIVE {AUTOITEXTFONT} CONST AUTOITEXTFONT = NIL
NATIVE {AUTONEXTTEXT}  CONST AUTONEXTTEXT  = NIL

/* --- RAWMOUSE Codes and Qualifiers (Console OR IDCMP) ------------------- */
NATIVE {SELECTUP}     CONST SELECTUP     = (IECODE_LBUTTON OR IECODE_UP_PREFIX)
NATIVE {SELECTDOWN}   CONST SELECTDOWN   = (IECODE_LBUTTON)
NATIVE {MENUUP}       CONST MENUUP       = (IECODE_RBUTTON OR IECODE_UP_PREFIX)
NATIVE {MENUDOWN}     CONST MENUDOWN     = (IECODE_RBUTTON)
NATIVE {MIDDLEUP}     CONST MIDDLEUP     = (IECODE_MBUTTON OR IECODE_UP_PREFIX)
NATIVE {MIDDLEDOWN}   CONST MIDDLEDOWN   = (IECODE_MBUTTON)
NATIVE {ALTLEFT}      CONST ALTLEFT      = (IEQUALIFIER_LALT)
NATIVE {ALTRIGHT}     CONST ALTRIGHT     = (IEQUALIFIER_RALT)
NATIVE {AMIGALEFT}    CONST AMIGALEFT    = (IEQUALIFIER_LCOMMAND)
NATIVE {AMIGARIGHT}   CONST AMIGARIGHT   = (IEQUALIFIER_RCOMMAND)
NATIVE {AMIGAKEYS}    CONST AMIGAKEYS    = (AMIGALEFT OR AMIGARIGHT)

NATIVE {CURSORUP}     CONST CURSORUP     = $4C /* Same as RAWKEY_CRSRUP    */
NATIVE {CURSORLEFT}   CONST CURSORLEFT   = $4F /* Same as RAWKEY_CRSRLEFT  */
NATIVE {CURSORRIGHT}  CONST CURSORRIGHT  = $4E /* Same as RAWKEY_CRSRRIGHT */
NATIVE {CURSORDOWN}   CONST CURSORDOWN   = $4D /* Same as RAWKEY_CRSRDOWN  */
/* WARNING: The following codes are for the US keyboard only */
NATIVE {KEYCODE_Q}    CONST KEYCODE_Q    = $10
NATIVE {KEYCODE_Z}    CONST KEYCODE_Z    = $31
NATIVE {KEYCODE_X}    CONST KEYCODE_X    = $32
NATIVE {KEYCODE_V}    CONST KEYCODE_V    = $34
NATIVE {KEYCODE_B}    CONST KEYCODE_B    = $35
NATIVE {KEYCODE_N}    CONST KEYCODE_N    = $36
NATIVE {KEYCODE_M}    CONST KEYCODE_M    = $37
NATIVE {KEYCODE_LESS}    CONST KEYCODE_LESS    = $38
NATIVE {KEYCODE_GREATER} CONST KEYCODE_GREATER = $39

/* New for V39, Intuition supports the IESUBCLASS_NEWTABLET subclass
 * of the IECLASS_NEWPOINTERPOS event.    The ie_EventAddress of such
 * an event points to a TabletData structure (see below).
 *
 * The TabletData structure contains certain elements including a taglist.
 * The taglist can be used for special tablet parameters.  A tablet driver
 * should include only those tag-items the tablet supports.  An application
 * can listen for any tag-items that interest it.  Note: an application
 * must set the WA_TabletMessages attribute to TRUE to receive this
 * extended information in its IntuiMessages.
 *
 * The definitions given here MUST be followed.  Pay careful attention
 * to normalization and the interpretation of signs.
 *
 * TABLETA_TabletZ:  the current value of the tablet in the Z direction.
 * This unsigned value should typically be in the natural units of the
 * tablet.  You should also provide TABLETA_RangeZ.
 *
 * TABLETA_RangeZ:  the maximum value of the tablet in the Z direction.
 * Normally specified along with TABLETA_TabletZ, this allows the
 * application to scale the actual Z value across its range.
 *
 * TABLETA_AngleX:  the angle of rotation or tilt about the X-axis.  This
 * number should be normalized to fill a signed long integer.  Positive
 * values imply a clockwise rotation about the X-axis when viewing
 * from +X towards the origin.
 *
 * TABLETA_AngleY:  the angle of rotation or tilt about the Y-axis.  This
 * number should be normalized to fill a signed long integer.  Positive
 * values imply a clockwise rotation about the Y-axis when viewing
 * from +Y towards the origin.
 *
 * TABLETA_AngleZ:  the angle of rotation or tilt about the Z axis.  This
 * number should be normalized to fill a signed long integer.  Positive
 * values imply a clockwise rotation about the Z-axis when viewing
 * from +Z towards the origin.
 *
 *    Note: a stylus that supports tilt should use the TABLETA_AngleX
 *    and TABLETA_AngleY attributes.    Tilting the stylus so the tip
 *    points towards increasing or decreasing X is actually a rotation
 *    around the Y-axis.  Thus, if the stylus tip points towards
 *    positive X, then that tilt is represented as a negative
 *    TABLETA_AngleY.  Likewise, if the stylus tip points towards
 *    positive Y, that tilt is represented by positive TABLETA_AngleX.
 *
 * TABLETA_Pressure:  the pressure reading of the stylus.  The pressure
 * should be normalized to fill a signed long integer.    Typical devices
 * won't generate negative pressure, but the possibility is not precluded.
 * The pressure threshold which is considered to cause a button-click is
 * expected to be set in a Preferences program supplied by the tablet
 * vendor.  The tablet driver would send IECODE_LBUTTON-type events as
 * the pressure crossed that threshold.
 *
 * TABLETA_ButtonBits:    ti_Data is a long integer whose bits are to
 * be interpreted at the state of the first 32 buttons of the tablet.
 *
 * TABLETA_InProximity:  ti_Data is a boolean.    For tablets that support
 * proximity, they should send the {TABLETA_InProximity,FALSE} tag item
 * when the stylus is out of proximity.  One possible use we can forsee
 * is a mouse-blanking commodity which keys off this to blank the
 * mouse.  When this tag is absent, the stylus is assumed to be
 * in proximity.
 *
 * TABLETA_ResolutionX:  ti_Data is an unsigned long integer which
 * is the x-axis resolution in dots per inch.
 *
 * TABLETA_ResolutionY:  ti_Data is an unsigned long integer which
 * is the y-axis resolution in dots per inch.
 */

NATIVE {TABLETA_Dummy}       CONST TABLETA_DUMMY       = (TAG_USER + $3A000)
NATIVE {TABLETA_TabletZ}     CONST TABLETA_TABLETZ     = (TABLETA_DUMMY + $01)
NATIVE {TABLETA_RangeZ}      CONST TABLETA_RANGEZ      = (TABLETA_DUMMY + $02)
NATIVE {TABLETA_AngleX}      CONST TABLETA_ANGLEX      = (TABLETA_DUMMY + $03)
NATIVE {TABLETA_AngleY}      CONST TABLETA_ANGLEY      = (TABLETA_DUMMY + $04)
NATIVE {TABLETA_AngleZ}      CONST TABLETA_ANGLEZ      = (TABLETA_DUMMY + $05)
NATIVE {TABLETA_Pressure}    CONST TABLETA_PRESSURE    = (TABLETA_DUMMY + $06)
NATIVE {TABLETA_ButtonBits}  CONST TABLETA_BUTTONBITS  = (TABLETA_DUMMY + $07)
NATIVE {TABLETA_InProximity} CONST TABLETA_INPROXIMITY = (TABLETA_DUMMY + $08)
NATIVE {TABLETA_ResolutionX} CONST TABLETA_RESOLUTIONX = (TABLETA_DUMMY + $09)
NATIVE {TABLETA_ResolutionY} CONST TABLETA_RESOLUTIONY = (TABLETA_DUMMY + $0A)

/* If your window sets WA_TabletMessages to TRUE, then it will receive
 * extended IntuiMessages (struct ExtIntuiMessage) whose eim_TabletData
 * field points at a TabletData structure.  This structure contains
 * additional information about the input event.
 */

NATIVE {TabletData} OBJECT tabletdata
    /* Sub-pixel position of tablet, in screen coordinates,
     * scaled to fill a UWORD fraction:
     */
    {td_XFraction}	xfraction	:UINT
	{td_YFraction}	yfraction	:UINT

    /* Current tablet coordinates along each axis: */
    {td_TabletX}	tabletx	:ULONG
	{td_TabletY}	tablety	:ULONG

    /* Tablet range along each axis.  For example, if td_TabletX
     * can take values 0-999, td_RangeX should be 1000.
     */
    {td_RangeX}	rangex	:ULONG
	{td_RangeY}	rangey	:ULONG

    /* Pointer to tag-list of additional tablet attributes.
     * See <intuition/intuition.h> for the tag values.
     */
    {td_TagList}	taglist	:ARRAY OF tagitem
ENDOBJECT

/* If a tablet driver supplies a hook for ient_CallBack, it will be
 * invoked in the standard hook manner.  A0 will point to the Hook
 * itself, A2 will point to the InputEvent that was sent, and
 * A1 will point to a TabletHookData structure.  The InputEvent's
 * ie_EventAddress field points at the IENewTablet structure that
 * the driver supplied.
 *
 * Based on the thd_Screen, thd_Width, and thd_Height fields, the driver
 * should scale the ient_TabletX and ient_TabletY fields and store the
 * result in ient_ScaledX, ient_ScaledY, ient_ScaledXFraction, and
 * ient_ScaledYFraction.
 *
 * The tablet hook must currently return NULL.    This is the only
 * acceptable return-value under V39.
 */

NATIVE {TabletHookData} OBJECT tablethookdata
    /* Pointer to the active screen:
     * Note: if there are no open screens, thd_Screen will be NULL.
     * thd_Width and thd_Height will then describe an NTSC 640x400
     * screen.    Please scale accordingly.
     */
    {thd_Screen}	screen	:PTR TO screen

    /* The width and height (measured in pixels of the active screen)
     * that your are to scale to:
     */
    {thd_Width}	width	:ULONG
    {thd_Height}	height	:ULONG

    /* Non-zero if the screen or something about the screen
     * changed since the last time you were invoked:
     */
    {thd_ScreenChanged}	screenchanged	:VALUE
ENDOBJECT

/* ======================================================================== */
/* === DoScrollHook() specifications (V50) ================================ */
/* ======================================================================== */

/* Hook function with extra data; invoked when one of the scrolling
 * operations are to be performed.
 */
NATIVE {ScrollHook} OBJECT scrollhook
    {sh_Hook}	hook	:hook

    {sh_Top}	top	:VALUE     /* This is the number of the first
                               visible item. */
    {sh_Total}	total	:VALUE   /* This is the total number of items
                               available for display. */
    {sh_Visible}	visible	:VALUE /* This is how many entries can be
                               visible at a time. */
    {sh_Size}	size	:VALUE    /* This is how many pixels high/wide
                               each item is. */
ENDOBJECT

/****************************************************************************/

/* The message passed to your scrolling function. The action to perform is
 * in the sm_Action field.
 */
NATIVE {ScrollMsg} OBJECT scrollmsg
    {sm_Action}	action	:ULONG    /* The action to perform */

    {sm_NumItems}	numitems	:VALUE  /* Number of items to render */
    {sm_NumPixels}	numpixels	:VALUE /* Number of pixels to scroll */
    {sm_TopItem}	topitem	:VALUE   /* The first visible item */
    {sm_TopPixel}	toppixel	:VALUE  /* The first visible pixel */
ENDOBJECT

/* Scrolling actions to perform. */
NATIVE {SMA_GetScrollerTop} CONST SMA_GETSCROLLERTOP = 0 /* Return the number of the first
                              * visible line.
                              */

NATIVE {SMA_RedrawAll}      CONST SMA_REDRAWALL      = 1 /* Redraw the entire display. */

NATIVE {SMA_Scroll}         CONST SMA_SCROLL         = 2 /* Scroll the display; the number of
                              * pixels to scroll is stored in the
                              * sm_NumPixels field. Return whether
                              * the scrolling operation produced
                              * layer damage which needs to be
                              * repaired.
                              */

NATIVE {SMA_Draw}           CONST SMA_DRAW           = 3 /* Draw a portion of the display. The
                              * number of lines to print is in the
                              * sm_NumItems field. The pixel position
                              * to start drawing at is in the
                              * sm_TopPixel field. The first
                              * line to print is in the
                              * sm_TopItem field.
                              */

NATIVE {SMA_RepairDamage}   CONST SMA_REPAIRDAMAGE   = 4 /* Same as SMA_Draw except that the drawing
                              * operations must be performed between
                              * BeginRefresh() and EndRefresh().
                              */

/****************************************************************************/

/* How to perform the scrolling operation (this is the scroll mode
 * parameter of the DoScrollHook() function.
 */
NATIVE {DSHM_Smooth} CONST DSHM_SMOOTH = 0 /* Scroll smoothly */
NATIVE {DSHM_Jump}   CONST DSHM_JUMP   = 1 /* Jump straight to the requested display position. */
