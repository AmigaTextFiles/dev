-> morphos/dos/dostags


OPT MODULE, EXPORT

MODULE 'utility/tagitem'

-> keeping pre v50 constants all uppercase for compability.
CONST SYS_DUMMY        = TAG_USER + 32
CONST SYS_INPUT        = SYS_DUMMY + 1
CONST SYS_OUTPUT       = SYS_DUMMY + 2
CONST SYS_ASYNCH       = SYS_DUMMY + 3
CONST SYS_USERSHELL    = SYS_DUMMY + 4
CONST SYS_CUSTOMSHELL  = SYS_DUMMY + 5

/*** V50 ***/

CONST SYS_FilterTags   = SYS_DUMMY + 6   /* filters the tags passed down to CreateNewProc= , default: TRUE */

-> keeping pre v50 constants all uppercase for compability.
CONST NP_DUMMY          = TAG_USER + 1000
CONST NP_SEGLIST        = NP_DUMMY + 1
CONST NP_FREESEGLIST    = NP_DUMMY + 2
CONST NP_ENTRY          = NP_DUMMY + 3
CONST NP_INPUT          = NP_DUMMY + 4
CONST NP_OUTPUT         = NP_DUMMY + 5
CONST NP_CLOSEINPUT     = NP_DUMMY + 6
CONST NP_CLOSEOUTPUT    = NP_DUMMY + 7
CONST NP_ERROR          = NP_DUMMY + 8
CONST NP_CLOSEERROR     = NP_DUMMY + 9
CONST NP_CURRENTDIR     = NP_DUMMY + 10
CONST NP_STACKSIZE      = NP_DUMMY + 11
CONST NP_NAME           = NP_DUMMY + 12
CONST NP_PRIORITY       = NP_DUMMY + 13
CONST NP_CONSOLETASK    = NP_DUMMY + 14
CONST NP_WINDOWPTR      = NP_DUMMY + 15
CONST NP_HOMEDIR        = NP_DUMMY + 16
CONST NP_COPYVARS       = NP_DUMMY + 17
CONST NP_CLI            = NP_DUMMY + 18
CONST NP_PATH           = NP_DUMMY + 19
CONST NP_COMMANDNAME    = NP_DUMMY + 20
CONST NP_ARGUMENTS      = NP_DUMMY + 21

CONST NP_NOTIFYONDEATH  = NP_DUMMY + 22
CONST NP_SYNCHRONOUS    = NP_DUMMY + 23
CONST NP_EXITCODE       = NP_DUMMY + 24
CONST NP_EXITDATA       = NP_DUMMY + 25

/*** V50 ***/

CONST NP_SeglistArray   = NP_DUMMY + 26
CONST NP_UserData       = NP_DUMMY + 27
CONST NP_StartupMsg     = NP_DUMMY + 28  /* struct Message *, ReplyMsg'd at exit */
CONST NP_TaskMsgPort    = NP_DUMMY + 29  /* struct MsgPort **, create MsgPort, automagic delete */

CONST NP_CodeType       = NP_DUMMY + 100
CONST NP_PPC_Arg1       = NP_DUMMY + 101
CONST NP_PPC_Arg2       = NP_DUMMY + 102
CONST NP_PPC_Arg3       = NP_DUMMY + 103
CONST NP_PPC_Arg4       = NP_DUMMY + 104
CONST NP_PPC_Arg5       = NP_DUMMY + 105
CONST NP_PPC_Arg6       = NP_DUMMY + 106
CONST NP_PPC_Arg7       = NP_DUMMY + 107
CONST NP_PPC_Arg8       = NP_DUMMY + 108
CONST NP_PPCStackSize   = NP_DUMMY + 109


CONST ADO_Dummy        = TAG_USER + 2000
CONST ADO_FH_Mode      = ADO_Dummy + 1

CONST ADO_DirLen       = ADO_Dummy + 2
CONST ADO_CommNameLen  = ADO_Dummy + 3
CONST ADO_CommFileLen  = ADO_Dummy + 4
CONST ADO_PromptLen    = ADO_Dummy + 5

/*** V50 ***/

CONST ADDS_Dummy       = TAG_USER + 3000
CONST ADDS_Name        = ADDS_Dummy + 1  /* Segment name */
CONST ADDS_Seglist     = ADDS_Dummy + 2  /* Seglist for this segment */
CONST ADDS_Filename    = ADDS_Dummy + 3  /* Name of the file to load when needed. Ignored if Seglist is given. */
CONST ADDS_Type        = ADDS_Dummy + 4  /* Segment type */

CONST FNDS_Dummy       = TAG_USER + 3100
CONST FNDS_Name        = FNDS_Dummy + 1  /* Segment name */
CONST FNDS_From        = FNDS_Dummy + 2  /* Segment to start from */
CONST FNDS_System      = FNDS_Dummy + 3  /* Look for a system segment ? */
CONST FNDS_Load        = FNDS_Dummy + 4  /* Load the seglist if needed ? = Default: TRUE */

 /*** V51 ***/

CONST   FSCONTEXTTAG_Dummy      = (TAG_USER + 3200)
/*
 * Pass a custom handler seglist. This handler MUST be able
 * to handle the fscontext filesystem extension
 */
CONST   FSCONTEXTTAG_SEGLIST      = (FSCONTEXTTAG_Dummy + $1)
CONST   FSCONTEXTTAG_PRIORITY      = (FSCONTEXTTAG_Dummy + $2)
CONST   FSCONTEXTTAG_STACKSIZE      = (FSCONTEXTTAG_Dummy + $3)
CONST   FSCONTEXTTAG_STARTUPSTRING   = (FSCONTEXTTAG_Dummy + $4)
CONST   FSCONTEXTTAG_STARTUPVALUE   = (FSCONTEXTTAG_Dummy + $5)
CONST   FSCONTEXTTAG_FSSM      = (FSCONTEXTTAG_Dummy + $6)
/*
 * A matching filesystem is searched through query.library
 */
CONST   FSCONTEXTTAG_DOSTYPE      = (FSCONTEXTTAG_Dummy + $7)

CONST   FSCONTEXTINFOTAG_Dummy      = (TAG_USER + 3300)
CONST   FSCONTEXTINFOTAG_NAME      = (FSCONTEXTINFOTAG_Dummy + $1)

CONST   SEGLISTTAG_Dummy      = (TAG_USER + 3400)
/*
 * return the ObjData object when it exists or NULL.
 */
CONST   SEGLISTTAG_OBJDATA      = (SEGLISTTAG_Dummy + $1)
