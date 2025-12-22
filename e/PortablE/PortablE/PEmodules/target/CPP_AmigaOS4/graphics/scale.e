/* $Id: scale.h,v 1.12 2005/11/10 15:36:43 hjfrieden Exp $ */
OPT NATIVE
MODULE 'target/exec/types'
MODULE 'target/graphics/gfx'
{#include <graphics/scale.h>}
NATIVE {GRAPHICS_SCALE_H} CONST

NATIVE {BitScaleArgs} OBJECT bitscaleargs
    {bsa_SrcX}	srcx	:UINT         /* source origin            */
    {bsa_SrcY}	srcy	:UINT         /*       "                  */
    {bsa_SrcWidth}	srcwidth	:UINT     /* source size              */
    {bsa_SrcHeight}	srcheight	:UINT    /*       "                  */
    {bsa_XSrcFactor}	xsrcfactor	:UINT   /* scale factor denominator */
    {bsa_YSrcFactor}	ysrcfactor	:UINT   /*       "                  */
    {bsa_DestX}	destx	:UINT        /* destination origin       */
    {bsa_DestY}	desty	:UINT        /*       "                  */
    {bsa_DestWidth}	destwidth	:UINT    /* destination size result  */
    {bsa_DestHeight}	destheight	:UINT   /*       "                  */
    {bsa_XDestFactor}	xdestfactor	:UINT  /* scale factor numerator   */
    {bsa_YDestFactor}	ydestfactor	:UINT  /*       "                  */
    {bsa_SrcBitMap}	srcbitmap	:PTR TO bitmap    /* source BitMap            */
    {bsa_DestBitMap}	destbitmap	:PTR TO bitmap   /* destination BitMap       */
    {bsa_Flags}	flags	:ULONG        /* reserved.  Must be zero! */
    {bsa_XDDA}	xdda	:UINT         /* reserved                 */
    {bsa_YDDA}	ydda	:UINT         /*       "                  */
    {bsa_Reserved1}	reserved1	:VALUE    /*       "                  */
    {bsa_Reserved2}	reserved2	:VALUE    /*       "                  */
ENDOBJECT
