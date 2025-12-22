********************************************************************************
*
*       Program:        startup
*       Filename:       startup.i
*
*       Contents:       AMIGA startup code (description below)
*
*       Language:       68000 Assembler
*
*       Author:         Johannes R. Geiss
*
*       Copyright:      Amigavisions & Commodore-Amiga, Inc.
*
*       History:        $HISTORY:
*                       1.2 (26-Oct-91) changed JRG
*                       1.1 (15-Oct-91) changed JRG
*                       1.0 (13-Oct-91) written JRG
*
*       Version:        $VER: startup.i 1.2 (26-Oct-91)
*
********************************************************************************
*
*       Description:
*
* Conditional assembly flags:
*       ASTART: 1=Standard Globals Defined      0=Reentrant Only
*       WINDOW: 1=AppWindow for WB startup      0=No AppWindow code
*       XNIL:   1=Remove startup NIL: init      0=Default Nil: WB Output
*       NARGS:  1=argv[0] only                  0=Normal cmd line arg parse
*       DEBUG:  1=Set up old statics for Wack   0=No extra statics
*       QARG:   1=No argv                       0=Passes argc,argv
*
* Flags for   Astart  AWstart Rstart  RWstart RXstart Qstart  Nstart  Dstart
*  ASTART       1       1       0       0       0       0       1       1
*  WINDOW       0       1       0       1       0       0       0       0
*  XNIL         0       0       0       0       1       1       0       0
*  NARGS        0       0       0       0       0       0       1       0
*  DEBUG        0       0       0       0       0       0       0       1
*  QARG         0       0       0       0       0       1       0       0
*
*  This startup dynamically allocates a structure which includes the argv
* buffers. If you use this startup, your code must return to this startup when
* it exits. Use exit(n) of final curly brace (rts) to return here. Do not use
* AmigaDOS Exit() function. Due this dynamic allocation and some code
* consolidation, this startup can make executables several hundred bytes
* smaller.
*
*  Because a static initialSP variable can not be used, this code depends on
* the fact that AmigaDOS places the address of the top of our stack in SP and
* proc->pr_ReturnAddr right before JSR'ing to us. This code uses
* pr_ReturnAddr when restoring SP.
*
*  Most versions of startup will initialize a Workbench process's input and
* output streams (and stdio globals if present) to NIL: if no other form of
* Workbench output (like WINDOW) is provided. This should help prevent crashes
* if a user puts an icon on a CLI program, and will also protect against care-
* less sdtio debugging or error messages left in a Workbench IO stream only
* be removed by assembling startup with ASTART and WINDOW set to 0, and XNIL
* set to 1.
*
*
* Some startups which can be conditionally assembled:
*
*  1. Standard Astartup for non-reentrant code
*  2. Reentrant Rstartup (no unshareable globals)
*  3. Smaller reentrant-only RXstartup (no NIL: WB init code)
*  4. Standard AWstartup (WB output window) for non-reentrant code
*  5. Reentrant RWstartup (WB output window, no unshareable globals)
*  6. Smallest Qstartup (No argv - argv is ptr to NULL string)
*  7. Standard Nstartup (no arguments, only command name)
*  8. Standard Dstartup (plus initialSP, dosCmdLen and dosCmdBuf)
*
*
* Explanation of conditional assembly flags:
*
*  ASTART (ASTART set 1) startups will set up and xdef the global variables
* _stdin, _stdout, _stderr and _WBenchMsg. These startups can be used
* as smaller replacements for startups like (A)startup.obj and TWstartup.obj.
* Startups with ASTART would generally be used for non-reentrant programs,
* although the startup code ifself is still reentrant if the globals are not
* referenced.
*  Reentrant (ASTART set 0) startups will NOT set up or xdef the sdtio and
* WBenchMsg globals. This not only makes the startup slightly smaller, but also
* lets you know if your code is referencing these non-reentrant globals (you
* will get an unresolved external reference when you link). Programs get their
* input and output handlers from Input() and Output(), and the WBenchMsg is
* passed in argv on Workbench startup.
*
*  WINDOW (WINDOW set 1) startups use an xref'd CON: string named AppWindow,
* defined in your application, to open a stdio console window when your
* application is started from Workbench. For non-reentrant programs, this
* window can be used for normal stdio (printf, getchar, etc). For reentrant
* programs the window is Input() and Output(). WINDOW is useful when adding
* other Workbench capability to a stdio application, and also for debugging
* other Workbench applications. To insure that applications requiring a window
* startup are linked with a window startup, the label _NeedWstartup can be
* externed and referenced in the application so that a linker error will occur
* if linked with a standard startup.
*
*       example:  /* Optional safety reference to NeedWstartup */
*                 extern UBYTE NeedWstartup;
*                 UBYTE *HaveWstartup = &NeedWstartup;
*                 /* Required window specification */
*                 char AppWindow[] = "CON:30/30/200/150/MyProgram";
*                 ( OR char AppWindow[] = "\0"; for no window)
*
*
*  XNIL (XNIL set 1) allows the creation of smaller startup by removing the
* code that initializes a Workbench process's output streams to NIL:. This flag
* can only remove the code if it is not required for ASTART or WINDOW.
*
*  NARGS (NARGS set 1) removes the code used to parse command line arguments.
* The command name is still passed to _main as argv[0]. This option can take
* about 120 bytes off the size of any program that does not use command line
* args.
*
*  DEBUG (DEBUG set 1) will cause the old startup.asm statics initialSP,
* dosCmdLen and dosCmdBuf to be defined and initialized by the startup code,
* for use as debugging symbols when using Wack.
*
*  QARG (QARG set 1) will bypass all argument parsing. A CLI startup is passed
* argc == 1, and a Workbench startup is passed argc == 0. argv[0] will be a
* pointer to the a NULL string rather than a pointer to the command name. This
* option creates a very small startup with no sVar structure allocation, and
* therefore must be used with XNIL (it is incompatible with default or
* AWindow output options).
*
*
* RULES FOR REENTRANT CODE
*
*       - Make no direct of indirect (printf, etc) references to the globals
*         _stdin, _stdout, _stderr, or _WBenchMsg.
*
*       - For stdio use either special versions of printf and getchar that
*         use Input() and Output() rather than _stdin and _stdout, or use
*         fprintf and fgetc with Input() and Output() file handlers.
*
*       - Workbench applications must get the pointer to the WBenchMsg from
*         argv rather than from global extern WBenchMsg.
*
*       - Use no global or static variables within your code. Instead, put
*         all formaer globals in a dynamically allocated structure, and pass
*         around a pointer to that structure. The only acceptable globals
*         are constants (message, strings, etc) and global copies of Library
*         Bases to resolve amiga.lib references. Your code must return all
*         OpenLibrary's into non-global variables, copy the result to the
*         global library base only if successful, and use the non-globals
*         when deciding whether to Close any opened libraries.
*
*
* ADDITIONAL NOTES
*
*       The original startup code printed in AMIGA ROM KERNEL REFERENCE MANUAL:
*       LIBRARY & DEVICES (V1.3) does not work with BLink Version 6.7.
*       Now this code works correctly. Furthermore I did a few improvements
*       for smaller and faster code.
*
*         THIS ASSEMBLY SOURCE AND OBJECT FILE IS FOR PRIVATE USE ONLY!
*
*                                                              Johannes R. Geiss
*
********************************************************************************
*
* EXAMPLE FOR A SOURCE CODE TO INVOKE THIS FILE:
*
*       *------ Equates
*       ASTART  set     1
*       WINDOW  set     0
*       XNIL    set     0
*       NARGS   set     0
*       DEBUG   set     0
*       QARG    set     0
*
*       *------ Includes
*               include 'startup.i'
*
********************************************************************************


        IFND STARTUP_I
STARTUP_I SET 1


*------ Includes
        include 'exec/types.i'
        include 'exec/alerts.i'
        include 'exec/memory.i'
        include 'libraries/dos.i'
        include 'libraries/dosextens.i'
        include 'workbench/startup.i'


*------ Macros
XLIB    MACRO
        xref    _LVO\1
        ENDM

CALLSYS MACRO
        jsr     _LVO\1(a6)
        ENDM

CALLEXE MACRO
        movea.l _SysBase,a6
        jsr     _LVO\1(a6)
        ENDM

CALLGFX MACRO
        movea.l _GfxBase,a6
        jsr     _LVO\1(a6)
        ENDM

CALLITU MACRO
        movea.l _IntuitionBase,a6
        jsr     _LVO\1(a6)
        ENDM

CALLDOS MACRO
        movea.l _DOSBase,a6
        jsr     _LVO\1(a6)
        ENDM

LINKSYS MACRO
        move.l  a6,-(a7)
        move.l  \2,a6
        jsr     _LVO\1(a6)
        move.l  (a7)+,a6
        ENDM

LINKEXE MACRO
        move.l  a6,-(a7)
        movea.l _SysBase,a6
        jsr     _LVO\1(a6)
        move.l  (a7)+,a6
        ENDM

LINKGFX MACRO
        move.l  a6,-(a7)
        movea.l _GfxBase,a6
        jsr     _LVO\1(a6)
        move.l  (a7)+,a6
        ENDM

LINKITU MACRO
        move.l  a6,-(a7)
        movea.l _IntuitionBase,a6
        jsr     _LVO\1(a6)
        move.l  (a7)+,a6
        ENDM

LINKDOS MACRO
        move.l  a6,-(a7)
        movea.l _DOSBase,a6
        jsr     _LVO\1(a6)
        move.l  (a7)+,a6
        ENDM


*------ Equates
WBOUT   set     (ASTART!WINDOW!(1-XNIL))

        IFEQ    QARG
ARGVSLOTS       equ     32
        STRUCTURE sVar,0
        LONG    sv_WbOutput
        STRUCT  sv_argvArray,ARGVSLOTS*4
        STRUCT  sv_argvBuffer,256
        LABEL   sv_SIZEOF
        ENDC


*------ Imports
        xref    _main           ; Entry point for C & assembly codes
        xref    _AbsExecBase

        IFGT    WINDOW
        xref    _AppWindow      ; CON: spec in application for WB stdio window
        xdef    _NeedWstartup   ; May be externed and referenced in application
        ENDC

        XLIB    Alert
        XLIB    AllocMem
        XLIB    FindTask
        XLIB    Forbid
        XLIB    FreeMem
        XLIB    GetMsg
        XLIB    OpenLibrary
        XLIB    CloseLibrary
        XLIB    ReplyMsg
        XLIB    Wait
        XLIB    WaitPort

        XLIB    CurrentDir
        XLIB    Open
        XLIB    Close
        XLIB    Input
        XLIB    Output


*------ Exports
        IFGT    ASTART
        xdef    _stdin
        xdef    _stdout
        xdef    _stderr
        xdef    _WBenchMsg
        ENDC

        xdef    _SysBase
        xdef    _DOSBase
        xdef    _exit           ; Exit point for C & assembly codes


********************************************************************************


        SECTION AsmStartup,CODE

*------ Standard Program Entry Point
*
* Input: d0.l dosCmdLen
*        a0.l dosCmdBuf

startup
        IFGT    DEBUG
        move.l  a7,initialSP
        move.l  d0,dosCmdLen
        move.l  a0,dosCmdBuf
        ENDC

        IFEQ    QARG
        move.l  d0,d2
        movea.l a0,a2
        ENDC

        movea.l _AbsExecBase,a6 ; get Exec library base pointer
        move.l  a6,_SysBase

        suba.l  a1,a1           ; get the address of our task
        CALLSYS FindTask
        movea.l d0,a4           ; keep task in a4

        moveq.l #33,d0          ; Get DOS library base pointer (version 33)
        lea     DOSName,a1      ; dos.library
        CALLSYS OpenLibrary
        move.l  d0,_DOSBase     ; set global
        beq     alertDOS        ; fail on null with alert

        IFEQ    QARG
        move.l  #sv_SIZEOF,d0   ; alloc the argument structure
        move.l  #(MEMF_PUBLIC!MEMF_CLEAR),d1
        CALLSYS AllocMem
        tst.l   d0
        beq     alertMem        ; fail on null with alert
        move.l  d0,-(a7)        ; save sVar ptr on stack
        movea.l d0,a5           ; sVar ptr to a5
        ENDC

        IFGT    QARG
        clr.l   -(a7)
        ENDC

        clr.l   -(a7)           ; reserve space for WBenchMsg if any
        move.l  pr_CLI(a4),d0   ; branch to Workbench startup code if not a
        beq     fromWorkbench   ; CLI process

*------ CLI startup code
        IFEQ    QARG
        lsl.l   #2,d0           ; find command name
        movea.l d0,a0
        move.l  cli_CommandName(a0),d0
        lsl.l   #2,d0
        lea     sv_argvBuffer(a5),a1    ; start argv array
        lea     sv_argvArray(a5),a3
        movea.l d0,a0           ; copy command name
        moveq.l #0,d0
        move.b  (a0)+,d0
        clr.b   0(a0,d0.l)      ; terminate the command name
        move.l  a0,(a3)+
        moveq.l #1,d3           ; start counting arguments
        IFEQ    NARGS
        lea     0(a2,d2.l),a0   ; null terminate the arguments, eat trailing
strjunk cmpi.b  #$20,-(a0)      ; control characters
        dbhi    d2,strjunk
        clr.b   1(a0)
newarg  move.b  (a2)+,d1        ; start gathering arguments into buffer
        beq.s   paramExit       ; skip spaces
        cmpi.b  #$20,d1
        beq.s   newarg
        cmpi.b  #9,d1           ; tab
        beq.s   newarg
        cmpi.w  #ARGVSLOTS-1,d3 ; check for argument count overflow
        beq.s   paramExit
        move.l  a1,(a3)+        ; push address of the next parameter
        addq.w  #1,d3
        cmpi.b  #34,d1          ; process quotes
        beq.s   doquote
        move.b  d1,(a1)+        ; copy the parameter in
nextchr move.b  (a2)+,d1        ; null termination check
        beq.s   paramExit
        cmpi.b  #$20,d1
        beq.s   endarg
        move.b  d1,(a1)+
        bra.s   nextchr
endarg  clr.b   (a1)+
        bra.s   newarg
doquote move.b  (a2)+,d1        ; process quoted strings
        beq.s   paramExit
        cmpi.b  #34,d1          ; quote
        beq.s   endarg
        cmpi.b  #'*',d1         ; '*' is the BCPL escape character
        bne.s   addquc
        move.b  (a2)+,d1
        move.b  d1,d2
        andi.b  #$df,d2         ; d2 is temp toupper'd d1
        cmpi.b  #'N',d2         ; check for dos newline char
        bne.s   chkEsc
        moveq.l #10,d1          ; got a *N -- turn into a newline
        bra.s   addquc
chkEsc  cmpi.b  #'E',d2
        bne.s   addquc
        moveq.l #27,d1          ; got a *E -- turn into a escape
addquc  move.b  d1,(a1)+
        bra.s   doquote
paramExit
        clr.b   (a1)            ; all done -- null terminate the arguments
        clr.l   (a3)
        ENDC

        pea     sv_argvArray(a5)        ; argv
        move.l  d3,-(a7)                ; argc
        ENDC

        IFGT    QARG
        pea     nullArgV        ; pointer to pointer to null string
        pea     1               ; only one pointer
        ENDC

        IFGT    ASTART
        movea.l _DOSBase,a6
        CALLSYS Input           ; get standard input handle
        move.l  d0,_stdin
        CALLSYS Output          ; get standard output handle
        move.l  d0,_stdout
        move.l  d0,_stderr
        movea.l _SysBase,a6
        ENDC

        bra.s   domain          ; Ok, let's go...

*------ Workbench startup code
fromWorkbench
        bsr.s   getWbMsg        ; get the startup message that workbench will
        move.l  d0,(a7)         ; send to us. Must get this message before
                                ; doing any DOS calls. Save this message for
        IFGT    ASTART          ; later
        move.l  d0,_WBenchMsg
        ENDC

        move.l  d0,-(a7)        ; push the message on the stack for wbmain
        clr.l   -(a7)           ; (as argv). Indicate run from WB (argc=0)

        IFNE    (1-QARG)+WBOUT
        movea.l _DOSBase,a6     ; put DOSBase in a6 for next few calls
        ENDC

        IFEQ    QARG
        movea.l d0,a2           ; get the first argument
        move.l  sm_ArgList(a2),d0
        beq.s   doCons
        movea.l d0,a0           ; and set the current directory to the same dir
        move.l  wa_Lock(a0),d1
        beq.s   doCons
        CALLSYS CurrentDir
doCons  
        ENDC

        IFGT    WBOUT           ; Open NIL: or AppWindow for WB Input()/Output()
                                ; handle. Also for possible initialization of
        IFGT    WINDOW          ; stdio globals. stdio used to be init to -1
        lea     _AppWindow,a0   ; Get AppWindow defined in application
        tst.b   (a0)
        bne.s   doOpen          ; Open if not null string
        ENDC

        lea     NilName,a0      ; Open NIL: if no window provided
doOpen  move.l  a0,d1           ; Open up the file whose name is in a0
        move.l  #MODE_OLDFILE,d2
        CALLSYS Open
        move.l  d0,sv_WbOutput(a5)      ; d0 now contains handle for WB Output
        bne.s   gotOpen
        moveq.l #RETURN_FAIL,d2
        bra     exit2
gotOpen

        IFGT    ASTART
        move.l  d0,_stdin       ; set the C input and output descriptors
        move.l  d0,_stdout
        move.l  d0,_stderr
        ENDC

        move.l  d0,pr_CIS(a4)   ; set the console task (so Open("*",mode)
        move.l  d0,pr_COS(a4)   ; will work (task pointer still in a4
        lsl.l   #2,d0
        movea.l d0,a0
        move.l  fh_Type(a0),d0
        beq.s   noConTask
        move.l  d0,pr_ConsoleTask(a4)
noConTask
        ENDC

*------ CLI $ Workbench startup code (continued)
*
* Calls
*       main(argc,argv)
*            int   argc;
*            char *argv[];
*
* For Workbench startup, argc=0, argv=WBenchMsg

domain  bsr     _main           ; main didn't use exit(n) so provide success
        moveq.l #RETURN_OK,d2   ; return code
        bra.s   exit2


********************************************************************************


*------ get Workbench message
getWbMsg
        lea     pr_MsgPort(a4),a0       ; our process base
        CALLSYS WaitPort                ; a6=ExecBase
        lea     pr_MsgPort(a4),a0
        CALLSYS GetMsg
        rts


*------ Alert
alertDOS
        ALERT   (AG_OpenLib!AO_DOSLib)  ; no dos library

        IFEQ    QARG
        bra.s   failExit
alertMem
        movea.l _DOSBase,a1             ; Close DOS
        CALLSYS CloseLibrary
        ALERT   AG_NoMemory             ; no memory
        ENDC

failExit
        tst.l   pr_CLI(a4)
        bne.s   fail2
        bsr.s   getWbMsg
        movea.l d0,a2
        bsr.s   repWbMsg
fail2   moveq.l #RETURN_FAIL,d0
        rts


*------ Reply Workbench message
repWbMsg
        CALLSYS Forbid
        movea.l a2,a1
        CALLSYS ReplyMsg
        rts


*------ Exit
_exit   move.l  4(a7),d2        ; exit(n) return code to d2
exit2   movea.l _SysBase,a6     ; exit cod ein d2
        suba.l  a1,a1           ; restore initial stack ptr
        CALLSYS FindTask
        movea.l d0,a4
        movea.l pr_ReturnAddr(a4),a5
        subq.l  #8,a5
        subq.l  #4,a5
        movea.l a5,a7
        movea.l (a7)+,a2        ; recover WBenchMsg
        movea.l (a7)+,a5        ; recover sVar

        IFGT    WBOUT
        move.l  sv_WbOutput(a5),d1      ; Close any WbOutput file
        beq.s   noWbOut
        movea.l _DOSBase,a6
        CALLSYS Close
noWbOut movea.l _SysBase,a6     ; restore a6=ExecBase
        ENDC

        movea.l _DOSBase,a1     ; close DOS library
        CALLSYS CloseLibrary
checkWB move.l  a2,d0           ; if we ran from CLI, skip workbench reply
        beq.s   deallocSV
        bsr.s   repWbMsg
deallocSV

        IFEQ    QARG
        movea.l a5,a1           ; deallocate the sVar structure
        move.l  #sv_SIZEOF,d0
        CALLSYS FreeMem
        ENDC

        move.l  d2,d0           ; this rts sends us back to DOS
        rts


********************************************************************************

        section AsmStartup,DATA

*------ Datafield
DOSName DOSNAME
NilName dc.b    'NIL:',0
        ds.w    0

        IFGT    QARG
nullArgV        dc.l    nullArg
nullArg         dc.l    0       ; "" & the null entry after nullArgV
        ENDC

        IFGT    WINDOW
_NeedWstartup
        ENDC

_SysBase        dc.l    0
_DOSBase        dc.l    0

        IFGT    ASTART
_WBenchMsg      dc.l    0
_stdin          dc.l    0
_stdout         dc.l    0
_stderr         dc.l    0
        ENDC

        IFGT    DEBUG
initialSP       dc.l    0
dosCmdLen       dc.l    0
dosCmdBuf       dc.l    0
        ENDC

        ENDC
