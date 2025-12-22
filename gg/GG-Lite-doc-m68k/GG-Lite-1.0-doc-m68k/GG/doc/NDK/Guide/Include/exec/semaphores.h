@DATABASE "gg:doc/NDK/Guide/Include/exec/semaphores.h"
@MASTER   "gg:os-include/exec/semaphores.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:13:18
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "exec/semaphores.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"exec/semaphores.h" LINK File}


@{b}Structures@{ub}

@{"Semaphore" LINK "gg:doc/NDK/Guide/Include/exec/semaphores.h/File" 62}  @{"SemaphoreMessage" LINK "gg:doc/NDK/Guide/Include/exec/semaphores.h/File" 51}  @{"SemaphoreRequest" LINK "gg:doc/NDK/Guide/Include/exec/semaphores.h/File" 33}  @{"SignalSemaphore" LINK "gg:doc/NDK/Guide/Include/exec/semaphores.h/File" 40}


@{b}#defines@{ub}

@{"SM_EXCLUSIVE" LINK "gg:doc/NDK/Guide/Include/exec/semaphores.h/File" 58}  @{"sm_LockMsg" LINK "gg:doc/NDK/Guide/Include/exec/semaphores.h/File" 68}  @{"SM_SHARED" LINK "gg:doc/NDK/Guide/Include/exec/semaphores.h/File" 57}

@ENDNODE
@NODE File "exec/semaphores.h"
#ifndef EXEC_SEMAPHORES_H
#define EXEC_SEMAPHORES_H
/*
**      $VER: semaphores.h 39.1 (7.2.1992)
**      Includes Release 45.1
**
**      Definitions for locking functions.
**
**      (C) Copyright 1986-2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifndef EXEC_NODES_H
#include <@{"exec/nodes.h" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File"}>
#endif /* EXEC_NODES_H */

#ifndef EXEC_LISTS_H
#include <@{"exec/lists.h" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File"}>
#endif /* EXEC_LISTS_H */

#ifndef EXEC_PORTS_H
#include <@{"exec/ports.h" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File"}>
#endif /* EXEC_PORTS_H */

#ifndef EXEC_TASKS_H
#include <@{"exec/tasks.h" LINK "gg:doc/NDK/Guide/Include/exec/tasks.h/File"}>
#endif /* EXEC_TASKS_H */


/****** SignalSemaphore *********************************************/

/* Private structure used by @{"ObtainSemaphore()" LINK "gg:doc/NDK/Guide/exec/ObtainSemaphore"} */
struct SemaphoreRequest
{
        @{"struct MinNode" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 31}  sr_Link;
        @{"struct Task" LINK "gg:doc/NDK/Guide/Include/exec/tasks.h/File" 24}     *sr_Waiter;
};

/* Signal Semaphore data structure */
struct SignalSemaphore
{
        @{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22}             ss_Link;
        @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}                    ss_NestCount;
        @{"struct MinList" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 31}          ss_WaitQueue;
        @{"struct SemaphoreRequest" LINK File 33} ss_MultipleLink;
        @{"struct Task" LINK "gg:doc/NDK/Guide/Include/exec/tasks.h/File" 24}             *ss_Owner;
        @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}                    ss_QueueCount;
};

/****** Semaphore procure message (for use in V39 Procure/Vacate) ****/
struct SemaphoreMessage
{
        @{"struct Message" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 47}          ssm_Message;
        @{"struct SignalSemaphore" LINK File 40}  *ssm_Semaphore;
};

#define SM_SHARED       (1L)
#define SM_EXCLUSIVE    (0L)

/****** Semaphore (Old Procure/Vacate type, not reliable) ***********/

        /* Do not use these semaphores! */struct Semaphore
{
        @{"struct MsgPort" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 28}  sm_MsgPort;
        @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}            sm_Bids;
};

#define sm_LockMsg mp_SigTask

#endif  /* EXEC_SEMAPHORES_H */
@ENDNODE
