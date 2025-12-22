
#include "tek/mem.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TAPTR TMMUAllocHandle0(TAPTR mmu, TDESTROYFUNC destroyfunc, TUINT size)
**
**	allocate a generic handle with destructor,
**	and zero out the entire allocation
**
*/

TAPTR TMMUAllocHandle0(TAPTR mmu, TDESTROYFUNC destroyfunc, TUINT size)
{
	if (size)
	{
		THNDL *handle = TMMUAlloc0(mmu, size);
		if (handle)
		{
			handle->destroyfunc = destroyfunc;
			handle->mmu = mmu;
			return (TAPTR) handle;
		}
	}
	return TNULL;
}
