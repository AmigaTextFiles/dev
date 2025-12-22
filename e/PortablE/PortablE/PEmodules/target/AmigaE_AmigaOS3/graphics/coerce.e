/* $VER: coerce.h 39.3 (15.2.1993) */
OPT NATIVE
{MODULE 'graphics/coerce'}

NATIVE {PRESERVE_COLORS} CONST PRESERVE_COLORS = 1

/* Ensure that the mode coerced to is not interlaced. */
NATIVE {AVOID_FLICKER} CONST AVOID_FLICKER = 2

/* Coercion should ignore monitor compatibility issues. */
NATIVE {IGNORE_MCOMPAT} CONST IGNORE_MCOMPAT = 4


NATIVE {BIDTAG_COERCE} CONST BIDTAG_COERCE = 1	/* Private */
