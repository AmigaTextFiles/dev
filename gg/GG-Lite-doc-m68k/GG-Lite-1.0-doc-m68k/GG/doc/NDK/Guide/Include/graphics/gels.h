@DATABASE "gg:doc/NDK/Guide/Include/graphics/gels.h"
@MASTER   "gg:os-include/graphics/gels.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:13:54
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "graphics/gels.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"graphics/gels.h" LINK File}


@{b}Structures@{ub}

@{"AnimComp" LINK "gg:doc/NDK/Guide/Include/graphics/gels.h/File" 168}  @{"AnimOb" LINK "gg:doc/NDK/Guide/Include/graphics/gels.h/File" 204}  @{"Bob" LINK "gg:doc/NDK/Guide/Include/graphics/gels.h/File" 139}  @{"collTable" LINK "gg:doc/NDK/Guide/Include/graphics/gels.h/File" 265}  @{"DBufPacket" LINK "gg:doc/NDK/Guide/Include/graphics/gels.h/File" 235}  @{"VSprite" LINK "gg:doc/NDK/Guide/Include/graphics/gels.h/File" 72}


@{b}#defines@{ub}

@{"ANFRACSIZE" LINK "gg:doc/NDK/Guide/Include/graphics/gels.h/File" 44}  @{"ANIMHALF" LINK "gg:doc/NDK/Guide/Include/graphics/gels.h/File" 45}       @{"AUserStuff" LINK "gg:doc/NDK/Guide/Include/graphics/gels.h/File" 64}  @{"B2BOBBER" LINK "gg:doc/NDK/Guide/Include/graphics/gels.h/File" 260}    @{"B2NORM" LINK "gg:doc/NDK/Guide/Include/graphics/gels.h/File" 258}
@{"B2SWAP" LINK "gg:doc/NDK/Guide/Include/graphics/gels.h/File" 259}      @{"BACKSAVED" LINK "gg:doc/NDK/Guide/Include/graphics/gels.h/File" 25}      @{"BDRAWN" LINK "gg:doc/NDK/Guide/Include/graphics/gels.h/File" 37}      @{"BOBISCOMP" LINK "gg:doc/NDK/Guide/Include/graphics/gels.h/File" 34}   @{"BOBNIX" LINK "gg:doc/NDK/Guide/Include/graphics/gels.h/File" 39}
@{"BOBSAWAY" LINK "gg:doc/NDK/Guide/Include/graphics/gels.h/File" 38}    @{"BOBUPDATE" LINK "gg:doc/NDK/Guide/Include/graphics/gels.h/File" 26}      @{"BUSERFLAGS" LINK "gg:doc/NDK/Guide/Include/graphics/gels.h/File" 32}  @{"BUserStuff" LINK "gg:doc/NDK/Guide/Include/graphics/gels.h/File" 60}  @{"BWAITING" LINK "gg:doc/NDK/Guide/Include/graphics/gels.h/File" 36}
@{"GELGONE" LINK "gg:doc/NDK/Guide/Include/graphics/gels.h/File" 27}     @{"InitAnimate()" LINK "gg:doc/NDK/Guide/Include/graphics/gels.h/File" 252}  @{"MUSTDRAW" LINK "gg:doc/NDK/Guide/Include/graphics/gels.h/File" 23}    @{"OUTSTEP" LINK "gg:doc/NDK/Guide/Include/graphics/gels.h/File" 41}     @{"OVERLAY" LINK "gg:doc/NDK/Guide/Include/graphics/gels.h/File" 22}
@{"RemBob()" LINK "gg:doc/NDK/Guide/Include/graphics/gels.h/File" 253}    @{"RINGTRIGGER" LINK "gg:doc/NDK/Guide/Include/graphics/gels.h/File" 46}    @{"SAVEBACK" LINK "gg:doc/NDK/Guide/Include/graphics/gels.h/File" 21}    @{"SAVEBOB" LINK "gg:doc/NDK/Guide/Include/graphics/gels.h/File" 33}     @{"SAVEPRESERVE" LINK "gg:doc/NDK/Guide/Include/graphics/gels.h/File" 40}
@{"SUSERFLAGS" LINK "gg:doc/NDK/Guide/Include/graphics/gels.h/File" 19}  @{"VSOVERFLOW" LINK "gg:doc/NDK/Guide/Include/graphics/gels.h/File" 28}     @{"VSPRITE" LINK "gg:doc/NDK/Guide/Include/graphics/gels.h/File" 20}     @{"VUserStuff" LINK "gg:doc/NDK/Guide/Include/graphics/gels.h/File" 56}  

@ENDNODE
@NODE File "graphics/gels.h"
#ifndef GRAPHICS_GELS_H
#define GRAPHICS_GELS_H
/*
**      $VER: gels.h 39.0 (21.8.1991)
**      Includes Release 45.1
**
**      include file for AMIGA GELS (Graphics Elements)
**
**      (C) Copyright 1985-2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif

/* VSprite flags */
/* user-set VSprite flags: */
#define SUSERFLAGS  0x00FF    /* mask of all user-settable VSprite-flags */
#define VSPRITE     0x0001    /* set if VSprite, clear if Bob */
#define SAVEBACK    0x0002    /* set if background is to be saved/restored */
#define OVERLAY     0x0004    /* set to mask image of Bob onto background */
#define MUSTDRAW    0x0008    /* set if VSprite absolutely must be drawn */
/* system-set VSprite flags: */
#define BACKSAVED   0x0100    /* this Bob's background has been saved */
#define BOBUPDATE   0x0200    /* temporary flag, useless to outside world */
#define GELGONE     0x0400    /* set if gel is completely clipped (offscreen) */
#define VSOVERFLOW  0x0800    /* VSprite overflow (if @{"MUSTDRAW" LINK File 23} set we draw!) */

/* Bob flags */
/* these are the user flag bits */
#define BUSERFLAGS  0x00FF    /* mask of all user-settable Bob-flags */
#define SAVEBOB     0x0001    /* set to not erase Bob */
#define BOBISCOMP   0x0002    /* set to identify Bob as AnimComp */
/* these are the system flag bits */
#define BWAITING    0x0100    /* set while Bob is waiting on 'after' */
#define BDRAWN      0x0200    /* set when Bob is drawn this DrawG pass*/
#define BOBSAWAY    0x0400    /* set to initiate removal of Bob */
#define BOBNIX      0x0800    /* set when Bob is completely removed */
#define SAVEPRESERVE 0x1000   /* for back-restore during double-buffer*/
#define OUTSTEP     0x2000    /* for double-clearing if double-buffer */

/* defines for the animation procedures */
#define ANFRACSIZE  6
#define ANIMHALF    0x0020
#define RINGTRIGGER 0x0001


/* UserStuff definitions
 *  the user can define these to be a single variable or a sub-structure
 *  if undefined by the user, the system turns these into innocuous variables
 *  see the manual for a thorough definition of the UserStuff definitions
 *
 */
#ifndef VUserStuff            /* VSprite user stuff */
#define VUserStuff @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}
#endif

#ifndef BUserStuff            /* Bob user stuff */
#define BUserStuff @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}
#endif

#ifndef AUserStuff            /* AnimOb user stuff */
#define AUserStuff @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}
#endif




/*********************** GEL STRUCTURES ***********************************/

struct VSprite
{
/* --------------------- SYSTEM VARIABLES ------------------------------- */
/* GEL linked list forward/backward pointers sorted by y,x value */
    struct VSprite   *NextVSprite;
    struct VSprite   *PrevVSprite;

/* GEL draw list constructed in the order the Bobs are actually drawn, then
 *  list is copied to clear list
 *  must be here in VSprite for system boundary detection
 */
    struct VSprite   *DrawPath;     /* pointer of overlay drawing */
    struct VSprite   *ClearPath;    /* pointer for overlay clearing */

/* the VSprite positions are defined in (y,x) order to make sorting
 *  sorting easier, since (y,x) as a long integer
 */
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54} OldY, OldX;          /* previous position */

/* --------------------- COMMON VARIABLES --------------------------------- */
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54} Flags;       /* VSprite flags */


/* --------------------- USER VARIABLES ----------------------------------- */
/* the VSprite positions are defined in (y,x) order to make sorting
 *  sorting easier, since (y,x) as a long integer
 */
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54} Y, X;                /* screen position */

    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54} Height;
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54} Width;       /* number of words per row of image data */
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54} Depth;       /* number of planes of data */

    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54} MeMask;              /* which types can collide with this VSprite*/
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54} HitMask;             /* which types this VSprite can collide with*/

    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54} *ImageData;          /* pointer to VSprite image */

/* borderLine is the one-dimensional logical OR of all
 *  the VSprite bits, used for fast collision detection of edge
 */
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54} *BorderLine;         /* logical OR of all VSprite bits */
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54} *CollMask;           /* similar to above except this is a matrix */

/* pointer to this VSprite's color definitions (not used by Bobs) */
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54} *SprColors;

    @{"struct Bob" LINK File 139} *VSBob;        /* points home if this VSprite is part of
                                   a Bob */

/* planePick flag:  set bit selects a plane from image, clear bit selects
 *  use of shadow mask for that plane
 * OnOff flag: if using shadow mask to fill plane, this bit (corresponding
 *  to bit in planePick) describes whether to fill with 0's or 1's
 * There are two uses for these flags:
 *      - if this is the VSprite of a Bob, these flags describe how the Bob
 *        is to be drawn into memory
 *      - if this is a simple VSprite and the user intends on setting the
 *        @{"MUSTDRAW" LINK File 23} flag of the VSprite, these flags must be set too to describe
 *        which color registers the user wants for the image
 */
    @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58} PlanePick;
    @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58} PlaneOnOff;

    @{"VUserStuff" LINK File 56} VUserExt;      /* user definable:  see note above */
};


/* blitter-objects */struct Bob
{
/* --------------------- SYSTEM VARIABLES --------------------------------- */

/* --------------------- COMMON VARIABLES --------------------------------- */
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54} Flags; /* general purpose flags (see definitions below) */

/* --------------------- USER VARIABLES ----------------------------------- */
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54} *SaveBuffer;   /* pointer to the buffer for background save */

/* used by Bobs for "cookie-cutting" and multi-plane masking */
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54} *ImageShadow;

/* pointer to BOBs for sequenced drawing of Bobs
 *  for correct overlaying of multiple component animations
 */
    struct Bob *Before; /* draw this Bob before Bob pointed to by before */
    struct Bob *After;  /* draw this Bob after Bob pointed to by after */

    @{"struct VSprite" LINK File 72}   *BobVSprite;   /* this Bob's VSprite definition */

    @{"struct AnimComp" LINK File 168}  *BobComp;      /* pointer to this Bob's AnimComp def */

    @{"struct DBufPacket" LINK File 235} *DBuffer;     /* pointer to this Bob's dBuf packet */

    @{"BUserStuff" LINK File 60} BUserExt;            /* Bob user extension */
};

struct AnimComp
{
/* --------------------- SYSTEM VARIABLES --------------------------------- */

/* --------------------- COMMON VARIABLES --------------------------------- */
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54} Flags;             /* AnimComp flags for system & user */

/* timer defines how long to keep this component active:
 *  if set non-zero, timer decrements to zero then switches to nextSeq
 *  if set to zero, AnimComp never switches
 */
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54} Timer;

/* --------------------- USER VARIABLES ----------------------------------- */
/* initial value for timer when the AnimComp is activated by the system */
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54} TimeSet;

/* pointer to next and previous components of animation object */
    struct AnimComp  *NextComp;
    struct AnimComp  *PrevComp;

/* pointer to component component definition of next image in sequence */
    struct AnimComp  *NextSeq;
    struct AnimComp  *PrevSeq;

/* address of special animation procedure */
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54} (*AnimCRoutine) @{"__CLIB_PROTOTYPE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 117}((struct AnimComp *));

    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54} YTrans;     /* initial y translation (if this is a component) */
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54} XTrans;     /* initial x translation (if this is a component) */

    @{"struct AnimOb" LINK File 204}    *HeadOb;

    @{"struct Bob" LINK File 139}       *AnimBob;
};

struct AnimOb
{
/* --------------------- SYSTEM VARIABLES --------------------------------- */
    struct AnimOb    *NextOb, *PrevOb;

/* number of calls to Animate this AnimOb has endured */
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} Clock;

    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54} AnOldY, AnOldX;            /* old y,x coordinates */

/* --------------------- COMMON VARIABLES --------------------------------- */
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54} AnY, AnX;                  /* y,x coordinates of the AnimOb */

/* --------------------- USER VARIABLES ----------------------------------- */
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54} YVel, XVel;                /* velocities of this object */
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54} YAccel, XAccel;            /* accelerations of this object */

    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54} RingYTrans, RingXTrans;    /* ring translation values */

                                    /* address of special animation
                                       procedure */
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54} (*AnimORoutine) @{"__CLIB_PROTOTYPE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 117}((struct AnimOb *));

    @{"struct AnimComp" LINK File 168}  *HeadComp;     /* pointer to first component */

    @{"AUserStuff" LINK File 64} AUserExt;            /* AnimOb user extension */
};

/* dBufPacket defines the values needed to be saved across buffer to buffer
 *  when in double-buffer mode
 */
struct DBufPacket
{
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54} BufY, BufX;                /* save the other buffers screen coordinates */
    @{"struct VSprite" LINK File 72}   *BufPath;      /* carry the draw path over the gap */

/* these pointers must be filled in by the user */
/* pointer to other buffer's background save buffer */
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54} *BufBuffer;
};



/* ************************************************************************ */

/* these are GEL functions that are currently simple enough to exist as a
 *  definition.  It should not be assumed that this will always be the case
 */
#define InitAnimate(animKey) {*(animKey) = @{"NULL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 101};}
#define @{"RemBob" LINK "gg:doc/NDK/Guide/graphics/RemBob"}(b) {(b)->Flags |= @{"BOBSAWAY" LINK File 38};}


/* ************************************************************************ */

#define B2NORM      0
#define B2SWAP      1
#define B2BOBBER    2

/* ************************************************************************ */

/* a structure to contain the 16 collision procedure addresses */
struct collTable
{
    /* NOTE: This table actually consists of two different types of
     *       pointers. The first table entry is for collision testing,
     *       the other are for reporting collisions. The first function
     *       pointer looks like this:
     *
     *          @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} (*collPtrs[0])(@{"struct VSprite" LINK "gg:doc/NDK/Guide/Include/graphics/gels.h/File" 72} *,@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54});
     *
     *       The remaining 15 function pointers look like this:
     *
     *          @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} (*collPtrs[1..15])(@{"struct VSprite" LINK "gg:doc/NDK/Guide/Include/graphics/gels.h/File" 72} *,@{"struct VSprite" LINK "gg:doc/NDK/Guide/Include/graphics/gels.h/File" 72} *);
     */
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} (*collPtrs[16]) @{"__CLIB_PROTOTYPE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 117}((@{"struct VSprite" LINK File 72} *,struct VSprite *));
};

#endif  /* GRAPHICS_GELS_H */
@ENDNODE
