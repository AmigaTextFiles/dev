/* $VER: dostags.h 36.11 (29.4.1991) */
OPT NATIVE
MODULE 'target/utility/tagitem'
{MODULE 'dos/dostags'}

/*****************************************************************************/
/* definitions for the System() call */

NATIVE {SYS_DUMMY}	CONST SYS_DUMMY	= (TAG_USER + 32)
NATIVE {SYS_INPUT}	CONST SYS_INPUT	= (SYS_DUMMY + 1)
				/* specifies the input filehandle  */
NATIVE {SYS_OUTPUT}	CONST SYS_OUTPUT	= (SYS_DUMMY + 2)
				/* specifies the output filehandle */
NATIVE {SYS_ASYNCH}	CONST SYS_ASYNCH	= (SYS_DUMMY + 3)
				/* run asynch, close input/output on exit(!) */
NATIVE {SYS_USERSHELL}	CONST SYS_USERSHELL	= (SYS_DUMMY + 4)
				/* send to user shell instead of boot shell */
NATIVE {SYS_CUSTOMSHELL}	CONST SYS_CUSTOMSHELL	= (SYS_DUMMY + 5)
				/* send to a specific shell (data is name) */
/*	SYS_Error, */


/*****************************************************************************/
/* definitions for the CreateNewProc() call */
/* you MUST specify one of NP_Seglist or NP_Entry.  All else is optional. */

NATIVE {NP_DUMMY} CONST NP_DUMMY = (TAG_USER + 1000)
NATIVE {NP_SEGLIST}	CONST NP_SEGLIST	= (NP_DUMMY + 1)
				/* seglist of code to run for the process  */
NATIVE {NP_FREESEGLIST}	CONST NP_FREESEGLIST	= (NP_DUMMY + 2)
				/* free seglist on exit - only valid for   */
				/* for NP_Seglist.  Default is TRUE.	   */
NATIVE {NP_ENTRY}	CONST NP_ENTRY	= (NP_DUMMY + 3)
				/* entry point to run - mutually exclusive */
				/* with NP_Seglist! */
NATIVE {NP_INPUT}	CONST NP_INPUT	= (NP_DUMMY + 4)
				/* filehandle - default is Open("NIL:"...) */
NATIVE {NP_OUTPUT}	CONST NP_OUTPUT	= (NP_DUMMY + 5)
				/* filehandle - default is Open("NIL:"...) */
NATIVE {NP_CLOSEINPUT}	CONST NP_CLOSEINPUT	= (NP_DUMMY + 6)
				/* close input filehandle on exit	   */
				/* default TRUE				   */
NATIVE {NP_CLOSEOUTPUT}	CONST NP_CLOSEOUTPUT	= (NP_DUMMY + 7)
				/* close output filehandle on exit	   */
				/* default TRUE				   */
NATIVE {NP_ERROR}	CONST NP_ERROR	= (NP_DUMMY + 8)
				/* filehandle - default is Open("NIL:"...) */
NATIVE {NP_CLOSEERROR}	CONST NP_CLOSEERROR	= (NP_DUMMY + 9)
				/* close error filehandle on exit	   */
				/* default TRUE				   */
NATIVE {NP_CURRENTDIR}	CONST NP_CURRENTDIR	= (NP_DUMMY + 10)
				/* lock - default is parent's current dir  */
NATIVE {NP_STACKSIZE}	CONST NP_STACKSIZE	= (NP_DUMMY + 11)
				/* stacksize for process - default 4000    */
NATIVE {NP_NAME}		CONST NP_NAME		= (NP_DUMMY + 12)
				/* name for process - default "New Process"*/
NATIVE {NP_PRIORITY}	CONST NP_PRIORITY	= (NP_DUMMY + 13)
				/* priority - default same as parent	   */
NATIVE {NP_CONSOLETASK}	CONST NP_CONSOLETASK	= (NP_DUMMY + 14)
				/* consoletask - default same as parent    */
NATIVE {NP_WINDOWPTR}	CONST NP_WINDOWPTR	= (NP_DUMMY + 15)
				/* window ptr - default is same as parent  */
NATIVE {NP_HOMEDIR}	CONST NP_HOMEDIR	= (NP_DUMMY + 16)
				/* home directory - default curr home dir  */
NATIVE {NP_COPYVARS}	CONST NP_COPYVARS	= (NP_DUMMY + 17)
				/* boolean to copy local vars-default TRUE */
NATIVE {NP_CLI}		CONST NP_CLI		= (NP_DUMMY + 18)
				/* create cli structure - default FALSE    */
NATIVE {NP_PATH}		CONST NP_PATH		= (NP_DUMMY + 19)
				/* path - default is copy of parents path  */
				/* only valid if a cli process!	   */
NATIVE {NP_COMMANDNAME}	CONST NP_COMMANDNAME	= (NP_DUMMY + 20)
				/* commandname - valid only for CLI	   */
NATIVE {NP_ARGUMENTS}	CONST NP_ARGUMENTS	= (NP_DUMMY + 21)

/* FIX! should this be only for cli's? */
NATIVE {NP_NOTIFYONDEATH} CONST NP_NOTIFYONDEATH = (NP_DUMMY + 22)
				/* notify parent on death - default FALSE  */
				/* Not functional yet. */
NATIVE {NP_SYNCHRONOUS}	CONST NP_SYNCHRONOUS	= (NP_DUMMY + 23)
				/* don't return until process finishes -   */
				/* default FALSE.			   */
				/* Not functional yet. */
NATIVE {NP_EXITCODE}	CONST NP_EXITCODE	= (NP_DUMMY + 24)
				/* code to be called on process exit	   */
NATIVE {NP_EXITDATA}	CONST NP_EXITDATA	= (NP_DUMMY + 25)
				/* optional argument for NP_EndCode rtn -  */
				/* default NULL				   */


/*****************************************************************************/
/* tags for AllocDosObject */

NATIVE {ADO_DUMMY}	CONST ADO_DUMMY	= (TAG_USER + 2000)
NATIVE {ADO_FH_MODE}	CONST ADO_FH_MODE	= (ADO_DUMMY + 1)

NATIVE {ADO_DIRLEN}	CONST ADO_DIRLEN	= (ADO_DUMMY + 2)
				/* size in bytes for current dir buffer    */
NATIVE {ADO_COMMNAMELEN}	CONST ADO_COMMNAMELEN	= (ADO_DUMMY + 3)
				/* size in bytes for command name buffer   */
NATIVE {ADO_COMMFILELEN}	CONST ADO_COMMFILELEN	= (ADO_DUMMY + 4)
				/* size in bytes for command file buffer   */
NATIVE {ADO_PROMPTLEN}	CONST ADO_PROMPTLEN	= (ADO_DUMMY + 5)
				/* size in bytes for the prompt buffer	   */

/*****************************************************************************/
/* tags for NewLoadSeg */
/* no tags are defined yet for NewLoadSeg */
