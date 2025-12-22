/* $VER: prtgfx.h 44.1 (19.10.1999) */
OPT NATIVE
MODULE 'target/graphics/rastport'
MODULE 'target/utility/hooks', 'target/exec/types'
{#include <devices/prtgfx.h>}
NATIVE {DEVICES_PRTGFX_H} CONST

/****************************************************************************/

NATIVE {PCMYELLOW}	CONST PCMYELLOW	= 0		/* byte index for yellow */
NATIVE {PCMMAGENTA}	CONST PCMMAGENTA	= 1		/* byte index for magenta */
NATIVE {PCMCYAN}		CONST PCMCYAN		= 2		/* byte index for cyan */
NATIVE {PCMBLACK}	CONST PCMBLACK	= 3		/* byte index for black */
NATIVE {PCMBLUE}		CONST PCMBLUE		= PCMYELLOW	/* byte index for blue */
NATIVE {PCMGREEN}	CONST PCMGREEN	= PCMMAGENTA	/* byte index for green */
NATIVE {PCMRED}		CONST PCMRED		= PCMCYAN		/* byte index for red */
NATIVE {PCMWHITE}	CONST PCMWHITE	= PCMBLACK	/* byte index for white */

/****************************************************************************/

NATIVE {colorEntry} OBJECT colorentry
	{colorLong}	colorlong	:ULONG	/* quick access to all of YMCB */
	{colorByte}	colorbyte[4]	:ARRAY OF UBYTE	/* 1 entry for each of YMCB */
	{colorSByte}	colorsbyte[4]	:ARRAY OF BYTE	/* ditto (except signed) */
ENDOBJECT

/****************************************************************************/

NATIVE {PrtInfo} OBJECT prtinfo
	{pi_render}	render	:NATIVE {LONG			(*)()} PTR		/* PRIVATE - DO NOT USE! */
	{pi_rp}	rp	:PTR TO rastport			/* PRIVATE - DO NOT USE! */
	{pi_temprp}	temprp	:PTR TO rastport		/* PRIVATE - DO NOT USE! */
	{pi_RowBuf}	rowbuf	:PTR TO UINT		/* PRIVATE - DO NOT USE! */
	{pi_HamBuf}	hambuf	:PTR TO UINT		/* PRIVATE - DO NOT USE! */
	{pi_ColorMap}	colormap	:PTR TO colorentry		/* PRIVATE - DO NOT USE! */
	{pi_ColorInt}	colorint	:PTR TO colorentry		/* color intensities for entire row */
	{pi_HamInt}	hamint	:PTR TO colorentry		/* PRIVATE - DO NOT USE! */
	{pi_Dest1Int}	dest1int	:PTR TO colorentry		/* PRIVATE - DO NOT USE! */
	{pi_Dest2Int}	dest2int	:PTR TO colorentry		/* PRIVATE - DO NOT USE! */
	{pi_ScaleX}	scalex	:PTR TO UINT		/* array of scale values for X */
	{pi_ScaleXAlt}	scalexalt	:PTR TO UINT		/* PRIVATE - DO NOT USE! */
	{pi_dmatrix}	dmatrix	:PTR TO UBYTE		/* pointer to dither matrix */
	{pi_TopBuf}	topbuf	:PTR TO UINT		/* PRIVATE - DO NOT USE! */
	{pi_BotBuf}	botbuf	:PTR TO UINT		/* PRIVATE - DO NOT USE! */

	{pi_RowBufSize}	rowbufsize	:UINT		/* PRIVATE - DO NOT USE! */
	{pi_HamBufSize}	hambufsize	:UINT		/* PRIVATE - DO NOT USE! */
	{pi_ColorMapSize}	colormapsize	:UINT	/* PRIVATE - DO NOT USE! */
	{pi_ColorIntSize}	colorintsize	:UINT	/* PRIVATE - DO NOT USE! */
	{pi_HamIntSize}	hamintsize	:UINT		/* PRIVATE - DO NOT USE! */
	{pi_Dest1IntSize}	dest1intsize	:UINT	/* PRIVATE - DO NOT USE! */
	{pi_Dest2IntSize}	dest2intsize	:UINT	/* PRIVATE - DO NOT USE! */
	{pi_ScaleXSize}	scalexsize	:UINT		/* PRIVATE - DO NOT USE! */
	{pi_ScaleXAltSize}	scalexaltsize	:UINT	/* PRIVATE - DO NOT USE! */

	{pi_PrefsFlags}	prefsflags	:UINT		/* PRIVATE - DO NOT USE! */
	{pi_special}	special	:ULONG		/* PRIVATE - DO NOT USE! */
	{pi_xstart}	xstart	:UINT		/* PRIVATE - DO NOT USE! */
	{pi_ystart}	ystart	:UINT		/* PRIVATE - DO NOT USE! */
	{pi_width}	width	:UINT		/* source width (in pixels) */
	{pi_height}	height	:UINT		/* source height (in pixels) */
	{pi_pc}	pc	:ULONG			/* PRIVATE - DO NOT USE! */
	{pi_pr}	pr	:ULONG			/* PRIVATE - DO NOT USE! */
	{pi_ymult}	ymult	:UINT		/* PRIVATE - DO NOT USE! */
	{pi_ymod}	ymod	:UINT		/* PRIVATE - DO NOT USE! */
	{pi_ety}	ety	:INT			/* PRIVATE - DO NOT USE! */
	{pi_xpos}	xpos	:UINT		/* offset to start printing picture */
	{pi_threshold}	threshold	:UINT		/* threshold value (from prefs) */
	{pi_tempwidth}	tempwidth	:UINT		/* PRIVATE - DO NOT USE! */
	{pi_flags}	flags	:UINT		/* PRIVATE - DO NOT USE! */

	/* V44 additions */
	{pi_ReduceBuf}	reducebuf	:PTR TO UINT		/* PRIVATE - DO NOT USE! */
	{pi_ReduceBufSize}	reducebufsize	:UINT	/* PRIVATE - DO NOT USE! */
	{pi_SourceHook}	sourcehook	:PTR TO hook		/* PRIVATE - DO NOT USE! */
	{pi_InvertHookBuf}	inverthookbuf	:PTR TO ULONG	/* RESERVED - DO NOT USE! */
ENDOBJECT
