/*
 * $Id: privateallocvec.c,v 1.1 2005/12/21 19:48:23 itix Exp $
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

APTR
PrivateAllocVec(ULONG byteSize,ULONG attributes)
{
	APTR result;

	/* allocate memory through AllocMem(); but if AllocMem()
	 * has been redirected to our code, we still want to use
	 * the original ROM routine
	 */

#if 0
	if(OldAllocMem != NULL)
	{
		result	= OldAllocMemAligned(SysBase, sizeof(ULONG) + byteSize, attributes, 0, 0);
	}
	else
#endif
	{
		result = AllocMem(sizeof(ULONG) + byteSize,attributes);
	}

	/* store the size information in front of the allocation */
	if(result != NULL)
	{
		ULONG * size = result;

		(*size) = sizeof(ULONG) + byteSize;

		result = (APTR)(size + 1);
	}

	return(result);
}

VOID
PrivateFreeVec(APTR memoryBlock)
{
	/* free memory allocated by AllocMem(); but if FreeMem()
	 * has been redirected to our code, we still want to use
	 * the original ROM routine
	 */

	if(memoryBlock != NULL)
	{
		ULONG * mem;
		ULONG size;

		/* get the allocation size */
		mem = (ULONG *)(((ULONG)memoryBlock) - sizeof(ULONG));
		size = (*mem);

		/* munge the allocation */
		MungMem(mem,size,DEADBEEF);

		/* and finally free it */
#if 0
		if(OldFreeMem != NULL)
		{
			REG_A1	= (ULONG)mem;
			REG_D0	= size;
			REG_A6	= (ULONG)SysBase;
			MyEmulHandle->EmulCallDirect68k(OldFreeMem);
		}
		else
#endif
		{
			FreeMem(mem,size);
		}
	}
}
