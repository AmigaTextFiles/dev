@DATABASE "gg:doc/NDK/Guide/Include/clib/popcycle_protos.h"
@MASTER   "gg:os-include/clib/popcycle_protos.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:11:56
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "clib/popcycle_protos.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"clib/popcycle_protos.h" LINK File}

@ENDNODE
@NODE File "clib/popcycle_protos.h"
#ifndef  CLIB_POPCYCLE_PROTOS_H
#define  CLIB_POPCYCLE_PROTOS_H

/*
**      $VER: popcycle_protos.h 1.1 (6.10.1999)
**
**      C prototypes. For use with 32 bit integers only.
**
**      Copyright © 2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

#ifndef  INTUITION_INTUITION_H
#include <@{"intuition/intuition.h" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File"}>
#endif
#ifndef  INTUITION_CLASSES_H
#include <@{"intuition/classes.h" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File"}>
#endif
@{"Class" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File" 36} *@{"POPCYCLE_GetClass" LINK "gg:doc/NDK/Guide/Include/inline/popcycle.h/File" 23}( @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} );
@{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} *AllocPopCycleNodeA( struct TagItem *tags );
@{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} *AllocPopCycleNode( Tag firstTag, ... );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"FreePopCycleNode" LINK "gg:doc/NDK/Guide/Include/inline/popcycle.h/File" 36}( @{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} *node );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"SetPopCycleNodeAttrsA" LINK "gg:doc/NDK/Guide/Include/inline/popcycle.h/File" 40}( @{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} *node, struct TagItem *tags );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"SetPopCycleNodeAttrs" LINK "gg:doc/NDK/Guide/Include/inline/popcycle.h/File" 45}( @{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} *node, ... );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"GetPopCycleNodeAttrsA" LINK "gg:doc/NDK/Guide/Include/inline/popcycle.h/File" 49}( @{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} *node, struct TagItem *tags );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"GetPopCycleNodeAttrs" LINK "gg:doc/NDK/Guide/Include/inline/popcycle.h/File" 54}( @{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} *node, ... );

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif   /* CLIB_POPCYCLE_PROTOS_H */
@ENDNODE
