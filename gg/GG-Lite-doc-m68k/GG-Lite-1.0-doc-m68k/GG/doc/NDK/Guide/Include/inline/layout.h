@DATABASE "gg:doc/NDK/Guide/Include/inline/layout.h"
@MASTER   "gg:os-include/inline/layout.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:15:11
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "inline/layout.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"inline/layout.h" LINK File}


@{b}#defines@{ub}

@{"ActivateLayoutGadget()" LINK "gg:doc/NDK/Guide/Include/inline/layout.h/File" 30}  @{"CLIB_LAYOUT_PROTOS_H" LINK "gg:doc/NDK/Guide/Include/inline/layout.h/File" 5}   @{"FlushLayoutDomainCache()" LINK "gg:doc/NDK/Guide/Include/inline/layout.h/File" 34}
@{"LAYOUT_BASE_NAME" LINK "gg:doc/NDK/Guide/Include/inline/layout.h/File" 23}        @{"LAYOUT_GetClass()" LINK "gg:doc/NDK/Guide/Include/inline/layout.h/File" 26}      @{"LayoutLimits()" LINK "gg:doc/NDK/Guide/Include/inline/layout.h/File" 42}
@{"PAGE_GetClass()" LINK "gg:doc/NDK/Guide/Include/inline/layout.h/File" 46}         @{"RefreshPageGadget()" LINK "gg:doc/NDK/Guide/Include/inline/layout.h/File" 59}    @{"RethinkLayout()" LINK "gg:doc/NDK/Guide/Include/inline/layout.h/File" 38}
@{"SetPageGadgetAttrs()" LINK "gg:doc/NDK/Guide/Include/inline/layout.h/File" 55}    @{"SetPageGadgetAttrsA()" LINK "gg:doc/NDK/Guide/Include/inline/layout.h/File" 50}  

@ENDNODE
@NODE File "inline/layout.h"
#ifndef _INLINE_LAYOUT_H
#define _INLINE_LAYOUT_H

#ifndef CLIB_LAYOUT_PROTOS_H
#define CLIB_LAYOUT_PROTOS_H
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
#ifndef  GADGETS_LAYOUT_H
#include <@{"gadgets/layout.h" LINK "gg:doc/NDK/Guide/Include/gadgets/layout.h/File"}>
#endif

#ifndef LAYOUT_BASE_NAME
#define LAYOUT_BASE_NAME LayoutBase
#endif

#define @{"LAYOUT_GetClass()" LINK "gg:doc/NDK/Guide/layout_gc/LAYOUT_GetClass"} \\
        @{"LP0" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 25}(0x1e, @{"Class" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File" 36} *, @{"LAYOUT_GetClass" LINK File 26}, \\
        , @{"LAYOUT_BASE_NAME" LINK File 23})

#define @{"ActivateLayoutGadget" LINK "gg:doc/NDK/Guide/layout_gc/ActivateLayoutGadget"}(gadget, window, requester, object) \\
        @{"LP4" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 362}(0x24, @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}, @{"ActivateLayoutGadget" LINK File 30}, @{"struct Gadget" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 214} *, gadget, a0, struct Window *, window, a1, struct Requester *, requester, a2, ULONG, object, d0, \\
        , LAYOUT_BASE_NAME)

#define @{"FlushLayoutDomainCache" LINK "gg:doc/NDK/Guide/layout_gc/FlushLayoutDomainCache"}(gadget) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0x2a, @{"FlushLayoutDomainCache" LINK File 34}, @{"struct Gadget" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 214} *, gadget, a0, \\
        , LAYOUT_BASE_NAME)

#define @{"RethinkLayout" LINK "gg:doc/NDK/Guide/layout_gc/RethinkLayout"}(gadget, window, requester, refresh) \\
        @{"LP4" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 362}(0x30, @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}, @{"RethinkLayout" LINK File 38}, @{"struct Gadget" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 214} *, gadget, a0, struct Window *, window, a1, struct Requester *, requester, a2, LONG, refresh, d0, \\
        , LAYOUT_BASE_NAME)

#define @{"LayoutLimits" LINK "gg:doc/NDK/Guide/layout_gc/LayoutLimits"}(gadget, limits, font, screen) \\
        @{"LP4NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 386}(0x36, @{"LayoutLimits" LINK File 42}, @{"struct Gadget" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 214} *, gadget, a0, struct LayoutLimits *, limits, a1, struct TextFont *, font, a2, struct Screen *, screen, a3, \\
        , LAYOUT_BASE_NAME)

#define @{"PAGE_GetClass()" LINK "gg:doc/NDK/Guide/page_gc/PAGE_GetClass"} \\
        @{"LP0" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 25}(0x3c, @{"Class" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File" 36} *, @{"PAGE_GetClass" LINK File 46}, \\
        , @{"LAYOUT_BASE_NAME" LINK File 23})

#define @{"SetPageGadgetAttrsA" LINK "gg:doc/NDK/Guide/page_gc/SetPageGadgetAttrsA"}(gadget, object, window, requester, tags) \\
        @{"LP5A4" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 515}(0x42, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, @{"SetPageGadgetAttrsA" LINK File 50}, @{"struct Gadget" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 214} *, gadget, a0, Object *, object, a1, struct Window *, window, a2, struct Requester *, requester, a3, struct TagItem *, tags, d7, \\
        , LAYOUT_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define @{"SetPageGadgetAttrs" LINK "gg:doc/NDK/Guide/page_gc/SetPageGadgetAttrsA"}(gadget, object, window, requester, tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"SetPageGadgetAttrsA" LINK File 50}((gadget), (object), (window), (requester), (@{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#define @{"RefreshPageGadget" LINK "gg:doc/NDK/Guide/page_gc/RefreshPageGadget"}(gadget, object, window, requester) \\
        @{"LP4NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 386}(0x48, @{"RefreshPageGadget" LINK File 59}, @{"struct Gadget" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 214} *, gadget, a0, Object *, object, a1, struct Window *, window, a2, struct Requester *, requester, a3, \\
        , LAYOUT_BASE_NAME)

#endif /*  _INLINE_LAYOUT_H  */
@ENDNODE
