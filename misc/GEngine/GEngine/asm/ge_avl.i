; AVL Trees functions for gengine.library (c)2001 by Pablo Roldán

   IFND  GEAVL_I
GEAVL_I SET 1


   incdir  "sys:devpac/gengine/"
   INCLUDE "gengine.i"

   XDEF   GE_AVLMin
   XDEF   GE_AVLMax
   XDEF   GE_AVLFind
   XDEF   GE_AVLRLeft
   XDEF   GE_AVLRRight
   XDEF   GE_AVLRLeftR
   XDEF   GE_AVLRRightL
   XDEF   GE_AVLInsert
   XDEF   GE_AVLRemove

; AVLNodePtr=GE_AVLMax(A0)
GE_AVLMax:
   move.l a0,-(sp)
   move.l  (a0),d0
   beq.s   .en11$   ;Pointer OK?
.l11$
   move.l  d0,a0
   tst.l   an_Right(a0)
   beq.s   .en11$   ;Max?
   move.l  an_Right(a0),d0
   bra.s   .l11
.en11$
   move.l (sp)+,a0
   rts

; AVLNodePtr=GE_AVLMin(A0)
GE_AVLMin:
   move.l a0,-(sp)
   move.l  (a0),d0
   beq.s   .en21$   ;Pointer OK?
.l21$
   move.l  d0,a0
   tst.l   an_Left(a0)
   beq.s   .en21$   ;Min?
   move.l  an_Left(a0),d0
   bra.s   .l21
.en21$
   move.l (sp)+,a0
   rts

; GE_AVLFind(Tree:^AVLNodePtr(a0); Key:Integer(d0); SHook:Address(a1):AVLNodePtr
GE_AVLFind:
   movem.l a0/d1,-(sp)
   move.l  (a0),d1
.b61$
   move.l  d1,a0
   beq.s   .en61$
   move.l  a1,d1
   bne.s   .t61$   ;There is hook?
   move.l  an_Key(a0),d1  ;No
   sub.l   d0,d1
   bra.s   .t62$
.t61$
   movem.l a0-a3/d0,-(sp) ;Yes
   movea.l a0,a2     ;nodo (object)
   movea.l a1,a0     ;Hook
   lea     (sp),a1   ;@Key (message)
   move.l  h_Entry(a0),a3
   jsr     (a3)
   move.l  d0,d1
   movem.l (sp)+,a0-a3/d0
.t62$
   bge.s   .t63$
   move.l  an_Right(a0),d1
   bra.s   .b61$
.t63$
   beq.s   .en61$
   move.l  an_Left(a0),d1
   bra.s   .b61$
.en61$
   move.l  a0,d0
   movem.l (sp)+,a0/d1
   rts

; GE_AVLRLeft(Parent(a0),Child(a1):AVLNodePtr):short;
GE_AVLRLeft:
   move.l  a2,-(sp)
   move.l  a0,d0
   beq.s   en31
   move.l  a1,d0
   beq.s   en31
; Rotate
   move.l  an_Left(a1),a2
   move.l  a0,an_Left(a1)
   move.l  a2,an_Right(a0)
   move.w   #-1,d0
   cmp.w   #2,an_Balance(a0)
   bne.s   reb2
   tst.w   an_Balance(a1)
   bne.s   reb3
reb1
   add.w   d0,an_Balance(a1)
   add.w   d0,an_Balance(a0)
   bra.s   ts30
reb3
   neg.w   d0
   cmp.w   an_Balance(a1),d0
   bne.s   .reb4
   neg.w   d0
   add.w   d0,an_Balance(a1)
   muls.w  #2,d0
   add.w   d0,an_Balance(a0)
   bra.s   ts30
.reb4
   neg.w   d0
   add.w   d0,an_Balance(a1)
   add.w   d0,an_Balance(a1)
   muls.w  #3,d0
   add.w   d0,an_Balance(a0)
   bra.s   ts30

reb2
   tst.w   an_Balance(a1)
   beq.s   .reb5
   cmp.w   an_Balance(a1),d0
   bne.s   .reb6
.reb5
   add.w   d0,an_Balance(a1)
   add.w   d0,an_Balance(a0)
   bra.s   ts30
.reb6
   muls.w  #2,d0
   add.w   d0,an_Balance(a1)
   add.w   d0,an_Balance(a0)

ts30
; Update parents in this sub-tree
   move.l  a2,d0
   beq.s   .ts31$
   move.l  a0,an_Parent(a2)
.ts31$
   move.l  an_Parent(a0),an_Parent(a1)
   move.l  a1,an_Parent(a0)
; Update parents
   move.l  an_Parent(a1),a2
   move.l  a2,d0
   beq.s   .en32$
   cmpa.l  an_Left(a2),a0
   bne.s   .ts32$
   move.l  a1,an_Left(a2)
   bra.s   .en32$
.ts32$
   move.l  a1,an_Right(a2)
.en32$
   move.w  an_Balance(a1),d0
en31
   move.l  (sp)+,a2
   rts

; GE_AVLRRight(Parent(a0),Child(a1):AVLNodePtr):short;
GE_AVLRRight:
   move.l  a2,-(sp)
   move.l  a0,d0
   beq.s   en31
   move.l  a1,d0
   beq.s   en31
; Rotate
   move.l  an_Right(a1),a2
   move.l  a0,an_Right(a1)
   move.l  a2,an_Left(a0)
   move.w  #1,d0
   cmp.w   #-2,an_Balance(a0)
   bne.s   reb2
   tst.w   an_Balance(a1)
   bne.s   reb3
   bra.s   reb1 ; The rest is already written in GE_AVLRLeft

; GE_AVLRLeftR(Parent(a0),Child(a1):AVLNodePtr):short;
GE_AVLRLeftR:
   movem.l a2-a3,-(sp)
   move.l  a0,d0
   beq.s   en41
   move.l  a1,d0
   beq.s   en41
   move.l  a0,a2
;   move.l  a1,a3
   move.l  a1,a0
   move.l  an_Right(a0),a1
   bsr.s   GE_AVLRLeft
   move.l  a2,a0
   move.l  an_Left(a0),a1
   bsr.s   GE_AVLRRight
; Rotate
;   move.l  an_Left(a1),a2
;   move.l  an_Left(a2),an_Right(a0)
;   move.l  an_Right(a2),an_Left(a1)
;   move.l  a0,an_Left(a2)
;   move.l  a1,an_Right(a2)
; Update this subtree parents
;   move.l  an_Parent(a0),an_Parent(a2)
;   move.l  a2,an_Parent(a0)
;   move.l  a2,an_Parent(a1)
;   move.l  an_Right(a0),d0
;   beq.s   .t41$
;   move.l  d0,a3
;   move.l  a0,an_Parent(a3)
.t41$
;   move.l  an_Left(a1),d0
;   beq.s   reb2
;   move.l  d0,a3
;   move.l  a1,an_Parent(a3)
; Update grand-parent link
;reb2
;   move.l  an_Parent(a2),d0
;   beq.s   .t43$
;   move.l  d0,a3
;   cmpa.l  an_Left(a3),a0
;   bne.s   .t44$
;   move.l  a2,an_Left(a3)
;   bra.s   .t43$
;.t44$
;   move.l  a2,an_Right(a3)
; Update balance
;.t43$
;   move.w  #0,an_Balance(a1)
;   move.w  an_Balance(a2),d0
;   neg.w   d0
;   bge.s   .t45$
;   move.w  #0,an_Balance(a2)
;   move.w  d0,an_Balance(a0)
;   bra.s   .en42$
;.t45$
;   beq.s   .t46$
;   move.w  d0,an_Balance(a2)
;.t46$
;   move.w  #0,an_Balance(a0)

;.en42$
;   move.w  an_Balance(a2),d0
en41
   movem.l (sp)+,a2-a3
   rts

; GE_AVLRRightL(Parent(a0),Child(a1):AVLNodePtr):short;
GE_AVLRRightL:
   movem.l a2-a3,-(sp)
   move.l  a0,d0
   beq.s   en41
   move.l  a1,d0
   beq.s   en41
   move.l  a0,a2
;   move.l  a1,a3
   move.l  a1,a0
   move.l  an_Left(a0),a1
   bsr.s   GE_AVLRRight
   move.l  a2,a0
   move.l  an_Right(a0),a1
   bsr.s   GE_AVLRLeft
   bra.s   en41
; Rotate
;   move.l  an_Right(a1),a2
;   move.l  an_Left(a2),an_Right(a1)
;   move.l  an_Right(a2),an_Left(a0)
;   move.l  a1,an_Left(a2)
;   move.l  a0,an_Right(a2)
; Update this subtree parents
;   move.l  an_Parent(a0),an_Parent(a2)
;   move.l  a2,an_Parent(a0)
;  move.l  a2,an_Parent(a1)
;  move.l  an_Left(a0),d0
;  beq.s   .t51$
;  move.l  d0,a3
;  move.l  a0,an_Parent(a3)
;.t51$
;   move.l  an_Right(a1),d0
;   beq.s   reb2
;   move.l  d0,a3
;   move.l  a1,an_Parent(a3)
; Update grand-parent link
;   bra.s   reb2 ; The rest is already written in GE_AVLRLeftR

;GE_AVLInsert(Tree:^AVLNodePtr(a0); Key:Integer(d0); IHook:Address(a1)):AVLNodePtr
GE_AVLInsert:
   movem.l a0-a3/d1-d2,-(sp)
   move.l  d0,d2
   moveq   #AN_SIZE,d0
   move.l  #MEMF_CLEAR|MEMF_PUBLIC,d1
   CALLEXEC AllocMem
   tst.l   d0
   beq.s   .en71$
   move.l  d0,a2
   move.l  d2,an_Key(a2)
   move.w  #0,an_Balance(a2)
   move.l  #0,an_Left(a2)
   move.l  #0,an_Right(a2)
   movea.l 8(sp),a0
   move.l  a0,d0
   beq.s   .en72$
   move.l  (a0),d0
   beq.s   .en72$
   move.l  d2,d0
   move.l  12(sp),a1
   bsr.s   GE_AVLFind  ;Find first ocurrance
   tst.l   d0
   bne.s   .t71$
   move.l  (a0),a3
   bra.s   .t72$
.t71$
   move.l  d0,a3
.t72$
   sf      d1    ;d1 acts like GoR
; find free space
.b71$
   move.l  a3,a0
   move.l  a1,d0
   beq.s   .nh71$
   movem.l a0-a3/d2,-(sp)
   movea.l a3,a2     ;nodo (object)
   movea.l a1,a0     ;Hook
   lea     (sp),a1   ;@Key (message)
   move.l  h_Entry(a0),a3
   jsr     (a3)
   movem.l (sp)+,a0-a3/d2
   tst.l   d0
   bra.s   .nh72$
.nh71$
   move.l  an_Key(a3),d0
   sub.l   d2,d0
.nh72$
   bge.s   .t73$
   st      d1
   move.l  an_Right(a3),a3
   bra.s   .tb71$
.t73$
   beq.s   .t74$
   sf      d1
   move.l  an_Left(a3),a3
   bra.s   .tb71$
.t74$
   move.w  an_Balance(a3),d0
   bge.s   .t75$
   st      d1
   move.l  an_Right(a3),a3
   bra.s   .tb71$
.t75$
   sf      d1
   move.l  an_Left(a3),a3
.tb71$
   move.l  a3,d0
   bne.s   .b71$
; Insert node
   move.l  a0,an_Parent(a2)
   tst.b   d1
   beq.s   .t76$
   move.l  a2,an_Right(a0)
   addi.w  #1,an_Balance(a0)
   bra.s   .b72$
.t76$
   move.l  a2,an_Left(a0)
   subi.w  #1,an_Balance(a0)
.b72$
   move.w  an_Balance(a0),d0
   bpl.s   .t77$
   neg.w   d0
.t77$
   cmpi.w  #1,d0
   bne.s   .t78$
   move.l  an_Parent(a0),d0
   beq.s   .en72$
   move.l  d0,a1
   cmpa.l  an_Left(a1),a0
   beq.s   .t79$
   addi.w  #1,an_Balance(a1)
   bra.s   .t710$
.t79$
   subi.w  #1,an_Balance(a1)
.t710$
   move.l  a1,a0
   move.l  a0,d0
   beq.s   .en72$
   bra.s   .b72$
.t78$
   cmpi.w  #1,an_Balance(a0)
   ble.s   .t711$
   move.l  an_Right(a0),a1
   move.w  an_Balance(a1),d0
   ;exg     a0,a1
   bge.s   .t712$
   bsr.s   GE_AVLRRightL
;.r71$
;  move.l  an_Parent(a1),a1
.r72$
   move.l  an_Parent(a1),d0
   bne.s   .en72$
   move.l  8(sp),a0
   move.l  a1,(a0) ;refreshing root
   bra.s   .en72$
.t712$
   bsr.s   GE_AVLRLeft
   bra.s   .r72$

.t711$
   cmpi.w  #-1,an_Balance(a0)
   bge.s   .en72$
   move.l  an_Left(a0),a1
   move.w  an_Balance(a1),d0
   ;exg     a0,a1
   ble.s   .t713$
   bsr.s   GE_AVLRLeftR
   bra.s   .r72$
.t713$
   bsr.s   GE_AVLRRight
   bra.s   .r72$
.en72$
   move.l  a2,d0
.en71$
   movem.l (sp)+,a0-a3/d1-d2
   rts

; GE_AVLRemove(Tree:^AVLNodePtr(a0); Key:Integer(d0); RHook:Address(a1)):Boolean
GE_AVLRemove:
   link    a5,#-4
   move.l  a0,-4(a5)
   bsr.s   GE_AVLFind
   tst.l   d0
   beq.s   .en81$
   movem.l a2-a4/d1,-(sp); a0=t2/Tree, a1=Ret, a2=tt, a3=tmp/t2, a4=t1
   move.l  d0,a1
   move.l  a1,a2
.b81$
   tst.l   an_Left(a2)
   beq.s   .t81$
   tst.l   an_Right(a2)
   beq.s   .t81$
;node is a (sub)tree
   move.l  an_Right(a2),-(sp)
   lea     (sp),a0
   bsr.s   GE_AVLMin
   lea     4(sp),sp ;
   move.l  d0,a0
;replace node with next in order
   move.l  an_Key(a0),an_Key(a2)
   move.l  a0,a2
   move.l  a0,a1
   bra.s   .t87 ;Now remove next in order
;   move.w  an_Balance(a0),an_Balance(a3)
;replace t2 with tmp
;   move.l  an_Parent(a0),a4
;   cmp.l   an_Left(a4),a0
;   bne.s   .t82$
;   move.l   a3,an_Left(a4)
;   bra.s   .t83$
;.t82$
;   move.l   a3,an_Right(a4)
;replace tt with t2
;.t83$
;   move.l   an_Parent(a2),an_Parent(a0)
;   move.l   an_Left(a2),an_Parent(a0)
;   move.l   an_Right(a2),an_Right(a0)
;   move.w   an_Balance(a2),an_Balance(a0)
;   move.l   an_Parent(a2),d0
;  beq.s    .t84$
;   move.l   d0,a4
;   cmp.l    an_Right(a4),a2
;   bne.s    .t85$
;   move.l   a0,an_Right(a4)
;   bra.s    .t86$
;.t85$
;   move.l   a0,an_Left(a4)
;   bra.s    .t86$
;.t84$
;   move.l   a0,a4
;   move.l   -(AN_SIZE+4)(a5),a0  ;a0 -> Tree
;   move.l   a4,(a0)  ;Refresh Tree root
;.t86$
;   move.l   -(AN_SIZE+4)(a5),a0  ;a0 -> Tree
;   move.l   a3,a2
;   bra.s    .b81$

.t81$
   move.l  an_Left(a2),d0
   move.l  an_Right(a2),d1
   cmp.l   d0,d1   ;equals iff both null
   beq.s   .t87$
;node is a branch
   move.l  an_Left(a2),d0
   bne.s   .t88$
   move.l  an_Right(a2),d0
.t88$
   move.l  d0,a4
   move.l  an_Parent(a2),d0
   move.l  d0,a3
   beq.s   .t89$
   cmp.l   an_Left(a3),a2
   bne.s   .t810$
   move.l  a4,an_Left(a3)
   addi.w  #1,an_Balance(a3)
   bra.s   .t811$
.t810$
   move.l  a4,an_Right(a3)
   subi.w  #1,an_Balance(a3)
   bra.s   .t811$
.t89$
   move.l  a4,(a0)
.t811$
   move.l  a3,a2
   move.l  a3,an_Parent(a4)
   bra.s   .t823$
.t87$
;node is a leaf
   move.l  an_Parent(a2),d0
   beq.s   .t813$
   move.l  d0,a4
   cmp.l   an_Left(a4),a2
   bne.s   .t814$
   clr.l   an_Left(a4)
   addi.w  #1,an_Balance(a4)
   bra.s   .t813$
.t814$
   clr.l   an_Right(a4)
   subi.w  #1,an_Balance(a4)
.t813$
   move.l  a4,a2

.t823$
;Now rebalance
   move.l  -4(a5),a0
   move.l  a2,d0
   beq.s   .en82$
.b82
   move.w  an_Balance(a2),d0
   cmpi.w  #1,d0
   ble.s   .t815$
   move.l  an_Right(a2),a4
   tst.w   an_Balance(a4)
   bge.s   .t816$
   exg     a0,a2
   exg     a1,a4
   bsr.s   GE_AVLRRightL
   exg     a0,a2
   exg     a1,a4
   cmpa.l  (a0),a2
   bne.s   .rf1
   move.l  an_Parent(a2),(a0)
.rf1
   tst.w   d0
   bne.s   .en82$
   move.l  an_Left(a4),a2
   bra.s   .t817$
.t816$
   exg     a0,a2
   exg     a1,a4
   bsr.s   GE_AVLRLeft
   exg     a0,a2
   exg     a1,a4
   cmpa.l  (a0),a2
   bne.s   .rf2
   move.l  an_Parent(a2),(a0)
.rf2
   tst.w   d0
   bne.s   .en82$
   move.l  a4,a2
   bra.s   .t817$

.t815$
   move.w  an_Balance(a2),d0
   cmpi.w  #-1,d0
   bge.s   .t818$
   move.l  an_Left(a2),a4
   tst.w   an_Balance(a4)
   ble.s   .t819$
   exg     a0,a2
   exg     a1,a4
   bsr.s   GE_AVLRLeftR
   exg     a0,a2
   exg     a1,a4
   cmpa.l  (a0),a2
   bne.s   .rf3
   move.l  an_Parent(a2),(a0)
.rf3
   tst.w    d0
   bne.s   .en82$
   move.l  an_Right(a4),a2
   bra.s   .t817$
.t819$
   exg     a0,a2
   exg     a1,a4
   bsr.s   GE_AVLRRight
   exg     a0,a2
   exg     a1,a4
   cmpa.l  (a0),a2
   bne.s   .rf4
   move.l  an_Parent(a2),(a0)
.rf4
   tst.w    d0
   bne.s   .en82$
   move.l  a4,a2
   bra.s   .t817$

.t818$
   move.w  an_Balance(a2),d0
   bpl.s   .t820$
   neg.w    d0
.t820$
   cmpi.w  #1,d0
   bne.s   .t817
   bra.s   .en82$ ;Tree depth no changed
;Tree shortened or after rotation-> check upper levels
.t817$
   move.l  an_Parent(a2),d0
   beq.s   .t821$
   move.l  d0,a4
   cmp.l   an_Right(a4),a2
   bne.s   .t822$
   subi.w  #1,an_Balance(a4)
   move.l  a4,a2
   bra.s   .b82$
.t822$
   addi.w  #1,an_Balance(a4)
   move.l  a4,a2
   bra.s   .b82$
.t821$
   cmp.l   (a0),a2
   beq.s   .en82$
   move.l  a2,(a0)
.en82$
   move.l  -4(a5),a0
   cmpa.l  (a0),a1
   bne.s   .en83$
   clr.l   (a0)
.en83$
   move.l  #AN_SIZE,d0
   CALLEXEC FreeMem
   st      d0
   move.l  -4(a5),a0
   movem.l (sp)+,a2-a4/d1
.en81$
   unlk    a5
   rts
  ENDC