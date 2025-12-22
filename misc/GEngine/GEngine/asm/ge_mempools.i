;----Memory management functions


   IFND  GE_MEMPOOLS_I
GE_MEMPOOLS_I SET 1

   XDEF Mtest1
   XDEF Mtest2
   XDEF  gehook1
   XDEF  gehook2
   XDEF  GE_NewMemPool
   XDEF  GE_PoolAlloc
   XDEF  GE_PoolDealloc
   XDEF  GE_FreeMemPool

gehook1:
   dc.l  0,0
   dc.l  Mtest1
   dc.l  0,0

gehook2:
   dc.l  0,0
   dc.l  Mtest2
   dc.l  0,0
;---- Test lower bounds of passed MemHeaders
Mtest1:
   movem.l a1-a2,-(sp)
   move.l  an_Key(a2),a2
   move.l  MH_LOWER(a2),d0
   move.l  (a1),a1
   sub.l   MH_LOWER(a1),d0
   movem.l (sp)+,a1-a2
   rts

Mtest2:
   move.l  a2,-(sp)
   move.l  an_Key(a2),a2
   move.l  MH_LOWER(a2),d0
   sub.l   (a1),d0
   bge.s   .mt2$
   move.l  MH_UPPER(a2),d0
   subq.l  #1,d0
   sub.l   (a1),d0
   ble.s   .mt2$
   moveq   #0,d0
.mt2$
   move.l  (sp)+,a2
   rts

;---GE_NewMemPool(d0,d1,d2):D0
GE_NewMemPool:
   tst.l   d0
   ble.s   .npe2$
   link    a5,#-16
   move.l  d0,-8(a5) ;Size
   move.l  d1,-4(a5) ;Attr
   movem.l a0-a1,-(sp)
   move.l  #MP_SIZEOF,d0
   move.l  #MEMF_CLEAR+MEMF_PUBLIC,d1
   CALLEXEC AllocMem        ;Alloc MemPool Struct
   tst.l   d0
   beq.s   .npe1$
   move.l  d0,a0
   move.l  d0,-12(a5)
   move.l  -8(a5),d0
   move.l  d0,mp_Size(a0)
   move.l  d0,mp_MemFree(a0)
   move.l  d0,mp_MemTotal(a0)
   move.l  -4(a5),mp_Attr(a0)
   cmp.w   #2,d2
   bge.s   .npt1$
   moveq   #2,d2
.npt1$
   move.w  d2,mp_ColapseNum(a0)
   move.w  #1,mp_FreeChunks(a0)
   move.b  #NT_MEMORY,LH_TYPE(a0)
   NEWLIST a0
   move.l  #MH_SIZE,d0
   move.l  #MEMF_CLEAR+MEMF_PUBLIC,d1
   jsr     _LVOAllocMem(a6) ;Alloc 1st memheader
   tst.l   d0
   beq.s   .npe3$
   move.l  d0,a1
   move.l  d0,-16(a5)
   move.b  #NT_MEMORY,LN_TYPE(a1)
   move.l  -12(a5),a0
   ADDHEAD
   move.l  -8(a5),d0
   move.l  -4(a5),d1
   jsr     _LVOAllocMem(a6) ;Alloc memchunk
   tst.l   d0
   beq.s   .npe4$
   move.l  d0,a0
   move.l  #0,MC_NEXT(a0)
   move.l  -8(a5),MC_BYTES(a0)
   move.l  -16(a5),a0     ;Init MemHeader
   move.l  d0,MH_FIRST(a0)
   move.l  d0,MH_LOWER(a0)
   move.l  -8(a5),d1
   move.l  d1,MH_FREE(a0)
   add.l   d0,d1
   move.l  d1,MH_UPPER(a0)
   moveq   #4,d0
   move.l  #MEMF_PUBLIC+MEMF_CLEAR,d1
   jsr     _LVOAllocMem(a6) ;**AVLNode
   tst.l   d0
   beq.s   .npe5$
   move.l  -12(a5),a0
   move.l  d0,mp_MemTree(a0)
   sub.l   a0,a0
   move.l  -16(a5),d0
   lea     gehook1(pc),a1
   bsr     GE_AVLInsert
   tst.l   d0
   beq.s   .npe6$
   move.l  -12(a5),a0
   move.l  mp_MemTree(a0),a1
   move.l  d0,(a1)
   move.l  a0,d0
   bra.s   .npe1$

.npe6$
   moveq    #4,d0
   move.l   -12(a5),a1
   move.l   mp_MemTree(a1),a1
   jsr      _LVOFreeMem(a6)
.npe5$
   move.l   -8(a5),d0
   move.l   -16(a5),a1
   move.l   MH_LOWER(a1),a1
   jsr      _LVOFreeMem(a6)
.npe4$
   move.l   #MH_SIZE,d0
   move.l   -16(a5),a1
   jsr      _LVOFreeMem(a6)
.npe3$
   move.l  #MP_SIZE,d0
   move.l  -12(a5),a1
   jsr     _LVOFreeMem(a6)
   moveq   #0,d0
.npe1$
   movem.l (sp)+,a0-a1
   unlk    a5
   rts
.npe2$
   moveq   #0,d0
   rts

;---GE_PoolAlloc(a0,d0)
GE_PoolAlloc:
   movem.l d1/a1-a2,-(sp)
   move.l  a0,d1
   beq.s   .pae1$  ;No mempoolptr ?
   tst.l   d0
   beq.s   .pae2$  ;0 Bytes
   cmp.l   mp_Size(a0),d0
   bgt.s   .pae1$  ;Too many bytes
   link    a5,#-12
   move.l  a0,-8(a5)
   move.l  d0,-4(a5)
   move.l  LH_HEAD(a0),a1
   lea     LH_TAIL(a0),a2
   move.l  a2,d1
.pab1$
   move.l  a1,a2
   move.l  LN_SUCC(a1),a1
   cmp.l   MH_FREE(a2),d0
   ble.s   .pat1$
   cmpa.l  d1,a1
   beq.s   .pat2$ ;No succesor?
   bra.s   .pab1$
.pat1$
   move.l  MH_FREE(a2),-12(a5)
   move.l  a2,a0
   CALLEXEC Allocate
   tst.l   d0
   beq.s   .pae4$
   move.l  -8(a5),a0
   move.l  -4(a5),d1
   sub.l   d1,mp_MemFree(a0)
   move.l  mp_Size(a0),d1
   cmp.l   -12(a5),d1
   bne.s   .pae5$
   sub.w   #1,mp_FreeChunks(a0)
.pae5$
   move.l   -8(a5),a0
   unlk     a5
   bra.s    .pae2$

.pat2$
   move.l   #MH_SIZE,d0
   move.l   #MEMF_CLEAR+MEMF_PUBLIC,d1
   CALLEXEC  AllocMem ;Alloc new memheader
   tst.l    d0
   beq.s    .pae4$
   move.l   d0,-12(a5)
   move.l   -8(a5),a0
   move.l   mp_Size(a0),d0
   move.l   mp_Attr(a0),d1
   jsr      _LVOAllocMem(a6) ;New Chunk
   tst.l    d0
   beq.s    .pae6$
   move.l   d0,a2
   move.l   -8(a5),a0
   move.l   #0,MC_NEXT(a2)
   move.l   mp_Size(a0),d1
   move.l   d1,MC_BYTES(a2)
   move.l   -12(a5),a1
   move.l   #NT_MEMORY,LN_TYPE(a1)
   move.l   d0,MH_LOWER(a1)
   move.l   d0,MH_FIRST(a1)
   move.l   d1,MH_FREE(a1)
   add.l    d1,d0
   move.l   d0,MH_UPPER(a1)
   ADDHEAD
   move.l   -8(a5),a0
   move.l   mp_MemTree(a0),a0
   move.l   a1,d0
   lea      gehook1(pc),a1
   bsr      GE_AVLInsert
   tst.l    d0
   beq.s    .pae7$
   move.l   -8(a5),a0
   add.l    d1,mp_MemTotal(a0)
   add.l    d1,mp_MemFree(a0)
   move.l   -12(a5),a0
   move.l   -4(a5),d0
   jsr      _LVOAllocate(a6) ;Alloc requested bytes
   tst.l    d0
   beq.s    .pae4$
   move.l   -8(a5),a0
   move.l   -4(a5),d1
   sub.l    d1,mp_MemFree(a0)
   bra.s    .pae5$

.pae7$
   move.l  a2,a1
   move.l  -8(a5),a0
   move.l  mp_Size(a0),d0
   jsr     _LVOFreeMem(a6)
.pae6$
   move.l  -12(a5),a1
   move.l  #MH_SIZE,d0
   jsr     _LVOFreeMem(a6)
.pae4$
   move.l  -8(a5),a0
.pae3$
   unlk    a5
.pae1$
   moveq   #0,d0
.pae2$
   movem.l (sp)+,d1/a1-a2
   rts

;GE_PoolDealloc(a0-a1,d0)
GE_PoolDealloc:
   movem.l a0-a3/d0-d3,-(sp)
   tst.l   d0
   beq.s   .pdae1$
   move.l  a0,d1
   beq.s   .pdae1$
   move.l  a1,d1
   beq.s   .pdae1$
;nothing null then proceed
   move.l  a0,a2
   move.l  mp_MemTree(a2),a0
   move.l  a1,a3
   lea     gehook2(pc),a1
   move.l  d0,d2
   move.l  a3,d0
   bsr.s   GE_AVLFind
   tst.l   d0
   beq.s   .pdae1$
   move.l  d0,a0
   move.l  an_Key(a0),a0
   move.l  a0,-(sp)
   move.l  a3,a1
   move.l  d2,d0
   CALLEXEC Deallocate
   move.l  (sp)+,a3
   add.l   d2,mp_MemFree(a2)
   move.l  MH_FREE(a3),d0
   cmp.l   mp_Size(a2),d0
   bne.s   .pdae1$
   move.w  mp_FreeChunks(a2),d0
   cmp.w   mp_ColapseNum(a2),d0
   bne.s   .pdat1$
   move.l  a3,d0
   move.l  mp_MemTree(a2),a0
   lea     gehook1(pc),a1
   bsr.s   GE_AVLRemove
   tst.b   d0
   beq.s   .pdae1$
   move.l  a3,a1
   CALLEXEC Remove
   move.l  MH_LOWER(a3),a1
   move.l  mp_Size(a2),d0
   jsr     _LVOFreeMem(a6)
   move.l  a3,a1
   move.l  #MH_SIZE,d0
   jsr     _LVOFreeMem(a6)
   move.l  mp_Size(a2),d0
   sub.l   d0,mp_MemTotal(a2)
   bra.s   .pdae1$
.pdat1$
   add.w   #1,mp_FreeChunks(a2)
.pdae1$
   movem.l (sp)+,a0-a3/d0-d3
   rts

;GE_FreeMemPool(a0)
GE_FreeMemPool:
   movem.l d0-d1/a1-a3,-(sp)
   move.l  a0,d0
   beq.s   fmpe1
   move.l  a0,a2
fmpb1:
   cmpa.l  LH_TAILPRED(a2),a2
   beq.s   fmpt1
   move.l  a2,a0
   REMTAIL
   tst.l   d0
   beq.s   fmpb1
   move.l  d0,a3
   move.l  mp_MemTree(a2),a0
   lea     gehook1(pc),a1
   bsr.s   GE_AVLRemove
   move.l  MH_LOWER(a3),a1
   move.l  mp_Size(a2),d0
   CALLEXEC FreeMem
   move.l  a3,a1
   move.l  #MH_SIZE,d0
   jsr     _LVOFreeMem(a6)
   bra.s   fmpb1
fmpt1:
   move.l  mp_MemTree(a2),a1
   move.l  #4,d0
   CALLEXEC FreeMem
   move.l  a2,a1
   move.l  #MP_SIZEOF,d0
   jsr     _LVOFreeMem(a6)
fmpe1:
   movem.l (sp)+,d0-d1/a1-a3
   rts

   ENDC