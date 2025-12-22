/* $Id: clip.h 19924 2003-10-08 02:25:29Z bergers $ */
OPT NATIVE
PUBLIC MODULE 'target/graphics/gfx_shared3'
MODULE 'target/exec/semaphores', 'target/exec/types', 'target/graphics/gfx', /*'target/intuition/intuition',*/ 'target/utility/hooks'
{#include <graphics/clip.h>}
NATIVE {GRAPHICS_CLIP_H} CONST

NATIVE {NEWLOCKS} CONST


->"OBJECT layer" is on-purposely missing from here (it can be found in 'graphics/gfx_shared3')

NATIVE {MAXSUPERSAVECLIPRECTS}	CONST MAXSUPERSAVECLIPRECTS	= 20	/* Max. number of cliprects that are kept preallocated in the list */

->"OBJECT cliprect" is on-purposely missing from here (it can be found in 'graphics/gfx_shared3')

/* PRIVATE */
NATIVE {CR_NEEDS_NO_CONCEALED_RASTERS} CONST CR_NEEDS_NO_CONCEALED_RASTERS = 1
NATIVE {CR_NEEDS_NO_LAYERBLIT_DAMAGE}  CONST CR_NEEDS_NO_LAYERBLIT_DAMAGE  = 2

NATIVE {ISLESSX} CONST ISLESSX = $1
NATIVE {ISLESSY} CONST ISLESSY = $2
NATIVE {ISGRTRX} CONST ISGRTRX = $4
NATIVE {ISGRTRY} CONST ISGRTRY = $8

/* This one is used for determining optimal offset for blitting into
cliprects */
NATIVE {ALIGN_OFFSET} CONST	->ALIGN_OFFSET(x) ((x) & 0x0F)


->NATIVE {LA_Priority}	CONST
NATIVE {LA_Hook}		CONST
->NATIVE {LA_SuperBitMap}	CONST
NATIVE {LA_ChildOf}	CONST
NATIVE {LA_InFrontOf}	CONST
->NATIVE {LA_Behind}	CONST
NATIVE {LA_Visible}	CONST
->NATIVE {LA_Shape}	CONST
NATIVE {LA_ShapeHook}	CONST


/*
 * Tags for scale layer
 */
NATIVE {LA_SRCX}	      CONST LA_SRCX	      = $4000
NATIVE {LA_SRCY}       CONST LA_SRCY       = $4001
NATIVE {LA_DESTX}      CONST LA_DESTX      = $4002
NATIVE {LA_DESTY}      CONST LA_DESTY      = $4003
NATIVE {LA_SRCWIDTH}   CONST LA_SRCWIDTH   = $4004
NATIVE {LA_SRCHEIGHT}  CONST LA_SRCHEIGHT  = $4005
NATIVE {LA_DESTWIDTH}  CONST LA_DESTWIDTH  = $4006
NATIVE {LA_DESTHEIGHT} CONST LA_DESTHEIGHT = $4007


NATIVE {ROOTPRIORITY}		CONST ROOTPRIORITY		= 0
NATIVE {BACKDROPPRIORITY}	CONST BACKDROPPRIORITY	= 10
NATIVE {UPFRONTPRIORITY}		CONST UPFRONTPRIORITY		= 20

NATIVE {IS_VISIBLE} CONST	->IS_VISIBLE(l) (TRUE == l->visible)

NATIVE {ChangeLayerShapeMsg} OBJECT changelayershapemsg
  {newshape}	newshape	:PTR TO region -> same as passed to ChangeLayerShape()
  {cliprect}	cliprect	:PTR TO cliprect
  {shape}	shape	:PTR TO region
ENDOBJECT

NATIVE {CollectPixelsLayerMsg} OBJECT collectpixelslayermsg
  {xSrc}	xsrc	:VALUE
  {ySrc}	ysrc	:VALUE
  {width}	width	:VALUE
  {height}	height	:VALUE
  {xDest}	xdest	:VALUE
  {yDest}	ydest	:VALUE
  {bm}	bm	:PTR TO bitmap
  {layer}	layer	:PTR TO layer
  {minterm}	minterm	:ULONG
ENDOBJECT

/* Msg sent through LA_ShapeHook. */

NATIVE {SHAPEHOOKACTION_CREATELAYER}     CONST SHAPEHOOKACTION_CREATELAYER     = 0
NATIVE {SHAPEHOOKACTION_MOVELAYER}	    CONST SHAPEHOOKACTION_MOVELAYER	    = 1
NATIVE {SHAPEHOOKACTION_SIZELAYER}	    CONST SHAPEHOOKACTION_SIZELAYER	    = 2
NATIVE {SHAPEHOOKACTION_MOVESIZELAYER}   CONST SHAPEHOOKACTION_MOVESIZELAYER   = 3

NATIVE {ShapeHookMsg} OBJECT shapehookmsg
    {Action}	action	:VALUE
    {Layer}	layer	:PTR TO layer
    {ActualShape}	actualshape	:PTR TO region
    {NewBounds}	newbounds	:rectangle
    {OldBounds}	oldbounds	:rectangle
ENDOBJECT
