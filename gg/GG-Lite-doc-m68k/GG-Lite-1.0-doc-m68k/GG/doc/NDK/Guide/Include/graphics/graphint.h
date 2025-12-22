@DATABASE "gg:doc/NDK/Guide/Include/graphics/graphint.h"
@MASTER   "gg:os-include/graphics/graphint.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:14:00
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "graphics/graphint.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"graphics/graphint.h" LINK File}


@{b}Structures@{ub}

@{"Isrvstr" LINK "gg:doc/NDK/Guide/Include/graphics/graphint.h/File" 16}

@ENDNODE
@NODE File "graphics/graphint.h"
#ifndef GRAPHICS_GRAPHINT_H
#define GRAPHICS_GRAPHINT_H
/*
**      $VER: graphint.h 39.0 (23.9.1991)
**      Includes Release 45.1
**
**      (C) Copyright 1985-2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifndef EXEC_NODES_H
#include <@{"exec/nodes.h" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File"}>
#endif

/* structure used by AddTOFTask */
struct Isrvstr
{
    @{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} is_Node;
    struct Isrvstr *Iptr;   /* passed to srvr by os */
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} (*code)();
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} (*ccode) @{"__CLIB_PROTOTYPE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 117}((@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}));
    @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} Carg;
};

#endif  /* GRAPHICS_GRAPHINT_H */
@ENDNODE
