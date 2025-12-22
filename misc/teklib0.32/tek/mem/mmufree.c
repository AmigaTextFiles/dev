
#include "tek/mem.h"
#include "tek/kn/exec.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TVOID TMMUFree(TAPTR mmu, TAPTR mem)
**
**	free memory allocated from a MMU.
**
*/

TVOID TMMUFree(TAPTR mmu, TAPTR mem)
{
	if (mem)
	{
		if (mmu)
		{
			(*((TMMU *) mmu)->freefunc)(((TMMU *) mmu)->allocator, mem);
		}
		else
		{
			kn_free(mem);
		}
	}
}
