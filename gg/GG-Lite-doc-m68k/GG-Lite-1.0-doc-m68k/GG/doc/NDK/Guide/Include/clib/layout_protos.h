@DATABASE "gg:doc/NDK/Guide/Include/clib/layout_protos.h"
@MASTER   "gg:os-include/clib/layout_protos.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:11:52
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "clib/layout_protos.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"clib/layout_protos.h" LINK File}

@ENDNODE
@NODE File "clib/layout_protos.h"
#ifndef  CLIB_LAYOUT_PROTOS_H
#define  CLIB_LAYOUT_PROTOS_H

/*
**      $VER: layout_protos.h 1.1 (6.10.1999)
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
#ifndef  GADGETS_LAYOUT_H
#include <@{"gadgets/layout.h" LINK "gg:doc/NDK/Guide/Include/gadgets/layout.h/File"}>
#endif
@{"Class" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File" 36} *@{"LAYOUT_GetClass" LINK "gg:doc/NDK/Guide/Include/inline/layout.h/File" 26}( @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"ActivateLayoutGadget" LINK "gg:doc/NDK/Guide/Include/inline/layout.h/File" 30}( @{"struct Gadget" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 214} *gadget, struct Window *window, struct Requester *requester, ULONG object );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"FlushLayoutDomainCache" LINK "gg:doc/NDK/Guide/Include/inline/layout.h/File" 34}( @{"struct Gadget" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 214} *gadget );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"RethinkLayout" LINK "gg:doc/NDK/Guide/Include/inline/layout.h/File" 38}( @{"struct Gadget" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 214} *gadget, struct Window *window, struct Requester *requester, LONG refresh );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"LayoutLimits" LINK "gg:doc/NDK/Guide/Include/inline/layout.h/File" 42}( @{"struct Gadget" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 214} *gadget, struct LayoutLimits *limits, struct TextFont *font, struct Screen *screen );
@{"Class" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File" 36} *@{"PAGE_GetClass" LINK "gg:doc/NDK/Guide/Include/inline/layout.h/File" 46}( @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"SetPageGadgetAttrsA" LINK "gg:doc/NDK/Guide/Include/inline/layout.h/File" 50}( @{"struct Gadget" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 214} *gadget, Object *object, struct Window *window, struct Requester *requester, struct TagItem *tags );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"SetPageGadgetAttrs" LINK "gg:doc/NDK/Guide/Include/inline/layout.h/File" 55}( @{"struct Gadget" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 214} *gadget, Object *object, struct Window *window, struct Requester *requester, ... );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"RefreshPageGadget" LINK "gg:doc/NDK/Guide/Include/inline/layout.h/File" 59}( @{"struct Gadget" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 214} *gadget, Object *object, struct Window *window, struct Requester *requester );

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif   /* CLIB_LAYOUT_PROTOS_H */
@ENDNODE
