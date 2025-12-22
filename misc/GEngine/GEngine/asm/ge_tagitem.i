; ge_tagitem.i---------
; 27-12-2001  ---------
; ---------------------

   XDEF  GE_NextTagItem
   XDEF  GE_GetTagData

GE_NextTagItem:
   move.l a1,-(sp)
   tst.l  (a0)
   beq.s  .nte1
.ntb1  ;--->Begin loop 'til not a control tag or end of array
   move.l (a0),a1
   move.l ti_Tag(a1),d0
   beq.s  .nte1  ;--> end of array
   add.l  #ti_SIZEOF,(a0)
   and.l  #TAG_USER,d0
   bne.s  .nte3  ;--> USER tag
   move.l  ti_Tag(a1),d0
   cmp.l  #TAG_IGNORE,d0
   beq.s  .ntb1  ;--> Ignore this tag, go process next
   cmp.l  #TAG_SKIP,d0
   bne.s  .ntt1
   move.l ti_Data(a1),d0  ;--> Ignore this and next (ti_Data) items
   subq.l #1,d0
   mulu.w #ti_SIZEOF,d0
   add.l  d0,(a0)
   bra.s  .ntb1  ;--> process next
.ntt1
   cmp.l  #TAG_MORE,d0
   bne.s  .ntb1  ;--> invalid control tag, skip
   move.l ti_Data(a1),(a0)
   bra.s  .ntb1
;---------------Loop end
.nte3
   move.l a1,d0
   bra.s  .nte2
.nte1
   moveq  #0,d0
.nte2
   move.l (sp)+,a1
   rts

;GE_GetTagData(d0-d1/a0);
GE_GetTagData:
   movem.l  d1-d2/a0-a1,-(sp)
   move.l   d0,d2
   move.l   a0,-(sp)
;-----------While
   move.l   sp,a0
.gtdl1
   bsr.s    GE_NextTagItem
   tst.l    d0
   beq.s    .gtde1
   move.l   d0,a1
   cmp.l    ti_Tag(a1),d2
   bne.s    .gtdl1
   move.l   ti_Data(a1),d1
.gtde1
   move.l   (sp)+,a0
   move.l   d1,d0
   movem.l  (sp)+,d1-d2/a0-a1
   rts