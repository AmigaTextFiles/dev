
#include "tek/mem.h"
#include "tek/kn/exec.h"
#include "tek/debug.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TAPTR TMMUAlloc(TAPTR mmu, TUINT size)
**
**	alloc from MMU.
**
*/

TAPTR TMMUAlloc(TAPTR mmu, TUINT size)
{
	if (!size)
	{
		tdbprintf(10, "TMMUAlloc: allocating size = 0\n");
	}

	/*if (size)*/
	{
		if (mmu)
		{
			return (*((TMMU *) mmu)->allocfunc)(((TMMU *) mmu)->allocator, size);
		}
		else
		{
			return kn_alloc(size);
		}
	}
	return TNULL;
}
