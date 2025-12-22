@DATABASE "gg:doc/NDK/Guide/Include/graphics/clip.h"
@MASTER   "gg:os-include/graphics/clip.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:13:50
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "graphics/clip.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"graphics/clip.h" LINK File}


@{b}Structures@{ub}

@{"ClipRect" LINK "gg:doc/NDK/Guide/Include/graphics/clip.h/File" 57}  @{"Layer" LINK "gg:doc/NDK/Guide/Include/graphics/clip.h/File" 27}


@{b}#defines@{ub}

@{"CR_NEEDS_NO_CONCEALED_RASTERS" LINK "gg:doc/NDK/Guide/Include/graphics/clip.h/File" 74}  @{"CR_NEEDS_NO_LAYERBLIT_DAMAGE" LINK "gg:doc/NDK/Guide/Include/graphics/clip.h/File" 75}  @{"ISGRTRX" LINK "gg:doc/NDK/Guide/Include/graphics/clip.h/File" 80}
@{"ISGRTRY" LINK "gg:doc/NDK/Guide/Include/graphics/clip.h/File" 81}                        @{"ISLESSX" LINK "gg:doc/NDK/Guide/Include/graphics/clip.h/File" 78}                       @{"ISLESSY" LINK "gg:doc/NDK/Guide/Include/graphics/clip.h/File" 79}
@{"NEWLOCKS" LINK "gg:doc/NDK/Guide/Include/graphics/clip.h/File" 25}                       

@ENDNODE
@NODE File "graphics/clip.h"
#ifndef GRAPHICS_CLIP_H
#define GRAPHICS_CLIP_H
/*
**      $VER: clip.h 39.0 (2.12.1991)
**      Includes Release 45.1
**
**      (C) Copyright 1985-2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif

#ifndef GRAPHICS_GFX_H
#include <@{"graphics/gfx.h" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File"}>
#endif
#ifndef EXEC_SEMAPHORES_H
#include <@{"exec/semaphores.h" LINK "gg:doc/NDK/Guide/Include/exec/semaphores.h/File"}>
#endif
#ifndef UTILITY_HOOKS_H
#include <@{"utility/hooks.h" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File"}>
#endif

#define NEWLOCKS

struct Layer
{
    struct  Layer *front,*back;
    @{"struct  ClipRect" LINK File 57}    *ClipRect;  /* read by roms to find first cliprect */
    @{"struct  RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52}    *rp;
    @{"struct  Rectangle" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 27}   bounds;
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   reserved[4];
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   priority;               /* system use only */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   Flags;                  /* obscured ?, Virtual BitMap? */
    @{"struct  BitMap" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 46} *SuperBitMap;
    @{"struct  ClipRect" LINK File 57} *SuperClipRect; /* super bitmap cliprects if VBitMap != 0*/
                                  /* else damage cliprect list for refresh */
    @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}    Window;               /* reserved for user interface use */
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}    Scroll_X,Scroll_Y;
    @{"struct  ClipRect" LINK File 57} *cr,*cr2,*crnew;   /* used by dedice */
    @{"struct  ClipRect" LINK File 57} *SuperSaveClipRects; /* preallocated cr's */
    @{"struct  ClipRect" LINK File 57} *_cliprects;       /* system use during refresh */
    @{"struct  Layer_Info" LINK "gg:doc/NDK/Guide/Include/graphics/layers.h/File" 31}  *LayerInfo;     /* points to head of the list */
    @{"struct  SignalSemaphore" LINK "gg:doc/NDK/Guide/Include/exec/semaphores.h/File" 40} Lock;
    @{"struct  Hook" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File" 28} *BackFill;
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   reserved1;
    @{"struct  Region" LINK "gg:doc/NDK/Guide/Include/graphics/regions.h/File" 25} *ClipRegion;
    @{"struct  Region" LINK "gg:doc/NDK/Guide/Include/graphics/regions.h/File" 25} *saveClipRects;      /* used to back out when in trouble*/
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}    Width,Height;               /* system use */
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   reserved2[18];
    /* this must stay here */
    @{"struct  Region" LINK "gg:doc/NDK/Guide/Include/graphics/regions.h/File" 25}  *DamageList;    /* list of rectangles to refresh
                                       through */
};

struct ClipRect
{
    struct  ClipRect *Next;         /* roms used to find next ClipRect */
    struct  ClipRect *prev;         /* Temp use in layers (private) */
    @{"struct  Layer" LINK File 27}   *lobs;          /* Private use for layers */
    @{"struct  BitMap" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 46}  *BitMap;        /* Bitmap for layers private use */
    @{"struct  Rectangle" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 27}   bounds;     /* bounds of cliprect */
    void    *_p1;                   /* Layers private use!!! */
    void    *_p2;                   /* Layers private use!!! */
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}    reserved;               /* system use (Layers private) */
#ifdef NEWCLIPRECTS_1_1
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}    Flags;                  /* Layers private field for cliprects */
                                    /* that layers allocates... */
#endif                              /* MUST be multiple of 8 bytes to buffer */
};

/* internal cliprect flags */
#define CR_NEEDS_NO_CONCEALED_RASTERS  1
#define CR_NEEDS_NO_LAYERBLIT_DAMAGE   2

/* defines for code values for getcode */
#define ISLESSX 1
#define ISLESSY 2
#define ISGRTRX 4
#define ISGRTRY 8

#endif  /* GRAPHICS_CLIP_H */
@ENDNODE
