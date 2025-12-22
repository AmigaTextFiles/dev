/* $VER: bitmap.h 44.1 (19.10.1999) */
OPT NATIVE
MODULE 'target/reaction/reaction', 'target/intuition/imageclass'
{#include <images/bitmap.h>}
NATIVE {IMAGES_BITMAP_H} CONST

NATIVE {BITMAP_Dummy}		   CONST BITMAP_DUMMY		   = (REACTION_DUMMY + $19000)

/*****************************************************************************/

/* Additional attributes defined by the bitmap class
 */

NATIVE {BITMAP_SourceFile}        CONST BITMAP_SOURCEFILE        = (BITMAP_DUMMY + 1)
   /* (STRPTR) Filename of datatype object */

NATIVE {BITMAP_Screen}            CONST BITMAP_SCREEN            = (BITMAP_DUMMY + 2)
   /* (struct Screen *) Screen to remap the datatype image to */

NATIVE {BITMAP_Precision}         CONST BITMAP_PRECISION         = (BITMAP_DUMMY + 3)
   /* (ULONG) OBP_PRECISION to use in remapping */

NATIVE {BITMAP_Masking}           CONST BITMAP_MASKING           = (BITMAP_DUMMY + 4)
   /* (BOOL) Mask image */

NATIVE {BITMAP_BitMap}            CONST BITMAP_BITMAP            = (BITMAP_DUMMY + 5)
   /* (struct BitMap *) Ready-to-use bitmap */

NATIVE {BITMAP_Width}             CONST BITMAP_WIDTH             = (BITMAP_DUMMY + 6)
   /* (LONG) Width of bitmap */

NATIVE {BITMAP_Height}            CONST BITMAP_HEIGHT            = (BITMAP_DUMMY + 7)
   /* (LONG) Height of bitmap */

NATIVE {BITMAP_MaskPlane}         CONST BITMAP_MASKPLANE         = (BITMAP_DUMMY + 8)
   /* (APTR) Masking plane */

NATIVE {BITMAP_SelectSourceFile}  CONST BITMAP_SELECTSOURCEFILE  = (BITMAP_DUMMY + 9)
   /* (STRPTR) */

NATIVE {BITMAP_SelectBitMap}      CONST BITMAP_SELECTBITMAP      = (BITMAP_DUMMY + 10)
   /* (struct BitMap */

NATIVE {BITMAP_SelectWidth}       CONST BITMAP_SELECTWIDTH       = (BITMAP_DUMMY + 11)
   /* (LONG) */

NATIVE {BITMAP_SelectHeight}      CONST BITMAP_SELECTHEIGHT      = (BITMAP_DUMMY + 12)
   /* (LONG) */

NATIVE {BITMAP_SelectMaskPlane}   CONST BITMAP_SELECTMASKPLANE   = (BITMAP_DUMMY + 13)
   /* (APTR) */

NATIVE {BITMAP_OffsetX}           CONST BITMAP_OFFSETX           = (BITMAP_DUMMY + 14)
   /* (LONG) */

NATIVE {BITMAP_OffsetY}           CONST BITMAP_OFFSETY           = (BITMAP_DUMMY + 15)
   /* (LONG) */

NATIVE {BITMAP_SelectOffsetX}     CONST BITMAP_SELECTOFFSETX     = (BITMAP_DUMMY + 16)
   /* (LONG) */

NATIVE {BITMAP_SelectOffsetY}     CONST BITMAP_SELECTOFFSETY     = (BITMAP_DUMMY + 17)
   /* (LONG) */
