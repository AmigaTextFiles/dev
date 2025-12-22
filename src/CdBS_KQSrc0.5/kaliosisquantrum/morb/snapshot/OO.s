*
* CdBSian Obviously Universal & Interactive Nonsense (COUIN)
* (Absurdité CdBSienne Manifestement Universelle et Interactive)
* ©1997-1998, CdBS Software (MORB)
* Object oriented support routines
* $Id: OO.s 0.10 1998/01/04 16:26:06 MORB Exp MORB $
*

_OOPool:
	 ds.l      1
_ObjectCollector:
	 ds.l      1

;fs "_OOInit"
_OOInit:
	 move.l    (AbsExecBase).w,a6
	 move.l    #MEMF_CLEAR,d0
	 move.l    #1024,d1
	 move.l    #512,d2
	 CALL      CreatePool
	 move.l    d0,_OOPool
	 beq.s     .Fail

	 lea       _RootClass,a0
	 sub.l     a1,a1
	 bsr       _NewObject
	 move.l    d0,_ObjectCollector
.Fail:
	 rts
;fe
;fs "_OOCleanUp"
_OOCleanUp:
	 move.l    _ObjectCollector,a0
	 bsr       _DisposeObject

	 move.l    _OOPool(pc),a0
	 beq.s     .Ok
	 move.l    (AbsExecBase).w,a6
	 CALL      DeletePool
.Ok:
	 rts
;fe

;fs "_InitClass"
_InitClass:        ; a0=Class
	 movem.l   a0/a3-a5,-(a7)

	 move.l    a0,a5
	 move.l    ci_SuperClass(a5),a0
	 tst.l     (a0)
	 bne.s     .SuperClassOk
	 bsr.s     _InitClass
.SuperClassOk:

	 move.l    ci_FuncTable(a5),a1
	 moveq     #0,d7
.CountFuncs:
	 tst.l     (a1)+
	 beq.s     .CFDone
	 addq.l    #6,d7
	 bra.s     .CountFuncs
.CFDone:

	 move.l    d7,d1
	 add.l     ci_JumpTable_Size(a0),d1
	 move.l    d1,ci_JumpTable_Size(a5)
	 move.l    d7,d0
	 addq.l    #4,d0
	 move.l    d0,d1
	 add.l     ci_BaseOffset(a0),d1
	 move.l    d1,ci_BaseOffset(a5)

	 move.l    ci_DataLength(a5),d1
	 move.l    d1,d2
	 add.l     ci_Data_Size(a0),d2
	 move.l    d2,ci_Data_Size(a5)

	 add.l     d1,d0
	 addq.l    #4,d0
	 add.l     ci_InstanceSize(a0),d0
	 move.l    d0,ci_InstanceSize(a5)
	 move.l    a0,a2

	 move.l    (AbsExecBase).w,a6
	 move.l    _OOPool(pc),a0
	 CALL      AllocPooled
	 move.l    d0,ci_ClassObj(a5)
	 beq.s     .Fail

	 move.l    ci_FuncTable(a5),a0
	 move.l    d0,a1
.MakeJumpTable:
	 move.l    (a0)+,d0
	 beq.s     .MJTDone
	 move.w    #$4ef9,(a1)+
	 move.l    d0,(a1)+
	 bra.s     .MakeJumpTable
.MJTDone:

	 move.l    ci_ClassObj(a2),a3
	 move.l    a3,a0
	 move.l    a1,a4
	 move.l    ci_JumpTable_Size(a2),d2
	 move.l    d2,d0
	 CALL      CopyMem

	 move.l    a4,d0
	 subq.l    #6,d0
	 sub.l     ci_ClassObj(a5),d0
	 add.l     d2,a3
	 add.l     d2,a4
	 move.l    d0,(a4)+

	 move.l    ci_Generation(a2),d2
	 move.l    d2,d0
	 addq.l    #1,d0
	 move.l    d0,ci_Generation(a5)

	 move.l    d2,d0
.CpyFuncTable:
	 move.l    (a3)+,d1
	 add.l     d7,d1
	 move.l    d1,(a4)+
	 dbf       d0,.CpyFuncTable

	 addq.l    #8,a4
	 move.l    a5,(a4)+

	 lea       12(a3),a3
	 addq.l    #8,d7
.CpyDataTable:
	 move.l    (a3)+,d1
	 add.l     d7,d1
	 move.l    d1,(a4)+
	 dbf       d2,.CpyDataTable

	 move.l    a4,d1
	 addq.l    #4,d1
	 sub.l     (a5),d1
	 move.l    ci_Data_Size(a2),d0
	 add.l     d0,d1
	 move.l    d1,(a4)+

	 move.l    a4,a1
	 add.l     d0,a4
	 move.l    a3,a0
	 CALL      CopyMem

	 move.l    a4,a1
	 move.l    ci_Datas(a5),a0
	 move.l    ci_DataLength(a5),d0
	 CALL      CopyMem

	 move.l    ci_InitCode(a5),d0
	 beq.s     .Fail
	 move.l    a5,a0
	 move.l    (a0),a1
	 move.l    a1,a2
	 add.l     ci_BaseOffset(a0),a2
	 move.l    d0,a5
	 jsr       (a5)

.Fail:
	 movem.l   (a7)+,a0/a3-a5
	 rts
;fe
;fs "_SetMethod"
_SetMethod:        ; d0=Method id a0=Class a1=NewFunc
	 movem.l   d2/a0-3,-(a7)

	 move.l    (a0),a2
	 move.l    a2,a3
	 add.l     ci_BaseOffset(a0),a3
	 add.l     -4(a3,d0.w),a2
	 swap      d0
	 addq.w    #2,d0
	 move.l    (a2,d0.w),d2
	 move.l    a1,(a2,d0.w)

	 move.l    (AbsExecBase).w,a6
	 CALL      CacheClearU
	 move.l    d2,d0

	 movem.l   (a7)+,d2/a0-3
	 rts
;fe

;fs "_NewObject"
_NewObject:        ; a0=Class a1=SetupCode a5=SetupData
	 movem.l   d2-3/d7/a2-4/a6,-(a7)

	 move.l    a0,a3
	 move.l    a1,a4

	 tst.l     (a0)
	 bne.s     .ClassOk
	 bsr.s     _InitClass
.ClassOk:

	 move.l    (AbsExecBase).w,a6
	 move.l    ci_InstanceSize(a3),d2
	 move.l    d2,d0
	 move.l    #MEMF_CLEAR,d1
	 CALL      AllocVec
	 move.l    d0,d7
	 beq.s     .Fail

	 move.l    d0,a2
	 move.l    (a3),a0
	 move.l    a2,a1
	 move.l    ci_JumpTable_Size(a3),d2
	 move.l    d2,d0
	 CALL      CopyMem
	 CALL      CacheClearU

	 add.l     d2,a2
	 move.l    (a3),a0
	 add.l     d2,a0
	 move.l    ci_Generation(a3),d3
	 move.l    d3,d0
.FuncTableLoop:
	 move.l    (a0)+,d1
	 add.l     d7,d1
	 move.l    d1,(a2)+
	 dbf       d0,.FuncTableLoop

	 addq.l    #8,a2
	 move.l    a3,(a2)+
	 lea       12(a0),a0

.DataTableLoop:
	 move.l    (a0)+,d1
	 add.l     d7,d1
	 move.l    d1,(a2)+
	 dbf       d3,.DataTableLoop

	 move.l    a2,a1
	 move.l    ci_Data_Size(a3),d0
	 CALL      CopyMem

	 move.l    d7,a2
	 add.l     ci_BaseOffset(a3),a2

	 move.l    a4,d0
	 beq.s     .NoInit
	 move.l    a2,a0
	 jsr       (a4)
.NoInit:

	 DOMTDI    MTD_New,a2
	 move.l    a2,d0

.Fail:
	 movem.l   (a7)+,d2-3/d7/a2-4/a6
	 rts
;fe
;fs "_DisposeObject"
_DisposeObject:    ; a0=Object
	 move.l    d0,d0
	 beq.s     .Ok
	 movem.l   a2/a6,-(a7)

	 move.l    a0,a2
	 DOMTDI    MTD_Dispose,a0

	 move.l    (AbsExecBase).w,a6
	 move.l    a2,a1
	 move.l    8(a1),a0
	 sub.l     ci_BaseOffset(a0),a1
	 CALL      FreeVec

	 movem.l   (a7)+,a2/a6
.Ok:
	 rts
;fe

;fs "_CreateObjectTree"
_CreateObjectTree: ; a0=ObjTree
	 movem.l   a2/a5-6,-(a7)

	 lea       4(a0),a5
	 sub.l     a6,a6
	 bsr.s     .ObjTree
	 tst.l     d0
	 beq.s     .Fail

.COTDone:
	 movem.l   (a7)+,a2/a5-6
	 rts

.Fail:
	 move.l    d0,a0
	 bsr.s     _DisposeObject
	 moveq     #0,d0
	 bra.s     .COTDone

.ObjTree:          ; a5=ObjTree a6=Parent
	 move.l    (a5)+,a0
	 lea       .ObjInit,a1
	 bsr.s     _NewObject
	 tst.l     d0
	 beq.s     .Ok

	 move.l    d0,a2
	 move.l    a6,d1
	 beq.s     .Loop
	 DOMTDI    MTD_AddMember,a6

.Loop:
	 move.l    (a5)+,d0
	 bne.s     .Done

	 movem.l   a2/a6,-(a7)
	 move.l    a2,a6
	 bsr.s     .ObjTree
	 movem.l   (a7)+,a2/a6
	 tst.l     d0
	 bne.s     .Loop

.Ok:
	 rts

.Done:
	 addq.l    #1,d0
	 beq.s     .DontStore
	 move.l    (a5)+,a0
	 move.l    a2,(a0)
.DontStore:

	 move.l    a2,d0
	 rts

.ObjInit:
	 move.l    a0,a1

.DatLoop:
	 move.l    (a5)+,d0
	 beq.s     .OIDone
	 cmp.l     #OBJ_End,d0
	 beq.s     .OIDone
	 cmp.l     #OBJ_Store,d0
	 beq.s     .OIDone

	 SDATAL    (a5)+,d0,a1
	 bra.s     .DatLoop

.OIDone:
	 subq.l    #4,a5
	 rts
;fe

;fs "RootClass"
_RootClass:
	 dc.l      RootClassObj
	 dc.l      0
	 dc.l      RootClassObjEnd-RootClassObj
	 dc.l      RootClassBase-RootClassObj
	 dc.l      RootClassBase-RootClassObj-4
	 dc.l      RootClassObjEnd-RootClassData
	 dc.l      0
	 dc.l      RootClassObjEnd-RootClassData
	 dc.l      0
	 dc.l      0
	 dc.l      0
	 dc.l      0

RootClassObj:
	 dc.w      $4ef9
	 dc.l      RCRemove
	 dc.w      $4ef9
	 dc.l      RCAdd
	 dc.w      $4ef9
	 dc.l      RCAddM
	 dc.w      $4ef9
	 dc.l      RCDispose
RCJmpTbl:
	 dc.w      $4ef9
	 dc.l      RCNew

	 dc.l      RCJmpTbl-RootClassObj
RootClassBase:
	 dc.l      0,0
	 dc.l      _RootClass
	 dc.l      RootClassData-RootClassObj
RootClassData:
	 ds.b      MLH_SIZE
	 dc.l      0
RootClassObjEnd:
	 even

RCNew:
	 LBLOCKEAI RootClass_ID,a0,a1
	 NEWLIST   a1
	 rts

RCDispose:
	 movem.l   d2/a2,-(a7)
	 move.l    a0,a2

	 LBLOCKEAI RootClass_ID,a0,a0
	 move.l    (a0),a0
.Loop:
	 move.l    (a0),d2
	 beq.s     .Done
	 bsr.s     _DisposeObject
	 move.l    d2,a0
	 bra.s     .Loop
.Done:

	 tst.l     (a2)
	 beq.s     .Ok
	 move.l    a2,a1
	 REMOVE
.Ok:

	 movem.l   (a7)+,d2/a2
	 rts

RCAddM:  ; a2=Object to add
	 LBLOCKEAI RootClass_ID,a2,a1
	 move.l    a0,root_DTA_Parent(a1)

	 move.l    a2,a1
	 LBLOCKEAI RootClass_ID,a0,a0
	 ADDTAIL
	 rts

RCAdd:   ; a2=Object to add to
	 LBLOCKEAI RootClass_ID,a0,a1
	 move.l    a2,root_DTA_Parent(a1)

	 move.l    a0,a1
	 LBLOCKEAI RootClass_ID,a2,a0
	 ADDTAIL
	 rts

RCRemove:
	 LBLOCKEAI RootClass_ID,a0,a1
	 clr.l     root_DTA_Parent(a1)

	 move.l    a0,a1
	 REMOVE
	 rts
;fe
