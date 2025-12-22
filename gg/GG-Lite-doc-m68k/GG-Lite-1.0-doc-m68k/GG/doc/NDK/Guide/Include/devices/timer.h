@DATABASE "gg:doc/NDK/Guide/Include/devices/timer.h"
@MASTER   "gg:os-include/devices/timer.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:12:44
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "devices/timer.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"devices/timer.h" LINK File}


@{b}Structures@{ub}

@{"EClockVal" LINK "gg:doc/NDK/Guide/Include/devices/timer.h/File" 35}  @{"timerequest" LINK "gg:doc/NDK/Guide/Include/devices/timer.h/File" 40}  @{"timeval" LINK "gg:doc/NDK/Guide/Include/devices/timer.h/File" 30}


@{b}#defines@{ub}

@{"TIMERNAME" LINK "gg:doc/NDK/Guide/Include/devices/timer.h/File" 28}     @{"TR_ADDREQUEST" LINK "gg:doc/NDK/Guide/Include/devices/timer.h/File" 46}  @{"TR_GETSYSTIME" LINK "gg:doc/NDK/Guide/Include/devices/timer.h/File" 47}    @{"TR_SETSYSTIME" LINK "gg:doc/NDK/Guide/Include/devices/timer.h/File" 48}   @{"UNIT_ECLOCK" LINK "gg:doc/NDK/Guide/Include/devices/timer.h/File" 24}
@{"UNIT_MICROHZ" LINK "gg:doc/NDK/Guide/Include/devices/timer.h/File" 22}  @{"UNIT_VBLANK" LINK "gg:doc/NDK/Guide/Include/devices/timer.h/File" 23}    @{"UNIT_WAITECLOCK" LINK "gg:doc/NDK/Guide/Include/devices/timer.h/File" 26}  @{"UNIT_WAITUNTIL" LINK "gg:doc/NDK/Guide/Include/devices/timer.h/File" 25}  

@ENDNODE
@NODE File "devices/timer.h"
#ifndef DEVICES_TIMER_H
#define DEVICES_TIMER_H 1
/*
**      $VER: timer.h 36.16 (25.1.1991)
**      Includes Release 45.1
**
**      Timer device name and useful definitions.
**
**      (C) Copyright 1985-2001 Amiga, Inc.
**              All Rights Reserved
*/

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif

#ifndef EXEC_IO_H
#include <@{"exec/io.h" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File"}>
#endif

/* unit defintions */
#define UNIT_MICROHZ    0
#define UNIT_VBLANK     1
#define UNIT_ECLOCK     2
#define UNIT_WAITUNTIL  3
#define UNIT_WAITECLOCK 4

#define TIMERNAME       "timer.device"

struct timeval {
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} tv_secs;
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} tv_micro;
};

struct EClockVal {
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} ev_hi;
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} ev_lo;
};

struct timerequest {
    @{"struct IORequest" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 18} tr_node;
    @{"struct timeval" LINK File 30} tr_time;
};

/* IO_COMMAND to use for adding a timer */
#define @{"TR_ADDREQUEST" LINK "gg:doc/NDK/Guide/timer/TR_ADDREQUEST"}   @{"CMD_NONSTD" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 59}
#define @{"TR_GETSYSTIME" LINK "gg:doc/NDK/Guide/timer/TR_GETSYSTIME"}   (@{"CMD_NONSTD" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 59}+1)
#define @{"TR_SETSYSTIME" LINK "gg:doc/NDK/Guide/timer/TR_SETSYSTIME"}   (@{"CMD_NONSTD" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 59}+2)

#endif /* DEVICES_TIMER_H */
@ENDNODE
