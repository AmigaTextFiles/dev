/* $Id: dostags.h 15065 2002-07-30 12:50:52Z falemagn $ */
OPT NATIVE
MODULE 'target/utility/tagitem'
MODULE 'target/exec/types'
{#include <dos/dostags.h>}
NATIVE {DOS_DOSTAGS_H} CONST

NATIVE {NP_Dummy}        CONST NP_DUMMY        = (TAG_USER + 1000)

/* Exactly one of NP_Seglist or NP_Entry must be specified. */
  /* (BPTR) Seglist of code for process. */
NATIVE {NP_Seglist}	CONST NP_SEGLIST	= (NP_DUMMY + 1)
  /* (BOOL) Free seglist on exit? (Default: TRUE) */
NATIVE {NP_FreeSeglist}	CONST NP_FREESEGLIST	= (NP_DUMMY + 2)
  /* (APTR) Entry point for process code. */
NATIVE {NP_Entry}	CONST NP_ENTRY	= (NP_DUMMY + 3)

  /* (BPTR/struct FileHandle *) Input filehandle. (Default: NIL:) */
NATIVE {NP_Input}	CONST NP_INPUT	= (NP_DUMMY + 4)
  /* (BPTR/struct FileHandle *) Output filehandle. (Default: NIL:) */
NATIVE {NP_Output}	CONST NP_OUTPUT	= (NP_DUMMY + 5)
  /* (BOOL) Close input filehandle on exit? (Default: TRUE) */
NATIVE {NP_CloseInput}	CONST NP_CLOSEINPUT	= (NP_DUMMY + 6)
  /* (BOOL) Close output filehandle in exit? (Default: TRUE) */
NATIVE {NP_CloseOutput}	CONST NP_CLOSEOUTPUT	= (NP_DUMMY + 7)
  /* (BPTR/struct FileHandle *) Error filehandle. (Default: NIL:) */
NATIVE {NP_Error}	CONST NP_ERROR	= (NP_DUMMY + 8)
  /* (BOOL) Close error filehandle on exit? (Default: TRUE) */
NATIVE {NP_CloseError}	CONST NP_CLOSEERROR	= (NP_DUMMY + 9)

  /* (BPTR/struct FileLock *) Current directory for new task. */
NATIVE {NP_CurrentDir}	CONST NP_CURRENTDIR	= (NP_DUMMY + 10)
  /* (ULONG) Stacksize to use for the new process. Default is variable. */
NATIVE {NP_StackSize}	CONST NP_STACKSIZE	= (NP_DUMMY + 11)
  /* (STRPTR) Name for the new process. (Default: "New Process") */
NATIVE {NP_Name} 	CONST NP_NAME 	= (NP_DUMMY + 12)
  /* (LONG) Priority of the new process. */
NATIVE {NP_Priority}	CONST NP_PRIORITY	= (NP_DUMMY + 13)

  /* (APTR) Pointer to the console task. */
NATIVE {NP_ConsoleTask}	CONST NP_CONSOLETASK	= (NP_DUMMY + 14)
  /* (struct Window *) The processes default window. */
NATIVE {NP_WindowPtr}	CONST NP_WINDOWPTR	= (NP_DUMMY + 15)
  /* (BPTR/struct FileLock *) The home directory of the new process. This
     defaults to the parents current directory. */
NATIVE {NP_HomeDir}	CONST NP_HOMEDIR	= (NP_DUMMY + 16)
  /* (BOOL) Copy local environment variables? (Default: TRUE) */
NATIVE {NP_CopyVars}	CONST NP_COPYVARS	= (NP_DUMMY + 17)
  /* (BOOL) Create a CLI structure? (Default: FALSE) */
NATIVE {NP_Cli}		CONST NP_CLI		= (NP_DUMMY + 18)

/* The following two tags are only valid for CLI processes. */
  /* (APTR) Path for the new process. */
NATIVE {NP_Path} 	CONST NP_PATH 	= (NP_DUMMY + 19)
  /* (STRPTR) Name of the called program. */
NATIVE {NP_CommandName}	CONST NP_COMMANDNAME	= (NP_DUMMY + 20)
  /* If this tag is used, NP_Input must not be NULL. */
NATIVE {NP_Arguments}	CONST NP_ARGUMENTS	= (NP_DUMMY + 21)

/* The following two tags do not work, yet. */
  /* (BOOL) Notify parent, when process exits? (Default: FALSE) */
NATIVE {NP_NotifyOnDeath} CONST NP_NOTIFYONDEATH = (NP_DUMMY + 22)
  /* (BOOL) Wait until called process returns. (Default: FALSE) */
NATIVE {NP_Synchronous}	CONST NP_SYNCHRONOUS	= (NP_DUMMY + 23)

  /* (APTR) Code that is to be called, when process exits. (Default: NULL) */
NATIVE {NP_ExitCode}	CONST NP_EXITCODE	= (NP_DUMMY + 24)
  /* (APTR) Optional data for NP_ExitCode. (Default: NULL) */
NATIVE {NP_ExitData}	CONST NP_EXITDATA	= (NP_DUMMY + 25)

NATIVE {NP_UserData}	CONST NP_USERDATA	= (NP_DUMMY + 26)


NATIVE {SYS_Dummy}       CONST SYS_DUMMY       = (TAG_USER + 32)

NATIVE {SYS_Input}	CONST SYS_INPUT	= (SYS_DUMMY + 1)
NATIVE {SYS_Output}	CONST SYS_OUTPUT	= (SYS_DUMMY + 2)
NATIVE {SYS_Asynch}	CONST SYS_ASYNCH	= (SYS_DUMMY + 3)
NATIVE {SYS_UserShell}	CONST SYS_USERSHELL	= (SYS_DUMMY + 4) /* (BPTR) */
NATIVE {SYS_CustomShell} CONST SYS_CUSTOMSHELL = (SYS_DUMMY + 5) /* (STRPTR) */

NATIVE {SYS_Error}	CONST SYS_ERROR	= (SYS_DUMMY + 10)
NATIVE {SYS_ScriptInput} CONST SYS_SCRIPTINPUT = (SYS_DUMMY + 11)
NATIVE {SYS_Background}  CONST SYS_BACKGROUND  = (SYS_DUMMY + 12)
NATIVE {SYS_CliNumPtr}   CONST SYS_CLINUMPTR   = (SYS_DUMMY + 13)

NATIVE {SYS_DupStream}   CONST SYS_DUPSTREAM   = 1

/* Tags for AllocDosObject(). */

NATIVE {ADO_Dummy}	CONST ADO_DUMMY	= (TAG_USER + 2000)

NATIVE {ADO_FH_Mode}	CONST ADO_FH_MODE	= (ADO_DUMMY + 1) /* Sets up FH to the specified mode. */

  /* Length of current directory buffer. */
NATIVE {ADO_DirLen}	CONST ADO_DIRLEN	= (ADO_DUMMY + 2)
  /* Length of command name buffer. */
NATIVE {ADO_CommNameLen} CONST ADO_COMMNAMELEN = (ADO_DUMMY + 3)
  /* Length of command file buffer. */
NATIVE {ADO_CommFileLen} CONST ADO_COMMFILELEN = (ADO_DUMMY + 4)
  /* Length of buffer for CLI prompt. */
NATIVE {ADO_PromptLen}	CONST ADO_PROMPTLEN	= (ADO_DUMMY + 5)
