@DATABASE "gg:doc/NDK/Guide/Include/clib/virtual_protos.h"
@MASTER   "gg:os-include/clib/virtual_protos.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:12:03
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "clib/virtual_protos.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"clib/virtual_protos.h" LINK File}

@ENDNODE
@NODE File "clib/virtual_protos.h"
#ifndef  CLIB_VIRTUAL_PROTOS_H
#define  CLIB_VIRTUAL_PROTOS_H

/*
**      $VER: virtual_protos.h 1.1 (6.10.1999)
**
**      C prototypes. For use with 32 bit integers only.
**
**      Copyright © 2001 Stephan Rupprecht
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
@{"struct IClass" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File" 36} *VIRTUAL_GetClass( VOID );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"RefreshVirtualGadget" LINK "gg:doc/NDK/Guide/Include/inline/virtual.h/File" 33}( @{"struct Gadget" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 214} *gadget, ULONG obj, struct Window *window, struct Requester *requester );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"RethinkVirtualSize" LINK "gg:doc/NDK/Guide/Include/inline/virtual.h/File" 37}( @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} virt_obj, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} rootlayout, @{"struct TextFont" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 89} *font, struct Screen *screen, struct LayoutLimits *layoutlimits );

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif   /* CLIB_VIRTUAL_PROTOS_H */
@ENDNODE
