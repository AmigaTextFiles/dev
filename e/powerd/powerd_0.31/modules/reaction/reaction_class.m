/*
**  $VER: reaction_class.h 44.1 (19.10.1999)
**  Includes Release 44.1
**
**  reaction class author definitions
**
**  (C) Copyright 1987-1999 Amiga, Inc.
**      All Rights Reserved
*/
MODULE 'intuition/cghooks'
/*
 * PRIVATE!
 */
OBJECT SpecialPens
 Version:WORD,     /* Currently 0 */
 DarkPen:LONG,     /* XEN/Thick extended locked pen */
 LightPen:LONG     /* XEN/Thick extended locked pen */

/* Custom method defined and supported by some Reaction Gadgets
 * When this method is supported by more (all?) Reaction Gadgets
 * this structure may move to intuition/gadgetclass.h
 */
#define GM_CLIPRECT ($550001)
/* The GM_CLIPRECT method is used to pass a gadget a cliprect
 * it should install before rendering to ObtainGIRPort() rastports
 * to support proper usage within virtual groups.
 */
OBJECT gpClipRect
 MethodID:ULONG,                   /* GM_CLIPRECT              */
 GInfo:PTR TO GadgetInfo,      /* GadgetInfo               */
 ClipRect:PTR TO Rectangle,    /* Rectangle To Clip To     */
 Flags:ULONG                   /* Flags                    */

/* Possible return values from GM_CLIPRECT
 */
#define GMC_VISIBLE       2
#define GMC_PARTIAL       1
#define GMC_INVISIBLE     0
