/* $Id: coerce.h,v 1.11 2005/11/10 15:36:43 hjfrieden Exp $ */
OPT NATIVE
{#include <graphics/coerce.h>}
NATIVE {GRAPHICS_COERCE_H} CONST

/* These flags are passed (in combination) to CoerceMode() to determine the
 * type of coercion required.
 */

/****************************************************************************/

/* Ensure that the mode coerced to can display just as many colours as the
 * ViewPort being coerced.
 */
NATIVE {PRESERVE_COLORS} CONST PRESERVE_COLORS = 1

/* Ensure that the mode coerced to is not interlaced. */
NATIVE {AVOID_FLICKER} CONST AVOID_FLICKER = 2

/* Coercion should ignore monitor compatibility issues. */
NATIVE {IGNORE_MCOMPAT} CONST IGNORE_MCOMPAT = 4

NATIVE {BIDTAG_COERCE} CONST BIDTAG_COERCE = 1 /* Private */
