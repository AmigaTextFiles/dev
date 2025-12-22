;
; ** $VER: memory.h 39.3 (21.5.92)
; ** Includes Release 40.15
; **
; ** Definitions and structures used by the memory allocation system
; **
; ** (C) Copyright 1985-1993 Commodore-Amiga, Inc.
; **     All Rights Reserved
;
;
; 05/02/2000
;   Added union support

XIncludeFile "exec/nodes.pb"


; ***** MemChunk ***************************************************

Structure MemChunk
    *mc_Next.MemChunk ;  pointer to next chunk
    mc_Bytes.l  ;  chunk byte size
EndStructure


; ***** MemHeader **************************************************

Structure MemHeader
    mh_Node.Node
    mh_Attributes.w ;  characteristics of this region
    *mh_First.MemChunk ;  first free region
    *mh_Lower.l  ;  lower memory bound
    *mh_Upper.l  ;  upper memory bound+1
    mh_Free.l  ;  total number of free bytes
EndStructure


; ***** MemEntry ***************************************************

Structure MemEntry
  StructureUnion
    me_Reqs.l  ;  the AllocMem requirements
   *me_Addr.l  ;  the address of this memory region
  EndStructureUnion

  me_Length.l  ;  the length of this memory region
EndStructure

;#me_Reqs     = me_Un\meu_Reqs
;#me_Addr     = me_Un\meu_Addr


; ***** MemList ****************************************************

;  Note: sizeof(struct MemList) includes the size of the first MemEntry!
Structure MemList
    ml_Node.Node
    ml_NumEntries.w ;  number of entries in this struct
    ml_ME.MemEntry[1] ;  the first entry
EndStructure

;#ml_me = ml_ME  ;  compatability - do not use

; ----- Memory Requirement Types ---------------------------
; ----- See the AllocMem() documentation for details--------

#MEMF_ANY    = (0) ;  Any type of memory will do
#MEMF_PUBLIC = (1 LSL 0)
#MEMF_CHIP   = (1 LSL 1)
#MEMF_FAST   = (1 LSL 2)
#MEMF_LOCAL  = (1 LSL 8) ;  Memory that does not go away at RESET
#MEMF_24BITDMA = (1 LSL 9) ;  DMAable memory within 24 bits of address
#MEMF_KICK   = (1 LSL 10) ;  Memory that can be used for KickTags

#MEMF_CLEAR   = (1 LSL 16) ;  AllocMem: NULL out area before return
#MEMF_LARGEST = (1 LSL 17) ;  AvailMem: return the largest chunk size
#MEMF_REVERSE = (1 LSL 18) ;  AllocMem: allocate from the top down
#MEMF_TOTAL   = (1 LSL 19) ;  AvailMem: return total size of memory

#MEMF_NO_EXPUNGE = (1 LSL 31) ; AllocMem: Do not cause expunge on failure

; ----- Current alignment rules for memory blocks (may increase) -----
#MEM_BLOCKSIZE = 8
#MEM_BLOCKMASK = (#MEM_BLOCKSIZE-1)


; ***** MemHandlerData *********************************************
;  Note:  This structure is *READ ONLY* and only EXEC can create it!
Structure MemHandlerData

 memh_RequestSize.l ;  Requested allocation size
 memh_RequestFlags.l ;  Requested allocation flags
 memh_Flags.l  ;  Flags (see below)
EndStructure

#MEMHF_RECYCLE = (1 LSL 0) ;  0==First time, 1==recycle

; ***** Low Memory handler return values **************************
#MEM_DID_NOTHING = (0) ;  Nothing we could do...
#MEM_ALL_DONE = (-1) ;  We did all we could do
#MEM_TRY_AGAIN = (1) ;  We did some, try the allocation again

