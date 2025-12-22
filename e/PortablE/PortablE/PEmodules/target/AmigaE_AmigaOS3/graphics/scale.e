/* $VER: scale.h 39.0 (21.8.1991) */
OPT NATIVE
MODULE 'target/exec/types'
MODULE 'target/graphics/gfx'
{MODULE 'graphics/scale'}

NATIVE {bitscaleargs} OBJECT bitscaleargs
    {srcx}	srcx	:UINT
	{srcy}	srcy	:UINT			/* source origin */
    {srcwidth}	srcwidth	:UINT
	{srcheight}	srcheight	:UINT	/* source size */
    {xsrcfactor}	xsrcfactor	:UINT
	{ysrcfactor}	ysrcfactor	:UINT	/* scale factor denominators */
    {destx}	destx	:UINT
	{desty}	desty	:UINT		/* destination origin */
    {destwidth}	destwidth	:UINT
	{destheight}	destheight	:UINT	/* destination size result */
    {xdestfactor}	xdestfactor	:UINT
	{ydestfactor}	ydestfactor	:UINT	/* scale factor numerators */
    {srcbitmap}	srcbitmap	:PTR TO bitmap		/* source BitMap */
    {destbitmap}	destbitmap	:PTR TO bitmap		/* destination BitMap */
    {flags}	flags	:ULONG				/* reserved.  Must be zero! */
    {xdda}	xdda	:UINT
	{ydda}	ydda	:UINT			/* reserved */
    {reserved1}	reserved1	:VALUE
    {reserved2}	reserved2	:VALUE
ENDOBJECT
