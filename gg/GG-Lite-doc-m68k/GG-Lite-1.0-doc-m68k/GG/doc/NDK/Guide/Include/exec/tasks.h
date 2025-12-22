@DATABASE "gg:doc/NDK/Guide/Include/exec/tasks.h"
@MASTER   "gg:os-include/exec/tasks.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:13:19
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "exec/tasks.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"exec/tasks.h" LINK File}


@{b}Structures@{ub}

@{"StackSwapStruct" LINK "gg:doc/NDK/Guide/Include/exec/tasks.h/File" 52}  @{"Task" LINK "gg:doc/NDK/Guide/Include/exec/tasks.h/File" 24}


@{b}#defines@{ub}

@{"SIGB_ABORT" LINK "gg:doc/NDK/Guide/Include/exec/tasks.h/File" 83}  @{"SIGB_BLIT" LINK "gg:doc/NDK/Guide/Include/exec/tasks.h/File" 85}       @{"SIGB_CHILD" LINK "gg:doc/NDK/Guide/Include/exec/tasks.h/File" 84}   @{"SIGB_DOS" LINK "gg:doc/NDK/Guide/Include/exec/tasks.h/File" 89}     @{"SIGB_INTUITION" LINK "gg:doc/NDK/Guide/Include/exec/tasks.h/File" 87}
@{"SIGB_NET" LINK "gg:doc/NDK/Guide/Include/exec/tasks.h/File" 88}    @{"SIGB_SINGLE" LINK "gg:doc/NDK/Guide/Include/exec/tasks.h/File" 86}     @{"SIGF_ABORT" LINK "gg:doc/NDK/Guide/Include/exec/tasks.h/File" 91}   @{"SIGF_BLIT" LINK "gg:doc/NDK/Guide/Include/exec/tasks.h/File" 93}    @{"SIGF_CHILD" LINK "gg:doc/NDK/Guide/Include/exec/tasks.h/File" 92}
@{"SIGF_DOS" LINK "gg:doc/NDK/Guide/Include/exec/tasks.h/File" 97}    @{"SIGF_INTUITION" LINK "gg:doc/NDK/Guide/Include/exec/tasks.h/File" 95}  @{"SIGF_NET" LINK "gg:doc/NDK/Guide/Include/exec/tasks.h/File" 96}     @{"SIGF_SINGLE" LINK "gg:doc/NDK/Guide/Include/exec/tasks.h/File" 94}  @{"TB_ETASK" LINK "gg:doc/NDK/Guide/Include/exec/tasks.h/File" 60}
@{"TB_EXCEPT" LINK "gg:doc/NDK/Guide/Include/exec/tasks.h/File" 62}   @{"TB_LAUNCH" LINK "gg:doc/NDK/Guide/Include/exec/tasks.h/File" 64}       @{"TB_PROCTIME" LINK "gg:doc/NDK/Guide/Include/exec/tasks.h/File" 59}  @{"TB_STACKCHK" LINK "gg:doc/NDK/Guide/Include/exec/tasks.h/File" 61}  @{"TB_SWITCH" LINK "gg:doc/NDK/Guide/Include/exec/tasks.h/File" 63}
@{"TF_ETASK" LINK "gg:doc/NDK/Guide/Include/exec/tasks.h/File" 67}    @{"TF_EXCEPT" LINK "gg:doc/NDK/Guide/Include/exec/tasks.h/File" 69}       @{"TF_LAUNCH" LINK "gg:doc/NDK/Guide/Include/exec/tasks.h/File" 71}    @{"TF_PROCTIME" LINK "gg:doc/NDK/Guide/Include/exec/tasks.h/File" 66}  @{"TF_STACKCHK" LINK "gg:doc/NDK/Guide/Include/exec/tasks.h/File" 68}
@{"TF_SWITCH" LINK "gg:doc/NDK/Guide/Include/exec/tasks.h/File" 70}   @{"TS_ADDED" LINK "gg:doc/NDK/Guide/Include/exec/tasks.h/File" 75}        @{"TS_EXCEPT" LINK "gg:doc/NDK/Guide/Include/exec/tasks.h/File" 79}    @{"TS_INVALID" LINK "gg:doc/NDK/Guide/Include/exec/tasks.h/File" 74}   @{"TS_READY" LINK "gg:doc/NDK/Guide/Include/exec/tasks.h/File" 77}
@{"TS_REMOVED" LINK "gg:doc/NDK/Guide/Include/exec/tasks.h/File" 80}  @{"TS_RUN" LINK "gg:doc/NDK/Guide/Include/exec/tasks.h/File" 76}          @{"TS_WAIT" LINK "gg:doc/NDK/Guide/Include/exec/tasks.h/File" 78}      

@ENDNODE
@NODE File "exec/tasks.h"
#ifndef EXEC_TASKS_H
#define EXEC_TASKS_H
/*
**      $VER: tasks.h 39.3 (18.9.1992)
**      Includes Release 45.1
**
**      Task Control Block, Signals, and Task flags.
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


/* Please use Exec functions to modify task structure fields, where available.
 */
struct Task {
    @{"struct  Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} tc_Node;
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   tc_Flags;
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   tc_State;
    @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58}    tc_IDNestCnt;           /* intr disabled nesting*/
    @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58}    tc_TDNestCnt;           /* task disabled nesting*/
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   tc_SigAlloc;            /* sigs allocated */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   tc_SigWait;     /* sigs we are waiting for */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   tc_SigRecvd;            /* sigs we have received */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   tc_SigExcept;           /* sigs we will take excepts for */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   tc_TrapAlloc;           /* traps allocated */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   tc_TrapAble;            /* traps enabled */
    @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}    tc_ExceptData;          /* points to except data */
    @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}    tc_ExceptCode;          /* points to except code */
    @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}    tc_TrapData;            /* points to trap data */
    @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}    tc_TrapCode;            /* points to trap code */
    @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}    tc_SPReg;               /* stack pointer        */
    @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}    tc_SPLower;     /* stack lower bound    */
    @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}    tc_SPUpper;     /* stack upper bound + 2*/
    @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24}    (*tc_Switch)();         /* task losing CPU    */
    @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24}    (*tc_Launch)();         /* task getting CPU  */
    @{"struct  List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} tc_MemEntry;       /* Allocated memory. Freed by @{"RemTask()" LINK "gg:doc/NDK/Guide/exec/RemTask"} */
    @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}    tc_UserData;            /* For use by the task; no restrictions! */
};

/*
 * Stack swap structure as passed to @{"StackSwap()" LINK "gg:doc/NDK/Guide/exec/StackSwap"}
 */
struct  StackSwapStruct {
        @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}    stk_Lower;      /* Lowest byte of stack */
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   stk_Upper;      /* Upper end of stack (size + Lowest) */
        @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}    stk_Pointer;    /* Stack pointer at switch point */
};

/*----- Flag Bits ------------------------------------------*/
#define TB_PROCTIME     0
#define TB_ETASK        3
#define TB_STACKCHK     4
#define TB_EXCEPT       5
#define TB_SWITCH       6
#define TB_LAUNCH       7

#define TF_PROCTIME     (1L<<0)
#define TF_ETASK        (1L<<3)
#define TF_STACKCHK     (1L<<4)
#define TF_EXCEPT       (1L<<5)
#define TF_SWITCH       (1L<<6)
#define TF_LAUNCH       (1L<<7)

/*----- Task States ----------------------------------------*/
#define TS_INVALID      0
#define TS_ADDED        1
#define TS_RUN          2
#define TS_READY        3
#define TS_WAIT 4
#define TS_EXCEPT       5
#define TS_REMOVED      6

/*----- Predefined Signals -------------------------------------*/
#define SIGB_ABORT      0
#define SIGB_CHILD      1
#define SIGB_BLIT       4       /* Note: same as @{"SINGLE" LINK "gg:doc/NDK/Guide/Include/intuition/preferences.h/File" 175} */
#define SIGB_SINGLE     4       /* Note: same as BLIT */
#define SIGB_INTUITION  5
#define SIGB_NET        7
#define SIGB_DOS        8

#define SIGF_ABORT      (1L<<0)
#define SIGF_CHILD      (1L<<1)
#define SIGF_BLIT       (1L<<4)
#define SIGF_SINGLE     (1L<<4)
#define SIGF_INTUITION  (1L<<5)
#define SIGF_NET        (1L<<7)
#define SIGF_DOS        (1L<<8)

#endif  /* EXEC_TASKS_H */
@ENDNODE
