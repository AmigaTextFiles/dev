
#include "tek/mem.h"
#include "tek/kn/exec.h"
#include "tek/debug.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TAPTR TMMUAlloc0(TAPTR mmu, TUINT size)
**
**	alloc blank memory from a MMU.
**
*/

TAPTR TMMUAlloc0(TAPTR mmu, TUINT size)
{
	if (!size)
	{
		tdbprintf(10, "TMMUAlloc: allocating size = 0\n");
	}

	/*if (size)*/
	{
		if (mmu)
		{
			TAPTR mem = (*((TMMU *) mmu)->allocfunc)(((TMMU *) mmu)->allocator, size);
			if (mem)
			{
				TMemFill32(mem, size, 0);
				return mem;
			}
		}
		else
		{
			return kn_alloc0(size);
		}
	}
	return TNULL;
}
