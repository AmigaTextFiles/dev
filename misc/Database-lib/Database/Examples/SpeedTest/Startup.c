/* Startup.c
 *
 * The startup-procedure for system independent programs.
 * Currently defined for AmigaOS and Windoof, must be linked to every
 * application, so the whole (other) sourcecode is system independent.
 *
 ***** WARNING *****
 *
 * Under AmigaOS the object module - create by compiling this source - MUST be
 *	the first module that is passed to the linker, so the function of this
 *	module is the first function in the executeable; otherwise you will crash
 * the system, if you start the application!
 *
 * Don't link any compiler-specific startup-code to your application !
 *
 ***** WARNING *****
 *
 * This function calls a function "Main", which is the entrypoint for
 * every application and therefor must be written for every application.
 *
 * Prototype:
 *
 * LONG Main (LONG length, char* cmdline);
 *
 * result = Main (length, cmdline);
 *
 * The function is called with two arguments:
 * First argument is the length of the commandline string passed as second
 * argument.
 * The commandline holds a string with all commandline arguments passed to the
 * application on startup. The arguments could be parsed using ParseArg() (see
 * "ParseArgs.h" for details). The argument should be used as read-only also it
 * isn't declared as const.
 * If no arguments were passed to the application, the commandline should point
 * to an empty string ("") and the length should therefor be 0.
 * If the length is equal -1, the commandline argument points to a WBStartup
 * structure, the application is started from Workbench (without an associated
 * console window).
 *
 * Inputs:
 *		length  = range between -1 and 255
 *		cmdline = pointer to char or pointer to struct WBStartup
 *
 * Result:
 * 	The function should return an error code as described in "define.h".
 */

#define __USE_SYSBASE 1

/* --- Includes ------------------------------------------------------------- */

#include <joinOS/exec/defines.h>	/* basic headerfile for every application */
#include <joinOS/dos/AmigaDOS.h>
#include <joinOS/dos/DosProcess.h>
#include <joinOS/protos/AmigaDosProtos.h>
#include <joinOS/exec/Exec.h>
#include <joinOS/protos/ExecProtos.h>
#include <joinOS/protos/JoinOSProtos.h>	/* Macro GetSysBase() */

#ifndef _AMIGA
#include <string.h>
#endif

/* --- The prototype of the application main function (system independent) -- */

LONG Main (LONG length, char* cmdline);

/* --- Globals (needed by every application) -------------------------------- */

struct ExecBase *SysBase = NULL;
struct DosLibrary *DOSBase = NULL;
/* struct Library *JoinOSBase = NULL; */

#ifdef _AMIGA

/* --- The System specific startup function. (definition) ------------------- */

/* NAME
 *		main - entry-point, called from system
 *
 *	SYNOPSIS
 *		result = main (length, cmdline)
 *		  D0            D0       A0
 *		long main (long, const char *) 
 *
 * FUNCTION
 *		This is the entry-point of every application; this function is called
 *		direct from the system and has to be the first function in the object-
 *		file.
 *
 * INPUTS
 *		length - the length of the passed command line (>= 0)
 *		cmdline - the command line buffer with the arguments as specified on
 *					 application start, NULL if started from Workbench.
 * RESULT
 *		The function returns either RETURN_FAIL or the returncode as returned by
 *		the application specific Main() function, which should be either
 *		RETURN_FAIL, RETURN_ERROR, RETURN_WARN, or RETURN_OK so this returncode
 *		could be processed by the commands FAILAT and IF in batch-processing.
 */
__saveds long __asm main ( register __d0 long length,
									register __a0 const char* cmdline)
{
	long rc = RETURN_FAIL;
	struct Process *proc;
	struct WBStartup *wbstartup=NULL;

	/* initialize data */
	SysBase = GetSysBase();

	if (proc = (struct Process *)FindTask(NULL))	/* find own Process structure */
	{
		if (proc->pr_CLI == NULL)
		{
			/* Application started from Workbench ->
			 * Wait for WBStartup-Message...
			 */
			WaitPort (&proc->pr_MsgPort);

			/* remove WBStartup-Message ...
			 */
			wbstartup = (struct WBStartup*)GetMsg(&proc->pr_MsgPort);
		}

		/* Open the libraries
		 */
		if (DOSBase = (struct DosLibrary *)OpenLibrary ("dos.library",0L))
		{
			if (wbstartup)
			{
				/* Application started from Workbench...
				 */
				rc = Main (-1, (char *)wbstartup);
			}
			else
			{
				/* Application started from cli...
				 */
#pragma msg 104 ignore		/* no warn for conversion from "const char*" to "char*" */
				rc = Main (length, cmdline); /* Application started from cli */
#pragma msg 104 warn			/* warn for conversion from "const char*" to "char*" */
			}
			CloseLibrary ((struct Library *)DOSBase);
		}
		if (wbstartup)
		{
			Forbid();	/* disable taskswitch */
			/* reply WBStartup message to notify Workbench from terminating app */
			ReplyMsg ((struct Message *)wbstartup);
		}
	}
	return rc;
}
#else

/* --- The System specific startup function. (definition) ------------------- */

/* NAME
 *		WinMain - entry-point, called from system
 *
 *	SYNOPSIS
 *		result = WinMain (hInstance, hPrevInstance, cmdline, iCmdShow)
 *		  D0            D0       A0
 *		int WinMain (HINSTANCE, HINSTANCE, LPSTR, int) 
 *
 * FUNCTION
 *		This is the entry-point of every application; this function is called
 *		direct from the system and has to be the first function in the object-
 *		file.
 *
 * INPUTS
 *		hInstance - The instance-handle of the current Windoof-process
 *		hPrevInstance - relict from Windoof 3.x, always NULL under Win32
 *		cmdline - the command line buffer with the arguments as specified on
 *					 application start.
 *		iCmdShow - a constant, describing how the main-window of a Windoof-
 *					  application should be opened (ignored by this startup-code)
 * RESULT
 *		The function returns either RETURN_FAIL or the returncode as returned by
 *		the application specific Main() function, which should be either
 *		RETURN_FAIL, RETURN_ERROR, RETURN_WARN, or RETURN_OK so this returncode
 *		could be processed by the commands FAILAT and IF in batch-processing.
 */
int WINAPI WinMain (HINSTANCE hInstance, HINSTANCE hPrevInstance,
							LPSTR cmdline, int iCmdShow)
{
	long rc = RETURN_FAIL;
	struct Process *pr;
	struct DevProc *boot = NULL, *dp;
	UBYTE *path = NULL, *p;
	struct CommandLineInterface *cli;
	BOOL winStart = FALSE;

	/* initialize data...
	 */
	SysBase = GetSysBase();

	if (pr = (struct Process *)FindTask(NULL))	/* find own Process structure */
	{
		/* Open the libraries
		 */
		if (DOSBase = (struct DosLibrary *)OpenLibrary ("dos.library",0L))
		{
			/* Finally initialize the Process structure...
			 */
			if (!pr->pr_FileSystemTask) winStart = TRUE;

			if (boot = GetDeviceProc (NULL, NULL))
			{
				if (winStart)
				{
					/* This process has been started from Windoof explorer...
					 */
					if (path = AllocMem (MAX_PATH, MEMF_ANY))
					{
						/* This currently opens a console also if the process was invoked
						 * by the windoof explorer as a non-console application...
						 */
						wsprintf (path, "CON:0/0/630/320/%s",pr->pr_Task.tc_Node.ln_Name);
						if (dp = GetDeviceProc (path, NULL))
						{
							pr->pr_ConsoleTask = dp->dvp_Port;
							pr->pr_CIS = Open ("*", MODE_OLDFILE);
							pr->pr_COS = Open ("*", MODE_NEWFILE);
							pr->pr_CES = Open ("*", MODE_NEWFILE);
							FreeDeviceProc (dp);
							pr->pr_Flags |= (PRF_CLOSEINPUT | PRF_CLOSEOUTPUT);
						}

						/* handler for boot-device started, pr_FileSystemTask and
						 * dos.library's rn_BootProc should be set up...
						 */

						if (pr->pr_HomeDir == NULL)
						{
							/* Create a Lock for the home directory...
							 */
							if (GetModuleFileName (hInstance, path, MAX_PATH))
							{
								p = FilePart (path);
								*p = '\0';
								pr->pr_HomeDir = Lock (path, SHARED_LOCK);

								/* Use the home directory lock for the current
								 * directory lock...
								 */
							}
							if (pr->pr_CurrentDir == NULL)
							{
								if (GetCurrentDirectory (MAX_PATH, path))
								{
									pr->pr_CurrentDir = Lock (path, SHARED_LOCK);
									pr->pr_Flags |= PRF_FREECURRDIR;
								}
							}
						}
						FreeMem (path, MAX_PATH);
					}
				}
			}
			rc = Main (strlen (cmdline), cmdline);

			/* Set the returncode to the CommandLineInterface structure...
			 */
			if (cli = (struct CommandLineInterface *)BADDR(pr->pr_CLI))
			{
				cli->cli_ReturnCode = rc;
				cli->cli_Result2 = pr->pr_Result2;
			}
			if (pr->pr_CIS) Close (pr->pr_CIS);
			if (pr->pr_COS) Close (pr->pr_COS);
			if (pr->pr_CES) Close (pr->pr_CES);
			pr->pr_CIS = NULL;
			pr->pr_COS = NULL;
			pr->pr_CES = NULL;

			if (boot) FreeDeviceProc (boot);

			CloseLibrary ((struct Library *)DOSBase);
		}
	}
	return rc;		/* never called */
}
#endif
