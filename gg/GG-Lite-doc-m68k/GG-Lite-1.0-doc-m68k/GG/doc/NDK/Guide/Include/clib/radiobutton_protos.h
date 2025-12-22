@DATABASE "gg:doc/NDK/Guide/Include/clib/radiobutton_protos.h"
@MASTER   "gg:os-include/clib/radiobutton_protos.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:11:57
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "clib/radiobutton_protos.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"clib/radiobutton_protos.h" LINK File}

@ENDNODE
@NODE File "clib/radiobutton_protos.h"
#ifndef  CLIB_RADIOBUTTON_PROTOS_H
#define  CLIB_RADIOBUTTON_PROTOS_H

/*
**      $VER: radiobutton_protos.h 1.1 (6.10.1999)
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
@{"Class" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File" 36} *@{"RADIOBUTTON_GetClass" LINK "gg:doc/NDK/Guide/Include/inline/radiobutton.h/File" 23}( @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} );
@{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} *AllocRadioButtonNodeA( ULONG columns, struct TagItem *tags );
@{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} *AllocRadioButtonNode( ULONG columns, Tag firstTag, ... );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"FreeRadioButtonNode" LINK "gg:doc/NDK/Guide/Include/inline/radiobutton.h/File" 36}( @{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} *node );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"SetRadioButtonNodeAttrsA" LINK "gg:doc/NDK/Guide/Include/inline/radiobutton.h/File" 40}( @{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} *node, struct TagItem *tags );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"SetRadioButtonNodeAttrs" LINK "gg:doc/NDK/Guide/Include/inline/radiobutton.h/File" 45}( @{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} *node, ... );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"GetRadioButtonNodeAttrsA" LINK "gg:doc/NDK/Guide/Include/inline/radiobutton.h/File" 49}( @{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} *node, struct TagItem *tags );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"GetRadioButtonNodeAttrs" LINK "gg:doc/NDK/Guide/Include/inline/radiobutton.h/File" 54}( @{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} *node, ... );

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif   /* CLIB_RADIOBUTTON_PROTOS_H */
@ENDNODE
