@DATABASE "gg:doc/NDK/Guide/Include/exec/memory.h"
@MASTER   "gg:os-include/exec/memory.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:13:15
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "exec/memory.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"exec/memory.h" LINK File}


@{b}Structures@{ub}

@{"MemChunk" LINK "gg:doc/NDK/Guide/Include/exec/memory.h/File" 20}  @{"MemEntry" LINK "gg:doc/NDK/Guide/Include/exec/memory.h/File" 40}  @{"MemHandlerData" LINK "gg:doc/NDK/Guide/Include/exec/memory.h/File" 90}  @{"MemHeader" LINK "gg:doc/NDK/Guide/Include/exec/memory.h/File" 28}  @{"MemList" LINK "gg:doc/NDK/Guide/Include/exec/memory.h/File" 56}


@{b}#defines@{ub}

@{"me_Addr" LINK "gg:doc/NDK/Guide/Include/exec/memory.h/File" 50}          @{"me_Reqs" LINK "gg:doc/NDK/Guide/Include/exec/memory.h/File" 49}        @{"me_un" LINK "gg:doc/NDK/Guide/Include/exec/memory.h/File" 48}            @{"MEM_ALL_DONE" LINK "gg:doc/NDK/Guide/Include/exec/memory.h/File" 101}
@{"MEM_BLOCKMASK" LINK "gg:doc/NDK/Guide/Include/exec/memory.h/File" 85}    @{"MEM_BLOCKSIZE" LINK "gg:doc/NDK/Guide/Include/exec/memory.h/File" 84}  @{"MEM_DID_NOTHING" LINK "gg:doc/NDK/Guide/Include/exec/memory.h/File" 100}  @{"MEM_TRY_AGAIN" LINK "gg:doc/NDK/Guide/Include/exec/memory.h/File" 102}
@{"MEMF_24BITDMA" LINK "gg:doc/NDK/Guide/Include/exec/memory.h/File" 73}    @{"MEMF_ANY" LINK "gg:doc/NDK/Guide/Include/exec/memory.h/File" 68}       @{"MEMF_CHIP" LINK "gg:doc/NDK/Guide/Include/exec/memory.h/File" 70}        @{"MEMF_CLEAR" LINK "gg:doc/NDK/Guide/Include/exec/memory.h/File" 76}
@{"MEMF_FAST" LINK "gg:doc/NDK/Guide/Include/exec/memory.h/File" 71}        @{"MEMF_KICK" LINK "gg:doc/NDK/Guide/Include/exec/memory.h/File" 74}      @{"MEMF_LARGEST" LINK "gg:doc/NDK/Guide/Include/exec/memory.h/File" 77}     @{"MEMF_LOCAL" LINK "gg:doc/NDK/Guide/Include/exec/memory.h/File" 72}
@{"MEMF_NO_EXPUNGE" LINK "gg:doc/NDK/Guide/Include/exec/memory.h/File" 81}  @{"MEMF_PUBLIC" LINK "gg:doc/NDK/Guide/Include/exec/memory.h/File" 69}    @{"MEMF_REVERSE" LINK "gg:doc/NDK/Guide/Include/exec/memory.h/File" 78}     @{"MEMF_TOTAL" LINK "gg:doc/NDK/Guide/Include/exec/memory.h/File" 79}
@{"MEMHF_RECYCLE" LINK "gg:doc/NDK/Guide/Include/exec/memory.h/File" 97}    @{"ml_me" LINK "gg:doc/NDK/Guide/Include/exec/memory.h/File" 62}          

@ENDNODE
@NODE File "exec/memory.h"
#ifndef EXEC_MEMORY_H
#define EXEC_MEMORY_H
/*
**      $VER: memory.h 39.3 (21.5.1992)
**      Includes Release 45.1
**
**      Definitions and structures used by the memory allocation system
**
**      (C) Copyright 1985-2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifndef EXEC_NODES_H
#include <@{"exec/nodes.h" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File"}>
#endif /* EXEC_NODES_H */


/****** MemChunk ****************************************************/

struct  MemChunk {
    struct  MemChunk *mc_Next;  /* pointer to next chunk */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   mc_Bytes;           /* chunk byte size      */
};


/****** MemHeader ***************************************************/

struct  MemHeader {
    @{"struct  Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} mh_Node;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   mh_Attributes;      /* characteristics of this region */
    @{"struct  MemChunk" LINK File 20} *mh_First; /* first free region            */
    @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}    mh_Lower;           /* lower memory bound           */
    @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}    mh_Upper;           /* upper memory bound+1 */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   mh_Free;            /* total number of free bytes   */
};


/****** MemEntry ****************************************************/

struct  MemEntry {
union
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   meu_Reqs;           /* the @{"AllocMem" LINK "gg:doc/NDK/Guide/exec/AllocMem"} requirements */
    @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}    meu_Addr;           /* the address of this memory region */
    } me_Un;
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   me_Length;          /* the length of this memory region */
};

#define me_un       me_Un       /* compatibility - do not use*/
#define me_Reqs     me_Un.meu_Reqs
#define me_Addr     me_Un.meu_Addr


/****** MemList *****************************************************/

/* Note: sizeof(@{"struct MemList" LINK "gg:doc/NDK/Guide/Include/exec/memory.h/File" 56}) includes the size of the first MemEntry! */
struct  MemList {
    @{"struct  Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} ml_Node;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   ml_NumEntries;      /* number of entries in this struct */
    @{"struct  MemEntry" LINK "gg:doc/NDK/Guide/Include/exec/memory.h/File" 40} ml_ME[1];  /* the first entry      */
};

#define ml_me   ml_ME           /* compatability - do not use */


/*----- Memory Requirement Types ---------------------------*/
/*----- See the @{"AllocMem()" LINK "gg:doc/NDK/Guide/exec/AllocMem"} documentation for details--------*/

#define MEMF_ANY    (0L)        /* Any type of memory will do */
#define MEMF_PUBLIC (1L<<0)
#define MEMF_CHIP   (1L<<1)
#define MEMF_FAST   (1L<<2)
#define MEMF_LOCAL  (1L<<8)     /* Memory that does not go away at @{"RESET" LINK "gg:doc/NDK/Guide/exec/RESET"} */
#define MEMF_24BITDMA (1L<<9)   /* DMAable memory within 24 bits of address */
#define MEMF_KICK   (1L<<10)    /* Memory that can be used for KickTags */

#define MEMF_CLEAR   (1L<<16)   /* @{"AllocMem" LINK "gg:doc/NDK/Guide/exec/AllocMem"}: @{"NULL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 101} out area before return */
#define MEMF_LARGEST (1L<<17)   /* @{"AvailMem" LINK "gg:doc/NDK/Guide/exec/AvailMem"}: return the largest chunk size */
#define MEMF_REVERSE (1L<<18)   /* @{"AllocMem" LINK "gg:doc/NDK/Guide/exec/AllocMem"}: allocate from the top down */
#define MEMF_TOTAL   (1L<<19)   /* @{"AvailMem" LINK "gg:doc/NDK/Guide/exec/AvailMem"}: return total size of memory */

#define MEMF_NO_EXPUNGE (1L<<31) /*@{"AllocMem" LINK "gg:doc/NDK/Guide/exec/AllocMem"}: Do not cause expunge on failure */

/*----- Current alignment rules for memory blocks (may increase) -----*/
#define MEM_BLOCKSIZE   8L
#define MEM_BLOCKMASK   (@{"MEM_BLOCKSIZE" LINK File 84}-1)


/****** MemHandlerData **********************************************/
/* Note:  This structure is *READ ONLY* and only EXEC can create it!*/
struct MemHandlerData
{
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   memh_RequestSize;       /* Requested allocation size */
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   memh_RequestFlags;      /* Requested allocation flags */
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   memh_Flags;             /* Flags (see below) */
};

#define MEMHF_RECYCLE   (1L<<0) /* 0==First time, 1==recycle */

/****** Low Memory handler return values ***************************/
#define MEM_DID_NOTHING (0)     /* Nothing we could do... */
#define MEM_ALL_DONE    (-1)    /* We did all we could do */
#define MEM_TRY_AGAIN   (1)     /* We did some, try the allocation again */

#endif  /* EXEC_MEMORY_H */
@ENDNODE
