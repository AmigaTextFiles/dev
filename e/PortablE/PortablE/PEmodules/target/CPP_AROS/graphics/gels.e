/* $Id: gels.h 22331 2004-09-04 11:59:49Z verhaegs $ */
OPT NATIVE
PUBLIC MODULE 'target/graphics/gfx_shared4'
MODULE 'target/exec/types'
{#include <graphics/gels.h>}
NATIVE {GRAPHICS_GELS_H} CONST

/* VSprite flags */
/* VSprite flags set by user: */
NATIVE {VSPRITE}     CONST VSF_VSPRITE     = $0001   
NATIVE {SAVEBACK}    CONST VSF_SAVEBACK    = $0002   
NATIVE {OVERLAY}     CONST VSF_OVERLAY     = $0004   
NATIVE {MUSTDRAW}    CONST VSF_MUSTDRAW    = $0008   
NATIVE {SUSERFLAGS}  CONST SUSERFLAGS  = $00FF   

/* VSprite flags set by system: */
NATIVE {BACKSAVED}   CONST VSF_BACKSAVED   = $0100   
NATIVE {BOBUPDATE}   CONST VSF_BOBUPDATE   = $0200 
NATIVE {GELGONE}     CONST VSF_GELGONE     = $0400   
NATIVE {VSOVERFLOW}  CONST VSF_VSOVERFLOW  = $0800 

/* Bob flags */
/* user flag bits */
NATIVE {SAVEBOB}     CONST BF_SAVEBOB     = $0001 
NATIVE {BOBISCOMP}   CONST BF_BOBISCOMP   = $0002    
NATIVE {BUSERFLAGS}  CONST BUSERFLAGS  = $00FF   

/* system flag bits */
NATIVE {BWAITING}     CONST BF_BWAITING     = $0100 
NATIVE {BDRAWN}	     CONST BF_BDRAWN	     = $0200    
NATIVE {BOBSAWAY}     CONST BF_BOBSAWAY     = $0400   
NATIVE {BOBNIX}	     CONST BF_BOBNIX	     = $0800   
NATIVE {SAVEPRESERVE} CONST BF_SAVEPRESERVE = $1000  
NATIVE {OUTSTEP}      CONST BF_OUTSTEP      = $2000  

/* defines for animation procedures */
NATIVE {ANFRACSIZE}  CONST ANFRACSIZE  = 6
NATIVE {RINGTRIGGER} CONST RINGTRIGGER = $0001
NATIVE {ANIMHALF}    CONST ANIMHALF    = $0020


/* UserStuff definitions */
NATIVE {VUserStuff} CONST
NATIVE {BUserStuff} CONST
NATIVE {AUserStuff} CONST




/*********************** GEL STRUCTURES ***********************************/

->"OBJECT vs" is on-purposely missing from here (it can be found in 'graphics/gfx_shared4')

->"OBJECT bob" is on-purposely missing from here (it can be found in 'graphics/gfx_shared4')

->"OBJECT ac" is on-purposely missing from here (it can be found in 'graphics/gfx_shared4')

->"OBJECT ao" is on-purposely missing from here (it can be found in 'graphics/gfx_shared4')

->"OBJECT dbp" is on-purposely missing from here (it can be found in 'graphics/gfx_shared4')



/* ************************************************************************ */

/* simple GEL functions that can currently exist as a definition.  
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

/* a structure for the 16 collision procedure addresses */
->"OBJECT colltable" is on-purposely missing from here (it can be found in 'graphics/gfx_shared4')

/* cxref mixes up with the function pointers in the previous definition */
->extern int __cxref_bug_gels;
