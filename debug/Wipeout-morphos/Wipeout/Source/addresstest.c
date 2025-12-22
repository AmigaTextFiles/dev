/*
 * $Id: addresstest.c,v 1.2 2009/02/22 20:58:54 piru Exp $
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

#include <exec/system.h>

/******************************************************************************/

#define NOT_IN_RAM (0)

/******************************************************************************/

#define ROM_SIZE_OFFSET 0x13

/******************************************************************************/

BOOL
IsValidAddress(ULONG address)
{
	BOOL isValid = FALSE;

	/* Is this a valid RAM address? */
	if(TypeOfMem((APTR)address) == NOT_IN_RAM)
	{
		extern LONG romend;

		#warning fixme
		const ULONG romEnd		= (ULONG)&romend;
		const ULONG romStart	= romEnd - (*(ULONG *)(romEnd - ROM_SIZE_OFFSET));

		/* Check if the address resides in ROM space. */
		if(romStart <= address && address <= romEnd)
			isValid = TRUE;
	}
	else
	{
		isValid = TRUE;
	}

	/* In this context "valid" means that the data stored
	 * at the given address is safe to read.
	 */
	return(isValid);
}

/******************************************************************************/

BOOL
IsInvalidAddress(ULONG address)
{
	BOOL isInvalid;

	isInvalid = (BOOL)(TypeOfMem((APTR)address) == NOT_IN_RAM);

	/* In this context "invalid" means that the data stored
	 * at the given address is not located in RAM, but
	 * somewhere else.
	 */
	return(isInvalid);
}

BOOL
IsOddAddress(ULONG address)
{
	BOOL isOdd;

	isOdd = (BOOL)((address & 3) != 0);

	return(isOdd);
}

/******************************************************************************/


struct hookdata
{
	ULONG memStart;
	ULONG memStop;
	BOOL  isAllocated;
};

/*
** The hook is called within Forbid. It must not perform any action that might
** break forbid or allocate memory. Keep it simple.
*/
static LONG hookfunc(void)
{
	struct Hook      *hook      = (APTR) REG_A0;
	struct MemEntry  *mementry  = (APTR) REG_A1; /* message */
	/*struct MemHeader *memheader = (APTR) REG_A2;*/ /* object */
	struct hookdata *hookdata = hook->h_Data;
	const ULONG memStart = hookdata->memStart;
	const ULONG memStop  = hookdata->memStop;
	const ULONG chunkStart = (ULONG) mementry->me_Addr;
	const ULONG chunkStop  = chunkStart + mementry->me_Length - 1;

	/* four cases are possible:
	 * 1) the chunk and the allocated memory do not overlap
	 * 2) the chunk and the allocated memory overlap at the beginning
	 * 3) the chunk and the allocated memory overlap at the end
	 * 4) the chunk and the allocated memory overlap completely
	 */

	if(memStop < chunkStart || memStart > chunkStop)
	{
		/* harmless */
	}
	else if (memStart <= chunkStart && memStop <= chunkStop)
	{
		hookdata->isAllocated = FALSE;
		return FALSE;
	}
	else if (chunkStart <= memStart && chunkStop <= memStop)
	{
		hookdata->isAllocated = FALSE;
		return FALSE;
	}
	else if ((  memStart <= chunkStart && chunkStop <= memStop) ||
	         (chunkStart <= memStart   &&   memStop <= chunkStop))
	{
		hookdata->isAllocated = FALSE;
		return FALSE;
	}

	/* Continue */
	return TRUE;
}

static const struct EmulLibEntry hookfuncgate =
{
	TRAP_LIB,
	0,
	(void (*)(void)) hookfunc
};

BOOL
IsAllocatedMemory(ULONG address,ULONG size)
{
	BOOL isAllocated = TRUE;

	if (LIB_MINVER(&SysBase->LibNode, 51, 32))
	{
		struct hookdata hookdata =
		{
			address,
			address + size - 1,
			TRUE
		};
		struct Hook hook =
		{
			{NULL, NULL},
			(HOOKFUNC) &hookfuncgate,
			NULL,
			&hookdata
		};
		ULONG dummy;

		NewGetSystemAttrs(&dummy, sizeof(dummy), SYSTEMINFOTYPE_FREEBLOCKS,
		                  SYSTEMINFOTAG_HOOK, (ULONG) &hook,
		                  TAG_END);

		isAllocated = hookdata.isAllocated;
	}
	else
	{
		struct MemHeader * mh;
		struct MemChunk * mc;
		ULONG memStart;
		ULONG memStop;
		ULONG chunkStart;
		ULONG chunkStop;

		/* check whether the allocated memory overlaps with free
		 * memory or whether freeing it would result in part of
		 * an already free area to be freed
		 */

		memStart	= address;
		memStop		= address + size-1;

		Forbid();

		for(mh = (struct MemHeader *)SysBase->MemList.lh_Head ;
		    mh->mh_Node.ln_Succ != NULL ;
		    mh = (struct MemHeader *)mh->mh_Node.ln_Succ)
		{
			for(mc = mh->mh_First ;
			    mc != NULL ;
			    mc = mc->mc_Next)
			{
				chunkStart	= (ULONG)mc;
				chunkStop	= chunkStart + mc->mc_Bytes-1;

				/* four cases are possible:
				 * 1) the chunk and the allocated memory do not overlap
				 * 2) the chunk and the allocated memory overlap at the beginning
				 * 3) the chunk and the allocated memory overlap at the end
				 * 4) the chunk and the allocated memory overlap completely
				 */

				if(memStop < chunkStart || memStart > chunkStop)
				{
					/* harmless */
				}
				else if (memStart <= chunkStart && memStop <= chunkStop)
				{
					isAllocated = FALSE;
					break;
				}
				else if (chunkStart <= memStart && chunkStop <= memStop)
				{
					isAllocated = FALSE;
					break;
				}
				else if ((  memStart <= chunkStart && chunkStop <= memStop) ||
				         (chunkStart <= memStart   &&   memStop <= chunkStop))
				{
					isAllocated = FALSE;
					break;
				}
			}
		}

		Permit();
	}

	return(isAllocated);
}
