/* $VER: rpattr.h 39.2 (31.5.1993) */
OPT NATIVE
{#include <graphics/rpattr.h>}
NATIVE {GRAPHICS_RPATTR_H} CONST

NATIVE {RPTAG_Font}		CONST RPTAG_FONT		= $80000000		/* get/set font */
NATIVE {RPTAG_APen}		CONST RPTAG_APEN		= $80000002		/* get/set apen */
NATIVE {RPTAG_BPen}		CONST RPTAG_BPEN		= $80000003		/* get/set bpen */
NATIVE {RPTAG_DrMd}		CONST RPTAG_DRMD		= $80000004		/* get/set draw mode */
->NATIVE {RPTAG_OutLinePen}	CONST RPTAG_OUTLINEPEN	= $80000005	/* get/set outline pen */
NATIVE {RPTAG_OutlinePen}	CONST RPTAG_OUTLINEPEN	= $80000005	/* get/set outline pen. corrected case. */
NATIVE {RPTAG_WriteMask}	CONST RPTAG_WRITEMASK	= $80000006	/* get/set WriteMask */
NATIVE {RPTAG_MaxPen}		CONST RPTAG_MAXPEN		= $80000007	/* get/set maxpen */

NATIVE {RPTAG_DrawBounds}	CONST RPTAG_DRAWBOUNDS	= $80000008	/* get only rastport draw bounds. pass &rect */

/* added by MorphOS */
NATIVE {RPTAG_PenMode}	 CONST RPTAG_PENMODE	 = $80000080
NATIVE {RPTAG_FgColor}	 CONST RPTAG_FGCOLOR	 = $80000081
NATIVE {RPTAG_BgColor}	 CONST RPTAG_BGCOLOR	 = $80000082
