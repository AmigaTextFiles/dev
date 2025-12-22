/*
 * $Id: mungmem.c 1.6 1999/01/20 16:54:30 olsen Exp olsen $
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

VOID
MungMem(ULONG * mem,ULONG numBytes,ULONG magic)
{
	/* the memory to munge must be on a long-word address */
	ASSERT((((ULONG)mem) & 3) == 0);

	/* fill the memory with junk, but only as long as
	 * a long-word fits into the remaining space
	 */
	while(numBytes > sizeof(*mem))
	{
		(*mem++) = magic;

		numBytes -= sizeof(*mem);
	}

	/* fill in the left-over space */
	if(numBytes > 0)
	{
		memcpy(mem,&magic,numBytes);
	}
}

/******************************************************************************/

STATIC VOID
MungFreeMem(VOID)
{
	struct MemHeader *	mh;
	struct MemChunk *	mc;

	/* walk down the list of unallocated system memory
	 * and trash it
	 */

	Forbid();

	for(mh = (struct MemHeader *)SysBase->MemList.lh_Head ;
	    mh->mh_Node.ln_Succ != NULL ;
	    mh = (struct MemHeader *)mh->mh_Node.ln_Succ)
	{
		for(mc = mh->mh_First ;
		    mc != NULL ;
		    mc = mc->mc_Next)
		{
			if(mc->mc_Bytes > sizeof(*mc))
			{
				MungMem((ULONG *)(mc + 1),mc->mc_Bytes - sizeof(*mc),ABADCAFE);
			}
		}
	}

	Permit();
}

/******************************************************************************/

STATIC BOOL
EnforcerIsRunning(VOID)
{
	BOOL found = FALSE;

	/* check whether The Enforcer or a program with similar
	 * functionality (such as CyberGuard) is currently
	 * running
	 */

	Forbid();

	if(FindPort("_The Enforcer_") != NULL ||
	   FindTask("« Enforcer »") != NULL ||
	   FindPort("CyberGuard") != NULL)
	{
		found = TRUE;
	}

	Permit();

	return(found);
}

/******************************************************************************/

VOID
BeginMemMung(VOID)
{
	Forbid();

	/* unless The Enforcer is running, trash address 0 */
	if(NOT EnforcerIsRunning())
	{
		(*(ULONG *)0) = CODEDBAD;
	}

	Permit();

	/* proceed to trash all unallocated system memory */
	MungFreeMem();
}
