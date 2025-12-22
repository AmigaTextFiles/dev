/*
 * $Id: showcrashinfo.c 1.7 1998/06/13 08:20:14 olsen Exp olsen $
 *
 * :ts=4
 *
 * Blowup -- Catches and displays task errors
 *
 * Written by Olaf `Olsen' Barthel <olsen@sourcery.han.de>
 * Public Domain
 */

#ifndef _GLOBAL_H
#include "global.h"
#endif	/* _GLOBAL_H */

/******************************************************************************/

#define TROUBLE	(-1)	/* could not open the requester */
#define REBOOT	( 0)	/* user wants to reboot the machine */
#define SUSPEND	( 1)	/* user wants the trapped task to be suspended */

/******************************************************************************/

STATIC LONG
ShowEasyRequest(
	const STRPTR	title,
	const STRPTR	gadgets,
	const STRPTR	text,
					...)
{
	struct Process * thisProcess;
	struct Window * parentWindow;
	LONG result = TROUBLE;

	/* set up the parent window pointer so the requester will
	 * open on the program's preferred screen; this works only
	 * for processes, which may not want this requester to show
	 * up in the first place
	 */

	parentWindow = NULL;

	thisProcess = (struct Process *)FindTask(NULL);
	if(thisProcess->pr_Task.tc_Node.ln_Type == NT_PROCESS)
	{
		parentWindow = thisProcess->pr_WindowPtr;
	}

	/* if the pointer is invalid, do not show the requester */
	if(parentWindow != (struct Window *)~0)
	{
		struct EasyStruct es;
		va_list varArgs;
	
		es.es_StructSize	= sizeof(es);
		es.es_Flags			= NULL;
		es.es_Title			= (STRPTR)title;
		es.es_TextFormat	= (STRPTR)text;
		es.es_GadgetFormat	= (STRPTR)gadgets;
	
		va_start(varArgs,text);
		result = EasyRequestArgs(parentWindow,&es,NULL,(APTR)varArgs);
		va_end(varArgs);
	}

	return(result);
}

/******************************************************************************/

VOID ASM
ShowCrashInfo(
	REG(d0) UBYTE	trapType,
	REG(d1) ULONG	pc,
	REG(d2) UWORD	sr,
	REG(a0) ULONG *	stackFrame)
{
	/* a short table to associate trap types with human-readable information */
	STATIC const struct { ULONG Type; STRPTR Name; } TrapTypes[] =
	{
		2,	"Bus error",
		3,	"Address error",
		4,	"Illegal instruction",
		5,	"Zero divide",
		6,	"CHK, CHK2 instructions",
		7,	"cpTRAPc, TRAPcc, TRAPV instructions",
		8,	"Privilege violation",
		9,	"Trace",
		10,	"Line 1010 emulator",
		11,	"Line 1111 emulator",
		13,	"Coprocessor protocol violation",
		14,	"Stack frame format error",
		15,	"Uninitialized interrupt",
		24,	"Spurious interrupt",
		25,	"Level 1 interrupt autovector (SOFTINT, DSKBLK, TBE)",
		26,	"Level 2 interrupt autovector (PORTS)",
		27,	"Level 3 interrupt autovector (COPER, VERTB, BLIT)",
		28,	"Level 4 interrupt autovector (AUD2, AUD0, AUD3, AUD1)",
		29,	"Level 5 interrupt autovector (RBF, DSKSYNC)",
		30,	"Level 6 interrupt autovector (EXTER)",
		31,	"Level 7 interrupt autovector (NMI)",
		32,	"TRAP #0 instruction",
		33,	"TRAP #1 instruction",
		34,	"TRAP #2 instruction",
		35,	"TRAP #3 instruction",
		36,	"TRAP #4 instruction",
		37,	"TRAP #5 instruction",
		38,	"TRAP #6 instruction",
		39,	"TRAP #7 instruction",
		40,	"TRAP #8 instruction",
		41,	"TRAP #9 instruction",
		42,	"TRAP #10 instruction",
		43,	"TRAP #11 instruction",
		44,	"TRAP #12 instruction",
		45,	"TRAP #13 instruction",
		46,	"TRAP #14 instruction",
		47,	"TRAP #15 instruction",
		48,	"FPCP Branch or Set on unordered condition",
		49,	"FPCP inexact result",
		50,	"FPCP divide by zero",
		51,	"FPCP underflow",
		52,	"FPCP operand error",
		53,	"FPCP overflow",
		54,	"FPCP signaling NAN",
		56,	"MMU configuration error",
		57,	"MMU illegal operation error",
		58,	"MMU access level violation error"
	};

	UBYTE errorBuffer[40];
	STRPTR errorType;
	UBYTE nameBuffer[MAX_FILENAME_LEN];
	struct Process * thisProcess;
	STRPTR taskType;
	LONG response;
	int i;

	/* check whether the exception came from supervisor mode
	 * or whether it was triggered from an interrupt; if that
	 * happens, we will know that we are in trouble and thus
	 * fall straight into a dead-end alert
	 */
	if((sr & 0x2700) != 0)
	{
		Alert(AT_DeadEnd | trapType);
	}

	/* we really are busy now */
	ObtainSemaphoreShared(&BusySemaphore);

	/* find an explanation for the exception condition */
	errorType = NULL;
	for(i = 0 ; i < NUM_ELEMENTS(TrapTypes) ; i++)
	{
		if(TrapTypes[i].Type == trapType)
		{
			errorType = (STRPTR)TrapTypes[i].Name;
			break;
		}
	}

	/* if no explanation could be found, just list the trap number */
	if(errorType == NULL)
	{
		errorType = errorBuffer;

		SPrintfN(sizeof(errorBuffer),errorBuffer,"Exception #%ld",trapType);
	}

	/* show the error and the status information */
	VoiceComplaint(trapType,sr,pc,stackFrame,"%s\n",errorType);

	/* determine the name and the type of the current task */
	thisProcess = (struct Process *)FindTask(NULL);
	
	StrcpyN(sizeof(nameBuffer),nameBuffer,thisProcess->pr_Task.tc_Node.ln_Name);
	
	if(thisProcess->pr_Task.tc_Node.ln_Type == NT_PROCESS)
	{
		struct CommandLineInterface * cli;
	
		taskType = "Process";
	
		cli = BADDR(thisProcess->pr_CLI);
		if(cli != NULL)
		{
			if(cli->cli_CommandName != NULL)
			{
				SPrintfN(sizeof(nameBuffer),nameBuffer,"%b",cli->cli_CommandName);
				taskType = "Shell program";
			}
		}
	}
	else
	{
		taskType = "Task";
	}
	
	/* say what happened and ask the user to decide what to do next */
	response = ShowEasyRequest("Software error","Suspend|Reboot",
		"%s \"%s\" stopped.\n\n"
		"Finish ALL disk activity\n"
		"before you select \"Reboot\"!",taskType,nameBuffer);
	
	/* release the busy semaphore, but without allowing multitasking
	 * to resume; that would be a bad idea because we are not going
	 * to be busy any more in a minute but wouldn't want anyone else
	 * to consider us busy until we have actually gone into suspension
	 */
	Forbid();

	ReleaseSemaphore(&BusySemaphore);
	
	/* if the requester did not open or if the task was to be
	 * suspended, wait forever for a signal that will never arrive
	 */
	if(response == TROUBLE || response == SUSPEND)
	{
		Wait(0);
	}
	else
	{
		/* drop straight into a dead-end alert that
		 * will eventually trigger a reboot
		 */
		Alert(AT_DeadEnd | trapType);
	}
}
