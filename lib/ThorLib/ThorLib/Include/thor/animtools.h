/*************************************************************************
 ** THOR.lib                                                            **
 ** Version 1.00  6th December 1995     © 1995 THOR-Software inc        **
 **                                                                     **
 **---------------------------------------------------------------------**
 **                                                                     **
 ** Serviceprocedures for animation                                     **
 **                                                                     **
 *************************************************************************/

#ifndef ANIMTOOLS_H
#define ANIMTOOLS_H

#ifndef GRAPHICS_GFX_H
#include <graphics/gfx.h>
#endif
#ifndef GRAPHICS_RASTPORT_H
#include <graphics/rastport.h>
#endif
#ifndef GRAPHICS_COLLIDE_H
#include <graphics/collide.h>
#endif
#ifndef GRAPHICS_GELS_H
#include <graphics/gels.h>
#endif

/*
** These data structures are used by the functions in animtools.c to
** allow an easier interface to the animation system.
*/

/* Data structure to hold infomation for a new Object.
** type of object is either VSprite or Bob, depending on the flags-field */
typedef struct newOb {
        UWORD    *nob_Image;            /* image data for object        */
        UWORD    *nob_ColorSet;         /* color array for the vsprite  */
                                        /* not used for bobs            */
        UWORD   nob_Width;              /* width in pixels              */
        UWORD   nob_Height;             /* height in pixels             */
        UBYTE   nob_ImageDepth;         /* depth of the image           */
        UBYTE   nob_RasDepth;           /* depth of the raster          */
                                        /* only used for bobs           */
        WORD   nob_X;                  /* initial x position           */
        WORD   nob_Y;                  /* initial y position           */
        WORD   nob_Flags;              /* vsprite flags                */
        WORD   nob_ExtraFlags;         /* see below                    */
        UBYTE   nob_PlanePick;          /* planes that get image data   */
        UBYTE   nob_PlaneOnOff;         /* unused planes to turn on     */
                                        /* only used for bobs           */
        UWORD  nob_HitMask;            /* Hit mask.                    */
        UWORD  nob_MeMask;             /* Me mask.                     */
} NEWOB;

#define ISBOB   0x01
#define DBUF    0x02    

/* Data structure to hold information for a new animation component.    */
typedef struct newAnimComp {
        WORD    (*nac_Routine)();       /* routine called when Comp is displayed */
        WORD   nac_Xt;                 /* initial delta offset position. */
        WORD   nac_Yt;                 /* initial delta offset position. */
        WORD   nac_Time;               /* initial Timer value          */
        WORD   nac_CFlags;             /* Flags for the Component      */
} NEWANIMCOMP;

/* Data structure to hold information for a new animation sequence.     */
typedef struct newAnimSeq {
        struct AnimOb   *nas_HeadOb;    /* common Head of Object        */
        WORD    *nas_Image;             /* array of Comp image data     */
        WORD   *nas_Xt;                /* array of initial offsets.    */
        WORD   *nas_Yt;                /* array of initial offsets.    */
        WORD   *nas_Times;             /* array of initial Timer value */
        WORD    (**nas_Routines)();     /* array of fns called when comp drawn */
        WORD   nas_CFlags;             /* flags for the Component.     */
        WORD   nas_Count;              /* Num Comp in seq (= array size)*/
        WORD   nas_SingleImage;        /* one (or count) images        */
} NEWANIMSEQ;

/* Data structure to hold all initial gel-structures.                   */
typedef struct AllGels {
        struct GelsInfo ag_gInfo;       /* the GelsInfo                 */
        UWORD           ag_cludefill;   /* for LW alignment             */
        UWORD           ag_nextLine[8]; /* 8 words for nextline array   */
        UWORD           *ag_lastColor[8];/* 8 pointers for lastcolor array */
        struct collTable ag_collHandler;/* the collision routines       */
        struct VSprite  ag_vsHead;      /* the head of the gels list    */
        struct VSprite  ag_vsTail;      /* the tail of the gels list    */
} ALLGELS;

struct GelsInfo __regargs *setupGelSys(struct RastPort *rPort, BYTE reserved);
void            __regargs cleanupGelSys(struct GelsInfo *gInfo, struct RastPort *rPort);
struct VSprite  __regargs *makeVSprite(NEWOB *nob);
struct Bob      __regargs *makeBob(NEWOB *nob);
struct AnimComp __regargs *makeComp(NEWOB *nob, NEWANIMCOMP *nAnimComp);
struct AnimComp __regargs *makeSeq(NEWOB *nob, NEWANIMSEQ *nAnimSeq);
void            __regargs freeVSprite(struct VSprite *vsprite);
void            __regargs freeBob(struct Bob *bob,LONG rasdepth);
void            __regargs freeComp(struct AnimComp *myComp,LONG rasdepth);
void            __regargs freeSeq(struct AnimComp *headComp,LONG rasdepth);
void            __regargs freeOb(struct AnimOb *headOb, LONG rasdepth);

#endif
