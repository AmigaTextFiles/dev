/* $VER: rastport.h 39.0 (21.8.1991) */
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
NATIVE {JAM1}	    CONST RP_JAM1	    = 0	      /* jam 1 color into raster */
NATIVE {JAM2}	    CONST RP_JAM2	    = 1	      /* jam 2 colors into raster */
NATIVE {COMPLEMENT}  CONST RP_COMPLEMENT  = 2	      /* XOR bits into raster */
NATIVE {INVERSVID}   CONST RP_INVERSVID   = 4	      /* inverse video for drawing modes */

/* these are the flag bits for RastPort flags */
NATIVE {FRST_DOT}    CONST FRST_DOT    = $01      /* draw the first dot of this line ? */
NATIVE {ONE_DOT}     CONST ONE_DOT     = $02      /* use one dot mode for drawing lines */
NATIVE {DBUFFER}     CONST RPF_DBUFFER     = $04      /* flag set when RastPorts
				 are double-buffered */

	     /* only used for bobs */

NATIVE {AREAOUTLINE} CONST RPF_AREAOUTLINE = $08      /* used by areafiller */
NATIVE {NOCROSSFILL} CONST RPF_NOCROSSFILL = $20      /* areafills have no crossovers */

/* there is only one style of clipping: raster clipping */
/* this preserves the continuity of jaggies regardless of clip window */
/* When drawing into a RastPort, if the ptr to ClipRect is nil then there */
/* is no clipping done, this is dangerous but useful for speed */
