@DATABASE "gg:doc/NDK/Guide/Include/clib/battmem_protos.h"
@MASTER   "gg:os-include/clib/battmem_protos.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:11:31
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "clib/battmem_protos.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"clib/battmem_protos.h" LINK File}

@ENDNODE
@NODE File "clib/battmem_protos.h"
#ifndef  CLIB_BATTMEM_PROTOS_H
#define  CLIB_BATTMEM_PROTOS_H

/*
**      $VER: battmem_protos.h 40.1 (17.5.1996)
**
**      C prototypes. For use with 32 bit integers only.
**
**      Copyright © 2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

#ifndef  EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"ObtainBattSemaphore" LINK "gg:doc/NDK/Guide/Include/inline/battmem.h/File" 20}( @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"ReleaseBattSemaphore" LINK "gg:doc/NDK/Guide/Include/inline/battmem.h/File" 24}( @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"ReadBattMem" LINK "gg:doc/NDK/Guide/Include/inline/battmem.h/File" 28}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} buffer, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} offset, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} length );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"WriteBattMem" LINK "gg:doc/NDK/Guide/Include/inline/battmem.h/File" 32}( @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} buffer, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} offset, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} length );

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif   /* CLIB_BATTMEM_PROTOS_H */
@ENDNODE
