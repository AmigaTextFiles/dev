@DATABASE "gg:doc/NDK/Guide/Include/clib/battclock_protos.h"
@MASTER   "gg:os-include/clib/battclock_protos.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:11:30
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "clib/battclock_protos.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"clib/battclock_protos.h" LINK File}

@ENDNODE
@NODE File "clib/battclock_protos.h"
#ifndef  CLIB_BATTCLOCK_PROTOS_H
#define  CLIB_BATTCLOCK_PROTOS_H

/*
**      $VER: battclock_protos.h 40.1 (17.5.1996)
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
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"ResetBattClock" LINK "gg:doc/NDK/Guide/Include/inline/battclock.h/File" 20}( @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"ReadBattClock" LINK "gg:doc/NDK/Guide/Include/inline/battclock.h/File" 24}( @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"WriteBattClock" LINK "gg:doc/NDK/Guide/Include/inline/battclock.h/File" 28}( @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} time );

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif   /* CLIB_BATTCLOCK_PROTOS_H */
@ENDNODE
