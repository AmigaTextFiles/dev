/* $Id: sprite.h 19503 2003-08-29 21:37:33Z bergers $ */
OPT NATIVE
MODULE 'target/exec/types'
MODULE 'target/graphics/gfx'
{#include <graphics/sprite.h>}
NATIVE {GRAPHICS_SPRITE_H} CONST

NATIVE {SPRITE_ATTACHED} CONST SPRITE_ATTACHED = $80

NATIVE {SimpleSprite} OBJECT simplesprite
    {posctldata}	posctldata	:PTR TO UINT
    {height}	height	:UINT
    {x}	x	:UINT
	{y}	y	:UINT    
    {num}	num	:UINT
ENDOBJECT

NATIVE {ExtSprite} OBJECT extsprite
	{es_SimpleSprite}	simplesprite	:simplesprite
	{es_wordwidth}	wordwidth	:UINT
	{es_flags}	flags	:UINT

	/* New in AROS */
	{es_BitMap}	bitmap	:PTR TO bitmap  -> Actual image data.
ENDOBJECT



/* tags for use with AllocSpriteData() */
NATIVE {SPRITEA_Width}		CONST SPRITEA_WIDTH		= $81000000
NATIVE {SPRITEA_XReplication}	CONST SPRITEA_XREPLICATION	= $81000002
NATIVE {SPRITEA_YReplication}	CONST SPRITEA_YREPLICATION	= $81000004
NATIVE {SPRITEA_OutputHeight}	CONST SPRITEA_OUTPUTHEIGHT	= $81000006
NATIVE {SPRITEA_Attached}	CONST SPRITEA_ATTACHED	= $81000008
NATIVE {SPRITEA_OldDataFormat}	CONST SPRITEA_OLDDATAFORMAT	= $8100000a

/* tags valid for either GetExtSprite or ChangeExtSprite */
NATIVE {GSTAG_SCANDOUBLED}	CONST GSTAG_SCANDOUBLED	= $83000000

/* tags for use with GetExtSprite() */
NATIVE {GSTAG_SPRITE_NUM} CONST GSTAG_SPRITE_NUM = $82000020
NATIVE {GSTAG_ATTACHED}	 CONST GSTAG_ATTACHED	 = $82000022
NATIVE {GSTAG_SOFTSPRITE} CONST GSTAG_SOFTSPRITE = $82000024
