@DATABASE "gg:doc/NDK/Guide/Include/inline/popcycle.h"
@MASTER   "gg:os-include/inline/popcycle.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:15:34
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "inline/popcycle.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"inline/popcycle.h" LINK File}


@{b}#defines@{ub}

@{"AllocPopCycleNode()" LINK "gg:doc/NDK/Guide/Include/inline/popcycle.h/File" 32}      @{"AllocPopCycleNodeA()" LINK "gg:doc/NDK/Guide/Include/inline/popcycle.h/File" 27}    @{"CLIB_POPCYCLE_PROTOS_H" LINK "gg:doc/NDK/Guide/Include/inline/popcycle.h/File" 5}
@{"FreePopCycleNode()" LINK "gg:doc/NDK/Guide/Include/inline/popcycle.h/File" 36}       @{"GetPopCycleNodeAttrs()" LINK "gg:doc/NDK/Guide/Include/inline/popcycle.h/File" 54}  @{"GetPopCycleNodeAttrsA()" LINK "gg:doc/NDK/Guide/Include/inline/popcycle.h/File" 49}
@{"POPCYCLE_BASE_NAME" LINK "gg:doc/NDK/Guide/Include/inline/popcycle.h/File" 20}       @{"POPCYCLE_GetClass()" LINK "gg:doc/NDK/Guide/Include/inline/popcycle.h/File" 23}     @{"SetPopCycleNodeAttrs()" LINK "gg:doc/NDK/Guide/Include/inline/popcycle.h/File" 45}
@{"SetPopCycleNodeAttrsA()" LINK "gg:doc/NDK/Guide/Include/inline/popcycle.h/File" 40}  

@ENDNODE
@NODE File "inline/popcycle.h"
#ifndef _INLINE_POPCYCLE_H
#define _INLINE_POPCYCLE_H

#ifndef CLIB_POPCYCLE_PROTOS_H
#define CLIB_POPCYCLE_PROTOS_H
#endif

#ifndef __INLINE_MACROS_H
#include <@{"inline/macros.h" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File"}>
#endif

#ifndef  INTUITION_INTUITION_H
#include <@{"intuition/intuition.h" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File"}>
#endif
#ifndef  INTUITION_CLASSES_H
#include <@{"intuition/classes.h" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File"}>
#endif

#ifndef POPCYCLE_BASE_NAME
#define POPCYCLE_BASE_NAME PopCycleBase
#endif

#define POPCYCLE_GetClass() \\
        @{"LP0" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 25}(0x1e, @{"Class" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File" 36} *, @{"POPCYCLE_GetClass" LINK File 23}, \\
        , @{"POPCYCLE_BASE_NAME" LINK File 20})

#define AllocPopCycleNodeA(tags) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0x24, @{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} *, AllocPopCycleNodeA, struct TagItem *, tags, a0, \\
        , POPCYCLE_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define AllocPopCycleNode(tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"AllocPopCycleNodeA" LINK File 27}((@{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#define FreePopCycleNode(node) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0x2a, @{"FreePopCycleNode" LINK File 36}, @{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} *, node, a0, \\
        , POPCYCLE_BASE_NAME)

#define SetPopCycleNodeAttrsA(node, tags) \\
        @{"LP2NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 168}(0x30, @{"SetPopCycleNodeAttrsA" LINK File 40}, @{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} *, node, a0, struct TagItem *, tags, a1, \\
        , POPCYCLE_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define SetPopCycleNodeAttrs(node, tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"SetPopCycleNodeAttrsA" LINK File 40}((node), (@{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#define GetPopCycleNodeAttrsA(node, tags) \\
        @{"LP2NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 168}(0x36, @{"GetPopCycleNodeAttrsA" LINK File 49}, @{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} *, node, a0, struct TagItem *, tags, a1, \\
        , POPCYCLE_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define GetPopCycleNodeAttrs(node, tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"GetPopCycleNodeAttrsA" LINK File 49}((node), (@{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#endif /*  _INLINE_POPCYCLE_H  */
@ENDNODE
