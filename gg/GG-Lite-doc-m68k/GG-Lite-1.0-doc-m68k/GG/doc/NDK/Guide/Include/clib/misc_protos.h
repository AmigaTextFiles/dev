@DATABASE "gg:doc/NDK/Guide/Include/clib/misc_protos.h"
@MASTER   "gg:os-include/clib/misc_protos.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:11:55
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "clib/misc_protos.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"clib/misc_protos.h" LINK File}

@ENDNODE
@NODE File "clib/misc_protos.h"
#ifndef  CLIB_MISC_PROTOS_H
#define  CLIB_MISC_PROTOS_H

/*
**      $VER: misc_protos.h 40.1 (17.5.1996)
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
@{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} *@{"AllocMiscResource" LINK "gg:doc/NDK/Guide/Include/inline/misc.h/File" 20}( @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} unitNum, @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} name );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"FreeMiscResource" LINK "gg:doc/NDK/Guide/Include/inline/misc.h/File" 24}( @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} unitNum );

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif   /* CLIB_MISC_PROTOS_H */
@ENDNODE
