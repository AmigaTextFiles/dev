/*
 * $Id: addresstest.c 1.6 1998/04/13 09:39:45 olsen Exp olsen $
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
		extern LONG FAR romend;

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

BOOL
IsAllocatedMemory(ULONG address,ULONG size)
{
	struct MemHeader * mh;
	struct MemChunk * mc;
	ULONG memStart;
	ULONG memStop;
	ULONG chunkStart;
	ULONG chunkStop;
	BOOL isAllocated = TRUE;

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
			else if (  memStart <= chunkStart && chunkStop <= memStop ||
			         chunkStart <= memStart   &&   memStop <= chunkStop)
			{
				isAllocated = FALSE;
				break;
			}
		}
	}

	Permit();

	return(isAllocated);
}
