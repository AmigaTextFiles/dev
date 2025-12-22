/* $VER: chooser.h 53.21 (29.9.2013) */
OPT NATIVE
MODULE 'target/reaction/reaction', 'target/intuition/gadgetclass'
MODULE 'target/utility/tagitem'
{#include <gadgets/chooser.h>}
NATIVE {GADGETS_CHOOSER_H} CONST

/* Predefined Minimum dimensions for safe operation.
 */
NATIVE {CHOOSER_MinWidth}  CONST CHOOSER_MINWIDTH  = 36
NATIVE {CHOOSER_MinHeight} CONST CHOOSER_MINHEIGHT = 10

/*****************************************************************************/

/* Chooser node attributes.
 */
NATIVE {CNA_Dummy}     CONST CNA_DUMMY     = (TAG_USER+$5001500)

NATIVE {CNA_Text}      CONST CNA_TEXT      = (CNA_DUMMY+1)
    /* (STRPTR) Text for the node. */

NATIVE {CNA_Image}     CONST CNA_IMAGE     = (CNA_DUMMY+2)
    /* (struct Image *) Normal image for node. */

NATIVE {CNA_SelImage}  CONST CNA_SELIMAGE  = (CNA_DUMMY+3)
    /* (struct Image *) Select image for node. */

NATIVE {CNA_UserData}  CONST CNA_USERDATA  = (CNA_DUMMY+4)
    /* (APTR) User data, use as desired. */

NATIVE {CNA_Separator} CONST CNA_SEPARATOR = (CNA_DUMMY+5)
    /* (BOOL) Render a separator bar. */

NATIVE {CNA_Disabled}  CONST CNA_DISABLED  = (CNA_DUMMY+6)
    /* (BOOL) Disabled entry. */

NATIVE {CNA_BGPen}     CONST CNA_BGPEN     = (CNA_DUMMY+7)
    /* (WORD) Background Pen. (V51) */

NATIVE {CNA_FGPen}     CONST CNA_FGPEN     = (CNA_DUMMY+8)
    /* (WORD) Foreground Pen. (V51) */

NATIVE {CNA_ReadOnly}  CONST CNA_READONLY  = (CNA_DUMMY+9)
    /* (BOOL) Non-selectable entry. */

NATIVE {CNA_CopyText}  CONST CNA_COPYTEXT  = (CNA_DUMMY+10)
	/* (BOOL) Copy CNA_Text into internal buffer */

/*****************************************************************************/

/* Additional attributes defined by the Chooser class
 */
NATIVE {CHOOSER_Dummy}              CONST CHOOSER_DUMMY              = (REACTION_DUMMY+$0001000)

NATIVE {CHOOSER_PopUp}              CONST CHOOSER_POPUP              = (CHOOSER_DUMMY+1)
    /* (BOOL) Make it a popup menu. Defaults to FALSE.
     * This item is mutually exclusive to CHOOSER_DropDown,
     * one of the two MUST be TRUE.
     */

NATIVE {CHOOSER_DropDown}           CONST CHOOSER_DROPDOWN           = (CHOOSER_DUMMY+2)
    /* (BOOL) Make it a dropdown menu. Defaults to FALSE.
     * This item is mutually exclusive to CHOOSER_PopUp,
     * one of the two MUST be TRUE.
     */

NATIVE {CHOOSER_Title}              CONST CHOOSER_TITLE              = (CHOOSER_DUMMY+3)
    /* (STRPTR) Title for the dropdown. Defaults to NULL. */

NATIVE {CHOOSER_Labels}             CONST CHOOSER_LABELS             = (CHOOSER_DUMMY+4)
    /* (struct List *) Exec List of labels for the menu. Either this or
     * CHOOSER_LabelArray (see below) is required. */

NATIVE {CHOOSER_Active}             CONST CHOOSER_ACTIVE             = (CHOOSER_DUMMY+5)
    /* (WORD) Active label in the list. Defaults to 0. */

NATIVE {CHOOSER_Selected}           CONST CHOOSER_SELECTED           = (CHOOSER_ACTIVE)
    /* A more logical NEW NAME for the above. */

NATIVE {CHOOSER_Width}              CONST CHOOSER_WIDTH              = (CHOOSER_DUMMY+6)
    /* (WORD) The width of the popup menu. Defaults to the width of the
     * gadget. */

NATIVE {CHOOSER_AutoFit}            CONST CHOOSER_AUTOFIT            = (CHOOSER_DUMMY+7)
    /* (BOOL) Make the menu automatically fit its labels. Defaults to FALSE.
     * NOTE: Obsolete starting with V51, don't use in new code. */

NATIVE {CHOOSER_MaxLabels}          CONST CHOOSER_MAXLABELS          = (CHOOSER_DUMMY+9)
    /* (WORD) Maximum number of labels to be shown in the menu regardless
     * of how many are in the CHOOSER_Labels list. Defaults to 12. */

NATIVE {CHOOSER_Offset}             CONST CHOOSER_OFFSET             = (CHOOSER_DUMMY+10)
    /* (WORD) Add a fixed value offset to the CHOOSER_Selected value
     * for notification methods. This is useful in connecting a Chooser
     * with item IDs 0 thru 11 to a Calendar's month which is 1 thru 12.
     * In that situation, a CHOOSER_Offset of 1 would be used to match
     * the starting offsets of the respective tags.
     * Defaults to 0. (V41) */

NATIVE {CHOOSER_Hidden}             CONST CHOOSER_HIDDEN             = (CHOOSER_DUMMY+11)
    /* (BOOL) If set, the Chooser will not render its main body and you
     * may use WM_ACTIVATEGADGET to make the Chooser appear.
     * Defaults to FALSE. (V42 prerelease - V41.101 or later) */

NATIVE {CHOOSER_LabelArray}         CONST CHOOSER_LABELARRAY         = (CHOOSER_DUMMY+12)
    /* (STRPTR *) A NULL-terminated array of strings to use as labels. Use
     * ~0UL as string to add a separator bar to the list. Either this or
     * CHOOSER_Labels (see above) is required. New for V45.2 */

NATIVE {CHOOSER_Justification}      CONST CHOOSER_JUSTIFICATION      = (CHOOSER_DUMMY+13)
    /* (WORD) How to align the labels. New for V45.3 */

NATIVE {CHOOSER_ImageJustification} CONST CHOOSER_IMAGEJUSTIFICATION = (CHOOSER_DUMMY+14)
    /* (WORD) How to align the images. New for V51.2 */

NATIVE {CHOOSER_SelectedNode}       CONST CHOOSER_SELECTEDNODE       = (CHOOSER_DUMMY+15)
    /* (struct Node *) Get the active Chooser node pointer. New for V52.5 */
	
/*    Possible values for CHOOSER_Justification
 *    and CHOOSER_ImageJustification
 */
NATIVE {CHJ_LEFT}   CONST CHJ_LEFT   = 0  /* Default */
NATIVE {CHJ_CENTER} CONST CHJ_CENTER = 1
NATIVE {CHJ_RIGHT}  CONST CHJ_RIGHT  = 2
