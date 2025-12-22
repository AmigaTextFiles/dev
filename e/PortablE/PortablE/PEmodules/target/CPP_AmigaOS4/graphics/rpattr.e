/* $Id: rpattr.h,v 1.12 2005/11/10 15:36:43 hjfrieden Exp $ */
OPT NATIVE
{#include <graphics/rpattr.h>}
NATIVE {GRAPHICS_RPATTR_H} CONST

NATIVE {RPTAG_Font}       CONST RPTAG_FONT       = $80000000 /* get/set font */
NATIVE {RPTAG_APen}       CONST RPTAG_APEN       = $80000002 /* get/set apen */
NATIVE {RPTAG_BPen}       CONST RPTAG_BPEN       = $80000003 /* get/set bpen */
NATIVE {RPTAG_DrMd}       CONST RPTAG_DRMD       = $80000004 /* get/set draw mode */
->NATIVE {RPTAG_OutLinePen} CONST RPTAG_OUTLINEPEN = $80000005 /* get/set outline pen */
NATIVE {RPTAG_OutlinePen} CONST RPTAG_OUTLINEPEN = $80000005 /* get/set outline pen. corrected case. */
NATIVE {RPTAG_WriteMask}  CONST RPTAG_WRITEMASK  = $80000006 /* get/set WriteMask */
NATIVE {RPTAG_MaxPen}     CONST RPTAG_MAXPEN     = $80000007 /* get/set maxpen */

NATIVE {RPTAG_DrawBounds} CONST RPTAG_DRAWBOUNDS = $80000008 /* get only rastport draw bounds.
                                     * pass &rect */

/* V51 extensions */
NATIVE {RPTAG_APenColor}  CONST RPTAG_APENCOLOR  = $80000009 /* get/set apen color 0xaarrggbb */
NATIVE {RPTAG_BPenColor}  CONST RPTAG_BPENCOLOR  = $8000000A /* get/set bpen color 0xaarrggbb */
NATIVE {RPTAG_OPenColor}  CONST RPTAG_OPENCOLOR  = $8000000B /* get/set open color 0xaarrggbb */
NATIVE {RPTAG_CloneRP}    CONST RPTAG_CLONERP    = $8000000C /* AllocRastPort(): rastport to clone */
NATIVE {RPTAG_BitMap}     CONST RPTAG_BITMAP     = $8000000D /* get/set bitmap of rastport */ 
