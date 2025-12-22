/* fmalloc.c */

#include <exec/memory.h>
#include <libraries/arpbase.h>
#include <functions.h>

/* !!! could add a magic # to this to make free() more robust */
struct mem {
    struct DefaultTracker *tracker;
};


/*doc fmalloc
NAME
    fmalloc -- arp'd fmalloc()

SYNOPSIS
    result = fmalloc(size,flags)

    void *result;
    unsigned long size,flags;

FUNCTION
    Allocates memory using Amiga memory flags (defined in
    <exec/memory.h>).  Memory allocated this way can later be freed by
    calling free().  These allocations use Arp resource tracking an
    therefore will be freed by ArpExit().

INPUTS
    size - number of bytes to allocate
    flags - memory (MEMF_) flags

RESULTS
    result - pointer to memory block or NULL on failure

SEE ALSO
    malloc(), free(), fmalloc()

MODULE
    fmalloc.c
*end */

void *fmalloc(size,flags)
unsigned long size,flags;
{
    register struct mem *mp;

    if (!(mp = ArpAllocMem(size+sizeof(struct mem), flags))) return NULL;

    mp->tracker = LastTracker;

    return (char *)mp + sizeof(struct mem);
}

void *lmalloc(size)
unsigned long size;
{
    return fmalloc (size,0L);
}

void *calloc (nelem,size)
unsigned nelem, size;
{
    return fmalloc ((unsigned long)nelem * size,MEMF_CLEAR);
}

void *lcalloc (nelem,size)
unsigned long nelem, size;
{
    return fmalloc (nelem * size,MEMF_CLEAR);
}

void *malloc(size)
unsigned size;
{
    return fmalloc ((unsigned long)size,0L);
}

free(blk)
char *blk;
{
    register struct mem *mp = (void *)(blk - sizeof(struct mem));

    FreeTrackedItem (mp->tracker);
    return 0;
}
