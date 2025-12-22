@DATABASE "gg:doc/NDK/Guide/Include/inline/gadtools.h"
@MASTER   "gg:os-include/inline/gadtools.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:14:52
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "inline/gadtools.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"inline/gadtools.h" LINK File}


@{b}#defines@{ub}

@{"CLIB_GADTOOLS_PROTOS_H" LINK "gg:doc/NDK/Guide/Include/inline/gadtools.h/File" 5}  @{"CreateContext()" LINK "gg:doc/NDK/Guide/Include/inline/gadtools.h/File" 110}    @{"CreateGadget()" LINK "gg:doc/NDK/Guide/Include/inline/gadtools.h/File" 34}
@{"CreateGadgetA()" LINK "gg:doc/NDK/Guide/Include/inline/gadtools.h/File" 29}         @{"CreateMenus()" LINK "gg:doc/NDK/Guide/Include/inline/gadtools.h/File" 56}      @{"CreateMenusA()" LINK "gg:doc/NDK/Guide/Include/inline/gadtools.h/File" 51}
@{"DrawBevelBox()" LINK "gg:doc/NDK/Guide/Include/inline/gadtools.h/File" 119}          @{"DrawBevelBoxA()" LINK "gg:doc/NDK/Guide/Include/inline/gadtools.h/File" 114}    @{"FreeGadgets()" LINK "gg:doc/NDK/Guide/Include/inline/gadtools.h/File" 38}
@{"FreeMenus()" LINK "gg:doc/NDK/Guide/Include/inline/gadtools.h/File" 60}             @{"FreeVisualInfo()" LINK "gg:doc/NDK/Guide/Include/inline/gadtools.h/File" 132}   @{"GADTOOLS_BASE_NAME" LINK "gg:doc/NDK/Guide/Include/inline/gadtools.h/File" 26}
@{"GetVisualInfo()" LINK "gg:doc/NDK/Guide/Include/inline/gadtools.h/File" 128}         @{"GetVisualInfoA()" LINK "gg:doc/NDK/Guide/Include/inline/gadtools.h/File" 123}   @{"GT_BeginRefresh()" LINK "gg:doc/NDK/Guide/Include/inline/gadtools.h/File" 94}
@{"GT_EndRefresh()" LINK "gg:doc/NDK/Guide/Include/inline/gadtools.h/File" 98}         @{"GT_FilterIMsg()" LINK "gg:doc/NDK/Guide/Include/inline/gadtools.h/File" 102}    @{"GT_GetGadgetAttrs()" LINK "gg:doc/NDK/Guide/Include/inline/gadtools.h/File" 141}
@{"GT_GetGadgetAttrsA()" LINK "gg:doc/NDK/Guide/Include/inline/gadtools.h/File" 136}    @{"GT_GetIMsg()" LINK "gg:doc/NDK/Guide/Include/inline/gadtools.h/File" 82}       @{"GT_PostFilterIMsg()" LINK "gg:doc/NDK/Guide/Include/inline/gadtools.h/File" 106}
@{"GT_RefreshWindow()" LINK "gg:doc/NDK/Guide/Include/inline/gadtools.h/File" 90}      @{"GT_ReplyIMsg()" LINK "gg:doc/NDK/Guide/Include/inline/gadtools.h/File" 86}     @{"GT_SetGadgetAttrs()" LINK "gg:doc/NDK/Guide/Include/inline/gadtools.h/File" 47}
@{"GT_SetGadgetAttrsA()" LINK "gg:doc/NDK/Guide/Include/inline/gadtools.h/File" 42}    @{"LayoutMenuItems()" LINK "gg:doc/NDK/Guide/Include/inline/gadtools.h/File" 69}  @{"LayoutMenuItemsA()" LINK "gg:doc/NDK/Guide/Include/inline/gadtools.h/File" 64}
@{"LayoutMenus()" LINK "gg:doc/NDK/Guide/Include/inline/gadtools.h/File" 78}           @{"LayoutMenusA()" LINK "gg:doc/NDK/Guide/Include/inline/gadtools.h/File" 73}     

@ENDNODE
@NODE File "inline/gadtools.h"
#ifndef _INLINE_GADTOOLS_H
#define _INLINE_GADTOOLS_H

#ifndef CLIB_GADTOOLS_PROTOS_H
#define CLIB_GADTOOLS_PROTOS_H
#endif

#ifndef __INLINE_MACROS_H
#include <@{"inline/macros.h" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File"}>
#endif

#ifndef  EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#ifndef  INTUITION_INTUITION_H
#include <@{"intuition/intuition.h" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File"}>
#endif
#ifndef  UTILITY_TAGITEM_H
#include <@{"utility/tagitem.h" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File"}>
#endif
#ifndef  LIBRARIES_GADTOOLS_H
#include <@{"libraries/gadtools.h" LINK "gg:doc/NDK/Guide/Include/libraries/gadtools.h/File"}>
#endif

#ifndef GADTOOLS_BASE_NAME
#define GADTOOLS_BASE_NAME GadToolsBase
#endif

#define @{"CreateGadgetA" LINK "gg:doc/NDK/Guide/gadtools/CreateGadgetA"}(kind, gad, ng, taglist) \\
        @{"LP4" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 362}(0x1e, @{"struct Gadget" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 214} *, CreateGadgetA, ULONG, kind, d0, struct Gadget *, gad, a0, const struct NewGadget *, ng, a1, const struct TagItem *, taglist, a2, \\
        , GADTOOLS_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define @{"CreateGadget" LINK "gg:doc/NDK/Guide/gadtools/CreateGadgetA"}(kind, gad, ng, tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"CreateGadgetA" LINK File 29}((kind), (gad), (ng), (const @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#define @{"FreeGadgets" LINK "gg:doc/NDK/Guide/gadtools/FreeGadgets"}(gad) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0x24, @{"FreeGadgets" LINK File 38}, @{"struct Gadget" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 214} *, gad, a0, \\
        , GADTOOLS_BASE_NAME)

#define @{"GT_SetGadgetAttrsA" LINK "gg:doc/NDK/Guide/gadtools/GT_SetGadgetAttrsA"}(gad, win, req, taglist) \\
        @{"LP4NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 386}(0x2a, @{"GT_SetGadgetAttrsA" LINK File 42}, @{"struct Gadget" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 214} *, gad, a0, struct Window *, win, a1, struct Requester *, req, a2, const struct TagItem *, taglist, a3, \\
        , GADTOOLS_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define @{"GT_SetGadgetAttrs" LINK "gg:doc/NDK/Guide/gadtools/GT_SetGadgetAttrsA"}(gad, win, req, tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"GT_SetGadgetAttrsA" LINK File 42}((gad), (win), (req), (const @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#define @{"CreateMenusA" LINK "gg:doc/NDK/Guide/gadtools/CreateMenusA"}(newmenu, taglist) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x30, @{"struct Menu" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 60} *, CreateMenusA, const struct NewMenu *, newmenu, a0, const struct TagItem *, taglist, a1, \\
        , GADTOOLS_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define @{"CreateMenus" LINK "gg:doc/NDK/Guide/gadtools/CreateMenusA"}(newmenu, tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"CreateMenusA" LINK File 51}((newmenu), (const @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#define @{"FreeMenus" LINK "gg:doc/NDK/Guide/gadtools/FreeMenus"}(menu) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0x36, @{"FreeMenus" LINK File 60}, @{"struct Menu" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 60} *, menu, a0, \\
        , GADTOOLS_BASE_NAME)

#define @{"LayoutMenuItemsA" LINK "gg:doc/NDK/Guide/gadtools/LayoutMenuItemsA"}(firstitem, vi, taglist) \\
        @{"LP3" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 229}(0x3c, @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}, @{"LayoutMenuItemsA" LINK File 64}, @{"struct MenuItem" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 88} *, firstitem, a0, APTR, vi, a1, const struct TagItem *, taglist, a2, \\
        , GADTOOLS_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define @{"LayoutMenuItems" LINK "gg:doc/NDK/Guide/gadtools/LayoutMenuItemsA"}(firstitem, vi, tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"LayoutMenuItemsA" LINK File 64}((firstitem), (vi), (const @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#define @{"LayoutMenusA" LINK "gg:doc/NDK/Guide/gadtools/LayoutMenusA"}(firstmenu, vi, taglist) \\
        @{"LP3" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 229}(0x42, @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}, @{"LayoutMenusA" LINK File 73}, @{"struct Menu" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 60} *, firstmenu, a0, APTR, vi, a1, const struct TagItem *, taglist, a2, \\
        , GADTOOLS_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define @{"LayoutMenus" LINK "gg:doc/NDK/Guide/gadtools/LayoutMenusA"}(firstmenu, vi, tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"LayoutMenusA" LINK File 73}((firstmenu), (vi), (const @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#define @{"GT_GetIMsg" LINK "gg:doc/NDK/Guide/gadtools/GT_GetIMsg"}(iport) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0x48, @{"struct IntuiMessage" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 763} *, GT_GetIMsg, struct MsgPort *, iport, a0, \\
        , GADTOOLS_BASE_NAME)

#define @{"GT_ReplyIMsg" LINK "gg:doc/NDK/Guide/gadtools/GT_ReplyIMsg"}(imsg) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0x4e, @{"GT_ReplyIMsg" LINK File 86}, @{"struct IntuiMessage" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 763} *, imsg, a1, \\
        , GADTOOLS_BASE_NAME)

#define @{"GT_RefreshWindow" LINK "gg:doc/NDK/Guide/gadtools/GT_RefreshWindow"}(win, req) \\
        @{"LP2NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 168}(0x54, @{"GT_RefreshWindow" LINK File 90}, @{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *, win, a0, struct Requester *, req, a1, \\
        , GADTOOLS_BASE_NAME)

#define @{"GT_BeginRefresh" LINK "gg:doc/NDK/Guide/gadtools/GT_BeginRefresh"}(win) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0x5a, @{"GT_BeginRefresh" LINK File 94}, @{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *, win, a0, \\
        , GADTOOLS_BASE_NAME)

#define @{"GT_EndRefresh" LINK "gg:doc/NDK/Guide/gadtools/GT_EndRefresh"}(win, complete) \\
        @{"LP2NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 168}(0x60, @{"GT_EndRefresh" LINK File 98}, @{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *, win, a0, LONG, complete, d0, \\
        , GADTOOLS_BASE_NAME)

#define @{"GT_FilterIMsg" LINK "gg:doc/NDK/Guide/gadtools/GT_FilterIMsg"}(imsg) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0x66, @{"struct IntuiMessage" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 763} *, GT_FilterIMsg, const struct IntuiMessage *, imsg, a1, \\
        , GADTOOLS_BASE_NAME)

#define @{"GT_PostFilterIMsg" LINK "gg:doc/NDK/Guide/gadtools/GT_PostFilterIMsg"}(imsg) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0x6c, @{"struct IntuiMessage" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 763} *, GT_PostFilterIMsg, struct IntuiMessage *, imsg, a1, \\
        , GADTOOLS_BASE_NAME)

#define @{"CreateContext" LINK "gg:doc/NDK/Guide/gadtools/CreateContext"}(glistptr) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0x72, @{"struct Gadget" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 214} *, CreateContext, struct Gadget **, glistptr, a0, \\
        , GADTOOLS_BASE_NAME)

#define @{"DrawBevelBoxA" LINK "gg:doc/NDK/Guide/gadtools/DrawBevelBoxA"}(rport, left, top, width, height, taglist) \\
        @{"LP6NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 569}(0x78, @{"DrawBevelBoxA" LINK File 114}, @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *, rport, a0, LONG, left, d0, LONG, top, d1, LONG, width, d2, LONG, height, d3, const struct TagItem *, taglist, a1, \\
        , GADTOOLS_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define @{"DrawBevelBox" LINK "gg:doc/NDK/Guide/gadtools/DrawBevelBoxA"}(rport, left, top, width, height, tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"DrawBevelBoxA" LINK File 114}((rport), (left), (top), (width), (height), (const @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#define @{"GetVisualInfoA" LINK "gg:doc/NDK/Guide/gadtools/GetVisualInfoA"}(screen, taglist) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x7e, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}, @{"GetVisualInfoA" LINK File 123}, @{"struct Screen" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 133} *, screen, a0, const struct TagItem *, taglist, a1, \\
        , GADTOOLS_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define @{"GetVisualInfo" LINK "gg:doc/NDK/Guide/gadtools/GetVisualInfoA"}(screen, tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"GetVisualInfoA" LINK File 123}((screen), (const @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#define @{"FreeVisualInfo" LINK "gg:doc/NDK/Guide/gadtools/FreeVisualInfo"}(vi) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0x84, @{"FreeVisualInfo" LINK File 132}, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}, vi, a0, \\
        , @{"GADTOOLS_BASE_NAME" LINK File 26})

#define @{"GT_GetGadgetAttrsA" LINK "gg:doc/NDK/Guide/gadtools/GT_GetGadgetAttrsA"}(gad, win, req, taglist) \\
        @{"LP4" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 362}(0xae, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, @{"GT_GetGadgetAttrsA" LINK File 136}, @{"struct Gadget" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 214} *, gad, a0, struct Window *, win, a1, struct Requester *, req, a2, const struct TagItem *, taglist, a3, \\
        , GADTOOLS_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define @{"GT_GetGadgetAttrs" LINK "gg:doc/NDK/Guide/gadtools/GT_GetGadgetAttrsA"}(gad, win, req, tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"GT_GetGadgetAttrsA" LINK File 136}((gad), (win), (req), (const @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#endif /*  _INLINE_GADTOOLS_H  */
@ENDNODE
