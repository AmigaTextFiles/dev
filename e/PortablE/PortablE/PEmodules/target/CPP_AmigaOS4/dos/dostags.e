/* $Id: dostags.h,v 1.73 2005/12/30 04:57:48 cwenzel Exp $ */
OPT NATIVE
MODULE 'target/utility/tagitem'
MODULE 'target/exec/types'
{#include <dos/dostags.h>}
NATIVE {DOS_DOSTAGS_H} CONST

/*
 * definitions for the (V50) GetSegListInfo() call
 */

NATIVE {GSLI_Dummy}     CONST GSLI_DUMMY     = (TAG_USER+4000)
 
NATIVE {GSLI_Native}    CONST GSLI_NATIVE    = (GSLI_DUMMY+1)    
            /* struct PseudoSegList ** - if PPC executable.
               this only means it's native and executable,
               it does NOT imply any particular type. */

NATIVE {GSLI_Data}      CONST GSLI_DATA      = (GSLI_DUMMY+2)
            /* APTR * - data, if a data-only pseudoseglist.   */ 

NATIVE {GSLI_68KPS}     CONST GSLI_68KPS     = (GSLI_DUMMY+3)
            /* struct PseudoSeglist ** - if 68K pseudoseglist*/ 

NATIVE {GSLI_ElfHandle}    CONST GSLI_ELFHANDLE    = (GSLI_DUMMY+4) 
            /* Elf32_Handle * - if Elf32 style pseudoseglist. */

NATIVE {GSLI_68KHUNK}      CONST GSLI_68KHUNK      = (GSLI_DUMMY+5)
            /* BPTR * seglist - if old 68K HUNK style seglist.*/

NATIVE {GSLI_68KOVLAY}     CONST GSLI_68KOVLAY     = (GSLI_DUMMY+6)
            /* BPTR * seglist - if old 68K OVERLAY seglist.   */

NATIVE {GSLI_68KFileSize}    CONST GSLI_68KFILESIZE    = (GSLI_DUMMY+7)
            /* ULONG * size of the 68K binary load file. 51.58  */

NATIVE {GSLI_68KFileXsum}    CONST GSLI_68KFILEXSUM    = (GSLI_DUMMY+8)
            /* ULONG * 32 bit xsum of the 68K binary load file. 51.58 */


/*****************************************************************************/

/*
 * definitions for the (V50) AddSegmentTagList() call
 */

NATIVE {AS_Dummy}          CONST AS_DUMMY          = (TAG_USER+3000)

NATIVE {AS_SegmentList}    CONST AS_SEGMENTLIST    = (AS_DUMMY+1)    /* Segment list, as returned by
                                             the LoadSeg() function */
NATIVE {AS_Entry}          CONST AS_ENTRY          = (AS_DUMMY+2)    /* Address of a function which
                                             implements the command */

/*****************************************************************************/

/*
 * definitions for the System() call
 */

NATIVE {SYS_Dummy}          CONST SYS_DUMMY          = (TAG_USER + 32)

NATIVE {SYS_Input}          CONST SYS_INPUT          = (SYS_DUMMY + 1)
    /* specifies the input filehandle  */

NATIVE {SYS_Output}         CONST SYS_OUTPUT         = (SYS_DUMMY + 2)
    /* specifies the output filehandle */

NATIVE {SYS_Asynch}         CONST SYS_ASYNCH         = (SYS_DUMMY + 3)
    /* run asynch, close input/output on exit(!) */

NATIVE {SYS_UserShell}      CONST SYS_USERSHELL      = (SYS_DUMMY + 4)
    /* send to user shell instead of boot shell */

NATIVE {SYS_CustomShell}    CONST SYS_CUSTOMSHELL    = (SYS_DUMMY + 5)
    /* send to a specific shell (data is name) */

NATIVE {SYS_Error}          CONST SYS_ERROR          = (SYS_DUMMY + 6)
    /* specifies the error output filehandle (New for V50) */ 

/*****************************************************************************/

/* definitions for the CreateNewProc() call;
   you MUST specify one of NP_Seglist or NP_Entry. All else is optional.
   NOTE: NP_Error was not actually implemented in DOS until V50 */

NATIVE {NP_Dummy}            CONST NP_DUMMY            = (TAG_USER + 1000)

NATIVE {NP_Seglist}          CONST NP_SEGLIST          = (NP_DUMMY + 1)
    /* seglist of code to run for the process  */

NATIVE {NP_FreeSeglist}      CONST NP_FREESEGLIST      = (NP_DUMMY + 2)
    /* free seglist on exit - only valid for
       NP_Seglist.  Default is FALSE. */

NATIVE {NP_Entry}            CONST NP_ENTRY            = (NP_DUMMY + 3)
    /* entry point to run */

NATIVE {NP_Input}            CONST NP_INPUT            = (NP_DUMMY + 4)
    /* filehandle - default is Open("NIL:"...) */

NATIVE {NP_Output}           CONST NP_OUTPUT           = (NP_DUMMY + 5)
    /* filehandle - default is Open("NIL:"...) */

NATIVE {NP_CloseInput}       CONST NP_CLOSEINPUT       = (NP_DUMMY + 6)
    /* close input filehandle on exit,
       default TRUE */

NATIVE {NP_CloseOutput}      CONST NP_CLOSEOUTPUT      = (NP_DUMMY + 7)
    /* close output filehandle on exit,
       default TRUE */

NATIVE {NP_Error}            CONST NP_ERROR            = (NP_DUMMY + 8)
    /* filehandle - default is NULL (V50) */

NATIVE {NP_CloseError}       CONST NP_CLOSEERROR       = (NP_DUMMY + 9)
    /* close error filehandle on exit,
       default FALSE (V50) */

NATIVE {NP_CurrentDir}       CONST NP_CURRENTDIR       = (NP_DUMMY + 10)
    /* lock - default is parent's current dir  */

NATIVE {NP_StackSize}        CONST NP_STACKSIZE        = (NP_DUMMY + 11)
    /* stacksize for process */

NATIVE {NP_Name}             CONST NP_NAME             = (NP_DUMMY + 12)
    /* name for process - default "New Process"*/

NATIVE {NP_Priority}         CONST NP_PRIORITY         = (NP_DUMMY + 13)
    /* priority - default same as parent */

NATIVE {NP_ConsoleTask}      CONST NP_CONSOLETASK      = (NP_DUMMY + 14)
    /* consoletask - default same as parent */

NATIVE {NP_WindowPtr}        CONST NP_WINDOWPTR        = (NP_DUMMY + 15)
    /* window ptr - default is same as parent  */

NATIVE {NP_ProgramDir}          CONST NP_PROGRAMDIR          = (NP_DUMMY + 16)
    /* home directory - default curr home dir  */

NATIVE {NP_CopyVars}         CONST NP_COPYVARS         = (NP_DUMMY + 17)
    /* boolean to copy local vars-default TRUE */

NATIVE {NP_Cli}              CONST NP_CLI              = (NP_DUMMY + 18)
    /* create cli structure - default FALSE */

NATIVE {NP_Path}             CONST NP_PATH             = (NP_DUMMY + 19)
    /* path - default is copy of parents path,
       only valid if a cli process! */

NATIVE {NP_CommandName}      CONST NP_COMMANDNAME      = (NP_DUMMY + 20)
    /* commandname - valid only for CLI */

NATIVE {NP_Arguments}        CONST NP_ARGUMENTS        = (NP_DUMMY + 21)
    /* cstring of arguments - passed with str in a0, length in d0.
       (copied and freed on exit.) Default is 0-length NULL ptr.
       NOTE: not operational until V37 - see BIX/TechNotes for
       more info/workaround.  In V36, the registers were random.
       You must NEVER use NP_Arguments with a NP_Input of NULL. */

NATIVE {NP_unused1}          CONST NP_UNUSED1          = (NP_DUMMY + 22)    /* never inplemented */

NATIVE {NP_unused2}          CONST NP_UNUSED2          = (NP_DUMMY + 23)    /* never implemented */

NATIVE {NP_ExitCode}         CONST NP_EXITCODE         = (NP_DUMMY + 24)
    /* code to be called on process exit, just before cleanup */

NATIVE {NP_ExitData}         CONST NP_EXITDATA         = (NP_DUMMY + 25)
    /* optional argument for NP_ExitCode function - default 0 */

NATIVE {NP_UserData}         CONST NP_USERDATA         = (NP_DUMMY + 26)
    /* optional value to install into task->tc_UserData. */

NATIVE {NP_Child}            CONST NP_CHILD            = (NP_DUMMY + 27)
    /* boolean flag to nominate this new process as a dependant child 
       of the parent. */

NATIVE {NP_NotifyOnDeathMessage}        CONST NP_NOTIFYONDEATHMESSAGE        = (NP_DUMMY+28)
    /* struct DeathMessage * -- (V51.53) Specify an initialised death message 
       structure to ReplyMsg() to, upon death of this process.
       Defaults to none.  */

NATIVE {NP_NotifyOnDeathSigTask}        CONST NP_NOTIFYONDEATHSIGTASK        = (NP_DUMMY+29)
    /* struct Task * -- (V51.53) Specify the task or process to signal upon 
       death of this process. Specify NULL for the parent of this child process.
       Defaults to no signalling, if this tag is not specified. */

NATIVE {NP_NotifyOnDeathSignalBit}      CONST NP_NOTIFYONDEATHSIGNALBIT      = (NP_DUMMY+30)
    /* A value 0-31 for the signal bit number to send to the task
       NP_NotifyOnDeathSigTask, upon death of this process. 
       Defaults to SIGB_CHILD if not specified.  (See; exec/tasks.h) */

NATIVE {NP_LocalVars}                   CONST NP_LOCALVARS                   = (NP_DUMMY+31)
    /* UBYTE ** -- (V51.70) Paired array of string pointers representing a 
       list of local variables to add to the new process, array must be 
       arranged as;  Name1,Value1, Name2,Value2, Name3,Value3, NULL;
       Default NULL */

NATIVE {NP_EntryCode}                   CONST NP_ENTRYCODE                   = (NP_DUMMY+32)
    /* code to be called on process startup, just before internalRunCommand() */

NATIVE {NP_EntryData}                   CONST NP_ENTRYDATA                   = (NP_DUMMY+33)
    /* optional argument for NP_EntryCode function - default 0 */

NATIVE {NP_FinalCode}                   CONST NP_FINALCODE                   = (NP_DUMMY+34)
    /* code to be called on process exit, just before cleanup */

NATIVE {NP_FinalData}                   CONST NP_FINALDATA                   = (NP_DUMMY+35)
    /* optional argument for NP_FinalCode function - default 0 */


/*****************************************************************************/

/*
 * tags for AllocDosObject()
 */

NATIVE {ADO_Dummy}        CONST ADO_DUMMY        = (TAG_USER + 2000)

NATIVE {ADO_Strlen}       CONST ADO_STRLEN       = (ADO_DUMMY + 6)
    /* size of additional buffer to allocate over
       and above the base structure size required
       by the flag DOS_xxxxx .   (V50) */

NATIVE {ADO_Flags}        CONST ADO_FLAGS        = (ADO_DUMMY + 7)
    /* generic 32 bit flags for those allocations that
       require initialisation of a specific flags field. (V50) */

NATIVE {ADO_DOSType}       CONST            /* alias V51 */
NATIVE {ADO_TermChar}      CONST            /* alias V51 */

NATIVE {ADO_Mask}         CONST ADO_MASK         = (ADO_DUMMY + 8)
    /* generic 32 bit mask for those allocations that
       require initialisation of a specific bitmask. (V50) */

NATIVE {ADO_NotifyName}   CONST ADO_NOTIFYNAME   = (ADO_DUMMY + 9)
    /* Name of the volume, directory or file to monitor and produce
       notification messages for. (V51) */

NATIVE {ADO_NotifyUserData}    CONST ADO_NOTIFYUSERDATA    = (ADO_DUMMY + 10)
    /* User data to be stored in a NotifyRequest. (V51) */

NATIVE {ADO_NotifyMethod}      CONST ADO_NOTIFYMETHOD      = (ADO_DUMMY + 11)
    /* Notification method; must be one of NRF_SEND_MESSAGE,
       NRF_SEND_SIGNAL or NRF_CALL_HOOK. (V51) */

NATIVE {ADO_NotifyPort}        CONST ADO_NOTIFYPORT        = (ADO_DUMMY + 12)
    /* MsgPort to send notification messages to; this is used
       for the NRF_SEND_MESSAGE notification method. (V51) */

NATIVE {ADO_NotifyTask}        CONST ADO_NOTIFYTASK        = (ADO_DUMMY + 13)
    /* Task to send a notification signal to; this is used for
       the NRF_SEND_SIGNAL notification method. (V51) */

NATIVE {ADO_NotifySignalNumber}    CONST ADO_NOTIFYSIGNALNUMBER    = (ADO_DUMMY + 14)
    /* The signal number (0..31) to use when sending a notification
       signal; this is used for the NRF_SEND_SIGNAL notification
       method. (V51) */

NATIVE {ADO_NotifyHook}        CONST ADO_NOTIFYHOOK        = (ADO_DUMMY + 15)
    /* The hook to call when a notification is required; this is
       used for the NRF_CALL_HOOK method. (V51) */

NATIVE {ADO_NotifyWaitReply}   CONST ADO_NOTIFYWAITREPLY   = (ADO_DUMMY + 16)
    /* Selects if the further notification messages should be sent
       unless the last message has been replied. (V51) */

NATIVE {ADO_NotifyInitial}     CONST ADO_NOTIFYINITIAL     = (ADO_DUMMY + 17)
    /* Selects if the notification should be sent immediately after
       it was requested. (V51) */

NATIVE {ADO_Size}              CONST ADO_SIZE              = (ADO_DUMMY + 18)
    /* Specify allocation size that is larger than the default. (V51) */


/****************************************************************************/

/*
 * Tags for DosControl() 
 */

NATIVE {DC_Dummy}             CONST DC_DUMMY             = (TAG_USER + 5000)

NATIVE {DC_WildStarW}         CONST DC_WILDSTARW         = (DC_DUMMY+1)
    /*  (LONG Boolean) -- Write to the default WildStar switch. */
    /*  Default is FALSE. */

NATIVE {DC_WildStarR}         CONST DC_WILDSTARR         = (DC_DUMMY+2)
    /* (LONG *) -- Obtain the state of WildStar switch. */

NATIVE {DC_FHBufferW}         CONST DC_FHBUFFERW         = (DC_DUMMY+3)
    /* (LONG) -- Writes the size in bytes for all FileHandle buffers. */
    /* The default value for V50 DOS is 2048 bytes.  */

NATIVE {DC_FHBufferR}         CONST DC_FHBUFFERR         = (DC_DUMMY+4)
    /* (LONG *) -- Obtain the size in bytes for FH Buffers. */

NATIVE {DC_WarnPostTimeW}     CONST DC_WARNPOSTTIMEW     = (DC_DUMMY+5)
    /* (LONG) -- Write the number of ticks to post warning for.  */
    /* Default posting time is currently 7 seconds. (350 ticks)  */

NATIVE {DC_WarnPostTimeR}     CONST DC_WARNPOSTTIMER     = (DC_DUMMY+6)
    /* (LONG *) -- Obtain the value for WarnPostTime.  */

NATIVE {DC_WarnWaitTimeW}     CONST DC_WARNWAITTIMEW     = (DC_DUMMY+7)
    /* (LONG) -- Write the number of ticks to wait between warnings. */
    /* Default wait time is currently 60 seconds. (3000 ticks)  */

NATIVE {DC_WarnWaitTimeR}     CONST DC_WARNWAITTIMER     = (DC_DUMMY+8)
    /* (LONG *) -- Obtain the value for WarnWaitTime. */

NATIVE {DC_MinProcStackW}     CONST DC_MINPROCSTACKW     = (DC_DUMMY+9)
    /* (LONG) -- Write the number of bytes to enforce as min proc stack */

NATIVE {DC_MinProcStackR}     CONST DC_MINPROCSTACKR     = (DC_DUMMY+10)
    /* (LONG *) -- Obtain the value for MinProcStack. */

NATIVE {DC_AssignMountW}      CONST DC_ASSIGNMOUNTW      = (DC_DUMMY+11)
    /* (LONG) -- Write to the default AssignMount switch. */

NATIVE {DC_AssignMountR}      CONST DC_ASSIGNMOUNTR      = (DC_DUMMY+12)
    /* (LONG *) -- Obtain the state of the AssignMount switch. */

NATIVE {DC_BootCliFontSizeW}  CONST DC_BOOTCLIFONTSIZEW  = (DC_DUMMY+13)
    /* (LONG) -- Write the boot cli font size. TOPAZ_SIXTY or TOPAZ_EIGHTY */

NATIVE {DC_BootCliFontSizeR}  CONST DC_BOOTCLIFONTSIZER  = (DC_DUMMY+14)
    /* (LONG *) -- Obtain the size of the boot cli font size. */

NATIVE {DC_Reload68KApplistW} CONST DC_RELOAD68KAPPLISTW = (DC_DUMMY+15)
    /* (LONG) -- DOSTRUE will cause DEVS:applications.dos config file to 
                 reload from disk. 51.58 */

NATIVE {DC_1reservedR}        CONST DC_1RESERVEDR        = (DC_DUMMY+16) 



/****************************************************************************/

/*
 * Tags for ReadLineItem() 
 */

NATIVE {RLI_Dummy}                CONST RLI_DUMMY                = (TAG_USER + 5500)

NATIVE {RLI_FileHandleInput}      CONST RLI_FILEHANDLEINPUT      = (RLI_DUMMY+1)
    /* (BPTR) -- Read with FGetC() from this filehandle.
       Default is FGetC(Input()); */

NATIVE {RLI_CSourceInput}         CONST RLI_CSOURCEINPUT         = (RLI_DUMMY+2)
    /* (struct CSource *) -- Read from this CSource stream.
       Default is FGetC(Input()); */


NATIVE {RLI_EscapeChars}          CONST RLI_ESCAPECHARS          = (RLI_DUMMY+10)
    /* (STRPTR) -- Nul-terminated string of one or more characters
       to be recognised as escape characters.  
       This may be an empty string "" or NULL, for none.
       Defaults to "*".  */

NATIVE {RLI_MultiLine}            CONST RLI_MULTILINE            = (RLI_DUMMY+11)
    /* (LONG; boolean) -- Enable Multi-line processing.
       Defaults to FALSE.  */

NATIVE {RLI_CommentChars}         CONST RLI_COMMENTCHARS         = (RLI_DUMMY+12)
    /* (STRPTR) -- Nul-terminated string of one or more characters
       to be used as a comment marker.
       This may be an empty string "" or NULL, for none.
       Defaults to "".  */

NATIVE {RLI_Substitute_N}         CONST RLI_SUBSTITUTE_N         = (RLI_DUMMY+13)
    /* (LONG; boolean) -- Substitute quoted escaped "N" to the hex
       char 0x0a.   Only works when RLI_EscapeChars is not "" or NULL.
       Defaults to TRUE.  */

NATIVE {RLI_Substitute_E}         CONST RLI_SUBSTITUTE_E         = (RLI_DUMMY+14)
    /* (LONG; boolean) -- Substitute quoted escaped "E" to the hex
       char 0x1b.   Only works when RLI_EscapeChars is not "" or NULL.
       Defaults to TRUE.  */

/****************************************************************************/

/*
 * Tags for SetFileHandleAttr() 
 */

NATIVE {FH_Dummy}               CONST FH_DUMMY               = (TAG_USER + 6000)

NATIVE {FH_BufferSize}          CONST FH_BUFFERSIZE          = (FH_DUMMY + 1)
NATIVE {FH_UserBuffer}          CONST FH_USERBUFFER          = (FH_DUMMY + 2)
NATIVE {FH_BufferMode}          CONST FH_BUFFERMODE          = (FH_DUMMY + 3)
NATIVE {FH_Locking}             CONST FH_LOCKING             = (FH_DUMMY + 4)
NATIVE {FH_EndStream}           CONST FH_ENDSTREAM           = (FH_DUMMY + 5)


/****************************************************************************/

/*
 * Tags for TimedDosRequester() 
 */

NATIVE {TDR_Dummy}                CONST TDR_DUMMY                = (TAG_USER + 3500)

NATIVE {TDR_IDCMP_Ptr}            CONST TDR_IDCMP_PTR            = (TDR_DUMMY+1)
    /* (ULONG *) -- Pointer to a longword initialised with the IDCMP flags 
       that you want to terminate the requester on.  (Default; NULL)  */

NATIVE {TDR_Timeout}              CONST TDR_TIMEOUT              = (TDR_DUMMY+2)
    /* (LONG) -- Value in seconds to wait before requester will close without
       intervention.  A timeout will only occur with values > 0.
       It is recommended that timouts less than 10 seconds be
       avoided whenever possible, to be user-friendly. (Default; 0) */

NATIVE {TDR_Window}               CONST TDR_WINDOW               = (TDR_DUMMY+3)
    /* (struct Window *) [OPTIONAL] 
       -- A pointer to an (over-riding) reference window pointer.
       Normally, you would not need to specify this tag.
       
       However, if you are calling this function from a task, 
       then the default process window will not be available and
       you would normally finish up having the requester rendered
       on the default public screen instead, (usually workbench)
       therefore you can use this tag to force it to use your 
       own specified window,this will work from both a task or 
       a process. 
       (Default; proc->pr_WindowPtr, or WB screen from a task)  */

NATIVE {TDR_EasyStruct}           CONST TDR_EASYSTRUCT           = (TDR_DUMMY+4)
    /* (struct EasyStruct *) [OPTIONAL]
       -- Pointer to your own private struct EasyStruct that has
       already been initialised.   (Default; internally allocated)  */

NATIVE {TDR_FormatString}         CONST TDR_FORMATSTRING         = (TDR_DUMMY+5)
    /* (STRPTR) [OPTIONAL]
       -- The format string using RawDoFmt style specifiers that match
       the number of argument array entries.
       If this tag is present, it will override a formatstring that
       may have already been supplied with a private TDR_EasyStruct. */

NATIVE {TDR_TitleString}          CONST TDR_TITLESTRING          = (TDR_DUMMY+6)
    /* (STRPTR) [OPTIONAL]
       -- The title string for the requester.
       If this tag is present, it will override a title string that
       may have already been supplied with a private TDR_EasyStruct.  */

NATIVE {TDR_GadgetString}         CONST TDR_GADGETSTRING         = (TDR_DUMMY+7)
    /* (STRPTR) [OPTIONAL]
       -- The string spec for the gadgets/text for the requester.
       If this tag is present, it will override a Gadget string 
       that may have been supplied with a private TDR_EasyStruct.  */

NATIVE {TDR_ImageType}            CONST TDR_IMAGETYPE            = (TDR_DUMMY+8)
    /* (ULONG) -- The visual style of this request. This argument has
       currently no effect before IPrefs is running, but should always
       be specified to indicate the style of request this is directed
       for.   (Default; TDRIMAGE_DEFAULT)
       The values for this tag are defined below.  */
NATIVE {TDRIMAGE_DEFAULT}	CONST TDRIMAGE_DEFAULT = 0
NATIVE {TDRIMAGE_INFO}		CONST TDRIMAGE_INFO = 1
NATIVE {TDRIMAGE_WARNING}	CONST TDRIMAGE_WARNING = 2
NATIVE {TDRIMAGE_ERROR}		CONST TDRIMAGE_ERROR = 3
NATIVE {TDRIMAGE_QUESTION}	CONST TDRIMAGE_QUESTION = 4
NATIVE {TDRIMAGE_INSERTDISK}	CONST TDRIMAGE_INSERTDISK = 5

NATIVE {TDR_ArgArray}             CONST TDR_ARGARRAY             = (TDR_DUMMY+9)
    /* (APTR) [OPTIONAL]
       -- A pointer to a completely initialised argument array with
       the number of entries that correspond to the RawDoFmt()
       format specifiers.

       Do not use this tag if you want to specify up to the first
       10 arguments individually with the following TDR_Arg# tags. */

NATIVE {TDR_Inactive}             CONST TDR_INACTIVE             = (TDR_DUMMY+10)
    /* (LONG) -- Boolean value to specify the requester should not
       be activated to avoid its stealing the users input focus.
       You should set this to TRUE when the gadgets of your requester
       contain keyboard shortcuts and its possible that the user is
       currently typing text in another application (otherwise the
       user could answer the requester by accident). This argument has
       currently no effect before IPrefs is running, keyboard shortcuts
       also won't work before.  (Default; FALSE) */

NATIVE {TDR_CharSet}              CONST TDR_CHARSET              = (TDR_DUMMY+11)
    /* (ULONG) -- Character set for the requester's text and gadgets.
       Defaults to 0, meaning the charset of the screen font which
       will be the current system default charset in most cases.
       This argument has currently no effect before IPrefs is running.
       The tag value is based on the IANA MIBenum value for charsets.
       See the autodoc for diskfont.library/ObtainCharsetInfo().
       TDR_CharSet should be set by localized applications that want
       to display localized requesters, they tell locale.library in
       OpenCatalog() that it shall not convert the catalog charset to
       current system default charset and use the value of 
       Catalog->cat_CodeSet for the TDR_CharSet.    (Default; 0) */


NATIVE {TDR_Arg1}            CONST TDR_ARG1            = (TDR_DUMMY+20)
NATIVE {TDR_Arg2}            CONST TDR_ARG2            = (TDR_DUMMY+21)
NATIVE {TDR_Arg3}            CONST TDR_ARG3            = (TDR_DUMMY+22)
NATIVE {TDR_Arg4}            CONST TDR_ARG4            = (TDR_DUMMY+23)
NATIVE {TDR_Arg5}            CONST TDR_ARG5            = (TDR_DUMMY+24)
NATIVE {TDR_Arg6}            CONST TDR_ARG6            = (TDR_DUMMY+25)
NATIVE {TDR_Arg7}            CONST TDR_ARG7            = (TDR_DUMMY+26)
NATIVE {TDR_Arg8}            CONST TDR_ARG8            = (TDR_DUMMY+27)
NATIVE {TDR_Arg9}            CONST TDR_ARG9            = (TDR_DUMMY+28)
NATIVE {TDR_Arg10}           CONST TDR_ARG10           = (TDR_DUMMY+29)




/****************************************************************************/

/*
 * Tags for FileSystemAttr() 
 */

NATIVE {FSA_Dummy}                    CONST FSA_DUMMY                    = (TAG_USER + 9000)

NATIVE {FSA_StringNameInput}          CONST FSA_STRINGNAMEINPUT          = (FSA_DUMMY+1)
    /* (STRPTR) -- Identify the filesystem by this name reference. */

NATIVE {FSA_FileHandleInput}          CONST FSA_FILEHANDLEINPUT          = (FSA_DUMMY+2)
    /* (BPTR) -- Identify the filesystem by this FileHandle. */

NATIVE {FSA_FileLockInput}            CONST FSA_FILELOCKINPUT            = (FSA_DUMMY+3)
    /* (BPTR) -- Identify the filesystem by this FileLock. */



NATIVE {FSA_MaxFileNameLengthR}       CONST FSA_MAXFILENAMELENGTHR       = (FSA_DUMMY+10)
    /* (ULONG *) -- Obtain the maximum filename length. (including \0) */  

NATIVE {FSA_MaxFileNameLengthW}       CONST FSA_MAXFILENAMELENGTHW       = (FSA_DUMMY+11)
    /* (ULONG) -- Set the maximum filename length. (including \0) */  

NATIVE {FSA_VersionNumberR}           CONST FSA_VERSIONNUMBERR           = (FSA_DUMMY+12)
    /* (ULONG *) -- Obtain the version/rev number for the filesystem. */

NATIVE {FSA_DOSTypeR}                 CONST FSA_DOSTYPER                 = (FSA_DUMMY+13)
    /* (ULONG *) -- Obtain the dostype identifier for the filesystem. */

NATIVE {FSA_ActivityFlushTimeoutR}    CONST FSA_ACTIVITYFLUSHTIMEOUTR    = (FSA_DUMMY+14)
    /* (ULONG *) -- Obtain the ticks (50th second) before a flush while active occurs. */

NATIVE {FSA_ActivityFlushTimeoutW}    CONST FSA_ACTIVITYFLUSHTIMEOUTW    = (FSA_DUMMY+15)
    /* (ULONG) -- Set the ticks (50th second) before a flush while active occurs. */

NATIVE {FSA_InactivityFlushTimeoutR}  CONST FSA_INACTIVITYFLUSHTIMEOUTR  = (FSA_DUMMY+16)
    /* (ULONG *) -- Obtain the ticks (50th second) before a flush when inactive occurs. */

NATIVE {FSA_InactivityFlushTimeoutW}  CONST FSA_INACTIVITYFLUSHTIMEOUTW  = (FSA_DUMMY+17)
    /* (ULONG) -- Set the ticks (50th second) before a flush when inactive occurs. */

NATIVE {FSA_MaxRecycledEntriesR}      CONST FSA_MAXRECYCLEDENTRIESR      = (FSA_DUMMY+18)
    /* (ULONG *) -- Obtain the number of recycled entries supported. */

NATIVE {FSA_MaxRecycledEntriesW}      CONST FSA_MAXRECYCLEDENTRIESW      = (FSA_DUMMY+19)
    /* (ULONG) -- Set the number of recycled entries supported. */

NATIVE {FSA_HasRecycledEntriesR}      CONST FSA_HASRECYCLEDENTRIESR      = (FSA_DUMMY+20)
    /* (LONG *) -- Obtain boolean value if the filesystem supports recycled entries. */

NATIVE {FSA_VersionStringR}           CONST FSA_VERSIONSTRINGR           = (FSA_DUMMY+21)
    /* (UBYTE *) -- Obtain a copy of the version string for the filesystem. */

NATIVE {FSA_VersionStringR_BufSize}   CONST FSA_VERSIONSTRINGR_BUFSIZE   = (FSA_DUMMY+22)
    /* (ULONG) -- Sub tag to specify the length of the space provided for 
       FSA_VersionStringR. */

NATIVE {FSA_VersionStringR_Len}    CONST  /* temp compatibility */
