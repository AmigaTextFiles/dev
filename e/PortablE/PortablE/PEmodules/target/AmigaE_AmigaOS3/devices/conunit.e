/* $VER: conunit.h 36.15 (20.11.1990) */
OPT NATIVE
MODULE 'target/exec/types', 'target/exec/ports', 'target/devices/console', 'target/devices/keymap', 'target/devices/inputevent'
MODULE 'target/intuition/intuition', 'target/graphics/text'
{MODULE 'devices/conunit'}

/* ----	console unit numbers for OpenDevice() */
NATIVE {CONU_LIBRARY}	CONST CONU_LIBRARY	= -1	/* no unit, just fill in IO_DEVICE field */
NATIVE {CONU_STANDARD}	CONST CONU_STANDARD	= 0	/* standard unmapped console */

/* ---- New unit numbers for OpenDevice() - (V36) */

NATIVE {CONU_CHARMAP}	CONST CONU_CHARMAP	= 1	/* bind character map to console */
NATIVE {CONU_SNIPMAP}	CONST CONU_SNIPMAP	= 3	/* bind character map w/ snip to console */

/* ---- New flag defines for OpenDevice() - (V37) */

NATIVE {CONFLAG_DEFAULT}			CONST CONFLAG_DEFAULT			= 0
NATIVE {CONFLAG_NODRAW_ON_NEWSIZE}	CONST CONFLAG_NODRAW_ON_NEWSIZE	= 1


NATIVE {PMB_ASM}		CONST PMB_ASM		= (M_LNM+1)	/* internal storage bit for AS flag */
NATIVE {PMB_AWM}		CONST PMB_AWM		= (PMB_ASM+1)	/* internal storage bit for AW flag */
NATIVE {MAXTABS}		CONST MAXTABS		= 80


NATIVE {conunit} OBJECT conunit
    {mp}	mp	:mp
    /* ---- read only variables */
    {window}	window	:PTR TO window	/* intuition window bound to this unit */
    {xcp}	xcp	:INT		/* character position */
    {ycp}	ycp	:INT
    {xmax}	xmax	:INT		/* max character position */
    {ymax}	ymax	:INT
    {xrsize}	xrsize	:INT		/* character raster size */
    {yrsize}	yrsize	:INT
    {xrorigin}	xrorigin	:INT	/* raster origin */
    {yrorigin}	yrorigin	:INT
    {xrextant}	xrextant	:INT	/* raster maxima */
    {yrextant}	yrextant	:INT
    {xminshrink}	xminshrink	:INT	/* smallest area intact from resize process */
    {yminshrink}	yminshrink	:INT
    {xccp}	xccp	:INT		/* cursor position */
    {yccp}	yccp	:INT

    /* ---- read/write variables (writes must must be protected) */
    /* ---- storage for AskKeyMap and SetKeyMap */
    {keymapstruct}	keymapstruct	:keymap
    /* ---- tab stops */
    {tabstops}	tabstops[MAXTABS]	:ARRAY OF UINT /* 0 at start, $ffff at end of list */

    /* ---- console rastport attributes */
    {mask}	mask	:BYTE
    {fgpen}	fgpen	:BYTE
    {bgpen}	bgpen	:BYTE
    {aolpen}	aolpen	:BYTE
    {drawmode}	drawmode	:BYTE
    {obsolete1}	obsolete1	:BYTE	/* was cu_AreaPtSz -- not used in V36 */
    {obsolete2}	obsolete2	:APTR	/* was cu_AreaPtrn -- not used in V36 */
    {minterms}	minterms[8]	:ARRAY OF UBYTE	/* console minterms */
    {font}	font	:PTR TO textfont
    {algostyle}	algostyle	:UBYTE
    {txflags}	txflags	:UBYTE
    {txheight}	txheight	:UINT
    {txwidth}	txwidth	:UINT
    {txbaseline}	txbaseline	:UINT
    {txspacing}	txspacing	:INT

    /* ---- console MODES and RAW EVENTS switches */
    {modes}	modes[(PMB_AWM+7)/8]	:ARRAY OF UBYTE	/* one bit per mode */
    {rawevents}	rawevents[(IECLASS_MAX+8)/8]	:ARRAY OF UBYTE
ENDOBJECT
