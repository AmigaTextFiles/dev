@DATABASE "gg:doc/NDK/Guide/Include/workbench/startup.h"
@MASTER   "gg:os-include/workbench/startup.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:39
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "workbench/startup.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"workbench/startup.h" LINK File}


@{b}Structures@{ub}

@{"WBArg" LINK "gg:doc/NDK/Guide/Include/workbench/startup.h/File" 34}  @{"WBStartup" LINK "gg:doc/NDK/Guide/Include/workbench/startup.h/File" 25}

@ENDNODE
@NODE File "workbench/startup.h"
#ifndef WORKBENCH_STARTUP_H
#define WORKBENCH_STARTUP_H
/*
**      $VER: startup.h 36.3 (11.7.1990)
**      Includes Release 45.1
**
**      workbench startup definitions
**
**      (C) Copyright 1985-2001 Amiga, Inc.
**      All Rights Reserved
*/

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif

#ifndef EXEC_PORTS_H
#include <@{"exec/ports.h" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File"}>
#endif

#ifndef DOS_DOS_H
#include <@{"dos/dos.h" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File"}>
#endif

struct WBStartup {
    @{"struct Message" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 47}      sm_Message;     /* a standard message structure */
    @{"struct MsgPort" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 28} *    sm_Process;     /* the process descriptor for you */
    @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130}                sm_Segment;     /* a descriptor for your code */
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}                sm_NumArgs;     /* the number of elements in ArgList */
    char *              sm_ToolWindow;  /* description of window */
    @{"struct WBArg" LINK File 34} *      sm_ArgList;     /* the arguments themselves */
};

struct WBArg {
    @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130}                wa_Lock;        /* a lock descriptor */
    @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58} *              wa_Name;        /* a string relative to that lock */
};

#endif  /* !WORKBENCH_STARTUP_H */
@ENDNODE
