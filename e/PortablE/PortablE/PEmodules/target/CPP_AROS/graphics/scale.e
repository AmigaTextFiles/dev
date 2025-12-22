/* $Id: scale.h 12757 2001-12-08 22:23:57Z chodorowski $ */
OPT NATIVE
MODULE 'target/exec/types'
MODULE 'target/graphics/gfx'
{#include <graphics/scale.h>}
NATIVE {GRAPHICS_SCALE_H} CONST

/* BitScaleArgs structure used by BitMapScale() */

NATIVE {BitScaleArgs} OBJECT bitscaleargs
  {bsa_SrcX}	srcx	:UINT
  {bsa_SrcY}	srcy	:UINT		
  {bsa_SrcWidth}	srcwidth	:UINT
  {bsa_SrcHeight}	srcheight	:UINT
  {bsa_XSrcFactor}	xsrcfactor	:UINT
  {bsa_YSrcFactor}	ysrcfactor	:UINT
  {bsa_DestX}	destx	:UINT
  {bsa_DestY}	desty	:UINT
  {bsa_DestWidth}	destwidth	:UINT
  {bsa_DestHeight}	destheight	:UINT
  {bsa_XDestFactor}	xdestfactor	:UINT
  {bsa_YDestFactor}	ydestfactor	:UINT
  {bsa_SrcBitMap}	srcbitmap	:PTR TO bitmap
  {bsa_DestBitMap}	destbitmap	:PTR TO bitmap
  {bsa_Flags}	flags	:ULONG
  {bsa_XDDA}	xdda	:UINT
  {bsa_YDDA}	ydda	:UINT
  {bsa_Reserved1}	reserved1	:VALUE
  {bsa_Reserved2}	reserved2	:VALUE
ENDOBJECT
