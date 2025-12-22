/* $VER: scale.h 39.0 (21.8.1991) */
OPT NATIVE
MODULE 'target/exec/types'
MODULE 'target/graphics/gfx'
{#include <graphics/scale.h>}
NATIVE {GRAPHICS_SCALE_H} CONST

NATIVE {BitScaleArgs} OBJECT bitscaleargs
    {bsa_SrcX}	srcx	:UINT
	{bsa_SrcY}	srcy	:UINT			/* source origin */
    {bsa_SrcWidth}	srcwidth	:UINT
	{bsa_SrcHeight}	srcheight	:UINT	/* source size */
    {bsa_XSrcFactor}	xsrcfactor	:UINT
	{bsa_YSrcFactor}	ysrcfactor	:UINT	/* scale factor denominators */
    {bsa_DestX}	destx	:UINT
	{bsa_DestY}	desty	:UINT		/* destination origin */
    {bsa_DestWidth}	destwidth	:UINT
	{bsa_DestHeight}	destheight	:UINT	/* destination size result */
    {bsa_XDestFactor}	xdestfactor	:UINT
	{bsa_YDestFactor}	ydestfactor	:UINT	/* scale factor numerators */
    {bsa_SrcBitMap}	srcbitmap	:PTR TO bitmap		/* source BitMap */
    {bsa_DestBitMap}	destbitmap	:PTR TO bitmap		/* destination BitMap */
    {bsa_Flags}	flags	:ULONG				/* reserved.  Must be zero! */
    {bsa_XDDA}	xdda	:UINT
	{bsa_YDDA}	ydda	:UINT			/* reserved */
    {bsa_Reserved1}	reserved1	:VALUE
    {bsa_Reserved2}	reserved2	:VALUE
ENDOBJECT
