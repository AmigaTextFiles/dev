/*
 * $Id: dump.c 1.15 1998/05/31 10:05:23 olsen Exp olsen $
 *
 * :ts=4
 *
 * Wipeout -- Traces and munges memory and detects memory trashing
 *
 * Written by Olaf `Olsen' Barthel <olsen@sourcery.han.de>
 * Public Domain
 */

#ifndef _GLOBAL_H
#include "global.h"
#endif	/* _GLOBAL_H */

/******************************************************************************/

STATIC const STRPTR Separator = "---------------------------------------"
                                "---------------------------------------";

/******************************************************************************/

STATIC UBYTE
GetHexChar(int v)
{
	UBYTE result;

	ASSERT(0 <= v && v <= 15);

	/* determine the ASCII character that belongs to a
	 * number (or nybble) in hexadecimal notation
	 */

	if(v <= 9)
		result = '0' + v;
	else
		result = 'A' + (v - 10);

	return(result);
}

/******************************************************************************/

VOID
DumpWall(
	const UBYTE *	wall,
	int				wallSize,
	UBYTE			fillChar)
{
	UBYTE line[80];
	int i,j,k;

	/* dump the contents of a memory wall; we explicitely
	 * filter out those bytes that match the fill char.
	 */

	for(i = 0 ; i <= (wallSize / 20) ; i++)
	{
		memset(line,' ',sizeof(line)-1);
		line[sizeof(line)-1] = '\0';

		for(j = 0 ; j < 20 ; j++)
		{
			k = i * 20 + j;

			if(k < wallSize)
			{
				UBYTE c = wall[k];

				/* don't show the fill character */
				if(c == fillChar)
				{
					line[j * 2]    = '.';
					line[j * 2 +1] = '.';

					line[41 + j] = '.';
				}
				else
				{
					/* fill in the trash character and
					 * also put in an ASCII representation
					 * of its code.
					 */
					line[j * 2]    = GetHexChar(c >> 4);
					line[j * 2 +1] = GetHexChar(c & 15);

					if(c <= ' ' || (c >= 127 && c <= 160))
						c = '.';

					line[41 + j] = c;
				}
			}
			else
			{
				/* fill the remainder of the line */
				while(j < 20)
				{
					line[j * 2]    = '.';
					line[j * 2 +1] = '.';

					line[41 + j] = '.';

					j++;
				}

				break;
			}
		}

		DPrintf("%08lx: %s\n",&wall[i * 20],line);
	}
}

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
				ULONG segment;
				ULONG offset;
				int j;

				for(j = i - 7 ; j <= i ; j++)
				{
					if(FindAddress(range[j],sizeof(GlobalNameBuffer),GlobalNameBuffer,&segment,&offset))
					{
						DPrintf("----> %08lx - \"%s\" Hunk %04lx Offset %08lx\n",
							range[j],GlobalNameBuffer,segment,offset);
					}
				}
			}
		}
	}
}

/******************************************************************************/

VOID
VoiceComplaint(
	ULONG *					stackFrame,
	struct TrackHeader *	th,
	const STRPTR			format,
							...)
{
	ULONG segment;
	ULONG offset;

	/* show the hit header, if there is one */
	if(format != NULL)
	{
		va_list varArgs;
		struct timeval tv;

		GetSysTime(&tv);
		ConvertTimeAndDate(&tv,GlobalDateTimeBuffer);
		DPrintf("\n\aWIPEOUT HIT\n%s\n",GlobalDateTimeBuffer);

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
		struct Process * thisProcess;

		DumpRange("Data",stackFrame,8,DRegCheck);
		DumpRange("Addr",&stackFrame[8],8,ARegCheck);
		DumpRange("Stck",&stackFrame[17],8 * StackLines,StackCheck);

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

		/* if possible, show the hunk offset of the caller return
		 * address; for FreeMem() this would be the next instruction
		 * after the FreeMem() call.
		 */
		if(FindAddress(stackFrame[16],sizeof(GlobalNameBuffer),GlobalNameBuffer,&segment,&offset))
		{
			DPrintf("  \"%s\" Hunk %04lx Offset %08lx",GlobalNameBuffer,segment,offset);
		}

		DPrintf("\n");
	}

	/* show the data associated with the memory tracking
	 * header, if there is one.
	 */
	if(th != NULL)
	{
		BOOL showCreator;
		UBYTE * mem;
		STRPTR type;

		if(format != NULL || stackFrame != NULL)
		{
			DPrintf("%s\n",Separator);
		}

		switch(th->th_Type)
		{
			case ALLOCATIONTYPE_AllocMem:

				type = "AllocMem(%ld,...)";
				break;

			case ALLOCATIONTYPE_AllocVec:

				type = "AllocVec(%ld,...)";
				break;

			case ALLOCATIONTYPE_AllocPooled:

				type = "AllocPooled(...,%ld)";
				break;

			default:

				type = "";
				break;
		}

		ConvertTimeAndDate(&th->th_Time,GlobalDateTimeBuffer);

		mem = (UBYTE *)(th + 1);
		mem += PreWallSize;

		/* show type, size and place of the allocation; AllocVec()
		 * allocations are special in that the memory body is actually
		 * following a size long word.
		 */
		if(th->th_Type == ALLOCATIONTYPE_AllocVec)
		{
			DPrintf("0x%08lx = ",mem + sizeof(ULONG));
			DPrintf(type,th->th_Size - sizeof(ULONG));
		}
		else
		{
			DPrintf("0x%08lx = ",mem);
			DPrintf(type,th->th_Size);
		}

		DPrintf("\n");

		/* show information on the time and the task/process/whatever
		 * that created the allocation.
		 */
		DPrintf("Created on %s\n",GlobalDateTimeBuffer);

		DPrintf("        by task 0x%08lx",th->th_Owner);

		showCreator = TRUE;

		if(th->th_NameTagLen > 0)
		{
			STRPTR taskNameBuffer;
			STRPTR programNameBuffer;

			if(GetNameTagData(th,th->th_NameTagLen,&programNameBuffer,&segment,&offset,&taskNameBuffer))
			{
				DPrintf(", %s \"%s\"\n",GetTaskTypeName(th->th_OwnerType),taskNameBuffer);

				DPrintf("        at \"%s\" Hunk %04lx Offset %08lx",programNameBuffer,segment,offset);

				showCreator = FALSE;
			}
		}

		DPrintf("\n");

		if(showCreator || th->th_ShowPC)
		{
			if(FindAddress(th->th_PC,sizeof(GlobalNameBuffer),GlobalNameBuffer,&segment,&offset))
				DPrintf("        at \"%s\" Hunk %04lx Offset %08lx\n",GlobalNameBuffer,segment,offset);
		}

		DPrintf("%s\n",Separator);
	}
}

/******************************************************************************/

VOID
DumpPoolOwner(const struct PoolHeader * ph)
{
	BOOL showCreator;
	ULONG segment;
	ULONG offset;

	/* show information on the creator of a memory pool. */
	ConvertTimeAndDate(&ph->ph_Time,GlobalDateTimeBuffer);

	DPrintf("%s\n",Separator);

	DPrintf("0x%08lx = CreatePool(...)\n",ph->ph_PoolHeader);
	DPrintf("Created on %s\n",GlobalDateTimeBuffer);

	DPrintf("        by task 0x%08lx",ph->ph_Owner);

	showCreator = TRUE;

	if(ph->ph_NameTagLen > 0)
	{
		STRPTR taskNameBuffer;
		STRPTR programNameBuffer;

		if(GetNameTagData((APTR)ph,ph->ph_NameTagLen,&programNameBuffer,&segment,&offset,&taskNameBuffer))
		{
			DPrintf(", %s \"%s\"\n",GetTaskTypeName(ph->ph_OwnerType),taskNameBuffer);

			DPrintf("        at \"%s\" Hunk %04lx Offset %08lx",programNameBuffer,segment,offset);

			showCreator = FALSE;
		}
	}

	DPrintf("\n");

	if(showCreator)
	{
		if(FindAddress(ph->ph_PC,sizeof(GlobalNameBuffer),GlobalNameBuffer,&segment,&offset))
		{
			DPrintf("        at \"%s\" Hunk %04lx Offset %08lx\n",GlobalNameBuffer,segment,offset);
		}
	}

	DPrintf("%s\n",Separator);
}
