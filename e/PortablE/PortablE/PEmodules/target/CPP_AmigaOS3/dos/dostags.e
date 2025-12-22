/* $VER: dostags.h 36.11 (29.4.1991) */
OPT NATIVE
MODULE 'target/utility/tagitem'
{#include <dos/dostags.h>}
NATIVE {DOS_DOSTAGS_H} CONST

/*****************************************************************************/
/* definitions for the System() call */

NATIVE {SYS_Dummy}	CONST SYS_DUMMY	= (TAG_USER + 32)
NATIVE {SYS_Input}	CONST SYS_INPUT	= (SYS_DUMMY + 1)
				/* specifies the input filehandle  */
NATIVE {SYS_Output}	CONST SYS_OUTPUT	= (SYS_DUMMY + 2)
				/* specifies the output filehandle */
NATIVE {SYS_Asynch}	CONST SYS_ASYNCH	= (SYS_DUMMY + 3)
				/* run asynch, close input/output on exit(!) */
NATIVE {SYS_UserShell}	CONST SYS_USERSHELL	= (SYS_DUMMY + 4)
				/* send to user shell instead of boot shell */
NATIVE {SYS_CustomShell}	CONST SYS_CUSTOMSHELL	= (SYS_DUMMY + 5)
				/* send to a specific shell (data is name) */
/*	SYS_Error, */


/*****************************************************************************/
/* definitions for the CreateNewProc() call */
/* you MUST specify one of NP_Seglist or NP_Entry.  All else is optional. */

NATIVE {NP_Dummy} CONST NP_DUMMY = (TAG_USER + 1000)
NATIVE {NP_Seglist}	CONST NP_SEGLIST	= (NP_DUMMY + 1)
				/* seglist of code to run for the process  */
NATIVE {NP_FreeSeglist}	CONST NP_FREESEGLIST	= (NP_DUMMY + 2)
				/* free seglist on exit - only valid for   */
				/* for NP_Seglist.  Default is TRUE.	   */
NATIVE {NP_Entry}	CONST NP_ENTRY	= (NP_DUMMY + 3)
				/* entry point to run - mutually exclusive */
				/* with NP_Seglist! */
NATIVE {NP_Input}	CONST NP_INPUT	= (NP_DUMMY + 4)
				/* filehandle - default is Open("NIL:"...) */
NATIVE {NP_Output}	CONST NP_OUTPUT	= (NP_DUMMY + 5)
				/* filehandle - default is Open("NIL:"...) */
NATIVE {NP_CloseInput}	CONST NP_CLOSEINPUT	= (NP_DUMMY + 6)
				/* close input filehandle on exit	   */
				/* default TRUE				   */
NATIVE {NP_CloseOutput}	CONST NP_CLOSEOUTPUT	= (NP_DUMMY + 7)
				/* close output filehandle on exit	   */
				/* default TRUE				   */
NATIVE {NP_Error}	CONST NP_ERROR	= (NP_DUMMY + 8)
				/* filehandle - default is Open("NIL:"...) */
NATIVE {NP_CloseError}	CONST NP_CLOSEERROR	= (NP_DUMMY + 9)
				/* close error filehandle on exit	   */
				/* default TRUE				   */
NATIVE {NP_CurrentDir}	CONST NP_CURRENTDIR	= (NP_DUMMY + 10)
				/* lock - default is parent's current dir  */
NATIVE {NP_StackSize}	CONST NP_STACKSIZE	= (NP_DUMMY + 11)
				/* stacksize for process - default 4000    */
NATIVE {NP_Name}		CONST NP_NAME		= (NP_DUMMY + 12)
				/* name for process - default "New Process"*/
NATIVE {NP_Priority}	CONST NP_PRIORITY	= (NP_DUMMY + 13)
				/* priority - default same as parent	   */
NATIVE {NP_ConsoleTask}	CONST NP_CONSOLETASK	= (NP_DUMMY + 14)
				/* consoletask - default same as parent    */
NATIVE {NP_WindowPtr}	CONST NP_WINDOWPTR	= (NP_DUMMY + 15)
				/* window ptr - default is same as parent  */
NATIVE {NP_HomeDir}	CONST NP_HOMEDIR	= (NP_DUMMY + 16)
				/* home directory - default curr home dir  */
NATIVE {NP_CopyVars}	CONST NP_COPYVARS	= (NP_DUMMY + 17)
				/* boolean to copy local vars-default TRUE */
NATIVE {NP_Cli}		CONST NP_CLI		= (NP_DUMMY + 18)
				/* create cli structure - default FALSE    */
NATIVE {NP_Path}		CONST NP_PATH		= (NP_DUMMY + 19)
				/* path - default is copy of parents path  */
				/* only valid if a cli process!	   */
NATIVE {NP_CommandName}	CONST NP_COMMANDNAME	= (NP_DUMMY + 20)
				/* commandname - valid only for CLI	   */
NATIVE {NP_Arguments}	CONST NP_ARGUMENTS	= (NP_DUMMY + 21)
/* cstring of arguments - passed with str in a0, length in d0.	*/
/* (copied and freed on exit.)	Default is 0-length NULL ptr.	*/
/* NOTE: not operational until V37 - see BIX/TechNotes for	*/
/* more info/workaround.  In V36, the registers were random.	*/
/* You must NEVER use NP_Arguments with a NP_Input of NULL.	*/

/* FIX! should this be only for cli's? */
NATIVE {NP_NotifyOnDeath} CONST NP_NOTIFYONDEATH = (NP_DUMMY + 22)
				/* notify parent on death - default FALSE  */
				/* Not functional yet. */
NATIVE {NP_Synchronous}	CONST NP_SYNCHRONOUS	= (NP_DUMMY + 23)
				/* don't return until process finishes -   */
				/* default FALSE.			   */
				/* Not functional yet. */
NATIVE {NP_ExitCode}	CONST NP_EXITCODE	= (NP_DUMMY + 24)
				/* code to be called on process exit	   */
NATIVE {NP_ExitData}	CONST NP_EXITDATA	= (NP_DUMMY + 25)
				/* optional argument for NP_EndCode rtn -  */
				/* default NULL				   */


/*****************************************************************************/
/* tags for AllocDosObject */

NATIVE {ADO_Dummy}	CONST ADO_DUMMY	= (TAG_USER + 2000)
NATIVE {ADO_FH_Mode}	CONST ADO_FH_MODE	= (ADO_DUMMY + 1)
				/* for type DOS_FILEHANDLE only		   */
				/* sets up FH for mode specified.
				   This can make a big difference for buffered
				   files.				   */
	/* The following are for DOS_CLI */
	/* If you do not specify these, dos will use it's preferred values */
	/* which may change from release to release.  The BPTRs to these   */
	/* will be set up correctly for you.  Everything will be zero,	   */
	/* except cli_FailLevel (10) and cli_Background (DOSTRUE).	   */
	/* NOTE: you may also use these 4 tags with CreateNewProc.	   */

NATIVE {ADO_DirLen}	CONST ADO_DIRLEN	= (ADO_DUMMY + 2)
				/* size in bytes for current dir buffer    */
NATIVE {ADO_CommNameLen}	CONST ADO_COMMNAMELEN	= (ADO_DUMMY + 3)
				/* size in bytes for command name buffer   */
NATIVE {ADO_CommFileLen}	CONST ADO_COMMFILELEN	= (ADO_DUMMY + 4)
				/* size in bytes for command file buffer   */
NATIVE {ADO_PromptLen}	CONST ADO_PROMPTLEN	= (ADO_DUMMY + 5)
				/* size in bytes for the prompt buffer	   */

/*****************************************************************************/
/* tags for NewLoadSeg */
/* no tags are defined yet for NewLoadSeg */
