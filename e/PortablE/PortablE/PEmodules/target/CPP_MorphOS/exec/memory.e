/* $VER: memory.h 39.3 (21.5.1992) */
OPT NATIVE
MODULE 'target/exec/nodes'
MODULE 'target/exec/types'
{#include <exec/memory.h>}
NATIVE {EXEC_MEMORY_H} CONST

/****** MemChunk ****************************************************/

NATIVE {MemChunk} OBJECT mc
    {mc_Next}	next	:PTR TO mc	/* pointer to next chunk */
    {mc_Bytes}	bytes	:ULONG		/* chunk byte size	*/
ENDOBJECT


/****** MemHeader ***************************************************/

NATIVE {MemHeader} OBJECT mh
    {mh_Node}	ln	:ln
    {mh_Attributes}	attributes	:UINT	/* characteristics of this region */
    {mh_First}	first	:PTR TO mc /* first free region		*/
    {mh_Lower}	lower	:APTR		/* lower memory bound		*/
    {mh_Upper}	upper	:APTR		/* upper memory bound+1	*/
    {mh_Free}	free	:ULONG		/* total number of free bytes	*/
ENDOBJECT


/****** MemEntry ****************************************************/

NATIVE {MemEntry} OBJECT me
    {me_Un.meu_Reqs}	reqs	:ULONG		/* the AllocMem requirements */
    {me_Un.meu_Addr}	addr	:APTR		/* the address of this memory region */
    {me_Length}			length	:ULONG		/* the length of this memory region */
ENDOBJECT

NATIVE {me_un}	    DEF 	/* compatibility - do not use*/
NATIVE {me_Reqs}     DEF
NATIVE {me_Addr}     DEF


/****** MemList *****************************************************/

/* Note: sizeof(struct MemList) includes the size of the first MemEntry! */
NATIVE {MemList} OBJECT ml
    {ml_Node}	ln	:ln
    {ml_NumEntries}	numentries	:UINT	/* number of entries in this struct */
    {ml_ME}		me	:ARRAY OF me	/* the first entry	*/
ENDOBJECT

NATIVE {ml_me}	DEF		/* compatability - do not use */


/*----- Memory Requirement Types ---------------------------*/
/*----- See the AllocMem() documentation for details--------*/

NATIVE {MEMF_ANY}    CONST MEMF_ANY    = $0	/* Any type of memory will do */
NATIVE {MEMF_PUBLIC} CONST MEMF_PUBLIC = $1
NATIVE {MEMF_CHIP}   CONST MEMF_CHIP   = $2
NATIVE {MEMF_FAST}   CONST MEMF_FAST   = $4
NATIVE {MEMF_LOCAL}  CONST MEMF_LOCAL  = $100	/* Memory that does not go away at RESET */
NATIVE {MEMF_24BITDMA} CONST MEMF_24BITDMA = $200	/* DMAable memory within 24 bits of address */
NATIVE {MEMF_KICK}   CONST MEMF_KICK   = $400	/* Memory that can be used for KickTags */

NATIVE {MEMF_CLEAR}   CONST MEMF_CLEAR   = $10000	/* AllocMem: NULL out area before return */
NATIVE {MEMF_LARGEST} CONST MEMF_LARGEST = $20000	/* AvailMem: return the largest chunk size */
NATIVE {MEMF_REVERSE} CONST MEMF_REVERSE = $40000	/* AllocMem: allocate from the top down */
NATIVE {MEMF_TOTAL}   CONST MEMF_TOTAL   = $80000	/* AvailMem: return total size of memory */

NATIVE {MEMF_NO_EXPUNGE}	CONST MEMF_NO_EXPUNGE	= $80000000 /*AllocMem: Do not cause expunge on failure */

/*----- Current alignment rules for memory blocks (may increase) -----*/
NATIVE {MEM_BLOCKSIZE}	CONST MEM_BLOCKSIZE	= 8
NATIVE {MEM_BLOCKMASK}	CONST MEM_BLOCKMASK	= (MEM_BLOCKSIZE-1)


/****** MemHandlerData **********************************************/
/* Note:  This structure is *READ ONLY* and only EXEC can create it!*/
NATIVE {MemHandlerData} OBJECT memhandlerdata
	{memh_RequestSize}	requestsize	:ULONG	/* Requested allocation size */
	{memh_RequestFlags}	requestflags	:ULONG	/* Requested allocation flags */
	{memh_Flags}	flags	:ULONG		/* Flags (see below) */
ENDOBJECT

NATIVE {MEMHF_RECYCLE}	CONST MEMHF_RECYCLE	= $1	/* 0==First time, 1==recycle */

/****** Low Memory handler return values ***************************/
NATIVE {MEM_DID_NOTHING}	CONST MEM_DID_NOTHING	= (0)	/* Nothing we could do... */
NATIVE {MEM_ALL_DONE}	CONST MEM_ALL_DONE	= (-1)	/* We did all we could do */
NATIVE {MEM_TRY_AGAIN}	CONST MEM_TRY_AGAIN	= (1)	/* We did some, try the allocation again */
