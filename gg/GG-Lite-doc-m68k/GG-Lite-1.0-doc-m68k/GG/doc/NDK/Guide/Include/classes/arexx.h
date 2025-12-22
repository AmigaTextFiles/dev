@DATABASE "gg:doc/NDK/Guide/Include/classes/arexx.h"
@MASTER   "gg:os-include/classes/arexx.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:11:20
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "classes/arexx.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"classes/arexx.h" LINK File}


@{b}Structures@{ub}

@{"apExecute" LINK "gg:doc/NDK/Guide/Include/classes/arexx.h/File" 102}  @{"ARexxCmd" LINK "gg:doc/NDK/Guide/Include/classes/arexx.h/File" 118}


@{b}#defines@{ub}

@{"AM_EXECUTE" LINK "gg:doc/NDK/Guide/Include/classes/arexx.h/File" 94}           @{"AM_FLUSH" LINK "gg:doc/NDK/Guide/Include/classes/arexx.h/File" 97}                   @{"AM_HANDLEEVENT" LINK "gg:doc/NDK/Guide/Include/classes/arexx.h/File" 91}
@{"AREXX_Commands" LINK "gg:doc/NDK/Guide/Include/classes/arexx.h/File" 63}       @{"AREXX_DefExtension" LINK "gg:doc/NDK/Guide/Include/classes/arexx.h/File" 61}         @{"AREXX_DefExtention" LINK "gg:doc/NDK/Guide/Include/classes/arexx.h/File" 85}
@{"AREXX_Dummy" LINK "gg:doc/NDK/Guide/Include/classes/arexx.h/File" 57}          @{"AREXX_ErrorCode" LINK "gg:doc/NDK/Guide/Include/classes/arexx.h/File" 65}            @{"AREXX_HostName" LINK "gg:doc/NDK/Guide/Include/classes/arexx.h/File" 59}
@{"AREXX_MsgPort" LINK "gg:doc/NDK/Guide/Include/classes/arexx.h/File" 73}        @{"AREXX_NoSlot" LINK "gg:doc/NDK/Guide/Include/classes/arexx.h/File" 69}               @{"AREXX_ReplyHook" LINK "gg:doc/NDK/Guide/Include/classes/arexx.h/File" 71}
@{"AREXX_SigMask" LINK "gg:doc/NDK/Guide/Include/classes/arexx.h/File" 67}        @{"RXERR_NO_COMMAND_LIST" LINK "gg:doc/NDK/Guide/Include/classes/arexx.h/File" 78}      @{"RXERR_NO_PORT_NAME" LINK "gg:doc/NDK/Guide/Include/classes/arexx.h/File" 79}
@{"RXERR_OUT_OF_MEMORY" LINK "gg:doc/NDK/Guide/Include/classes/arexx.h/File" 81}  @{"RXERR_PORT_ALREADY_EXISTS" LINK "gg:doc/NDK/Guide/Include/classes/arexx.h/File" 80}  

@ENDNODE
@NODE File "classes/arexx.h"
#ifndef CLASSES_AREXX_H
#define CLASSES_AREXX_H
/*
**      $VER: arexx.h 44.1 (19.10.1999)
**      Includes Release 45.1
**
**      arexx.class definitions
**
**      (C) Copyright 1987-2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifndef EXEC_MEMORY_H
#include <@{"exec/memory.h" LINK "gg:doc/NDK/Guide/Include/exec/memory.h/File"}>
#endif

#ifndef DOS_DOS_H
#include <@{"dos/dos.h" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File"}>
#endif

#ifndef DOS_RDARGS_H
#include <@{"dos/rdargs.h" LINK "gg:doc/NDK/Guide/Include/dos/rdargs.h/File"}>
#endif

#ifndef REXX_STORAGE_H
#include <@{"rexx/storage.h" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File"}>
#endif

#ifndef REXX_RXSLIB_H
#include <@{"rexx/rxslib.h" LINK "gg:doc/NDK/Guide/Include/rexx/rxslib.h/File"}>
#endif

#ifndef REXX_ERRORS_H
#include <@{"rexx/errors.h" LINK "gg:doc/NDK/Guide/Include/rexx/errors.h/File"}>
#endif

#ifndef INTUITION_CLASSES_H
#include <@{"intuition/classes.h" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File"}>
#endif

#ifndef INTUITION_CLASSUSR_H
#include <@{"intuition/classusr.h" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File"}>
#endif

#ifndef UTILITY_HOOKS_H
#include <@{"utility/hooks.h" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File"}>
#endif

#ifndef REACTION_REACTION_H
#include <@{"reaction/reaction.h" LINK "gg:doc/NDK/Guide/Include/reaction/reaction.h/File"}>
#endif

/*****************************************************************************/

/* Tags supported by the arexx class
 */
#define AREXX_Dummy                             (@{"REACTION_Dummy" LINK "gg:doc/NDK/Guide/Include/reaction/reaction.h/File" 26}+0x30000)

#define AREXX_HostName                  (@{"AREXX_Dummy" LINK File 57}+1)
        /* (@{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}) */
#define AREXX_DefExtension              (@{"AREXX_Dummy" LINK File 57}+2)
        /* (@{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}) */
#define AREXX_Commands                  (@{"AREXX_Dummy" LINK File 57}+3)
        /* (@{"struct ARexxCmd" LINK "gg:doc/NDK/Guide/Include/classes/arexx.h/File" 118} *) */
#define AREXX_ErrorCode                 (@{"AREXX_Dummy" LINK File 57}+4)
        /* (@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} *) */
#define AREXX_SigMask                   (@{"AREXX_Dummy" LINK File 57}+5)
        /* (@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}) */
#define AREXX_NoSlot                    (@{"AREXX_Dummy" LINK File 57}+6)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) */
#define AREXX_ReplyHook                 (@{"AREXX_Dummy" LINK File 57}+7)
        /* (@{"struct Hook" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File" 28} *) */
#define AREXX_MsgPort                   (@{"AREXX_Dummy" LINK File 57}+8)
        /* (@{"struct MsgPort" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 28} *) */

/* Possible error result codes
 */
#define RXERR_NO_COMMAND_LIST     (1L)
#define RXERR_NO_PORT_NAME        (2L)
#define RXERR_PORT_ALREADY_EXISTS (3L)
#define RXERR_OUT_OF_MEMORY       (4L)

/* I can't spell, don't use this.
 */
#define AREXX_DefExtention      @{"AREXX_DefExtension" LINK File 61}

/*****************************************************************************/

/* Methods Supported by the ARexx Class.
 */
#define AM_HANDLEEVENT                (0x590001)
        /* ARexx class event-handler. */

#define @{"AM_EXECUTE" LINK "gg:doc/NDK/Guide/arexx_cl/AM_EXECUTE"}                    (0x590002)
        /* Execute a host command. */

#define AM_FLUSH                      (0x590003)
        /* Flush rexx port. */

/* @{"AM_EXECUTE" LINK "gg:doc/NDK/Guide/arexx_cl/AM_EXECUTE"} message.
 */
struct apExecute
{
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} MethodID;                         /* @{"AM_EXECUTE" LINK "gg:doc/NDK/Guide/arexx_cl/AM_EXECUTE"} */
        @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} ape_CommandString;       /* Command string to execute */
        @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} ape_PortName;            /* Port to send to (usually @{"RXSDIR" LINK "gg:doc/NDK/Guide/Include/rexx/rxslib.h/File" 19}) */
        @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} *ape_RC;                           /* RC pointer */
        @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} *ape_RC2;                          /* RC2 pointer */
        @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} *ape_Result;                     /* Result pointer */
        @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} ape_IO;                            /* I/O handle */
};


/*****************************************************************************/

/* An array of these structures must be passed at object-create time.
 */
struct ARexxCmd
{
        @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} ac_Name;                 /* Command name */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} ac_ID;                    /* Unique ID */

        /* NOTE: The function pointed to by ac_Func() will be called
         *       with parameters in CPU registers. Register usage
         *       is as follows:
         *
         *       @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} ac_Func(@{"struct ARexxCmd" LINK "gg:doc/NDK/Guide/Include/classes/arexx.h/File" 118} * cmd, @{"struct RexxMsg" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 98} * rm)
         *                                       A0                   A1
         */
        @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} (*ac_Func)();

        @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} ac_ArgTemplate;  /* DOS-style argument template */
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} ac_Flags;                 /* Unused, make @{"NULL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 101} */
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} *ac_ArgList;              /* Result of @{"ReadArgs()" LINK "gg:doc/NDK/Guide/dos/ReadArgs"} */
        @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} ac_RC;                             /* Primary result */
        @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} ac_RC2;                    /* Secondary result */
        @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} ac_Result;               /* RESULT variable */
};

#endif /* CLASSES_AREXX_H */
@ENDNODE
