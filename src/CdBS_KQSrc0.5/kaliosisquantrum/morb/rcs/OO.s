head	0.11;
access;
symbols;
locks
	MORB:0.11; strict;
comment	@# @;


0.11
date	98.01.04.16.37.20;	author MORB;	state Exp;
branches;
next	0.10;

0.10
date	98.01.04.16.26.06;	author MORB;	state Exp;
branches;
next	0.9;

0.9
date	98.01.03.17.35.38;	author MORB;	state Exp;
branches;
next	0.8;

0.8
date	97.12.31.19.21.28;	author MORB;	state Exp;
branches;
next	0.7;

0.7
date	97.12.16.12.06.10;	author MORB;	state Exp;
branches;
next	0.6;

0.6
date	97.12.16.12.00.02;	author MORB;	state Exp;
branches;
next	0.5;

0.5
date	97.12.16.11.06.22;	author MORB;	state Exp;
branches;
next	0.4;

0.4
date	97.12.15.22.57.28;	author MORB;	state Exp;
branches;
next	0.3;

0.3
date	97.12.15.21.40.26;	author MORB;	state Exp;
branches;
next	0.2;

0.2
date	97.12.14.19.48.45;	author MORB;	state Exp;
branches;
next	0.1;

0.1
date	97.12.14.18.14.05;	author MORB;	state Exp;
branches;
next	0.0;

0.0
date	97.12.14.13.47.06;	author MORB;	state Exp;
branches;
next	;


desc
@@


0.11
log
@DisposeObject() tolere une valeur d'entree nulle
@
text
@*
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
@


0.10
log
@Correction d'un petit bug dans _OOInit
@
text
@d6 1
a6 1
* $Id: OO.s 0.9 1998/01/03 17:35:38 MORB Exp MORB $
d259 2
d273 1
@


0.9
log
@Ajout de l'attribut DTA_Parent dans rootclass
@
text
@d6 1
a6 1
* $Id: OO.s 0.8 1997/12/31 19:21:28 MORB Exp MORB $
d22 1
d28 1
@


0.8
log
@Plein de débuggage, ajout de CreateObjectTree(), etc.
@
text
@d4 1
a4 1
* ©1997, CdBS Software (MORB)
d6 1
a6 1
* $Id: OO.s 0.7 1997/12/16 12:06:10 MORB Exp MORB $
d382 1
d415 3
d424 3
d433 3
@


0.7
log
@Ptin j'avais encore oublié un truc
@
text
@d6 1
a6 1
* $Id: OO.s 0.6 1997/12/16 12:00:02 MORB Exp MORB $
d11 2
d22 5
d31 3
d44 1
a44 1
	 movem.l   a3-a5,-(a7)
d77 1
d162 1
a162 1
	 movem.l   (a7)+,a3-a5
d167 2
d170 3
a172 2
	 add.l     ci_BaseOffset(a0),a2
	 move.l    (a2,d0.w),a2
d181 2
d188 2
d248 1
a248 1
	 DOMETHODI MTD_New,a2
d252 1
d260 1
a260 1
	 DOMETHODI MTD_Dispose,a0
d272 75
d391 5
a395 2
	 LBLOCKEAI RootClass_ID,a0,a1
	 move.l    (a1),d0
d397 1
a397 2
	 move.l    d0,a1
	 move.l    (a1),d0
a398 2
	 move.l    d0,-(a7)
	 move.l    a1,a0
d400 1
a400 1
	 move.l    (a7)+,d0
d403 8
@


0.6
log
@Chnite modif dans InitClass
@
text
@d6 1
a6 1
* $Id: OO.s 0.5 1997/12/16 11:06:22 MORB Exp MORB $
d145 2
a148 1

@


0.5
log
@Nettoyage de deux trois trucs
@
text
@d6 1
a6 1
* $Id: OO.s 0.4 1997/12/15 22:57:28 MORB Exp MORB $
d144 1
a144 1
	 move.l    ci_ClassData(a0),a1
@


0.4
log
@Implémentation de MTD_Add, MTD_Remove, et MTD_AddMember dans RootClass
@
text
@d6 1
a6 1
* $Id: OO.s 0.3 1997/12/15 21:40:26 MORB Exp MORB $
d291 1
a291 1
	 LDATAEAI  RootClass_ID,a0,a1
d296 1
a296 1
	 LDATAEAI  RootClass_ID,a0,a1
d312 1
a312 1
	 LDATAEAI  RootClass_ID,a0,a0
d318 1
a318 1
	 LDATAEAI  RootClass_ID,a2,a0
@


0.3
log
@Tout plus bugs avoir
@
text
@d6 1
a6 1
* $Id: OO.s 0.2 1997/12/14 19:48:45 MORB Exp MORB $
d237 2
d247 2
d269 7
a275 1
	 dc.l      RCDummy
d278 1
a278 1
	 dc.l      RCDummy
d286 8
d295 26
a320 1
RootClassObjEnd:
d322 3
a324 1
RCDummy:
@


0.2
log
@Implémentation de SetMethod(), NewObject, DisposeObject et de la rootclass
@
text
@d6 1
a6 1
* $Id: OO.s 0.1 1997/12/14 18:14:05 MORB Exp MORB $
d34 1
a34 1
	 move.l    a5,-(a7)
d44 1
a44 1
	 moveq     #0,d0
d46 1
a46 1
	 tst.l     (a0)+
d48 1
a48 1
	 addq.l    #6,d0
d52 1
a52 1
	 move.l    d0,d1
d54 2
a55 1
	 move.l    ci_JumpTable_Size(a5)
d96 1
d108 3
a110 1
	 move.l    (a3)+,(a4)+
d113 2
a114 1
	 clr.l     (a4)+     ; RPL descriptor pointer (not used for now)
d116 2
a117 1
	 addq.l    #4,a3
d119 8
a126 3
	 move.l    (a3)+,(a4)+
	 dbf       d0,.CpyDataTable

d128 2
a129 1
	 move.l    d0,(a4)+
d150 1
a150 1
	 move.l    (a7)+,a5
d171 1
d173 5
a177 1
	 move.l    a0,a2
d180 1
a180 1
	 move.l    ci_InstanceSize(a2),d2
d184 1
a184 1
	 tst.l     d0
d187 4
a190 3
	 move.l    d0,a3
	 move.l    (a2),a0
	 move.l    a3,a1
d195 27
a221 1
	 add.l     ci_BaseOffset(a2),a3
d225 1
a225 1
	 move.l    a3,a0
d229 2
a230 2
	 DOMETHODI #MTD_New,a3
	 move.l    a3,d0
d238 1
a238 1
	 DOMETHODI #MTD_Dispose,a0
d242 2
d264 2
a265 1
	 jmp       RCDummy
d267 4
a270 2
	 jmp       RCDummy
	 dc.l      RCJmpTbl
d272 3
a274 2
	 dc.l      0
	 dc.l      RootClassData
@


0.1
log
@Ecriture de InitClass()
@
text
@d6 1
a6 1
* $Id: OO.s 0.0 1997/12/14 13:47:06 MORB Exp MORB $
d9 23
d71 2
a72 2
	 move.l    #MEMF_CLEAR,d1
	 CALL      AllocVec
d141 16
d158 37
a194 1
_NewObject:        ; a0=Class a1=Tags
d196 35
@


0.0
log
@Et hop... Gerflor
@
text
@d6 1
a6 1
* $Id$
d8 114
@
