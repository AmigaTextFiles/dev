/* $VER: integer.h 53.21 (29.9.2013) */
OPT NATIVE
MODULE 'target/reaction/reaction', 'target/intuition/gadgetclass'
{#include <gadgets/integer.h>}
NATIVE {GADGETS_INTEGER_H} CONST

/* Additional attributes defined by the Integer class
 */
NATIVE {INTEGER_Dummy}      CONST INTEGER_DUMMY      = (REACTION_DUMMY+$0002000)

NATIVE {INTEGER_Number}     CONST INTEGER_NUMBER     = (INTEGER_DUMMY+1)
    /* (LONG) The value in the gadget.  Defaults to 0. */

NATIVE {INTEGER_MaxChars}   CONST INTEGER_MAXCHARS   = (INTEGER_DUMMY+2)
    /* (WORD) Maximum number of characters for the numer (including
       negative sign.  Defaults to 10. */

NATIVE {INTEGER_Minimum}    CONST INTEGER_MINIMUM    = (INTEGER_DUMMY+3)
    /* (LONG) Minimum value for the number. */

NATIVE {INTEGER_Maximum}    CONST INTEGER_MAXIMUM    = (INTEGER_DUMMY+4)
    /* (LONG) Maximum value for the number. */

NATIVE {INTEGER_Arrows}     CONST INTEGER_ARROWS     = (INTEGER_DUMMY+5)
    /* (BOOL) Should arrows be available.  Defaults to TRUE. */

NATIVE {INTEGER_MinVisible} CONST INTEGER_MINVISIBLE = (INTEGER_DUMMY+6)
    /* (BOOL) Minimum number of digits to be visible.  Defaults to 0. (V41) */
    
NATIVE {INTEGER_SkipVal}    CONST INTEGER_SKIPVAL    = (INTEGER_DUMMY+7)
    /* (BOOL) In-/decrease the number by the given value when user presses
       the arrows, defaults to 1. (V45) */
