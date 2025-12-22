@DATABASE "gg:doc/NDK/Guide/Include/clib/timer_protos.h"
@MASTER   "gg:os-include/clib/timer_protos.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:12:01
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "clib/timer_protos.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"clib/timer_protos.h" LINK File}

@ENDNODE
@NODE File "clib/timer_protos.h"
#ifndef  CLIB_TIMER_PROTOS_H
#define  CLIB_TIMER_PROTOS_H

/*
**      $VER: timer_protos.h 40.1 (17.5.1996)
**
**      C prototypes. For use with 32 bit integers only.
**
**      Copyright © 2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

#ifndef  DEVICES_TIMER_H
#include <@{"devices/timer.h" LINK "gg:doc/NDK/Guide/Include/devices/timer.h/File"}>
#endif
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"AddTime" LINK "gg:doc/NDK/Guide/Include/inline/timer.h/File" 20}( @{"struct timeval" LINK "gg:doc/NDK/Guide/Include/devices/timer.h/File" 30} *dest, CONST struct timeval *src );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"SubTime" LINK "gg:doc/NDK/Guide/Include/inline/timer.h/File" 24}( @{"struct timeval" LINK "gg:doc/NDK/Guide/Include/devices/timer.h/File" 30} *dest, CONST struct timeval *src );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"CmpTime" LINK "gg:doc/NDK/Guide/Include/inline/timer.h/File" 28}( @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"struct timeval" LINK "gg:doc/NDK/Guide/Include/devices/timer.h/File" 30} *dest, CONST struct timeval *src );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"ReadEClock" LINK "gg:doc/NDK/Guide/Include/inline/timer.h/File" 32}( @{"struct EClockVal" LINK "gg:doc/NDK/Guide/Include/devices/timer.h/File" 35} *dest );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"GetSysTime" LINK "gg:doc/NDK/Guide/Include/inline/timer.h/File" 36}( @{"struct timeval" LINK "gg:doc/NDK/Guide/Include/devices/timer.h/File" 30} *dest );

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif   /* CLIB_TIMER_PROTOS_H */
@ENDNODE
