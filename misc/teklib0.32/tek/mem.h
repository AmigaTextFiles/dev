
#ifndef _TEK_MEM_H
#define _TEK_MEM_H 1

/*
**	tek/mem.h
**
*/

#include <tek/list.h>
#include <tek/util.h>


typedef TINT (*TDESTROYFUNC)(TAPTR handle);


typedef struct					/* generic object handle */
{
	TNODE node;					/* node header for linkage */
	TAPTR mmu;					/* memory management unit */
	TDESTROYFUNC destroyfunc;	/* destroy function for this object */
}	THNDL;


typedef struct					/* lowlevel memheader. consider it private */
{
	THNDL handle;				/* object handle (currently needed for linking to a MMU) */
	TBYTE *mem;					/* ptr to raw memory */
	TUINT memnodesize;			/* size of a memory node, including alignment */
	TUINT align;				/* alignment size - 1 [bytes] */
	TUINT freesize;				/* total number of free bytes in this block */
}	TMEMHEAD;


typedef struct _tmemnode		/* lowlevel memnode. may be considered private */
{
	struct _tmemnode *next;
	struct _tmemnode *prev;
	TUINT free;					/* number of bytes free in this node */
	TUINT size;					/* number of bytes handled by this node */
}	TMEMNODE;


typedef struct					/* mempool. private. */
{
	THNDL handle;	
	TLIST list;					/* list of static pools */
	TUINT align;				/* memory alignment size */
	TUINT chunksize;			/* aligned size of chunk allocations */
	TUINT thressize;			/* aligned threshold for regular-block allocations */
	TUINT poolnodesize;			/* aligned size of poolheader */
	TUINT memnodesize;			/* aligned size of a memnode */
	TBOOL dyngrow;				/* perform dynamic pool growth */
	TFLOAT dynfactor;			/* chunk/thressize. adapted before allocating large chunks. */
}	TMEMPOOL;


typedef struct					/* mempool node. private. */
{
	TNODE node;
	TMEMHEAD memhead;
	TUINT numbytes;				/* actually allocatable size */
}	TPOOLNODE;


typedef struct									/* memory management unit */
{
	THNDL handle;								/* object handle */
	TUINT type;									/* type of this MMU */
	TAPTR allocator;							/* primary allocator, may be backptr to this MMU */
	TAPTR suballocator;							/* sub allocator, can be destroyed with destroymmufunc */
	TDESTROYFUNC destroyallocatorfunc;			/* function to destroy allocator or suballocator */
	TDESTROYFUNC destroymmufunc;				/* function to destroy MMU, or TNULL */

	TAPTR (*allocfunc)(TAPTR allocator, TUINT size);						/* callback hub functions */
	TVOID (*freefunc)(TAPTR allocator, TAPTR mem);
	TAPTR (*reallocfunc)(TAPTR allocator, TAPTR mem, TUINT newsize);
	TUINT (*getsizefunc)(TAPTR allocator, TAPTR mem);
	TAPTR reserved[2];

	TLIST tracklist;							/* tracking list for allocations */
	TKNOB tasklock;								/* lock for multitasking access */
	TAPTR userdata;								/* unrestricted use for user MMUs */

}	TMMU;


/* 
**	mmu types.
*/

#define TMMUT_Void		0x00000000		/* void MMU incapable of allocating */
#define TMMUT_MMU		0x00000100		/* put MMU on top of a parent MMU */
#define TMMUT_Kernel	0x00000101		/* put MMU on top of kernel */
#define TMMUT_Static	0x00000102		/* put MMU on top of a static memheader */
#define TMMUT_Pooled	0x00000103		/* put MMU on top of a pooled allocator */
#define TMMUT_Tracking	0x00001000		/* implement memory tracking on top of a parent MMU */
#define TMMUT_TaskSafe	0x00002000		/* implement task-safety on top of a parent MMU */
#define TMMUT_Message	0x00010000		/* message allocator on top of a parent (or TNULL) MMU */


/* 
**	mem tags.
*/

#define TMEMTAGS_					(TTAG_USER + 0x200)
#define TMem_DynGrow				(TTAG) (TMEMTAGS_ + 0)		/* use dynamic pool growth */



TBEGIN_C_API


extern TVOID TMemCopy(TAPTR from, TAPTR to, TUINT numbytes)								__ELATE_QCALL__(("qcall lib/tek/mem/memcopy"));
extern TVOID TMemCopy32(TAPTR from, TAPTR to, TUINT numbytes)							__ELATE_QCALL__(("qcall lib/tek/mem/memcopy32"));
extern TVOID TMemFill(TAPTR dest, TUINT numbytes, TUINT fillval)						__ELATE_QCALL__(("qcall lib/tek/mem/memfill"));
extern TVOID TMemFill32(TAPTR dest, TUINT numbytes, TUINT fillval)						__ELATE_QCALL__(("qcall lib/tek/mem/memfill32"));

extern TBOOL TInitMemHead(TMEMHEAD *head, TAPTR mem, TUINT size, TTAGITEM *tags)		__ELATE_QCALL__(("qcall lib/tek/mem/initmemhead"));
extern TAPTR TStaticAlloc(TMEMHEAD *head, TUINT size)									__ELATE_QCALL__(("qcall lib/tek/mem/staticalloc"));
extern TVOID TStaticFree(TMEMHEAD *head, TAPTR mem)										__ELATE_QCALL__(("qcall lib/tek/mem/staticfree"));
extern TAPTR TStaticRealloc(TMEMHEAD *head, TAPTR mem, TUINT size)						__ELATE_QCALL__(("qcall lib/tek/mem/staticrealloc"));
extern TUINT TStaticGetSize(TMEMHEAD *head, TAPTR mem)									__ELATE_QCALL__(("qcall lib/tek/mem/staticgetsize"));

extern TAPTR TCreatePool(TAPTR mmu, TUINT chunksize, TUINT thressize, TTAGITEM *tags)	__ELATE_QCALL__(("qcall lib/tek/mem/createpool"));
extern TAPTR TPoolAlloc(TAPTR pool, TUINT size)											__ELATE_QCALL__(("qcall lib/tek/mem/poolalloc"));
extern TVOID TPoolFree(TAPTR pool, TAPTR mem)											__ELATE_QCALL__(("qcall lib/tek/mem/poolfree"));
extern TAPTR TPoolRealloc(TAPTR pool, TAPTR mem, TUINT size)							__ELATE_QCALL__(("qcall lib/tek/mem/poolrealloc"));
extern TUINT TPoolGetSize(TAPTR mp, TAPTR mem)											__ELATE_QCALL__(("qcall lib/tek/mem/poolgetsize"));

extern TBOOL TInitMMU(TMMU *mmu, TAPTR allocator, TUINT mmutype, TTAGITEM *tags)		__ELATE_QCALL__(("qcall lib/tek/mem/initmmu"));
extern TAPTR TMMUAlloc0(TAPTR mmu, TUINT size)											__ELATE_QCALL__(("qcall lib/tek/mem/mmualloc0"));
extern TAPTR TMMURealloc(TAPTR mmu, TAPTR mem, TUINT newsize)							__ELATE_QCALL__(("qcall lib/tek/mem/mmurealloc"));

extern TAPTR TMMUAlloc(TAPTR mmu, TUINT size)											__ELATE_QCALL__(("qcall lib/tek/mem/mmualloc"));
extern TVOID TMMUFree(TAPTR mmu, TAPTR mem)												__ELATE_QCALL__(("qcall lib/tek/mem/mmufree"));
extern TUINT TMMUGetSize(TAPTR mmu, TAPTR mem)											__ELATE_QCALL__(("qcall lib/tek/mem/mmugetsize"));

/*#define TMMUAlloc(mmu, size)	(mmu) ? (*((TMMU *) (mmu))->allocfunc)(((TMMU *) (mmu))->allocator, (size)) : kn_alloc(size)*/
/*#define TMMUFree(mmu, mem)	(mmu) ? (*((TMMU *) (mmu))->freefunc)(((TMMU *) (mmu))->allocator, (mem)) : kn_free(mem)*/
/*#define TMMUGetSize(mmu, mem)	(mmu) ? (*((TMMU *) (mmu))->getsizefunc)(((TMMU *) (mmu))->allocator, (mem)) : kn_getsize(mem)*/

extern TAPTR TMMUAllocHandle(TAPTR mmu, TDESTROYFUNC destroyfunc, TUINT size)			__ELATE_QCALL__(("qcall lib/tek/mem/mmuallochandle"));
extern TAPTR TMMUAllocHandle0(TAPTR mmu, TDESTROYFUNC destroyfunc, TUINT size)			__ELATE_QCALL__(("qcall lib/tek/mem/mmuallochandle0"));
extern TVOID TMMUFreeHandle(TAPTR h)													__ELATE_QCALL__(("qcall lib/tek/mem/mmufreehandle"));

extern TINT TDestroy(TAPTR object)														__ELATE_QCALL__(("qcall lib/tek/mem/destroy"));


TEND_C_API


#endif
