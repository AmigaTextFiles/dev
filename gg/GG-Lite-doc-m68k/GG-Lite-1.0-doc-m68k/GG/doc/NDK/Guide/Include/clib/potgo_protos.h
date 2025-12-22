@DATABASE "gg:doc/NDK/Guide/Include/clib/potgo_protos.h"
@MASTER   "gg:os-include/clib/potgo_protos.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:11:57
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "clib/potgo_protos.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"clib/potgo_protos.h" LINK File}

@ENDNODE
@NODE File "clib/potgo_protos.h"
#ifndef  CLIB_POTGO_PROTOS_H
#define  CLIB_POTGO_PROTOS_H

/*
**      $VER: potgo_protos.h 40.1 (17.5.1996)
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
@{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} @{"AllocPotBits" LINK "gg:doc/NDK/Guide/Include/inline/potgo.h/File" 20}( @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} bits );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"FreePotBits" LINK "gg:doc/NDK/Guide/Include/inline/potgo.h/File" 24}( @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} bits );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"WritePotgo" LINK "gg:doc/NDK/Guide/Include/inline/potgo.h/File" 28}( @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} word, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} mask );

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif   /* CLIB_POTGO_PROTOS_H */
@ENDNODE
