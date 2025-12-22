/* $VER: gels.h 39.0 (21.8.1991) */
OPT NATIVE
PUBLIC MODULE 'target/graphics/gfx_shared4'
MODULE 'target/exec/types'
{MODULE 'graphics/gels'}

/* VSprite flags */
/* user-set VSprite flags: */
NATIVE {SUSERFLAGS}  CONST SUSERFLAGS  = $00FF    /* mask of all user-settable VSprite-flags */
NATIVE {VSF_VSPRITE}     CONST VSF_VSPRITE     = $0001    /* set if VSprite, clear if Bob */
NATIVE {VSF_SAVEBACK}    CONST VSF_SAVEBACK    = $0002    /* set if background is to be saved/restored */
NATIVE {VSF_OVERLAY}     CONST VSF_OVERLAY     = $0004    /* set to mask image of Bob onto background */
NATIVE {VSF_MUSTDRAW}    CONST VSF_MUSTDRAW    = $0008    /* set if VSprite absolutely must be drawn */
/* system-set VSprite flags: */
NATIVE {VSF_BACKSAVED}   CONST VSF_BACKSAVED   = $0100    /* this Bob's background has been saved */
NATIVE {VSF_BOBUPDATE}   CONST VSF_BOBUPDATE   = $0200    /* temporary flag, useless to outside world */
NATIVE {VSF_GELGONE}     CONST VSF_GELGONE     = $0400    /* set if gel is completely clipped (offscreen) */
NATIVE {VSF_VSOVERFLOW}  CONST VSF_VSOVERFLOW  = $0800    /* VSprite overflow (if MUSTDRAW set we draw!) */

/* Bob flags */
/* these are the user flag bits */
NATIVE {BUSERFLAGS}  CONST BUSERFLAGS  = $00FF    /* mask of all user-settable Bob-flags */
NATIVE {BF_SAVEBOB}     CONST BF_SAVEBOB     = $0001    /* set to not erase Bob */
NATIVE {BF_BOBISCOMP}   CONST BF_BOBISCOMP   = $0002    /* set to identify Bob as AnimComp */
/* these are the system flag bits */
NATIVE {BF_BWAITING}    CONST BF_BWAITING    = $0100    /* set while Bob is waiting on 'after' */
NATIVE {BF_BDRAWN}	    CONST BF_BDRAWN	    = $0200    /* set when Bob is drawn this DrawG pass*/
NATIVE {BF_BOBSAWAY}    CONST BF_BOBSAWAY    = $0400    /* set to initiate removal of Bob */
NATIVE {BF_BOBNIX}	    CONST BF_BOBNIX	    = $0800    /* set when Bob is completely removed */
NATIVE {BF_SAVEPRESERVE} CONST BF_SAVEPRESERVE = $1000   /* for back-restore during double-buffer*/
NATIVE {BF_OUTSTEP}     CONST BF_OUTSTEP     = $2000    /* for double-clearing if double-buffer */

/* defines for the animation procedures */
NATIVE {ANFRACSIZE}  CONST ANFRACSIZE  = 6
NATIVE {ANIMHALF}    CONST ANIMHALF    = $0020
NATIVE {RINGTRIGGER} CONST RINGTRIGGER = $0001

/*********************** GEL STRUCTURES ***********************************/

->"OBJECT vs" is on-purposely missing from here (it can be found in 'graphics/gfx_shared4')

->"OBJECT bob" is on-purposely missing from here (it can be found in 'graphics/gfx_shared4')

->"OBJECT ac" is on-purposely missing from here (it can be found in 'graphics/gfx_shared4')

->"OBJECT ao" is on-purposely missing from here (it can be found in 'graphics/gfx_shared4')

->"OBJECT dbp" is on-purposely missing from here (it can be found in 'graphics/gfx_shared4')


/* ************************************************************************ */

NATIVE {InitAnimate} PROC
PROC InitAnimate(animKey:ARRAY OF PTR) IS NATIVE {InitAnimate(} animKey {)} ENDNATIVE
NATIVE {RemBob} PROC
PROC RemBob(b:PTR TO bob) IS NATIVE {RemBob(} b {)} ENDNATIVE


/* ************************************************************************ */

NATIVE {B2NORM}	    CONST B2NORM	    = 0
NATIVE {B2SWAP}	    CONST B2SWAP	    = 1
NATIVE {B2BOBBER}    CONST B2BOBBER    = 2

/* ************************************************************************ */

/* a structure to contain the 16 collision procedure addresses */
->"OBJECT colltable" is on-purposely missing from here (it can be found in 'graphics/gfx_shared4')
