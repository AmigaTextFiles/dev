OPT MODULE, EXPORT, MORPHOS

-> ECX:modules/morphos/graphics/rpattr.e (MORPHOS)

CONST RPTAG_Font        = $80000000
CONST RPTAG_APen        = $80000002
CONST RPTAG_BPen        = $80000003
CONST RPTAG_DrMd        = $80000004
CONST RPTAG_OutLinePen  = $80000005
CONST RPTAG_OutlinePen  = $80000005
CONST RPTAG_WriteMask   = $80000006
CONST RPTAG_MaxPen      = $80000007

CONST RPTAG_DrawBounds  = $80000008

/*** V50 ***/

CONST RPTAG_PenMode     = $80000080    /* Enable/Disable PenMode (Defaults to TRUE) */
CONST RPTAG_FgColor     = $80000081    /* 32bit Background Color used when PenMode is FALSE */
CONST RPTAG_BgColor     = $80000082    /* 32bit Background Color used when PenMode is FALSE */

/* v51 */

CONST RPTAG_AlphaMode   = $80000083    /* (NYI) Enable/Disable AlphaMode (Defaults to FALSE) */
