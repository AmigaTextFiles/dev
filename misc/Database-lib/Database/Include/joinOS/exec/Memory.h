/* memory.h
 *
 * Headerfile for Exec's memory functions for writing portable code.
 */

#ifndef _MEMORY_H_
#define _MEMORY_H_

#ifndef _DEFINES_H_
#include <joinOS/exec/defines.h>
#endif

#ifndef _LISTS_H_
#include <joinOS/exec/Lists.h>
#endif

/* --- Defines (all systems)------------------------------------------------- */

/* Default size of a single memoryblock (for a puddle of a pool)
 * Should not be changed, cause Exec use it for its own pool.
 * If you change it, take an even multiply of the current value (64K)
 */
#define MEMBLOCKSIZE 65536

#ifdef _AMIGA

#include <exec/memory.h>

#else		/* _AMIGA */

/* If compiled for Windoof-systems the AmigaOS-functions and structures
 * are rewritten for use in that environment.
 */

/* --- Defines (windoof specific) ------------------------------------------- */

/* Memory types - ignored under Windoof (except MEMF_PUBLIC) */
#define MEMF_ANY			0x00000000
/* Under AmigaOS (and therefore for applications using the emulating-system)
 * all memory needed for system calls must be shared.
 */
#define MEMF_PUBLIC		0x00000001
#define MEMF_CHIP			0x00000002
#define MEMF_FAST			0x00000004
#define MEMF_LOCAL		0x00000008
#define MEMF_24BITDMA	0x00000010

/* Memory requirements - ignored under Windoof (except MEMF_CLEAR) */
#define MEMF_CLEAR	0x00010000
#define MEMF_LARGEST 0x00020000
#define MEMF_REVERSE 0x00040000
#define MEMF_TOTAL	0x00080000

/* current allignment rules for memory-blocks (may increase) */
#define MEM_BLOCKSIZE	8L
#define MEM_BLOCKMASK	(MEM_BLOCKSIZE-1)

/* --- Structures (redifinition for AmigaOS structures for use in windoof) -- */

/* Structure for a linked list of free memory blocks.
 * Every block is at a minimum 8 bytes long and aligned on 4 bytes boundarys.
 */
struct MemChunk		/* longword-aligned, size 8 */
{
	struct MemChunk *mc_Next;	/* pointer to next free memory block */
	ULONG mc_Bytes;				/* size of this free memory block in bytes */
};

/* Structure to handle a linked list of free memory blocks.
 * The memory block this structure handles must be aligned on 8
 * byte boundarys, otherwise, there could be a leak of memory.
 */
struct MemHeader		/* longword-aligned, size 32 */
{
	struct Node mh_Node;			/* Node structure, used to link a number of MemHeaders */
	UWORD  mh_Attributes;		/* characteristics of this memory region */
	struct MemChunk *mh_First;	/* ptr. to first free memory region */
	APTR   mh_Lower;				/* lower memory bound */
	APTR   mh_Upper;				/* upper memory bound+1 */
	ULONG  mh_Free;				/* total number of free bytes */
};

/* Structure for use in structure MemList for multiple allocations in a
 * single call to AllocEntry().
 */
struct MemEntry
{
	union
	{
		ULONG meu_Reqs;	/* the AllocMem() requirements */
		APTR	meu_Addr;	/* the address of this memory region */
	} me_Un;
	ULONG me_Length;		/* the size of the memory region */
};

#define me_un	me_Un		/* compatibility - do not use ! */
#define me_Reqs	me_Un.meu_Reqs
#define me_Addr	me_Un.meu_Addr
	

/* Structure used to allocate multiple blocks of memory by a single call to
 * AllocEntry()/FreeEntry().
 * NOTE: sizeof (struct MemList) includes the size of the first MemEntry !
 */
struct MemList
{
	struct Node ml_Node;
	UWORD	ml_NumEntries;			/* number of entries in this struct */
	struct MemEntry ml_ME[1];	/* the first entry */
};

#define ml_me	ml_ME		/* compatibility - do not use ! */

#endif		/* _AMIGA */

/* --- Private structures (NEVER use in application code) ------------------- */

/* A pointer to this structure is returned by CreateMemPool() under AmigaOS
 * version < V39 or Windoof systems, but NOT under AmigaOS >= V39.
 */
struct PoolHeader			/* word-aligned, size 22 */
{
	ULONG ph_PuddleSize;				/* size of a single "puddle" of the pool */
	ULONG ph_ThreshSize;				/* size of largest memory allocated from
											 * within a normal puddle */
	struct MinList ph_MemList;		/* list header of the list of puddles */
	UWORD ph_Attributes;				/* memory type of the pool */
};

#endif		/* _MEMORY_H_ */
