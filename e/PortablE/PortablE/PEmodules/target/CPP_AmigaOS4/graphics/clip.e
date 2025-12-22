/* $Id: clip.h,v 1.16 2005/11/10 15:36:43 hjfrieden Exp $ */
OPT NATIVE
PUBLIC MODULE 'target/graphics/gfx_shared3'
MODULE 'target/exec/types', 'target/graphics/gfx', 'target/exec/semaphores', 'target/utility/hooks'
{#include <graphics/clip.h>}
NATIVE {GRAPHICS_CLIP_H} CONST

NATIVE {NEWLOCKS} CONST

/*
 * Thor says: Keep hands off this structure. Layers builds it for you,
 * and keeps and adminstrates it for you. What's documented here is
 * only of interest for graphics and intuition. Especially, you may
 * only look at the front/back pointer of this layer while keeping the
 * layers list locked, or at the (Super)ClipRect singly (!) linked
 * list while keeping this layer locked. Bounds are the bounds of this 
 * layer, rp its rastport whose layer is, surprise, surprise, this here.
 * Lock is the access lock you please lock by LockLayer() or
 * LockLayerRom().
 * Everything else is completely off-limits and for private use only.
 */

->"OBJECT layer" is on-purposely missing from here (it can be found in 'graphics/gfx_shared3')

/*
 * Describes one graphic rectangle of this layer, may it
 * be drawable or not. 
 * The meaning of some fields in here changed in the past,
 * and will remain changing. Chaining is done by Next, and
 * if "lobs" is non-NULL, BitMap *may* point to a backing
 * store bitmap aligned to multiples of 16 pixels. 
 * Everything else is private, and may change.
 * Especially, note that this structure grew in v33(!!!)
 * and has now been documented to be of this size in
 * v44. NEWCLIPRECTS_1_1 is really, really obsolete.
 * Do *never* allocate this yourself as layers handles them
 * internally more efficiently than AllocMem() could.
 */

->"OBJECT cliprect" is on-purposely missing from here (it can be found in 'graphics/gfx_shared3')

/* internal cliprect flags */
NATIVE {CR_USERCLIPPED}    CONST CR_USERCLIPPED    = 16 /* out of user clip rectangle */
NATIVE {CR_DAMAGECLIPPED}  CONST CR_DAMAGECLIPPED  = 32 /* out of damage cliprects */

/* defines for code values for getcode 
 * this really belongs to graphics, and is of no
 * use for layers. It's here only for traditional
 * reasons.
 */
NATIVE {ISLESSX} CONST ISLESSX = 1
NATIVE {ISLESSY} CONST ISLESSY = 2
NATIVE {ISGRTRX} CONST ISGRTRX = 4
NATIVE {ISGRTRY} CONST ISGRTRY = 8

/*
 * defines for shape hooks
 */
NATIVE {SHAPEHOOKACTION_CREATELAYER}      CONST SHAPEHOOKACTION_CREATELAYER      = 0
NATIVE {SHAPEHOOKACTION_MOVELAYER}        CONST SHAPEHOOKACTION_MOVELAYER        = 1 /* Only sent if LAYERMOVECHANGESSHAPE is set */
NATIVE {SHAPEHOOKACTION_SIZELAYER}        CONST SHAPEHOOKACTION_SIZELAYER        = 2
NATIVE {SHAPEHOOKACTION_MOVESIZELAYER}    CONST SHAPEHOOKACTION_MOVESIZELAYER    = 3
NATIVE {SHAPEHOOKACTION_CHANGELAYERSHAPE} CONST SHAPEHOOKACTION_CHANGELAYERSHAPE = 4
NATIVE {SHAPEHOOKACTION_DELETELAYER}      CONST SHAPEHOOKACTION_DELETELAYER      = 5
NATIVE {SHAPEHOOKACTION_GETHOOKACTIONS}   CONST SHAPEHOOKACTION_GETHOOKACTIONS   = 6

NATIVE {ShapeHookMsg} OBJECT shapehookmsg
    {Action}	action	:ULONG
    {NewShape}	newshape	:PTR TO region
    {OldShape}	oldshape	:PTR TO region
    {NewBounds}	newbounds	:PTR TO rectangle
    {OldBounds}	oldbounds	:PTR TO rectangle
ENDOBJECT
