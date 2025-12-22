/*
 * $Id: dump.c,v 1.10 2009/06/14 22:03:58 itix Exp $
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

STATIC CONST TEXT Separator[] = "---------------------------------------"
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
#define	LINEELEMENTS	16

VOID
DumpWall(
	const UBYTE *	wall,
	int				wallSize,
	UBYTE			fillChar)
{
	UBYTE line[41 + LINEELEMENTS + 1];
	int i,j,k;

	/* dump the contents of a memory wall; we explicitely
	 * filter out those bytes that match the fill char.
	 */

	for(i = 0 ; i <= (wallSize / LINEELEMENTS) ; i++)
	{
		memset(line,' ',sizeof(line)-1);
		line[sizeof(line)-1] = '\0';

		for(j = 0 ; j < LINEELEMENTS ; j++)
		{
			k = i * LINEELEMENTS + j;

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
				while(j < LINEELEMENTS)
				{
					line[j * 2]    = '.';
					line[j * 2 +1] = '.';

					line[41 + j] = '.';

					j++;
				}

				break;
			}
		}

		DPrintf("%08lx: %s\n",&wall[i * LINEELEMENTS],line);
	}
}

/******************************************************************************/

VOID
DumpArea(
	const UBYTE *	wall,
	int				wallSize)
{
	UBYTE line[41 + LINEELEMENTS + 1];
	int i,j,k;

	/* dump the contents of a memory wall; we explicitely
	 * filter out those bytes that match the fill char.
	 */

	if (wallSize > 0x1000)
	{
		DPrintf("WallSize %08lx too big, limit it\n",wallSize);
		wallSize = 0x1000;
	}
	for(i = 0 ; i <= (wallSize / LINEELEMENTS) ; i++)
	{
		memset(line,' ',sizeof(line)-1);
		line[sizeof(line)-1] = '\0';

		for(j = 0 ; j < LINEELEMENTS ; j++)
		{
			k = i * LINEELEMENTS + j;

			if(k < wallSize)
			{
				UBYTE c = wall[k];

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
				break;
			}
		}
		if (j > 0)
		{
			DPrintf("%08lx: %s\n",&wall[i * LINEELEMENTS],line);
		}
	}
}

/******************************************************************************/

VOID
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
	ULONG					*stackFrame,
    ULONG 					pc[TRACKEDCALLERSTACKSIZE],
	struct TrackHeader		*th,
	CONST_STRPTR			format,
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
		#if 0
		DumpRange("Data",stackFrame,8,DRegCheck);
		DumpRange("Addr",&stackFrame[8],8,ARegCheck);
		DumpRange("Stck",&stackFrame[17],8 * StackLines,StackCheck);
		#endif

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

		#if 1
		if (pc)
		{
			int i;
			for (i=0;i<TRACKEDCALLERSTACKSIZE;i++)
			{
				if(FindAddress(pc[i],sizeof(GlobalNameBuffer),GlobalNameBuffer,&segment,&offset))
				{
					DPrintf("CallerStack[%ld] 0x%lx at %s Hunk %lx Offset 0x%08lx\n",i,pc[i],GlobalNameBuffer,segment,offset);
					break;
				}
				else
				{
					//DPrintf("CallerStack[%ld] 0x%lx\n",i,pc[i]);
				}
			}
		}
		#endif
	}

	/* show the data associated with the memory tracking
	 * header, if there is one.
	 */
	if(th != NULL)
	{
		if (TypeOfMem(th))
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

			if (TypeOfMem(mem))
			{
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
			}
			else
			{
				DPrintf("TrackHeader's mem ptr 0x%lx is bogus\n",mem);
			}
			/* show information on the time and the task/process/whatever
			 * that created the allocation.
			 */
			DPrintf("Created on %s\n",GlobalDateTimeBuffer);

			DPrintf("        by task 0x%08lx",th->th_Owner);

			showCreator = TRUE;

			if (TypeOfMem(th->th_Owner))
			{
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
			}
			else
			{
				DPrintf("\nTrackHeader's OwnerTask 0x%lx is bogus\n",th->th_Owner);
			}

			if(showCreator || th->th_ShowPC)
			{
				int i;
				for (i=0;i<TRACKEDCALLERSTACKSIZE;i++)
				{
					if(FindAddress(th->th_PC[i],sizeof(GlobalNameBuffer),GlobalNameBuffer,&segment,&offset))
					{
						DPrintf("CallerStack[%ld] 0x%lx at %s Hunk %lx Offset 0x%08lx\n",i,th->th_PC[i],GlobalNameBuffer,segment,offset);
					}
					else
					{
						//DPrintf("CallerStack[%ld] 0x%lx\n",i,th->th_PC[i]);
					}
				}
			}
		}
		else
		{
			DPrintf("TrackHeader 0x%lx is bogus\n",th);
		}
		DPrintf("%s\n",Separator);
	}
	#if 0
	else
	if (pc)
	{
		//if(showCreator)
		{
			int i;
			for (i=0;i<TRACKEDCALLERSTACKSIZE;i++)
			{
				if(FindAddress(pc[i],sizeof(GlobalNameBuffer),GlobalNameBuffer,&segment,&offset))
				{
					DPrintf("CallerStack[%ld] 0x%lx at %s Hunk %lx Offset 0x%08lx\n",i,pc[i],GlobalNameBuffer,segment,offset);
				}
				else
				{
					//DPrintf("CallerStack[%ld] 0x%lx\n",i,pc[i]);
				}
			}
		}
	}
	#endif
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

	DPrintf("0x%08lx = CreatePool(0x%lx,0x%lx,0x%lx)\n",ph->ph_PoolHeader,ph->ph_PuddleSize,ph->ph_ThreshSize,ph->ph_Attributes);

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
		int i;
		for (i=0;i<TRACKEDCALLERSTACKSIZE;i++)
		{
			if(FindAddress(ph->ph_PC[i],sizeof(GlobalNameBuffer),GlobalNameBuffer,&segment,&offset))
			{
				DPrintf("CallerStack[%ld] 0x%lx at %s Hunk %lx Offset 0x%08lx\n",i,ph->ph_PC[i],GlobalNameBuffer,segment,offset);
			}
			else
			{
				//DPrintf("CallerStack[%ld] 0x%lx\n",i,ph->ph_PC[i]);
			}
		}
	}

	DPrintf("%s\n",Separator);
}
