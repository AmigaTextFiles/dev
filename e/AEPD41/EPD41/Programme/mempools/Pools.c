/**
***  Pool functions from amiga.lib
***
***  Version: $VER: Pools.c 1.0 (11.97.94) © D. Göhler
***
***  Adapted to match the definitions of LibAllocPooled() and
***  LibFreePooled() by Jochen Wiedmann.
***
***  This source was *NEVER* tested and just typed in from the
***  Amiga magazine, 10/94. Handle it with care.
***
**/

#include <exec/types.h>
#include <exec/memory.h>
#include <exec/lists.h>
#include <exec/execbase.h>
#include <proto/exec.h>
#include <clib/alib_protos.h>
#include <clib/macros.h>





/**
***  The structure used for a pool.
**/
struct Pool
  {
    struct List MHAnchor;   /*  Puddle list                         */
    ULONG Flags;            /*  AllocMem argument                   */
    ULONG PuddleSize;       /*  Usual puddle size                   */
    ULONG ThreshSize;       /*  Size that requires a special puddle */
  };





/**
***  AllocMemHeader() allocates a new block of RAM from the global
***  memory list.
**/
STATIC struct MemHeader *AllocMemHeader(ULONG Size, ULONG Flags)

{
    struct MemHeader *mh = NULL;

    /**
    ***  Allocate memory
    **/
    if ((mh = AllocMem(Size+sizeof(*mh), Flags))) {
	struct MemChunk *mc;

	/**
	***  Our memory block consists of a memheader structure,
	***  followed by a memchunk structure.
	***  We start with initializing the memchunk structure.
	**/
	mc = (struct MemChunk *) (mh+1);
	mc->mc_Next = NULL;
	mc->mc_Bytes = Size;  

	/**
	***  Initialize the memheader structure.
	**/
	mh->mh_Node.ln_Type = NT_MEMORY;
	mh->mh_Node.ln_Name = NULL;
	mh->mh_Node.ln_Succ = NULL;
	mh->mh_Node.ln_Pred = NULL;
	mh->mh_Node.ln_Pri = 0;
	mh->mh_First = mc;
	mh->mh_Lower = (APTR) mc;
	mh->mh_Upper = ((UBYTE *) mc) + Size;
	mh->mh_Free = Size;

    }

    return(mh);
}






/**
***  FreeMemHeader() is the counterpart of AllocMemHeader().
**/
STATIC void FreeMemHeader(struct MemHeader *mh)

{
    /**
    ***  Be safe
    **/
    if (mh) {
	FreeMem(mh, (UBYTE *) mh->mh_Upper - (UBYTE *) mh->mh_Lower +
		    sizeof(*mh));
    }
}







/**
***  LibCreatePool() is the CreatePool() equivalent. In fact, it calls
***  CreatePool(), if the OS is V39 or higher.
**/
void *LibCreatePool(ULONG Flags, ULONG PuddleSize, ULONG ThreshSize)

{
    struct Pool *pool;

    if (SysBase->LibNode.lib_Version >= 39) {
	return(CreatePool(Flags, PuddleSize, ThreshSize));
    }

    pool = NULL;
    if (ThreshSize <= PuddleSize) {
	if ((pool = AllocMem(sizeof(struct Pool), MEMF_ANY))) {
	    pool->Flags = Flags;
	    pool->PuddleSize = PuddleSize;
	    pool->ThreshSize = ThreshSize;
	    NewList(&pool->MHAnchor);
	    pool->MHAnchor.lh_Type = NT_MEMORY;
	}
    }
    return(pool);
}





/**
***  LibDeletePool() is the counterpart of LibCreatePool().
**/
void LibDeletePool(APTR pool)

{
    if (SysBase->LibNode.lib_Version >= 39) {
	DeletePool(pool);
    } else if (pool) {
	while (!IsListEmpty(&((struct Pool *) pool)->MHAnchor)) {
	    struct MemHeader *mh;

	    mh = (struct MemHeader *) ((struct Pool *) pool)->MHAnchor.lh_Head;
	    Remove(mh);
	    FreeMemHeader(mh);
	}
	FreeMem(pool, sizeof(struct Pool));
    }
}






/**
***  LibAllocPooled() is the AllocPooled() equivalent. In fact, it
***  calls AllocPooled(), if the OS is V39 or higher.
**/
STATIC BOOL AllocPuddle(struct Pool *pool, ULONG Size)

{
    struct MemHeader *mh = NULL;
    int poolsize;

    poolsize = MAX(pool->PuddleSize, Size+8);
    if (!(mh = AllocMemHeader(poolsize, pool->Flags))) {
	return(FALSE);  /*  Failure     */
    }
    AddHead(&pool->MHAnchor, (struct Node *) mh);
    return(TRUE);
}

APTR LibAllocPooled(APTR pool, ULONG Size)

{
    struct MemHeader *mh;
    APTR newmem = NULL;

    if (SysBase->LibNode.lib_Version >= 39) {
	return(AllocPooled(pool, Size));
    }

    /**
    ***  Allocate a new puddle, if puddle list is empty or Size
    ***  is big.
    **/
    if (IsListEmpty(&((struct Pool *) pool)->MHAnchor)  ||
	Size >= ((struct Pool *) pool)->ThreshSize) {
	if (!AllocPuddle(pool, Size)) {
	    return(NULL);
	}
    }

    /**
    ***  Look for a puddle with sufficient memory.
    **/
    mh = (struct MemHeader *) ((struct Pool *) pool)->MHAnchor.lh_Head;
    while (mh->mh_Node.ln_Succ) {
	if ((newmem = Allocate(mh, Size))) {
	    return(newmem);
	}
	mh = (struct MemHeader *) mh->mh_Node.ln_Succ;
    }

    /**
    ***  No puddle found, allocate a new one.
    **/
    if (!AllocPuddle(pool, Size)) {
	return(NULL);
    }
    mh = (struct MemHeader *) ((struct Pool *) pool)->MHAnchor.lh_Head;
    return(Allocate(mh, Size));
}




/**
***  LibFreePooled() is the counterpart to LibAllocPooled().
**/
void LibFreePooled(APTR pool, APTR mem, ULONG size)

{
    struct MemHeader *mh;

    if (!mem) {
	return;
    }

    mh = (struct MemHeader *) ((struct Pool *) pool)->MHAnchor.lh_Head;
    /**
    ***  Look for the right puddle.
    **/
    while (mh->mh_Node.ln_Succ) {
	if (mem >= mh->mh_Lower  &&  mem < mh->mh_Upper) {
	    Deallocate(mh, mem, size);
	    return;
	}
	mh = (struct MemHeader *) mh->mh_Node.ln_Succ;
    }
}
