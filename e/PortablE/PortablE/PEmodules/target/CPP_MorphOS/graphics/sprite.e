/* $VER: sprite.h 39.6 (16.6.1992) */
OPT NATIVE
MODULE 'target/exec/types'
{#include <graphics/sprite.h>}
NATIVE {GRAPHICS_SPRITE_H} CONST

NATIVE {SPRITE_ATTACHED} CONST SPRITE_ATTACHED = $80

NATIVE {SimpleSprite} OBJECT simplesprite
    {posctldata}	posctldata	:PTR TO UINT
    {height}	height	:UINT
    {x}	x	:UINT
	{y}	y	:UINT    /* current position */
    {num}	num	:UINT
ENDOBJECT

NATIVE {ExtSprite} OBJECT extsprite
	{es_SimpleSprite}	simplesprite	:simplesprite	/* conventional simple sprite structure */
	{es_wordwidth}	wordwidth	:UINT			/* graphics use only, subject to change */
	{es_flags}	flags	:UINT			/* graphics use only, subject to change */
ENDOBJECT



/* tags for AllocSpriteData() */
NATIVE {SPRITEA_Width}		CONST SPRITEA_WIDTH		= $81000000
NATIVE {SPRITEA_XReplication}	CONST SPRITEA_XREPLICATION	= $81000002
NATIVE {SPRITEA_YReplication}	CONST SPRITEA_YREPLICATION	= $81000004
NATIVE {SPRITEA_OutputHeight}	CONST SPRITEA_OUTPUTHEIGHT	= $81000006
NATIVE {SPRITEA_Attached}	CONST SPRITEA_ATTACHED	= $81000008
NATIVE {SPRITEA_OldDataFormat}	CONST SPRITEA_OLDDATAFORMAT	= $8100000a	/* MUST pass in outputheight if using this tag */

/* tags for GetExtSprite() */
NATIVE {GSTAG_SPRITE_NUM} CONST GSTAG_SPRITE_NUM = $82000020
NATIVE {GSTAG_ATTACHED}	 CONST GSTAG_ATTACHED	 = $82000022
NATIVE {GSTAG_SOFTSPRITE} CONST GSTAG_SOFTSPRITE = $82000024

/* tags valid for either GetExtSprite or ChangeExtSprite */
NATIVE {GSTAG_SCANDOUBLED}	CONST GSTAG_SCANDOUBLED	= $83000000	/* request "NTSC-Like" height if possible. */
