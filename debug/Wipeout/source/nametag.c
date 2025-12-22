/*
 * $Id: nametag.c 1.2 2000/12/18 16:23:05 olsen Exp olsen $
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

struct NameTag
{
	ULONG	nt_Checksum;		/* checksum for entire data structure */
	ULONG	nt_Size;			/* size of entire data structure */
	ULONG	nt_Segment;			/* hunk number allocation came from */
	ULONG	nt_Offset;			/* hunk offset allocation came from */
	LONG	nt_ProgramNameLen;	/* name of program making the call */
	LONG	nt_TaskNameLen;		/* name of task/process making the call */
	UBYTE	nt_Names[2];		/* both program and task name */
};

/******************************************************************************/

STATIC ULONG LocalSegment;
STATIC ULONG LocalOffset;
STATIC UBYTE LocalProgramNameBuffer[MAX_FILENAME_LEN];
STATIC UBYTE LocalTaskNameBuffer[MAX_FILENAME_LEN];

/******************************************************************************/

LONG
GetNameTagLen(ULONG pc)
{
	LONG bytes = 0;

	/* determine the name and the origin of the caller */
	if(GetTaskName(NULL,LocalTaskNameBuffer,sizeof(LocalTaskNameBuffer)))
	{
		if(FindAddress(pc,sizeof(LocalProgramNameBuffer),LocalProgramNameBuffer,&LocalSegment,&LocalOffset))
		{
			/* calculate the size of the data structure to allocate later */
			bytes = ((sizeof(struct NameTag) + strlen(LocalTaskNameBuffer) + strlen(LocalProgramNameBuffer)) + MEM_BLOCKMASK) & ~MEM_BLOCKMASK;
		}
	}

	return(bytes);
}

/******************************************************************************/

STATIC struct NameTag *
GetNameTag(const APTR mem,LONG size)
{
	struct NameTag * nt = NULL;

	ASSERT(th != NULL);

	/* return the nametag corresponding to the given memory area */
	if(size > 0)
		nt = (struct NameTag *)(((ULONG)mem) - size);

	return(nt);
}

/******************************************************************************/

VOID
FillNameTag(APTR mem,LONG size)
{
	struct NameTag * nt;
	STRPTR name;

	ASSERT(mem != NULL && size > 0);

	nt = (struct NameTag *)mem;

	/* fill in the name tag header with data */
	nt->nt_Size				= size;
	nt->nt_Segment			= LocalSegment;
	nt->nt_Offset			= LocalOffset;
	nt->nt_ProgramNameLen	= strlen(LocalProgramNameBuffer)+1;
	nt->nt_TaskNameLen		= strlen(LocalTaskNameBuffer)+1;

	/* fill in the names */	
	name = nt->nt_Names;
	strcpy(name,LocalProgramNameBuffer);
	
	name += strlen(LocalProgramNameBuffer)+1;
	strcpy(name,LocalTaskNameBuffer);

	/* fix the checksum */
	nt->nt_Checksum	= 0;
	nt->nt_Checksum = ~CalculateChecksum((ULONG *)nt,nt->nt_Size);
}

/******************************************************************************/

BOOL
GetNameTagData(
	const APTR	mem,
	LONG		size,
	STRPTR *	programNamePtr,
	ULONG *		segmentPtr,
	ULONG *		offsetPtr,
	STRPTR *	taskNamePtr)
{
	struct NameTag * nt;
	BOOL found = FALSE;

	ASSERT(th != NULL);

	/* if a name tag header corresponds to the memory
	 * chunk, extract its data
	 */
	nt = GetNameTag(mem,size);
	if(nt != NULL)
	{
		/* is the data still intact? */
		if(CalculateChecksum((ULONG *)nt,nt->nt_Size) == (ULONG)-1)
		{
			STRPTR name;

			/* fill in the data */

			name = nt->nt_Names;

			if(programNamePtr != NULL)
				(*programNamePtr) = name;

			if(segmentPtr != NULL)
				(*segmentPtr) = nt->nt_Segment;

			if(offsetPtr != NULL)
				(*offsetPtr) = nt->nt_Offset;

			if(taskNamePtr != NULL)
			{
				name += nt->nt_ProgramNameLen;
				(*taskNamePtr) = name;
			}

			found = TRUE;
		}
	}

	return(found);
}
