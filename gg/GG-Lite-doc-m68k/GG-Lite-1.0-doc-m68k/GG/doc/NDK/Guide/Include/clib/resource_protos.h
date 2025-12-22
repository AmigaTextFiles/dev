@DATABASE "gg:doc/NDK/Guide/Include/clib/resource_protos.h"
@MASTER   "gg:os-include/clib/resource_protos.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:12:00
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "clib/resource_protos.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"clib/resource_protos.h" LINK File}

@ENDNODE
@NODE File "clib/resource_protos.h"
#ifndef  CLIB_RESOURCE_PROTOS_H
#define  CLIB_RESOURCE_PROTOS_H

/*
**      $VER: resource_protos.h 44.1 (17.5.1996)
**
**      C prototypes. For use with 32 bit integers only.
**
**      Copyright © 2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

#ifndef  LIBRARIES_RESOURCE_H
#include <@{"libraries/resource.h" LINK "gg:doc/NDK/Guide/Include/libraries/resource.h/File"}>
#endif
#ifndef  INTUITION_CLASSUSR_H
#include <@{"intuition/classusr.h" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File"}>
#endif
#ifndef  INTUITION_INTUITION_H
#include <@{"intuition/intuition.h" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File"}>
#endif
#ifndef  LIBRARIES_LOCALE_H
#include <@{"libraries/locale.h" LINK "gg:doc/NDK/Guide/Include/libraries/locale.h/File"}>
#endif
#ifndef  UTILITY_TAGITEM_H
#include <@{"utility/tagitem.h" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File"}>
#endif
@{"RESOURCEFILE" LINK "gg:doc/NDK/Guide/Include/libraries/resource.h/File" 17} @{"RL_OpenResource" LINK "gg:doc/NDK/Guide/Include/inline/resource.h/File" 32}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} resource, @{"struct Screen" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 133} *screen, struct Catalog *catalog );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"RL_CloseResource" LINK "gg:doc/NDK/Guide/Include/inline/resource.h/File" 36}( @{"RESOURCEFILE" LINK "gg:doc/NDK/Guide/Include/libraries/resource.h/File" 17} resfile );
@{"Object" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 19} *@{"RL_NewObjectA" LINK "gg:doc/NDK/Guide/Include/inline/resource.h/File" 40}( @{"RESOURCEFILE" LINK "gg:doc/NDK/Guide/Include/libraries/resource.h/File" 17} resfile, @{"RESOURCEID" LINK "gg:doc/NDK/Guide/Include/libraries/resource.h/File" 18} resid, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *tags );
@{"Object" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 19} *@{"RL_NewObject" LINK "gg:doc/NDK/Guide/Include/inline/resource.h/File" 45}( @{"RESOURCEFILE" LINK "gg:doc/NDK/Guide/Include/libraries/resource.h/File" 17} resfile, @{"RESOURCEID" LINK "gg:doc/NDK/Guide/Include/libraries/resource.h/File" 18} resid, ... );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"RL_DisposeObject" LINK "gg:doc/NDK/Guide/Include/inline/resource.h/File" 49}( @{"RESOURCEFILE" LINK "gg:doc/NDK/Guide/Include/libraries/resource.h/File" 17} resfile, @{"Object" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 19} *obj );
@{"Object" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 19} **@{"RL_NewGroupA" LINK "gg:doc/NDK/Guide/Include/inline/resource.h/File" 53}( @{"RESOURCEFILE" LINK "gg:doc/NDK/Guide/Include/libraries/resource.h/File" 17} resfile, @{"RESOURCEID" LINK "gg:doc/NDK/Guide/Include/libraries/resource.h/File" 18} id, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *taglist );
@{"Object" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 19} **@{"RL_NewGroup" LINK "gg:doc/NDK/Guide/Include/inline/resource.h/File" 58}( @{"RESOURCEFILE" LINK "gg:doc/NDK/Guide/Include/libraries/resource.h/File" 17} resfile, @{"RESOURCEID" LINK "gg:doc/NDK/Guide/Include/libraries/resource.h/File" 18} id, ... );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"RL_DisposeGroup" LINK "gg:doc/NDK/Guide/Include/inline/resource.h/File" 62}( @{"RESOURCEFILE" LINK "gg:doc/NDK/Guide/Include/libraries/resource.h/File" 17} resfile, @{"Object" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 19} **obj );
@{"Object" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 19} **@{"RL_GetObjectArray" LINK "gg:doc/NDK/Guide/Include/inline/resource.h/File" 66}( @{"RESOURCEFILE" LINK "gg:doc/NDK/Guide/Include/libraries/resource.h/File" 17} resfile, @{"Object" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 19} *obj, @{"RESOURCEID" LINK "gg:doc/NDK/Guide/Include/libraries/resource.h/File" 18} id );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"RL_SetResourceScreen" LINK "gg:doc/NDK/Guide/Include/inline/resource.h/File" 70}( @{"RESOURCEFILE" LINK "gg:doc/NDK/Guide/Include/libraries/resource.h/File" 17} resfile, @{"struct Screen" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 133} *screen );

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif   /* CLIB_RESOURCE_PROTOS_H */
@ENDNODE
