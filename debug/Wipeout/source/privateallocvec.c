/*
 * $Id: privateallocvec.c 1.6 1998/04/16 10:25:42 olsen Exp olsen $
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

	if(OldAllocMem != NULL)
	{
		result = (*OldAllocMem)(sizeof(ULONG) + byteSize,attributes,SysBase);
	}
	else
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
		if(OldFreeMem != NULL)
		{
			(*OldFreeMem)(mem,size,SysBase);
		}
		else
		{
			FreeMem(mem,size);
		}
	}
}
