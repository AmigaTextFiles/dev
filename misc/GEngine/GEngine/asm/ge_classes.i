; Class creation functions

   XDEF geshook1
   XDEF geshook2
   XDEF GE_MakeClass
   XDEF GE_FreeClass
   XDEF GE_AddClass
   XDEF GE_RemoveClass
   XDEF GE_IsObject
   XDEF _GRoot

GEROOTNAME: dc.b 'gerootclass',0

geshook1:
   dc.l  0,0
   dc.l  Stest1
   dc.l  0,0

geshook2:
   dc.l  0,0
   dc.l  Stest2
   dc.l  0,0

Stest1:
     movem.l a1-a2/d1,-(sp)
     move.l  an_Key(a2),a2
     move.l  gc_ID(a2),a2
     move.l  (a1),a1
s1   move.b  (a2)+,d0
     beq.s   .se1
     cmp.b   #'A',d0
     blo.s   .s1a
     cmp.b   #'Z',d0
     bhi.s   .s1a
     add.b   #32,d0
.s1a move.b  (a1)+,d1
     beq.s   .se2
     cmp.b   #'A',d1
     blo.s   .s1b
     cmp.b   #'Z',d1
     bhi.s   .s1b
     add.b   #32,d1
.s1b sub.b   d1,d0
     beq.s   s1
.s1c ext.w   d0
     ext.l   d0
.s2  movem.l (sp)+,a1-a2/d1
     rts
.se1 tst.b   (a1)+
     beq.s   .s1c
     moveq   #-1,d0
     bra.s   .s2
.se2 moveq   #1,d0
     bra.s   .s2

Stest2:
     movem.l a1-a2/d1,-(sp)
     move.l  an_Key(a2),a2
     move.l  gc_ID(a2),a2
     move.l  (a1),a1
     move.l  gc_ID(a1),a1
     bra.s   s1

;------------------------------
; GE_MakeClass(A0-A2/D0-D1):D0
;------------------------------
GE_MakeClass:
     movem.l  a0-a3/a6/d1-d2,-(sp)
     move.w   d0,d2
     move.l   #GC_SIZE,d0
     move.l   #MEMF_CLEAR+MEMF_PUBLIC,d1
     CALLEXEC AllocMem
     tst.l    d0
     beq.s    .mce1
     move.l   d0,a3
     move.w   d2,gc_InstSize(a3)
     moveq    #0,d0
     move.w   d0,gc_InstOffset(a3)
     move.l   d0,gc_Reserved(a3)
     move.l   8(sp),gc_ID(a3)
     beq.s    .mct1
     move.l   #GCF_INLIST,d0  ;will be a public class
.mct1
     move.l   d0,gc_Flags(a3)
     move.l   16(sp),a2   ;superclass
     move.l   a2,d0
     bne.s    .mct2
     move.l   12(sp),d0   ;superclassID
     beq.s    .mct2
     move.l   24(sp),a0   ;genginebase
     lea      eb_ClassTree(a0),a0
     lea      geshook1(pc),a1
     bsr      GE_AVLFind       ;find this ID corresponding GE_Class struct
     tst.l    d0
     beq.s    .mct2
     move.l   d0,a2
     move.l   an_Key(a2),a2
.mct2
     move.l   a2,gc_Super(a3)
     move.l   a2,d0
     beq.s    .mce2
     move.w   gc_InstSize(a2),d0
     move.w   gc_InstOffset(a2),gc_InstOffset(a3)
     add.w    d0,gc_InstOffset(a3)
     add.l    #1,gc_SubclassCount(a2)  ;increment subclass count on superclass
.mce2
     move.l   a3,d0
.mce1
     movem.l  (sp)+,a0-a3/a6/d1-d2
     rts

;--------------------
;GE_FreeClass(a0):D0
;--------------------
GE_FreeClass:
     movem.l  a1/d1,-(sp)
     move.l   a0,d1
     beq.s    .fce1
     tst.l    gc_ObjectCount(a0)
     bne.s    .fce1
     tst.l    gc_SubclassCount(a0)
     bne.s    .fce1
     tst.l    gc_Super(a0)
     beq.s    .fct1
     move.l   gc_Super(a0),a1
     sub.l    #1,gc_SubclassCount(a1) ;decrement subclass count on superclass
.fct1
     move.l   #GC_SIZE,d0
     move.l   a0,a1
     CALLEXEC FreeMem
     st       d0
     bra.s    .fce2
.fce1
     sf       d0
.fce2
     movem.l  (sp)+,a1/d1
     rts


;----------------
;GE_AddClass(A0)
;----------------
GE_AddClass:
     movem.l  a0-a1/d0,-(sp)
     move.l   a0,d0
     beq.s    .ace1
     tst.l    gc_ID(a0)  ;It has a name?
     beq.s    .ace1
     lea      geshook2(pc),a1
     tst.l    eb_ClassTree(a6) ;test if ClassTree already initialized
     beq.s    .act1
     lea      eb_ClassTree(a6),a0
     bsr.s    GE_AVLInsert
     bra.s    .ace1
.act1
     move.l   #0,a0
     move.l   a6,-(sp)
     bsr.s    GE_AVLInsert
     move.l   (sp)+,a6
     move.l   d0,eb_ClassTree(a6)
.ace1
     movem.l  (sp)+,a0-a1/d0
     rts

;------------------
;GE_RemoveClass(a0)
;------------------
GE_RemoveClass:
     movem.l  a0-a1/d0,-(sp)
     move.l   a0,d0
     beq.s    .rce1
     lea      eb_ClassTree(a6),a0
     lea      geshook2(pc),a1
     bsr.s    GE_AVLRemove
.rce1
     movem.l  (sp)+,a0-a1/d0
     rts

;----------------
;GE_IsObject(a0)
;----------------
GE_IsObject:
   movem.l a1-a3,-(sp)
   move.l  eb_ObjPool(a6),a2
   move.l  a0,a3
   move.l  mp_MemTree(a2),a0
   lea     gehook2(pc),a1
   move.l  d0,d2
   move.l  a3,d0
   bsr.s   GE_AVLFind
   move.l  a3,a0
   tst.l   d0
   beq.s   .ioe1
   st      d0
.ioe1
   movem.l (sp)+,a1-a3
   rts

;---------------
; RootClass dispatcher
;---------------
_GRoot:
     move.l   a1,d0
     beq.s    .gre1  ;Msg=Nil?
     move.l   a2,d0
     beq.s    .gre1  ;Obj=Nil?
     movem.l  a0-a2/d1,-(sp)
     move.l   (a1),d0
     cmpi.l   #GM_NEW,d0
     bne.s    .grt1
     ;----NEW Object
     clr.l    d0
     cmpa.l   a0,a2
     beq.s    .gre2
     move.w   gc_InstOffset(a2),d0
     add.w    gc_InstSize(a2),d0
     move.l   _MYLIB(pc),a0
     move.l   eb_ObjPool(a0),a0
     bsr.s    GE_PoolAlloc
     tst.l    d0
     beq.s    .gre2
     move.l   d0,a0
     move.l   a2,go_Class(a0)
     addi.l   #1,gc_ObjectCount(a2)
     bra.s    .gre2
.grt1
     cmpi.l   #GM_DISPOSE,d0
     bne.s    .grt2
     move.l   go_Class(a2),a0
     clr.l    d0  
     move.w   gc_InstOffset(a0),d0
     add.w    gc_InstSize(a0),d0
     subi.l   #1,gc_ObjectCount(a0)
     move.l   _MYLIB(pc),a0
     move.l   eb_ObjPool(a0),a0
     move.l   a2,a1
     bsr.s    GE_PoolDealloc
     clr.l    d0
     bra.s    .gre2
.grt2
     clr.l    d0

.gre2
     movem.l  (sp)+,a0-a2/d1
.gre1
     rts