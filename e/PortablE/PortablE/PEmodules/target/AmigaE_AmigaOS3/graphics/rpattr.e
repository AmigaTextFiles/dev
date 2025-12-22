/* $VER: rpattr.h 39.2 (31.5.1993) */
OPT NATIVE
{MODULE 'graphics/rpattr'}

NATIVE {RPTAG_FONT}		CONST RPTAG_FONT		= $80000000		/* get/set font */
NATIVE {RPTAG_APEN}		CONST RPTAG_APEN		= $80000002		/* get/set apen */
NATIVE {RPTAG_BPEN}		CONST RPTAG_BPEN		= $80000003		/* get/set bpen */
NATIVE {RPTAG_DRMD}		CONST RPTAG_DRMD		= $80000004		/* get/set draw mode */
->NATIVE {RPTAG_OUTLINEPEN}	CONST RPTAG_OUTLINEPEN	= $80000005	/* get/set outline pen */
NATIVE {RPTAG_OUTLINEPEN}	CONST RPTAG_OUTLINEPEN	= $80000005	/* get/set outline pen. corrected case. */
NATIVE {RPTAG_WRITEMASK}	CONST RPTAG_WRITEMASK	= $80000006	/* get/set WriteMask */
NATIVE {RPTAG_MAXPEN}		CONST RPTAG_MAXPEN		= $80000007	/* get/set maxpen */

NATIVE {RPTAG_DRAWBOUNDS}	CONST RPTAG_DRAWBOUNDS	= $80000008	/* get only rastport draw bounds. pass &rect */
