@DATABASE "gg:doc/NDK/Guide/Include/inline/battclock.h"
@MASTER   "gg:os-include/inline/battclock.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:14:29
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "inline/battclock.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"inline/battclock.h" LINK File}


@{b}#defines@{ub}

@{"BATTCLOCK_BASE_NAME" LINK "gg:doc/NDK/Guide/Include/inline/battclock.h/File" 17}  @{"CLIB_BATTCLOCK_PROTOS_H" LINK "gg:doc/NDK/Guide/Include/inline/battclock.h/File" 5}  @{"ReadBattClock()" LINK "gg:doc/NDK/Guide/Include/inline/battclock.h/File" 24}
@{"ResetBattClock()" LINK "gg:doc/NDK/Guide/Include/inline/battclock.h/File" 20}     @{"WriteBattClock()" LINK "gg:doc/NDK/Guide/Include/inline/battclock.h/File" 28}         

@ENDNODE
@NODE File "inline/battclock.h"
#ifndef _INLINE_BATTCLOCK_H
#define _INLINE_BATTCLOCK_H

#ifndef CLIB_BATTCLOCK_PROTOS_H
#define CLIB_BATTCLOCK_PROTOS_H
#endif

#ifndef __INLINE_MACROS_H
#include <@{"inline/macros.h" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File"}>
#endif

#ifndef  EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif

#ifndef BATTCLOCK_BASE_NAME
#define BATTCLOCK_BASE_NAME BattClockBase
#endif

#define @{"ResetBattClock()" LINK "gg:doc/NDK/Guide/battclock/ResetBattClock"} \\
        @{"LP0NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 41}(0x6, @{"ResetBattClock" LINK File 20}, \\
        , @{"BATTCLOCK_BASE_NAME" LINK File 17})

#define @{"ReadBattClock()" LINK "gg:doc/NDK/Guide/battclock/ReadBattClock"} \\
        @{"LP0" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 25}(0xc, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, @{"ReadBattClock" LINK File 24}, \\
        , @{"BATTCLOCK_BASE_NAME" LINK File 17})

#define @{"WriteBattClock" LINK "gg:doc/NDK/Guide/battclock/WriteBattClock"}(time) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0x12, @{"WriteBattClock" LINK File 28}, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, time, d0, \\
        , @{"BATTCLOCK_BASE_NAME" LINK File 17})

#endif /*  _INLINE_BATTCLOCK_H  */
@ENDNODE
