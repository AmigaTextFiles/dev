@DATABASE "gg:doc/NDK/Guide/Include/graphics/gfxnodes.h"
@MASTER   "gg:os-include/graphics/gfxnodes.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:13:59
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "graphics/gfxnodes.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"graphics/gfxnodes.h" LINK File}


@{b}Structures@{ub}

@{"ExtendedNode" LINK "gg:doc/NDK/Guide/Include/graphics/gfxnodes.h/File" 17}


@{b}#defines@{ub}

@{"MONITOR_SPEC_TYPE" LINK "gg:doc/NDK/Guide/Include/graphics/gfxnodes.h/File" 34}    @{"SPECIAL_MONITOR_TYPE" LINK "gg:doc/NDK/Guide/Include/graphics/gfxnodes.h/File" 33}  @{"SS_GRAPHICS" LINK "gg:doc/NDK/Guide/Include/graphics/gfxnodes.h/File" 29}  @{"VIEW_EXTRA_TYPE" LINK "gg:doc/NDK/Guide/Include/graphics/gfxnodes.h/File" 31}
@{"VIEWPORT_EXTRA_TYPE" LINK "gg:doc/NDK/Guide/Include/graphics/gfxnodes.h/File" 32}  

@ENDNODE
@NODE File "graphics/gfxnodes.h"
#ifndef GRAPHICS_GFXNODES_H
#define GRAPHICS_GFXNODES_H
/*
**      $VER: gfxnodes.h 39.0 (21.8.1991)
**      Includes Release 45.1
**
**      graphics extended node definintions
**
**      (C) Copyright 1985-2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifndef EXEC_NODES_H
#include <@{"exec/nodes.h" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File"}>
#endif

struct  ExtendedNode    {
        @{"struct  Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22}    *xln_Succ;
        @{"struct  Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22}    *xln_Pred;
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   xln_Type;
        @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58}    xln_Pri;
        char    *xln_Name;
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   xln_Subsystem;
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   xln_Subtype;
        @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}    xln_Library;
        @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}    (*xln_Init)();
};

#define SS_GRAPHICS     0x02

#define VIEW_EXTRA_TYPE         1
#define VIEWPORT_EXTRA_TYPE     2
#define SPECIAL_MONITOR_TYPE    3
#define MONITOR_SPEC_TYPE       4

#endif  /* GRAPHICS_GFXNODES_H */
@ENDNODE
