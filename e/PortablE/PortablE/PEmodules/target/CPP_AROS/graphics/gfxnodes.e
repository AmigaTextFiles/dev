/* $Id: gfxnodes.h 12757 2001-12-08 22:23:57Z chodorowski $ */
OPT NATIVE
PUBLIC MODULE 'target/graphics/gfx_shared1'
MODULE 'target/exec/nodes'
{#include <graphics/gfxnodes.h>}
NATIVE {GRAPHICS_GFXNODES_H} CONST

->"OBJECT xln" is on-purposely missing from here (it can be found in 'graphics/gfx_shared1')

/* xln_Type */
NATIVE {VIEW_EXTRA_TYPE}      CONST VIEW_EXTRA_TYPE      = 1
NATIVE {VIEWPORT_EXTRA_TYPE}  CONST VIEWPORT_EXTRA_TYPE  = 2
NATIVE {SPECIAL_MONITOR_TYPE} CONST SPECIAL_MONITOR_TYPE = 3
NATIVE {MONITOR_SPEC_TYPE}    CONST MONITOR_SPEC_TYPE    = 4

NATIVE {SS_GRAPHICS} CONST SS_GRAPHICS = $02
