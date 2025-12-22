/* $Id: conunit.h,v 1.12 2005/11/10 15:31:33 hjfrieden Exp $ */
OPT NATIVE
MODULE 'target/exec/types', 'target/exec/ports', 'target/devices/console', 'target/devices/keymap', 'target/devices/inputevent'
MODULE 'target/intuition/intuition', 'target/graphics/text'
{#include <devices/conunit.h>}
NATIVE {DEVICES_CONUNIT_H} CONST

/* ---- console unit numbers for OpenDevice() */
NATIVE {CONU_LIBRARY}  CONST CONU_LIBRARY  = -1 /* no unit, just fill in IO_DEVICE field */
NATIVE {CONU_STANDARD}  CONST CONU_STANDARD  = 0 /* standard unmapped console */

/* ---- New unit numbers for OpenDevice() - (V36) */

NATIVE {CONU_CHARMAP} CONST CONU_CHARMAP = 1 /* bind character map to console */
NATIVE {CONU_SNIPMAP} CONST CONU_SNIPMAP = 3 /* bind character map w/ snip to console */

/* ---- New flag defines for OpenDevice() - (V37) */

NATIVE {CONFLAG_DEFAULT}           CONST CONFLAG_DEFAULT           = 0
NATIVE {CONFLAG_NODRAW_ON_NEWSIZE} CONST CONFLAG_NODRAW_ON_NEWSIZE = 1


NATIVE {PMB_LNM} CONST PMB_LNM = M_LNM              /* internal storage bit for NL flag */
NATIVE {PMF_LNM} CONST ->#PMF_LNM = (1<<(M_LNM&7))     /* bit value in that byte           */
NATIVE {PMB_ASM} CONST PMB_ASM = (M_LNM+1)          /* internal storage bit for AS flag */
NATIVE {PMF_ASM} CONST ->#PMF_ASM = (1<<((M_LNM+1)&7)) /* bit value in that byte           */
NATIVE {PMB_AWM} CONST PMB_AWM = (PMB_ASM+1)        /* internal storage bit for AW flag */
NATIVE {PMF_AWM} CONST ->#PMF_AWM = (1<<((M_LNM+2)&7)) /* bit value in that byte           */

NATIVE {MAXTABS} CONST MAXTABS = 80


NATIVE {ConUnit} OBJECT conunit
    {cu_MP}	mp	:mp
    /* ---- read only variables */
    {cu_Window}	window	:PTR TO window /* intuition window bound to this unit */
    {cu_XCP}	xcp	:INT            /* character position */
    {cu_YCP}	ycp	:INT
    {cu_XMax}	xmax	:INT           /* max character position */
    {cu_YMax}	ymax	:INT
    {cu_XRSize}	xrsize	:INT         /* character raster size */
    {cu_YRSize}	yrsize	:INT
    {cu_XROrigin}	xrorigin	:INT       /* raster origin */
    {cu_YROrigin}	yrorigin	:INT
    {cu_XRExtant}	xrextant	:INT       /* raster maxima */
    {cu_YRExtant}	yrextant	:INT
    {cu_XMinShrink}	xminshrink	:INT     /* smallest area intact from resize process */
    {cu_YMinShrink}	yminshrink	:INT
    {cu_XCCP}	xccp	:INT           /* cursor position */
    {cu_YCCP}	yccp	:INT

    /* ---- read/write variables (writes must must be protected) */
    /* ---- storage for AskKeyMap and SetKeyMap */
    {cu_KeyMapStruct}	keymapstruct	:keymap
    /* ---- tab stops */
    {cu_TabStops}	tabstops[MAXTABS]	:ARRAY OF UINT /* 0 at start, $ffff at end of list */

    /* ---- console rastport attributes */
    {cu_Mask}	mask	:BYTE
    {cu_FgPen}	fgpen	:BYTE
    {cu_BgPen}	bgpen	:BYTE
    {cu_AOLPen}	aolpen	:BYTE
    {cu_DrawMode}	drawmode	:BYTE
    {cu_Obsolete1}	obsolete1	:BYTE   /* was cu_AreaPtSz -- not used in V36 */
    {cu_Obsolete2}	obsolete2	:APTR   /* was cu_AreaPtrn -- not used in V36 */
    {cu_Minterms}	minterms[8]	:ARRAY OF UBYTE /* console minterms */
    {cu_Font}	font	:PTR TO textfont
    {cu_AlgoStyle}	algostyle	:UBYTE
    {cu_TxFlags}	txflags	:UBYTE
    {cu_TxHeight}	txheight	:UINT
    {cu_TxWidth}	txwidth	:UINT
    {cu_TxBaseline}	txbaseline	:UINT
    {cu_TxSpacing}	txspacing	:INT

    /* ---- console MODES and RAW EVENTS switches */
    {cu_Modes}	modes[(PMB_AWM+7)/8]	:ARRAY OF UBYTE /* one bit per mode */
    {cu_RawEvents}	rawevents[(IECLASS_MAX+8)/8]	:ARRAY OF UBYTE
ENDOBJECT
