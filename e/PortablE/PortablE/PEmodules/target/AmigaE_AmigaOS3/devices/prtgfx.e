/* $VER: prtgfx.h 44.1 (19.10.1999) */
OPT NATIVE
MODULE 'target/graphics/rastport'
MODULE 'target/utility/hooks', 'target/exec/types'
{MODULE 'devices/prtgfx'}

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

NATIVE {colorentry} OBJECT colorentry
	{colorlong}	colorlong	:ULONG	/* quick access to all of YMCB */
	{colorbyte}	colorbyte[4]	:ARRAY OF UBYTE	/* 1 entry for each of YMCB */
->	{colorsbyte}	colorsbyte[4]	:ARRAY OF BYTE	/* ditto (except signed) */
ENDOBJECT

/****************************************************************************/

NATIVE {prtinfo} OBJECT prtinfo
	{render}	render	:PTR /*LONG			(*pi_render)()*/		/* PRIVATE - DO NOT USE! */
	{rp}	rp	:PTR TO rastport			/* PRIVATE - DO NOT USE! */
	{temprp}	temprp	:PTR TO rastport		/* PRIVATE - DO NOT USE! */
	{rowbuf}	rowbuf	:PTR TO UINT		/* PRIVATE - DO NOT USE! */
	{hambuf}	hambuf	:PTR TO UINT		/* PRIVATE - DO NOT USE! */
	{colormap}	colormap	:PTR TO colorentry		/* PRIVATE - DO NOT USE! */
	{colorint}	colorint	:PTR TO colorentry		/* color intensities for entire row */
	{hamint}	hamint	:PTR TO colorentry		/* PRIVATE - DO NOT USE! */
	{dest1int}	dest1int	:PTR TO colorentry		/* PRIVATE - DO NOT USE! */
	{dest2int}	dest2int	:PTR TO colorentry		/* PRIVATE - DO NOT USE! */
	{scalex}	scalex	:PTR TO UINT		/* array of scale values for X */
	{scalexalt}	scalexalt	:PTR TO UINT		/* PRIVATE - DO NOT USE! */
	{dmatrix}	dmatrix	:PTR TO UBYTE		/* pointer to dither matrix */
	{topbuf}	topbuf	:PTR TO UINT		/* PRIVATE - DO NOT USE! */
	{botbuf}	botbuf	:PTR TO UINT		/* PRIVATE - DO NOT USE! */

	{rowbufsize}	rowbufsize	:UINT		/* PRIVATE - DO NOT USE! */
	{hambufsize}	hambufsize	:UINT		/* PRIVATE - DO NOT USE! */
	{colormapsize}	colormapsize	:UINT	/* PRIVATE - DO NOT USE! */
	{colorintsize}	colorintsize	:UINT	/* PRIVATE - DO NOT USE! */
	{hamintsize}	hamintsize	:UINT		/* PRIVATE - DO NOT USE! */
	{dest1intsize}	dest1intsize	:UINT	/* PRIVATE - DO NOT USE! */
	{dest2intsize}	dest2intsize	:UINT	/* PRIVATE - DO NOT USE! */
	{scalexsize}	scalexsize	:UINT		/* PRIVATE - DO NOT USE! */
	{scalexaltsize}	scalexaltsize	:UINT	/* PRIVATE - DO NOT USE! */

	{prefsflags}	prefsflags	:UINT		/* PRIVATE - DO NOT USE! */
	{special}	special	:ULONG		/* PRIVATE - DO NOT USE! */
	{xstart}	xstart	:UINT		/* PRIVATE - DO NOT USE! */
	{ystart}	ystart	:UINT		/* PRIVATE - DO NOT USE! */
	{width}	width	:UINT		/* source width (in pixels) */
	{height}	height	:UINT		/* source height (in pixels) */
	{pc}	pc	:ULONG			/* PRIVATE - DO NOT USE! */
	{pr}	pr	:ULONG			/* PRIVATE - DO NOT USE! */
	{ymult}	ymult	:UINT		/* PRIVATE - DO NOT USE! */
	{ymod}	ymod	:UINT		/* PRIVATE - DO NOT USE! */
	{ety}	ety	:INT			/* PRIVATE - DO NOT USE! */
	{xpos}	xpos	:UINT		/* offset to start printing picture */
	{threshold}	threshold	:UINT		/* threshold value (from prefs) */
	{tempwidth}	tempwidth	:UINT		/* PRIVATE - DO NOT USE! */
	{flags}	flags	:UINT		/* PRIVATE - DO NOT USE! */

	/* V44 additions */
->	{reducebuf}	reducebuf	:PTR TO UINT		/* PRIVATE - DO NOT USE! */
->	{reducebufsize}	reducebufsize	:UINT	/* PRIVATE - DO NOT USE! */
->	{sourcehook}	sourcehook	:PTR TO hook		/* PRIVATE - DO NOT USE! */
->	{inverthookbuf}	inverthookbuf	:PTR TO ULONG	/* RESERVED - DO NOT USE! */
ENDOBJECT
