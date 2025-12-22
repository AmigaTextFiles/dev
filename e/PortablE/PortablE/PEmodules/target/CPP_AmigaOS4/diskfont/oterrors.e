/* $Id: oterrors.h,v 1.13 2005/11/10 15:31:54 hjfrieden Exp $ */
OPT NATIVE
{#include <diskfont/oterrors.h>}
NATIVE {DISKFONT_OTERRORS_H} CONST

/* PRELIMINARY */
NATIVE {OTERR_Failure}      CONST OTERR_FAILURE      = -1 /* catch-all for error */
NATIVE {OTERR_Success}       CONST OTERR_SUCCESS       = 0 /* no error */
NATIVE {OTERR_BadTag}        CONST OTERR_BADTAG        = 1 /* inappropriate tag for function */
NATIVE {OTERR_UnknownTag}    CONST OTERR_UNKNOWNTAG    = 2 /* unknown tag for function */
NATIVE {OTERR_BadData}       CONST OTERR_BADDATA       = 3 /* catch-all for bad tag data */
NATIVE {OTERR_NoMemory}      CONST OTERR_NOMEMORY      = 4 /* insufficient memory for operation */
NATIVE {OTERR_NoFace}        CONST OTERR_NOFACE        = 5 /* no typeface currently specified */
NATIVE {OTERR_BadFace}       CONST OTERR_BADFACE       = 6 /* typeface specification problem */
NATIVE {OTERR_NoGlyph}       CONST OTERR_NOGLYPH       = 7 /* no glyph specified */
NATIVE {OTERR_BadGlyph}      CONST OTERR_BADGLYPH      = 8 /* bad glyph code or glyph range */
NATIVE {OTERR_NoShear}       CONST OTERR_NOSHEAR       = 9 /* shear only partially specified */
NATIVE {OTERR_NoRotate}     CONST OTERR_NOROTATE     = 10 /* rotate only partially specified */
NATIVE {OTERR_TooSmall}     CONST OTERR_TOOSMALL     = 11 /* typeface metrics yield tiny glyphs */
NATIVE {OTERR_UnknownGlyph} CONST OTERR_UNKNOWNGLYPH = 12 /* glyph not known by engine */
