/*
 * $Id: mungmem.c,v 1.4 2009/02/23 01:24:09 piru Exp $
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

#include "installpatches.h"

/******************************************************************************/

VOID
MungMem(ULONG * mem,ULONG numBytes,ULONG magic)
{
	/* the memory to munge must be on a long-word address */
	ASSERT((((ULONG)mem) & 3) == 0);

	/* fill the memory with junk, but only as long as
	 * a long-word fits into the remaining space
	 */
	while(numBytes >= sizeof(*mem))
	{
		(*mem++) = magic;

		numBytes -= sizeof(*mem);
	}

	/* fill in the left-over space */
	if (numBytes & 2)
	{
		(*((UWORD *) mem)++) = magic >> 16;
	}

	if (numBytes & 1)
	{
		*((UBYTE *) mem) = magic >> 24;
	}
}

/******************************************************************************/

STATIC APTR _allocany(ULONG size);
STATIC VOID _freemem(APTR ptr, ULONG size);

VOID BeginMemMung(VOID)
{
	struct MemHeader *	mh;
	struct MemChunk *	mc;
	BOOL foundmemory = FALSE;

	/* walk down the list of unallocated system memory
	 * and trash it
	 */

	Forbid();

	for(mh = (struct MemHeader *)SysBase->MemList.lh_Head ;
	    mh->mh_Node.ln_Succ != NULL ;
	    mh = (struct MemHeader *)mh->mh_Node.ln_Succ)
	{
		if (mh->mh_First)
		{
			foundmemory = TRUE;
		}
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

	if (!foundmemory)
	{
		/* Ok we didn't find any memory going thru the memory list.
		 * This means we're running with an alternate memory system
		 * (such as TLSF) and we must apply different strategy.
		 *
		 * Attempt to allocate the largest memory block until we run
		 * out of memory. Once we do, munge and free all the allocated
		 * memory areas.
		 */
		CONST ULONG largest = AvailMem(MEMF_LARGEST | MEMF_ANY);
		if (largest)
		{
			struct
			{
				ULONG size;
				APTR  ptr;
			} *array;

			array = _allocany(largest);
			if (array)
			{
				CONST LONG maxallocs = largest / sizeof(array[0]);
				LONG i;

				for (i = 0; i < maxallocs; i++)
				{
					if ((array[i].size = AvailMem(MEMF_LARGEST | MEMF_ANY)) == 0)
					{
						break;
					}
					if ((array[i].ptr = _allocany(array[i].size)) == NULL)
					{
						break;
					}
				}
				for (i--; i >= 0; i--)
				{
					MungMem(array[i].ptr, array[i].size, ABADCAFE);
					_freemem(array[i].ptr, array[i].size);
				}
				MungMem((APTR) array, largest, ABADCAFE);
				_freemem(array, largest);
			}
		}
	}

	Permit();
}

STATIC APTR _allocany(ULONG size)
{
	if (OldAllocMem)
	{
		REG_D0 = size;
		REG_D1 = MEMF_ANY;
		REG_A6 = (ULONG)SysBase;
		return (APTR)MyEmulHandle->EmulCallDirect68k(OldAllocMem);
	}
	else
	{
		return AllocMem(size, MEMF_ANY);
	}
}

STATIC VOID _freemem(APTR ptr, ULONG size)
{
	if (OldFreeMem)
	{
		REG_A1 = (ULONG) ptr;
		REG_D0 = size;
		REG_A6 = (ULONG)SysBase;
		(void)MyEmulHandle->EmulCallDirect68k(OldFreeMem);
	}
	else
	{
		FreeMem(ptr, size);
	}
}
