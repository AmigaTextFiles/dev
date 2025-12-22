/* DOSProcess.h
 *
 * The base structures for AmigaDOS-processes.
 */

#ifndef _DOSPROCESS_H_
#define _DOSPROCESS_H_ 1

#ifndef _AMIGADOS_H_
#include <joinOS/dos/AmigaDOS.h>
#endif

#ifdef _AMIGA

#ifndef DOS_DOSEXTENS_H
#include <dos/dosextens.h>
#endif

#else				/* _AMIGA */

#ifndef _TASKS_H_
#include <joinOS/exec/tasks.h>
#endif

#ifndef _PORTS_H_
#include <joinOS/exec/ports.h>
#endif

#endif			/* _AMIGA */

/* --- pathlist structure --------------------------------------------------- */

/* A singly linked list of this structures is pointed by the cli_CommandDir
 * field of the CommandLineInterface structure the Process's field pr_CLI
 * points to.
 * This structure is NOT defined in the Commodore-supplied header files, but
 * nevertheless officially documented:
 */

struct PathList
{
	BPTR nextPath;	/* BPTR to struct PathList */
	BPTR pathLock;	/* BPTR to struct FileLock */
};

#ifndef _AMIGA

/* --- Process structure ---------------------------------------------------- */

/* All DOS processes have this structure.
 * Create and Device Proc returns pointer to the MsgPort in this structure
 * dev_proc = (struct Process *) (DeviceProc(..) - sizeof(struct Task));
 *
 * Not all fields of this structure are used in this implementation, and the
 * used fields might be used different as under AmigsOS.
 * SO DON'T DEPEND ON THIS FIELDS, DON'T ACCESS ANY OF THE FIELDS OF THIS
 * STRUCTURE FROM WITHIN USER-APPLICATIONS.
 */

struct Process
{
    struct  Task    pr_Task;
    struct  MsgPort pr_MsgPort;	/* This is BPTR address from DOS functions	*/
    WORD    pr_Pad;					/* Remaining variables on 4 byte boundaries	*/
    BPTR    pr_SegList;				/* Array of seg lists used by this process	*/
    LONG    pr_StackSize;			/* Size of process stack in bytes				*/
    APTR    pr_GlobVec;				/* Global vector for this process (BCPL)		*/
    LONG    pr_TaskNum;				/* CLI task number or zero if not a CLI		*/
    BPTR    pr_StackBase;			/* Ptr to high memory end of process stack	*/
    LONG    pr_Result2;				/* Value of secondary result from last call	*/
    BPTR    pr_CurrentDir;			/* Lock associated with current directory		*/
    BPTR    pr_CIS;					/* Current CLI Input Stream						*/
    BPTR    pr_COS;					/* Current CLI Output Stream						*/
    APTR    pr_ConsoleTask;		/* Console handler process for current window*/
    APTR    pr_FileSystemTask;	/* File handler process for current drive		*/
    BPTR    pr_CLI;					/* pointer to CommandLineInterface				*/
    APTR    pr_ReturnAddr;			/* pointer to previous stack frame				*/
    APTR    pr_PktWait;				/* Function to be called when awaiting msg	*/
    APTR    pr_WindowPtr;			/* Window for error printing						*/

    /* following definitions are new with 2.0 */
    BPTR    pr_HomeDir;				/* Home directory of executing program			*/
    LONG    pr_Flags;				/* flags telling dos about process				*/
    void    (*pr_ExitCode)();		/* code to call on exit of program or NULL	*/
    LONG    pr_ExitData;			/* Passed as an argument to pr_ExitCode.		*/
    UBYTE   *pr_Arguments;			/* Arguments passed to the process at start	*/
    struct MinList pr_LocalVars;	/* Local environment variables					*/
    ULONG   pr_ShellPrivate;		/* for the use of the current shell				*/
    BPTR    pr_CES;					/* Error stream - if NULL, use pr_COS			*/
};


/* Flags for pr_Flags
 */
#define	PRB_FREESEGLIST	0
#define	PRF_FREESEGLIST	1
#define	PRB_FREECURRDIR	1
#define	PRF_FREECURRDIR	2
#define	PRB_FREECLI			2
#define	PRF_FREECLI			4
#define	PRB_CLOSEINPUT		3
#define	PRF_CLOSEINPUT		8
#define	PRB_CLOSEOUTPUT	4
#define	PRF_CLOSEOUTPUT	16
#define	PRB_FREEARGS		5
#define	PRF_FREEARGS		32

/* Private flags for pr_Flags - DON'T USE THEM IN USER_APPLICATION
 */
#define PRB_ASYNC				6
#define PRF_ASYNC				64

/* --- CommandLineInterface structure --------------------------------------- */

/* AmigaDos CLI-processes get a pointer to a structure of this type in pr_CLI,
 * this would normaly be used to access shell-specific data of the underlying
 * shell, the fields of this structure should be treated as "read-only".
 */

struct CommandLineInterface
{
	LONG cli_Result2;		/* copy of pr_Result2 of the last executed CLI command */
	BSTR cli_SetName;		/* name of the current working directory */
	BPTR cli_CommandDir;	/* BPTR to struct PathList */
	LONG cli_ReturnCode;	/* primary return code of last executed CLI command */
	BSTR cli_CommandName;	/* name of the CLI command currently being executed */
	LONG cli_FailLevel;		/* this is the current failure level */
	BSTR cli_Prompt;			/* buffer of the CLI's prompt */
	BPTR cli_StandardInput;	/* terminal input stream (default) */
	BPTR cli_CurrentInput;	/* current input stream */
	BSTR cli_CommandFile;	/* name of temporary script file */
	LONG cli_Interactive;	/* boolean, determines whether prompts are required */
	LONG cli_Background;		/* boolean, determines whether CLI runs in background */
	BPTR cli_CurrentOutput;	/* current output stream (allways equal cli_StandardOutput */
	LONG cli_DefaultStack;	/* size of command stack */
	BPTR cli_StandardOutput;/* standard output stream */
	BPTR cli_Module;			/* SegList of the program currently loaded */
};

/* --- DevProc structure ---------------------------------------------------- */

/* A structure of this kind is returned by GetDeviceProc().
 */
struct DevProc
{
	struct MsgPort *dvp_Port;		/* handler's processID */
	BPTR dvp_Lock;						/* BPTR to struct FileLock */
	ULONG dvp_Flags;					/* internal flags */
	struct DosList *dvp_DevNode;	/* private pointer to DosList */
};

/* Defines for dvp_Flags
 */

#define DVPF_UNLOCK 0x00000001
#define DVPF_ASSIGN 0x00000002

/* --- Hunk types of "LoadModules" loaded by LoadSeg() ---------------------- */

/* hunk types (small subset)
 */
#define HUNK_UNIT	999
#define HUNK_NAME	1000
#define HUNK_CODE	1001
#define HUNK_DATA	1002
#define HUNK_BSS	1003
#define HUNK_RELOC32	1004
#define HUNK_RELOC16	1005
#define HUNK_RELOC8	1006
#define HUNK_EXT	1007
#define HUNK_SYMBOL	1008
#define HUNK_DEBUG	1009
#define HUNK_END	1010
#define HUNK_HEADER	1011
#define HUNK_OVERLAY	1013
#define HUNK_BREAK	1014

#endif		/* _AMIGA */

#endif		/* PROCESS_H_ */