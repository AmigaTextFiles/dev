@DATABASE "gg:doc/NDK/Guide/Include/exec/nodes.h"
@MASTER   "gg:os-include/exec/nodes.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:13:16
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "exec/nodes.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"exec/nodes.h" LINK File}


@{b}Structures@{ub}

@{"MinNode" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 31}  @{"Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22}


@{b}#defines@{ub}

@{"NT_BOOTNODE" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 59}  @{"NT_DEATHMESSAGE" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 62}  @{"NT_DEVICE" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 46}     @{"NT_EXTENDED" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 65}  @{"NT_FONT" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 55}
@{"NT_FREEMSG" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 49}   @{"NT_GRAPHICS" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 61}      @{"NT_INTERRUPT" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 45}  @{"NT_KICKMEM" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 60}   @{"NT_LIBRARY" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 52}
@{"NT_MEMORY" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 53}    @{"NT_MESSAGE" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 48}       @{"NT_MSGPORT" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 47}    @{"NT_PROCESS" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 56}   @{"NT_REPLYMSG" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 50}
@{"NT_RESOURCE" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 51}  @{"NT_SEMAPHORE" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 57}     @{"NT_SIGNALSEM" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 58}  @{"NT_SOFTINT" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 54}   @{"NT_TASK" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 44}
@{"NT_UNKNOWN" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 43}   @{"NT_USER" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 64}          

@ENDNODE
@NODE File "exec/nodes.h"
#ifndef EXEC_NODES_H
#define EXEC_NODES_H
/*
**      $VER: nodes.h 39.0 (15.10.1991)
**      Includes Release 45.1
**
**      Nodes & Node type identifiers.
**
**      (C) Copyright 1985-2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif /* EXEC_TYPES_H */


/*
 *  List Node Structure.  Each member in a list starts with a Node
 */

struct Node {
    struct  Node *ln_Succ;      /* Pointer to next (successor) */
    struct  Node *ln_Pred;      /* Pointer to previous (predecessor) */
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   ln_Type;
    @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58}    ln_Pri;             /* Priority, for sorting */
    char    *ln_Name;           /* ID string, null terminated */
};      /* Note: word aligned */

/* minimal node -- no type checking possible */
struct MinNode {
    struct MinNode *mln_Succ;
    struct MinNode *mln_Pred;
};


/*
** Note: Newly initialized IORequests, and software interrupt structures
** used with @{"Cause()" LINK "gg:doc/NDK/Guide/exec/Cause"}, should have type @{"NT_UNKNOWN" LINK File 43}.  The OS will assign a type
** when they are first used.
*/
/*----- Node Types for LN_TYPE -----*/
#define NT_UNKNOWN      0
#define NT_TASK         1       /* Exec task */
#define NT_INTERRUPT    2
#define NT_DEVICE       3
#define NT_MSGPORT      4
#define NT_MESSAGE      5       /* Indicates message currently pending */
#define NT_FREEMSG      6
#define NT_REPLYMSG     7       /* Message has been replied */
#define NT_RESOURCE     8
#define NT_LIBRARY      9
#define NT_MEMORY       10
#define NT_SOFTINT      11      /* Internal flag used by SoftInits */
#define NT_FONT         12
#define NT_PROCESS      13      /* AmigaDOS Process */
#define NT_SEMAPHORE    14
#define NT_SIGNALSEM    15      /* signal semaphores */
#define NT_BOOTNODE     16
#define NT_KICKMEM      17
#define NT_GRAPHICS     18
#define NT_DEATHMESSAGE 19

#define NT_USER         254     /* User node types work down from here */
#define NT_EXTENDED     255

#endif  /* EXEC_NODES_H */
@ENDNODE
