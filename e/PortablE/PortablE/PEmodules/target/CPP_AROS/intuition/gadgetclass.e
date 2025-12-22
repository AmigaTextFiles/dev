/* $Id: gadgetclass.h 25583 2007-03-26 23:38:53Z dariusb $ */
OPT NATIVE
MODULE 'target/exec/types', 'target/intuition/intuition', 'target/utility/tagitem'
MODULE 'target/graphics/rastport', 'target/devices/inputevent'
{#include <intuition/gadgetclass.h>}
NATIVE {INTUITION_GADGETCLASS_H} CONST

NATIVE {GA_Dummy}	CONST GA_DUMMY	= (TAG_USER + $30000)

  /* [ISG] (LONG) Left edge of gadget. */
NATIVE {GA_Left} 	CONST GA_LEFT 	= (GA_DUMMY +  1)
  /* [ISG] (LONG) Left edge of gadget, depending on right window border:
     Left=Win->Width-this-1 */
NATIVE {GA_RelRight}	CONST GA_RELRIGHT	= (GA_DUMMY +  2)
  /* [ISG] (LONG) Top edge of gadget. */
NATIVE {GA_Top}		CONST GA_TOP		= (GA_DUMMY +  3)
  /* [ISG] (LONG) Top edge of gadget, depending on bottom window border:
     Top=Win->Height-this-1 */
NATIVE {GA_RelBottom}	CONST GA_RELBOTTOM	= (GA_DUMMY +  4)
  /* [ISG] (LONG) Width of gadget. */
NATIVE {GA_Width}	CONST GA_WIDTH	= (GA_DUMMY +  5)
  /* [ISG] (LONG) Width of gadget, depending on window width:
     Width=Win->Width-this */
NATIVE {GA_RelWidth}	CONST GA_RELWIDTH	= (GA_DUMMY +  6)
  /* [ISG] (LONG) Height of gadget. */
NATIVE {GA_Height}	CONST GA_HEIGHT	= (GA_DUMMY +  7)
  /* [ISG] (LONG) Height of gadget, depending on window height:
     Height=Win->Height-this */
NATIVE {GA_RelHeight}	CONST GA_RELHEIGHT	= (GA_DUMMY +  8)

/* Gadget rendering. */
  /* [IS.] (UBYTE *) Label text. This is mutually exclusive with GA_IntuiText
     and GA_LabelImage. */
NATIVE {GA_Text} 	CONST GA_TEXT 	= (GA_DUMMY +  9)
/* The next two attributes are mutually exclusive. */
  /* [IS.] (struct Image *) Gadgets' image. */
NATIVE {GA_Image}	CONST GA_IMAGE	= (GA_DUMMY + 10)
  /* [IS.] (struct Border *) Gadgets' border. */
NATIVE {GA_Border}	CONST GA_BORDER	= (GA_DUMMY + 11)
  /* [IS.] (struct Image *) Gadgets' image in selected state. */
NATIVE {GA_SelectRender} CONST GA_SELECTRENDER = (GA_DUMMY + 12)
  /* [IS.] (ULONG) Takes GFLG_GADGH* flags (see <intuition/intuition.h>) as
     argument. Used to specify the highlighting technique. */
NATIVE {GA_Highlight}	CONST GA_HIGHLIGHT	= (GA_DUMMY + 13)
  /* [ISG] (BOOL) If this is set to true, the gadget is not selectable. Often
     this is visually represented by using a special disabled pattern. */
NATIVE {GA_Disabled}	CONST GA_DISABLED	= (GA_DUMMY + 14)

/* Additional information. */
  /* [IS.] (BOOL) The Gadget is a GimmeZeroZero gadget. */
NATIVE {GA_GZZGadget}	CONST GA_GZZGADGET	= (GA_DUMMY + 15)
  /* [ISG] (LONG) The gadget ID to identify that gadget. */
NATIVE {GA_ID}		CONST GA_ID		= (GA_DUMMY + 16)
  /* [ISG] (IPTR) Fill with whatever you want to. This field is ignored by
     the system. */
NATIVE {GA_UserData}	CONST GA_USERDATA	= (GA_DUMMY + 17)
  /* [IS.] (APTR) Pointer to additional information, needed by some gadgets
     (like string or integer gadgets). This field should generally only be set
     by subclasses of GadgetClass. Applications should keep their hands off it.
  */
NATIVE {GA_SpecialInfo}	CONST GA_SPECIALINFO	= (GA_DUMMY + 18)
  /* [ISG] (BOOL) Determines the selected state of a gadget. */

/* Gadget activation. */
NATIVE {GA_Selected}	CONST GA_SELECTED	= (GA_DUMMY + 19)
  /* [IS.] (BOOL) Only used for requester gadgets. This tells intuition that
     the requester is to be closed, when the gadget is released. */
NATIVE {GA_EndGadget}	CONST GA_ENDGADGET	= (GA_DUMMY + 20)
  /* [IS.] (BOOL) If set the gadget responds immediatly, when the gadget is
     selected. */
NATIVE {GA_Immediate}	CONST GA_IMMEDIATE	= (GA_DUMMY + 21)
  /* [IS.] (BOOL) If set the gadget responds, when it is released from selected
     state. */
NATIVE {GA_RelVerify}	CONST GA_RELVERIFY	= (GA_DUMMY + 22)
  /* [IS.] (BOOL) If this is set, the gadget receives information about the
     movement of the mouse as long as it is activated. */
NATIVE {GA_FollowMouse}	CONST GA_FOLLOWMOUSE	= (GA_DUMMY + 23)

/* The (boolean) border attributes mean that the gadget is to be included in a
   window border, when the window containing it is opened. */
NATIVE {GA_RightBorder}	CONST GA_RIGHTBORDER	= (GA_DUMMY + 24) /* [IS.] (BOOL) */
NATIVE {GA_LeftBorder}	CONST GA_LEFTBORDER	= (GA_DUMMY + 25) /* [IS.] (BOOL) */
NATIVE {GA_TopBorder}	CONST GA_TOPBORDER	= (GA_DUMMY + 26) /* [IS.] (BOOL) */
NATIVE {GA_BottomBorder} CONST GA_BOTTOMBORDER = (GA_DUMMY + 27) /* [IS.] (BOOL) */

  /* [IS.] (BOOL) Set this to turn on the toggle-select mode. */
NATIVE {GA_ToggleSelect} CONST GA_TOGGLESELECT = (GA_DUMMY + 28)

/* The following two attributes are PRIVATE! */
  /* [IS.] (BOOL) Set, if gadget is a system-gadget (eg a standard window
     border gadget. */
NATIVE {GA_SysGadget}	CONST GA_SYSGADGET	= (GA_DUMMY + 29)
  /* [I..] (ULONG) Flag to indicate, which kind of system gadget this is (see
     <intuition/intuition.h> for more information). */
NATIVE {GA_SysGType}	CONST GA_SYSGTYPE	= (GA_DUMMY + 30)

/* Gadget linking. */
  /* [I..] (struct Gadget *) Pointer to previous gadget. */
NATIVE {GA_Previous}	CONST GA_PREVIOUS	= (GA_DUMMY + 31)
  /* [I..] (struct Gadget *) Currently not implemented. */
NATIVE {GA_Next} 	CONST GA_NEXT 	= (GA_DUMMY + 32)

NATIVE {GA_DrawInfo}	CONST GA_DRAWINFO	= (GA_DUMMY + 33)

/* You should use at most ONE of GA_Text, GA_IntuiText, and GA_LabelImage! */
  /* [IS.] (struct IntuiText *) The label of the gadget expressed as IntuiText
     structure (see <intuition/intuition.h>). */
NATIVE {GA_IntuiText}	 CONST GA_INTUITEXT	 = (GA_DUMMY + 34)
  /* [IS.] (struct Object *) Use this image object as label. */
NATIVE {GA_LabelImage}	 CONST GA_LABELIMAGE	 = (GA_DUMMY + 35)

  /* [IS.] (BOOL) If set to true that gadget participates in TAB handling, ie
     if tab is pressed, the next gadget is activated. */
NATIVE {GA_TabCycle}	 CONST GA_TABCYCLE	 = (GA_DUMMY + 36)
  /* [..G] (BOOL) If this is set by the gadget, the sends GADGETHELP messages.
  */
NATIVE {GA_GadgetHelp}	 CONST GA_GADGETHELP	 = (GA_DUMMY + 37)
  /* [IS.] (struct IBox *) Bounds to be copied into the ExtGadget structure.
     (see <intuition/intuition.h> for more information). */
NATIVE {GA_Bounds}	 CONST GA_BOUNDS	 = (GA_DUMMY + 38)
NATIVE {GA_RelSpecial}	 CONST GA_RELSPECIAL	 = (GA_DUMMY + 39)

NATIVE {GA_TextAttr}	 CONST GA_TEXTATTR	 = (GA_DUMMY + 40)
  /* [] (BOOL) */
NATIVE {GA_ReadOnly}	 CONST GA_READONLY	 = (GA_DUMMY + 41)
NATIVE {GA_Underscore}	 CONST GA_UNDERSCORE	 = (GA_DUMMY + 42)
NATIVE {GA_ActivateKey}   CONST GA_ACTIVATEKEY   = (GA_DUMMY + 43)
NATIVE {GA_BackFill}	 CONST GA_BACKFILL	 = (GA_DUMMY + 44)
NATIVE {GA_GadgetHelpText} CONST GA_GADGETHELPTEXT = (GA_DUMMY + 45)
NATIVE {GA_UserInput}	 CONST GA_USERINPUT	 = (GA_DUMMY + 46)

/* The following attributes are AROS specific. */
NATIVE {GA_LabelPlace}    CONST GA_LABELPLACE    = (GA_DUMMY + 100)


/* Placetext values for GA_LabelPlace. */
NATIVE {GV_LabelPlace_In}    CONST GV_LABELPLACE_IN    = 1
NATIVE {GV_LabelPlace_Left}  CONST GV_LABELPLACE_LEFT  = 2
NATIVE {GV_LabelPlace_Right} CONST GV_LABELPLACE_RIGHT = 3
NATIVE {GV_LabelPlace_Above} CONST GV_LABELPLACE_ABOVE = 4
NATIVE {GV_LabelPlace_Below} CONST GV_LABELPLACE_BELOW = 5


/************* Methods for GadgetClass and its subclasses. ************/

NATIVE {GM_HITTEST} CONST GM_HITTEST = 0
NATIVE {gpHitTest} OBJECT gphittest
    {MethodID}	methodid	:/*STACKULONG*/ ULONG   /* GM_HITEST or GM_HELPTEST */
    {gpht_GInfo}	ginfo	:PTR TO gadgetinfo /* see <intuition/cghooks.h> */

	{gpht_Mouse.X}	mousex	:STACKWORD
	{gpht_Mouse.Y}	mousey	:STACKWORD
ENDOBJECT
NATIVE {GMR_GADGETHIT} CONST GMR_GADGETHIT = $00000004


/* This method is invoked to draw the gadget into a rastport. */
NATIVE {GM_RENDER} CONST GM_RENDER = 1     /* draw yourself in the right state */
NATIVE {gpRender} OBJECT gprender
    {MethodID}	methodid	:/*STACKULONG*/ ULONG   /* GM_RENDER */
    {gpr_GInfo}	ginfo	:PTR TO gadgetinfo  /* see <intuition/cghooks.h> */
    {gpr_RPort}	rport	:PTR TO rastport  /* RastPort (see <graphics/rastport.h>) to
                                       render into. */
    {gpr_Redraw}	redraw	:STACKLONG /* see below */
ENDOBJECT
/* gpr_Redraw. Not all of these values make sense for all gadgets. */
NATIVE {GREDRAW_TOGGLE} CONST GREDRAW_TOGGLE = 0 /* Just toggle the status. */
NATIVE {GREDRAW_REDRAW} CONST GREDRAW_REDRAW = 1 /* Redraw the whole gadget. */
NATIVE {GREDRAW_UPDATE} CONST GREDRAW_UPDATE = 2 /* Some data (eg the level of a slider) was updated.
                            Just redraw the necessary parts. */


NATIVE {GM_GOACTIVE}    CONST GM_GOACTIVE    = 2
NATIVE {GM_HANDLEINPUT} CONST GM_HANDLEINPUT = 3
NATIVE {gpInput} OBJECT gpinput
    {MethodID}	methodid	:/*STACKULONG*/ ULONG        /* GM_GOACTIVE or GM_HANDLEINPUT */
    {gpi_GInfo}	ginfo	:PTR TO gadgetinfo       /* see <intuition/cghooks.h> */
    {gpi_IEvent}	ievent	:PTR TO inputevent
    {gpi_Termination}	termination	:PTR TO SLONG

	{gpi_Mouse.X}	mousex	:STACKWORD
	{gpi_Mouse.Y}	mousey	:STACKWORD
    {gpi_TabletData}	tabletdata	:PTR TO tabletdata
ENDOBJECT

  /* Gadget is still alive. */
NATIVE {GMR_MEACTIVE}      CONST GMR_MEACTIVE      = 0
  /* Gadget has become inactive, but the input event may not be used again. */
NATIVE {GMR_NOREUSE}       CONST GMR_NOREUSE       = $2
  /* Gadget has become inactive, and the input event may be reused by
     intuition. */
NATIVE {GMR_REUSE}         CONST GMR_REUSE         = $4
  /* Gadget was selected. Generate IDCMP_GADGETUP message. gpi_Termination must
     be set. */
NATIVE {GMR_VERIFY}        CONST GMR_VERIFY        = $8

NATIVE {GMR_NEXTACTIVE}    CONST GMR_NEXTACTIVE    = $10 /* Activate next gadget. */
NATIVE {GMR_PREVACTIVE}    CONST GMR_PREVACTIVE    = $20 /* Activate previous gadget. */

/* See GM_GOACTIVE for explanation. */
NATIVE {GM_GOINACTIVE} CONST GM_GOINACTIVE = 4
NATIVE {gpGoInactive} OBJECT gpgoinactive
    {MethodID}	methodid	:/*STACKULONG*/ ULONG   /* GM_GOINACTIVE */
    {gpgi_GInfo}	ginfo	:PTR TO gadgetinfo /* see <intuition/cghooks.h> */
    {gpgi_Abort}	abort	:/*STACKULONG*/ ULONG
ENDOBJECT


NATIVE {GM_HELPTEST} CONST GM_HELPTEST = 5

/* Return codes. */
  /* The gadget was not hit. */
NATIVE {GMR_NOHELPHIT} CONST GMR_NOHELPHIT = (0 !!ULONG)
  /* The gadget was hit. The lower word of the Code field of the IntuiMessage
     (see <intuition/intuition.h>) will be set to -1. */
NATIVE {GMR_HELPHIT}   CONST GMR_HELPHIT   = ($FFFFFFFF /*!!BIGVALUE!!ULONG*/)
  /* The gadget was hit. Pass the lower word, returned by this method to the
     application by using the Code field of the IntuiMessage. */
NATIVE {GMR_HELPCODE}  CONST GMR_HELPCODE  = ($00010000 /*!!BIGVALUE!!ULONG*/)


NATIVE {GM_LAYOUT} CONST GM_LAYOUT = 6
NATIVE {gpLayout} OBJECT gplayout
    {MethodID}	methodid	:/*STACKULONG*/ ULONG    /* GM_LAYOUT */
    {gpl_GInfo}	ginfo	:PTR TO gadgetinfo   /* see <intuition/cghooks.h> */
    {gpl_Initial}	initial	:/*STACKULONG*/ ULONG
ENDOBJECT


NATIVE {GM_DOMAIN} CONST GM_DOMAIN = 7
NATIVE {gpDomain} OBJECT gpdomain
    {MethodID}	methodid	:/*STACKULONG*/ ULONG   /* GM_DOMAIN */
    {gpd_GInfo}	ginfo	:PTR TO gadgetinfo  /* see <intuition/cghooks.h> */
    {gpd_RPort}	rport	:PTR TO rastport  /* RastPort to calculate dimensions for. */
    {gpd_Which}	which	:STACKLONG  /* see below */
    {gpd_Domain}	domain	:ibox /* Resulting domain. */
    {gpd_Attrs}	attrs	:ARRAY OF tagitem  /* Additional attributes. None defined,
                                       yet. */
ENDOBJECT

/* gpd_Which */
NATIVE {GDOMAIN_MINIMUM} CONST GDOMAIN_MINIMUM = 0 /* Calculate minimum size. */
NATIVE {GDOMAIN_NOMINAL} CONST GDOMAIN_NOMINAL = 1 /* Calculate nominal size. */
NATIVE {GDOMAIN_MAXIMUM} CONST GDOMAIN_MAXIMUM = 2 /* Calculate maximum size. */


/* This class defines a standard proportional gadget. */

/* Attributes. */
NATIVE {PGA_Dummy}      CONST PGA_DUMMY      = (TAG_USER + $31000)

NATIVE {PGA_Freedom}    CONST PGA_FREEDOM    = (PGA_DUMMY +  1)
  /* [IS.] (BOOL) If set, no border will be rendered. */
NATIVE {PGA_Borderless} CONST PGA_BORDERLESS = (PGA_DUMMY +  2)

  /* [ISG] (UWORD) */
NATIVE {PGA_HorizPot}   CONST PGA_HORIZPOT   = (PGA_DUMMY +  3)
  /* [ISG] (UWORD) */
NATIVE {PGA_HorizBody}  CONST PGA_HORIZBODY  = (PGA_DUMMY +  4)
  /* [ISG] (UWORD) */
NATIVE {PGA_VertPot}    CONST PGA_VERTPOT    = (PGA_DUMMY +  5)
  /* [ISG] (UWORD) */
NATIVE {PGA_VertBody}   CONST PGA_VERTBODY   = (PGA_DUMMY +  6)

  /* [IS.] (UWORD) The total number of positions in the gadget. */
NATIVE {PGA_Total}      CONST PGA_TOTAL      = (PGA_DUMMY +  7)
  /* [IS.] (UWORD) The number of visible positions in the gadget. */
NATIVE {PGA_Visible}    CONST PGA_VISIBLE    = (PGA_DUMMY +  8)
  /* [ISG] (UWORD) The first visible position. */
NATIVE {PGA_Top}        CONST PGA_TOP        = (PGA_DUMMY +  9)

  /* [IS.] (BOOL) If set, this indicated that the new look should be used for
     rendering. */
NATIVE {PGA_NewLook}    CONST PGA_NEWLOOK    = (PGA_DUMMY + 10)

  /* (I.G) (struct Hook) Use this Hook to render the Gadget visuals
     */

NATIVE {PGA_DisplayHook} CONST PGA_DISPLAYHOOK = (PGA_DUMMY + 11)
/* AROS extensions */

NATIVE {PGA_NotifyBehaviour} CONST PGA_NOTIFYBEHAVIOUR = (PGA_DUMMY + 30)

NATIVE {PGA_RenderBehaviour} CONST PGA_RENDERBEHAVIOUR = (PGA_DUMMY + 31)

NATIVE {PG_BEHAVIOUR_COMPATIBLE} CONST PG_BEHAVIOUR_COMPATIBLE = 0
NATIVE {PG_BEHAVIOUR_NICE}       CONST PG_BEHAVIOUR_NICE       = 1


/* StringGClass is just a normal "string" gadget. */

/* Attributes. */
NATIVE {STRINGA_Dummy}          CONST STRINGA_DUMMY          = (TAG_USER + $32000)

  /* [I..] (WORD) Maximum number of characters the string gadget accepts.
     Default defined below. */
NATIVE {STRINGA_MaxChars}       CONST STRINGA_MAXCHARS       = (STRINGA_DUMMY +  1)
  /* [I..] (STRPTR) Buffer for storing the current string of the gadget. */
NATIVE {STRINGA_Buffer}	       CONST STRINGA_BUFFER	       = (STRINGA_DUMMY +  2)
  /* [I..] (STRPTR) Buffer for storing the old (undo) string of the gadget. */
NATIVE {STRINGA_UndoBuffer}     CONST STRINGA_UNDOBUFFER     = (STRINGA_DUMMY +  3)
  /* [I..] (STRPTR) Buffer for the class to work with. */
NATIVE {STRINGA_WorkBuffer}     CONST STRINGA_WORKBUFFER     = (STRINGA_DUMMY +  4)
  /* [IS.] (WORD) Current position of cursor (relative to the beginning of the
     buffer). */
NATIVE {STRINGA_BufferPos}      CONST STRINGA_BUFFERPOS      = (STRINGA_DUMMY +  5)
  /* [IS.] (WORD) FIXME */
NATIVE {STRINGA_DispPos}        CONST STRINGA_DISPPOS        = (STRINGA_DUMMY +  6)
  /* [IS.] (struct KeyMap *) KeyMap to use (see <devices/keymaps.h>). */
NATIVE {STRINGA_AltKeyMap}      CONST STRINGA_ALTKEYMAP      = (STRINGA_DUMMY +  7)
  /* [IS.] (struct TextFont *) Font to use for displaying the string (see
     <graphics/text.h>). */
NATIVE {STRINGA_Font}	       CONST STRINGA_FONT	       = (STRINGA_DUMMY +  8)
  /* [IS.] (LONG) The lower 16 bits specify the background-pen, the upper 16
     bits the foreground-pen. The gadget is rendered, using these pens, if the
     gadget is inactive */
NATIVE {STRINGA_Pens}	       CONST STRINGA_PENS	       = (STRINGA_DUMMY +  9)
  /* [IS.] (LONG) Like STRINGA_Pens. These pens are used, if the gadget is
     active. */
NATIVE {STRINGA_ActivePens}     CONST STRINGA_ACTIVEPENS     = (STRINGA_DUMMY + 10)
  /* [I..] (struct Hook *) FIXME */
NATIVE {STRINGA_EditHook}       CONST STRINGA_EDITHOOK       = (STRINGA_DUMMY + 11)
  /* [IS.] (ULONG) FIXME */
NATIVE {STRINGA_EditModes}      CONST STRINGA_EDITMODES      = (STRINGA_DUMMY + 12)
  /* [IS.] (BOOL) If this is TRUE, the current character is overwritten, if the
     use presses a key. Otherwise, the new character is inserted. */
NATIVE {STRINGA_ReplaceMode}    CONST STRINGA_REPLACEMODE    = (STRINGA_DUMMY + 13)
  /* [IS.] (BOOL) FIXME */
NATIVE {STRINGA_FixedFieldMode} CONST STRINGA_FIXEDFIELDMODE = (STRINGA_DUMMY + 14)
  /* [IS.] (BOOL) FIXME */
NATIVE {STRINGA_NoFilterMode}   CONST STRINGA_NOFILTERMODE   = (STRINGA_DUMMY + 15)
  /* [IS.] (UWORD) Where should the text be justified? Use one of
     GACT_STRINGCENTER, GACT_STRINGLEFT and GACT_STRINGRIGHT (defined in
     <intuition/intuition.h>). */
NATIVE {STRINGA_Justification}  CONST STRINGA_JUSTIFICATION  = (STRINGA_DUMMY + 16)
  /* [ISG] (LONG) If this is set, the string gadget will only accept numeric
     values. Argument is the number, the string gadget is to be set to. When
     getting this attribute, this number is returned. */
NATIVE {STRINGA_LongVal}        CONST STRINGA_LONGVAL        = (STRINGA_DUMMY + 17)
  /* [ISG] (STRPTR) If this is set, the string gadget will accept strings.
     Argument is a string that is to be copied into the string gadget and its
     buffer. */
NATIVE {STRINGA_TextVal}        CONST STRINGA_TEXTVAL        = (STRINGA_DUMMY + 18)
  /* [IS.] (BOOL) If this is set, pressing the "Help" key, while the gadget is
     active, will unselect the gadget. */
NATIVE {STRINGA_ExitHelp}       CONST STRINGA_EXITHELP       = (STRINGA_DUMMY + 19) /* Exit on "Help" */

/* Default, if STRINGA_MaxChars is not set. */
NATIVE {SG_DEFAULTMAXCHARS} CONST SG_DEFAULTMAXCHARS = (128)

/* Gadget layout related attributes. */
NATIVE {LAYOUTA_Dummy}	       CONST LAYOUTA_DUMMY	       = (TAG_USER + $38000)
  /* FIXME */
NATIVE {LAYOUTA_LayoutObj}      CONST LAYOUTA_LAYOUTOBJ      = (LAYOUTA_DUMMY + 1)
  /* FIXME */
NATIVE {LAYOUTA_Spacing}        CONST LAYOUTA_SPACING        = (LAYOUTA_DUMMY + 2)
  /* FIXME (see below) */
NATIVE {LAYOUTA_Orientation}    CONST LAYOUTA_ORIENTATION    = (LAYOUTA_DUMMY + 3)
  /* FIXME */
NATIVE {LAYOUTA_ChildMaxWidth}  CONST LAYOUTA_CHILDMAXWIDTH  = (LAYOUTA_DUMMY + 4)
  /* FIXME */
NATIVE {LAYOUTA_ChildMaxHeight} CONST LAYOUTA_CHILDMAXHEIGHT = (LAYOUTA_DUMMY + 5)

/* Orientation values. */
NATIVE {LORIENT_NONE}  CONST LORIENT_NONE  = 0
NATIVE {LORIENT_HORIZ} CONST LORIENT_HORIZ = 1
NATIVE {LORIENT_VERT}  CONST LORIENT_VERT  = 2
