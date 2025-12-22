@DATABASE "gg:doc/NDK/Guide/Include/rexx/rxslib.h"
@MASTER   "gg:os-include/rexx/rxslib.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:28
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "rexx/rxslib.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"rexx/rxslib.h" LINK File}


@{b}Structures@{ub}

@{"RxsLib" LINK "gg:doc/NDK/Guide/Include/rexx/rxslib.h/File" 25}


@{b}#defines@{ub}

@{"CTB_ALPHA" LINK "gg:doc/NDK/Guide/Include/rexx/rxslib.h/File" 90}    @{"CTB_DIGIT" LINK "gg:doc/NDK/Guide/Include/rexx/rxslib.h/File" 89}    @{"CTB_LOWER" LINK "gg:doc/NDK/Guide/Include/rexx/rxslib.h/File" 95}    @{"CTB_REXXOPR" LINK "gg:doc/NDK/Guide/Include/rexx/rxslib.h/File" 92}  @{"CTB_REXXSPC" LINK "gg:doc/NDK/Guide/Include/rexx/rxslib.h/File" 93}
@{"CTB_REXXSYM" LINK "gg:doc/NDK/Guide/Include/rexx/rxslib.h/File" 91}  @{"CTB_SPACE" LINK "gg:doc/NDK/Guide/Include/rexx/rxslib.h/File" 88}    @{"CTB_UPPER" LINK "gg:doc/NDK/Guide/Include/rexx/rxslib.h/File" 94}    @{"CTF_ALPHA" LINK "gg:doc/NDK/Guide/Include/rexx/rxslib.h/File" 100}    @{"CTF_DIGIT" LINK "gg:doc/NDK/Guide/Include/rexx/rxslib.h/File" 99}
@{"CTF_LOWER" LINK "gg:doc/NDK/Guide/Include/rexx/rxslib.h/File" 105}    @{"CTF_REXXOPR" LINK "gg:doc/NDK/Guide/Include/rexx/rxslib.h/File" 102}  @{"CTF_REXXSPC" LINK "gg:doc/NDK/Guide/Include/rexx/rxslib.h/File" 103}  @{"CTF_REXXSYM" LINK "gg:doc/NDK/Guide/Include/rexx/rxslib.h/File" 101}  @{"CTF_SPACE" LINK "gg:doc/NDK/Guide/Include/rexx/rxslib.h/File" 98}
@{"CTF_UPPER" LINK "gg:doc/NDK/Guide/Include/rexx/rxslib.h/File" 104}    @{"RLFB_CLOSE" LINK "gg:doc/NDK/Guide/Include/rexx/rxslib.h/File" 77}   @{"RLFB_HALT" LINK "gg:doc/NDK/Guide/Include/rexx/rxslib.h/File" 74}    @{"RLFB_STOP" LINK "gg:doc/NDK/Guide/Include/rexx/rxslib.h/File" 76}    @{"RLFB_SUSP" LINK "gg:doc/NDK/Guide/Include/rexx/rxslib.h/File" 75}
@{"RLFB_TRACE" LINK "gg:doc/NDK/Guide/Include/rexx/rxslib.h/File" 73}   @{"RLFMASK" LINK "gg:doc/NDK/Guide/Include/rexx/rxslib.h/File" 79}      @{"RXSCHUNK" LINK "gg:doc/NDK/Guide/Include/rexx/rxslib.h/File" 82}     @{"RXSDIR" LINK "gg:doc/NDK/Guide/Include/rexx/rxslib.h/File" 19}       @{"RXSNAME" LINK "gg:doc/NDK/Guide/Include/rexx/rxslib.h/File" 18}
@{"RXSNEST" LINK "gg:doc/NDK/Guide/Include/rexx/rxslib.h/File" 83}      @{"RXSSTACK" LINK "gg:doc/NDK/Guide/Include/rexx/rxslib.h/File" 85}     @{"RXSTNAME" LINK "gg:doc/NDK/Guide/Include/rexx/rxslib.h/File" 20}     @{"RXSTPRI" LINK "gg:doc/NDK/Guide/Include/rexx/rxslib.h/File" 84}      

@ENDNODE
@NODE File "rexx/rxslib.h"
#ifndef REXX_RXSLIB_H
#define REXX_RXSLIB_H
/*
**      $VER: rxslib.h 1.6 (8.11.1991)
**      Includes Release 45.1
**
**      The header file for the REXX Systems Library
**
**      (C) Copyright 1987,1988,1989,1990 William S. Hawes
**      (C) Copyright 1990-2001 Amiga, Inc.
**              All Rights Reserved
*/

#ifndef REXX_STORAGE_H
#include <@{"rexx/storage.h" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File"}>
#endif

#define RXSNAME  "rexxsyslib.library"
#define RXSDIR   "REXX"
#define RXSTNAME "ARexx"

/* The REXX systems library structure.  This should be considered as    */
/* semi-private and read-only, except for documented exceptions.        */

struct RxsLib {
   @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34} rl_Node;             /* EXEC library node             */
   @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}    rl_Flags;                  /* global flags                  */
   @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}    rl_Shadow;                 /* shadow flags                  */
   @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}     rl_SysBase;        /* EXEC library base             */
   @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}     rl_DOSBase;        /* DOS library base              */
   @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}     rl_IeeeDPBase;             /* IEEE DP math library base     */
   @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}     rl_SegList;        /* library seglist               */
   @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}     rl_NIL;                    /* global NIL: filehandle        */
   @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}     rl_Chunk;                  /* allocation quantum            */
   @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}     rl_MaxNest;        /* maximum expression nesting    */
   @{"struct NexxStr" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 41} *rl_NULL;            /* static string: @{"NULL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 101}           */
   @{"struct NexxStr" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 41} *rl_FALSE;           /* static string: @{"FALSE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 98}          */
   @{"struct NexxStr" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 41} *rl_TRUE;            /* static string: @{"TRUE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 95}           */
   @{"struct NexxStr" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 41} *rl_REXX;            /* static string: REXX           */
   @{"struct NexxStr" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 41} *rl_COMMAND;         /* static string: COMMAND        */
   @{"struct NexxStr" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 41} *rl_STDIN;           /* static string: STDIN          */
   @{"struct NexxStr" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 41} *rl_STDOUT;          /* static string: STDOUT */
   @{"struct NexxStr" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 41} *rl_STDERR;          /* static string: STDERR */
   @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}    rl_Version;               /* version string                */

   @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}    rl_TaskName;              /* name string for tasks */
   @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}      rl_TaskPri;               /* starting priority             */
   @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}      rl_TaskSeg;               /* startup seglist               */
   @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}      rl_StackSize;             /* stack size                    */
   @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}    rl_RexxDir;               /* REXX directory                */
   @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}    rl_CTABLE;        /* character attribute table     */
   @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}    rl_Notice;        /* copyright notice              */

   @{"struct MsgPort" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 28} rl_RexxPort;         /* REXX public port              */
   @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}     rl_ReadLock;              /* lock count                    */
   @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}      rl_TraceFH;               /* global trace console          */
   @{"struct List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} rl_TaskList;            /* REXX task list                */
   @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}      rl_NumTask;               /* task count                    */
   @{"struct List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} rl_LibList;             /* Library List header           */
   @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}      rl_NumLib;        /* library count         */
   @{"struct List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} rl_ClipList;            /* ClipList header               */
   @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}      rl_NumClip;               /* clip node count               */
   @{"struct List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} rl_MsgList;             /* pending messages              */
   @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}      rl_NumMsg;        /* pending count         */
   @{"struct List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} rl_PgmList;             /* cached programs               */
   @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}      rl_NumPgm;        /* program count         */

   @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}     rl_TraceCnt;              /* usage count for trace console */
   @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}      rl_avail;
   };

/* Global flag bit definitions for RexxMaster                           */
#define RLFB_TRACE @{"RTFB_TRACE" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 208}          /* interactive tracing?          */
#define RLFB_HALT  @{"RTFB_HALT" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 209}           /* halt execution?               */
#define RLFB_SUSP  @{"RTFB_SUSP" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 210}           /* suspend execution?            */
#define RLFB_STOP  6                   /* deny further invocations      */
#define RLFB_CLOSE 7                   /* close the master              */

#define RLFMASK    (1<<@{"RLFB_TRACE" LINK File 73}) | (1<<@{"RLFB_HALT" LINK File 74}) | (1<<@{"RLFB_SUSP" LINK File 75})

/* Initialization constants                                             */
#define RXSCHUNK   1024        /* allocation quantum            */
#define RXSNEST    32                  /* expression nesting limit      */
#define RXSTPRI    0                   /* task priority         */
#define RXSSTACK   4096        /* stack size                    */

/* Character attribute flag bits used in REXX.                          */
#define CTB_SPACE   0                  /* white space characters        */
#define CTB_DIGIT   1                  /* decimal digits 0-9            */
#define CTB_ALPHA   2                  /* alphabetic characters */
#define CTB_REXXSYM 3                  /* REXX symbol characters        */
#define CTB_REXXOPR 4                  /* REXX operator characters      */
#define CTB_REXXSPC 5                  /* REXX special symbols          */
#define CTB_UPPER   6                  /* UPPERCASE alphabetic          */
#define CTB_LOWER   7                  /* lowercase alphabetic          */

/* Attribute flags                                                      */
#define CTF_SPACE   (1 << @{"CTB_SPACE" LINK File 88})
#define CTF_DIGIT   (1 << @{"CTB_DIGIT" LINK File 89})
#define CTF_ALPHA   (1 << @{"CTB_ALPHA" LINK File 90})
#define CTF_REXXSYM (1 << @{"CTB_REXXSYM" LINK File 91})
#define CTF_REXXOPR (1 << @{"CTB_REXXOPR" LINK File 92})
#define CTF_REXXSPC (1 << @{"CTB_REXXSPC" LINK File 93})
#define CTF_UPPER   (1 << @{"CTB_UPPER" LINK File 94})
#define CTF_LOWER   (1 << @{"CTB_LOWER" LINK File 95})

#endif
@ENDNODE
