@DATABASE "gg:doc/NDK/Guide/Include/exec/ports.h"
@MASTER   "gg:os-include/exec/ports.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:13:17
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "exec/ports.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"exec/ports.h" LINK File}


@{b}Structures@{ub}

@{"Message" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 47}  @{"MsgPort" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 28}


@{b}#defines@{ub}

@{"mp_SoftInt" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 36}  @{"PA_IGNORE" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 42}  @{"PA_SIGNAL" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 40}  @{"PA_SOFTINT" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 41}  @{"PF_ACTION" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 39}

@ENDNODE
@NODE File "exec/ports.h"
#ifndef EXEC_PORTS_H
#define EXEC_PORTS_H
/*
**      $VER: ports.h 39.0 (15.10.1991)
**      Includes Release 45.1
**
**      Message ports and Messages.
**
**      (C) Copyright 1985-2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifndef EXEC_NODES_H
#include <@{"exec/nodes.h" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File"}>
#endif /* EXEC_NODES_H */

#ifndef EXEC_LISTS_H
#include <@{"exec/lists.h" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File"}>
#endif /* EXEC_LISTS_H */

#ifndef EXEC_TASKS_H
#include <@{"exec/tasks.h" LINK "gg:doc/NDK/Guide/Include/exec/tasks.h/File"}>
#endif /* EXEC_TASKS_H */


/****** MsgPort *****************************************************/

struct MsgPort {
    @{"struct  Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} mp_Node;
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   mp_Flags;
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   mp_SigBit;          /* signal bit number    */
    void   *mp_SigTask;         /* object to be signalled */
    @{"struct  List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} mp_MsgList;    /* message linked list  */
};

#define mp_SoftInt mp_SigTask   /* Alias */

/* mp_Flags: Port arrival actions (@{"PutMsg" LINK "gg:doc/NDK/Guide/exec/PutMsg"}) */
#define PF_ACTION       3       /* Mask */
#define PA_SIGNAL       0       /* Signal task in mp_SigTask */
#define PA_SOFTINT      1       /* Signal SoftInt in @{"mp_SoftInt" LINK File 36}/mp_SigTask */
#define PA_IGNORE       2       /* Ignore arrival */


/****** Message *****************************************************/

struct Message {
    @{"struct  Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} mn_Node;
    @{"struct  MsgPort" LINK File 28} *mn_ReplyPort;  /* message reply port */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   mn_Length;              /* total message length, in bytes */
                                    /* (include the size of the Message */
                                    /* structure in the length) */
};

#endif  /* EXEC_PORTS_H */
@ENDNODE
