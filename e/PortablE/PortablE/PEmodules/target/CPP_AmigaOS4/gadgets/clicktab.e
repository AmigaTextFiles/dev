/* $VER: clicktab.h 53.21 (29.9.2013) */
OPT NATIVE
MODULE 'target/reaction/reaction', 'target/intuition/gadgetclass'
MODULE 'target/utility/tagitem'
{#include <gadgets/clicktab.h>}
NATIVE {GADGETS_CLICKTAB_H} CONST

/* Defines for the clicktab node attributes.
 */
NATIVE {TNA_Dummy}     CONST TNA_DUMMY     = (TAG_USER+$010000)

NATIVE {TNA_UserData}  CONST TNA_USERDATA  = (TNA_DUMMY+1)
    /* (APTR) user data, have a blast. */

NATIVE {TNA_Enabled}   CONST TNA_ENABLED   = (TNA_DUMMY+2) /* was never implemented, now obsolete! */
NATIVE {TNA_Spacing}   CONST TNA_SPACING   = (TNA_DUMMY+3) /* obsolete! */
NATIVE {TNA_Highlight} CONST TNA_HIGHLIGHT = (TNA_DUMMY+4) /* obsolete! */

NATIVE {TNA_Image}     CONST TNA_IMAGE     = (TNA_DUMMY+5)
    /* (struct Image *) render image pointer. */

NATIVE {TNA_SelImage}  CONST TNA_SELIMAGE  = (TNA_DUMMY+6)
    /* (struct Image *) select image pointer. */

NATIVE {TNA_Text}      CONST TNA_TEXT      = (TNA_DUMMY+7)
    /* (CONST_STRPTR) tab text label string pointer. */

NATIVE {TNA_Number}    CONST TNA_NUMBER    = (TNA_DUMMY+8)
    /* (uint16) numeric ID assignment for tab. */

NATIVE {TNA_TextPen}   CONST TNA_TEXTPEN   = (TNA_DUMMY+9)
    /* (int16) Text pen ID to render tab text. */

NATIVE {TNA_Disabled}  CONST TNA_DISABLED  = (TNA_DUMMY+10)
    /* (BOOL) Is this button disabled?. (V42) */

NATIVE {TNA_Flagged}   CONST TNA_FLAGGED   = (TNA_DUMMY+11)
    /* (BOOL) show the "flag" image in the tab (V52.6) */

NATIVE {TNA_HintInfo}  CONST TNA_HINTINFO  = (TNA_DUMMY+12)
    /* (CONST_STRPTR) define a hintinfo for this clicktab node (V53.10) */

NATIVE {TNA_CloseGadget} CONST TNA_CLOSEGADGET = (TNA_DUMMY+13 )
    /* (BOOL) specify if this tab has a close gadget */

NATIVE {TNA_SoftStyle} CONST TNA_SOFTSTYLE = (TNA_DUMMY+14)
    /* (int32) Specify a custom softstyle for this tabs title */

/*****************************************************************************/

/* Additional attributes defined by the clicktab.gadget class
 */
NATIVE {CLICKTAB_Dummy}             CONST CLICKTAB_DUMMY             = (REACTION_DUMMY + $27000)

NATIVE {CLICKTAB_Labels}            CONST CLICKTAB_LABELS            = (CLICKTAB_DUMMY+1)
    /* (struct List *) button list */

NATIVE {CLICKTAB_Current}           CONST CLICKTAB_CURRENT           = (CLICKTAB_DUMMY+2)
    /* (uint16) Currently selected tab id# */

NATIVE {CLICKTAB_CurrentNode}       CONST CLICKTAB_CURRENTNODE       = (CLICKTAB_DUMMY+3)
    /* (struct Node *) Currently selected tab node */

NATIVE {CLICKTAB_Orientation}       CONST CLICKTAB_ORIENTATION       = (CLICKTAB_DUMMY+4)
    /* (int16) Horizontal/Vertical/Flip mode - **Not Implemented!** */

NATIVE {CLICKTAB_PageGroup}         CONST CLICKTAB_PAGEGROUP         = (CLICKTAB_DUMMY+5)
    /* (Object *) Embedded page.gadget object child pointer. (V42) */

NATIVE {CLICKTAB_PageGroupBackFill} CONST CLICKTAB_PAGEGROUPBACKFILL = (CLICKTAB_DUMMY+6)
    /* (struct Hook *) Embedded page.gadget object + selected ClickTab backfill
       pointer. (V42) */

NATIVE {CLICKTAB_LabelTruncate}     CONST CLICKTAB_LABELTRUNCATE     = (CLICKTAB_DUMMY+7)
    /* (BOOL) Allow labels to become truncated when gadget width
       is compressed. (V51) */

NATIVE {CLICKTAB_FlagImage}         CONST CLICKTAB_FLAGIMAGE         = (CLICKTAB_DUMMY+8)
    /* (struct Image *) Bitmap to be rendered in the tab if 
       TNA_Flagged is TRUE (V52.6) */

NATIVE {CLICKTAB_EvenSize}          CONST CLICKTAB_EVENSIZE          = (CLICKTAB_DUMMY+9)
    /* (BOOL) Allows the user to override the system prefs setting
       for even size tabs. Defaults to system settings. (V53.1) */

NATIVE {CLICKTAB_Total}             CONST CLICKTAB_TOTAL             = (CLICKTAB_DUMMY+10)
    /* (uint32) Total number of nodes attached to the gadget. (V53.3) */

NATIVE {CLICKTAB_PageGroupBorder}   CONST CLICKTAB_PAGEGROUPBORDER   = (CLICKTAB_DUMMY+11)
NATIVE {CLICKTAB_PageBorder}        CONST CLICKTAB_PAGEBORDER        = CLICKTAB_PAGEGROUPBORDER
    /* (BOOL) Specify whether the border is to be drawn around pages
       attached to the clicktab. (V53.7) */

NATIVE {CLICKTAB_AutoFit}           CONST CLICKTAB_AUTOFIT           = (CLICKTAB_DUMMY+12)
    /* (BOOL) Automatically fit dynamic tabs. (V53.20) */

NATIVE {CLICKTAB_AutoTabNumbering}  CONST CLICKTAB_AUTOTABNUMBERING  = (CLICKTAB_DUMMY+13)
    /* (BOOL) Automatically number tabs. (V53.23) */

NATIVE {CLICKTAB_CloseImage}        CONST CLICKTAB_CLOSEIMAGE        = (CLICKTAB_DUMMY+14)
    /* (Object *) Specify a BOOPSI image to use for the TABs close 
       gadget. (V53.29) */

NATIVE {CLICKTAB_Closed}            CONST CLICKTAB_CLOSED            = (CLICKTAB_DUMMY+15)
    /* (ULONG) Returns the number of the last tab on which a close gadget 
        was used (V53.29) */

NATIVE {CLICKTAB_NodeClosed}        CONST CLICKTAB_NODECLOSED        = (CLICKTAB_DUMMY+16)
    /* (struct Node *) Returns the tab node address in which the close
       gadget was last used (V53.29) */

NATIVE {CLICKTAB_ClosePlacement}    CONST CLICKTAB_CLOSEPLACEMENT    = (CLICKTAB_DUMMY+17)
    /* (ULONG) Specify which side of the tab the close gadget should 
       appear. (V53.30) */

NATIVE {CLICKTAB_PageTransparent}   CONST CLICKTAB_PAGETRANSPARENT   = (CLICKTAB_DUMMY+18)
    /* (BOOL) The PageObject attached to this gadget should not backfill
       itself. (V53.30) */

/*****************************************************************************/

/* CLICKTAB_Orientation Modes
 */
NATIVE {CTORIENT_HORIZ}     CONST CTORIENT_HORIZ     = 0
NATIVE {CTORIENT_VERT}      CONST CTORIENT_VERT      = 1
NATIVE {CTORIENT_HORIZFLIP} CONST CTORIENT_HORIZFLIP = 2
NATIVE {CTORIENT_VERTFLIP}  CONST CTORIENT_VERTFLIP  = 3


/* Close gadget placement
 */
NATIVE {PLACECLOSE_LEFT}  CONST PLACECLOSE_LEFT  = 0
NATIVE {PLACECLOSE_RIGHT} CONST PLACECLOSE_RIGHT = 1
