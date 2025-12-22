/* $VER: gels.h 39.0 (21.8.1991) */
OPT NATIVE
PUBLIC MODULE 'target/graphics/gfx_shared4'
MODULE 'target/exec/types'
{#include <graphics/gels.h>}
NATIVE {GRAPHICS_GELS_H} CONST

/* VSprite flags */
/* user-set VSprite flags: */
NATIVE {SUSERFLAGS}  CONST SUSERFLAGS  = $00FF    /* mask of all user-settable VSprite-flags */
NATIVE {VSPRITE}     CONST VSF_VSPRITE     = $0001    /* set if VSprite, clear if Bob */
NATIVE {SAVEBACK}    CONST VSF_SAVEBACK    = $0002    /* set if background is to be saved/restored */
NATIVE {OVERLAY}     CONST VSF_OVERLAY     = $0004    /* set to mask image of Bob onto background */
NATIVE {MUSTDRAW}    CONST VSF_MUSTDRAW    = $0008    /* set if VSprite absolutely must be drawn */
/* system-set VSprite flags: */
NATIVE {BACKSAVED}   CONST VSF_BACKSAVED   = $0100    /* this Bob's background has been saved */
NATIVE {BOBUPDATE}   CONST VSF_BOBUPDATE   = $0200    /* temporary flag, useless to outside world */
NATIVE {GELGONE}     CONST VSF_GELGONE     = $0400    /* set if gel is completely clipped (offscreen) */
NATIVE {VSOVERFLOW}  CONST VSF_VSOVERFLOW  = $0800    /* VSprite overflow (if MUSTDRAW set we draw!) */

/* Bob flags */
/* these are the user flag bits */
NATIVE {BUSERFLAGS}  CONST BUSERFLAGS  = $00FF    /* mask of all user-settable Bob-flags */
NATIVE {SAVEBOB}     CONST BF_SAVEBOB     = $0001    /* set to not erase Bob */
NATIVE {BOBISCOMP}   CONST BF_BOBISCOMP   = $0002    /* set to identify Bob as AnimComp */
/* these are the system flag bits */
NATIVE {BWAITING}    CONST BF_BWAITING    = $0100    /* set while Bob is waiting on 'after' */
NATIVE {BDRAWN}	    CONST BF_BDRAWN	    = $0200    /* set when Bob is drawn this DrawG pass*/
NATIVE {BOBSAWAY}    CONST BF_BOBSAWAY    = $0400    /* set to initiate removal of Bob */
NATIVE {BOBNIX}	    CONST BF_BOBNIX	    = $0800    /* set when Bob is completely removed */
NATIVE {SAVEPRESERVE} CONST BF_SAVEPRESERVE = $1000   /* for back-restore during double-buffer*/
NATIVE {OUTSTEP}     CONST BF_OUTSTEP     = $2000    /* for double-clearing if double-buffer */

/* defines for the animation procedures */
NATIVE {ANFRACSIZE}  CONST ANFRACSIZE  = 6
NATIVE {ANIMHALF}    CONST ANIMHALF    = $0020
NATIVE {RINGTRIGGER} CONST RINGTRIGGER = $0001


/* UserStuff definitions
 *  the user can define these to be a single variable or a sub-structure
 *  if undefined by the user, the system turns these into innocuous variables
 *  see the manual for a thorough definition of the UserStuff definitions
 *
 */
	      /* VSprite user stuff */
NATIVE {VUserStuff} CONST

	      /* Bob user stuff */
NATIVE {BUserStuff} CONST

	      /* AnimOb user stuff */
NATIVE {AUserStuff} CONST




/*********************** GEL STRUCTURES ***********************************/

->"OBJECT vs" is on-purposely missing from here (it can be found in 'graphics/gfx_shared4')

->"OBJECT bob" is on-purposely missing from here (it can be found in 'graphics/gfx_shared4')

->"OBJECT ac" is on-purposely missing from here (it can be found in 'graphics/gfx_shared4')

->"OBJECT ao" is on-purposely missing from here (it can be found in 'graphics/gfx_shared4')

/* dBufPacket defines the values needed to be saved across buffer to buffer
 *  when in double-buffer mode
 */
->"OBJECT dbp" is on-purposely missing from here (it can be found in 'graphics/gfx_shared4')



/* ************************************************************************ */

/* these are GEL functions that are currently simple enough to exist as a
 *  definition.  It should not be assumed that this will always be the case
 */
NATIVE {InitAnimate} PROC	->InitAnimate(animKey) {*(animKey) = NULL;}
PROC InitAnimate(animKey:ARRAY OF PTR) IS NATIVE {InitAnimate(} animKey {)} ENDNATIVE
NATIVE {RemBob} PROC	->RemBob(b) {(b)->Flags |= BOBSAWAY;}
PROC RemBob(b:PTR TO bob) IS NATIVE {RemBob(} b {)} ENDNATIVE


/* ************************************************************************ */

NATIVE {B2NORM}	    CONST B2NORM	    = 0
NATIVE {B2SWAP}	    CONST B2SWAP	    = 1
NATIVE {B2BOBBER}    CONST B2BOBBER    = 2

/* ************************************************************************ */

/* a structure to contain the 16 collision procedure addresses */
->"OBJECT colltable" is on-purposely missing from here (it can be found in 'graphics/gfx_shared4')
