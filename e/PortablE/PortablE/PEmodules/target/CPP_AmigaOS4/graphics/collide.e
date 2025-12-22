/* $Id: collide.h,v 1.12 2005/11/10 15:36:43 hjfrieden Exp $ */
OPT NATIVE
{#include <graphics/collide.h>}
NATIVE {GRAPHICS_COLLIDE_H} CONST

/* These bit descriptors are used by the GEL collide routines.
 *  These bits are set in the hitMask and meMask variables of
 *  a GEL to describe whether or not these types of collisions
 *  can affect the GEL.  BNDRY_HIT is described further below;
 *  this bit is permanently assigned as the boundary-hit flag.
 *  The other bit GEL_HIT is meant only as a default to cover
 *  any GEL hitting any other; the user may redefine this bit.
 */
NATIVE {BORDERHIT} CONST BORDERHIT = 0

/* These bit descriptors are used by the GEL boundry hit routines.
 *  When the user's boundry-hit routine is called (via the argument
 *  set by a call to SetCollision) the first argument passed to
 *  the user's routine is the address of the GEL involved in the
 *  boundry-hit, and the second argument has the appropriate bit(s)
 *  set to describe which boundry was surpassed
 */
NATIVE {TOPHIT}    CONST TOPHIT    = 1
NATIVE {BOTTOMHIT} CONST BOTTOMHIT = 2
NATIVE {LEFTHIT}   CONST LEFTHIT   = 4
NATIVE {RIGHTHIT}  CONST RIGHTHIT  = 8
