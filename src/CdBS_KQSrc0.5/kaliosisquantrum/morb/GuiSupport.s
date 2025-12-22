*
* CdBSian Obviously Universal & Interactive Nonsense (COUIN)
* (Absurdité CdBSienne Manifestement Universelle et Interactive)
* ©1997-1998, CdBS Software (MORB)
* Misc support routines for gui based things
* $Id: GuiSupport.s 0.6 1997/11/05 19:54:12 MORB Exp MORB $
*

;fs "_OutOfMemory"
_OutOfMemory:
	 lea       OOMTitle(pc),a0
	 lea       OOMBody(pc),a1
	 lea       OOMBut(pc),a2
	 sub.l     a3,a3
	 sub.l     a4,a4
	 bra       _Request

OOMTitle:
	 dc.b      "Don't panic -- This is a critical situation",0
OOMBody:
	 dc.b      "Ran out of memory",$a,$a
	 dc.b      "Try to iconify COUIN and to close things",$a
	 dc.b      "in order to save some memory, or to buy fast ram,",$a
	 dc.b      "or to pray, or to kill yourself, or to blow the monitor",$a
	 dc.b      "by hitting it with your head, or to cry, or to eat your",$a
	 dc.b      "mouse, or to break an egg, or to fly, or to throw",$a
	 dc.b      "yourself into a wall, or to put green dwarves into your",$a
	 dc.b      "garden, or to build a cathedral, or to slaughter a dog, or",$a
	 dc.b      "to do all of this at the same time. Grûûûûuûuuuuuûûûûûûûûnt.",0
OOMBut:
	 dc.b      "OK, I will try.",0
	 even
;fe

;fs "_FileRequest"
FRBufferSize       = 512

FRHook:
	 ds.l      1
FRCurrent:
	 ds.l      1
FRLastGui:
	 ds.l      1
FRList:
	 ds.l      3
FRLock:
	 ds.l      1
FRMemPool:
	 ds.l      1
FRExallFlag:
	 ds.l      1
FRReadDir:
	 ds.l      1
	 even

_FileRequest:      ; a2=FileReq a1=Hook
	 move.l    _CurrentGui,FRLastGui
	 move.l    a1,FRHook
	 move.l    a2,FRCurrent
	 move.l    (a2),FRTitle+ge_Data

	 lea       FRList(pc),a0
	 NEWLIST   a0

	 clr.l     FRExallFlag

	 lea       CustomBase,a6

	 lea       FRGui(pc),a0
	 bsr       _ChangeGui

	 lea       FRHandler(pc),a0
	 move.l    a0,_PreHandler

	 move.l    (AbsExecBase).w,a6
	 move.l    _SStack,d0
	 CALL      UserState

	 bsr.s     FRBreak

	 lea       fr_Path(a2),a0
	 lea       _StrBuf,a1
.StrCpy:
	 move.b    (a0)+,(a1)+
	 bne.s     .StrCpy

	 bsr.s     FRSelectDir

	 move.l    (AbsExecBase).w,a6
	 CALL      SuperState
	 move.l    d0,_SStack
	 lea       CustomBase,a6

	 tst.l     d7
	 bne.s     .Done

	 lea       FRLv(pc),a0
	 bsr       _Layout
	 bsr       _Render

.Done:
	 rts
;fe

;fs "FROk"
FROk:
	 move.l    FRCurrent(pc),a2
	 lea       fr_Path(a2),a3
	 move.l    a3,a1
	 lea       _StrBuf,a0

.StrCpy:
	 move.b    (a0)+,(a1)+
	 bne.s     .StrCpy

	 move.l    (AbsExecBase).w,a6
	 move.l    _SStack,d0
	 CALL      UserState

	 move.l    Dos_Base,a6
	 move.l    a3,d1
	 move.l    #_NameBuffer,d2
	 move.l    #1024,d3
	 CALL      AddPart

	 move.l    (AbsExecBase).w,a6
	 moveq     #-1,d7
	 bra.s     FRExit
;fe
;fs "FRCancel"
FRCancel:
	 move.l    (AbsExecBase).w,a6
	 move.l    _SStack,d0
	 CALL      UserState
	 moveq     #0,d7
;fe
;fs "FRExit"
FRExit:
	 clr.l     _PreHandler
	 clr.l     FRReadDir

	 move.l    FRMemPool,a0
	 CALL      DeletePool
	 clr.l     FRMemPool

	 bsr.s     FRBreak

	 move.l    (AbsExecBase).w,a6
	 CALL      SuperState
	 move.l    d0,_SStack
	 lea       CustomBase,a6

	 move.l    FRLastGui(pc),a0
	 bsr       _ChangeGui

	 move.l    FRHook(pc),d0
	 beq.s     .Done

	 move.l    d0,a1
	 move.l    d7,d0
	 move.l    FRCurrent(pc),a0
	 jmp       (a1)

.Done:
	 rts
;fe

;fs "FRBreak"
FRBreak:
	 move.l    Dos_Base,a6
	 tst.l     FRExallFlag
	 beq.s     .Gzlonkrunk

	 move.l    FRLock(pc),d1
	 move.l    #_FRBuffer,d2
	 move.l    #FRBufferSize,d3
	 moveq     #ED_COMMENT,d4
	 move.l    FRExallCtrl,d5
	 CALL      ExAllEnd

.Gzlonkrunk:
	 move.l    FRExallCtrl(pc),a0
	 clr.l     eac_LastKey(a0)

	 move.l    FRLock(pc),d1
	 CALL      UnLock
	 clr.l     FRLock
	 rts
;fe
;fs "FRHandler"
FRHandler:
	 tst.l     FRExallFlag
	 bne.s     .Continue
	 tst.l     FRReadDir
	 bne.s     .Continue
.Done:
	 rts

.Continue:
	 move.l    FRLock(pc),d7
	 beq.s     .Done

	 move.l    (AbsExecBase).w,a6
	 move.l    _SStack,d0
	 CALL      UserState

	 move.l    Dos_Base,a6
	 move.l    d7,d1
	 move.l    #_FRBuffer,d2
	 move.l    #FRBufferSize,d3
	 moveq     #ED_COMMENT,d4
	 move.l    FRExallCtrl,d5
	 CALL      ExAll
	 move.l    d0,FRExallFlag

	 move.l    (AbsExecBase).w,a6

	 move.l    FRExallCtrl(pc),a3
	 move.l    eac_Entries(a3),d7
	 beq.s     .NoEntries
	 subq.l    #1,d7

	 lea       _FRBuffer,a2

.Loop:
	 move.l    FRMemPool(pc),a0
	 move.l    #lve_Size+4+32+80,d0
	 CALL      AllocPooled
	 tst.l     d0
	 beq.s     _OutOfMemory
	 move.l    d0,a1
	 lea       lve_Size+4(a1),a0
	 move.l    a0,lve_String(a1)

	 move.l    ed_Name(a2),a3
.StrCpy:
	 move.b    (a3)+,(a0)+
	 bne.s     .StrCpy

	 move.l    a1,a3
	 lea       FRList(pc),a0
	 tst.l     ed_Type(a2)
	 bmi.s     .File
	 CALL      AddHead
	 moveq     #2,d0
	 bra.s     .Dir
.File:
	 CALL      AddTail
	 moveq     #1,d0
.Dir:
	 move.l    d0,lve_Color(a3)

	 move.l    (a2),a2
	 dbf       d7,.Loop

	 CALL      SuperState
	 move.l    d0,_SStack
	 lea       CustomBase,a6
	 lea       FRLv(pc),a0
	 bsr       _Layout
	 bsr       _Render
	 ;move.l    _SStack,d0
	 ;CALL      UserState
	 rts

.NoEntries:
	 CALL      SuperState
	 move.l    d0,_SStack
	 lea       CustomBase,a6

	 rts
;fe

;fs "FRParent"
FRParent:
	 sf        FRReadDir

	 lea       FRList(pc),a0
	 NEWLIST   a0

	 lea       FRLv(pc),a0
	 clr.l     ge_Data3(a0)
	 bsr       _RefreshGuiEntry

	 move.l    (AbsExecBase).w,a6
	 move.l    _SStack,d0
	 CALL      UserState

	 move.l    Dos_Base,a6
	 move.l    #_StrBuf,d1
	 move.w    #"/\0",-(a7)
	 move.l    a7,d2
	 move.l    #1024,d3
	 CALL      AddPart
	 addq.l    #2,a7

	 bsr.s     FRBreak

	 bsr.s     FRSelectDir

	 move.l    (AbsExecBase).w,a6
	 CALL      SuperState
	 move.l    d0,_SStack
	 lea       CustomBase,a6

	 tst.l     d7
	 bne.s     .Done

	 lea       FRLv(pc),a0
	 bsr       _Layout
	 bsr       _Render

.Done:
	 rts
;fe
;fs "FRDirHook"
FRDirHook:
	 move.l    a0,a2

	 tst.l     FRLock
	 beq.s     .VolList

	 moveq     #2,d0
	 cmp.l     lve_Color(a2),d0
	 beq.s     .VolList

	 move.l    lve_String(a2),a1
	 lea       _NameBuffer,a3
.FileNameLoop:
	 move.b    (a1)+,(a3)+
	 bne.s     .FileNameLoop
	 rts

.VolList:
	 sf        FRReadDir

	 lea       FRList(pc),a0
	 NEWLIST   a0

	 lea       FRLv(pc),a0
	 clr.l     ge_Data3(a0)
	 bsr       _RefreshGuiEntry

	 move.l    (AbsExecBase).w,a6
	 move.l    _SStack,d0
	 CALL      UserState

	 move.l    Dos_Base,a6
	 move.l    #_StrBuf,d1
	 move.l    lve_String(a2),d2
	 move.l    #1024,d3
	 CALL      AddPart

	 bsr       FRBreak

	 bsr.s     FRSelectDir

	 move.l    (AbsExecBase).w,a6
	 CALL      SuperState
	 move.l    d0,_SStack
	 lea       CustomBase,a6

	 tst.l     d7
	 bne.s     .Done

	 lea       FRLv(pc),a0
	 bsr       _Layout
	 bsr       _Render

.Done:
	 rts
;fe
;fs "FRSelectDir"
FRSelectDir:
	 move.l    (AbsExecBase).w,a6

	 move.l    FRMemPool(pc),d0
	 beq.s     .Scrogneugneu
	 move.l    d0,a0
	 CALL      DeletePool
.Scrogneugneu:

	 moveq     #0,d0
	 move.l    #4096,d1
	 move.l    #512,d2
	 CALL      CreatePool
	 move.l    d0,FRMemPool
	 bne.s     .Rogntudju

	 CALL      SuperState
	 move.l    d0,_SStack

	 lea       CustomBase,a6
	 bra.s     _OutOfMemory

.Rogntudju:

	 move.l    Dos_Base,a6

	 move.l    #_StrBuf,d1
	 moveq     #ACCESS_READ,d2
	 CALL      Lock
	 move.l    d0,d7
	 beq.s     .SplitPath

	 move.l    d7,d1
	 move.l    FRFib,d2
	 CALL      Examine
	 tst.l     d0
	 beq.s     .UnLockAndSplit

	 move.l    FRFib,a0
	 tst.l     fib_EntryType(a0)
	 bpl.s     .DirOk

.UnLockAndSplit:
	 move.l    d7,d1
	 CALL      UnLock

.SplitPath:
	 move.l    #_StrBuf,d1
	 CALL      FilePart
	 move.l    d0,a0

	 lea       _NameBuffer,a1
.FileLoop:
	 move.b    (a0)+,(a1)+
	 bne.s     .FileLoop

	 move.l    #_StrBuf,d1
	 CALL      PathPart
	 move.l    d0,a0
	 clr.b     (a0)

	 move.l    #_StrBuf,d1
	 moveq     #ACCESS_READ,d2
	 CALL      Lock
	 move.l    d0,d7

.DirOk:
	 move.l    d7,FRLock
	 beq.s     FRDevList

	 sne       FRReadDir
	 moveq     #-1,d7
	 rts
;fe

;fs "FRVolumes"
FRVolumes:
	 sf        FRReadDir

	 lea       FRList(pc),a0
	 NEWLIST   a0

	 lea       FRLv(pc),a0
	 clr.l     ge_Data3(a0)
	 bsr       _RefreshGuiEntry

	 move.l    (AbsExecBase).w,a6
	 move.l    _SStack,d0
	 CALL      UserState

	 bsr.s     FRBreak

	 bsr.s     FRDevList

	 move.l    (AbsExecBase).w,a6
	 CALL      SuperState
	 move.l    d0,_SStack
	 lea       CustomBase,a6

	 lea       FRLv(pc),a0
	 bsr       _Layout
	 bsr       _Render
	 rts
;fe
;fs "FRDevList"
FRDevList:
	 move.l    (AbsExecBase).w,a6

	 move.l    FRMemPool(pc),d0
	 beq.s     .Scrogneugneu
	 move.l    d0,a0
	 CALL      DeletePool
.Scrogneugneu:

	 moveq     #0,d0
	 move.l    #4096,d1
	 move.l    #512,d2
	 CALL      CreatePool
	 move.l    d0,FRMemPool
	 bne.s     .Rogntudju

	 CALL      SuperState
	 move.l    d0,_SStack

	 lea       CustomBase,a6
	 bra.s     _OutOfMemory

.Rogntudju:

	 move.l    Dos_Base,a6
	 move.l    #LDF_VOLUMES|LDF_ASSIGNS|LDF_READ,d1
	 CALL      LockDosList
	 move.l    d0,d7

.Loop:
	 move.l    d7,d1
	 move.l    #LDF_VOLUMES|LDF_ASSIGNS|LDF_READ,d2
	 CALL      NextDosEntry
	 move.l    d0,d7
	 beq.s     .Done
	 move.l    d0,a5

	 move.l    (AbsExecBase).w,a6
	 move.l    FRMemPool(pc),a0
	 move.l    #lve_Size+4+130,d0
	 CALL      AllocPooled
	 tst.l     d0
	 beq.s     _OutOfMemory
	 move.l    d0,a1
	 lea       lve_Size+4(a1),a0
	 move.l    a0,lve_String(a1)

	 move.l    dol_Name(a5),a2
	 add.l     a2,a2
	 add.l     a2,a2
	 moveq     #0,d0
	 move.b    (a2)+,d0
	 subq.l    #1,d0

.StrCpy:
	 move.b    (a2)+,(a0)+
	 dbf       d0,.StrCpy
	 move.b    #":",(a0)+
	 clr.b     (a0)

	 move.l    a1,a3
	 lea       FRList(pc),a0
	 cmp.l     #DLT_VOLUME,dol_Type(a5)
	 beq.s     .Volume
	 CALL      AddTail
	 moveq     #2,d0
	 bra.s     .Assign
.Volume:
	 CALL      AddHead
	 moveq     #1,d0
.Assign:
	 move.l    d0,lve_Color(a3)

	 move.l    Dos_Base,a6
	 bra.s     .Loop

.Done:
	 move.l    #LDF_VOLUMES|LDF_ASSIGNS|LDF_READ,d1
	 CALL      UnLockDosList
	 moveq     #0,d7
	 rts
;fe

;fs "FRGui"
FRGui:
	 GENTRY    _VGroup,0,0

	 GENTRY    _HGroup,0,0
	 GENTRY    _SmallButton,"X",FRCancel
	 GENTRY    _SmallButton,"I",_Iconify
FRTitle:
	 GENTRY    _DragBar,0,0
	 GEND

FRLv:
	 GENTRY    _ListView,FRList,FRDirHook

	 GENTRY    _HGroup,0,0
	 GENTRY    _Button,FROkTxt,FROk
	 GENTRY    _Button,FRVolsTxt,FRVolumes
	 GENTRY    _Button,FRParentTxt,FRParent
	 GENTRY    _Button,FRCancelTxt,FRCancel
	 GEND

	 GEND

FROkTxt:
	 dc.b      "OK",0
FRVolsTxt:
	 dc.b      "Volumes",0
FRParentTxt:
	 dc.b      "Parent",0
FRCancelTxt:
	 dc.b      "Cancel",0
	 even
;fe
