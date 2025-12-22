@DATABASE "gg:doc/NDK/Guide/Include/inline/virtual.h"
@MASTER   "gg:os-include/inline/virtual.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:15:48
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "inline/virtual.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"inline/virtual.h" LINK File}


@{b}#defines@{ub}

@{"CLIB_VIRTUAL_PROTOS_H" LINK "gg:doc/NDK/Guide/Include/inline/virtual.h/File" 5}  @{"RefreshVirtualGadget()" LINK "gg:doc/NDK/Guide/Include/inline/virtual.h/File" 33}  @{"RethinkVirtualSize()" LINK "gg:doc/NDK/Guide/Include/inline/virtual.h/File" 37}
@{"VIRTUAL_BASE_NAME" LINK "gg:doc/NDK/Guide/Include/inline/virtual.h/File" 26}      @{"VIRTUAL_GetClass()" LINK "gg:doc/NDK/Guide/Include/inline/virtual.h/File" 29}      

@ENDNODE
@NODE File "inline/virtual.h"
#ifndef _INLINE_VIRTUAL_H
#define _INLINE_VIRTUAL_H

#ifndef CLIB_VIRTUAL_PROTOS_H
#define CLIB_VIRTUAL_PROTOS_H
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
#ifndef  INTUITION_CLASSUSR_H
#include <@{"intuition/classusr.h" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File"}>
#endif
#ifndef  GADGETS_LAYOUT_H
#include <@{"gadgets/layout.h" LINK "gg:doc/NDK/Guide/Include/gadgets/layout.h/File"}>
#endif

#ifndef VIRTUAL_BASE_NAME
#define VIRTUAL_BASE_NAME VirtualBase
#endif

#define @{"VIRTUAL_GetClass()" LINK "gg:doc/NDK/Guide/virtual_gc/VIRTUAL_GetClass"} \\
        @{"LP0" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 25}(0x1e, @{"Class" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File" 36} *, @{"VIRTUAL_GetClass" LINK File 29}, \\
        , @{"VIRTUAL_BASE_NAME" LINK File 26})

#define @{"RefreshVirtualGadget" LINK "gg:doc/NDK/Guide/virtual_gc/RefreshVirtualGadget"}(gadget, obj, window, requester) \\
        @{"LP4NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 386}(0x24, @{"RefreshVirtualGadget" LINK File 33}, @{"struct Gadget" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 214} *, gadget, a0, Object *, obj, a1, struct Window *, window, a2, struct Requester *, requester, a3, \\
        , VIRTUAL_BASE_NAME)

#define @{"RethinkVirtualSize" LINK "gg:doc/NDK/Guide/virtual_gc/RethinkVirtualSize"}(virt_obj, rootlayout, font, screen, layoutlimits) \\
        @{"LP5" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 435}(0x2a, @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}, @{"RethinkVirtualSize" LINK File 37}, @{"Object" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 19} *, virt_obj, a0, @{"Object" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 19} *, rootlayout, a1, @{"struct TextFont" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 89} *, font, a2, struct Screen *, screen, a3, struct LayoutLimits *, layoutlimits, d0, \\
        , VIRTUAL_BASE_NAME)

#endif /*  _INLINE_VIRTUAL_H  */
@ENDNODE
