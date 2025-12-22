@DATABASE "gg:doc/NDK/Guide/Include/graphics/layers.h"
@MASTER   "gg:os-include/graphics/layers.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:14:00
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "graphics/layers.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"graphics/layers.h" LINK File}


@{b}Structures@{ub}

@{"Layer_Info" LINK "gg:doc/NDK/Guide/Include/graphics/layers.h/File" 31}


@{b}#defines@{ub}

@{"LAYER_CLIPRECTS_LOST" LINK "gg:doc/NDK/Guide/Include/graphics/layers.h/File" 27}  @{"LAYERBACKDROP" LINK "gg:doc/NDK/Guide/Include/graphics/layers.h/File" 23}  @{"LAYERIREFRESH" LINK "gg:doc/NDK/Guide/Include/graphics/layers.h/File" 25}
@{"LAYERIREFRESH2" LINK "gg:doc/NDK/Guide/Include/graphics/layers.h/File" 26}        @{"LAYERREFRESH" LINK "gg:doc/NDK/Guide/Include/graphics/layers.h/File" 24}   @{"LAYERS_BACKFILL" LINK "gg:doc/NDK/Guide/Include/graphics/layers.h/File" 58}
@{"LAYERS_NOBACKFILL" LINK "gg:doc/NDK/Guide/Include/graphics/layers.h/File" 57}     @{"LAYERSIMPLE" LINK "gg:doc/NDK/Guide/Include/graphics/layers.h/File" 19}    @{"LAYERSMART" LINK "gg:doc/NDK/Guide/Include/graphics/layers.h/File" 20}
@{"LAYERSUPER" LINK "gg:doc/NDK/Guide/Include/graphics/layers.h/File" 21}            @{"LAYERUPDATING" LINK "gg:doc/NDK/Guide/Include/graphics/layers.h/File" 22}  @{"NEWLAYERINFO_CALLED" LINK "gg:doc/NDK/Guide/Include/graphics/layers.h/File" 51}

@ENDNODE
@NODE File "graphics/layers.h"
#ifndef GRAPHICS_LAYERS_H
#define GRAPHICS_LAYERS_H
/*
**      $VER: layers.h 39.4 (14.4.1992)
**      Includes Release 45.1
**
**      (C) Copyright 1985-2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifndef EXEC_LISTS_H
#include <@{"exec/lists.h" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File"}>
#endif

#ifndef EXEC_SEMAPHORES_H
#include <@{"exec/semaphores.h" LINK "gg:doc/NDK/Guide/Include/exec/semaphores.h/File"}>
#endif

#define LAYERSIMPLE             1
#define LAYERSMART              2
#define LAYERSUPER              4
#define LAYERUPDATING           0x10
#define LAYERBACKDROP           0x40
#define LAYERREFRESH            0x80
#define LAYERIREFRESH           0x200
#define LAYERIREFRESH2          0x400
#define LAYER_CLIPRECTS_LOST    0x100   /* during @{"BeginUpdate" LINK "gg:doc/NDK/Guide/layers/BeginUpdate"} */
                                        /* or during layerop */
                                        /* this happens if out of memory */

struct Layer_Info
{
        @{"struct  Layer" LINK "gg:doc/NDK/Guide/Include/graphics/clip.h/File" 27}           *top_layer;
        @{"struct  Layer" LINK "gg:doc/NDK/Guide/Include/graphics/clip.h/File" 27}           *check_lp;              /* !! Private !! */
        @{"struct  ClipRect" LINK "gg:doc/NDK/Guide/Include/graphics/clip.h/File" 57}        *obs;
        @{"struct  ClipRect" LINK "gg:doc/NDK/Guide/Include/graphics/clip.h/File" 57}        *FreeClipRects;         /* !! Private !! */
                @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}            PrivateReserve1;        /* !! Private !! */
                @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}            PrivateReserve2;        /* !! Private !! */
        @{"struct  SignalSemaphore" LINK "gg:doc/NDK/Guide/Include/exec/semaphores.h/File" 40} Lock;                   /* !! Private !! */
        @{"struct  MinList" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 31}         gs_Head;                /* !! Private !! */
                @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}            PrivateReserve3;        /* !! Private !! */
                @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24}            *PrivateReserve4;       /* !! Private !! */
                @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}           Flags;
                @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58}            fatten_count;           /* !! Private !! */
                @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58}            LockLayersCount;        /* !! Private !! */
                @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}            PrivateReserve5;        /* !! Private !! */
                @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24}            *BlankHook;             /* !! Private !! */
                @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24}            *LayerInfo_extra;       /* !! Private !! */
};

#define NEWLAYERINFO_CALLED 1

/*
 * @{"LAYERS_NOBACKFILL" LINK File 57} is the value needed to get no backfill hook
 * @{"LAYERS_BACKFILL" LINK File 58} is the value needed to get the default backfill hook
 */
#define LAYERS_NOBACKFILL       ((@{"struct Hook" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File" 28} *)1)
#define LAYERS_BACKFILL         ((@{"struct Hook" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File" 28} *)0)

#endif  /* GRAPHICS_LAYERS_H */
@ENDNODE
