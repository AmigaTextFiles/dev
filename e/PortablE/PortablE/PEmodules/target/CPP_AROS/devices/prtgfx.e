/* $Id: prtgfx.h 12757 2001-12-08 22:23:57Z chodorowski $ */
OPT NATIVE
MODULE 'target/graphics/rastport'
MODULE 'target/utility/hooks', 'target/exec/types'
{#include <devices/prtgfx.h>}
NATIVE {DEVICES_PRTGFX_H} CONST

NATIVE {PCMYELLOW}	CONST PCMYELLOW	= 0
NATIVE {PCMMAGENTA}	CONST PCMMAGENTA	= 1
NATIVE {PCMCYAN}		CONST PCMCYAN		= 2
NATIVE {PCMBLACK}	CONST PCMBLACK	= 3
NATIVE {PCMBLUE}		CONST PCMBLUE		= PCMYELLOW
NATIVE {PCMGREEN}	CONST PCMGREEN	= PCMMAGENTA
NATIVE {PCMRED}		CONST PCMRED		= PCMCYAN
NATIVE {PCMWHITE}	CONST PCMWHITE	= PCMBLACK

NATIVE {colorEntry} OBJECT colorentry
    {colorLong}	colorlong	:ULONG
    {colorByte}	colorbyte[4]	:ARRAY OF UBYTE
    {colorSByte}	colorsbyte[4]	:ARRAY OF BYTE
ENDOBJECT

/****************************************************************************/

NATIVE {PrtInfo} OBJECT prtinfo
    {pi_render}	render	:NATIVE {LONG		(*)()} PTR
    {pi_rp}	rp	:PTR TO rastport
    {pi_temprp}	temprp	:PTR TO rastport
    {pi_RowBuf}	rowbuf	:PTR TO UINT
    {pi_HamBuf}	hambuf	:PTR TO UINT
    {pi_ColorMap}	colormap	:PTR TO colorentry
    {pi_ColorInt}	colorint	:PTR TO colorentry
    {pi_HamInt}	hamint	:PTR TO colorentry
    {pi_Dest1Int}	dest1int	:PTR TO colorentry
    {pi_Dest2Int}	dest2int	:PTR TO colorentry
    {pi_ScaleX}	scalex	:PTR TO UINT
    {pi_ScaleXAlt}	scalexalt	:PTR TO UINT
    {pi_dmatrix}	dmatrix	:PTR TO UBYTE
    {pi_TopBuf}	topbuf	:PTR TO UINT
    {pi_BotBuf}	botbuf	:PTR TO UINT

    {pi_RowBufSize}	rowbufsize	:UINT
    {pi_HamBufSize}	hambufsize	:UINT
    {pi_ColorMapSize}	colormapsize	:UINT
    {pi_ColorIntSize}	colorintsize	:UINT
    {pi_HamIntSize}	hamintsize	:UINT
    {pi_Dest1IntSize}	dest1intsize	:UINT
    {pi_Dest2IntSize}	dest2intsize	:UINT
    {pi_ScaleXSize}	scalexsize	:UINT
    {pi_ScaleXAltSize}	scalexaltsize	:UINT

    {pi_PrefsFlags}	prefsflags	:UINT
    {pi_special}	special	:ULONG
    {pi_xstart}	xstart	:UINT
    {pi_ystart}	ystart	:UINT
    {pi_width}	width	:UINT
    {pi_height}	height	:UINT
    {pi_pc}	pc	:ULONG
    {pi_pr}	pr	:ULONG
    {pi_ymult}	ymult	:UINT
    {pi_ymod}	ymod	:UINT
    {pi_ety}	ety	:INT
    {pi_xpos}	xpos	:UINT
    {pi_threshold}	threshold	:UINT
    {pi_tempwidth}	tempwidth	:UINT
    {pi_flags}	flags	:UINT

    /* New in V44 */
    {pi_ReduceBuf}	reducebuf	:PTR TO UINT
    {pi_ReduceBufSize}	reducebufsize	:UINT
    {pi_SourceHook}	sourcehook	:PTR TO hook
    {pi_InvertHookBuf}	inverthookbuf	:PTR TO ULONG
ENDOBJECT
