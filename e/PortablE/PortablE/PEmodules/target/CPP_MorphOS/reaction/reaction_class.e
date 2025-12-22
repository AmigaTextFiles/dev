/* $VER: reaction_class.h 44.1 (19.10.1999) */
OPT NATIVE
MODULE 'target/intuition/cghooks'
MODULE 'target/exec/types', 'target/graphics/regions'
{#include <reaction/reaction_class.h>}
NATIVE {REACTION_REACTION_CLASS_H} CONST

/*
 * PRIVATE!
 */
NATIVE {SpecialPens} OBJECT specialpens
	{sp_Version}	version	:INT	/* Currently 0 */
	{sp_DarkPen}	darkpen	:VALUE	/* XEN/Thick extended locked pen */
	{sp_LightPen}	lightpen	:VALUE	/* XEN/Thick extended locked pen */
	/* NOTE: This structure may grow! */
ENDOBJECT

/*****************************************************************************
 * Custom method defined and supported by some Reaction Gadgets
 * When this method is supported by more (all?) Reaction Gadgets
 * this structure may move to intuition/gadgetclass.h
 */
NATIVE {GM_CLIPRECT}  CONST GM_CLIPRECT  = ($550001)

/* The GM_CLIPRECT method is used to pass a gadget a cliprect
 * it should install before rendering to ObtainGIRPort() rastports
 * to support proper usage within virtual groups.
 */

NATIVE {gpClipRect} OBJECT gpcliprect
	{MethodID}	methodid	:ULONG       /* GM_CLIPRECT              */
	{gpc_GInfo}	ginfo	:PTR TO gadgetinfo      /* GadgetInfo               */
	{gpc_ClipRect}	cliprect	:PTR TO rectangle   /* Rectangle To Clip To     */
	{gpc_Flags}	flags	:ULONG      /* Flags                    */
ENDOBJECT

/* Possible return values from GM_CLIPRECT
 */
NATIVE {GMC_VISIBLE}			CONST GMC_VISIBLE			= 2
NATIVE {GMC_PARTIAL}			CONST GMC_PARTIAL			= 1
NATIVE {GMC_INVISIBLE}		CONST GMC_INVISIBLE		= 0
