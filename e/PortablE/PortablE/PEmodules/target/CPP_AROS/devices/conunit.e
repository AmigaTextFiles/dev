/* $Id: conunit.h 12452 2001-10-24 10:02:53Z chodorowski $ */
OPT NATIVE
MODULE 'target/exec/types', 'target/exec/ports', 'target/devices/console', 'target/devices/keymap', 'target/devices/inputevent'
MODULE 'target/intuition/intuition', 'target/graphics/text'
{#include <devices/conunit.h>}
NATIVE {DEVICES_CONUNIT_H} CONST

/* Console units */
NATIVE {CONU_LIBRARY}	CONST CONU_LIBRARY	= -1
NATIVE {CONU_STANDARD}	CONST CONU_STANDARD	= 0
NATIVE {CONU_CHARMAP}	CONST CONU_CHARMAP	= 1
NATIVE {CONU_SNIPMAP}	CONST CONU_SNIPMAP	= 3

NATIVE {CONFLAG_DEFAULT}			CONST CONFLAG_DEFAULT			= 0
NATIVE {CONFLAG_NODRAW_ON_NEWSIZE}	CONST CONFLAG_NODRAW_ON_NEWSIZE	= 1

NATIVE {PMB_ASM}		CONST PMB_ASM		= (M_LNM + 1)
NATIVE {PMB_AWM}		CONST PMB_AWM		= (PMB_ASM + 1)
NATIVE {MAXTABS}		CONST MAXTABS		= 80

NATIVE {ConUnit} OBJECT conunit
    {cu_MP}	mp	:mp
    
    {cu_Window}	window	:PTR TO window    
    {cu_XCP}	xcp	:INT
    {cu_YCP}	ycp	:INT
    {cu_XMax}	xmax	:INT
    {cu_YMax}	ymax	:INT
    {cu_XRSize}	xrsize	:INT
    {cu_YRSize}	yrsize	:INT
    {cu_XROrigin}	xrorigin	:INT
    {cu_YROrigin}	yrorigin	:INT
    {cu_XRExtant}	xrextant	:INT
    {cu_YRExtant}	yrextant	:INT
    {cu_XMinShrink}	xminshrink	:INT
    {cu_YMinShrink}	yminshrink	:INT
    {cu_XCCP}	xccp	:INT
    {cu_YCCP}	yccp	:INT
    
    {cu_KeyMapStruct}	keymapstruct	:keymap
    {cu_TabStops}	tabstops[MAXTABS]	:ARRAY OF UINT
    
    {cu_Mask}	mask	:BYTE
    {cu_FgPen}	fgpen	:BYTE
    {cu_BgPen}	bgpen	:BYTE
    {cu_AOLPen}	aolpen	:BYTE
    {cu_DrawMode}	drawmode	:BYTE
    {cu_Obsolete1}	obsolete1	:BYTE
    {cu_Obsolete2}	obsolete2	:APTR
    {cu_Minterms}	minterms[8]	:ARRAY OF UBYTE
    {cu_Font}	font	:PTR TO textfont
    {cu_AlgoStyle}	algostyle	:UBYTE
    {cu_TxFlags}	txflags	:UBYTE
    {cu_TxHeight}	txheight	:UINT
    {cu_TxWidth}	txwidth	:UINT
    {cu_TxBaseline}	txbaseline	:UINT
    {cu_TxSpacing}	txspacing	:INT
    
    {cu_Modes}	modes[(PMB_AWM + 7) / 8]	:ARRAY OF UBYTE
    {cu_RawEvents}	rawevents[(IECLASS_MAX + 8) / 8]	:ARRAY OF UBYTE
ENDOBJECT
