/* $Id: memory.h,v 1.18 2005/11/10 15:33:07 hjfrieden Exp $ */
OPT NATIVE
MODULE 'target/exec/nodes', 'target/utility/hooks'
MODULE 'target/exec/types'
{#include <exec/memory.h>}
NATIVE {EXEC_MEMORY_H} CONST

/****** MemChunk ****************************************************/

NATIVE {MemChunk} OBJECT mc
    {mc_Next}	next	:PTR TO mc  /* pointer to next chunk */
    {mc_Bytes}	bytes	:ULONG /* chunk byte size      */
ENDOBJECT

/****** MemHeader ***************************************************/

NATIVE {MemHeader} OBJECT mh
    {mh_Node}	ln	:ln
    {mh_Attributes}	attributes	:UINT /* characteristics of this region */
    {mh_First}	first	:PTR TO mc      /* first free region */
    {mh_Lower}	lower	:APTR      /* lower memory bound */
    {mh_Upper}	upper	:APTR      /* upper memory bound+1 */
    {mh_Free}	free	:ULONG       /* total number of free bytes */
ENDOBJECT

/****** MemEntry ****************************************************/

NATIVE {MemEntry} OBJECT me
    {me_Un.meu_Reqs}	reqs	:ULONG /* the AllocMem requirements */
    {me_Un.meu_Addr}	addr	:APTR /* the address of this memory region */

    {me_Length}	length	:ULONG    /* the length of this memory region */
ENDOBJECT

NATIVE {me_un}    DEF        /* compatibility - do not use*/
NATIVE {me_Reqs}  DEF
NATIVE {me_Addr}  DEF

/****** MemList *****************************************************/

/* Note: sizeof(struct MemList) includes the size of the first MemEntry! */
NATIVE {MemList} OBJECT ml
    {ml_Node}	ln	:ln
    {ml_NumEntries}	numentries	:UINT /* number of entries in this struct */
    {ml_ME}	me	:ARRAY OF me      /* the first entry      */
ENDOBJECT

NATIVE {ml_me} DEF /* compatibility - do not use */

/*----- Memory Requirement Types ---------------------------*/
/*----- See the AllocMem() documentation for details--------*/

/*
 * MEMF_SHARED has replaced MEMF_PUBLIC for almost all applications,
 * starting with AmigaOS release 4.0. In order to help you build
 * and test software, you can #define one of the two preprocessor
 * symbols below:
 *
 *     __DISABLE_MEMF_PUBLIC
 *         The MEMF_PUBLIC symbol will not be defined, causing your
 *         compiler to print an error message where it is still
 *         referenced in your code. This can help in tracking down
 *         all the references to MEMF_PUBLIC, so that you can replace
 *         them with MEMF_SHARED where appropriate; do not forget to
 *         rebuild your code with the __DISABLE_MEMF_PUBLIC symbol
 *         taken out after you have made all the necessary changes!
 *
 *     __REPLACE_MEMF_PUBLIC
 *         The MEMF_PUBLIC symbol will be replaced with the definition
 *         of MEMF_SHARED. This has the effect of switching over all
 *         MEMF_PUBLIC references to MEMF_SHARED, an effect you could
 *         also achieve by a global search & replace operation performed
 *         on your source code. However, by defining __REPLACE_MEMF_PUBLIC
 *         in your build makefile and rebuilding your software, you can
 *         test the effects of the change to MEMF_SHARED much more
 *         easily. It is also helpful for software that needs to be built
 *         both for the 68k platform and the PowerPC.
 *
 * Note that these two symbol definitions are mutually exclusive!
 */

NATIVE {MEMF_ANY}        CONST MEMF_ANY        = (0    ) /* Any type of memory will do */
NATIVE {MEMF_PUBLIC}     CONST MEMF_PUBLIC     = $1
NATIVE {MEMF_CHIP}       CONST MEMF_CHIP       = $2
NATIVE {MEMF_FAST}       CONST MEMF_FAST       = $4
NATIVE {MEMF_VIRTUAL}    CONST MEMF_VIRTUAL    = $8 /* Memory that is mapped/paged */
NATIVE {MEMF_EXECUTABLE} CONST MEMF_EXECUTABLE = $10 /* Memory that contains executable code */
NATIVE {MEMF_LOCAL}      CONST MEMF_LOCAL      = $100 /* Memory that does not go away at RESET */
NATIVE {MEMF_24BITDMA}   CONST MEMF_24BITDMA   = $200 /* DMAable memory within
                                   * 24 bits of address */
NATIVE {MEMF_KICK}       CONST MEMF_KICK       = $400 /* Memory that can be used for KickTags */
NATIVE {MEMF_PRIVATE}    CONST MEMF_PRIVATE    = $800 /* Memory that is only _visible_ to the
                                   * allocator task */
NATIVE {MEMF_SHARED}     CONST MEMF_SHARED     = $1000 /* Memory that is visible and accessible
                                   * to all tasks */

NATIVE {MEMF_CLEAR}      CONST MEMF_CLEAR      = $10000 /* AllocMem: NULL out area before return */
NATIVE {MEMF_LARGEST}    CONST MEMF_LARGEST    = $20000 /* AvailMem: return the largest chunk size */
NATIVE {MEMF_REVERSE}    CONST MEMF_REVERSE    = $40000 /* AllocMem: allocate from the top down */
NATIVE {MEMF_TOTAL}      CONST MEMF_TOTAL      = $80000 /* AvailMem: return total size of memory */
NATIVE {MEMF_HWALIGNED}  CONST MEMF_HWALIGNED  = $100000 /* AllocMem: Allocate aligned to hardware
                                   *           page size */
NATIVE {MEMF_DELAYED}    CONST MEMF_DELAYED    = $200000 /* AllocMem: Delay physical memory mapping */

NATIVE {MEMF_NO_EXPUNGE} CONST MEMF_NO_EXPUNGE = $80000000 /* AllocMem: Do not cause expunge
                                   *           on failure */

/*----- Current alignment rules for memory blocks (may increase) -----*/
NATIVE {MEM_BLOCKSIZE} CONST MEM_BLOCKSIZE = (8)
NATIVE {MEM_BLOCKMASK} CONST MEM_BLOCKMASK = (MEM_BLOCKSIZE-1)


/****** MemHandlerData **********************************************/
/* Note:  This structure is *READ ONLY* and only EXEC can create it!*/
NATIVE {MemHandlerData} OBJECT memhandlerdata
    {memh_RequestSize}	requestsize	:ULONG  /* Requested allocation size */
    {memh_RequestFlags}	requestflags	:ULONG /* Requested allocation flags */
    {memh_Flags}	flags	:ULONG        /* Flags (see below) */
ENDOBJECT

NATIVE {enMemHandlerFlags} DEF
NATIVE {MEMHF_RECYCLE} CONST MEMHF_RECYCLE = $1  /* 0==First time, 1==recycle */


/****** Low Memory handler return values ***************************/
NATIVE {enMemHandlerActions} DEF
NATIVE {MEM_DID_NOTHING} CONST MEM_DID_NOTHING = ( 0) /* Nothing we could do... */
NATIVE {MEM_ALL_DONE}    CONST MEM_ALL_DONE    = (-1) /* We did all we could do */
NATIVE {MEM_TRY_AGAIN}   CONST MEM_TRY_AGAIN   = ( 1)  /* We did some, try the allocation again */


/****** Memory attributes ******************************************/
NATIVE {enMemAttrs} DEF
NATIVE {MEMATTRF_WRITETHROUGH}     CONST MEMATTRF_WRITETHROUGH     = $1 /* Stores in this area update cache
                                           * and memory */
NATIVE {MEMATTRF_CACHEINHIBIT}     CONST MEMATTRF_CACHEINHIBIT     = $2 /* Caches are inhibited in this
                                           * area */
NATIVE {MEMATTRF_COHERENT}         CONST MEMATTRF_COHERENT         = $4 /* Coherency required, stores to
                                           * same region will be serialized */
NATIVE {MEMATTRF_GUARDED}          CONST MEMATTRF_GUARDED          = $8 /* Ensure in-order execute of memory
                                           * accesses */

NATIVE {MEMATTRF_REFERENCED}       CONST MEMATTRF_REFERENCED       = $10 /* Page containing memory location
                                           * has been referenced (used) */
NATIVE {MEMATTRF_CHANGED}          CONST MEMATTRF_CHANGED          = $20 /* Page containing memory location
                                           * has been changed */

NATIVE {MEMATTRF_SUPER_RW}         CONST MEMATTRF_SUPER_RW         = $0
NATIVE {MEMATTRF_SUPER_RW_USER_RO} CONST MEMATTRF_SUPER_RW_USER_RO = $40
NATIVE {MEMATTRF_SUPER_RW_USER_RW} CONST MEMATTRF_SUPER_RW_USER_RW = $80
NATIVE {MEMATTRF_SUPER_RO_USER_RO} CONST MEMATTRF_SUPER_RO_USER_RO = $C0
NATIVE {MEMATTRF_RW_MASK}          CONST MEMATTRF_RW_MASK          = $C0

NATIVE {MEMATTRF_EXECUTE}          CONST MEMATTRF_EXECUTE          = $200 /* CPU can execute instructions
                                           * from this memory */

NATIVE {MEMATTRF_NOT_MAPPED}       CONST MEMATTRF_NOT_MAPPED       = $400 /* Special flag: The memory is not
                                           * mapped at all. This flag is only
                                           * used as return value of
                                           * GetMemoryAttr */
NATIVE {MEMATTRF_RESERVED1}        CONST MEMATTRF_RESERVED1        = $800 /* Used by the system */
NATIVE {MEMATTRF_RESERVED2}        CONST MEMATTRF_RESERVED2        = $1000 /* _NEVER_ use these */
NATIVE {MEMATTRF_RESERVER3}        CONST MEMATTRF_RESERVER3        = $2000


/* Short forms for common cases */
NATIVE {MEMATTRF_READ_WRITE} CONST MEMATTRF_READ_WRITE = MEMATTRF_SUPER_RW_USER_RW
NATIVE {MEMATTRF_READ_ONLY}  CONST MEMATTRF_READ_ONLY  = MEMATTRF_SUPER_RO_USER_RO

/****** GetMemoryAttrs flags ******************************************/
NATIVE {enGetMemoryAttrsFlags} DEF
NATIVE {GMAF_REPORT_CR} CONST GMAF_REPORT_CR = $1


/****** AllocSysObject flags ******************************************/
NATIVE {enAllocSysObjectFlags} DEF
NATIVE {ASOF_NOTRACK} CONST ASOF_NOTRACK = $2 /* Used internally to indicate
                            * no tracking of object */

/****************************************************************************/

/* Warning: Everything below default alignmend */

/****** Trackable ***************************************************/

/* 
 * Warning: 
 * Do NOT allocate one of those yourself!
 */

NATIVE {Trackable} OBJECT trackable
    {Destructor}	destructor	:hook
    {Object}	object	:APTR
    {Flags}	flags	:ULONG
    {HashChain}	hashchain	:PTR TO trackable
    /* Long word aligned */
ENDOBJECT

NATIVE {enTrackableFlags} DEF
NATIVE {TRACKF_COMPACT} CONST TRACKF_COMPACT = $1 /* Trackable was allocated by "constructor" */


/****** DMA Scatter list ********************************************/

NATIVE {DMAEntry} OBJECT dmaentry
    {PhysicalAddress}	physicaladdress	:APTR /* Physically mapped address */
    {BlockLength}	blocklength	:ULONG     /* Length of the block in physical memory */
ENDOBJECT
