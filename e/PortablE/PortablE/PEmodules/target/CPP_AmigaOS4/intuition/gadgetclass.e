/* $Id: gadgetclass.h,v 1.21 2005/12/23 19:38:25 mtantignone Exp $ */
OPT NATIVE
MODULE 'target/intuition/intuition', 'target/utility/tagitem', 'target/intuition/iobsolete'
MODULE 'target/intuition/cghooks', 'target/graphics/rastport', 'target/devices/inputevent', 'target/graphics/regions', 'target/exec/types'
{#include <intuition/gadgetclass.h>}
NATIVE {INTUITION_GADGETCLASS_H} CONST

/* Gadget class attributes */
NATIVE {GA_Dummy}            CONST GA_DUMMY            = (TAG_USER+$30000)

NATIVE {GA_Left}             CONST GA_LEFT             = (GA_DUMMY+1)
    /* (LONG) Left edge of the gadget relative to the left edge of
     * the window */

NATIVE {GA_RelRight}         CONST GA_RELRIGHT         = (GA_DUMMY+2)
    /* (LONG) Left edge of the gadget relative to the right edge of
     * the window */

NATIVE {GA_Top}              CONST GA_TOP              = (GA_DUMMY+3)
    /* (LONG) Top edge of the gadget relative to the top edge of
     * the window */

NATIVE {GA_RelBottom}        CONST GA_RELBOTTOM        = (GA_DUMMY+4)
    /* (LONG) Top edge of the gadget relative to the bottom edge
     * of the window */

NATIVE {GA_Width}            CONST GA_WIDTH            = (GA_DUMMY+5)
    /* (LONG) Width of the gadget */

NATIVE {GA_RelWidth}         CONST GA_RELWIDTH         = (GA_DUMMY+6)
    /* (LONG) Width of the gadget relative to the width of the
     * window */

NATIVE {GA_Height}           CONST GA_HEIGHT           = (GA_DUMMY+7)
    /* (LONG) Height of the gadget */

NATIVE {GA_RelHeight}        CONST GA_RELHEIGHT        = (GA_DUMMY+8)
    /* (LONG) Height of the gadget relative to the height of
     * the window */

NATIVE {GA_Text}             CONST GA_TEXT             = (GA_DUMMY+9)
    /* (STRPTR) Gadget imagry is NULL terminated string */

NATIVE {GA_Image}            CONST GA_IMAGE            = (GA_DUMMY+10)
    /* (struct Image *) Gadget imagry is an image */

NATIVE {GA_Border}           CONST GA_BORDER           = (GA_DUMMY+11)
    /* (struct Border *) Gadget imagry is a border */

NATIVE {GA_SelectRender}     CONST GA_SELECTRENDER     = (GA_DUMMY+12)
    /* (struct Image *) Selected gadget imagry */

NATIVE {GA_Highlight}        CONST GA_HIGHLIGHT        = (GA_DUMMY+13)
    /* (UWORD) One of GFLG_GADGHNONE, GFLG_GADGHBOX, GFLG_GADGHCOMP,
     * or GFLG_GADGHIMAGE */

NATIVE {GA_Disabled}         CONST GA_DISABLED         = (GA_DUMMY+14)
    /* (BOOL) Indicate whether gadget is disabled or not.
     * Defaults to FALSE. */

NATIVE {GA_GZZGadget}        CONST GA_GZZGADGET        = (GA_DUMMY+15)
    /* (BOOL) Indicate whether the gadget is for
     * WFLG_GIMMEZEROZERO window borders or not.  Defaults
     * to FALSE. */

NATIVE {GA_ID}               CONST GA_ID               = (GA_DUMMY+16)
    /* (UWORD) Gadget ID assigned by the application */

NATIVE {GA_UserData}         CONST GA_USERDATA         = (GA_DUMMY+17)
    /* (APTR) Application specific data */

NATIVE {GA_SpecialInfo}      CONST GA_SPECIALINFO      = (GA_DUMMY+18)
    /* (APTR) Gadget specific data */

NATIVE {GA_Selected}         CONST GA_SELECTED         = (GA_DUMMY+19)
    /* (BOOL) Indicate whether the gadget is selected or not.
     * Defaults to FALSE */

NATIVE {GA_EndGadget}        CONST GA_ENDGADGET        = (GA_DUMMY+20)
    /* (BOOL) When set tells the system that when this gadget
     * is selected causes the requester that it is in to be
     * ended.  Defaults to FALSE. */

NATIVE {GA_Immediate}        CONST GA_IMMEDIATE        = (GA_DUMMY+21)
    /* (BOOL) When set indicates that the gadget is to
     * notify the application when it becomes active.  Defaults
     * to FALSE. */

NATIVE {GA_RelVerify}        CONST GA_RELVERIFY        = (GA_DUMMY+22)
    /* (BOOL) When set indicates that the application wants to
     * verify that the pointer was still over the gadget when
     * the select button is released.  Defaults to FALSE. */

NATIVE {GA_FollowMouse}      CONST GA_FOLLOWMOUSE      = (GA_DUMMY+23)
    /* (BOOL) When set indicates that the application wants to
     * be notified of mouse movements while the gadget is active.
     * It is recommmended that GA_Immediate and GA_RelVerify are
     * also used so that the active gadget can be tracked by the
     * application.  Defaults to FALSE. */

NATIVE {GA_RightBorder}      CONST GA_RIGHTBORDER      = (GA_DUMMY+24)
    /* (BOOL) Indicate whether the gadget is in the right border
     * or not.  Defaults to FALSE. */

NATIVE {GA_LeftBorder}       CONST GA_LEFTBORDER       = (GA_DUMMY+25)
    /* (BOOL) Indicate whether the gadget is in the left border
     * or not.  Defaults to FALSE. */

NATIVE {GA_TopBorder}        CONST GA_TOPBORDER        = (GA_DUMMY+26)
    /* (BOOL) Indicate whether the gadget is in the top border
     * or not.  Defaults to FALSE. */

NATIVE {GA_BottomBorder}     CONST GA_BOTTOMBORDER     = (GA_DUMMY+27)
    /* (BOOL) Indicate whether the gadget is in the bottom border
     * or not.  Defaults to FALSE. */

NATIVE {GA_ToggleSelect}     CONST GA_TOGGLESELECT     = (GA_DUMMY+28)
    /* (BOOL) Indicate whether the gadget is toggle-selected
     * or not.  Defaults to FALSE. */

NATIVE {GA_SysGadget}        CONST GA_SYSGADGET        = (GA_DUMMY+29)
    /* (BOOL) Reserved for system use to indicate that the
     * gadget belongs to the system.  Defaults to FALSE. */

NATIVE {GA_SysGType}         CONST GA_SYSGTYPE         = (GA_DUMMY+30)
    /* (UWORD) Reserved for system use to indicate the
     * gadget type. */

NATIVE {GA_Previous}         CONST GA_PREVIOUS         = (GA_DUMMY+31)
    /* (struct Gadget *) Previous gadget in the linked list.
     * NOTE: This attribute CANNOT be used to link new gadgets
     * into the gadget list of an open window or requester.
     * You must use AddGList(). */

NATIVE {GA_Next}             CONST GA_NEXT             = (GA_DUMMY+32)
    /* (struct Gadget *) Next gadget in the linked list. */

NATIVE {GA_DrawInfo}         CONST GA_DRAWINFO         = (GA_DUMMY+33)
    /* (struct DrawInfo *) Some gadgets need a DrawInfo at creation time */

/* You should use at most ONE of GA_Text, GA_IntuiText, and GA_LabelImage */
NATIVE {GA_IntuiText}        CONST GA_INTUITEXT        = (GA_DUMMY+34)
    /* (struct IntuiText *) Label is an IntuiText. */

NATIVE {GA_LabelImage}       CONST GA_LABELIMAGE       = (GA_DUMMY+35)
    /* (Object *) Label is an image object. */

NATIVE {GA_TabCycle}         CONST GA_TABCYCLE         = (GA_DUMMY+36)
    /* (BOOL) Indicate whether gadget is part of TAB/SHIFT-TAB cycle
     * activation.  Defaults to FALSE.  New for V37. */

NATIVE {GA_GadgetHelp}       CONST GA_GADGETHELP       = (GA_DUMMY+37)
    /* (BOOL) Indicate whether gadget is to send IDCMP_GADGETHELP.
     * Defaults to FALSE.  New for V39. */

NATIVE {GA_Bounds}           CONST GA_BOUNDS           = (GA_DUMMY+38)
    /* (struct IBox *) Copied into the extended gadget's bounds.
     * New for V39. */

NATIVE {GA_RelSpecial}       CONST GA_RELSPECIAL       = (GA_DUMMY+39)
    /* (BOOL) Indicate whether gadget has special relativity.  Defaults to
     * FALSE.  New for V39. */

NATIVE {GA_TextAttr}         CONST GA_TEXTATTR         = (GA_DUMMY+40)
    /* (struct TextAttr *) Indicate the font to use for the gadget.
     * New for V42. */

NATIVE {GA_ReadOnly}         CONST GA_READONLY         = (GA_DUMMY+41)
    /* (BOOL) Indicate that the gadget is read-only (non-selectable).
     * Defaults to FALSE. New for V42. */

NATIVE {GA_Underscore}       CONST GA_UNDERSCORE       = (GA_DUMMY+42)
    /* (UBYTE) Underscore/escape character for keyboard shortcuts.
     * Defaults to '_' . New for V44. */

NATIVE {GA_ActivateKey}      CONST GA_ACTIVATEKEY      = (GA_DUMMY+43)
    /* (STRPTR) Set/Get the gadgets shortcut/activation key(s)
     * Defaults to NULL. New for V44. */

NATIVE {GA_BackFill}         CONST GA_BACKFILL         = (GA_DUMMY+44)
    /* (struct Hook *) Backfill pattern hook.
     * Defaults to NULL. New for V44. */

NATIVE {GA_GadgetHelpText}   CONST GA_GADGETHELPTEXT   = (GA_DUMMY+45)
    /* (STRPTR) **RESERVED/PRIVATE DO NOT USE**
     * Defaults to NULL. New for V44. */

NATIVE {GA_UserInput}        CONST GA_USERINPUT        = (GA_DUMMY+46)
    /* (BOOL) Notification tag indicates this notification is from the active
     * gadget receiving user input - an attempt to make IDCMPUPDATE more
     * efficient.
     * Defaults to FALSE. New for V44. */

NATIVE {GA_DoLayout}         CONST GA_DOLAYOUT         = (GA_DUMMY+51)
    /* (BOOL) Set this to TRUE if the gadget should recompute its
     * position and size when it receives a GM_LAYOUT message. For
     * gadgets which are part of a layout group this attribute
     * should be FALSE; the layout takes care of placing and sizing
     * its members and the resulting geometry must not be changed.
     * The default is usually FALSE for ReAction gadgets, while for
     * others it is defined on a class-by-class basis. New for V50. */

NATIVE {GA_NoFilterMenuKeys} CONST GA_NOFILTERMENUKEYS = (GA_DUMMY+52)
    /* (BOOL) Corresponds to GMORE_NOFILTERMENUKEYS. New for V50. */

NATIVE {GA_Titlebar}         CONST GA_TITLEBAR         = (GA_DUMMY+53)
    /* (BOOL) Set this to TRUE if you want the gadget to be automatically
     * positioned by Intuition in the window titlebar (at the left or at
     * the right side, depending on the state of GFLG_RELRIGHT). The layout
     * is done according to the current style and geometry settings for
     * window border gadgets. Please use an appropriate sysiclass instance
     * as imagery for a titlebar gadget, such as ICONIFYIMAGE or TBFRAMEIMAGE.
     * Note: This property implies { GA_TopBorder, TRUE }. New for V50. */

NATIVE {GA_Hidden}           CONST GA_HIDDEN           = (GA_DUMMY+54)
    /* (BOOL) Corresponds to GMORE_HIDDEN. New for V50. */

NATIVE {GA_NoFilterWheel}    CONST GA_NOFILTERWHEEL    = (GA_DUMMY+55)
    /* (BOOL) Corresponds to GMORE_NOFILTERWHEEL. New for V51. */

/*****************************************************************************/

/* PROPGCLASS attributes */
NATIVE {PGA_Dummy}      CONST PGA_DUMMY      = (TAG_USER+$31000)
NATIVE {PGA_Freedom}    CONST PGA_FREEDOM    = (PGA_DUMMY+$0001)
     /* only one of FREEVERT or FREEHORIZ */
NATIVE {PGA_Borderless} CONST PGA_BORDERLESS = (PGA_DUMMY+$0002)
NATIVE {PGA_HorizPot}   CONST PGA_HORIZPOT   = (PGA_DUMMY+$0003)
NATIVE {PGA_HorizBody}  CONST PGA_HORIZBODY  = (PGA_DUMMY+$0004)
NATIVE {PGA_VertPot}    CONST PGA_VERTPOT    = (PGA_DUMMY+$0005)
NATIVE {PGA_VertBody}   CONST PGA_VERTBODY   = (PGA_DUMMY+$0006)
NATIVE {PGA_Total}      CONST PGA_TOTAL      = (PGA_DUMMY+$0007)
NATIVE {PGA_Visible}    CONST PGA_VISIBLE    = (PGA_DUMMY+$0008)
NATIVE {PGA_Top}        CONST PGA_TOP        = (PGA_DUMMY+$0009)
/* New for V37: */
NATIVE {PGA_NewLook}    CONST PGA_NEWLOOK    = (PGA_DUMMY+$000A)
/* New for V50: scrollergclass attributes */
NATIVE {PGA_ArrowDelta} CONST PGA_ARROWDELTA = (PGA_DUMMY+$000B)
NATIVE {PGA_ArrowDown}  CONST PGA_ARROWDOWN  = (PGA_DUMMY+$000C)

/*****************************************************************************/

/* STRGCLASS attributes */
NATIVE {STRINGA_Dummy}          CONST STRINGA_DUMMY          = (TAG_USER     +$32000)
NATIVE {STRINGA_MaxChars}       CONST STRINGA_MAXCHARS       = (STRINGA_DUMMY+$0001)
/* Note:  There is a minor problem with Intuition when using boopsi integer
 * gadgets (which are requested by using STRINGA_LongInt).  Such gadgets
 * must not have a STRINGA_MaxChars to be bigger than 15.  Setting
 * STRINGA_MaxChars for a boopsi integer gadget will cause a mismatched
 * FreeMem() to occur.
 */

NATIVE {STRINGA_Buffer}         CONST STRINGA_BUFFER         = (STRINGA_DUMMY+$0002)
NATIVE {STRINGA_UndoBuffer}     CONST STRINGA_UNDOBUFFER     = (STRINGA_DUMMY+$0003)
NATIVE {STRINGA_WorkBuffer}     CONST STRINGA_WORKBUFFER     = (STRINGA_DUMMY+$0004)
NATIVE {STRINGA_BufferPos}      CONST STRINGA_BUFFERPOS      = (STRINGA_DUMMY+$0005)
NATIVE {STRINGA_DispPos}        CONST STRINGA_DISPPOS        = (STRINGA_DUMMY+$0006)
NATIVE {STRINGA_AltKeyMap}      CONST STRINGA_ALTKEYMAP      = (STRINGA_DUMMY+$0007)
NATIVE {STRINGA_Font}           CONST STRINGA_FONT           = (STRINGA_DUMMY+$0008)
NATIVE {STRINGA_Pens}           CONST STRINGA_PENS           = (STRINGA_DUMMY+$0009)
NATIVE {STRINGA_ActivePens}     CONST STRINGA_ACTIVEPENS     = (STRINGA_DUMMY+$000A)
NATIVE {STRINGA_EditHook}       CONST STRINGA_EDITHOOK       = (STRINGA_DUMMY+$000B)
NATIVE {STRINGA_EditModes}      CONST STRINGA_EDITMODES      = (STRINGA_DUMMY+$000C)

/* booleans */
NATIVE {STRINGA_ReplaceMode}    CONST STRINGA_REPLACEMODE    = (STRINGA_DUMMY+$000D)
NATIVE {STRINGA_FixedFieldMode} CONST STRINGA_FIXEDFIELDMODE = (STRINGA_DUMMY+$000E)
NATIVE {STRINGA_NoFilterMode}   CONST STRINGA_NOFILTERMODE   = (STRINGA_DUMMY+$000F)

NATIVE {STRINGA_Justification}  CONST STRINGA_JUSTIFICATION  = (STRINGA_DUMMY+$0010)
    /* GACT_STRINGCENTER, GACT_STRINGLEFT, GACT_STRINGRIGHT */
NATIVE {STRINGA_LongVal}        CONST STRINGA_LONGVAL        = (STRINGA_DUMMY+$0011)
NATIVE {STRINGA_TextVal}        CONST STRINGA_TEXTVAL        = (STRINGA_DUMMY+$0012)

NATIVE {STRINGA_ExitHelp}       CONST STRINGA_EXITHELP       = (STRINGA_DUMMY+$0013)
    /* STRINGA_ExitHelp is new for V37, and ignored by V36.
     * Set this if you want the gadget to exit when Help is
     * pressed.  Look for a code of $5F, the rawkey code for Help */

NATIVE {STRINGA_MarkedBlock}    CONST STRINGA_MARKEDBLOCK    = (STRINGA_DUMMY+$0014)
    /* Sets/gets the marked block of a string.gadget. The hi-word
     * contains the start position (first marked char) and the
     * lo-word the end position (last marked char).  If both are
     * -1 nothing is marked.  (V50).
     */

NATIVE {SG_DEFAULTMAXCHARS} CONST SG_DEFAULTMAXCHARS = (128)

/*****************************************************************************/

/* Gadget layout related attributes */
NATIVE {LAYOUTA_Dummy}          CONST LAYOUTA_DUMMY          = (TAG_USER+$38000)
NATIVE {LAYOUTA_LayoutObj}      CONST LAYOUTA_LAYOUTOBJ      = (LAYOUTA_DUMMY+$0001)
NATIVE {LAYOUTA_Spacing}        CONST LAYOUTA_SPACING        = (LAYOUTA_DUMMY+$0002)
NATIVE {LAYOUTA_Orientation}    CONST LAYOUTA_ORIENTATION    = (LAYOUTA_DUMMY+$0003)

NATIVE {LAYOUTA_ChildMaxWidth}  CONST LAYOUTA_CHILDMAXWIDTH  = (LAYOUTA_DUMMY+$0004)
    /* (BOOL) Child objects are of equal width.  Should default to TRUE for
     * gadgets with a horizontal orientation.  New for V42. */
NATIVE {LAYOUTA_ChildMaxHeight} CONST LAYOUTA_CHILDMAXHEIGHT = (LAYOUTA_DUMMY+$0005)
    /* (BOOL) Child objects are of equal height.  Should default to TRUE for
     * gadgets with a vertical orientation.  New for V42. */

/* orientation values */
NATIVE {LORIENT_NONE}  CONST LORIENT_NONE  = 0
NATIVE {LORIENT_HORIZ} CONST LORIENT_HORIZ = 1
NATIVE {LORIENT_VERT}  CONST LORIENT_VERT  = 2

/*****************************************************************************/

/* Gadget Method ID's */
NATIVE {GM_Dummy}         CONST GM_DUMMY         = (-1)
    /* not used for anything */

NATIVE {GM_HITTEST}       CONST GM_HITTEST       = (0)
    /* return GMR_GADGETHIT if you are clicked on (whether or not you
     * are disabled). */

NATIVE {GM_RENDER}        CONST GM_RENDER        = (1)
    /* draw yourself, in the appropriate state */

NATIVE {GM_GOACTIVE}      CONST GM_GOACTIVE      = (2)
    /* you are now going to be fed input */

NATIVE {GM_HANDLEINPUT}   CONST GM_HANDLEINPUT   = (3)
    /* handle that input */

NATIVE {GM_GOINACTIVE}    CONST GM_GOINACTIVE    = (4)
    /* whether or not by choice, you are done */

NATIVE {GM_HELPTEST}      CONST GM_HELPTEST      = (5)
    /* Will you send gadget help if the mouse is at the specified coordinates?
     * See below for possible GMR_ values. */

NATIVE {GM_LAYOUT}        CONST GM_LAYOUT        = (6)
    /* re-evaluate your size based on the GadgetInfo domain.
     * Do NOT re-render yourself yet, you will be called when it is
     * time... */

NATIVE {GM_DOMAIN}        CONST GM_DOMAIN        = (7)
    /* Used to obtain the sizing requirements of an object.  Does not
     * require an object. */

NATIVE {GM_KEYTEST}       CONST GM_KEYTEST       = (8)
    /* return GMR_GADGETHIT if you activation key matches (whether or not you
     * are disabled). */

NATIVE {GM_KEYGOACTIVE}   CONST GM_KEYGOACTIVE   = (9)

NATIVE {GM_KEYGOINACTIVE} CONST GM_KEYGOINACTIVE = (10)

NATIVE {GM_PRERENDER}     CONST GM_PRERENDER     = (11)    /* New for V50. Private */

NATIVE {GM_POSTRENDER}    CONST GM_POSTRENDER    = (12)    /* New for V50. Private */

NATIVE {GM_EXTENT}        CONST GM_EXTENT        = (13)
    /* Let Intuition know what pixels your GM_RENDER method will fill. (V51) */

/*****************************************************************************/

/* Parameter "Messages" passed to gadget class methods    */

/* GM_HITTEST and GM_HELPTEST send this message.
 * For GM_HITTEST, gpht_Mouse are coordinates relative to the gadget
 * select box.  For GM_HELPTEST, the coordinates are relative to
 * the gadget bounding box (which defaults to the select box).
 */
NATIVE {gpHitTest} OBJECT gphittest
    {MethodID}	methodid	:ULONG
    {gpht_GInfo}	ginfo	:PTR TO gadgetinfo
    {gpht_Mouse.X}	mousex	:INT
    {gpht_Mouse.Y}	mousey	:INT
ENDOBJECT

/* For GM_HITTEST, return GMR_GADGETHIT if you were indeed hit,
 * otherwise return zero.
 *
 * For GM_HELPTEST, return GMR_NOHELPHIT (zero) if you were not hit.
 * Typically, return GMR_HELPHIT if you were hit.
 * It is possible to pass a UWORD to the application via the Code field
 * of the IDCMP_GADGETHELP message.  Return GMR_HELPCODE or'd with
 * the UWORD-sized result you wish to return.
 *
 * GMR_HELPHIT yields a Code value of ((UWORD) ~0), which should
 * mean "nothing particular" to the application.
 */

NATIVE {GMR_GADGETHIT} CONST GMR_GADGETHIT = ($00000004) /* GM_HITTEST hit */

NATIVE {GMR_NOHELPHIT} CONST GMR_NOHELPHIT = ($00000000) /* GM_HELPTEST didn't hit */
NATIVE {GMR_HELPHIT}   CONST GMR_HELPHIT   = ($FFFFFFFF) /* GM_HELPTEST hit, return code = ~0 */
NATIVE {GMR_HELPCODE}  CONST GMR_HELPCODE  = ($00010000) /* GM_HELPTEST hit,
                                         return low word as code */

/*****************************************************************************/

/* GM_RENDER */
NATIVE {gpRender} OBJECT gprender
    {MethodID}	methodid	:ULONG
    {gpr_GInfo}	ginfo	:PTR TO gadgetinfo  /* gadget context              */
    {gpr_RPort}	rport	:PTR TO rastport  /* all ready for use           */
    {gpr_Redraw}	redraw	:VALUE /* might be a "highlight pass" */
ENDOBJECT

/* values of gpr_Redraw */
NATIVE {GREDRAW_UPDATE} CONST GREDRAW_UPDATE = (2) /* incremental update, e.g. prop slider */
NATIVE {GREDRAW_REDRAW} CONST GREDRAW_REDRAW = (1) /* redraw gadget                        */
NATIVE {GREDRAW_TOGGLE} CONST GREDRAW_TOGGLE = (0) /* toggle highlight, if applicable      */

/*****************************************************************************/

/* GM_GOACTIVE, GM_HANDLEINPUT */
NATIVE {gpInput} OBJECT gpinput
    {MethodID}	methodid	:ULONG
    {gpi_GInfo}	ginfo	:PTR TO gadgetinfo
    {gpi_IEvent}	ievent	:PTR TO inputevent
    {gpi_Termination}	termination	:PTR TO VALUE
    {gpi_Mouse.X}	mousex	:INT
    {gpi_Mouse.Y}	mousey	:INT

    /* (V39) Pointer to TabletData structure, if this event originated
     * from a tablet which sends IESUBCLASS_NEWTABLET events, or NULL if
     * not.
     *
     * DO NOT ATTEMPT TO READ THIS FIELD UNDER INTUITION PRIOR TO V39!
     * IT WILL BE INVALID!
     */
    {gpi_TabletData}	tabletdata	:PTR TO tabletdata
ENDOBJECT

/* GM_HANDLEINPUT and GM_GOACTIVE  return code flags */
/* return GMR_MEACTIVE (0) alone if you want more input.
 * Otherwise, return ONE of GMR_NOREUSE and GMR_REUSE, and optionally
 * GMR_VERIFY.
 */
NATIVE {GMR_MEACTIVE}   CONST GMR_MEACTIVE   = (0)
NATIVE {GMR_NOREUSE}    CONST GMR_NOREUSE    = $2
NATIVE {GMR_REUSE}      CONST GMR_REUSE      = $4
NATIVE {GMR_VERIFY}     CONST GMR_VERIFY     = $8 /* you MUST set gpi_Termination */

/* New for V37:
 * You can end activation with one of GMR_NEXTACTIVE and GMR_PREVACTIVE,
 * which instructs Intuition to activate the next or previous gadget
 * that has GFLG_TABCYCLE set.
 */
NATIVE {GMR_NEXTACTIVE} CONST GMR_NEXTACTIVE = $10
NATIVE {GMR_PREVACTIVE} CONST GMR_PREVACTIVE = $20

/*****************************************************************************/

/* GM_GOINACTIVE */
NATIVE {gpGoInactive} OBJECT gpgoinactive
    {MethodID}	methodid	:ULONG
    {gpgi_GInfo}	ginfo	:PTR TO gadgetinfo

    /* V37 field only!  DO NOT attempt to read under V36! */
    {gpgi_Abort}	abort	:ULONG /* gpgi_Abort=1 if gadget was aborted
                                    * by Intuition and 0 if gadget went
                                    * inactive at its own request
                                    */
ENDOBJECT

/*****************************************************************************/

/* New for V39: Intuition sends GM_LAYOUT to any GREL_ gadget when
 * the gadget is added to the window (or when the window opens, if
 * the gadget was part of the NewWindow.FirstGadget or the WA_Gadgets
 * list), or when the window is resized.  Your gadget can set the
 * GA_RelSpecial property to get GM_LAYOUT events without Intuition
 * changing the interpretation of your gadget select box.  This
 * allows for completely arbitrary resizing/repositioning based on
 * window size.
 */
/* GM_LAYOUT */
NATIVE {gpLayout} OBJECT gplayout
    {MethodID}	methodid	:ULONG
    {gpl_GInfo}	ginfo	:PTR TO gadgetinfo
    {gpl_Initial}	initial	:ULONG /* non-zero if this method was invoked
                                     * during AddGList() or OpenWindow()
                                     * time.  zero if this method was invoked
                                     * during window resizing.
                                     */
ENDOBJECT

/*****************************************************************************/

/* The GM_DOMAIN method is used to obtain the sizing requirements of an
 * object for a class before ever creating an object. */

/* GM_DOMAIN */
NATIVE {gpDomain} OBJECT gpdomain
    {MethodID}	methodid	:ULONG
    {gpd_GInfo}	ginfo	:PTR TO gadgetinfo
    {gpd_RPort}	rport	:PTR TO rastport  /* RastPort to layout for */
    {gpd_Which}	which	:VALUE
    {gpd_Domain}	domain	:ibox /* Resulting domain */
    {gpd_Attrs}	attrs	:ARRAY OF tagitem  /* Additional attributes */
ENDOBJECT

NATIVE {GDOMAIN_MINIMUM} CONST GDOMAIN_MINIMUM = (0) /* Minimum size */
NATIVE {GDOMAIN_NOMINAL} CONST GDOMAIN_NOMINAL = (1) /* Nominal size */
NATIVE {GDOMAIN_MAXIMUM} CONST GDOMAIN_MAXIMUM = (2) /* Maximum size */


/*****************************************************************************/

/* The GM_KEYTEST method is used to determin if a key press matches an
 * object's activation key(s). */

/* GM_KEYTEST send this message.
 */
NATIVE {gpKeyTest} OBJECT gpkeytest
    {MethodID}	methodid	:ULONG
    {gpkt_GInfo}	ginfo	:PTR TO gadgetinfo
    {gpkt_IMsg}	imsg	:PTR TO intuimessage /* The IntuiMessage that triggered this */
    {gpkt_VanillaKey}	vanillakey	:ULONG
ENDOBJECT

/*****************************************************************************/

/* The GM_KEYGOACTIVE method is called to "simulate" a gadget going down.
 * A gadget should render itself in a selected state when receiving
 * this message. If the class supports this method, it must return
 * GMR_KEYACTIVE.
 *
 * If a gadget returns zero for this method, it will subsequently be
 * activated via ActivateGadget() with a NULL IEvent.
 */

NATIVE {gpKeyInput} OBJECT gpkeyinput
    {MethodID}	methodid	:ULONG        /* GM_KEYGOACTIVE */
    {gpk_GInfo}	ginfo	:PTR TO gadgetinfo
    {gpk_IEvent}	ievent	:PTR TO inputevent
    {gpk_Termination}	termination	:PTR TO VALUE
ENDOBJECT

NATIVE {GMR_KEYACTIVE} CONST GMR_KEYACTIVE = $10
NATIVE {GMR_KEYVERIFY} CONST GMR_KEYVERIFY = $20 /* you MUST set gpk_Termination */

/* The GM_KEYGOINACTIVE method is called to simulate the gadget release.
 * Upon receiving this message, the gadget should do everything a
 * normal gadget release would do.
 */

NATIVE {gpKeyGoInactive} OBJECT gpkeygoinactive
    {MethodID}	methodid	:ULONG   /* GM_KEYGOINACTIVE */
    {gpki_GInfo}	ginfo	:PTR TO gadgetinfo
    {gpki_Abort}	abort	:ULONG /* TRUE if input was aborted */
ENDOBJECT

/****************************************************************************/

/* New for V51: Intuition may send GM_EXTENT to a gadget to ask it what
 * pixels (at least) it will fully redraw when its GM_RENDER method is
 * invoked in the same context.
 * (By "fully redraw", we mean changing the pixel's color in a way that
 * is totally unrelated to its previous value -- so this doesn't apply
 * to alpha-blended pixels, for example.)
 *
 * Intuition uses that information for optimization purposes: during GUI
 * refreshes, it will skip filling or erasing those pixels that the gadget
 * would then completely re-render anyway.
 * Supporting this method in your gadgets will help Intuition improve the
 * smoothness of user interface refresh, by preventing redundant graphic
 * calls and minimizing "flicker" effects caused by background clearing,
 * especially during window resizes.
 *
 * The easiest way to support it is to make sure your gadget always fills
 * every pixel within its hit box or bounding box, and just return the
 * relevant (GMR_FULLHBOX or GMR_FULLBBOX) result value. In this case, you
 * may safely ignore the actual message contents (and the following text).
 *
 * If the above solution is not feasible (for instance because the gadget
 * has an irregular or not fully connected shape), then you should check
 * the gpe_Region and gpe_RPort message fields: if any of them is non-NULL
 * you may decide to employ a more detailed way to tell Intuition exactly
 * what pixels your GM_RENDER method does fill.
 *
 * If gpe_Region is non-NULL, you can compose in it your gadget's shape,
 * by using graphics.library's XxxxRectRegion() functions. Remember to
 * look at the gpe_Action field to determine what function to use: for
 * instance, if gpe_Action is GEXTENT_ADD, you should use OrRectRegion().
 * Note: you must NOT pre-clear or alter the initial region's contents
 * in any way, other than to compose your own gadget's shape!
 * Once finished composing your gadget's shape in the region, return
 * GMR_CLIPDONE to let Intuition know you updated the region's contents.
 *
 * If gpe_RPort is non-NULL, you can draw your gadget's shape into it,
 * just like you would do for a GM_RENDER message -- however, you're only
 * allowed to use colors 0 or 1, because you're actually drawing into a
 * single-bitplane mask. Again, check the gpe_Action field to find out
 * whether you should actually set, clear, or invert the pixels making up
 * your gadget's shape in the mask. Similarly to the previous case, you
 * are NOT allowed to alter any pixels other than those belonging to your
 * gadget's shape, nor to clear the mask's background before rendering.
 * Once finished drawing your gadget's shape in the mask plane, return
 * GMR_MASKDONE to let Intuition know you updated the mask's contents.
 *
 * (If both gpe_Region and gpe_RPort are non-NULL, you may simply choose
 * the method which is most suited for your purposes; you don't have to
 * support both for the same message! If you do, however, you can let
 * Intuition know by ORing together the appropriate return values.)
 *
 * It goes without saying that the region solution is best suited for
 * gadgets made up of a few rectangular parts, whereas the mask method
 * is better in the case of more complex gadget shapes.
 *
 * (Note: as of Intuition V51, the mask method is not yet implemented.)
 *
 * If all or part of your gadget's rendering is performed by some BOOPSI
 * image, you could also try asking the image for its extent information
 * by way of an IM_EXTENT or IM_EXTENTFRAME message (see imageclass.h).
 *
 * If for whatever reasons your GM_EXTENT method finds itself unable to
 * support any of the described solutions, it should return GMR_INVALID:
 * this particular return value will tell Intuition not to clip away the
 * gadget's shape at all. While this is usually slower and more prone to
 * flickering, it will still produce correct graphic results. This is of
 * course the same fallback applied for any gadgets not recognizing the
 * GM_EXTENT method.
 *
 * NOTE WELL:
 * Since it is very important that a gadget's GM_RENDER and GM_EXTENT
 * methods remain always synchronized, the default behavior of a gadget
 * class should be to only handle GM_EXTENT if it is the "true class"
 * of the object the method is invoked on, and just return GMR_INVALID
 * otherwise. This is because a subclass might override the behavior
 * of GM_RENDER in such a way that your class' GM_EXTENT results are
 * no longer correct. If a gadget subclass needs (and knows it's ok) to
 * let its superclass handle GM_EXTENT, it must set the GPEF_ALLOWSUPER
 * flag in gpe_Flags before calling IDoSuperMethodA() (and clear it as
 * soon as the call returns). If GPEF_ALLOWSUPER is set in gpe_Flags,
 * your gadget should accept and handle GM_EXTENT regardless of whether
 * it is the true class or not.
 */

/* GM_EXTENT */
NATIVE {gpExtent} OBJECT gpextent
   {MethodID}	methodid	:ULONG
   {gpe_GInfo}	ginfo	:PTR TO gadgetinfo
   {gpe_RPort}	rport	:PTR TO rastport  /* NULL if masking not supported */
   {gpe_Region}	region	:PTR TO region /* NULL if clipping not supported */
   {gpe_Action}	action	:ULONG /* Requested operation */
   {gpe_Flags}	flags	:ULONG  /* Control flags, see below */
   {gpe_Attrs}	attrs	:ARRAY OF tagitem  /* Additional attributes */
ENDOBJECT

/* Possible operations requested by GM_EXTENT
 */
NATIVE {GEXTENT_REMOVE} CONST GEXTENT_REMOVE = (0) /* You should CLEAR shapes from region/mask */
NATIVE {GEXTENT_ADD}    CONST GEXTENT_ADD    = (1) /* You should OR shapes into region/mask */
NATIVE {GEXTENT_INVERT} CONST GEXTENT_INVERT = (2) /* You should XOR shapes into region/mask */
NATIVE {GEXTENT_SECT}   CONST GEXTENT_SECT   = (3) /* You should AND shapes into region/mask */

/* Control flags defined for GM_EXTENT
 */
NATIVE {GPEF_ALLOWSUPER} CONST GPEF_ALLOWSUPER = ($00000001) /* Allow superclass to handle
                                      * the method
                                      */

/* Possible return codes for GM_EXTENT
 */
NATIVE {GMR_INVALID}  CONST GMR_INVALID  = ($00000000) /* Couldn't provide any information */
NATIVE {GMR_FULLHBOX} CONST GMR_FULLHBOX = ($00000010) /* I fill every pixel within my hit box */
NATIVE {GMR_FULLBBOX} CONST GMR_FULLBBOX = ($00000020) /* I fill every pixel within
                                     my bounding box */
NATIVE {GMR_CLIPDONE} CONST GMR_CLIPDONE = ($00000040) /* Added to the region all areas I fully
                                     redraw */
NATIVE {GMR_MASKDONE} CONST GMR_MASKDONE = ($00000080) /* Wrote into the mask all pixels I fully
                                     redraw */
