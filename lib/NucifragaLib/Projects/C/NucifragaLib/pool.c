/*
 * Revision control info:
 *
 */

static const char rcsid[] =
	"$Id: pool.c 1.2 1995/10/23 21:54:32 JöG Exp JöG $";

/*
 *
 * Easy access to (hopefully) pooled memory
 * allocations under V33 - V40 Kickstarts.
 *
 * 1994-12-22
 *
 * Jörgen Grahn
 * Wetterlinsgatan 13E
 * S-521 34 Falköping
 * Sverige
 *
 */

/*
 * $Log: pool.c $
 * Revision 1.2  1995/10/23  21:54:32  JöG
 * made the RCS id a string
 *
 * Revision 1.1  1995/10/18  14:43:02  JöG
 * Initial revision
 *
 * Revision 1.1  1995/04/24  16:30:42  JöG
 * Initial revision
 *
 *
 */

/*
 * Nofrag.library is a shared library
 * by Jan van den Baard. Comes with
 * GadToolsBox and separately on some
 * Fish disk.
 *
 */

#include <exec/types.h>
#include <exec/memory.h>
#include <exec/execbase.h>

#include <proto/exec.h>

#include "pool.h"

APTR GetMemoryChain(ULONG);
void FreeMemoryChain(APTR, ULONG);
APTR AllocItem(APTR, ULONG, ULONG);
void FreeItem(APTR, APTR, ULONG);

#pragma libcall NoFragBase GetMemoryChain 1e 1
#pragma libcall NoFragBase FreeMemoryChain 30 802
#pragma libcall NoFragBase AllocItem 24 10803
#pragma libcall NoFragBase FreeItem 2a 9803


/*
 * Create a Pool object for use.
 * Returns TRUE on success.
 * Will always fail if neither exec V39
 * nor nofrag.library is available.
 *
 * Allocations larger than maxsize aren't
 * guaranteed to work.
 *
 * All allocations will have the same
 * requirements.
 *
 * You can mix memory allocated with poolalloc()
 * and poolallocvec() in this pool.
 *
 */
BOOL poolcreate(Pool * pool, ULONG maxsize, ULONG memflags)
{
	struct Library * NoFragBase;
	extern struct ExecBase * SysBase;


	pool->v39 = (SysBase->LibNode.lib_Version >= 39);

	if(pool->v39)
	{	pool->handle = CreatePool(memflags, maxsize, maxsize);
		return(BOOL)(pool->handle != NULL);
	}

	pool->nofrag = OpenLibrary("nofrag.library", 1);

	if(pool->nofrag)
	{	NoFragBase = pool->nofrag;
		pool->handle = GetMemoryChain(maxsize);
		if(pool->handle)
		{	return(TRUE);
		}
		else
		{	CloseLibrary(pool->nofrag);
			return(FALSE);
		}
	}

	return(FALSE);
}


/*
 * Destroy a Pool object.
 * All memory is deallocated and all
 * other resources deallocated.
 *
 * This works on any created Pool,
 * even if creation failed.
 *
 */
void pooldestroy(Pool * pool)
{
	struct Library * NoFragBase;


	if(pool->v39)
	{	if(pool->handle)
		{	DeletePool(pool->handle);
		}
		return;
	}

	if(pool->nofrag)
	{	if(pool->handle)
		{	NoFragBase = pool->nofrag;
			FreeMemoryChain(pool->handle, TRUE);
		}
	}
}


/*
 * Allocate a piece of memory from a private Pool.
 *
 * It will be longword aligned, allocated with
 * the flags given to poolcreate().
 * Allocations larger that the maximum size given
 * may fail (e.g. _will_ fail if nofrag.library is used).
 * 
 * Allocations will (probably) take place in larger
 * memory pools, so that other applications won't suffer
 * from memory fragmentation.
 *
 * Zero size is allowed; in that case, NULL is returned.
 *
 */
APTR poolalloc(Pool * pool, ULONG size)
{
	struct Library	* NoFragBase;


	if(size==0)
	{	return(NULL);
	}

	if(pool->v39)
	{	return(AllocPooled(pool->handle, size));
	}
	else if(pool->nofrag)
	{	NoFragBase = pool->nofrag;
		return(AllocItem(pool->handle, size, pool->memflags));
	}
	else
	{	return(NULL);
	}
}


/*
 * Free a piece of memory.
 * The deallocation must match an
 * allocation of the proper length in
 * this pool.
 *
 * Freeing NULL is allowed.
 *
 */
void poolfree(Pool * pool, APTR allocation, ULONG size)
{
	struct Library	* NoFragBase;

	if(!allocation)
	{	return;
	}

	if(pool->v39)
	{	FreePooled(pool->handle, allocation, size);
	}
	else if(pool->nofrag)
	{	NoFragBase = pool->nofrag;
		FreeItem(pool->handle, allocation, size);
	}
}


/*
 * As poolalloc(), but must be freed with
 * poolfreevec. Wastes 4 bytes more than
 * poolalloc().
 *
 * Zero size is allowed; in that case, NULL is returned.
 *
 */
APTR poolallocvec(Pool * pool, ULONG size)
{
	ULONG	* addr;


	if(size==0)
	{	return(NULL);
	}

	addr = poolalloc(pool, size + sizeof(LONG));

	if(!addr)
	{	return(NULL);
	}

	addr[0] = size;

	return(&addr[1]);
}


/*
 * As poolfree(), but doesn't need
 * the size of the allocation.
 *
 * Freeing NULL is allowed.
 *
 */
void poolfreevec(Pool * pool, APTR allocation)
{
	ULONG	* addr;


	if(!allocation)
	{	return;
	}

	addr = (ULONG *)((ULONG)allocation - 4);

	poolfree(pool, addr, addr[0]);
}


#if 0
void pooladdhandler(struct Hook *, BYTE);
void poolremhandler(struct Hook *);
#endif
