/* $VER: radiobutton.h 53.21 (29.9.2013) */
OPT NATIVE
MODULE 'target/reaction/reaction', 'target/intuition/gadgetclass'
MODULE 'target/utility/tagitem'
{#include <gadgets/radiobutton.h>}
NATIVE {GADGETS_RADIOBUTTON_H} CONST

/* Defines for the radiobutton node attributes. */
NATIVE {RBNA_Dummy}    CONST RBNA_DUMMY    = (TAG_USER+$020000)

NATIVE {RBNA_UserData} CONST RBNA_USERDATA = (RBNA_DUMMY+1)
    /* (APTR) User Data. */

NATIVE {RBNA_Label}   CONST RBNA_LABEL   = (RBNA_DUMMY+2)
    /* (STRPTR) Text string for this MX button. */

NATIVE {RBNA_HintInfo} CONST RBNA_HINTINFO = (RBNA_DUMMY+3)
    /* (STRPTR) Text string for the hint info for this MX button */

NATIVE {RBNA_Disabled} CONST RBNA_DISABLED = (RBNA_DUMMY+4)
	/* (BOOL) If TRUE, renders this MX button in disabled state */

CONST RBNA_LABELS = RBNA_LABEL

/*****************************************************************************/

/* Additional attributes defined by the RadioButton class */
NATIVE {RADIOBUTTON_Dummy}      CONST RADIOBUTTON_DUMMY      = (REACTION_DUMMY + $14000)

NATIVE {RADIOBUTTON_Labels}     CONST RADIOBUTTON_LABELS     = (RADIOBUTTON_DUMMY+1)
    /* (struct List *) Radio Button Label List. */

NATIVE {RADIOBUTTON_Strings}    CONST RADIOBUTTON_STRINGS    = (RADIOBUTTON_DUMMY+2)
    /* RESERVED - presently unsupported */

NATIVE {RADIOBUTTON_Spacing}    CONST RADIOBUTTON_SPACING    = (RADIOBUTTON_DUMMY+3)
    /* (WORD) Spacing between radio buttons */

NATIVE {RADIOBUTTON_Selected}   CONST RADIOBUTTON_SELECTED   = (RADIOBUTTON_DUMMY+4)
    /* (WORD) selected radio button (OM_GET/OM_SET/OM_NOTIFY) */

NATIVE {RADIOBUTTON_LabelPlace} CONST RADIOBUTTON_LABELPLACE = (RADIOBUTTON_DUMMY+5)
    /* (WORD) label location (OM_GET/OM_SET) */
    
NATIVE {RADIOBUTTON_LabelArray} CONST RADIOBUTTON_LABELARRAY = (RADIOBUTTON_DUMMY+6)
    /* (STRPTR *) Radio Button Labels */
