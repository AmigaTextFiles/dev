/* $VER: speedbar.h 53.21 (29.9.2013) */
OPT NATIVE
MODULE 'target/reaction/reaction', 'target/intuition/gadgetclass'
MODULE 'target/utility/tagitem', 'target/exec/types', 'target/intuition/cghooks', 'target/exec/nodes'
{#include <gadgets/speedbar.h>}
NATIVE {GADGETS_SPEEDBAR_H} CONST

/* Defines for the speedbar node attributes.
 */
NATIVE {SBNA_Dummy}     CONST SBNA_DUMMY     = (TAG_USER+$010000)

NATIVE {SBNA_Left}      CONST SBNA_LEFT      = (SBNA_DUMMY+1)
    /* (WORD) Left offset of button. (OBSOLETE - DON'T USE) */

NATIVE {SBNA_Top}       CONST SBNA_TOP       = (SBNA_DUMMY+2)
    /* (WORD) Top offset of button. (OBSOLETE - DON'T USE) */

NATIVE {SBNA_Width}     CONST SBNA_WIDTH     = (SBNA_DUMMY+3)
    /* (WORD) Minimum inner width of button. */

NATIVE {SBNA_Height}    CONST SBNA_HEIGHT    = (SBNA_DUMMY+4)
    /* (WORD) Minimum inner height of button. */

NATIVE {SBNA_UserData}  CONST SBNA_USERDATA  = (SBNA_DUMMY+5)
    /* (APTR) User data, have a blast. */

NATIVE {SBNA_Enabled}   CONST SBNA_ENABLED   = (SBNA_DUMMY+6)
    /* (BOOL) Should this button actually be shown? */

NATIVE {SBNA_Spacing}   CONST SBNA_SPACING   = (SBNA_DUMMY+7)
    /* (WORD) Spacing between this button and the previous one. */

NATIVE {SBNA_Highlight} CONST SBNA_HIGHLIGHT = (SBNA_DUMMY+8)
    /* (UWORD) Highlight mode (see below). */

NATIVE {SBNA_Image}     CONST SBNA_IMAGE     = (SBNA_DUMMY+9)
    /* (struct Image *) Render image pointer. */

NATIVE {SBNA_SelImage}  CONST SBNA_SELIMAGE  = (SBNA_DUMMY+10)
    /* (struct Image *) Select image pointer. */

NATIVE {SBNA_Help}      CONST SBNA_HELP      = (SBNA_DUMMY+11)
    /* (STRPTR) Optional help text message pointer. */

NATIVE {SBNA_Toggle}    CONST SBNA_TOGGLE    = (SBNA_DUMMY+12)
    /* (BOOL) Make button a toggle button. */

NATIVE {SBNA_Selected}  CONST SBNA_SELECTED  = (SBNA_DUMMY+13)
    /* (BOOL) Sets state of a toggle button. */

NATIVE {SBNA_MXGroup}   CONST SBNA_MXGROUP   = (SBNA_DUMMY+14)
    /* (WORD) Mutual exclusion group ID of button, implies SBNA_Toggle. */

NATIVE {SBNA_Disabled}  CONST SBNA_DISABLED  = (SBNA_DUMMY+15)
    /* (BOOL) Is this button disabled? */

NATIVE {SBNA_Text}      CONST SBNA_TEXT      = (SBNA_DUMMY+16)
    /* (STRPTR) Label to display below the image. (V50) */

NATIVE {SBNA_Spacer}    CONST SBNA_SPACER    = (SBNA_DUMMY+17)
    /* (BOOL) Is this button a spacer? (V53) */

NATIVE {SBNA_Separator} CONST SBNA_SEPARATOR = (SBNA_DUMMY+18)
    /* (BOOL) Is this button a separator? (V53) */

NATIVE {SBNA_HintInfo}  CONST SBNA_HINTINFO  = (SBNA_DUMMY+19)
    /* (STRPTR) Set the hintinfo for this button (V53) */
    
/* Possible highlight modes. */
NATIVE {SBH_NONE}     CONST SBH_NONE     = 0
NATIVE {SBH_BACKFILL} CONST SBH_BACKFILL = 1
NATIVE {SBH_RECESS}   CONST SBH_RECESS   = 2
NATIVE {SBH_IMAGE}    CONST SBH_IMAGE    = 3

/*****************************************************************************/

/* Additional attributes defined by the speedbar.gadget class */
NATIVE {SPEEDBAR_Dummy}        CONST SPEEDBAR_DUMMY        = (REACTION_DUMMY + $13000)

NATIVE {SPEEDBAR_Buttons}      CONST SPEEDBAR_BUTTONS      = (SPEEDBAR_DUMMY+1)
    /* (struct List *) Button list */

NATIVE {SPEEDBAR_Orientation}  CONST SPEEDBAR_ORIENTATION  = (SPEEDBAR_DUMMY+2)
    /* (UWORD) Horizontal/vertical mode (SBORIENT_HORIZ or SBORIENT_VERT) */

NATIVE {SPEEDBAR_Background}   CONST SPEEDBAR_BACKGROUND   = (SPEEDBAR_DUMMY+3)
    /* (UWORD) Container background color */

NATIVE {SPEEDBAR_Window}       CONST SPEEDBAR_WINDOW       = (SPEEDBAR_DUMMY+4)
    /* (struct Window *) Window for titlebar help */

NATIVE {SPEEDBAR_StrumBar}     CONST SPEEDBAR_STRUMBAR     = (SPEEDBAR_DUMMY+5)
    /* (BOOL) Allow strumming of button bar (OBSOLETE - DON'T USE) */

NATIVE {SPEEDBAR_OnButton}     CONST SPEEDBAR_ONBUTTON     = (SPEEDBAR_DUMMY+6)
    /* (WORD) Turn on a button by ID number */

NATIVE {SPEEDBAR_OffButton}    CONST SPEEDBAR_OFFBUTTON    = (SPEEDBAR_DUMMY+7)
    /* (WORD) Turn off a button by ID number */

NATIVE {SPEEDBAR_ScrollLeft}   CONST SPEEDBAR_SCROLLLEFT   = (SPEEDBAR_DUMMY+8)
    /* (WORD) Scroll buttons left */

NATIVE {SPEEDBAR_ScrollRight}  CONST SPEEDBAR_SCROLLRIGHT  = (SPEEDBAR_DUMMY+9)
    /* (WORD) Scroll buttons right */

NATIVE {SPEEDBAR_Top}          CONST SPEEDBAR_TOP          = (SPEEDBAR_DUMMY+10)
    /* (WORD) Index of first visible button */

NATIVE {SPEEDBAR_Visible}      CONST SPEEDBAR_VISIBLE      = (SPEEDBAR_DUMMY+11)
    /* (WORD) Number of visible buttons */

NATIVE {SPEEDBAR_Total}        CONST SPEEDBAR_TOTAL        = (SPEEDBAR_DUMMY+12)
    /* (WORD) Total number of buttons in list */

NATIVE {SPEEDBAR_Help}         CONST SPEEDBAR_HELP         = (SPEEDBAR_DUMMY+13)
    /* (STRPTR) Window/Screen help text */

NATIVE {SPEEDBAR_BevelStyle}   CONST SPEEDBAR_BEVELSTYLE   = (SPEEDBAR_DUMMY+14)
    /* (UWORD) Bevel box style (BVS_DISPLAY, BVS_THIN, BVS_BOX, BVS_NONE) */

NATIVE {SPEEDBAR_Selected}     CONST SPEEDBAR_SELECTED     = (SPEEDBAR_DUMMY+15)
    /* (WORD) Last selected speedbar node ID number */

NATIVE {SPEEDBAR_SelectedNode} CONST SPEEDBAR_SELECTEDNODE = (SPEEDBAR_DUMMY+16)
    /* (struct Node *) Last selected speedbar node pointer */

NATIVE {SPEEDBAR_EvenSize}     CONST SPEEDBAR_EVENSIZE     = (SPEEDBAR_DUMMY+17)
    /* (BOOL) Size all buttons in bar evenly, according to largest contents */

NATIVE {SPEEDBAR_Font}         CONST SPEEDBAR_FONT         = (SPEEDBAR_DUMMY+18)
    /* (struct TextFont *) Font to use for SBNA_Text labels (V50) */

NATIVE {SPEEDBAR_TopNode}      CONST SPEEDBAR_TOPNODE      = (SPEEDBAR_DUMMY+19)
    /* (struct Node *) Node pointer of first visible button (V53) */

NATIVE {SPEEDBAR_ButtonType}   CONST SPEEDBAR_BUTTONTYPE   = (SPEEDBAR_DUMMY+20)
    /* (UWORD) Type of buttons: text, image or both (see below) (V53) */

NATIVE {SPEEDBAR_HorizPadding} CONST SPEEDBAR_HORIZPADDING = (SPEEDBAR_DUMMY+21)
    /* (UWORD) Horizontal padding between buttons and container frame (V53) */

NATIVE {SPEEDBAR_VertPadding}  CONST SPEEDBAR_VERTPADDING  = (SPEEDBAR_DUMMY+22)
    /* (UWORD) Vertical padding between buttons and container frame (V53) */

/*****************************************************************************/

/* Changes attributes for a speedbar node without
 * the need of detaching the speedbar list first.
 * This methods also takes care of updating the
 * display. (V50).
 */
NATIVE {SBM_SETNODEATTRS} CONST SBM_SETNODEATTRS = ($58000A)

NATIVE {sbSetNodeAttrs} OBJECT sbsetnodeattrs
    {MethodID}	methodid	:ULONG    /* SBM_SETNODEATTRS */
    {sb_GInfo}	ginfo	:PTR TO gadgetinfo
    {sb_Node}	node	:PTR TO ln     /* node whose attributes
                                        you are changing. */
    {sb_AttrList}	attrlist	:PTR TO tagitem /* list of attributes to change. */
ENDOBJECT

/*****************************************************************************/

/* SPEEDBAR_Orientation modes */
NATIVE {SBORIENT_HORIZ} CONST SBORIENT_HORIZ = 0
NATIVE {SBORIENT_VERT}  CONST SBORIENT_VERT  = 1

/* OBSOLETE DO NOT USE. */
NATIVE {SPEEDBAR_HORIZONTAL} CONST SPEEDBAR_HORIZONTAL = SBORIENT_HORIZ
NATIVE {SPEEDBAR_VERTICAL}   CONST SPEEDBAR_VERTICAL   = SBORIENT_VERT

/*****************************************************************************/

/* SPEEDBAR_ButtonType values */

NATIVE {SBTYPE_BOTH}  CONST SBTYPE_BOTH  = 0  /* Image and text */
NATIVE {SBTYPE_TEXT}  CONST SBTYPE_TEXT  = 1  /* Text only */
NATIVE {SBTYPE_IMAGE} CONST SBTYPE_IMAGE = 2  /* Image only */
