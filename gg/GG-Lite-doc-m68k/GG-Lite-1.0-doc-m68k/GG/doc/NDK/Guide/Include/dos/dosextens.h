@DATABASE "gg:doc/NDK/Guide/Include/dos/dosextens.h"
@MASTER   "gg:os-include/dos/dosextens.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:12:55
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "dos/dosextens.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"dos/dosextens.h" LINK File}


@{b}Structures@{ub}

@{"AssignList" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 407}   @{"CliProcList" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 274}     @{"CommandLineInterface" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 314}  @{"DeviceList" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 342}  @{"DevInfo" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 356}
@{"DevProc" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 421}      @{"DosInfo" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 284}         @{"DosLibrary" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 237}            @{"DosList" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 372}     @{"DosPacket" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 108}
@{"ErrorString" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 227}  @{"FileHandle" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 89}      @{"FileLock" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 456}              @{"Process" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 37}     @{"RootNode" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 252}
@{"Segment" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 299}      @{"StandardPacket" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 139}  


@{b}#defines@{ub}

@{"ABORT_BUSY" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 473}            @{"ABORT_DISK_ERROR" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 472}       @{"ACTION_ADD_NOTIFY" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 209}
@{"ACTION_CHANGE_MODE" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 199}    @{"ACTION_CHANGE_SIGNAL" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 191}   @{"ACTION_COPY_DIR" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 160}
@{"ACTION_COPY_DIR_FH" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 201}    @{"ACTION_CREATE_DIR" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 163}      @{"ACTION_CURRENT_VOLUME" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 151}
@{"ACTION_DELETE_OBJECT" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 157}  @{"ACTION_DIE" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 149}             @{"ACTION_DISK_CHANGE" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 174}
@{"ACTION_DISK_INFO" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 166}      @{"ACTION_DISK_TYPE" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 173}       @{"ACTION_END" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 185}
@{"ACTION_EVENT" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 150}          @{"ACTION_EXAMINE_ALL" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 203}     @{"ACTION_EXAMINE_ALL_END" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 213}
@{"ACTION_EXAMINE_FH" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 204}     @{"ACTION_EXAMINE_NEXT" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 165}    @{"ACTION_EXAMINE_OBJECT" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 164}
@{"ACTION_FH_FROM_LOCK" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 197}   @{"ACTION_FINDINPUT" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 183}       @{"ACTION_FINDOUTPUT" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 184}
@{"ACTION_FINDUPDATE" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 182}     @{"ACTION_FLUSH" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 168}           @{"ACTION_FORMAT" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 192}
@{"ACTION_FREE_LOCK" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 156}      @{"ACTION_FREE_RECORD" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 207}     @{"ACTION_GET_BLOCK" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 147}
@{"ACTION_INFO" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 167}           @{"ACTION_INHIBIT" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 172}         @{"ACTION_IS_FILESYSTEM" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 198}
@{"ACTION_LOCATE_OBJECT" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 152}  @{"ACTION_LOCK_RECORD" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 206}     @{"ACTION_MAKE_LINK" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 193}
@{"ACTION_MORE_CACHE" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 159}     @{"ACTION_NIL" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 145}             @{"ACTION_PARENT" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 170}
@{"ACTION_PARENT_FH" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 202}      @{"ACTION_READ" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 155}            @{"ACTION_READ_LINK" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 196}
@{"ACTION_READ_RETURN" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 179}    @{"ACTION_REMOVE_NOTIFY" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 210}   @{"ACTION_RENAME_DISK" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 153}
@{"ACTION_RENAME_OBJECT" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 158}  @{"ACTION_SAME_LOCK" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 190}       @{"ACTION_SCREEN_MODE" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 177}
@{"ACTION_SEEK" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 181}           @{"ACTION_SERIALIZE_DISK" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 221}  @{"ACTION_SET_COMMENT" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 169}
@{"ACTION_SET_DATE" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 175}       @{"ACTION_SET_FILE_SIZE" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 186}   @{"ACTION_SET_MAP" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 148}
@{"ACTION_SET_OWNER" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 214}      @{"ACTION_SET_PROTECT" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 162}     @{"ACTION_STARTUP" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 146}
@{"ACTION_TIMER" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 171}          @{"ACTION_WAIT_CHAR" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 161}       @{"ACTION_WRITE" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 154}
@{"ACTION_WRITE_PROTECT" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 187}  @{"ACTION_WRITE_RETURN" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 180}    @{"CMD_DISABLED" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 308}
@{"CMD_INTERNAL" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 307}          @{"CMD_SYSTEM" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 306}             @{"DLT_DEVICE" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 413}
@{"DLT_DIRECTORY" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 414}         @{"DLT_LATE" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 416}               @{"DLT_NONBINDING" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 417}
@{"DLT_PRIVATE" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 418}           @{"DLT_VOLUME" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 415}             @{"DVPB_ASSIGN" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 431}
@{"DVPB_UNLOCK" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 429}           @{"DVPF_ASSIGN" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 432}            @{"DVPF_UNLOCK" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 430}
@{"LDB_ASSIGNS" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 439}           @{"LDB_DELETE" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 443}             @{"LDB_DEVICES" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 435}
@{"LDB_ENTRY" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 441}             @{"LDB_READ" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 447}               @{"LDB_VOLUMES" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 437}
@{"LDB_WRITE" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 449}             @{"LDF_ALL" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 453}                @{"LDF_ASSIGNS" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 440}
@{"LDF_DELETE" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 444}            @{"LDF_DEVICES" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 436}            @{"LDF_ENTRY" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 442}
@{"LDF_READ" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 448}              @{"LDF_VOLUMES" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 438}            @{"LDF_WRITE" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 450}
@{"PRB_CLOSEINPUT" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 77}        @{"PRB_CLOSEOUTPUT" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 79}        @{"PRB_FREEARGS" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 81}
@{"PRB_FREECLI" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 75}           @{"PRB_FREECURRDIR" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 73}        @{"PRB_FREESEGLIST" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 71}
@{"PRF_CLOSEINPUT" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 78}        @{"PRF_CLOSEOUTPUT" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 80}        @{"PRF_FREEARGS" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 82}
@{"PRF_FREECLI" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 76}           @{"PRF_FREECURRDIR" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 74}        @{"PRF_FREESEGLIST" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 72}
@{"REPORT_INSERT" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 469}         @{"REPORT_LOCK" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 467}            @{"REPORT_STREAM" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 465}
@{"REPORT_TASK" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 466}           @{"REPORT_VOLUME" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 468}          @{"RNB_PRIVATE1" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 270}
@{"RNB_WILDSTAR" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 268}          @{"RNF_PRIVATE1" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 271}           @{"RNF_WILDSTAR" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 269}
@{"RUN_EXECUTE" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 477}           @{"RUN_SYSTEM" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 478}             @{"RUN_SYSTEM_ASYNCH" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 479}
@{"ST_FILE" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 490}               @{"ST_LINKDIR" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 489}             @{"ST_LINKFILE" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 491}
@{"ST_PIPEFILE" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 492}           @{"ST_ROOT" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 486}                @{"ST_SOFTLINK" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 488}
@{"ST_USERDIR" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 487}            

@ENDNODE
@NODE File "dos/dosextens.h"
#ifndef DOS_DOSEXTENS_H
#define DOS_DOSEXTENS_H
/*
**      $VER: dosextens.h 36.41 (14.5.1992)
**      Includes Release 45.1
**
**      DOS structures not needed for the casual AmigaDOS user
**
**      (C) Copyright 1985-2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifndef EXEC_TASKS_H
#include <@{"exec/tasks.h" LINK "gg:doc/NDK/Guide/Include/exec/tasks.h/File"}>
#endif
#ifndef EXEC_PORTS_H
#include <@{"exec/ports.h" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File"}>
#endif
#ifndef EXEC_LIBRARIES_H
#include <@{"exec/libraries.h" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File"}>
#endif
#ifndef EXEC_SEMAPHORES_H
#include <@{"exec/semaphores.h" LINK "gg:doc/NDK/Guide/Include/exec/semaphores.h/File"}>
#endif
#ifndef DEVICES_TIMER_H
#include <@{"devices/timer.h" LINK "gg:doc/NDK/Guide/Include/devices/timer.h/File"}>
#endif

#ifndef DOS_DOS_H
#include <@{"dos/dos.h" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File"}>
#endif

/* All DOS processes have this structure */
/* Create and Device Proc returns pointer to the MsgPort in this structure */
/* dev_proc = (@{"struct Process" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 37} *) (@{"DeviceProc" LINK "gg:doc/NDK/Guide/dos/DeviceProc"}(..) - sizeof(@{"struct Task" LINK "gg:doc/NDK/Guide/Include/exec/tasks.h/File" 24})); */

struct Process {
    @{"struct  Task" LINK "gg:doc/NDK/Guide/Include/exec/tasks.h/File" 24}    pr_Task;
    @{"struct  MsgPort" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 28} pr_MsgPort; /* This is @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} address from DOS functions  */
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}    pr_Pad;             /* Remaining variables on 4 byte boundaries */
    @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130}    pr_SegList;         /* Array of seg lists used by this process  */
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}    pr_StackSize;       /* Size of process stack in bytes           */
    @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}    pr_GlobVec;         /* Global vector for this process (BCPL)    */
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}    pr_TaskNum;         /* CLI task number of zero if not a CLI     */
    @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130}    pr_StackBase;       /* Ptr to high memory end of process stack  */
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}    pr_Result2;         /* Value of secondary result from last call */
    @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130}    pr_CurrentDir;      /* Lock associated with current directory   */
    @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130}    pr_CIS;             /* Current CLI Input Stream                 */
    @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130}    pr_COS;             /* Current CLI Output Stream                */
    @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}    pr_ConsoleTask;     /* Console handler process for current window*/
    @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}    pr_FileSystemTask;  /* File handler process for current drive   */
    @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130}    pr_CLI;             /* pointer to CommandLineInterface          */
    @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}    pr_ReturnAddr;      /* pointer to previous stack frame          */
    @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}    pr_PktWait;         /* Function to be called when awaiting msg  */
    @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}    pr_WindowPtr;       /* Window for error printing                */

    /* following definitions are new with 2.0 */
    @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130}    pr_HomeDir;         /* Home directory of executing program      */
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}    pr_Flags;           /* flags telling dos about process          */
    void    (*pr_ExitCode)();   /* code to call on exit of program or @{"NULL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 101}  */
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}    pr_ExitData;        /* Passed as an argument to pr_ExitCode.    */
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   *pr_Arguments;      /* Arguments passed to the process at start */
    @{"struct MinList" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 31} pr_LocalVars; /* Local environment variables             */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   pr_ShellPrivate;    /* for the use of the current shell         */
    @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130}    pr_CES;             /* Error stream - if @{"NULL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 101}, use pr_COS       */
};  /* Process */

/*
 * Flags for pr_Flags
 */
#define PRB_FREESEGLIST         0
#define PRF_FREESEGLIST         1
#define PRB_FREECURRDIR         1
#define PRF_FREECURRDIR         2
#define PRB_FREECLI             2
#define PRF_FREECLI             4
#define PRB_CLOSEINPUT          3
#define PRF_CLOSEINPUT          8
#define PRB_CLOSEOUTPUT         4
#define PRF_CLOSEOUTPUT         16
#define PRB_FREEARGS            5
#define PRF_FREEARGS            32

/* The long word address (@{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130}) of this structure is returned by
 * @{"Open()" LINK "gg:doc/NDK/Guide/dos/Open"} and other routines that return a file.  You need only worry
 * about this struct to do async io's via @{"PutMsg()" LINK "gg:doc/NDK/Guide/exec/PutMsg"} instead of
 * standard file system calls */

struct FileHandle {
   @{"struct Message" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 47} *fh_Link;      /* EXEC message              */
   @{"struct MsgPort" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 28} *fh_Port;      /* Reply port for the packet */
   @{"struct MsgPort" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 28} *fh_Type;      /* Port to do @{"PutMsg()" LINK "gg:doc/NDK/Guide/exec/PutMsg"} to
                                  * Address is negative if a plain file */
   @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} fh_Buf;
   @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} fh_Pos;
   @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} fh_End;
   @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} fh_Funcs;
#define fh_Func1 fh_Funcs
   @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} fh_Func2;
   @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} fh_Func3;
   @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} fh_Args;
#define fh_Arg1 fh_Args
   @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} fh_Arg2;
}; /* FileHandle */

/* This is the extension to EXEC Messages used by DOS */

struct DosPacket {
   @{"struct Message" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 47} *dp_Link;      /* EXEC message              */
   @{"struct MsgPort" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 28} *dp_Port;      /* Reply port for the packet */
                                 /* Must be filled in each send. */
   @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} dp_Type;                 /* See ACTION_... below and
                                  * 'R' means Read, 'W' means Write to the
                                  * file system */
   @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} dp_Res1;                 /* For file system calls this is the result
                                  * that would have been returned by the
                                  * function, e.g. @{"Write" LINK "gg:doc/NDK/Guide/dos/Write"} ('W') returns actual
                                  * length written */
   @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} dp_Res2;                 /* For file system calls this is what would
                                  * have been returned by @{"IoErr()" LINK "gg:doc/NDK/Guide/dos/IoErr"} */
/*  Device packets common equivalents */
#define dp_Action  dp_Type
#define dp_Status  dp_Res1
#define dp_Status2 dp_Res2
#define dp_BufAddr dp_Arg1
   @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} dp_Arg1;
   @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} dp_Arg2;
   @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} dp_Arg3;
   @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} dp_Arg4;
   @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} dp_Arg5;
   @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} dp_Arg6;
   @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} dp_Arg7;
}; /* DosPacket */

/* A Packet does not require the Message to be before it in memory, but
 * for convenience it is useful to associate the two.
 * Also see the function init_std_pkt for initializing this structure */

struct StandardPacket {
   @{"struct Message" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 47}   sp_Msg;
   @{"struct DosPacket" LINK File 108} sp_Pkt;
}; /* StandardPacket */

/* Packet types */
#define ACTION_NIL              0
#define ACTION_STARTUP          0
#define ACTION_GET_BLOCK        2       /* OBSOLETE */
#define ACTION_SET_MAP          4
#define ACTION_DIE              5
#define ACTION_EVENT            6
#define ACTION_CURRENT_VOLUME   7
#define ACTION_LOCATE_OBJECT    8
#define ACTION_RENAME_DISK      9
#define ACTION_WRITE            'W'
#define ACTION_READ             'R'
#define ACTION_FREE_LOCK        15
#define ACTION_DELETE_OBJECT    16
#define ACTION_RENAME_OBJECT    17
#define ACTION_MORE_CACHE       18
#define ACTION_COPY_DIR         19
#define ACTION_WAIT_CHAR        20
#define ACTION_SET_PROTECT      21
#define ACTION_CREATE_DIR       22
#define ACTION_EXAMINE_OBJECT   23
#define ACTION_EXAMINE_NEXT     24
#define ACTION_DISK_INFO        25
#define ACTION_INFO             26
#define ACTION_FLUSH            27
#define ACTION_SET_COMMENT      28
#define ACTION_PARENT           29
#define ACTION_TIMER            30
#define ACTION_INHIBIT          31
#define ACTION_DISK_TYPE        32
#define ACTION_DISK_CHANGE      33
#define ACTION_SET_DATE         34

#define ACTION_SCREEN_MODE      994

#define ACTION_READ_RETURN      1001
#define ACTION_WRITE_RETURN     1002
#define ACTION_SEEK             1008
#define ACTION_FINDUPDATE       1004
#define ACTION_FINDINPUT        1005
#define ACTION_FINDOUTPUT       1006
#define ACTION_END              1007
#define ACTION_SET_FILE_SIZE    1022    /* fast file system only in 1.3 */
#define ACTION_WRITE_PROTECT    1023    /* fast file system only in 1.3 */

/* new 2.0 packets */
#define ACTION_SAME_LOCK        40
#define ACTION_CHANGE_SIGNAL    995
#define ACTION_FORMAT           1020
#define ACTION_MAKE_LINK        1021
/**/
/**/
#define ACTION_READ_LINK        1024
#define ACTION_FH_FROM_LOCK     1026
#define ACTION_IS_FILESYSTEM    1027
#define ACTION_CHANGE_MODE      1028
/**/
#define ACTION_COPY_DIR_FH      1030
#define ACTION_PARENT_FH        1031
#define ACTION_EXAMINE_ALL      1033
#define ACTION_EXAMINE_FH       1034

#define ACTION_LOCK_RECORD      2008
#define ACTION_FREE_RECORD      2009

#define ACTION_ADD_NOTIFY       4097
#define ACTION_REMOVE_NOTIFY    4098

/* Added in V39: */
#define ACTION_EXAMINE_ALL_END  1035
#define ACTION_SET_OWNER        1036

/* Tell a file system to serialize the current volume. This is typically
 * done by changing the creation date of the disk. This packet does not take
 * any arguments.  NOTE: be prepared to handle failure of this packet for
 * V37 ROM filesystems.
 */
#define ACTION_SERIALIZE_DISK   4200

/*
 * A structure for holding error messages - stored as array with error == 0
 * for the last entry.
 */
struct ErrorString {
        @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}  *estr_Nums;
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} *estr_Strings;
};

/* DOS library node structure.
 * This is the data at positive offsets from the library node.
 * Negative offsets from the node is the jump table to DOS functions
 * node = (@{"struct DosLibrary" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 237} *) @{"OpenLibrary" LINK "gg:doc/NDK/Guide/exec/OpenLibrary"}( "@{"dos.library" LINK "gg:doc/NDK/Guide/dos/MAIN"}" .. )      */

struct DosLibrary {
    @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34} dl_lib;
    @{"struct RootNode" LINK File 252} *dl_Root; /* Pointer to RootNode, described below */
    @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}    dl_GV;            /* Pointer to BCPL global vector        */
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}    dl_A2;            /* BCPL standard register values        */
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}    dl_A5;
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}    dl_A6;
    @{"struct ErrorString" LINK File 227} *dl_Errors;        /* PRIVATE pointer to array of error msgs */
    @{"struct timerequest" LINK "gg:doc/NDK/Guide/Include/devices/timer.h/File" 40} *dl_TimeReq;       /* PRIVATE pointer to timer request */
    @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34}     *dl_UtilityBase;   /* PRIVATE ptr to utility library */
    @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34}     *dl_IntuitionBase; /* PRIVATE ptr to intuition library */
};  /*  DosLibrary */

/*                             */

struct RootNode {
    @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130}    rn_TaskArray;            /* [0] is max number of CLI's
                                      * [1] is @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} to process id of CLI 1
                                      * [n] is @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} to process id of CLI n */
    @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130}    rn_ConsoleSegment; /* SegList for the CLI                      */
    @{"struct  DateStamp" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 52} rn_Time; /* Current time                             */
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}    rn_RestartSeg;     /* SegList for the disk validator process   */
    @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130}    rn_Info;           /* Pointer to the Info structure            */
    @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130}    rn_FileHandlerSegment; /* segment for a file handler           */
    @{"struct MinList" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 31} rn_CliList; /* new list of all CLI processes */
                               /* the first cpl_Array is also rn_TaskArray */
    @{"struct MsgPort" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 28} *rn_BootProc; /* private ptr to msgport of boot fs      */
    @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130}    rn_ShellSegment;   /* seglist for Shell (for NewShell)         */
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}    rn_Flags;          /* dos flags */
};  /* RootNode */

#define RNB_WILDSTAR    24
#define RNF_WILDSTAR    (1L<<24)
#define RNB_PRIVATE1    1       /* private for dos */
#define RNF_PRIVATE1    2

/* ONLY to be allocated by DOS! */
struct CliProcList {
        @{"struct MinNode" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 31} cpl_Node;
        @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} cpl_First;      /* number of first entry in array */
        @{"struct MsgPort" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 28} **cpl_Array;
                             /* [0] is max number of CLI's in this entry (n)
                              * [1] is @{"CPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 85} to process id of CLI cpl_First
                              * [n] is @{"CPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 85} to process id of CLI cpl_First+n-1
                              */
};

struct DosInfo {
    @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130}    di_McName;         /* PRIVATE: system resident module list      */
#define di_ResList di_McName
    @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130}    di_DevInfo;        /* Device List                               */
    @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130}    di_Devices;        /* Currently zero                            */
    @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130}    di_Handlers;       /* Currently zero                            */
    @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}    di_NetHand;        /* Network handler processid; currently zero */
    @{"struct  SignalSemaphore" LINK "gg:doc/NDK/Guide/Include/exec/semaphores.h/File" 40} di_DevLock;    /* do @{"NOT" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 1500} access directly! */
    @{"struct  SignalSemaphore" LINK "gg:doc/NDK/Guide/Include/exec/semaphores.h/File" 40} di_EntryLock;  /* do @{"NOT" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 1500} access directly! */
    @{"struct  SignalSemaphore" LINK "gg:doc/NDK/Guide/Include/exec/semaphores.h/File" 40} di_DeleteLock; /* do @{"NOT" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 1500} access directly! */
};  /* DosInfo */

/* structure for the Dos resident list.  Do @{"NOT" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 1500} allocate these, use       */
/* @{"AddSegment()" LINK "gg:doc/NDK/Guide/dos/AddSegment"}, and heed the warnings in the autodocs!                   */

struct Segment {
        @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} seg_Next;
        @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} seg_UC;
        @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} seg_Seg;
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} seg_Name[4];      /* actually the first 4 chars of @{"BSTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 131} name */
};

#define CMD_SYSTEM      -1
#define CMD_INTERNAL    -2
#define CMD_DISABLED    -999


/* DOS Processes started from the CLI via RUN or NEWCLI have this additional
 * set to data associated with them */

struct CommandLineInterface {
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}   cli_Result2;        /* Value of @{"IoErr" LINK "gg:doc/NDK/Guide/dos/IoErr"} from last command        */
    @{"BSTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 131}   cli_SetName;        /* Name of current directory               */
    @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130}   cli_CommandDir;     /* Head of the path locklist               */
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}   cli_ReturnCode;     /* Return code from last command           */
    @{"BSTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 131}   cli_CommandName;    /* Name of current command                 */
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}   cli_FailLevel;      /* Fail level (set by FAILAT)              */
    @{"BSTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 131}   cli_Prompt;         /* Current prompt (set by PROMPT)          */
    @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130}   cli_StandardInput;  /* Default (terminal) CLI input            */
    @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130}   cli_CurrentInput;   /* Current CLI input                       */
    @{"BSTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 131}   cli_CommandFile;    /* Name of EXECUTE command file            */
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}   cli_Interactive;    /* Boolean; True if prompts required       */
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}   cli_Background;     /* Boolean; True if CLI created by RUN     */
    @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130}   cli_CurrentOutput;  /* Current CLI output                      */
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}   cli_DefaultStack;   /* Stack size to be obtained in long words */
    @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130}   cli_StandardOutput; /* Default (terminal) CLI output           */
    @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130}   cli_Module;         /* SegList of currently loaded command     */
};  /* CommandLineInterface */

/* This structure can take on different values depending on whether it is
 * a device, an assigned directory, or a volume.  Below is the structure
 * reflecting volumes only.  Following that is the structure representing
 * only devices. Following that is the unioned structure representing all
 * the values
 */

/* structure representing a volume */

struct DeviceList {
    @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130}                dl_Next;        /* bptr to next device list */
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}                dl_Type;        /* see DLT below */
    @{"struct MsgPort" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 28} *    dl_Task;        /* ptr to handler task */
    @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130}                dl_Lock;        /* not for volumes */
    @{"struct DateStamp" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 52}    dl_VolumeDate;  /* creation date */
    @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130}                dl_LockList;    /* outstanding locks */
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}                dl_DiskType;    /* 'DOS', etc */
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}                dl_unused;
    @{"BSTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 131}                dl_Name;        /* bptr to bcpl name */
};

/* device structure (same as the DeviceNode structure in filehandler.h) */

struct        DevInfo {
    @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130}  dvi_Next;
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}  dvi_Type;
    @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}  dvi_Task;
    @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130}  dvi_Lock;
    @{"BSTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 131}  dvi_Handler;
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}  dvi_StackSize;
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}  dvi_Priority;
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}  dvi_Startup;
    @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130}  dvi_SegList;
    @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130}  dvi_GlobVec;
    @{"BSTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 131}  dvi_Name;
};

/* combined structure for devices, assigned directories, volumes */

struct DosList {
    @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130}                dol_Next;        /* bptr to next device on list */
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}                dol_Type;        /* see DLT below */
    @{"struct MsgPort" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 28}     *dol_Task;        /* ptr to handler task */
    @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130}                dol_Lock;
    union
        struct
        @{"BSTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 131}    dol_Handler;    /* file name to load if seglist is null */
        @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}    dol_StackSize;  /* stacksize to use when starting process */
        @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}    dol_Priority;   /* task priority when starting process */
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   dol_Startup;    /* startup msg: FileSysStartupMsg for disks */
        @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130}    dol_SegList;    /* already loaded code for new task */
        @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130}    dol_GlobVec;    /* BCPL global vector to use when starting
                                 * a process. -1 indicates a C/Assembler
                                 * program. */
        } dol_handler;

        struct
        @{"struct DateStamp" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 52}        dol_VolumeDate;  /* creation date */
        @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130}                    dol_LockList;    /* outstanding locks */
        @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}                    dol_DiskType;    /* 'DOS', etc */
        } dol_volume;

        struct
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   *dol_AssignName;     /* name for non-or-late-binding assign */
        @{"struct AssignList" LINK File 407} *dol_List; /* for multi-directory assigns (regular) */
        } dol_assign;

    } dol_misc;

    @{"BSTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 131}                dol_Name;        /* bptr to bcpl name */
    };

/* structure used for multi-directory assigns. @{"AllocVec()" LINK "gg:doc/NDK/Guide/exec/AllocVec"}ed. */

struct AssignList {
        struct AssignList *al_Next;
        @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130}               al_Lock;
};

/* definitions for dl_Type */
#define DLT_DEVICE      0
#define DLT_DIRECTORY   1       /* assign */
#define DLT_VOLUME      2
#define DLT_LATE        3       /* late-binding assign */
#define DLT_NONBINDING  4       /* non-binding assign */
#define DLT_PRIVATE     -1      /* for internal use only */

/* structure return by @{"GetDeviceProc()" LINK "gg:doc/NDK/Guide/dos/GetDeviceProc"} */
struct DevProc {
        @{"struct MsgPort" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 28} *dvp_Port;
        @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130}            dvp_Lock;
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}           dvp_Flags;
        @{"struct DosList" LINK File 372} *dvp_DevNode;    /* DON'T TOUCH OR USE! */
};

/* definitions for dvp_Flags */
#define DVPB_UNLOCK     0
#define DVPF_UNLOCK     (1L << @{"DVPB_UNLOCK" LINK File 429})     /* PRIVATE! */
#define DVPB_ASSIGN     1
#define DVPF_ASSIGN     (1L << @{"DVPB_ASSIGN" LINK File 431})

/* Flags to be passed to @{"LockDosList()" LINK "gg:doc/NDK/Guide/dos/LockDosList"}, etc */
#define LDB_DEVICES     2
#define LDF_DEVICES     (1L << @{"LDB_DEVICES" LINK File 435})
#define LDB_VOLUMES     3
#define LDF_VOLUMES     (1L << @{"LDB_VOLUMES" LINK File 437})
#define LDB_ASSIGNS     4
#define LDF_ASSIGNS     (1L << @{"LDB_ASSIGNS" LINK File 439})
#define LDB_ENTRY       5
#define LDF_ENTRY       (1L << @{"LDB_ENTRY" LINK File 441})
#define LDB_DELETE      6
#define LDF_DELETE      (1L << @{"LDB_DELETE" LINK File 443})

/* you MUST specify one of @{"LDF_READ" LINK File 448} or @{"LDF_WRITE" LINK File 450} */
#define LDB_READ        0
#define LDF_READ        (1L << @{"LDB_READ" LINK File 447})
#define LDB_WRITE       1
#define LDF_WRITE       (1L << @{"LDB_WRITE" LINK File 449})

/* actually all but @{"LDF_ENTRY" LINK File 442} (which is used for internal locking) */
#define LDF_ALL         (@{"LDF_DEVICES" LINK File 436}|@{"LDF_VOLUMES" LINK File 438}|@{"LDF_ASSIGNS" LINK File 440})

/* a lock structure, as returned by @{"Lock()" LINK "gg:doc/NDK/Guide/dos/Lock"} or @{"DupLock()" LINK "gg:doc/NDK/Guide/dos/DupLock"} */
struct FileLock {
    @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130}                fl_Link;        /* bcpl pointer to next lock */
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}                fl_Key;         /* disk block number */
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}                fl_Access;      /* exclusive or shared */
    @{"struct MsgPort" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 28} *    fl_Task;        /* handler task's port */
    @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130}                fl_Volume;      /* bptr to @{"DLT_VOLUME" LINK File 415} DosList entry */
};

/* error report types for @{"ErrorReport()" LINK "gg:doc/NDK/Guide/dos/ErrorReport"} */
#define REPORT_STREAM           0       /* a stream */
#define REPORT_TASK             1       /* a process - unused */
#define REPORT_LOCK             2       /* a lock */
#define REPORT_VOLUME           3       /* a volume node */
#define REPORT_INSERT           4       /* please insert volume */

/* Special error codes for @{"ErrorReport()" LINK "gg:doc/NDK/Guide/dos/ErrorReport"} */
#define ABORT_DISK_ERROR        296     /* Read/write error */
#define ABORT_BUSY              288     /* You MUST replace... */

/* types for initial packets to shells from run/newcli/execute/system. */
/* For shell-writers only */
#define RUN_EXECUTE             -1
#define RUN_SYSTEM              -2
#define RUN_SYSTEM_ASYNCH       -3

/* Types for fib_DirEntryType.  NOTE that both USERDIR and ROOT are      */
/* directories, and that directory/file checks should use <0 and >=0.    */
/* This is not necessarily exhaustive!  Some handlers may use other      */
/* values as needed, though <0 and >=0 should remain as supported as     */
/* possible.                                                             */
#define ST_ROOT         1
#define ST_USERDIR      2
#define ST_SOFTLINK     3       /* looks like dir, but may point to a file! */
#define ST_LINKDIR      4       /* hard link to dir */
#define ST_FILE         -3      /* must be negative for FIB! */
#define ST_LINKFILE     -4      /* hard link to file */
#define ST_PIPEFILE     -5      /* for pipes that support @{"ExamineFH" LINK "gg:doc/NDK/Guide/dos/ExamineFH"} */

#endif  /* DOS_DOSEXTENS_H */
@ENDNODE
