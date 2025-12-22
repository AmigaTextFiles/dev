/* checkbox.h 53.21 (29.9.2013) */
OPT NATIVE
MODULE 'target/reaction/reaction', 'target/intuition/gadgetclass', 'target/libraries/gadtools'
{#include <gadgets/checkbox.h>}
NATIVE {GADGETS_CHECKBOX_H} CONST

/* Additional attributes defined by the checkbox.gadget class */
NATIVE {CHECKBOX_Dummy}         CONST CHECKBOX_DUMMY         = (REACTION_DUMMY + $11000)

NATIVE {CHECKBOX_TextPen}       CONST CHECKBOX_TEXTPEN       = (CHECKBOX_DUMMY+1)
    /* (WORD) Pen to use for text (~0 uses TEXTPEN). */

NATIVE {CHECKBOX_FillTextPen}   CONST CHECKBOX_FILLTEXTPEN   = (CHECKBOX_DUMMY+2)
    /* (WORD) Pen to use for fill (~0 uses FILLTEXTPEN). */

NATIVE {CHECKBOX_BackgroundPen} CONST CHECKBOX_BACKGROUNDPEN = (CHECKBOX_DUMMY+3)
    /* (WORD) Pen to use for background (~0 uses BACKGROUNDPEN) */

NATIVE {CHECKBOX_BevelStyle}    CONST CHECKBOX_BEVELSTYLE    = (CHECKBOX_DUMMY+4)
    /* (WORD) Optional outer bevel style - OBSOLETE */

NATIVE {CHECKBOX_TextPlace}     CONST CHECKBOX_TEXTPLACE     = (CHECKBOX_DUMMY+5)
    /* (LONG) Gadget Text Location (PLACETEXT_LEFT or PLACETEXT_RIGHT). */

NATIVE {CHECKBOX_Checked}       CONST CHECKBOX_CHECKED       = GA_SELECTED
    /* (BOOL) Checkmark state. */

NATIVE {CHECKBOX_Invert}        CONST CHECKBOX_INVERT        = (CHECKBOX_DUMMY+6)
    /* (BOOL) CheckMark state: TRUE is FALSE and FALSE is TRUE. V50. */
