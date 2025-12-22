/* $Id: filler.h,v 1.10 2005/11/10 15:36:44 hjfrieden Exp $ */
OPT NATIVE
MODULE 'target/reaction/reaction', 'target/intuition/imageclass'
MODULE 'target/exec/types'
{#include <images/filler.h>}
NATIVE {IMAGES_FILLER_H} CONST

/* image placement adjustment flags. (default is to centre image.)
 */
NATIVE {FILLER_PLACEMENT_LEFT}   CONST FILLER_PLACEMENT_LEFT   = 1 /* takes priority over
                                     FILLER_PLACEMENT_RIGHT */
NATIVE {FILLER_PLACEMENT_RIGHT}  CONST FILLER_PLACEMENT_RIGHT  = 2
NATIVE {FILLER_PLACEMENT_TOP}    CONST FILLER_PLACEMENT_TOP    = 4 /* takes priority over
                                     FILLER_PLACEMENT_BOTTOM */
NATIVE {FILLER_PLACEMENT_BOTTOM} CONST FILLER_PLACEMENT_BOTTOM = 8

/*****************************************************************************/

/* image mode flags.
 */
NATIVE {FILLER_MODE_NORMAL}  CONST FILLER_MODE_NORMAL  = 0 /* single image (default) */
NATIVE {FILLER_MODE_SCALED}  CONST FILLER_MODE_SCALED  = 1 /* image scaled to fill entire area */
NATIVE {FILLER_MODE_CONTAIN} CONST FILLER_MODE_CONTAIN = 2 /* image scaled to maximum size possible
                                 within area, maintaining aspect ratio */
NATIVE {FILLER_MODE_FIT}     CONST FILLER_MODE_FIT     = 3 /* image scaled to fill entire area,
                                 maintaining aspect ratio */
NATIVE {FILLER_MODE_TILED}   CONST FILLER_MODE_TILED   = 4 /* image is tiled across entire area */

/*****************************************************************************/

/* Additional attributes defined by the Filler class
 */
NATIVE {FILLER_Dummy}             CONST FILLER_DUMMY             = (REACTION_DUMMY+$0006666)

NATIVE {FILLER_Screen}            CONST FILLER_SCREEN            = (FILLER_DUMMY+1)
   /* (struct Screen *) Screen for pen allocation (default: None)
      (OM_NEW, OM_SET) */

NATIVE {FILLER_BackgroundColour}  CONST FILLER_BACKGROUNDCOLOUR  = (FILLER_DUMMY+2)
NATIVE {FILLER_BackgroundColor}   CONST FILLER_BACKGROUNDCOLOR   = FILLER_BACKGROUNDCOLOUR
   /* (uint32) Background fill ARGB colour (default: 0 (transparent))
      (OM_NEW, OM_SET) */

NATIVE {FILLER_ImageFilename}     CONST FILLER_IMAGEFILENAME     = (FILLER_DUMMY+3)
   /* (STRPTR) File to load as image. (OM_NEW, OM_SET) */

NATIVE {FILLER_TopLeftColour}     CONST FILLER_TOPLEFTCOLOUR     = (FILLER_DUMMY+4)
NATIVE {FILLER_TopRightColour}    CONST FILLER_TOPRIGHTCOLOUR    = (FILLER_DUMMY+5)
NATIVE {FILLER_BottomLeftColour}  CONST FILLER_BOTTOMLEFTCOLOUR  = (FILLER_DUMMY+6)
NATIVE {FILLER_BottomRightColour} CONST FILLER_BOTTOMRIGHTCOLOUR = (FILLER_DUMMY+7)
NATIVE {FILLER_TopLeftColor}      CONST FILLER_TOPLEFTCOLOR      = FILLER_TOPLEFTCOLOUR
NATIVE {FILLER_TopRightColor}     CONST FILLER_TOPRIGHTCOLOR     = FILLER_TOPRIGHTCOLOUR
NATIVE {FILLER_BottomLeftColor}   CONST FILLER_BOTTOMLEFTCOLOR   = FILLER_BOTTOMLEFTCOLOUR
NATIVE {FILLER_BottomRightColor}  CONST FILLER_BOTTOMRIGHTCOLOR  = FILLER_BOTTOMRIGHTCOLOUR
   /* (uint32) Four ARGB colours used to render gradient over area
      (default: 0 (transparent)) (OM_NEW, OM_SET) */

NATIVE {FILLER_ImageMode}         CONST FILLER_IMAGEMODE         = (FILLER_DUMMY+8)
   /* (uint32) The image mode, see above flags. (OM_NEW, OM_SET) */

NATIVE {FILLER_ImagePlacement}    CONST FILLER_IMAGEPLACEMENT    = (FILLER_DUMMY+9)
   /* (uint32) The image placement, see above flags. (OM_NEW, OM_SET) */

NATIVE {FILLER_ImageBuffer}       CONST FILLER_IMAGEBUFFER       = (FILLER_DUMMY+10)
   /* (struct SizedBuffer *) Buffer to load as image. (OM_NEW, OM_SET) */

NATIVE {FILLER_ImageAddress}      CONST FILLER_IMAGEADDRESS      = (FILLER_DUMMY+11)
NATIVE {FILLER_ImageSize}         CONST FILLER_IMAGESIZE         = (FILLER_DUMMY+12)
   /* (APTR), (uint32) Alternative way to import an image from memory. 
      Both these attributes must be set before the image is loaded.
      Also see FILLER_ImageBuffer.
      (OM_NEW, OM_SET) */

/*****************************************************************************/

/* structure required for FILLER_ImageBuffer */

NATIVE {SizedBuffer} OBJECT sizedbuffer
   {SB_Buffer}	buffer	:APTR
   {SB_Size}	size	:ULONG
ENDOBJECT
