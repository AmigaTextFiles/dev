/*
 * $Id: segtracker.c 1.2 1998/04/18 15:45:19 olsen Exp olsen $
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

typedef char (* ASM SegTrack(REG(a0) ULONG		Address,
                             REG(a1) ULONG *	SegNum,
                             REG(a2) ULONG *	Offset));

struct SegSem
{
	struct SignalSemaphore	seg_Semaphore;
	SegTrack *				seg_Find;
};

/******************************************************************************/

BOOL
FindAddress(
	ULONG	address,
	LONG	nameLen,
	STRPTR	nameBuffer,
	ULONG *	segmentPtr,
	ULONG *	offsetPtr)
{
	struct SegSem * SegTracker;
	BOOL found = FALSE;

	Forbid();

	/* check whether SegTracker was loaded */
	SegTracker = (struct SegSem *)FindSemaphore("SegTracker");
	if(SegTracker != NULL)
	{
		STRPTR name;

		/* map the address to a name and a hunk/offset index */
		name = (*SegTracker->seg_Find)(address,segmentPtr,offsetPtr);
		if(name != NULL)
		{
			strncpy(nameBuffer,name,nameLen-1);
			nameBuffer[nameLen-1] = '\0';

			found = TRUE;
		}
	}

	Permit();

	return(found);
}
