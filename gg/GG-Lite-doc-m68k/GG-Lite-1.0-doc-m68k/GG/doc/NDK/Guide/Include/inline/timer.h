@DATABASE "gg:doc/NDK/Guide/Include/inline/timer.h"
@MASTER   "gg:os-include/inline/timer.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:15:46
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "inline/timer.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"inline/timer.h" LINK File}


@{b}#defines@{ub}

@{"AddTime()" LINK "gg:doc/NDK/Guide/Include/inline/timer.h/File" 20}  @{"CLIB_TIMER_PROTOS_H" LINK "gg:doc/NDK/Guide/Include/inline/timer.h/File" 5}  @{"CmpTime()" LINK "gg:doc/NDK/Guide/Include/inline/timer.h/File" 28}  @{"GetSysTime()" LINK "gg:doc/NDK/Guide/Include/inline/timer.h/File" 36}  @{"ReadEClock()" LINK "gg:doc/NDK/Guide/Include/inline/timer.h/File" 32}
@{"SubTime()" LINK "gg:doc/NDK/Guide/Include/inline/timer.h/File" 24}  @{"TIMER_BASE_NAME" LINK "gg:doc/NDK/Guide/Include/inline/timer.h/File" 17}      

@ENDNODE
@NODE File "inline/timer.h"
#ifndef _INLINE_TIMER_H
#define _INLINE_TIMER_H

#ifndef CLIB_TIMER_PROTOS_H
#define CLIB_TIMER_PROTOS_H
#endif

#ifndef __INLINE_MACROS_H
#include <@{"inline/macros.h" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File"}>
#endif

#ifndef  DEVICES_TIMER_H
#include <@{"devices/timer.h" LINK "gg:doc/NDK/Guide/Include/devices/timer.h/File"}>
#endif

#ifndef TIMER_BASE_NAME
#define TIMER_BASE_NAME TimerBase
#endif

#define @{"AddTime" LINK "gg:doc/NDK/Guide/timer/AddTime"}(dest, src) \\
        @{"LP2NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 168}(0x2a, @{"AddTime" LINK File 20}, @{"struct timeval" LINK "gg:doc/NDK/Guide/Include/devices/timer.h/File" 30} *, dest, a0, const struct timeval *, src, a1, \\
        , TIMER_BASE_NAME)

#define @{"SubTime" LINK "gg:doc/NDK/Guide/timer/SubTime"}(dest, src) \\
        @{"LP2NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 168}(0x30, @{"SubTime" LINK File 24}, @{"struct timeval" LINK "gg:doc/NDK/Guide/Include/devices/timer.h/File" 30} *, dest, a0, const struct timeval *, src, a1, \\
        , TIMER_BASE_NAME)

#define @{"CmpTime" LINK "gg:doc/NDK/Guide/timer/CmpTime"}(dest, src) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x36, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, @{"CmpTime" LINK File 28}, const @{"struct timeval" LINK "gg:doc/NDK/Guide/Include/devices/timer.h/File" 30} *, dest, a0, const struct timeval *, src, a1, \\
        , TIMER_BASE_NAME)

#define @{"ReadEClock" LINK "gg:doc/NDK/Guide/timer/ReadEClock"}(dest) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0x3c, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, @{"ReadEClock" LINK File 32}, @{"struct EClockVal" LINK "gg:doc/NDK/Guide/Include/devices/timer.h/File" 35} *, dest, a0, \\
        , TIMER_BASE_NAME)

#define @{"GetSysTime" LINK "gg:doc/NDK/Guide/timer/GetSysTime"}(dest) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0x42, @{"GetSysTime" LINK File 36}, @{"struct timeval" LINK "gg:doc/NDK/Guide/Include/devices/timer.h/File" 30} *, dest, a0, \\
        , TIMER_BASE_NAME)

#endif /*  _INLINE_TIMER_H  */
@ENDNODE
