@DATABASE "gg:doc/NDK/Guide/Include/inline/listbrowser.h"
@MASTER   "gg:os-include/inline/listbrowser.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:15:12
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "inline/listbrowser.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"inline/listbrowser.h" LINK File}


@{b}#defines@{ub}

@{"AllocLBColumnInfo()" LINK "gg:doc/NDK/Guide/Include/inline/listbrowser.h/File" 90}           @{"AllocLBColumnInfoA()" LINK "gg:doc/NDK/Guide/Include/inline/listbrowser.h/File" 85}
@{"AllocListBrowserNode()" LINK "gg:doc/NDK/Guide/Include/inline/listbrowser.h/File" 35}        @{"AllocListBrowserNodeA()" LINK "gg:doc/NDK/Guide/Include/inline/listbrowser.h/File" 30}
@{"CLIB_LISTBROWSER_PROTOS_H" LINK "gg:doc/NDK/Guide/Include/inline/listbrowser.h/File" 5}     @{"FreeLBColumnInfo()" LINK "gg:doc/NDK/Guide/Include/inline/listbrowser.h/File" 112}
@{"FreeListBrowserList()" LINK "gg:doc/NDK/Guide/Include/inline/listbrowser.h/File" 81}         @{"FreeListBrowserNode()" LINK "gg:doc/NDK/Guide/Include/inline/listbrowser.h/File" 39}
@{"GetLBColumnInfoAttrs()" LINK "gg:doc/NDK/Guide/Include/inline/listbrowser.h/File" 108}        @{"GetLBColumnInfoAttrsA()" LINK "gg:doc/NDK/Guide/Include/inline/listbrowser.h/File" 103}
@{"GetListBrowserNodeAttrs()" LINK "gg:doc/NDK/Guide/Include/inline/listbrowser.h/File" 57}     @{"GetListBrowserNodeAttrsA()" LINK "gg:doc/NDK/Guide/Include/inline/listbrowser.h/File" 52}
@{"HideAllListBrowserChildren()" LINK "gg:doc/NDK/Guide/Include/inline/listbrowser.h/File" 77}  @{"HideListBrowserNodeChildren()" LINK "gg:doc/NDK/Guide/Include/inline/listbrowser.h/File" 69}
@{"LISTBROWSER_BASE_NAME" LINK "gg:doc/NDK/Guide/Include/inline/listbrowser.h/File" 23}         @{"LISTBROWSER_GetClass()" LINK "gg:doc/NDK/Guide/Include/inline/listbrowser.h/File" 26}
@{"ListBrowserClearAll()" LINK "gg:doc/NDK/Guide/Include/inline/listbrowser.h/File" 116}         @{"ListBrowserSelectAll()" LINK "gg:doc/NDK/Guide/Include/inline/listbrowser.h/File" 61}
@{"SetLBColumnInfoAttrs()" LINK "gg:doc/NDK/Guide/Include/inline/listbrowser.h/File" 99}        @{"SetLBColumnInfoAttrsA()" LINK "gg:doc/NDK/Guide/Include/inline/listbrowser.h/File" 94}
@{"SetListBrowserNodeAttrs()" LINK "gg:doc/NDK/Guide/Include/inline/listbrowser.h/File" 48}     @{"SetListBrowserNodeAttrsA()" LINK "gg:doc/NDK/Guide/Include/inline/listbrowser.h/File" 43}
@{"ShowAllListBrowserChildren()" LINK "gg:doc/NDK/Guide/Include/inline/listbrowser.h/File" 73}  @{"ShowListBrowserNodeChildren()" LINK "gg:doc/NDK/Guide/Include/inline/listbrowser.h/File" 65}

@ENDNODE
@NODE File "inline/listbrowser.h"
#ifndef _INLINE_LISTBROWSER_H
#define _INLINE_LISTBROWSER_H

#ifndef CLIB_LISTBROWSER_PROTOS_H
#define CLIB_LISTBROWSER_PROTOS_H
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
#ifndef  GADGETS_LISTBROWSER_H
#include <@{"gadgets/listbrowser.h" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File"}>
#endif

#ifndef LISTBROWSER_BASE_NAME
#define LISTBROWSER_BASE_NAME ListBrowserBase
#endif

#define @{"LISTBROWSER_GetClass()" LINK "gg:doc/NDK/Guide/listbrowser_gc/LISTBROWSER_GetClass"} \\
        @{"LP0" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 25}(0x1e, @{"struct IClass" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File" 36} *, LISTBROWSER_GetClass, \\
        , LISTBROWSER_BASE_NAME)

#define @{"AllocListBrowserNodeA" LINK "gg:doc/NDK/Guide/listbrowser_gc/AllocListBrowserNodeA"}(columns, tags) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x24, @{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} *, AllocListBrowserNodeA, ULONG, columns, d0, struct TagItem *, tags, a0, \\
        , LISTBROWSER_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define @{"AllocListBrowserNode" LINK "gg:doc/NDK/Guide/listbrowser_gc/AllocListBrowserNodeA"}(columns, tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"AllocListBrowserNodeA" LINK File 30}((columns), (@{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#define @{"FreeListBrowserNode" LINK "gg:doc/NDK/Guide/listbrowser_gc/FreeListBrowserNode"}(node) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0x2a, @{"FreeListBrowserNode" LINK File 39}, @{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} *, node, a0, \\
        , LISTBROWSER_BASE_NAME)

#define @{"SetListBrowserNodeAttrsA" LINK "gg:doc/NDK/Guide/listbrowser_gc/SetListBrowserNodeAttrsA"}(node, tags) \\
        @{"LP2NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 168}(0x30, @{"SetListBrowserNodeAttrsA" LINK File 43}, @{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} *, node, a0, struct TagItem *, tags, a1, \\
        , LISTBROWSER_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define @{"SetListBrowserNodeAttrs" LINK "gg:doc/NDK/Guide/listbrowser_gc/SetListBrowserNodeAttrsA"}(node, tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"SetListBrowserNodeAttrsA" LINK File 43}((node), (@{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#define @{"GetListBrowserNodeAttrsA" LINK "gg:doc/NDK/Guide/listbrowser_gc/GetListBrowserNodeAttrsA"}(node, tags) \\
        @{"LP2NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 168}(0x36, @{"GetListBrowserNodeAttrsA" LINK File 52}, @{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} *, node, a0, struct TagItem *, tags, a1, \\
        , LISTBROWSER_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define @{"GetListBrowserNodeAttrs" LINK "gg:doc/NDK/Guide/listbrowser_gc/GetListBrowserNodeAttrsA"}(node, tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"GetListBrowserNodeAttrsA" LINK File 52}((node), (@{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#define @{"ListBrowserSelectAll" LINK "gg:doc/NDK/Guide/listbrowser_gc/ListBrowserSelectAll"}(list) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0x3c, @{"ListBrowserSelectAll" LINK File 61}, @{"struct List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} *, list, a0, \\
        , LISTBROWSER_BASE_NAME)

#define @{"ShowListBrowserNodeChildren" LINK "gg:doc/NDK/Guide/listbrowser_gc/ShowListBrowserNodeChildren"}(node, depth) \\
        @{"LP2NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 168}(0x42, @{"ShowListBrowserNodeChildren" LINK File 65}, @{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} *, node, a0, LONG, depth, d0, \\
        , LISTBROWSER_BASE_NAME)

#define @{"HideListBrowserNodeChildren" LINK "gg:doc/NDK/Guide/listbrowser_gc/HideListBrowserNodeChildren"}(node) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0x48, @{"HideListBrowserNodeChildren" LINK File 69}, @{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} *, node, a0, \\
        , LISTBROWSER_BASE_NAME)

#define @{"ShowAllListBrowserChildren" LINK "gg:doc/NDK/Guide/listbrowser_gc/ShowAllListBrowserChildren"}(list) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0x4e, @{"ShowAllListBrowserChildren" LINK File 73}, @{"struct List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} *, list, a0, \\
        , LISTBROWSER_BASE_NAME)

#define @{"HideAllListBrowserChildren" LINK "gg:doc/NDK/Guide/listbrowser_gc/HideAllListBrowserChildren"}(list) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0x54, @{"HideAllListBrowserChildren" LINK File 77}, @{"struct List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} *, list, a0, \\
        , LISTBROWSER_BASE_NAME)

#define @{"FreeListBrowserList" LINK "gg:doc/NDK/Guide/listbrowser_gc/FreeListBrowserList"}(list) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0x5a, @{"FreeListBrowserList" LINK File 81}, @{"struct List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} *, list, a0, \\
        , LISTBROWSER_BASE_NAME)

#define AllocLBColumnInfoA(columns, tags) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x60, @{"struct ColumnInfo" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 285} *, AllocLBColumnInfoA, ULONG, columns, d0, struct TagItem *, tags, a0, \\
        , LISTBROWSER_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define AllocLBColumnInfo(columns, tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"AllocLBColumnInfoA" LINK File 85}((columns), (@{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#define SetLBColumnInfoAttrsA(columninfo, tags) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x66, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, @{"SetLBColumnInfoAttrsA" LINK File 94}, @{"struct ColumnInfo" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 285} *, columninfo, a1, struct TagItem *, tags, a0, \\
        , LISTBROWSER_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define SetLBColumnInfoAttrs(columninfo, tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"SetLBColumnInfoAttrsA" LINK File 94}((columninfo), (@{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#define GetLBColumnInfoAttrsA(columninfo, tags) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x6c, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, @{"GetLBColumnInfoAttrsA" LINK File 103}, @{"struct ColumnInfo" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 285} *, columninfo, a1, struct TagItem *, tags, a0, \\
        , LISTBROWSER_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define GetLBColumnInfoAttrs(columninfo, tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"GetLBColumnInfoAttrsA" LINK File 103}((columninfo), (@{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#define FreeLBColumnInfo(columninfo) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0x72, @{"FreeLBColumnInfo" LINK File 112}, @{"struct ColumnInfo" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 285} *, columninfo, a0, \\
        , LISTBROWSER_BASE_NAME)

#define @{"ListBrowserClearAll" LINK "gg:doc/NDK/Guide/listbrowser_gc/ListBrowserClearAll"}(list) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0x78, @{"ListBrowserClearAll" LINK File 116}, @{"struct List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} *, list, a0, \\
        , LISTBROWSER_BASE_NAME)

#endif /*  _INLINE_LISTBROWSER_H  */
@ENDNODE
