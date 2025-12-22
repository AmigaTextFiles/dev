OPT MODULE
OPT EXPORT

MODULE 'utility/tagitem'

CONST SYS_DUMMY=$80000020
CONST SYS_INPUT=$80000021,
      SYS_OUTPUT=$80000022,
      SYS_ASYNCH=$80000023,
      SYS_USERSHELL=$80000024,
      SYS_CUSTOMSHELL=$80000025,
      SYS_Error = $80000026  /* specifies the error output filehandle (New for V50) */

CONST NP_DUMMY=$800003E8
CONST NP_SEGLIST=$800003E9,
      NP_FREESEGLIST=$800003EA,
      NP_ENTRY=$800003EB,
      NP_INPUT=$800003EC,
      NP_OUTPUT=$800003ED,
      NP_CLOSEINPUT=$800003EE,
      NP_CLOSEOUTPUT=$800003EF,
      NP_ERROR=$800003F0,
      NP_CLOSEERROR=$800003F1,
      NP_CURRENTDIR=$800003F2,
      NP_STACKSIZE=$800003F3,
      NP_NAME=$800003F4,
      NP_PRIORITY=$800003F5,
      NP_CONSOLETASK=$800003F6,
      NP_WINDOWPTR=$800003F7,
      NP_HOMEDIR=$800003F8,
      NP_COPYVARS=$800003F9,
      NP_CLI=$800003FA,
      NP_PATH=$800003FB,
      NP_COMMANDNAME=$800003FC,
      NP_ARGUMENTS=$800003FD,
      NP_NOTIFYONDEATH=$800003FE,
      NP_SYNCHRONOUS=$800003FF,
      NP_EXITCODE=$80000400,
      NP_EXITDATA=$80000401

CONST ADO_DUMMY=$800007D0
CONST ADO_FH_MODE=$800007D1,
      ADO_DIRLEN=$800007D2,
      ADO_COMMNAMELEN=$800007D3,
      ADO_COMMFILELEN=$800007D4,
      ADO_PROMPTLEN=$800007D5

/***********************************/
/**** OS4 additions by LS 2008 *****/
/*** Comments from original header */
/***********************************/

CONST

      NP_UserData =  (NP_DUMMY + 26),
    /* optional value to install into task->tc_UserData. */

      NP_Child =     (NP_DUMMY + 27),
    /* boolean flag to nominate this new process as a dependant child
       of the parent. */

      NP_NotifyOnDeathMessage =  (NP_DUMMY+28),
    /* struct DeathMessage * -- (V51.53) Specify an initialised death message
       structure to ReplyMsg() to, upon death of this process.
       Defaults to none.  */

      NP_NotifyOnDeathSigTask = (NP_DUMMY+29),
    /* struct Task * -- (V51.53) Specify the task or process to signal upon
       death of this process. Specify NULL for the parent of this child process.
       Defaults to no signalling, if this tag is not specified. */

      NP_NotifyOnDeathSignalBit =  (NP_DUMMY+30),
    /* A value 0-31 for the signal bit number to send to the task
       NP_NotifyOnDeathSigTask, upon death of this process.
       Defaults to SIGB_CHILD if not specified.  (See; exec/tasks.h) */

      NP_LocalVars  =   (NP_DUMMY+31),
    /* UBYTE ** -- (V51.70) Paired array of string pointers representing a
       list of local variables to add to the new process, array must be
       arranged as;  Name1,Value1, Name2,Value2, Name3,Value3, NULL;
       Default NULL */

      NP_EntryCode = (NP_DUMMY+32),
    /* code to be called on process startup, just before internalRunCommand() */

      NP_EntryData = (NP_DUMMY+33),
    /* optional argument for NP_EntryCode function - default 0 */

      NP_FinalCode = (NP_DUMMY+34),
    /* code to be called on process exit, just before cleanup */

      NP_FinalData =  (NP_DUMMY+35)
    /* optional argument for NP_FinalCode function - default 0 */


/*
 * definitions for the (V50) GetSegListInfo() call
*/

CONST GSLI_Dummy     = (TAG_USER+4000)

CONST GSLI_Native    = (GSLI_Dummy+1)
            /* struct PseudoSegList ** - if PPC executable.
               this only means it's native and executable,
               it does NOT imply any particular type. */

CONST GSLI_Data      = (GSLI_Dummy+2)
            /* APTR * - data, if a data-only pseudoseglist.   */

CONST GSLI_68KPS     = (GSLI_Dummy+3)
            /* struct PseudoSeglist ** - if 68K pseudoseglist*/

CONST GSLI_ElfHandle    = (GSLI_Dummy+4)
            /* Elf32_Handle * - if Elf32 style pseudoseglist. */

CONST GSLI_68KHUNK      = (GSLI_Dummy+5)
            /* BPTR * seglist - if old 68K HUNK style seglist.*/

CONST GSLI_68KOVLAY     = (GSLI_Dummy+6)
            /* BPTR * seglist - if old 68K OVERLAY seglist.   */

CONST GSLI_68KFileSize    = (GSLI_Dummy+7)
            /* ULONG * size of the 68K binary load file. 51.58  */

CONST GSLI_68KFileXsum    = (GSLI_Dummy+8)
            /* ULONG * 32 bit xsum of the 68K binary load file. 51.58 */

/*
 * definitions for the (V50) AddSegmentTagList() call
 */

CONST AS_Dummy =        (TAG_USER+3000)
CONST AS_SegmentList =  (AS_Dummy+1),    /* Segment list, as returned by
                                             the LoadSeg() function */
      AS_Entry =        (AS_Dummy+2)    /* Address of a function which
                                              implements the command */




CONST ADO_Strlen       = (ADO_DUMMY + 6)
    /* size of additional buffer to allocate over
       and above the base structure size required
       by the flag DOS_xxxxx .   (V50) */

CONST ADO_Flags        = (ADO_DUMMY + 7)
    /* generic 32 bit flags for those allocations that
       require initialisation of a specific flags field. (V50) */

CONST ADO_DOSType       = ADO_Flags            /* alias V51 */
CONST ADO_TermChar      = ADO_Flags            /* alias V51 */

CONST ADO_Mask         = (ADO_DUMMY + 8)
    /* generic 32 bit mask for those allocations that
       require initialisation of a specific bitmask. (V50) */

CONST ADO_NotifyName   = (ADO_DUMMY + 9)
    /* Name of the volume, directory or file to monitor and produce
       notification messages for. (V51) */

CONST ADO_NotifyUserData    = (ADO_DUMMY + 10)
    /* User data to be stored in a NotifyRequest. (V51) */

CONST ADO_NotifyMethod      = (ADO_DUMMY + 11)
    /* Notification method; must be one of NRF_SEND_MESSAGE,
       NRF_SEND_SIGNAL or NRF_CALL_HOOK. (V51) */

CONST ADO_NotifyPort        = (ADO_DUMMY + 12)
    /* MsgPort to send notification messages to; this is used
       for the NRF_SEND_MESSAGE notification method. (V51) */

CONST ADO_NotifyTask        = (ADO_DUMMY + 13)
    /* Task to send a notification signal to; this is used for
       the NRF_SEND_SIGNAL notification method. (V51) */

CONST ADO_NotifySignalNumber    = (ADO_DUMMY + 14)
    /* The signal number (0..31) to use when sending a notification
       signal; this is used for the NRF_SEND_SIGNAL notification
       method.  (V51) */

CONST ADO_NotifyHook        = (ADO_DUMMY + 15)
    /* The hook to call when a notification is required; this is
       used for the NRF_CALL_HOOK method. (V51) */

CONST ADO_NotifyWaitReply   = (ADO_DUMMY + 16)
    /* Selects if the further notification messages should be sent
       unless the last message has been replied. (V51) */

CONST ADO_NotifyInitial     = (ADO_DUMMY + 17)
    /* Selects if the notification should be sent immediately after
       it was requested. (V51) */

CONST ADO_Size              = (ADO_DUMMY + 18)
    /* Specify allocation size that is larger than the default. (V51) */


/*
 * Tags for DosControl()
 */

CONST DC_Dummy           =   (TAG_USER + 5000)

CONST DC_WildStarW         = (DC_Dummy+1)
    /*  (LONG Boolean) -- Write to the default WildStar switch. */
    /*  Default is FALSE. */

CONST DC_WildStarR         = (DC_Dummy+2)
    /* (LONG *) -- Obtain the state of WildStar switch. */

CONST DC_FHBufferW         = (DC_Dummy+3)
    /* (LONG) -- Writes the size in bytes for all FileHandle buffers. */
    /* The default value for V50 DOS is 2048 bytes.  */

CONST DC_FHBufferR         = (DC_Dummy+4)
    /* (LONG *) -- Obtain the size in bytes for FH Buffers. */

CONST DC_WarnPostTimeW     = (DC_Dummy+5)
    /* (LONG) -- Write the number of ticks to post warning for.  */
    /* Default posting time is currently 7 seconds. (350 ticks)  */

CONST DC_WarnPostTimeR     = (DC_Dummy+6)
    /* (LONG *) -- Obtain the value for WarnPostTime.  */

CONST DC_WarnWaitTimeW     = (DC_Dummy+7)
    /* (LONG) -- Write the number of ticks to wait between warnings. */
    /* Default wait time is currently 60 seconds. (3000 ticks)  */

CONST DC_WarnWaitTimeR     = (DC_Dummy+8)
    /* (LONG *) -- Obtain the value for WarnWaitTime. */

CONST DC_MinProcStackW     = (DC_Dummy+9)
    /* (LONG) -- Write the number of bytes to enforce as min proc stack */

CONST DC_MinProcStackR     = (DC_Dummy+10)
    /* (LONG *) -- Obtain the value for MinProcStack. */

CONST DC_AssignMountW      = (DC_Dummy+11)
    /* (LONG) -- Write to the default AssignMount switch. */

CONST DC_AssignMountR      = (DC_Dummy+12)
    /* (LONG *) -- Obtain the state of the AssignMount switch. */

CONST DC_BootCliFontSizeW  = (DC_Dummy+13)
    /* (LONG) -- Write the boot cli font size. TOPAZ_SIXTY or TOPAZ_EIGHTY */

CONST DC_BootCliFontSizeR  = (DC_Dummy+14)
    /* (LONG *) -- Obtain the size of the boot cli font size. */

CONST DC_Reload68KApplistW = (DC_Dummy+15)
    /* (LONG) -- DOSTRUE will cause DEVS:applications.dos config file to
                 reload from disk. 51.58 */

CONST DC_1reservedR        = (DC_Dummy+16)



/*
 * Tags for ReadLineItem()
 */

CONST RLI_Dummy               = (TAG_USER + 5500)

CONST RLI_FileHandleInput      = (RLI_Dummy+1)
    /* (BPTR) -- Read with FGetC() from this filehandle.
       Default is FGetC(Input()); */

CONST RLI_CSourceInput         = (RLI_Dummy+2)
    /* (struct CSource *) -- Read from this CSource stream.
       Default is FGetC(Input()); */


CONST RLI_EscapeChars          = (RLI_Dummy+10)
    /* (STRPTR) -- Nul-terminated string of one or more characters
       to be recognised as escape characters.
       This may be an empty string "" or NULL, for none.
       Defaults to "*".  */

CONST RLI_MultiLine            = (RLI_Dummy+11)
    /* (LONG; boolean) -- Enable Multi-line processing.
       Defaults to FALSE.  */

CONST RLI_CommentChars         = (RLI_Dummy+12)
    /* (STRPTR) -- Nul-terminated string of one or more characters
       to be used as a comment marker.
       This may be an empty string "" or NULL, for none.
       Defaults to "".  */

CONST RLI_Substitute_N         = (RLI_Dummy+13)
    /* (LONG; boolean) -- Substitute quoted escaped "N" to the hex
       char 0x0a.   Only works when RLI_EscapeChars is not "" or NULL.
       Defaults to TRUE.  */

CONST RLI_Substitute_E         = (RLI_Dummy+14)
    /* (LONG; boolean) -- Substitute quoted escaped "E" to the hex
       char 0x1b.   Only works when RLI_EscapeChars is not "" or NULL.
       Defaults to TRUE.  */

/*
 * Tags for SetFileHandleAttr()
 */

CONST FH_Dummy               = (TAG_USER + 6000)

CONST FH_BufferSize          = (FH_Dummy + 1)
CONST FH_UserBuffer          = (FH_Dummy + 2)
CONST FH_BufferMode          = (FH_Dummy + 3)
CONST FH_Locking             = (FH_Dummy + 4)
CONST FH_EndStream           = (FH_Dummy + 5)


/*
 * Tags for TimedDosRequester()
 */

CONST TDR_Dummy                = (TAG_USER + 3500)

CONST TDR_IDCMP_Ptr            = (TDR_Dummy+1)
    /* (ULONG *) -- Pointer to a longword initialised with the IDCMP flags
       that you want to terminate the requester on.  (Default; NULL)  */

CONST TDR_Timeout              = (TDR_Dummy+2)
    /* (LONG) -- Value in seconds to wait before requester will close without
       intervention.  A timeout will only occur with values > 0.
       It is recommended that timouts less than 10 seconds be
       avoided whenever possible, to be user-friendly. (Default; 0) */

CONST TDR_Window               = (TDR_Dummy+3)
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

CONST TDR_EasyStruct           = (TDR_Dummy+4)
    /* (struct EasyStruct *) [OPTIONAL]
       -- Pointer to your own private struct EasyStruct that has
       already been initialised.   (Default; internally allocated)  */

CONST TDR_FormatString         = (TDR_Dummy+5)
    /* (STRPTR) [OPTIONAL]
       -- The format string using RawDoFmt style specifiers that match
       the number of argument array entries.
       If this tag is present, it will override a formatstring that
       may have already been supplied with a private TDR_EasyStruct. */

CONST TDR_TitleString          = (TDR_Dummy+6)
    /* (STRPTR) [OPTIONAL]
       -- The title string for the requester.
       If this tag is present, it will override a title string that
       may have already been supplied with a private TDR_EasyStruct.  */

CONST TDR_GadgetString         = (TDR_Dummy+7)
    /* (STRPTR) [OPTIONAL]
       -- The string spec for the gadgets/text for the requester.
       If this tag is present, it will override a Gadget string
       that may have been supplied with a private TDR_EasyStruct.  */

CONST TDR_ImageType            = (TDR_Dummy+8)
    /* (ULONG) -- The visual style of this request. This argument has
       currently no effect before IPrefs is running, but should always
       be specified to indicate the style of request this is directed
       for.   (Default; TDRIMAGE_DEFAULT)
       The values for this tag are defined below.  */

ENUM
    TDRIMAGE_DEFAULT,
    TDRIMAGE_INFO,
    TDRIMAGE_WARNING,
    TDRIMAGE_ERROR,
    TDRIMAGE_QUESTION,
    TDRIMAGE_INSERTDISK

CONST TDR_ArgArray             = (TDR_Dummy+9)
    /* (APTR) [OPTIONAL]
       -- A pointer to a completely initialised argument array with
       the number of entries that correspond to the RawDoFmt()
       format specifiers.

       Do not use this tag if you want to specify up to the first
       10 arguments individually with the following TDR_Arg# tags. */

CONST TDR_Inactive             = (TDR_Dummy+10)
    /* (LONG) -- Boolean value to specify the requester should not
       be activated to avoid its stealing the users input focus.
       You should set this to TRUE when the gadgets of your requester
       contain keyboard shortcuts and its possible that the user is
       currently typing text in another application (otherwise the
       user could answer the requester by accident). This argument has
       currently no effect before IPrefs is running, keyboard shortcuts
       also won't work before.  (Default; FALSE) */

CONST TDR_CharSet              = (TDR_Dummy+11)
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


CONST TDR_Arg1            = (TDR_Dummy+20)
CONST TDR_Arg2            = (TDR_Dummy+21)
CONST TDR_Arg3            = (TDR_Dummy+22)
CONST TDR_Arg4            = (TDR_Dummy+23)
CONST TDR_Arg5            = (TDR_Dummy+24)
CONST TDR_Arg6            = (TDR_Dummy+25)
CONST TDR_Arg7            = (TDR_Dummy+26)
CONST TDR_Arg8            = (TDR_Dummy+27)
CONST TDR_Arg9            = (TDR_Dummy+28)
CONST TDR_Arg10           = (TDR_Dummy+29)


/*
 * Tags for FileSystemAttr()
 */

CONST FSA_Dummy                    = (TAG_USER + 9000)

CONST FSA_StringNameInput          = (FSA_Dummy+1)
    /* (STRPTR) -- Identify the filesystem by this name reference. */

CONST FSA_FileHandleInput          = (FSA_Dummy+2)
    /* (BPTR) -- Identify the filesystem by this FileHandle. */

CONST FSA_FileLockInput            = (FSA_Dummy+3)
    /* (BPTR) -- Identify the filesystem by this FileLock. */



CONST FSA_MaxFileNameLengthR       = (FSA_Dummy+10)
    /* (ULONG *) -- Obtain the maximum filename length. (including \0) */

CONST FSA_MaxFileNameLengthW       = (FSA_Dummy+11)
    /* (ULONG) -- Set the maximum filename length. (including \0) */

CONST FSA_VersionNumberR           = (FSA_Dummy+12)
    /* (ULONG *) -- Obtain the version/rev number for the filesystem. */

CONST FSA_DOSTypeR                 = (FSA_Dummy+13)
    /* (ULONG *) -- Obtain the dostype identifier for the filesystem. */

CONST FSA_ActivityFlushTimeoutR    = (FSA_Dummy+14)
    /* (ULONG *) -- Obtain the ticks (50th second) before a flush while active occurs. */

CONST FSA_ActivityFlushTimeoutW    = (FSA_Dummy+15)
    /* (ULONG) -- Set the ticks (50th second) before a flush while active occurs. */

CONST FSA_InactivityFlushTimeoutR  = (FSA_Dummy+16)
    /* (ULONG *) -- Obtain the ticks (50th second) before a flush when inactive occurs. */

CONST FSA_InactivityFlushTimeoutW  = (FSA_Dummy+17)
    /* (ULONG) -- Set the ticks (50th second) before a flush when inactive occurs. */

CONST FSA_MaxRecycledEntriesR      = (FSA_Dummy+18)
    /* (ULONG *) -- Obtain the number of recycled entries supported. */

CONST FSA_MaxRecycledEntriesW      = (FSA_Dummy+19)
    /* (ULONG) -- Set the number of recycled entries supported. */

CONST FSA_HasRecycledEntriesR      = (FSA_Dummy+20)
    /* (LONG *) -- Obtain boolean value if the filesystem supports recycled entries. */

CONST FSA_VersionStringR           = (FSA_Dummy+21)
    /* (UBYTE *) -- Obtain a copy of the version string for the filesystem. */

CONST FSA_VersionStringR_BufSize   = (FSA_Dummy+22)
    /* (ULONG) -- Sub tag to specify the length of the space provided for
       FSA_VersionStringR. */

CONST FSA_VersionStringR_Len    = FSA_VersionStringR_BufSize  /* temp compatibility */


