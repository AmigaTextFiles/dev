/* $Id: bitmap.h,v 1.11 2005/11/10 15:36:44 hjfrieden Exp $ */
OPT NATIVE
MODULE 'target/reaction/reaction', 'target/intuition/imageclass'
{#include <images/bitmap.h>}
NATIVE {IMAGES_BITMAP_H} CONST

NATIVE {BITMAP_Dummy}              CONST BITMAP_DUMMY              = (REACTION_DUMMY + $19000)

/*****************************************************************************/

/* Additional attributes defined by the bitmap class
 */

NATIVE {BITMAP_SourceFile}         CONST BITMAP_SOURCEFILE         = (BITMAP_DUMMY + 1)
    /* (STRPTR) Filename of datatype object */

NATIVE {BITMAP_Screen}             CONST BITMAP_SCREEN             = (BITMAP_DUMMY + 2)
    /* (struct Screen *) Screen to remap the datatype image to */

NATIVE {BITMAP_Precision}          CONST BITMAP_PRECISION          = (BITMAP_DUMMY + 3)
    /* (ULONG) OBP_PRECISION to use in remapping */

NATIVE {BITMAP_Masking}            CONST BITMAP_MASKING            = (BITMAP_DUMMY + 4)
    /* (BOOL) Draw image with transparent background if a mask is available */

NATIVE {BITMAP_BitMap}             CONST BITMAP_BITMAP             = (BITMAP_DUMMY + 5)
    /* (struct BitMap *) Ready-to-use bitmap */

NATIVE {BITMAP_Width}              CONST BITMAP_WIDTH              = (BITMAP_DUMMY + 6)
    /* (LONG) Width of bitmap */

NATIVE {BITMAP_Height}             CONST BITMAP_HEIGHT             = (BITMAP_DUMMY + 7)
    /* (LONG) Height of bitmap */

NATIVE {BITMAP_MaskPlane}          CONST BITMAP_MASKPLANE          = (BITMAP_DUMMY + 8)
    /* (APTR) Masking plane */

NATIVE {BITMAP_SelectSourceFile}   CONST BITMAP_SELECTSOURCEFILE   = (BITMAP_DUMMY + 9)
    /* (STRPTR) Filename for "selected state" picture */

NATIVE {BITMAP_SelectBitMap}       CONST BITMAP_SELECTBITMAP       = (BITMAP_DUMMY + 10)
    /* (struct BitMap *) Bitmap for "selected state" */

NATIVE {BITMAP_SelectWidth}        CONST BITMAP_SELECTWIDTH        = (BITMAP_DUMMY + 11)
    /* (LONG) Width of "selected state" bitmap */

NATIVE {BITMAP_SelectHeight}       CONST BITMAP_SELECTHEIGHT       = (BITMAP_DUMMY + 12)
    /* (LONG) Height of "selected state" bitmap */

NATIVE {BITMAP_SelectMaskPlane}    CONST BITMAP_SELECTMASKPLANE    = (BITMAP_DUMMY + 13)
    /* (APTR) Masking plane for "selected state" */

NATIVE {BITMAP_OffsetX}            CONST BITMAP_OFFSETX            = (BITMAP_DUMMY + 14)
    /* (LONG) Left offset in (passed by application) bitmap */

NATIVE {BITMAP_OffsetY}            CONST BITMAP_OFFSETY            = (BITMAP_DUMMY + 15)
    /* (LONG) Top offset in (passed by application) bitmap */

NATIVE {BITMAP_SelectOffsetX}      CONST BITMAP_SELECTOFFSETX      = (BITMAP_DUMMY + 16)
    /* (LONG) Left offset in (passed by application) "selected state" bitmap */

NATIVE {BITMAP_SelectOffsetY}      CONST BITMAP_SELECTOFFSETY      = (BITMAP_DUMMY + 17)
    /* (LONG) Top offset in (passed by application) "selected state" bitmap */

NATIVE {BITMAP_Transparent}        CONST BITMAP_TRANSPARENT        = (BITMAP_DUMMY + 18)
    /* (BOOL) Make color zero transparent if no mask is available */

NATIVE {BITMAP_DisabledSourceFile} CONST BITMAP_DISABLEDSOURCEFILE = (BITMAP_DUMMY + 19)
    /* (STRPTR) Filename for "disabled state" picture (V51) */

NATIVE {BITMAP_DisabledBitMap}     CONST BITMAP_DISABLEDBITMAP     = (BITMAP_DUMMY + 20)
    /* (struct BitMap *) Bitmap for "disabled state" (V51) */

NATIVE {BITMAP_DisabledWidth}      CONST BITMAP_DISABLEDWIDTH      = (BITMAP_DUMMY + 21)
    /* (LONG) Width of "disabled state" bitmap (V51) */

NATIVE {BITMAP_DisabledHeight}     CONST BITMAP_DISABLEDHEIGHT     = (BITMAP_DUMMY + 22)
    /* (LONG) Height of "disabled state" bitmap (V51) */

NATIVE {BITMAP_DisabledMaskPlane}  CONST BITMAP_DISABLEDMASKPLANE  = (BITMAP_DUMMY + 23)
    /* (APTR) Masking plane for "disabled state" (V51) */

NATIVE {BITMAP_DisabledOffsetX}    CONST BITMAP_DISABLEDOFFSETX    = (BITMAP_DUMMY + 24)
    /* (LONG) Left offset in (passed by application) "disabled state"
       bitmap (V51) */

NATIVE {BITMAP_DisabledOffsetY}    CONST BITMAP_DISABLEDOFFSETY    = (BITMAP_DUMMY + 25)
    /* (LONG) Top offset in (passed by application) "disabled state"
       bitmap (V51) */
