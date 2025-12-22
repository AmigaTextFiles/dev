@DATABASE "gg:doc/NDK/Guide/Include/clib/chooser_protos.h"
@MASTER   "gg:os-include/clib/chooser_protos.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:11:32
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "clib/chooser_protos.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"clib/chooser_protos.h" LINK File}

@ENDNODE
@NODE File "clib/chooser_protos.h"
#ifndef  CLIB_CHOOSER_PROTOS_H
#define  CLIB_CHOOSER_PROTOS_H

/*
**      $VER: chooser_protos.h 1.1 (6.10.1999)
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
@{"Class" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File" 36} *@{"CHOOSER_GetClass" LINK "gg:doc/NDK/Guide/Include/inline/chooser.h/File" 23}( @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} );
@{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} *AllocChooserNodeA( struct TagItem *tags );
@{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} *AllocChooserNode( Tag firstTag, ... );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"FreeChooserNode" LINK "gg:doc/NDK/Guide/Include/inline/chooser.h/File" 36}( @{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} *node );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"SetChooserNodeAttrsA" LINK "gg:doc/NDK/Guide/Include/inline/chooser.h/File" 40}( @{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} *node, struct TagItem *tags );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"SetChooserNodeAttrs" LINK "gg:doc/NDK/Guide/Include/inline/chooser.h/File" 45}( @{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} *node, ... );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"GetChooserNodeAttrsA" LINK "gg:doc/NDK/Guide/Include/inline/chooser.h/File" 49}( @{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} *node, struct TagItem *tags );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"GetChooserNodeAttrs" LINK "gg:doc/NDK/Guide/Include/inline/chooser.h/File" 54}( @{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} *node, ... );

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif   /* CLIB_CHOOSER_PROTOS_H */
@ENDNODE
