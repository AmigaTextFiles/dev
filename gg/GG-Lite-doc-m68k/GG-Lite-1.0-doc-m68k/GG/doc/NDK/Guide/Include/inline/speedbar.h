@DATABASE "gg:doc/NDK/Guide/Include/inline/speedbar.h"
@MASTER   "gg:os-include/inline/speedbar.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:15:43
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "inline/speedbar.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"inline/speedbar.h" LINK File}


@{b}#defines@{ub}

@{"AllocSpeedButtonNode()" LINK "gg:doc/NDK/Guide/Include/inline/speedbar.h/File" 32}     @{"AllocSpeedButtonNodeA()" LINK "gg:doc/NDK/Guide/Include/inline/speedbar.h/File" 27}
@{"CLIB_SPEEDBAR_PROTOS_H" LINK "gg:doc/NDK/Guide/Include/inline/speedbar.h/File" 5}     @{"FreeSpeedButtonNode()" LINK "gg:doc/NDK/Guide/Include/inline/speedbar.h/File" 36}
@{"GetSpeedButtonNodeAttrs()" LINK "gg:doc/NDK/Guide/Include/inline/speedbar.h/File" 54}  @{"GetSpeedButtonNodeAttrsA()" LINK "gg:doc/NDK/Guide/Include/inline/speedbar.h/File" 49}
@{"SetSpeedButtonNodeAttrs()" LINK "gg:doc/NDK/Guide/Include/inline/speedbar.h/File" 45}  @{"SetSpeedButtonNodeAttrsA()" LINK "gg:doc/NDK/Guide/Include/inline/speedbar.h/File" 40}
@{"SPEEDBAR_BASE_NAME" LINK "gg:doc/NDK/Guide/Include/inline/speedbar.h/File" 20}         @{"SPEEDBAR_GetClass()" LINK "gg:doc/NDK/Guide/Include/inline/speedbar.h/File" 23}

@ENDNODE
@NODE File "inline/speedbar.h"
#ifndef _INLINE_SPEEDBAR_H
#define _INLINE_SPEEDBAR_H

#ifndef CLIB_SPEEDBAR_PROTOS_H
#define CLIB_SPEEDBAR_PROTOS_H
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

#ifndef SPEEDBAR_BASE_NAME
#define SPEEDBAR_BASE_NAME SpeedBarBase
#endif

#define @{"SPEEDBAR_GetClass()" LINK "gg:doc/NDK/Guide/speedbar_gc/SPEEDBAR_GetClass"} \\
        @{"LP0" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 25}(0x1e, @{"Class" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File" 36} *, @{"SPEEDBAR_GetClass" LINK File 23}, \\
        , @{"SPEEDBAR_BASE_NAME" LINK File 20})

#define @{"AllocSpeedButtonNodeA" LINK "gg:doc/NDK/Guide/speedbar_gc/AllocSpeedButtonNodeA"}(number, tags) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x24, @{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} *, AllocSpeedButtonNodeA, ULONG, number, d0, struct TagItem *, tags, a0, \\
        , SPEEDBAR_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define @{"AllocSpeedButtonNode" LINK "gg:doc/NDK/Guide/speedbar_gc/AllocSpeedButtonNodeA"}(number, tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"AllocSpeedButtonNodeA" LINK File 27}((number), (@{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#define @{"FreeSpeedButtonNode" LINK "gg:doc/NDK/Guide/speedbar_gc/FreeSpeedButtonNode"}(node) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0x2a, @{"FreeSpeedButtonNode" LINK File 36}, @{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} *, node, a0, \\
        , SPEEDBAR_BASE_NAME)

#define @{"SetSpeedButtonNodeAttrsA" LINK "gg:doc/NDK/Guide/speedbar_gc/SetSpeedButtonNodeAttrsA"}(node, tags) \\
        @{"LP2NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 168}(0x30, @{"SetSpeedButtonNodeAttrsA" LINK File 40}, @{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} *, node, a0, struct TagItem *, tags, a1, \\
        , SPEEDBAR_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define @{"SetSpeedButtonNodeAttrs" LINK "gg:doc/NDK/Guide/speedbar_gc/SetSpeedButtonNodeAttrsA"}(node, tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"SetSpeedButtonNodeAttrsA" LINK File 40}((node), (@{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#define @{"GetSpeedButtonNodeAttrsA" LINK "gg:doc/NDK/Guide/speedbar_gc/GetSpeedButtonNodeAttrsA"}(node, tags) \\
        @{"LP2NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 168}(0x36, @{"GetSpeedButtonNodeAttrsA" LINK File 49}, @{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} *, node, a0, struct TagItem *, tags, a1, \\
        , SPEEDBAR_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define @{"GetSpeedButtonNodeAttrs" LINK "gg:doc/NDK/Guide/speedbar_gc/GetSpeedButtonNodeAttrsA"}(node, tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"GetSpeedButtonNodeAttrsA" LINK File 49}((node), (@{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#endif /*  _INLINE_SPEEDBAR_H  */
@ENDNODE
