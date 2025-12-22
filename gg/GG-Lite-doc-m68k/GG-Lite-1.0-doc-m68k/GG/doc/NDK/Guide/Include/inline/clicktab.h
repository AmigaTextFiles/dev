@DATABASE "gg:doc/NDK/Guide/Include/inline/clicktab.h"
@MASTER   "gg:os-include/inline/clicktab.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:14:34
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "inline/clicktab.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"inline/clicktab.h" LINK File}


@{b}#defines@{ub}

@{"AllocClickTabNode()" LINK "gg:doc/NDK/Guide/Include/inline/clicktab.h/File" 32}      @{"AllocClickTabNodeA()" LINK "gg:doc/NDK/Guide/Include/inline/clicktab.h/File" 27}     @{"CLIB_CLICKTAB_PROTOS_H" LINK "gg:doc/NDK/Guide/Include/inline/clicktab.h/File" 5}
@{"CLICKTAB_BASE_NAME" LINK "gg:doc/NDK/Guide/Include/inline/clicktab.h/File" 20}       @{"CLICKTAB_GetClass()" LINK "gg:doc/NDK/Guide/Include/inline/clicktab.h/File" 23}      @{"FreeClickTabNode()" LINK "gg:doc/NDK/Guide/Include/inline/clicktab.h/File" 36}
@{"GetClickTabNodeAttrs()" LINK "gg:doc/NDK/Guide/Include/inline/clicktab.h/File" 54}   @{"GetClickTabNodeAttrsA()" LINK "gg:doc/NDK/Guide/Include/inline/clicktab.h/File" 49}  @{"SetClickTabNodeAttrs()" LINK "gg:doc/NDK/Guide/Include/inline/clicktab.h/File" 45}
@{"SetClickTabNodeAttrsA()" LINK "gg:doc/NDK/Guide/Include/inline/clicktab.h/File" 40}  

@ENDNODE
@NODE File "inline/clicktab.h"
#ifndef _INLINE_CLICKTAB_H
#define _INLINE_CLICKTAB_H

#ifndef CLIB_CLICKTAB_PROTOS_H
#define CLIB_CLICKTAB_PROTOS_H
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

#ifndef CLICKTAB_BASE_NAME
#define CLICKTAB_BASE_NAME ClickTabBase
#endif

#define @{"CLICKTAB_GetClass()" LINK "gg:doc/NDK/Guide/clicktab_gc/CLICKTAB_GetClass"} \\
        @{"LP0" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 25}(0x1e, @{"Class" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File" 36} *, @{"CLICKTAB_GetClass" LINK File 23}, \\
        , @{"CLICKTAB_BASE_NAME" LINK File 20})

#define @{"AllocClickTabNodeA" LINK "gg:doc/NDK/Guide/clicktab_gc/AllocClickTabNodeA"}(tags) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0x24, @{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} *, AllocClickTabNodeA, struct TagItem *, tags, a0, \\
        , CLICKTAB_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define @{"AllocClickTabNode" LINK "gg:doc/NDK/Guide/clicktab_gc/AllocClickTabNodeA"}(tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"AllocClickTabNodeA" LINK File 27}((@{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#define @{"FreeClickTabNode" LINK "gg:doc/NDK/Guide/clicktab_gc/FreeClickTabNode"}(node) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0x2a, @{"FreeClickTabNode" LINK File 36}, @{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} *, node, a0, \\
        , CLICKTAB_BASE_NAME)

#define @{"SetClickTabNodeAttrsA" LINK "gg:doc/NDK/Guide/clicktab_gc/SetClickTabNodeAttrsA"}(node, tags) \\
        @{"LP2NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 168}(0x30, @{"SetClickTabNodeAttrsA" LINK File 40}, @{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} *, node, a0, struct TagItem *, tags, a1, \\
        , CLICKTAB_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define @{"SetClickTabNodeAttrs" LINK "gg:doc/NDK/Guide/clicktab_gc/SetClickTabNodeAttrsA"}(node, tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"SetClickTabNodeAttrsA" LINK File 40}((node), (@{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#define @{"GetClickTabNodeAttrsA" LINK "gg:doc/NDK/Guide/clicktab_gc/GetClickTabNodeAttrsA"}(node, tags) \\
        @{"LP2NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 168}(0x36, @{"GetClickTabNodeAttrsA" LINK File 49}, @{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} *, node, a0, struct TagItem *, tags, a1, \\
        , CLICKTAB_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define @{"GetClickTabNodeAttrs" LINK "gg:doc/NDK/Guide/clicktab_gc/GetClickTabNodeAttrsA"}(node, tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"GetClickTabNodeAttrsA" LINK File 49}((node), (@{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#endif /*  _INLINE_CLICKTAB_H  */
@ENDNODE
