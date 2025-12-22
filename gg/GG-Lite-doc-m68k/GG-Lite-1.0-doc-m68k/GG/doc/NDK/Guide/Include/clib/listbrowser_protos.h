@DATABASE "gg:doc/NDK/Guide/Include/clib/listbrowser_protos.h"
@MASTER   "gg:os-include/clib/listbrowser_protos.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:11:52
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "clib/listbrowser_protos.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"clib/listbrowser_protos.h" LINK File}

@ENDNODE
@NODE File "clib/listbrowser_protos.h"
#ifndef  CLIB_LISTBROWSER_PROTOS_H
#define  CLIB_LISTBROWSER_PROTOS_H

/*
**      $VER: listbrowser_protos.h 1.1 (6.10.1999)
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
#ifndef  GADGETS_LISTBROWSER_H
#include <@{"gadgets/listbrowser.h" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File"}>
#endif
@{"struct IClass" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File" 36} *LISTBROWSER_GetClass( VOID );
@{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} *AllocListBrowserNodeA( ULONG columns, struct TagItem *tags );
@{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} *AllocListBrowserNode( ULONG columns, ... );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"FreeListBrowserNode" LINK "gg:doc/NDK/Guide/Include/inline/listbrowser.h/File" 39}( @{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} *node );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"SetListBrowserNodeAttrsA" LINK "gg:doc/NDK/Guide/Include/inline/listbrowser.h/File" 43}( @{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} *node, struct TagItem *tags );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"SetListBrowserNodeAttrs" LINK "gg:doc/NDK/Guide/Include/inline/listbrowser.h/File" 48}( @{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} *node, ... );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"GetListBrowserNodeAttrsA" LINK "gg:doc/NDK/Guide/Include/inline/listbrowser.h/File" 52}( @{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} *node, struct TagItem *tags );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"GetListBrowserNodeAttrs" LINK "gg:doc/NDK/Guide/Include/inline/listbrowser.h/File" 57}( @{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} *node, ... );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"ListBrowserSelectAll" LINK "gg:doc/NDK/Guide/Include/inline/listbrowser.h/File" 61}( @{"struct List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} *list );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"ShowListBrowserNodeChildren" LINK "gg:doc/NDK/Guide/Include/inline/listbrowser.h/File" 65}( @{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} *node, LONG depth );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"HideListBrowserNodeChildren" LINK "gg:doc/NDK/Guide/Include/inline/listbrowser.h/File" 69}( @{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} *node );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"ShowAllListBrowserChildren" LINK "gg:doc/NDK/Guide/Include/inline/listbrowser.h/File" 73}( @{"struct List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} *list );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"HideAllListBrowserChildren" LINK "gg:doc/NDK/Guide/Include/inline/listbrowser.h/File" 77}( @{"struct List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} *list );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"FreeListBrowserList" LINK "gg:doc/NDK/Guide/Include/inline/listbrowser.h/File" 81}( @{"struct List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} *list );
/* Functions in V45 */
@{"struct ColumnInfo" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 285} *AllocLBColumnInfoA( ULONG columns, struct TagItem *tags );
@{"struct ColumnInfo" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 285} *AllocLBColumnInfo( ULONG columns, ... );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"SetLBColumnInfoAttrsA" LINK "gg:doc/NDK/Guide/Include/inline/listbrowser.h/File" 94}( @{"struct ColumnInfo" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 285} *columninfo, struct TagItem *tags );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"SetLBColumnInfoAttrs" LINK "gg:doc/NDK/Guide/Include/inline/listbrowser.h/File" 99}( @{"struct ColumnInfo" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 285} *columninfo, ... );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"GetLBColumnInfoAttrsA" LINK "gg:doc/NDK/Guide/Include/inline/listbrowser.h/File" 103}( @{"struct ColumnInfo" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 285} *columninfo, struct TagItem *tags );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"GetLBColumnInfoAttrs" LINK "gg:doc/NDK/Guide/Include/inline/listbrowser.h/File" 108}( @{"struct ColumnInfo" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 285} *columninfo, ... );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"FreeLBColumnInfo" LINK "gg:doc/NDK/Guide/Include/inline/listbrowser.h/File" 112}( @{"struct ColumnInfo" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 285} *columninfo );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"ListBrowserClearAll" LINK "gg:doc/NDK/Guide/Include/inline/listbrowser.h/File" 116}( @{"struct List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} *list );

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif   /* CLIB_LISTBROWSER_PROTOS_H */
@ENDNODE
