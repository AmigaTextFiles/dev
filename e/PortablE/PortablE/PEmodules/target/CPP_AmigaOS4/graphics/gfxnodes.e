/* $Id: gfxnodes.h,v 1.17 2005/11/10 15:36:43 hjfrieden Exp $ */
OPT NATIVE
PUBLIC MODULE 'target/graphics/gfx_shared1'
MODULE 'target/exec/nodes'
{#include <graphics/gfxnodes.h>}
NATIVE {GRAPHICS_GFXNODES_H} CONST

/* define structure names in this scope */
->NATIVE {GraphicsIFace} OBJECT graphicsiface
->ENDOBJECT

->"OBJECT xln" is on-purposely missing from here (it can be found in 'graphics/gfx_shared1')

NATIVE {SS_GRAPHICS} CONST SS_GRAPHICS = $02

NATIVE {VIEW_EXTRA_TYPE}      CONST VIEW_EXTRA_TYPE      = 1
NATIVE {VIEWPORT_EXTRA_TYPE}  CONST VIEWPORT_EXTRA_TYPE  = 2
NATIVE {SPECIAL_MONITOR_TYPE} CONST SPECIAL_MONITOR_TYPE = 3
NATIVE {MONITOR_SPEC_TYPE}    CONST MONITOR_SPEC_TYPE    = 4
