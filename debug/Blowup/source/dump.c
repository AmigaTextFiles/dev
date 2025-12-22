/*
 * $Id: dump.c 1.4 1998/04/26 08:15:05 olsen Exp olsen $
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

STATIC VOID
DumpRange(
	const STRPTR	header,
	const ULONG *	range,
	int				numRangeLongs,
	BOOL			check)
{
	int i;

	/* dump and check a range of long words. */
	for(i = 0 ; i < numRangeLongs ; i++)
	{
		if((i % 8) == 0)
		{
			DPrintf("%s:",header);
		}

		DPrintf(" %08lx",range[i]);

		if((i % 8) == 7)
		{
			DPrintf("\n");

			/* check every long word processed so far? */
			if(check)
			{
				UBYTE nameBuffer[MAX_FILENAME_LEN];
				ULONG segment;
				ULONG offset;
				int j;

				for(j = i - 7 ; j <= i ; j++)
				{
					if(FindAddress(range[j],sizeof(nameBuffer),nameBuffer,&segment,&offset))
					{
						DPrintf("----> %08lx - \"%s\" Hunk %04lx Offset %08lx\n",
							range[j],nameBuffer,segment,offset);
					}
				}
			}
		}
	}
}

/******************************************************************************/

VOID
VoiceComplaint(
	UBYTE					trap,
	UWORD					sr,
	ULONG					pc,
	ULONG *					stackFrame,
	const STRPTR			format,
							...)
{
	/* show the hit header, if there is one */
	if(format != NULL)
	{
		UBYTE dateTimeBuffer[2*LEN_DATSTRING];
		va_list varArgs;
		struct timeval tv;

		GetSysTime(&tv);
		ConvertTimeAndDate(&tv,dateTimeBuffer);
		DPrintf("\n\aTASK TRAPPED\n%s\n",dateTimeBuffer);

		/* print the message to follow it */
		va_start(varArgs,format);
		DVPrintf(format,varArgs);
		va_end(varArgs);
	}

	/* show the stack frame, if there is one; this also includes
	 * a register dump.
	 */
	if(stackFrame != NULL)
	{
		UBYTE nameBuffer[MAX_FILENAME_LEN];
		struct Process * thisProcess;
		ULONG segment;
		ULONG offset;

		DPrintf("TRAP=0x%02lx  SR=0x%04lx  PC=0x%08lx  TCB=0x%08lx\n",trap,sr,pc,FindTask(NULL));
		DumpRange("  PC",((ULONG *)pc) - 8,16,FALSE);
		DumpRange("Data",stackFrame,8,DRegCheck);
		DumpRange("Addr",&stackFrame[8],8,ARegCheck);
		DumpRange("Stck",&stackFrame[16],8 * StackLines,StackCheck);

		/* show the name of the currently active process/task/whatever. */
		thisProcess = (struct Process *)FindTask(NULL);
		DPrintf("Name: \"%s\"",thisProcess->pr_Task.tc_Node.ln_Name);
	
		if(thisProcess->pr_Task.tc_Node.ln_Type == NT_PROCESS)
		{
			struct CommandLineInterface * cli;
	
			cli = BADDR(thisProcess->pr_CLI);
			if(cli != NULL)
			{
				if(cli->cli_CommandName != NULL)
					DPrintf("  CLI: \"%b\"",cli->cli_CommandName);
			}
		}

		if(FindAddress(pc,sizeof(nameBuffer),nameBuffer,&segment,&offset))
		{
			DPrintf("  \"%s\" Hunk %04lx Offset %08lx",nameBuffer,segment,offset);
		}

		DPrintf("\n");
	}
}
