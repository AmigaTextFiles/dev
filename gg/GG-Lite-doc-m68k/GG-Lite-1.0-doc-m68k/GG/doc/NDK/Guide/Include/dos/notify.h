@DATABASE "gg:doc/NDK/Guide/Include/dos/notify.h"
@MASTER   "gg:os-include/dos/notify.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:13:03
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "dos/notify.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"dos/notify.h" LINK File}


@{b}Structures@{ub}

@{"NotifyMessage" LINK "gg:doc/NDK/Guide/Include/dos/notify.h/File" 39}  @{"NotifyRequest" LINK "gg:doc/NDK/Guide/Include/dos/notify.h/File" 51}


@{b}#defines@{ub}

@{"NOTIFY_CLASS" LINK "gg:doc/NDK/Guide/Include/dos/notify.h/File" 31}        @{"NOTIFY_CODE" LINK "gg:doc/NDK/Guide/Include/dos/notify.h/File" 34}         @{"NR_HANDLER_FLAGS" LINK "gg:doc/NDK/Guide/Include/dos/notify.h/File" 95}
@{"NRB_MAGIC" LINK "gg:doc/NDK/Guide/Include/dos/notify.h/File" 92}           @{"NRB_NOTIFY_INITIAL" LINK "gg:doc/NDK/Guide/Include/dos/notify.h/File" 90}  @{"NRB_SEND_MESSAGE" LINK "gg:doc/NDK/Guide/Include/dos/notify.h/File" 87}
@{"NRB_SEND_SIGNAL" LINK "gg:doc/NDK/Guide/Include/dos/notify.h/File" 88}     @{"NRB_WAIT_REPLY" LINK "gg:doc/NDK/Guide/Include/dos/notify.h/File" 89}      @{"NRF_MAGIC" LINK "gg:doc/NDK/Guide/Include/dos/notify.h/File" 84}
@{"NRF_NOTIFY_INITIAL" LINK "gg:doc/NDK/Guide/Include/dos/notify.h/File" 81}  @{"NRF_SEND_MESSAGE" LINK "gg:doc/NDK/Guide/Include/dos/notify.h/File" 78}    @{"NRF_SEND_SIGNAL" LINK "gg:doc/NDK/Guide/Include/dos/notify.h/File" 79}
@{"NRF_WAIT_REPLY" LINK "gg:doc/NDK/Guide/Include/dos/notify.h/File" 80}      

@ENDNODE
@NODE File "dos/notify.h"
#ifndef DOS_NOTIFY_H
#define DOS_NOTIFY_H
/*
**
**      $VER: notify.h 36.8 (29.8.1990)
**      Includes Release 45.1
**
**      dos notification definitions
**
**      (C) Copyright 1989-2001 Amiga, Inc.
**          All Rights Reserved
**
*/

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif

#ifndef EXEC_PORTS_H
#include <@{"exec/ports.h" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File"}>
#endif

#ifndef EXEC_TASKS_H
#include <@{"exec/tasks.h" LINK "gg:doc/NDK/Guide/Include/exec/tasks.h/File"}>
#endif


/* use of Class and code is discouraged for the time being - we might want to
   change things */
/* --- NotifyMessage Class ------------------------------------------------ */
#define NOTIFY_CLASS    0x40000000

/* --- NotifyMessage Codes ------------------------------------------------ */
#define NOTIFY_CODE     0x1234


/* Sent to the application if SEND_MESSAGE is specified.                    */

struct NotifyMessage {
    @{"struct Message" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 47} nm_ExecMessage;
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}  nm_Class;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}  nm_Code;
    @{"struct NotifyRequest" LINK File 51} *nm_NReq;      /* don't modify the request! */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}  nm_DoNotTouch;               /* like it says!  For use by handlers */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}  nm_DoNotTouch2;              /* ditto */
};

/* Do not modify or reuse the notifyrequest while active.                   */
/* note: the first @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} of nr_Data has the length transfered                */

struct NotifyRequest {
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} *nr_Name;
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} *nr_FullName;             /* set by dos - don't touch */
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} nr_UserData;              /* for applications use */
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} nr_Flags;

        union

            struct
                @{"struct MsgPort" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 28} *nr_Port;        /* for SEND_MESSAGE */
            } nr_Msg;

            struct
                @{"struct Task" LINK "gg:doc/NDK/Guide/Include/exec/tasks.h/File" 24} *nr_Task;           /* for SEND_SIGNAL */
                @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} nr_SignalNum;             /* for SEND_SIGNAL */
                @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} nr_pad[3];
            } nr_Signal;
        } nr_stuff;

        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} nr_Reserved[4];           /* leave 0 for now */

        /* internal use by handlers */
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} nr_MsgCount;              /* # of outstanding msgs */
        @{"struct MsgPort" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 28} *nr_Handler;     /* handler sent to (for @{"EndNotify" LINK "gg:doc/NDK/Guide/dos/EndNotify"}) */
};

/* --- NotifyRequest Flags ------------------------------------------------ */
#define NRF_SEND_MESSAGE        1
#define NRF_SEND_SIGNAL         2
#define NRF_WAIT_REPLY          8
#define NRF_NOTIFY_INITIAL      16

/* do @{"NOT" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 1500} set or remove @{"NRF_MAGIC" LINK File 84}!  Only for use by handlers! */
#define NRF_MAGIC       0x80000000

/* bit numbers */
#define NRB_SEND_MESSAGE        0
#define NRB_SEND_SIGNAL         1
#define NRB_WAIT_REPLY          3
#define NRB_NOTIFY_INITIAL      4

#define NRB_MAGIC               31

/* Flags reserved for private use by the handler: */
#define NR_HANDLER_FLAGS        0xffff0000

#endif /* DOS_NOTIFY_H */
@ENDNODE
