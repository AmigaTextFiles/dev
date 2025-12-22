/* $Id: rpattr.h 23343 2005-05-31 22:20:48Z stegerg $ */
OPT NATIVE
MODULE 'target/exec/types'
{#include <graphics/rpattr.h>}
NATIVE {GRAPHICS_RPATTR_H} CONST

NATIVE {RPTAG_Font}       CONST RPTAG_FONT       = $80000000
NATIVE {RPTAG_APen}       CONST RPTAG_APEN       = $80000002
NATIVE {RPTAG_BPen}       CONST RPTAG_BPEN       = $80000003
NATIVE {RPTAG_DrMd}       CONST RPTAG_DRMD       = $80000004
NATIVE {RPTAG_OutlinePen} CONST RPTAG_OUTLINEPEN = $80000005
NATIVE {RPTAG_WriteMask}  CONST RPTAG_WRITEMASK  = $80000006
NATIVE {RPTAG_MaxPen}     CONST RPTAG_MAXPEN     = $80000007
NATIVE {RPTAG_DrawBounds} CONST RPTAG_DRAWBOUNDS = $80000008

/* Extensions taken over from MorphOS */
NATIVE {RPTAG_PenMode}	 CONST RPTAG_PENMODE	 = $80000080
NATIVE {RPTAG_FgColor}	 CONST RPTAG_FGCOLOR	 = $80000081
NATIVE {RPTAG_BgColor}	 CONST RPTAG_BGCOLOR	 = $80000082

/* Extensions invented by AROS */
NATIVE {RPTAG_PatternOriginX} 	    CONST RPTAG_PATTERNORIGINX 	    = $800000C0 /* WORD */
NATIVE {RPTAG_PatternOriginY} 	    CONST RPTAG_PATTERNORIGINY 	    = $800000C1 /* WORD */
NATIVE {RPTAG_ClipRectangle}  	    CONST RPTAG_CLIPRECTANGLE  	    = $800000C2 /* struct Rectangle *. Clones *rectangle. */
NATIVE {RPTAG_ClipRectangleFlags}    CONST RPTAG_CLIPRECTANGLEFLAGS    = $800000C3 /* ULONG */
NATIVE {RPTAG_RemapColorFonts}	    CONST RPTAG_REMAPCOLORFONTS	    = $800000C4 /* BOOL */

/* Flags for ClipRectangleFlags */
NATIVE {RPCRF_RELRIGHT}	    	    CONST RPCRF_RELRIGHT	    	    = $01       /* ClipRectangle.MaxX is relative to right of layer/bitmap */
NATIVE {RPCRF_RELBOTTOM}     	    CONST RPCRF_RELBOTTOM     	    = $02       /* ClipRectangle.MaxY is relative to bottom of layer/bitmap */
NATIVE {RPCRF_VALID} 	    	    CONST RPCRF_VALID 	    	    = $04       /* private */
