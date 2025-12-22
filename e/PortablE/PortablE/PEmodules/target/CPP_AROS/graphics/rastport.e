/* $Id: rastport.h 16374 2003-02-04 22:15:47Z dlc $ */
OPT NATIVE
PUBLIC MODULE 'target/graphics/gfx_shared3'
MODULE 'target/exec/types', 'target/graphics/gfx'
{#include <graphics/rastport.h>}
NATIVE {GRAPHICS_RASTPORT_H} CONST

->"OBJECT areainfo" is on-purposely missing from here (it can be found in 'graphics/gfx_shared3')

->"OBJECT gelsinfo" is on-purposely missing from here (it can be found in 'graphics/gfx_shared3')

->"OBJECT tmpras" is on-purposely missing from here (it can be found in 'graphics/gfx_shared3')

->"OBJECT rastport" is on-purposely missing from here (it can be found in 'graphics/gfx_shared3')

/* Flags */
NATIVE {FRST_DOT} CONST FRST_DOT = $1
NATIVE {ONE_DOT}  CONST ONE_DOT  = $2
NATIVE {DBUFFER}  CONST RPF_DBUFFER  = $4

/* Drawing Modes */
NATIVE {JAM1}       CONST RP_JAM1       = 0
NATIVE {JAM2}       CONST RP_JAM2       = 1
NATIVE {COMPLEMENT} CONST RP_COMPLEMENT = 2
NATIVE {INVERSVID}  CONST RP_INVERSVID  = 4

NATIVE {AREAOUTLINE} CONST RPF_AREAOUTLINE = $08
NATIVE {NOCROSSFILL} CONST RPF_NOCROSSFILL = $20
