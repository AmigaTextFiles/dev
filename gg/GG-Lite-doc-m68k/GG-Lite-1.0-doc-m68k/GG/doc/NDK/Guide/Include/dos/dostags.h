@DATABASE "gg:doc/NDK/Guide/Include/dos/dostags.h"
@MASTER   "gg:os-include/dos/dostags.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:13:00
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "dos/dostags.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"dos/dostags.h" LINK File}


@{b}#defines@{ub}

@{"ADO_CommFileLen" LINK "gg:doc/NDK/Guide/Include/dos/dostags.h/File" 129}   @{"ADO_CommNameLen" LINK "gg:doc/NDK/Guide/Include/dos/dostags.h/File" 127}  @{"ADO_DirLen" LINK "gg:doc/NDK/Guide/Include/dos/dostags.h/File" 125}      @{"ADO_Dummy" LINK "gg:doc/NDK/Guide/Include/dos/dostags.h/File" 112}
@{"ADO_FH_Mode" LINK "gg:doc/NDK/Guide/Include/dos/dostags.h/File" 113}       @{"ADO_PromptLen" LINK "gg:doc/NDK/Guide/Include/dos/dostags.h/File" 131}    @{"NP_Arguments" LINK "gg:doc/NDK/Guide/Include/dos/dostags.h/File" 87}    @{"NP_Cli" LINK "gg:doc/NDK/Guide/Include/dos/dostags.h/File" 80}
@{"NP_CloseError" LINK "gg:doc/NDK/Guide/Include/dos/dostags.h/File" 61}     @{"NP_CloseInput" LINK "gg:doc/NDK/Guide/Include/dos/dostags.h/File" 53}    @{"NP_CloseOutput" LINK "gg:doc/NDK/Guide/Include/dos/dostags.h/File" 56}  @{"NP_CommandName" LINK "gg:doc/NDK/Guide/Include/dos/dostags.h/File" 85}
@{"NP_ConsoleTask" LINK "gg:doc/NDK/Guide/Include/dos/dostags.h/File" 72}    @{"NP_CopyVars" LINK "gg:doc/NDK/Guide/Include/dos/dostags.h/File" 78}      @{"NP_CurrentDir" LINK "gg:doc/NDK/Guide/Include/dos/dostags.h/File" 64}   @{"NP_Dummy" LINK "gg:doc/NDK/Guide/Include/dos/dostags.h/File" 40}
@{"NP_Entry" LINK "gg:doc/NDK/Guide/Include/dos/dostags.h/File" 46}          @{"NP_Error" LINK "gg:doc/NDK/Guide/Include/dos/dostags.h/File" 59}         @{"NP_ExitCode" LINK "gg:doc/NDK/Guide/Include/dos/dostags.h/File" 102}     @{"NP_ExitData" LINK "gg:doc/NDK/Guide/Include/dos/dostags.h/File" 104}
@{"NP_FreeSeglist" LINK "gg:doc/NDK/Guide/Include/dos/dostags.h/File" 43}    @{"NP_HomeDir" LINK "gg:doc/NDK/Guide/Include/dos/dostags.h/File" 76}       @{"NP_Input" LINK "gg:doc/NDK/Guide/Include/dos/dostags.h/File" 49}        @{"NP_Name" LINK "gg:doc/NDK/Guide/Include/dos/dostags.h/File" 68}
@{"NP_NotifyOnDeath" LINK "gg:doc/NDK/Guide/Include/dos/dostags.h/File" 95}  @{"NP_Output" LINK "gg:doc/NDK/Guide/Include/dos/dostags.h/File" 51}        @{"NP_Path" LINK "gg:doc/NDK/Guide/Include/dos/dostags.h/File" 82}         @{"NP_Priority" LINK "gg:doc/NDK/Guide/Include/dos/dostags.h/File" 70}
@{"NP_Seglist" LINK "gg:doc/NDK/Guide/Include/dos/dostags.h/File" 41}        @{"NP_StackSize" LINK "gg:doc/NDK/Guide/Include/dos/dostags.h/File" 66}     @{"NP_Synchronous" LINK "gg:doc/NDK/Guide/Include/dos/dostags.h/File" 98}  @{"NP_WindowPtr" LINK "gg:doc/NDK/Guide/Include/dos/dostags.h/File" 74}
@{"SYS_Asynch" LINK "gg:doc/NDK/Guide/Include/dos/dostags.h/File" 27}        @{"SYS_CustomShell" LINK "gg:doc/NDK/Guide/Include/dos/dostags.h/File" 31}  @{"SYS_Dummy" LINK "gg:doc/NDK/Guide/Include/dos/dostags.h/File" 22}       @{"SYS_Input" LINK "gg:doc/NDK/Guide/Include/dos/dostags.h/File" 23}
@{"SYS_Output" LINK "gg:doc/NDK/Guide/Include/dos/dostags.h/File" 25}        @{"SYS_UserShell" LINK "gg:doc/NDK/Guide/Include/dos/dostags.h/File" 29}    

@ENDNODE
@NODE File "dos/dostags.h"
#ifndef DOS_DOSTAGS_H
#define DOS_DOSTAGS_H
/*
**
**      $VER: dostags.h 36.11 (29.4.1991)
**      Includes Release 45.1
**
**      Tag definitions for all Dos routines using tags
**
**      (C) Copyright 1989-2001 Amiga, Inc.
**          All Rights Reserved
**
*/

#ifndef UTILITY_TAGITEM_H
#include <@{"utility/tagitem.h" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File"}>
#endif

/*****************************************************************************/
/* definitions for the @{"System()" LINK "gg:doc/NDK/Guide/dos/SystemTagList"} call */

#define SYS_Dummy       (@{"TAG_USER" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 48} + 32)
#define SYS_Input       (@{"SYS_Dummy" LINK File 22} + 1)
                                /* specifies the input filehandle  */
#define SYS_Output      (@{"SYS_Dummy" LINK File 22} + 2)
                                /* specifies the output filehandle */
#define SYS_Asynch      (@{"SYS_Dummy" LINK File 22} + 3)
                                /* run asynch, close input/output on exit(!) */
#define SYS_UserShell   (@{"SYS_Dummy" LINK File 22} + 4)
                                /* send to user shell instead of boot shell */
#define SYS_CustomShell (@{"SYS_Dummy" LINK File 22} + 5)
                                /* send to a specific shell (data is name) */
/*      SYS_Error, */


/*****************************************************************************/
/* definitions for the @{"CreateNewProc()" LINK "gg:doc/NDK/Guide/dos/CreateNewProc"} call */
/* you MUST specify one of @{"NP_Seglist" LINK File 41} or @{"NP_Entry" LINK File 46}.  All else is optional. */

#define NP_Dummy (@{"TAG_USER" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 48} + 1000)
#define NP_Seglist      (@{"NP_Dummy" LINK File 40} + 1)
                                /* seglist of code to run for the process  */
#define NP_FreeSeglist  (@{"NP_Dummy" LINK File 40} + 2)
                                /* free seglist on exit - only valid for   */
                                /* for @{"NP_Seglist" LINK File 41}.  Default is @{"TRUE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 95}.       */
#define NP_Entry        (@{"NP_Dummy" LINK File 40} + 3)
                                /* entry point to run - mutually exclusive */
                                /* with @{"NP_Seglist" LINK File 41}! */
#define NP_Input        (@{"NP_Dummy" LINK File 40} + 4)
                                /* filehandle - default is @{"Open" LINK "gg:doc/NDK/Guide/dos/Open"}("NIL:"...) */
#define NP_Output       (@{"NP_Dummy" LINK File 40} + 5)
                                /* filehandle - default is @{"Open" LINK "gg:doc/NDK/Guide/dos/Open"}("NIL:"...) */
#define NP_CloseInput   (@{"NP_Dummy" LINK File 40} + 6)
                                /* close input filehandle on exit          */
                                /* default @{"TRUE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 95}                            */
#define NP_CloseOutput  (@{"NP_Dummy" LINK File 40} + 7)
                                /* close output filehandle on exit         */
                                /* default @{"TRUE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 95}                            */
#define NP_Error        (@{"NP_Dummy" LINK File 40} + 8)
                                /* filehandle - default is @{"Open" LINK "gg:doc/NDK/Guide/dos/Open"}("NIL:"...) */
#define NP_CloseError   (@{"NP_Dummy" LINK File 40} + 9)
                                /* close error filehandle on exit          */
                                /* default @{"TRUE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 95}                            */
#define NP_CurrentDir   (@{"NP_Dummy" LINK File 40} + 10)
                                /* lock - default is parent's current dir  */
#define NP_StackSize    (@{"NP_Dummy" LINK File 40} + 11)
                                /* stacksize for process - default 4000    */
#define NP_Name         (@{"NP_Dummy" LINK File 40} + 12)
                                /* name for process - default "New Process"*/
#define NP_Priority     (@{"NP_Dummy" LINK File 40} + 13)
                                /* priority - default same as parent       */
#define NP_ConsoleTask  (@{"NP_Dummy" LINK File 40} + 14)
                                /* consoletask - default same as parent    */
#define NP_WindowPtr    (@{"NP_Dummy" LINK File 40} + 15)
                                /* window ptr - default is same as parent  */
#define NP_HomeDir      (@{"NP_Dummy" LINK File 40} + 16)
                                /* home directory - default curr home dir  */
#define NP_CopyVars     (@{"NP_Dummy" LINK File 40} + 17)
                                /* boolean to copy local vars-default @{"TRUE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 95} */
#define NP_Cli          (@{"NP_Dummy" LINK File 40} + 18)
                                /* create cli structure - default @{"FALSE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 98}    */
#define NP_Path         (@{"NP_Dummy" LINK File 40} + 19)
                                /* path - default is copy of parents path  */
                                /* only valid if a cli process!    */
#define NP_CommandName  (@{"NP_Dummy" LINK File 40} + 20)
                                /* commandname - valid only for CLI        */
#define NP_Arguments    (@{"NP_Dummy" LINK File 40} + 21)
/* cstring of arguments - passed with str in a0, length in d0.  */
/* (copied and freed on exit.)  Default is 0-length @{"NULL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 101} ptr.   */
/* NOTE: not operational until V37 - see BIX/TechNotes for      */
/* more info/workaround.  In V36, the registers were random.    */
/* You must NEVER use @{"NP_Arguments" LINK File 87} with a @{"NP_Input" LINK File 49} of @{"NULL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 101}.     */

/* FIX! should this be only for cli's? */
#define NP_NotifyOnDeath (@{"NP_Dummy" LINK File 40} + 22)
                                /* notify parent on death - default @{"FALSE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 98}  */
                                /* Not functional yet. */
#define NP_Synchronous  (@{"NP_Dummy" LINK File 40} + 23)
                                /* don't return until process finishes -   */
                                /* default @{"FALSE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 98}.                          */
                                /* Not functional yet. */
#define NP_ExitCode     (@{"NP_Dummy" LINK File 40} + 24)
                                /* code to be called on process exit       */
#define NP_ExitData     (@{"NP_Dummy" LINK File 40} + 25)
                                /* optional argument for NP_EndCode rtn -  */
                                /* default @{"NULL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 101}                            */


/*****************************************************************************/
/* tags for @{"AllocDosObject" LINK "gg:doc/NDK/Guide/dos/AllocDosObject"} */

#define ADO_Dummy       (@{"TAG_USER" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 48} + 2000)
#define ADO_FH_Mode     (@{"ADO_Dummy" LINK File 112} + 1)
                                /* for type @{"DOS_FILEHANDLE" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 273} only            */
                                /* sets up FH for mode specified.
                                   This can make a big difference for buffered
                                   files.                                  */
        /* The following are for @{"DOS_CLI" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 277} */
        /* If you do not specify these, dos will use it's preferred values */
        /* which may change from release to release.  The BPTRs to these   */
        /* will be set up correctly for you.  Everything will be zero,     */
        /* except cli_FailLevel (10) and cli_Background (@{"DOSTRUE" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 22}).         */
        /* NOTE: you may also use these 4 tags with @{"CreateNewProc" LINK "gg:doc/NDK/Guide/dos/CreateNewProc"}.         */

#define ADO_DirLen      (@{"ADO_Dummy" LINK File 112} + 2)
                                /* size in bytes for current dir buffer    */
#define ADO_CommNameLen (@{"ADO_Dummy" LINK File 112} + 3)
                                /* size in bytes for command name buffer   */
#define ADO_CommFileLen (@{"ADO_Dummy" LINK File 112} + 4)
                                /* size in bytes for command file buffer   */
#define ADO_PromptLen   (@{"ADO_Dummy" LINK File 112} + 5)
                                /* size in bytes for the prompt buffer     */

/*****************************************************************************/
/* tags for @{"NewLoadSeg" LINK "gg:doc/NDK/Guide/dos/NewLoadSeg"} */
/* no tags are defined yet for @{"NewLoadSeg" LINK "gg:doc/NDK/Guide/dos/NewLoadSeg"} */

#endif /* DOS_DOSTAGS_H */
@ENDNODE
