/* $Id: rastport.h,v 1.16 2005/11/10 15:36:43 hjfrieden Exp $ */
OPT NATIVE
PUBLIC MODULE 'target/graphics/gfx_shared3'
MODULE 'target/exec/types', 'target/graphics/gfx'
{#include <graphics/rastport.h>}
NATIVE {GRAPHICS_RASTPORT_H} CONST

->"OBJECT areainfo" is on-purposely missing from here (it can be found in 'graphics/gfx_shared3')

->"OBJECT tmpras" is on-purposely missing from here (it can be found in 'graphics/gfx_shared3')

/* unoptimized for 32bit alignment of pointers */
->"OBJECT gelsinfo" is on-purposely missing from here (it can be found in 'graphics/gfx_shared3')

->"OBJECT rastport" is on-purposely missing from here (it can be found in 'graphics/gfx_shared3')

/* drawing modes */
NATIVE {JAM1}        CONST RP_JAM1        = 0  /* jam 1 color into raster */
NATIVE {JAM2}        CONST RP_JAM2        = 1  /* jam 2 colors into raster */
NATIVE {COMPLEMENT}  CONST RP_COMPLEMENT  = 2  /* XOR bits into raster */
NATIVE {INVERSVID}   CONST RP_INVERSVID   = 4  /* inverse video for drawing modes */
NATIVE {BGBACKFILL}  CONST RP_BGBACKFILL  = 8  /* use backfill instead of BgPen */
NATIVE {FILLALPHA}  CONST RP_FILLALPHA  = 16  /* draw background under alpha pixels */
NATIVE {LEVELS}     CONST RP_LEVELS     = 32  /* fill text extent with alpha levels */

/* these are the flag bits for RastPort flags */
NATIVE {FRST_DOT}    CONST FRST_DOT    = $01  /* draw the first dot of this line ? */
NATIVE {ONE_DOT}     CONST ONE_DOT     = $02  /* use one dot mode for drawing lines */
NATIVE {DBUFFER}     CONST RPF_DBUFFER     = $04  /* flag set when RastPorts
                             are double-buffered */
                          /* only used for bobs */

NATIVE {AREAOUTLINE}      CONST RPF_AREAOUTLINE      = $08  /* used by areafiller */
NATIVE {NOCROSSFILL}      CONST RPF_NOCROSSFILL      = $20  /* areafills have no crossovers */

/* graphics.library V51 extensions */
NATIVE {RPF_EXTENDED}     CONST RPF_EXTENDED     = $40  /* V51 rastport - reserved  */
NATIVE {RPF_USE_FGCOLOR}  CONST RPF_USE_FGCOLOR  = $80  /* draw with rp->FGPenColor */
NATIVE {RPF_USE_BGCOLOR}  CONST RPF_USE_BGCOLOR  = $100 /* draw with rp->BGPenColor */
NATIVE {RPF_USE_OCOLOR}   CONST RPF_USE_OCOLOR   = $200 /* draw with rp->OPenColor  */

/* there is only one style of clipping: raster clipping */
/* this preserves the continuity of jaggies regardless of clip window */
/* When drawing into a RastPort, if the ptr to ClipRect is nil then there */
/* is no clipping done, this is dangerous but useful for speed */
