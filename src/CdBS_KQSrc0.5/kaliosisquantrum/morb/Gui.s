*
* CdBSian Obviously Universal & Interactive Nonsense (COUIN)
* (AbsurditÈ CdBSienne Manifestement Universelle et Interactive)
* ©1997-1998, CdBS Software (MORB)
* Gui routines
* $Id: Gui.s 0.76 1998/05/05 01:15:39 MORB Exp MORB $
*

;fs "_InitGui"
_GuiBpMem:
	 ds.l      1
_GuiSelMem:
	 ds.l      1
_GuiBitmap:
	 ds.l      1
_GuiSelBitmap:
	 ds.l      1
_InitGui:
	 lea       _GuiBpPtrs,a0
	 move.l    _GuiBitmap(pc),d0
	 move.w    #bplpt,d1
	 moveq     #NbGuiPlanes-1,d2
.Loop:
	 swap      d0
	 move.w    d1,(a0)+
	 move.w    d0,(a0)+
	 addq.w    #2,d1
	 move.w    d1,(a0)+
	 swap      d0
	 move.w    d0,(a0)+
	 addq.w    #2,d1
	 add.l     #GuiBufferWidth,d0
	 dbf       d2,.Loop

	 lea       _GuiSelBpPtrs,a0
	 move.l    _GuiSelBitmap(pc),d0
	 move.l    d0,$8f00000
	 move.w    #bplpt,d1
	 moveq     #NbPlanes-1,d2
.Loop2:
	 swap      d0
	 move.w    d1,(a0)+
	 move.w    d0,(a0)+
	 addq.w    #2,d1
	 move.w    d1,(a0)+
	 swap      d0
	 move.w    d0,(a0)+
	 addq.w    #2,d1
	 add.l     #GuiSelBufferWidth,d0
	 dbf       d2,.Loop2

	 lea       StdMousePointer(pc),a0
	 bra.s     _SetMousePointer
;fe
;fs "Gui copper table"
CopLayer4:
	 dc.l      0,0
GuiP:
	 dc.w      $29+240,CET_BREAK
	 dc.l      _GuiCList
	 dc.l      _GuiCopTable

_GuiCopTable:
	 dc.l      GuiNml
_GuiL1Ptr:
	 dc.l      CopEnd,-1

GuiLayer1:
	 dc.l      0,0
GuiSelP:
	 dc.w      $29+240,CET_BREAK
	 dc.l      _GuiSelCList
	 dc.l      _GuiSelCopTable

_GuiSelCopTable:
	 dc.l      GuiSelNml
	 dc.l      CopEnd,-1

CopEnd:
	 dc.l      0,0
	 dc.w      $29+256,CET_BREAK
	 dc.l      0,0
;fe

;fs "_Request"
_ReqHook:
	 ds.l      1
_ReqLastGui:
	 ds.l      1
ReqGuiObj:
	 ds.l      1

_Request:          ; a0=Title a1=body a2=buttons a3=Hook a4=datastream
	 movem.l   d2/a2-6,-(a7)
	 move.l    a3,_ReqHook

	 move.l    a0,ReqTitle
	 move.l    a1,ReqBody
	 move.l    a4,ReqFDat
	 move.l    a2,a6

	 lea       ReqGui(pc),a0
	 bsr       _CreateObjectTree

	 move.l    d0,ReqGuiObj
	 move.l    _ObjectCollector,a0
	 move.l    d0,a2
	 DOMTDI    MTD_AddMember,a0

	 lea       _GuiTemp,a3
	 lea       _ButtonClass(pc),a4
	 lea       _ReqButHook(pc),a5
	 moveq     #1,d2

.BLoop:
	 move.l    a4,a0
	 sub.l     a1,a1
	 bsr       _NewObject
	 tst.l     d0
	 beq.s     .BDone

	 move.l    d0,a2
	 SDATALI   a3,BDTA_Label,a2
	 move.l    ReqButGrp,a0
	 DOMTDI    MTD_AddMember,a0

.CLoop:
	 move.b    (a6)+,d0
	 beq.s     .CDone
	 cmp.b     #"|",d0
	 beq.s     .CDone
	 move.b    d0,(a3)+
	 bra.s     .CLoop

.CDone:
	 clr.b     (a3)+
	 LBLOCKEAI GuiRootClass_ID,a2,a0
	 move.l    a5,guir_DTA_Hook(a0)

	 tst.b     d0
	 beq.s     .BDone

	 move.l    d2,guir_DTA_HookData(a0)
	 addq.l    #1,d2
	 bra.s     .BLoop

.BDone:
	 move.l    a3,_CtGuiTemp

	 clr.l     guir_DTA_HookData(a0)


	 move.l    ReqGuiObj,a2
	 DOMTDI    GM_Open,a2
	 tst.l     d0
	 bne.s     .ReqFail
.Fail:
	 movem.l   (a7)+,d2/a2-6
	 rts

.ReqFail:
	 move.l    d0,a4
	 DOMTDI    GM_Close,a2

	 lea       RQTitle(pc),a0
	 lea       RQBody(pc),a1
	 lea       RQBut(pc),a2
	 sub.l     a3,a3
	 bsr.s     _Request

	 moveq     #0,d0
	 bra.s     .Fail

RQTitle:
	 dc.b      "Request() failure",0
RQBody:
	 dc.b      "%s error :",$a
	 dc.b      "%s",0
RQBut:
	 dc.b      "OK",0
	 even

_ReqButHook:
	 movem.l   d2/a2,-(a7)

	 move.l    d0,d2

	 move.l    ReqGuiObj(pc),a2
	 DOMTDI    GM_Close,a2
	 move.l    a2,a0
	 bsr       _DisposeObject

	 move.l    d2,d0
	 move.l    _ReqHook,d1
	 beq.s     .Done

	 movem.l   (a7)+,d2/a2
	 move.l    d1,-(a7)
	 rts

.Done:
	 movem.l   (a7)+,d2/a2
	 rts

ReqButGrp:
	 ds.l      1

ReqGui:
	 GUI

	 VGROUP

	 HGROUP
	 SMALLBTN  "X",_ReqButHook,0
	 SMALLBTN  "I",_Iconify,0
	 dc.l      OBJ_Begin,_DragBarClass
	 dc.l      BDTA_Label
ReqTitle:
	 dc.l      0
	 ENDOBJ
	 ENDOBJ

	 dc.l      OBJ_Begin,_TextClass
	 dc.l      TDTA_Text
ReqBody:
	 dc.l      0
	 dc.l      TDTA_FData
ReqFDat:
	 dc.l      0
	 ENDOBJ

	 dc.l      OBJ_Begin,_HGroupClass
	 STOOBJ    ReqButGrp

	 ENDOBJ

	 ENDOBJ
;fe

;fs "_SetMousePointer"
_SetMousePointer:  ; a0=mptr
	 movem.w   (a0)+,d0-1
	 movem.w   d0-1,_MouseHotPointX
	 move.l    (a0),a0
	 move.l    a0,_MouseGardenDwarf
	 move.l    (a0),_GDwarfTable
	 rts

StdMousePointer:
	 dc.w      1,1
	 dc.l      StdMouseGDwarf
StdMouseGDwarf:
	 dc.l      _StdMouseGardenDwarfDat,0
	 dc.w      0,0,14

EDMousePointer:
	 dc.w      6,7
	 dc.l      EDMouseGDwarf
EDMouseGDwarf:
	 dc.l      _EDMouseGardenDwarfDat,0
	 dc.w      0,0,13

HKMousePointer:
	 dc.w      10,5
	 dc.l      HKMouseGDwarf
HKMouseGDwarf:
	 dc.l      _HKMouseGardenDwarfDat,0
	 dc.w      0,0,11

VKMousePointer:
	 dc.w      10,5
	 dc.l      VKMouseGDwarf
VKMouseGDwarf:
	 dc.l      _VKMouseGardenDwarfDat,0
	 dc.w      0,0,11
;fe
;fs "_HandleMouse"
_MouseHook:
	 dc.l      0
_HandleMouse:
	 move.l    Low_Base,a6
	 moveq     #0,d0
	 CALL      ReadJoyPort

	 btst      #JPB_BUTTON_RED,d0
	 sne       _LMBState
	 btst      #JPB_BUTTON_BLUE,d0
	 sne       _RMBState
	 btst      #JPB_BUTTON_PLAY,d0
	 sne       _MMBState

	 move.l    _MouseX(pc),d6
	 move.l    _MouseY(pc),d7

	 move.l    d0,d1
	 and.l     #JP_MHORZ_MASK,d1

	 lea       LastHMCount(pc),a0
	 move.w    (a0),d2
	 move.w    d1,(a0)
	 sub.b     d2,d1

	 extb.l    d1
	 add.l     d1,d6

	 and.l     #JP_MVERT_MASK,d0
	 lsr.l     #8,d0

	 lea       LastVMCount(pc),a0
	 move.w    (a0),d2
	 move.w    d0,(a0)
	 sub.b     d2,d0

	 extb.l    d0
	 asr.l     #1,d0
	 add.l     d0,d7

	 movem.l   _MinMouseX(pc),d0-3

	 cmp.l     d0,d6
	 bge.s     .XPos
	 move.l    d0,d6
.XPos:

	 cmp.l     d2,d6
	 ble.s     .XOk
	 move.l    d2,d6
.XOk:
	 move.l    d6,_MouseX

	 cmp.l     d1,d7
	 bge.s     .YPos
	 move.l    d1,d7
.YPos:

	 cmp.l     d3,d7
	 ble.s     .YOk
	 move.l    d3,d7
.YOk:
	 move.l    d7,_MouseY

	 sub.w     _MouseHotPointX,d6
	 add.w     d6,d6
	 sub.w     _MouseHotPointY,d7
	 subq.w    #HotPointY,d7

	 move.l    _MouseGardenDwarf(pc),a0
	 movem.w   d6-7,gdw_X(a0)
	 bsr       _RefreshGardenDwarf

	 move.l    _MouseHook(pc),d0
	 beq.s     .Done
	 move.l    d0,a0
	 jmp       (a0)
.Done:

	 rts
_MinMouseX:
	 dc.l      0
_MinMouseY:
	 dc.l      0
_MaxMouseX:
	 dc.l      GuiScreenWidth
_MaxMouseY:
	 dc.l      256
_MouseHotPointX:
	 ds.w      1
_MouseHotPointY:
	 ds.w      1
_MouseGardenDwarf:
	 ds.l      1
_MouseX:
	 dc.l      GuiScreenWidth
_MouseY:
	 dc.l      256
LastHMCount:
	 ds.w      1
LastVMCount:
	 ds.w      1
_LMBState:
	 dc.b      0
_RMBState:
	 dc.b      0
_MMBState:
	 dc.b      0
	 even
;fe
;fs "_HandleGui"
_CurrentGuiObject:
	 ds.l      1

_PlayfieldClickHandler:
	 ds.l      1
_PreHandler:
	 ds.l      1
_ActiveThingHandler:
	 ds.l      1
_ActiveGuiEntry:
	 ds.l      1
_OldMButtonState:
	 ds.b      1
	 even

_HandleGui:
	 move.l    _ActiveGuiObject(pc),d0
	 beq.s     .Hem
	 move.l    d0,a0
	 movem.l   _MouseX(pc),d0-1
	 sub.l     _GuiPos,d1
	 move.l    _ActiveGuiObjData(pc),d2
	 DOMTDJI   GCM_Handle,a0

.Hem:
	 tst.l     _CurrentGui(pc)
	 bne.s     .OldGuiHandler
	 move.l    _CurrentGuiObject(pc),d0
	 beq.s     .OldGuiHandler
	 move.l    d0,a0
	 movem.l   _MouseX(pc),d0-1
	 sub.l     _GuiPos,d1
	 DOMTDJI   GCM_Handle,a0

.OldGuiHandler:
	 move.l    _PreHandler(pc),d0
	 beq.s     .Kzlonka

	 move.l    d0,a0
	 jsr       (a0)

.Kzlonka:
	 movem.l   _MouseX(pc),d0-1
	 sub.l     _GuiPos,d1

	 move.l    _ActiveThingHandler(pc),d2
	 beq.s     .AhBon
	 move.l    d2,a1
	 move.l    _ActiveGuiEntry(pc),a0
	 lea       ge_Domain(a0),a2
	 move.l    a2,_CurrentDomain
	 jmp       (a1)

.AhBon:
	 move.b    _OldMButtonState(pc),d2
	 btst      #0,$dff016
	 seq       _OldMButtonState
	 bne.s     .PasClickuMilieu

	 tst.b     d2
	 bne.s     .PasClickuMilieu

	 cmp.l     #CopEnd,_GuiLayerPtr
	 beq       .ShowGui

	 move.l    #CopEnd,_GuiLayerPtr
	 bra.s     .PasClickuMilieu

.ShowGui:
	 move.l    #CopLayer4,_GuiLayerPtr

.PasClickuMilieu:

	 move.l    _PlayfieldClickHandler(pc),d2
	 beq.s     .DÈcidement

	 cmp.l     #CopEnd,_GuiLayerPtr
	 beq       .GzlonK

	 tst.l     d1
	 bpl.s     .DÈcidement

.GzlonK:

	 movem.l   _MouseX(pc),d0-1
	 move.l    d2,a0
	 jmp       (a0)

.DÈcidement:
	 cmp.l     #CopEnd,_GuiLayerPtr
	 beq.s     .OhEtPuisMerdeTousVouf

	 tst.b     _LMBState
	 beq.s     .OhEtPuisMerdeTousVouf

	 move.l    _CurrentGui(pc),d2
	 beq.s     .OhEtPuisMerdeTousVouf
	 move.l    d2,a0

	 cmp2.l    ge_Domain+gd_Left(a0),d0
	 bcs.s     .OhEtPuisMerdeTousVouf

	 cmp2.l    ge_Domain+gd_Top(a0),d1
	 bcs.s     .OhEtPuisMerdeTousVouf

	 bsr.s     _DoClick

.OhEtPuisMerdeTousVouf:
	 rts
;fe

;fs "_OpenGui"
_OpenGui:          ; a0=Gui
	 move.l    a2,-(a7)

	 move.l    a0,a2
	 move.l    (a2),d0
	 bne.s     .Ok

	 lea       g_ObjectTree(a2),a0
	 bsr       _CreateObjectTree
	 tst.l     d0
	 beq.s     .Fail
	 move.l    d0,(a2)
	 move.l    d0,a2
	 move.l    _ObjectCollector,a0
	 DOMTDI    MTD_AddMember,a0
	 move.l    a2,d0

.Ok:
	 move.l    d0,a2
	 DOMTDI    GM_Open,a2
	 tst.l     d0
	 bne.s     .GuiFail

	 moveq     #-1,d0
.Fail:

	 move.l    (a7)+,a2
	 rts

.GuiFail:
	 movem.l   a2-4,-(a7)
	 move.l    d0,a4
	 DOMTDI    GM_Close,a2

	 lea       OGTitle(pc),a0
	 lea       OGBody(pc),a1
	 lea       OGBut(pc),a2
	 sub.l     a3,a3
	 bsr.s     _Request

	 moveq     #0,d0
	 movem.l   (a7)+,a2-4
	 bra.s     .Fail

OGTitle:
	 dc.b      "OpenGui() failure",0
OGBody:
	 dc.b      "%s error :",$a
	 dc.b      "%s",0
OGBut:
	 dc.b      "OK",0
	 even
;fe
;fs "_CloseGui"
_CloseGui:
	 move.l    _CurrentGuiObject(pc),a0
	 DOMTDJI   GM_Close,a0
;fe

;fs "Classes"
;fs "GuiRootClass"
_GuiRootClass:
	 dc.l      0
	 dc.l      _RootClass
	 dc.l      0,0,0,0,0
	 dc.l      guir_DataSize
	 dc.l      guir_Funcs
	 dc.l      guir_Data
	 dc.l      0
	 dc.l      0

guir_Data:
	 ds.b      gd_Size
	 dc.l      20,20
	 dc.l      0,0
	 dc.l      1000
	 dc.l      0,0,0,0

guir_Funcs:
	 dc.l      GRCActivatePrev
	 dc.l      GRCActivateNext
	 dc.l      GRCActivateLast
	 dc.l      GRCActivateFirst
	 dc.l      GRCHandleAsciiKey
	 dc.l      GRCHandleRawKey
	 dc.l      GRCGoActive
	 dc.l      GRCHandle
	 dc.l      GRCClick
	 dc.l      GRCUnderMouse
	 dc.l      GRCClear
	 dc.l      GRCUpdate
	 dc.l      GRCRender
	 dc.l      GRCLayout
	 dc.l      GRCGetMinMax
	 dc.l      0

GRCClear:
	 movem.l   d3-7/a5,-(a7)
	 move.l    _CurrentDomain,a5
	 LBLOCKEAI GuiRootClass_ID,a0,a1
	 move.l    a1,_CurrentDomain
	 moveq     #0,d3
	 moveq     #0,d4
	 moveq     #0,d5
	 move.l    gd_Width(a1),d6
	 move.l    gd_Height(a1),d7
	 bsr.s     _DrawRectangle
	 move.l    a5,_CurrentDomain
	 movem.l   (a7)+,d3-7/a5
	 rts

GRCUnderMouse:
	 move.l    a2,a0
	 bra.s     _SetMousePointer

GRCGetMinMax:
GRCLayout:
GRCRender:
GRCUpdate:
GRCClick:
GRCHandle:
GRCGoActive:
GRCHandleRawKey:
GRCHandleAsciiKey:
GRCActivateFirst:
GRCActivateLast:
GRCActivateNext:
GRCActivatePrev:
	 moveq     #0,d0
	 rts
;fe
;fs "GuiClass"
_GuiClass:
	 dc.l      0
	 dc.l      _GuiRootClass
	 dc.l      0,0,0,0,0
	 dc.l      gui_DataSize
	 dc.l      gui_Funcs
	 dc.l      gui_Data
	 dc.l      0
	 dc.l      gui_Init

gui_Data:
	 dc.l      -1,0,0,0,0

gui_Funcs:
	 dc.l      GUIActivate
	 dc.l      GUIToggle
	 dc.l      GUIHide
	 dc.l      GUIShow
	 dc.l      GUIMove
	 dc.l      GUIClose
	 dc.l      GUIOpen
	 dc.l      0

gui_Init:
	 move.l    #GCM_GetMinMax,d0
	 lea       GUIGetMinMax,a1
	 bsr       _SetMethod
	 move.l    #GCM_Layout,d0
	 lea       GUILayout,a1
	 bsr       _SetMethod
	 move.l    #GCM_Render,d0
	 lea       GUIRender,a1
	 bsr       _SetMethod
	 move.l    #GCM_Clear,d0
	 lea       GUIClear,a1
	 bsr       _SetMethod
	 move.l    #GCM_Handle,d0
	 lea       GUIHandle,a1
	 bsr       _SetMethod
	 rts

GUIOpen:
	 movem.l   d2/a2-3,-(a7)

	 bsr.s     _ClearGui

	 move.l    a0,a3
	 LBLOCKEAI GuiClass_ID,a3,a2

	 move.l    _CurrentGuiObject(pc),d2
	 move.l    d2,gui_GDTA_OldGui(a2)
	 move.l    _CurrentGui(pc),gui_GDTA_OldStyleGui(a2)
	 bne.s     .Ok

	 tst.l     d2
	 beq.s     .Ok
	 move.l    d2,a0
	 DOMTDI    GCM_Clear,a0
.Ok:

	 clr.l     _CurrentGui
	 move.l    a3,_CurrentGuiObject
	 DOMTDI    GCM_GetMinMax,a3
	 DOMTDI    GCM_Layout,a3
	 move.l    d0,gui_GDTA_Error(a2)
	 bne.s     .Fail

	 DOMTDI    GCM_Render,a3

	 tst.l     gui_GDTA_ShownFlag(a2)
	 bne.s     .Show
	 move.l    #CopEnd,_GuiLayerPtr
	 bra.s     .Done

.Show:
	 move.l    #CopLayer4,_GuiLayerPtr

.Done:
	 moveq     #0,d0
.Fail:
	 movem.l   (a7)+,d2/a2-3
	 rts

GUIClose:
	 movem.l   d2-3/a2,-(a7)

	 LBLOCKEAI GuiClass_ID,a0,a1
	 move.l    gui_GDTA_OldGui(a1),d2
	 move.l    d2,_CurrentGuiObject

	 move.l    gui_GDTA_OldStyleGui(a1),d1
	 move.l    d1,_CurrentGui

	 move.l    gui_GDTA_Error(a1),d3
	 bne.s     .DontClear

	 DOMTDI    GCM_Clear,a0

.DontClear:
	 tst.l     d1
	 bne.s     .OldStyle

	 tst.l     d2
	 beq.s     .Done
	 move.l    d2,_CurrentGuiObject
	 tst.l     d3
	 bne.s     .Done
	 move.l    d2,a2
	 DOMTDI    GCM_GetMinMax,a2
	 DOMTDI    GCM_Layout,a2
	 DOMTDI    GCM_Render,a2
	 bra.s     .Done

.OldStyle:
	 tst.l     d3
	 bne.s     .Done
	 move.l    d1,a0
	 bsr.s     _ChangeGui

.Done:
	 movem.l   (a7)+,d2-3/a2
	 rts

GUIGetMinMax:
	 movem.l   d2/a2,-(a7)

	 LBLOCKEAI RootClass_ID,a0,a0
	 move.l    (a0),a2
	 DOMTDI    GCM_GetMinMax,a2

	 LBLOCKEAI GuiRootClass_ID,a2,a0
	 moveq     #0,d0
	 move.l    #255,d1

	 move.l    guir_DTA_MaxHeight(a0),d2
	 beq.s     .NoMax
	 move.l    d1,d0
	 sub.l     guir_DTA_MaxHeight(a0),d0
.NoMax:
	 move.l    d0,_MinGuiPos

	 sub.l     guir_DTA_MinHeight(a0),d1
	 move.l    d1,_MaxGuiPos

	 move.l    _GuiPos(pc),d2

	 cmp.l     d0,d2
	 bcc.s     .MinOk
	 move.l    d0,d2
.MinOk:

	 cmp.l     d2,d1
	 bcc.s     .MaxOk
	 move.l    d1,d2
.MaxOk:
	 move.l    d2,_GuiPos

	 movem.l   (a7)+,d2/a2
	 rts

GUILayout:
	 movem.l   a2-3,-(a7)
	 move.l    #CopEnd,_GuiL1Ptr

	 LBLOCKEAI GuiRootClass_ID,a0,a1

	 LBLOCKEAI RootClass_ID,a0,a0
	 move.l    (a0),a0
	 LBLOCKEAI GuiRootClass_ID,a0,a2

	 cmp.l     #256,guir_DTA_MinHeight(a2)
	 bcc.s     .TooTall
	 cmp.l     #GuiScreenWidth-4+1,guir_DTA_MinWidth(a2)
	 bcc.s     .TooWide

	 move.l    _GuiPos(pc),d0
	 move.l    d0,d1

	 add.l     #$28,d0
	 move.w    d0,GuiP

	 move.l    #2,gd_Left(a2)
	 move.l    #0,gd_Top(a2)

	 move.l    #GuiScreenWidth-2,gd_Right(a2)
	 move.l    #GuiScreenWidth-4,gd_Width(a2)

	 move.l    #255,d0
	 sub.l     d1,d0
	 move.l    d0,gd_Height(a2)
	 move.l    d0,gd_Bottom(a2)

	 DOMTDI    GCM_Layout,a0
.Fail:
	 movem.l   (a7)+,a2-3
	 rts

.TooTall:
	 lea       GUITooTall,a0
	 move.l    a0,d0
	 bra.s     .Fail

.TooWide:
	 lea       GUITooWide,a0
	 move.l    a0,d0
	 bra.s     .Fail

GUITooTall:
	 dc.l      GUIName
	 dc.l      GUITT

GUITooWide:
	 dc.l      GUIName
	 dc.l      GUITW


GUIRender:
	 LBLOCKEAI RootClass_ID,a0,a0
	 move.l    (a0),a0
	 DOMTDJI   GCM_Render,a0

GUIClear:
	 LBLOCKEAI RootClass_ID,a0,a0
	 move.l    (a0),a0
	 DOMTDJI   GCM_Clear,a0

GUIHandle:
	 movem.l   a2-3,-(a7)

	 move.l    a0,a3
	 LBLOCKEAI GuiClass_ID,a3,a1
	 tst.l     gui_GDTA_ShownFlag(a1)
	 beq.s     .Grunt

	 movem.l   d0-1,-(a7)
	 move.l    gui_GDTA_ActiveObj(a1),d1

	 bsr.s     _GetRawKey
	 tst.l     d0
	 bmi.s     .NoRawKey
	 tst.l     d1
	 beq.s     .RKNoActObj

	 movem.l   a0-1,-(a7)
	 DOMTDI    GCM_HandleRawKey,d1
	 movem.l   (a7)+,a0-1

.RKNoActObj:
	 cmp.b     #$5f,d0
	 bne.s     .NoRawKey

	 bsr.s     GUIToggle
.NoRawKey:

	 bsr.s     _GetAsciiKey
	 tst.l     d0
	 bmi.s     .NoAsciiKey
	 tst.l     d1
	 beq.s     .NoAsciiKey

	 movem.l   a0-1,-(a7)
	 DOMTDI    GCM_HandleAsciiKey,d1
	 movem.l   (a7)+,a0-1

.NoAsciiKey:
	 movem.l   (a7)+,d0-1

	 LBLOCKEAI RootClass_ID,a3,a0
	 move.l    (a0),a0
	 LBLOCKEAI GuiRootClass_ID,a0,a1

	 cmp2.l    gd_Left(a1),d0
	 bcs.s     .Grunt

	 cmp2.l    gd_Top(a1),d1
	 bcs.s     .Grunt

	 tst.b     _LMBState
	 beq.s     .Grunt

	 DOMTDI    GCM_Click,a0
	 bra.s     .Done

.Grunt:
	 lea       StdMousePointer,a2
	 DOMTDI    GCM_UnderMouse,a0

	 move.b    _OldMButtonState(pc),d1
	 btst      #2,$dff016
	 beq.s     .gna
	 btst      #0,$dff016
.gna:
	 seq       _OldMButtonState
	 bne.s     .Done

	 tst.b     d1
	 bne.s     .Done
	 bsr.s     GUIToggle

.Done:
	 movem.l   (a7)+,a2-3
	 rts

GUIMove:
	 move.l    a2,-(a7)
	 move.l    a0,a2
	 DOMTDI    GCM_Clear,a0
	 DOMTDI    GCM_Layout,a2
	 DOMTDI    GCM_Render,a2
	 move.l    (a7)+,a2
	 rts

GUIShow:
	 SDATALI   #-1,GDTA_ShownFlag,a0
	 move.l    #CopLayer4,_GuiLayerPtr
	 rts

GUIHide:
	 SDATALI   #0,GDTA_ShownFlag,a0
	 move.l    #CopEnd,_GuiLayerPtr
	 rts

GUIToggle:
	 LBLOCKEAI GuiClass_ID,a3,a0
	 not.l     gui_GDTA_ShownFlag(a0)
	 bne.s     .Show
	 move.l    #CopEnd,_GuiLayerPtr
	 rts

.Show:
	 move.l    #CopLayer4,_GuiLayerPtr
	 rts

GUIActivate:       ; a2=object
	 SDATALI   a2,GDTA_ActiveObj,a0
	 rts

GUIName:
	 dc.b      "GuiClass",0
GUITT:
	 dc.b      "GUI is too tall",0
GUITW:
	 dc.b      "GUI is too wide",0
	 even
;fe
;fs "HGroupClass"
_HGroupClass:
	 dc.l      0
	 dc.l      _GuiRootClass
	 dc.l      0,0,0,0,0
	 dc.l      hgr_DataSize
	 dc.l      empty_Funcs
	 dc.l      hgroup_Data
	 dc.l      0
	 dc.l      hgroup_Init

hgroup_Data:
	 dc.l      GuiHorSpacing

hgroup_Init:
	 move.l    #GCM_GetMinMax,d0
	 lea       HGRGetMinMax,a1
	 bsr       _SetMethod
	 move.l    #GCM_Layout,d0
	 lea       HGRLayout,a1
	 bsr       _SetMethod
	 move.l    #GCM_Render,d0
	 lea       _GRPRender,a1
	 bsr       _SetMethod
	 move.l    #GCM_UnderMouse,d0
	 lea       _GRPUnderMouse,a1
	 bsr       _SetMethod
	 move.l    #GCM_Click,d0
	 lea       _GRPClick,a1
	 bsr       _SetMethod
	 rts

HGRGetMinMax:
	 movem.l   d2-7/a2-5,-(a7)
	 move.l    a0,a5

	 LBLOCKEAI RootClass_ID,a5,a2
	 move.l    (a2),a2

	 LDATALI   HGDT_Spacing,a5,a4

	 move.l    a0,a1
	 lea       ge_Size(a0),a0
	 move.l    a4,d2
	 neg.l     d2
	 move.l    d2,d4
	 moveq     #0,d3
	 moveq     #0,d5
	 not.l     d5
	 sf        d6

.Loop:
	 move.l    (a2),d0
	 beq.s     .Done
	 move.l    d0,a3

	 DOMTDI    GCM_GetMinMax,a2

	 LBLOCKEAI GuiRootClass_ID,a2,a0
	 add.l     guir_DTA_MinWidth(a0),d2
	 move.l    guir_DTA_MaxWidth(a0),d0
	 seq       d7
	 or.b      d7,d6
	 add.l     d0,d4

	 move.l    guir_DTA_MinHeight(a0),d0
	 cmp.l     d0,d3
	 bcc.s     .MiHOk
	 move.l    d0,d3
.MiHOk:

	 move.l    guir_DTA_MaxHeight(a0),d0
	 beq.s     .MaHOk
	 cmp.l     d5,d0
	 bcc.s     .MaHOk
	 move.l    d0,d5
.MaHOk:

	 add.l     a4,d2
	 add.l     a4,d4

	 move.l    a3,a2
	 bra.s     .Loop

.Done:
	 tst.b     d6
	 beq.s     .WMaxOk
	 moveq     #0,d4
.WMaxOk:

	 tst.l     d5
	 bpl.s     .HMaxOk
	 moveq     #0,d5
.HMaxOk:

	 LBLOCKEAI GuiRootClass_ID,a5,a0
	 movem.l   d2-5,guir_DTA_MinWidth(a0)

	 movem.l   (a7)+,d2-7/a2-5
	 rts

HGRLayout:
	 movem.l   d2-7/a2-3/a5-6,-(a7)

	 move.l    a0,a6
	 LBLOCKEAI RootClass_ID,a6,a5
	 move.l    (a5),a5
	 moveq     #0,d7

	 LDATALI   HGDT_Spacing,a6,a3

	 LBLOCKEAI GuiRootClass_ID,a6,a1
	 move.l    gd_Height(a1),d0
	 move.l    gd_Top(a1),d1
	 move.l    gd_Bottom(a1),d2
	 moveq     #0,d4
	 move.l    a5,a0

.InitLoop:
	 move.l    (a0),d3
	 beq.s     .ILOk

	 LBLOCKEAI GuiRootClass_ID,a0,a2
	 move.l    d1,gd_Top(a2)
	 move.l    d2,gd_Bottom(a2)
	 clr.l     gd_Width(a2)
	 move.l    d0,gd_Height(a2)

	 add.l     guir_DTA_Weight(a2),d7
	 add.l     a3,d4

	 move.l    d3,a0
	 bra.s     .InitLoop

.ILOk:
	 tst.l     d7
	 bne.s     .WeightOk
	 lea       HGRAWN(pc),a0
	 move.l    a0,d0
	 bra.s     .Fail
.WeightOk:

	 move.l    gd_Width(a1),d5

	 sub.l     a3,d4
	 sub.l     d4,d5

.BigLoop:
	 move.l    a5,a0

.Loop:
	 move.l    (a0),d6
	 beq.s     .Ok

	 LBLOCKEAI GuiRootClass_ID,a0,a0
	 tst.l     gd_Width(a0)
	 bne.s     .Fixed

	 move.l    guir_DTA_MinWidth(a0),d0
	 move.l    guir_DTA_Weight(a0),d3
	 beq.s     .FixMin

	 move.l    d3,d4
	 mulu      d5,d4
	 divu      d7,d4

	 moveq     #0,d2
	 swap      d4
	 lsl.w     #1,d4
	 swap      d4
	 addx.l    d2,d4
	 ext.l     d4

	 cmp.l     d0,d4
	 bcc.s     .MinOk
.FixMin:
	 move.l    d0,gd_Width(a0)
	 sub.l     d0,d5
	 sub.l     d3,d7
	 moveq     #0,d1
	 move.l    d1,gd_Left(a0)
	 bra.s     .BigLoop
.MinOk:

	 move.l    guir_DTA_MaxWidth(a0),d0
	 beq.s     .Next

	 cmp.l     d4,d0
	 bcc.s     .Next
	 move.l    d0,gd_Width(a0)
	 sub.l     d0,d5
	 sub.l     d3,d7
	 moveq     #1,d1
	 move.l    d1,gd_Left(a0)
	 bra.s     .BigLoop

.Fixed:
	 move.l    gd_Left(a0),d0
	 eor.l     d1,d0
	 beq.s     .Next

	 move.l    gd_Width(a0),d0
	 add.l     d5,d0
	 move.l    guir_DTA_Weight(a0),d2
	 mulu      d2,d0
	 add.l     d7,d2
	 divu      d2,d0

	 moveq     #0,d3
	 swap      d0
	 lsl.w     #1,d0
	 swap      d0
	 addx.l    d3,d0
	 ext.l     d0

	 move.l    guir_DTA_MinWidth(a0),d3
	 cmp.l     d3,d0
	 bcs.s     .Next

	 move.l    guir_DTA_MaxWidth(a0),d3
	 beq.s     .AhhR‚aah
	 cmp.l     d0,d3
	 bcs.s     .Next

.AhhR‚aah:
	 add.l     gd_Width(a0),d5
	 clr.l     gd_Width(a0)
	 move.l    d2,d7
	 bra.s     .BigLoop

.Next:
	 move.l    d6,a0
	 bra       .Loop

.Ok:
	 move.l    gd_Left(a1),d2

.PosLoop:
	 move.l    (a5),d6
	 beq.s     .AllDone

	 LBLOCKEAI GuiRootClass_ID,a5,a0

	 move.l    d2,gd_Left(a0)

	 move.l    gd_Width(a0),d3
	 bne.s     .PLWOk

	 move.l    guir_DTA_Weight(a0),d3
	 mulu      d5,d3
	 divu      d7,d3

	 moveq     #0,d0
	 swap      d3
	 lsl.w     #1,d3
	 swap      d3
	 addx.l    d0,d3
	 ext.l     d3

	 move.l    d3,gd_Width(a0)
.PLWOk:

	 add.l     d3,d2
	 move.l    d2,gd_Right(a0)
	 add.l     a3,d2

	 DOMTDI    GCM_Layout,a5
	 tst.l     d0
	 bne.s     .Fail

	 move.l    d6,a5
	 bra.s     .PosLoop

.AllDone:
	 moveq     #0,d0
.Fail:
	 movem.l   (a7)+,d2-7/a2-3/a5-6
	 rts

HGRAWN:
	 dc.l      HGRName
	 dc.l      GRPAllWNull
HGRName:
	 dc.b      "HGroupClass",0
	 even
;fe
;fs "VKnobClass"
_VKnobClass:
	 dc.l      0
	 dc.l      _GuiRootClass
	 dc.l      0,0,0,0,0
	 dc.l      vkb_DataSize
	 dc.l      empty_Funcs
	 dc.l      vhandle_data
	 dc.l      0
	 dc.l      vhandle_Init

vhandle_data:
	 dc.l      0,0,0,0

vhandle_Init:
	 LBLOCKEAI GuiRootClass_ID,a2,a3
	 add.l     a1,a3

	 moveq     #0,d0
	 move.l    d0,guir_DTA_MinHeight(a3)
	 moveq     #4,d0
	 move.l    d0,guir_DTA_MinWidth(a3)
	 move.l    d0,guir_DTA_MaxWidth(a3)

	 move.l    #GCM_Layout,d0
	 lea       VKBLayout,a1
	 bsr       _SetMethod
	 move.l    #GCM_Render,d0
	 lea       VKBRender,a1
	 bsr       _SetMethod
	 move.l    #GCM_UnderMouse,d0
	 lea       VKBUnderMouse,a1
	 bsr       _SetMethod
	 move.l    #GCM_Click,d0
	 lea       VKBClick,a1
	 bsr       _SetMethod
	 move.l    #GCM_Handle,d0
	 lea       VKBHandler,a1
	 bsr       _SetMethod
	 rts

VKBLayout:
	 move.l    d2,-(a7)

	 LBLOCKEAI GuiRootClass_ID,a0,a1
	 move.l    gd_Left(a1),d2

	 move.l    4(a0),a1
	 tst.l     4(a1)
	 beq.s     .ErrAtBegin

	 LBLOCKEAI GuiRootClass_ID,a1,a1
	 move.l    guir_DTA_Weight(a1),d1

	 move.l    gd_Width(a1),d0
	 sub.l     d0,d2

	 add.l     guir_DTA_MinWidth(a1),d2

	 move.l    (a0),a1
	 tst.l     (a1)
	 beq.s     .ErrAtEnd

	 LBLOCKEAI GuiRootClass_ID,a1,a1
	 add.l     guir_DTA_Weight(a1),d1
	 beq.s     .Err2NullWeights

	 LBLOCKEAI VKnobClass_ID,a0,a1
	 movem.l   d0-2,vkb_VKDT_TotSize(a1)

	 moveq     #0,d0
.Fail:
	 move.l    (a7)+,d2
	 rts

.ErrAtBegin:
	 lea       VKBAB(pc),a0
	 move.l    a0,d0
	 bra.s     .Fail

.ErrAtEnd:
	 lea       VKBAE(pc),a0
	 move.l    a0,d0
	 bra.s     .Fail

.Err2NullWeights:
	 lea       VKB2NW(pc),a0
	 move.l    a0,d0
	 bra.s     .Fail

VKBRender:
	 movem.l   d2-4,-(a7)
	 move.l    _CurrentDomain(pc),-(a7)

	 move.l    (a0),a1
	 LBLOCKEAI GuiRootClass_ID,a1,a1
	 move.l    gd_Width(a1),d1
	 move.l    d1,d2
	 sub.l     guir_DTA_MinWidth(a1),d1

	 LBLOCKEAI GuiRootClass_ID,a0,a1

	 add.l     gd_Left(a1),d1
	 LBLOCKEAI VKnobClass_ID,a0,a0
	 move.l    d1,vkb_VKDT_MaxPos(a0)
	 add.l     d2,vkb_VKDT_TotSize(a0)

	 moveq     #0,d0
	 move.l    a1,_CurrentDomain
	 moveq     #0,d1
	 move.l    gd_Height(a1),d3
	 moveq     #4,d2
	 sf        d4
	 bsr       _DrawBevelBox

	 move.l    (a7)+,_CurrentDomain
	 movem.l   (a7)+,d2-4
	 rts

VKBUnderMouse:
	 lea       VKMousePointer,a0
	 bra       _SetMousePointer

VKBClick:
	 move.l    d2,-(a7)

	 add.l     _GuiPos(pc),d1
	 move.l    d1,_MinMouseY
	 move.l    d1,_MaxMouseY

	 LBLOCKEAI GuiRootClass_ID,a0,a1
	 move.l    gd_Left(a1),d2
	 sub.l     d0,d2
	 move.l    d0,VKBOffset

	 LBLOCKEAI VKnobClass_ID,a0,a1

	 movem.l   vkb_VKDT_MinPos(a1),d0-1
	 sub.l     d2,d0
	 move.l    d0,_MinMouseX
	 sub.l     d2,d1
	 move.l    d1,_MaxMouseX

	 sf        VKBFlag

	 move.l    a0,_ActiveGuiObject
	 move.l    (a7)+,d2
	 rts

VKBHandler:
	 movem.l   d3-7/a2,-(a7)
	 move.l    _CurrentDomain(pc),-(a7)

	 LBLOCKEAI GuiRootClass_ID,a0,a1
	 move.l    a1,_CurrentDomain

	 moveq     #-1,d3
	 moveq     #0,d5
	 moveq     #4,d6
	 move.l    gd_Height(a1),d7
	 move.l    VKBPos(pc),d4

	 tst.b     _LMBState
	 beq.s     .Release

	 sub.l     VKBOffset(pc),d0
	 move.l    d0,VKBPos
	 tst.b     VKBFlag
	 beq.s     .DontErase

	 cmp.l     d0,d4
	 beq.s     .Done

	 tst.b     VKBFlag
	 beq.s     .DontErase
	 bsr       _DrawRectangle
.DontErase:
	 move.l    d0,d4
	 bsr       _DrawRectangle
	 st        VKBFlag

.Done:
	 move.l    (a7)+,_CurrentDomain
	 movem.l   (a7)+,d3-7/a2
	 rts

.Release:
	 tst.b     VKBFlag
	 beq.s     .DontErase2
	 bsr       _DrawRectangle
.DontErase2:

	 clr.l     _ActiveGuiObject

	 clr.l     _MinMouseX
	 clr.l     _MinMouseY

	 move.l    #GuiScreenWidth,_MaxMouseX
	 move.l    #256,_MaxMouseY

	 tst.l     d4
	 beq.s     .Done

	 LBLOCKEAI VKnobClass_ID,a0,a1
	 movem.l   vkb_VKDT_TotSize(a1),d0-1

	 move.l    4(a0),a1
	 LBLOCKEAI GuiRootClass_ID,a1,a1

	 move.l    gd_Width(a1),d3
	 add.l     d4,d3
	 mulu      d1,d3
	 divu      d0,d3

	 moveq     #0,d4
	 swap      d3
	 lsl.w     #1,d3
	 swap      d3
	 addx.l    d4,d3
	 ext.l     d3

	 move.l    d3,guir_DTA_Weight(a1)

	 move.l    (a0),a1
	 LBLOCKEAI GuiRootClass_ID,a1,a1
	 sub.l     d3,d1
	 move.l    d1,guir_DTA_Weight(a1)

	 LDATALI   DTA_Parent,a0,a2
	 DOMTDI    GCM_Layout,a2
	 DOMTDI    GCM_Clear,a2
	 DOMTDI    GCM_Render,a2

	 move.l    (a7)+,_CurrentDomain
	 movem.l   (a7)+,d3-7/a2
	 rts

VKBOffset:
	 ds.l      1
VKBPos:
	 ds.l      1
VKBFlag:
	 dc.l      0

VKBAB:
	 dc.l      VKBName
	 dc.l      KNBAtBeg
VKBAE:
	 dc.l      VKBName
	 dc.l      KNBAtEnd
VKB2NW:
	 dc.l      VKBName
	 dc.l      KNB2Null

VKBName:
	 dc.b      "VKnobClass",0
	 even
;fe
;fs "VGroupClass"
_VGroupClass:
	 dc.l      0
	 dc.l      _GuiRootClass
	 dc.l      0,0,0,0,0
	 dc.l      vgr_DataSize
	 dc.l      empty_Funcs
	 dc.l      vgroup_Data
	 dc.l      0
	 dc.l      vgroup_Init

vgroup_Data:
	 dc.l      GuiVerSpacing

vgroup_Init:
	 move.l    #GCM_GetMinMax,d0
	 lea       VGRGetMinMax,a1
	 bsr       _SetMethod
	 move.l    #GCM_Layout,d0
	 lea       VGRLayout,a1
	 bsr       _SetMethod
	 move.l    #GCM_Render,d0
	 lea       _GRPRender,a1
	 bsr       _SetMethod
	 move.l    #GCM_UnderMouse,d0
	 lea       _GRPUnderMouse,a1
	 bsr       _SetMethod
	 move.l    #GCM_Click,d0
	 lea       _GRPClick,a1
	 bsr       _SetMethod
	 rts

VGRGetMinMax:
	 movem.l   d2-7/a2-5,-(a7)
	 move.l    a0,a5

	 LBLOCKEAI RootClass_ID,a5,a2
	 move.l    (a2),a2

	 LDATALI   VGDT_Spacing,a5,a4

	 move.l    a0,a1
	 lea       ge_Size(a0),a0
	 move.l    a4,d3
	 neg.l     d3
	 move.l    d3,d5
	 moveq     #0,d2
	 moveq     #0,d4
	 not.l     d4
	 sf        d6

.Loop:
	 move.l    (a2),d0
	 beq.s     .Done
	 move.l    d0,a3

	 DOMTDI    GCM_GetMinMax,a2

	 LBLOCKEAI GuiRootClass_ID,a2,a0
	 add.l     guir_DTA_MinHeight(a0),d3
	 move.l    guir_DTA_MaxHeight(a0),d0
	 seq       d7
	 or.b      d7,d6
	 add.l     d0,d5

	 move.l    guir_DTA_MinWidth(a0),d0
	 cmp.l     d0,d2
	 bcc.s     .MiWOk
	 move.l    d0,d2
.MiWOk:

	 move.l    guir_DTA_MaxWidth(a0),d0
	 beq.s     .MaWOk
	 cmp.l     d4,d0
	 bcc.s     .MaWOk
	 move.l    d0,d4
.MaWOk:

	 add.l     a4,d3
	 add.l     a4,d5

	 move.l    a3,a2
	 bra.s     .Loop

.Done:
	 tst.b     d6
	 beq.s     .HMaxOk
	 moveq     #0,d5
.HMaxOk:

	 tst.l     d4
	 bpl.s     .WMaxOk
	 moveq     #0,d4
.WMaxOk:

	 LBLOCKEAI GuiRootClass_ID,a5,a0
	 movem.l   d2-5,guir_DTA_MinWidth(a0)

	 movem.l   (a7)+,d2-7/a2-5
	 rts

VGRLayout:
	 movem.l   d2-7/a2-3/a5-6,-(a7)

	 move.l    a0,a6
	 LBLOCKEAI RootClass_ID,a6,a5
	 move.l    (a5),a5
	 moveq     #0,d7

	 LDATALI   VGDT_Spacing,a6,a3

	 LBLOCKEAI GuiRootClass_ID,a6,a1
	 move.l    gd_Width(a1),d0
	 move.l    gd_Left(a1),d1
	 move.l    gd_Right(a1),d2
	 moveq     #0,d4
	 move.l    a5,a0

.InitLoop:
	 move.l    (a0),d3
	 beq.s     .ILOk

	 LBLOCKEAI GuiRootClass_ID,a0,a2
	 move.l    d1,gd_Left(a2)
	 move.l    d2,gd_Right(a2)
	 clr.l     gd_Height(a2)
	 move.l    d0,gd_Width(a2)

	 add.l     guir_DTA_Weight(a2),d7
	 add.l     a3,d4

	 move.l    d3,a0
	 bra.s     .InitLoop

.ILOk:
	 tst.l     d7
	 bne.s     .WeightOk
	 lea       VGRAWN(pc),a0
	 move.l    a0,d0
	 bra.s     .Fail
.WeightOk:

	 move.l    gd_Height(a1),d5

	 sub.l     a3,d4
	 sub.l     d4,d5

.BigLoop:
	 move.l    a5,a0

.Loop:
	 move.l    (a0),d6
	 beq.s     .Ok

	 LBLOCKEAI GuiRootClass_ID,a0,a0
	 tst.l     gd_Height(a0)
	 bne.s     .Fixed

	 move.l    guir_DTA_MinHeight(a0),d0
	 move.l    guir_DTA_Weight(a0),d3
	 beq.s     .FixMin

	 move.l    d3,d4
	 mulu      d5,d4
	 divu      d7,d4

	 moveq     #0,d2
	 swap      d4
	 lsl.w     #1,d4
	 swap      d4
	 addx.l    d2,d4
	 ext.l     d4

	 cmp.l     d0,d4
	 bcc.s     .MinOk
.FixMin:
	 move.l    d0,gd_Height(a0)
	 sub.l     d0,d5
	 sub.l     d3,d7
	 moveq     #0,d1
	 move.l    d1,gd_Top(a0)
	 bra.s     .BigLoop
.MinOk:

	 move.l    guir_DTA_MaxHeight(a0),d0
	 beq.s     .Next

	 cmp.l     d4,d0
	 bcc.s     .Next
	 move.l    d0,gd_Height(a0)
	 sub.l     d0,d5
	 sub.l     d3,d7
	 moveq     #1,d1
	 move.l    d1,gd_Top(a0)
	 bra.s     .BigLoop

.Fixed:
	 move.l    gd_Top(a0),d0
	 eor.l     d1,d0
	 beq.s     .Next

	 move.l    gd_Height(a0),d0
	 add.l     d5,d0
	 move.l    guir_DTA_Weight(a0),d2
	 mulu      d2,d0
	 add.l     d7,d2
	 divu      d2,d0

	 moveq     #0,d3
	 swap      d0
	 lsl.w     #1,d0
	 swap      d0
	 addx.l    d3,d0
	 ext.l     d0

	 move.l    guir_DTA_MinHeight(a0),d3
	 cmp.l     d3,d0
	 bcs.s     .Next

	 move.l    guir_DTA_MaxHeight(a0),d3
	 beq.s     .AhhR‚aah
	 cmp.l     d0,d3
	 bcs.s     .Next

.AhhR‚aah:
	 add.l     gd_Height(a0),d5
	 clr.l     gd_Height(a0)
	 move.l    d2,d7
	 bra.s     .BigLoop

.Next:
	 move.l    d6,a0
	 bra       .Loop

.Ok:
	 move.l    gd_Top(a1),d2

.PosLoop:
	 move.l    (a5),d6
	 beq.s     .AllDone

	 LBLOCKEAI GuiRootClass_ID,a5,a0

	 move.l    d2,gd_Top(a0)

	 move.l    gd_Height(a0),d3
	 bne.s     .PLHOk

	 move.l    guir_DTA_Weight(a0),d3
	 mulu      d5,d3
	 divu      d7,d3

	 moveq     #0,d0
	 swap      d3
	 lsl.w     #1,d3
	 swap      d3
	 addx.l    d0,d3
	 ext.l     d3

	 move.l    d3,gd_Height(a0)
.PLHOk:

	 add.l     d3,d2
	 move.l    d2,gd_Bottom(a0)
	 add.l     a3,d2

	 DOMTDI    GCM_Layout,a5
	 tst.l     d0
	 bne.s     .Fail

	 move.l    d6,a5
	 bra.s     .PosLoop

.AllDone:
	 moveq     #0,d0
.Fail:
	 movem.l   (a7)+,d2-7/a2-3/a5-6
	 rts

VGRAWN:
	 dc.l      VGRName
	 dc.l      GRPAllWNull
VGRName:
	 dc.b      "VGroupClass",0
	 even
;fe
;fs "HKnobClass"
_HKnobClass:
	 dc.l      0
	 dc.l      _GuiRootClass
	 dc.l      0,0,0,0,0
	 dc.l      hkb_DataSize
	 dc.l      empty_Funcs
	 dc.l      hhandle_data
	 dc.l      0
	 dc.l      hhandle_Init

hhandle_data:
	 dc.l      0,0,0,0

hhandle_Init:
	 LBLOCKEAI GuiRootClass_ID,a2,a3
	 add.l     a1,a3

	 moveq     #0,d0
	 move.l    d0,guir_DTA_MinWidth(a3)
	 moveq     #2,d0
	 move.l    d0,guir_DTA_MinHeight(a3)
	 move.l    d0,guir_DTA_MaxHeight(a3)

	 move.l    #GCM_Layout,d0
	 lea       HKBLayout,a1
	 bsr       _SetMethod
	 move.l    #GCM_Render,d0
	 lea       HKBRender,a1
	 bsr       _SetMethod
	 move.l    #GCM_UnderMouse,d0
	 lea       HKBUnderMouse,a1
	 bsr       _SetMethod
	 move.l    #GCM_Click,d0
	 lea       HKBClick,a1
	 bsr       _SetMethod
	 move.l    #GCM_Handle,d0
	 lea       HKBHandler,a1
	 bsr       _SetMethod
	 rts

HKBLayout:
	 move.l    d2,-(a7)

	 LBLOCKEAI GuiRootClass_ID,a0,a1
	 move.l    gd_Top(a1),d2

	 move.l    4(a0),a1
	 tst.l     4(a1)
	 beq.s     .ErrAtBegin

	 LBLOCKEAI GuiRootClass_ID,a1,a1
	 move.l    guir_DTA_Weight(a1),d1

	 move.l    gd_Height(a1),d0
	 sub.l     d0,d2

	 add.l     guir_DTA_MinHeight(a1),d2

	 move.l    (a0),a1
	 tst.l     (a1)
	 beq.s     .ErrAtEnd

	 LBLOCKEAI GuiRootClass_ID,a1,a1
	 add.l     guir_DTA_Weight(a1),d1
	 beq.s     .Err2NullWeights

	 LBLOCKEAI HKnobClass_ID,a0,a1
	 movem.l   d0-2,hkb_HKDT_TotSize(a1)

	 moveq     #0,d0
.Fail:
	 move.l    (a7)+,d2
	 rts

.ErrAtBegin:
	 lea       HKBAB(pc),a0
	 move.l    a0,d0
	 bra.s     .Fail

.ErrAtEnd:
	 lea       HKBAE(pc),a0
	 move.l    a0,d0
	 bra.s     .Fail

.Err2NullWeights:
	 lea       HKB2NW(pc),a0
	 move.l    a0,d0
	 bra.s     .Fail

HKBRender:
	 movem.l   d2-4,-(a7)
	 move.l    _CurrentDomain(pc),-(a7)

	 move.l    (a0),a1
	 LBLOCKEAI GuiRootClass_ID,a1,a1
	 move.l    gd_Height(a1),d1
	 move.l    d1,d2
	 sub.l     guir_DTA_MinHeight(a1),d1

	 LBLOCKEAI GuiRootClass_ID,a0,a1

	 add.l     gd_Top(a1),d1
	 LBLOCKEAI HKnobClass_ID,a0,a0
	 move.l    d1,hkb_HKDT_MaxPos(a0)
	 add.l     d2,hkb_HKDT_TotSize(a0)

	 moveq     #0,d0
	 move.l    a1,_CurrentDomain
	 moveq     #0,d1
	 move.l    gd_Width(a1),d2
	 moveq     #2,d3
	 sf        d4
	 bsr       _DrawBevelBox

	 move.l    (a7)+,_CurrentDomain
	 movem.l   (a7)+,d2-4
	 rts

HKBUnderMouse:
	 lea       HKMousePointer,a0
	 bra       _SetMousePointer

HKBClick:
	 move.l    d2,-(a7)

	 move.l    d0,_MinMouseX
	 move.l    d0,_MaxMouseX

	 LBLOCKEAI GuiRootClass_ID,a0,a1
	 move.l    gd_Top(a1),d2
	 sub.l     d1,d2
	 move.l    d1,HKBOffset

	 LBLOCKEAI HKnobClass_ID,a0,a1

	 sub.l     _GuiPos(pc),d2
	 movem.l   hkb_HKDT_MinPos(a1),d0-1
	 sub.l     d2,d0
	 move.l    d0,_MinMouseY
	 sub.l     d2,d1
	 move.l    d1,_MaxMouseY

	 sf        HKBFlag

	 move.l    a0,_ActiveGuiObject
	 move.l    (a7)+,d2
	 rts

HKBHandler:
	 movem.l   d3-7/a2,-(a7)
	 move.l    _CurrentDomain(pc),-(a7)

	 LBLOCKEAI GuiRootClass_ID,a0,a1
	 move.l    a1,_CurrentDomain

	 moveq     #-1,d3
	 moveq     #0,d4
	 move.l    gd_Width(a1),d6
	 moveq     #2,d7
	 move.l    HKBPos(pc),d5

	 tst.b     _LMBState
	 beq.s     .Release

	 sub.l     HKBOffset(pc),d1
	 move.l    d1,HKBPos
	 tst.b     HKBFlag
	 beq.s     .DontErase

	 cmp.l     d1,d5
	 beq.s     .Done

	 tst.b     HKBFlag
	 beq.s     .DontErase
	 bsr       _DrawRectangle
.DontErase:
	 move.l    d1,d5
	 bsr       _DrawRectangle
	 st        HKBFlag

.Done:
	 move.l    (a7)+,_CurrentDomain
	 movem.l   (a7)+,d3-7/a2
	 rts

.Release:
	 tst.b     HKBFlag
	 beq.s     .DontErase2
	 bsr       _DrawRectangle
.DontErase2:

	 clr.l     _ActiveGuiObject

	 clr.l     _MinMouseX
	 clr.l     _MinMouseY

	 move.l    #GuiScreenWidth,_MaxMouseX
	 move.l    #256,_MaxMouseY

	 tst.l     d5
	 beq.s     .Done

	 LBLOCKEAI HKnobClass_ID,a0,a1
	 movem.l   hkb_HKDT_TotSize(a1),d0-1

	 move.l    4(a0),a1
	 LBLOCKEAI GuiRootClass_ID,a1,a1

	 move.l    gd_Height(a1),d3
	 add.l     d5,d3
	 mulu      d1,d3
	 divu      d0,d3

	 moveq     #0,d4
	 swap      d3
	 lsl.w     #1,d3
	 swap      d3
	 addx.l    d4,d3
	 ext.l     d3

	 move.l    d3,guir_DTA_Weight(a1)

	 move.l    (a0),a1
	 LBLOCKEAI GuiRootClass_ID,a1,a1
	 sub.l     d3,d1
	 move.l    d1,guir_DTA_Weight(a1)

	 LDATALI   DTA_Parent,a0,a2
	 DOMTDI    GCM_Layout,a2
	 DOMTDI    GCM_Clear,a2
	 DOMTDI    GCM_Render,a2

	 move.l    (a7)+,_CurrentDomain
	 movem.l   (a7)+,d3-7/a2
	 rts

HKBOffset:
	 ds.l      1
HKBPos:
	 ds.l      1
HKBFlag:
	 dc.l      0

HKBAB:
	 dc.l      HKBName
	 dc.l      KNBAtBeg
HKBAE:
	 dc.l      HKBName
	 dc.l      KNBAtEnd
HKB2NW:
	 dc.l      HKBName
	 dc.l      KNB2Null

HKBName:
	 dc.b      "HKnobClass",0
	 even
;fe
;fs "Common group code"
;fs "_GRPRender"
_GRPRender:
	 movem.l   d2/a2,-(a7)

	 LBLOCKEAI RootClass_ID,a0,a2
	 move.l    (a2),a2

.Loop:
	 move.l    (a2),d2
	 beq.s     .Done
	 DOMTDI    GCM_Render,a2
	 move.l    d2,a2
	 bra.s     .Loop

.Done:
	 movem.l   (a7)+,d2/a2
	 rts
;fe
;fs "_GRPUnderMouse"
_GRPUnderMouse:
	 movem.l   d2/a3,-(a7)

	 LBLOCKEAI RootClass_ID,a0,a3
	 move.l    (a3),a3

.Loop:
	 move.l    (a3),d2
	 beq.s     .Done

	 LBLOCKEAI GuiRootClass_ID,a3,a0

	 cmp2.l    gd_Left(a0),d0
	 bcs.s     .NoClick

	 cmp2.l    gd_Top(a0),d1
	 bcc.s     .Bingo

.NoClick:
	 move.l    d2,a3
	 bra.s     .Loop

.Done:
	 move.l    a2,a0
	 bsr       _SetMousePointer
	 moveq     #0,d0
	 movem.l   (a7)+,d2/a3
	 rts

.Bingo:
	 DOMTDI    GCM_UnderMouse,a3
	 moveq     #1,d0
	 movem.l   (a7)+,d2/a3
	 rts
;fe
;fs "_GRPClick"
_GRPClick:
	 movem.l   d2/a2,-(a7)

	 LBLOCKEAI RootClass_ID,a0,a2
	 move.l    (a2),a2

.Loop:
	 move.l    (a2),d2
	 beq.s     .Done

	 LBLOCKEAI GuiRootClass_ID,a2,a0

	 cmp2.l    gd_Left(a0),d0
	 bcs.s     .NoClick

	 cmp2.l    gd_Top(a0),d1
	 bcc.s     .Bingo

.NoClick:
	 move.l    d2,a2
	 bra.s     .Loop

.Done:
	 moveq     #0,d0
	 movem.l   (a7)+,d2/a2
	 rts

.Bingo:
	 DOMTDI    GCM_Click,a2
	 moveq     #1,d0
	 movem.l   (a7)+,d2/a2
	 rts
;fe
GRPAllWNull:
	 dc.b      "All objects weights are zero",0
	 even
;fe
;fs "Common knob datas"
KNBAtBeg:
	 dc.b      "Knob is at the begin of a group",0
KNBAtEnd:
	 dc.b      "Knob is at the end of a group",0
KNB2Null:
	 dc.b      "Knob is between two objects with null weights",0
	 even
;fe
;fs "EmptyClass"
_EmptyClass:
	 dc.l      0
	 dc.l      _GuiRootClass
	 dc.l      0,0,0,0,0
	 dc.l      0
	 dc.l      empty_Funcs
	 dc.l      0
	 dc.l      0
	 dc.l      empty_Init

empty_Funcs:
	 dc.l      0

empty_Init:
	 LBLOCKEAI GuiRootClass_ID,a2,a3
	 add.l     a1,a3
	 clr.l     guir_DTA_MinWidth(a3)
	 clr.l     guir_DTA_MinHeight(a3)
	 rts
;fe
;fs "ButtonClass"
_ButtonClass:
	 dc.l      0
	 dc.l      _GuiRootClass
	 dc.l      0,0,0,0,0
	 dc.l      btn_DataSize
	 dc.l      button_Funcs
	 dc.l      button_data
	 dc.l      0
	 dc.l      button_Init

button_data:
	 dc.l      0,0,0,0

button_Funcs:
	 dc.l      0

button_Init:
	 LBLOCKEAI GuiRootClass_ID,a2,a3
	 add.l     a1,a3

	 moveq     #12,d0
	 move.l    d0,guir_DTA_MinHeight(a3)
	 move.l    d0,guir_DTA_MaxHeight(a3)
	 clr.l     guir_DTA_MaxWidth(a3)

	 move.l    #GCM_GetMinMax,d0
	 lea       BTNGetMinMax,a1
	 bsr       _SetMethod
	 move.l    #GCM_Layout,d0
	 lea       BTNLayout,a1
	 bsr       _SetMethod
	 move.l    #GCM_Render,d0
	 lea       BTNRender,a1
	 bsr       _SetMethod
	 move.l    #GCM_Click,d0
	 lea       BTNClick,a1
	 bsr       _SetMethod
	 move.l    #GCM_Handle,d0
	 lea       BTNHandler,a1
	 bsr       _SetMethod
	 rts

BTNGetMinMax:
	 movem.l   a2-3,-(a7)
	 LBLOCKEAI ButtonClass_ID,a0,a1
	 move.l    (a1),a2
	 move.l    a2,a3

.StrLen:
	 tst.b     (a3)+
	 bne.s     .StrLen
	 sub.l     a2,a3
	 move.l    a3,d0
	 lsl.l     #3,d0

	 LBLOCKEAI GuiRootClass_ID,a0,a2
	 move.l    d0,guir_DTA_MinWidth(a2)

	 subq.l    #8,d0
	 move.l    d0,btn_BDTA_TextWidth(a1)
	 movem.l   (a7)+,a2-3
	 rts

BTNLayout:
	 LBLOCKEAI GuiRootClass_ID,a0,a1
	 move.l    gd_Width(a1),d0
	 LBLOCKEAI ButtonClass_ID,a0,a1
	 sub.l     btn_BDTA_TextWidth(a1),d0
	 lsr.l     #1,d0
	 move.l    d0,btn_BDTA_TextX(a1)
	 moveq     #0,d0
	 rts

BTNRender:
	 movem.l   d2-7/a5,-(a7)
	 move.l    _CurrentDomain(pc),-(a7)

	 LBLOCKEAI GuiRootClass_ID,a0,a1
	 move.l    a1,_CurrentDomain

	 moveq     #0,d0
	 moveq     #0,d1
	 move.l    gd_Width(a1),d2
	 move.l    gd_Height(a1),d3
	 sf        d4
	 bsr       _DrawBevelBox

	 LBLOCKEAI ButtonClass_ID,a0,a1
	 move.l    btn_BDTA_TextX(a1),d6
	 moveq     #2,d7
	 move.l    (a1),a5
	 moveq     #1,d4
	 moveq     #0,d5
	 bsr       _DrawText

	 move.l    (a7)+,_CurrentDomain
	 movem.l   (a7)+,d2-7/a5
	 rts

BTNClick:
	 clr.l     BTNReptCount
	 move.l    a0,_ActiveGuiObject
	 sf        BTNPressed

BTNHandler:
	 movem.l   d2-7/a5,-(a7)
	 move.l    _CurrentDomain(pc),-(a7)

	 LBLOCKEAI GuiRootClass_ID,a0,a1
	 move.l    a1,_CurrentDomain

	 tst.b     _LMBState
	 beq.s     .Desactivate

	 move.b    BTNPressed(pc),d2

	 cmp2.l    gd_Left(a1),d0
	 scc       d0

	 cmp2.l    gd_Top(a1),d1
	 scc       d1

	 and.b     d1,d0
	 move.b    d0,BTNPressed

	 eor.b     d0,d2
	 beq.s     .DoRepeat

	 tst.b     d0
	 bne.s     .Press

	 bsr.s     .Release

.Done:
	 move.l    (a7)+,_CurrentDomain
	 movem.l   (a7)+,d2-7/a5
	 rts

.DoRepeat:
	 tst.b     d0
	 beq.s     .Done
	 move.l    BTNReptCount,d0
	 beq.s     .Done
	 subq.l    #1,d0
	 bne.s     .ReptOk
	 LBLOCKEAI ButtonClass_ID,a0,a1
	 move.l    btn_BDTA_Repeat(a1),BTNReptCount
	 bra.s     .CallHook

.ReptOk:
	 move.l    d0,BTNReptCount
	 bra.s     .Done

.Release:
	 moveq     #0,d3
	 moveq     #2,d4
	 moveq     #1,d5
	 movem.l   gd_Width(a1),d6-7
	 subq.l    #4,d6
	 subq.l    #2,d7
	 bsr       _DrawRectangle

	 bsr       BTNRender
	 rts

.Press:
	 move.l    a1,a2

	 moveq     #3,d3
	 moveq     #2,d4
	 moveq     #1,d5
	 movem.l   gd_Width(a2),d6-7
	 subq.l    #4,d6
	 subq.l    #2,d7
	 bsr       _DrawRectangle

	 moveq     #0,d0
	 moveq     #0,d1
	 movem.l   gd_Width(a2),d2-3
	 st        d4
	 bsr       _DrawBevelBox

	 LBLOCKEAI ButtonClass_ID,a0,a1

	 move.l    btn_BDTA_TextX(a1),d6
	 moveq     #2,d7
	 move.l    (a1),a5
	 moveq     #1,d4
	 moveq     #0,d5
	 bsr       _DrawText

	 move.l    btn_BDTA_Repeat(a1),BTNReptCount
	 bne.s     .CallHook

	 move.l    (a7)+,_CurrentDomain
	 movem.l   (a7)+,d2-7/a5
	 rts

.Desactivate:
	 clr.l     _ActiveGuiObject

	 tst.b     BTNPressed
	 beq.s     .Done

	 bsr.s     .Release

	 tst.l     BTNReptCount
	 bne.s     .Done

.CallHook:
	 LBLOCKEAI GuiRootClass_ID,a0,a5
	 move.l    guir_DTA_Hook(a5),d0
	 beq.s     .Done
	 move.l    d0,a1
	 move.l    guir_DTA_HookData(a5),d0
	 jsr       (a1)

	 move.l    (a7)+,_CurrentDomain
	 movem.l   (a7)+,d2-7/a5
	 rts

BTNReptCount:
	 dc.l      0
BTNPressed:
	 ds.b      1
	 even
;fe
;fs "DragBarClass"
_DragBarClass:
	 dc.l      0
	 dc.l      _ButtonClass
	 dc.l      0,0,0,0,0
	 dc.l      0
	 dc.l      empty_Funcs
	 dc.l      0
	 dc.l      0
	 dc.l      dragbar_Init

dragbar_Init:
	 move.l    #GCM_Click,d0
	 lea       DRBClick,a1
	 bsr       _SetMethod
	 move.l    #GCM_Handle,d0
	 lea       DRBHandler,a1
	 bsr       _SetMethod
	 rts

DRBClick:
	 move.l    d0,_MinMouseX
	 move.l    d0,_MaxMouseX

	 move.l    a0,_ActiveGuiObject

	 move.l    d1,DRBOffset
	 move.w    GuiSelP,d0
	 sub.w     GuiP,d0
	 move.w    d0,DRBSelOffset

	 move.l    d1,d0
	 add.l     _MinGuiPos(pc),d0
	 move.l    d0,_MinMouseY

	 add.l     _MaxGuiPos(pc),d1
	 move.l    d1,_MaxMouseY

	 lea       DRBMouseHook(pc),a0
	 move.l    a0,_MouseHook

	 ;move.l    #CopEnd,_GuiL1Ptr
	 rts

DRBHandler:
	 tst.b     _LMBState
	 bne.s     .Ok

	 clr.l     _MouseHook
	 clr.l     _ActiveGuiObject

	 clr.l     _MinMouseX
	 clr.l     _MinMouseY

	 move.l    #GuiScreenWidth,_MaxMouseX
	 move.l    #256,_MaxMouseY

	 move.l    _CurrentGuiObject,a0
	 DOMTDJI   GM_Move,a0

.Ok:
	 rts

DRBMouseHook:
	 move.l    _MouseY(pc),d0
	 sub.l     DRBOffset(pc),d0
	 move.l    d0,_GuiPos

	 add.l     #$28,d0
	 move.w    d0,GuiP

	 add.w     DRBSelOffset,d0
	 move.w    d0,GuiSelP
	 rts

DRBOffset:
	 ds.l      1
DRBSelOffset:
	 ds.w      1
;fe
;fs "SmallButtonClass"
_SmallButtonClass:
	 dc.l      0
	 dc.l      _ButtonClass
	 dc.l      0,0,0,0,0
	 dc.l      sbtn_DataSize
	 dc.l      empty_Funcs
	 dc.l      smallbutton_data
	 dc.l      0
	 dc.l      smallbutton_Init

smallbutton_data:
	 dc.l      " ",0,0

smallbutton_Init:
	 move.l    #GCM_GetMinMax,d0
	 lea       SBTGetMinMax,a1
	 bsr       _SetMethod
	 move.l    d0,SBTSGetMinMax
	 rts

SBTSGetMinMax:
	 ds.l      1

SBTGetMinMax:
	 move.l    a2,-(a7)

	 move.l    a0,a2

	 LDATAEAI  SBDT_Char,a0,a1

.Loop:
	 tst.b     (a1)+
	 beq.s     .Loop
	 subq.l    #1,a1

	 SDATALI   a1,BDTA_Label,a0

	 move.l    a2,a0
	 move.l    SBTSGetMinMax(pc),a1
	 jsr       (a1)

	 LBLOCKEAI GuiRootClass_ID,a2,a1
	 move.l    guir_DTA_MinWidth(a1),d0

	 LDATALI   SBDT_Width,a2,d1
	 beq.s     .Ok
	 move.l    d1,d0
	 move.l    d0,guir_DTA_MinWidth(a1)
.Ok:

	 move.l    d0,guir_DTA_MaxWidth(a1)

	 move.l    (a7)+,a2
	 rts
;fe
;fs "TextClass"
_TextClass:
	 dc.l      0
	 dc.l      _GuiRootClass
	 dc.l      0,0,0,0,0
	 dc.l      txt_DataSize
	 dc.l      empty_Funcs
	 dc.l      text_data
	 dc.l      0
	 dc.l      text_Init

text_data:
	 dc.l      0,0

text_Funcs:
	 dc.l      0

text_Init:
	 move.l    #GCM_GetMinMax,d0
	 lea       TXTGetMinMax,a1
	 bsr       _SetMethod
	 move.l    #GCM_Render,d0
	 lea       TXTRender,a1
	 bsr       _SetMethod
	 rts

TXTGetMinMax:
	 movem.l   d2-3/a2-4/a6,-(a7)

	 move.l    a0,a4
	 LBLOCKEAI TextClass_ID,a0,a0

	 move.l    txt_TDTA_Text(a0),a1
	 move.l    txt_TDTA_FData(a0),d0
	 beq.s     .TrucEtTout

	 move.l    a0,-(a7)
	 move.l    (AbsExecBase).w,a6
	 move.l    a1,a0
	 move.l    d0,a1
	 lea       TXTPutChar(pc),a2
	 lea       _StrBuf,a3
	 CALL      RawDoFmt
	 move.l    (a7)+,a0
	 lea       _StrBuf,a1
	 lea       CustomBase,a6

	 moveq     #0,d0

.TrucEtTout:
	 moveq     #0,d1

.LLoop:
	 addq.l    #1,d0

	 cmp.b     #$9b,(a2)
	 bne.s     .Gargl
	 move.b    1(a2),d2
	 beq.s     .Gargl
	 cmp.b     #$a,d2
	 beq.s     .Gargl
	 addq.l    #2,a1
.Gargl:
	 move.l    a1,a2

.CLoop:
	 move.b    (a2)+,d2
	 beq.s     .CLDone
	 cmp.b     #$a,d2
	 bne.s     .CLoop
.CLDone:

	 move.l    a2,d3
	 sub.l     a1,d3

	 cmp.l     d3,d1
	 bcc.s     .Ba‚‚‚h
	 move.l    d3,d1
.Ba‚‚‚h:

	 move.l    a2,a1
	 tst.b     d2
	 bne.s     .LLoop

	 lsl.l     #3,d0
	 LBLOCKEAI GuiRootClass_ID,a4,a0
	 move.l    d0,guir_DTA_MinHeight(a0)
	 move.l    d0,guir_DTA_MaxHeight(a0)

	 subq.l    #1,d1
	 lsl.l     #3,d1

	 move.l    d1,guir_DTA_MinWidth(a0)

	 movem.l   (a7)+,d2-3/a2-4/a6
	 rts

TXTRender:
	 movem.l   d2-7/a2-3/a5-6,-(a7)
	 move.l    _CurrentDomain(pc),-(a7)

	 LBLOCKEAI GuiRootClass_ID,a0,a1
	 move.l    a1,_CurrentDomain

	 move.l    gd_Width(a1),d1

	 LBLOCKEAI TextClass_ID,a0,a0
	 move.l    txt_TDTA_Text(a0),a5
	 moveq     #0,d7
	 move.l    txt_TDTA_FData(a0),d0
	 beq.s     .LLoop

	 movem.l   d1/a1,-(a7)
	 move.l    (AbsExecBase).w,a6
	 move.l    a5,a0
	 move.l    d0,a1
	 lea       TPutChar(pc),a2
	 lea       _StrBuf,a3
	 CALL      RawDoFmt
	 lea       _StrBuf,a5
	 lea       CustomBase,a6
	 movem.l   (a7)+,d1/a1

.LLoop:
	 move.l    a5,a1
	 moveq     #0,d3

	 cmp.b     #$9b,(a1)
	 bne.s     .CLoop
	 cmp.b     #"-",1(a1)
	 beq.s     .ThinBar
	 cmp.b     #"=",1(a1)
	 bne.s     .CLoop

	 movem.l   d1/d6/d7,-(a7)
	 move.l    d1,d2
	 subq.l    #4,d2
	 moveq     #2,d0
	 move.l    d7,d1
	 addq.l    #2,d1
	 moveq     #3,d3
	 st        d4
	 bsr       _DrawBevelBox

	 moveq     #3,d3
	 moveq     #4,d4
	 move.l    d1,d5
	 addq.l    #1,d5
	 move.l    d2,d6
	 subq.l    #4,d6
	 moveq     #1,d7
	 bsr       _DrawRectangle

	 movem.l   (a7)+,d1/d6/d7

	 bra.s     .BarOk

.ThinBar:
	 move.l    d1,-(a7)
	 move.l    d1,d2
	 subq.l    #4,d2
	 moveq     #2,d0
	 move.l    d7,d1
	 addq.l    #3,d1
	 moveq     #2,d3
	 st        d4
	 bsr       _DrawBevelBox
	 move.l    (a7)+,d1

.BarOk:
	 addq.l    #2,a1
	 addq.l    #2,a5
	 st        d3

.CLoop:
	 move.b    (a1)+,d2
	 beq.s     .CLDone
	 cmp.b     #$a,d2
	 bne.s     .CLoop
.CLDone:
	 move.l    a1,d5
	 sub.l     a5,d5
	 subq.l    #1,d5
	 beq.s     .Poisse

	 move.l    d5,d0
	 lsl.l     #3,d0
	 move.l    d1,d6
	 sub.l     d0,d6
	 lsr.l     #1,d6

	 tst.b     d3
	 beq.s     .NoBar
	 move.l    d5,d2
	 moveq     #0,d3
	 move.l    d6,d4
	 subq.l    #2,d4
	 move.l    d7,d5
	 addq.l    #2,d5
	 move.l    d0,d6
	 addq.l    #4,d6
	 move.l    d7,d0
	 moveq     #3,d7
	 bsr       _DrawRectangle
	 move.l    d0,d7
	 move.l    d4,d6
	 addq.l    #2,d6
	 move.l    d2,d5
.NoBar:

	 moveq     #1,d4
	 bsr       _DrawText

.Poisse:
	 move.l    a1,a5
	 addq.l    #8,d7

	 tst.b     d2
	 bne.s     .LLoop

	 move.l    (a7)+,_CurrentDomain
	 movem.l   (a7)+,d2-7/a2-3/a5-6
	 rts

TXTPutChar:
	 move.b    d0,(a3)+
	 rts
;fe
;fs "FixedTextClass"
_FixedTextClass:
	 dc.l      0
	 dc.l      _TextClass
	 dc.l      0,0,0,0,0
	 dc.l      0
	 dc.l      empty_Funcs
	 dc.l      0
	 dc.l      0
	 dc.l      ftext_Init

ftext_Init:
	 move.l    #GCM_GetMinMax,d0
	 lea       FTXGetMinMax,a1
	 bsr       _SetMethod
	 move.l    d0,FTXSGetMinMax
	 rts

FTXSGetMinMax:
	 ds.l      1

FTXGetMinMax:
	 move.l    a2,-(a7)

	 move.l    a0,a2

	 move.l    FTXSGetMinMax(pc),a1
	 jsr       (a1)

	 LBLOCKEAI GuiRootClass_ID,a2,a0
	 move.l    guir_DTA_MinWidth(a0),guir_DTA_MaxWidth(a0)

	 move.l    (a7)+,a2
	 rts
;fe
;fs "HPropClass"
_HPropClass:
	 dc.l      0
	 dc.l      _GuiRootClass
	 dc.l      0,0,0,0,0
	 dc.l      hpr_DataSize
	 dc.l      hprop_Funcs
	 dc.l      hprop_data
	 dc.l      0
	 dc.l      hprop_Init

hprop_data:
	 dc.l      1,10,1
	 dc.l      0,0,0,0

hprop_Funcs:
	 dc.l      HPRDecr
	 dc.l      HPRIncr
	 dc.l      0

hprop_Init:
	 LBLOCKEAI GuiRootClass_ID,a2,a3
	 add.l     a1,a3

	 moveq     #12,d0
	 move.l    d0,guir_DTA_MinHeight(a3)
	 move.l    d0,guir_DTA_MaxHeight(a3)
	 clr.l     guir_DTA_MaxWidth(a3)
	 move.l    #50,guir_DTA_MinWidth(a3)

	 move.l    #GCM_Layout,d0
	 lea       HPRLayout,a1
	 bsr       _SetMethod
	 move.l    #GCM_Render,d0
	 lea       HPRRender,a1
	 bsr       _SetMethod
	 move.l    #GCM_Update,d0
	 lea       HPRUpdate,a1
	 bsr       _SetMethod
	 move.l    #GCM_Click,d0
	 lea       HPRClick,a1
	 bsr       _SetMethod
	 move.l    #GCM_Handle,d0
	 lea       HPRHandler,a1
	 bsr       _SetMethod
	 rts

HPRLayout:
	 movem.l   d2-5,-(a7)

	 LBLOCKEAI GuiRootClass_ID,a0,a1
	 move.l    gd_Width(a1),d0
	 subq.l    #8,d0
	 move.l    d0,d1

	 LBLOCKEAI HPropClass_ID,a0,a1
	 move.l    hpr_HPDT_Total(a1),d2

	 move.l    hpr_HPDT_Visible(a1),d3
	 cmp.l     d2,d3
	 bcc.s     .FullKnob

	 mulu      d3,d1
	 divu      d2,d1
	 ext.l     d1

	 cmp.l     #14,d1
	 bcc.s     .FullKnob
	 moveq     #14,d1

.FullKnob:
	 move.l    d1,hpr_HPDT_KnobSize(a1)

	 sub.l     d1,d0
	 move.l    d0,hpr_HPDT_MaxPos(a1)

	 bsr.s     HPRCalcKnobPos
	 cmp.l     d4,d5
	 sne       d0

	 tst.l     hpr_HPDT_LayoutNotify(a1)
	 beq.s     .Groumpf
	 tst.b     d0
	 beq.s     .Groumpf
	 move.l    hpr_HPDT_Position(a1),d1
	 LBLOCKEAI GuiRootClass_ID,a0,a1
	 move.l    guir_DTA_Hook(a1),d3
	 beq.s     .Groumpf
	 move.l    guir_DTA_HookData(a1),d0
	 move.l    d3,a1
	 moveq     #-1,d2
	 jsr       (a1)
.Groumpf:

	 moveq     #0,d0
	 movem.l   (a7)+,d2-5
	 rts

HPRDecr:
	 LBLOCKEAI HPropClass_ID,a0,a1
	 sub.l     #1,hpr_HPDT_Position(a1)
	 DOMTDJI   GCM_Update,a0

HPRIncr:
	 LBLOCKEAI HPropClass_ID,a0,a1
	 add.l     #1,hpr_HPDT_Position(a1)
	 DOMTDJI   GCM_Update,a0

HPRUpdate:
	 movem.l   d2-7,-(a7)
	 move.l    _CurrentDomain(pc),-(a7)

	 LBLOCKEAI GuiRootClass_ID,a0,a1
	 move.l    a1,_CurrentDomain
	 LBLOCKEAI HPropClass_ID,a0,a1

	 bsr.s     HPRCalcKnobPos
	 cmp.l     d4,d5
	 sne       d7

	 bsr.s     HPRClearKnob
	 bsr.s     HPRRenderKnob

	 tst.b     d7
	 beq.s     .Groumpf
	 move.l    hpr_HPDT_Position(a1),d1
	 LBLOCKEAI GuiRootClass_ID,a0,a1
	 move.l    guir_DTA_Hook(a1),d3
	 beq.s     .Groumpf
	 move.l    guir_DTA_HookData(a1),d0
	 move.l    d3,a1
	 moveq     #0,d2
	 jsr       (a1)
.Groumpf:

	 move.l    (a7)+,_CurrentDomain
	 movem.l   (a7)+,d2-7
	 rts

HPRCalcKnobPos:
	 movem.l   hpr_HPDT_Total(a1),d1-2
	 move.l    hpr_HPDT_Position(a1),d4
	 move.l    d4,d5
	 bpl.s     .MinOk

	 moveq     #0,d5
.MinOk:

	 move.l    d1,d3
	 sub.l     d2,d3
	 bpl.s     .Ok
	 moveq     #0,d3
.Ok:

	 cmp.l     d5,d3
	 bcc.s     .MaxOk
	 move.l    d3,d5
.MaxOk:

	 move.l    d5,hpr_HPDT_Position(a1)
	 move.l    d5,d0

	 mulu      hpr_HPDT_MaxPos+2(a1),d0
	 sub.l     d2,d1
	 beq.s     .FullKnob

	 divu      d1,d0
	 ext.l     d0

	 move.l    hpr_HPDT_MaxPos(a1),d1
	 cmp.l     d0,d1
	 bcc.s     .MaxPosOk
	 move.l    d1,d0
.MaxPosOk:

	 addq.l    #4,d0
	 move.l    d0,hpr_HPDT_KnobPos(a1)
	 rts

.FullKnob:
	 moveq     #2,d0
	 move.l    d0,hpr_HPDT_KnobPos(a1)
	 rts

HPRRender:
	 movem.l   d2-4,-(a7)
	 move.l    _CurrentDomain(pc),-(a7)

	 LBLOCKEAI HPropClass_ID,a0,a1

	 LBLOCKEAI GuiRootClass_ID,a0,a0
	 move.l    a0,_CurrentDomain
	 moveq     #0,d0
	 moveq     #0,d1
	 movem.l   gd_Width(a0),d2-3
	 sf        d4
	 bsr.s     _DrawBevelBox

	 moveq     #2,d0
	 moveq     #1,d1
	 movem.l   gd_Width(a0),d2-3
	 subq.l    #4,d2
	 subq.l    #2,d3
	 st        d4
	 bsr.s     _DrawBevelBox

	 bsr.s     HPRRenderKnob

	 move.l    (a7)+,_CurrentDomain
	 movem.l   (a7)+,d2-4
	 rts

HPRRenderKnob:
	 moveq     #2,d1
	 moveq     #8,d3
	 movem.l   hpr_HPDT_KnobPos(a1),d0/d2
	 sf        d4
	 bsr.s     _DrawBevelBox

	 moveq     #4,d1
	 move.l    hpr_HPDT_KnobSize(a1),d0
	 subq.l    #6,d0
	 lsr.l     #1,d0
	 add.l     hpr_HPDT_KnobPos(a1),d0
	 bra.s     _DrawPropHole

HPRRenderKnobSelected:
	 moveq     #2,d1
	 moveq     #8,d3
	 movem.l   hpr_HPDT_KnobPos(a1),d0/d2
	 sf        d4
	 bsr.s     _DrawBevelBox

	 moveq     #3,d5
	 moveq     #6,d7
	 movem.l   hpr_HPDT_KnobPos(a1),d4/d6
	 addq.l    #2,d4
	 subq.l    #4,d6
	 moveq     #3,d3
	 bsr.s     _DrawRectangle

	 moveq     #4,d1
	 move.l    hpr_HPDT_KnobSize(a1),d0
	 subq.l    #6,d0
	 lsr.l     #1,d0
	 add.l     hpr_HPDT_KnobPos(a1),d0
	 bra.s     _DrawPropHole

HPRClearKnob:
	 moveq     #2,d5
	 moveq     #8,d7
	 movem.l   hpr_HPDT_KnobPos(a1),d4/d6
	 moveq     #0,d3
	 bra.s     _DrawRectangle

HPRClick:
	 movem.l   d2-7,-(a7)
	 move.l    _CurrentDomain(pc),-(a7)

	 LBLOCKEAI GuiRootClass_ID,a0,a1
	 move.l    a1,_CurrentDomain

	 move.l    d0,d3
	 sub.l     gd_Left(a1),d0

	 LBLOCKEAI HPropClass_ID,a0,a1

	 move.l    hpr_HPDT_KnobPos(a1),d2
	 cmp.l     d2,d0
	 bcs.s     .BeforeKnob
	 add.l     hpr_HPDT_KnobSize(a1),d2
	 cmp.l     d2,d0
	 bcc.s     .AfterKnob

	 sub.l     hpr_HPDT_KnobPos(a1),d3
	 move.l    d3,HPROffset

	 add.l     _GuiPos(pc),d1
	 move.l    d1,_MinMouseY
	 move.l    d1,_MaxMouseY

	 addq.l    #4,d3
	 move.l    d3,d1

	 move.l    d3,_MinMouseX

	 add.l     hpr_HPDT_MaxPos(a1),d1
	 move.l    d1,_MaxMouseX

	 move.l    #-1,_ActiveGuiObjData
	 move.l    a0,_ActiveGuiObject
	 bsr.s     HPRRenderKnobSelected

	 move.l    (a7)+,_CurrentDomain
	 movem.l   (a7)+,d2-7
	 rts

.AfterKnob:
	 move.l    hpr_HPDT_Visible(a1),d1
	 subq.l    #1,d1
	 bne.s     .AKOkIncr
	 moveq     #1,d1
.AKOkIncr:
	 move.l    hpr_HPDT_Position(a1),d0
	 add.l     d1,d0
	 bra.s     .KnobOk

.BeforeKnob:
	 move.l    hpr_HPDT_Visible(a1),d1
	 subq.l    #1,d1
	 bne.s     .BKOkIncr
	 moveq     #1,d1
.BKOkIncr:
	 move.l    hpr_HPDT_Position(a1),d0
	 sub.l     d1,d0

.KnobOk:
	 move.l    d0,hpr_HPDT_Position(a1)

	 bsr       HPRClearKnob
	 bsr       HPRCalcKnobPos
	 move.l    d0,d7
	 bsr       HPRRenderKnob

	 clr.l     _ActiveGuiObjData
	 move.l    a0,_ActiveGuiObject

	 tst.b     d7
	 beq.s     .Done

	 move.l    hpr_HPDT_Position(a1),d1
	 LBLOCKEAI GuiRootClass_ID,a0,a1
	 move.l    guir_DTA_Hook(a1),d3
	 beq.s     .Done
	 move.l    guir_DTA_HookData(a1),d0
	 move.l    d3,a1
	 moveq     #0,d2
	 jsr       (a1)

.Done:
	 move.l    (a7)+,_CurrentDomain
	 movem.l   (a7)+,d2-7
	 rts

HPRHandler:
	 tst.b     d2
	 bne.s     HPRTrueHandler

	 tst.b     _LMBState
	 bne.s     .Done
	 clr.l     _ActiveGuiObject
.Done:
	 rts

HPRTrueHandler:
	 movem.l   d2-3,-(a7)
	 move.l    _CurrentDomain(pc),-(a7)

	 LBLOCKEAI GuiRootClass_ID,a0,a1
	 move.l    a1,_CurrentDomain

	 LBLOCKEAI HPropClass_ID,a0,a1

	 tst.b     _LMBState
	 beq.s     .Release

	 sub.l     HPROffset(pc),d0
	 cmp.l     hpr_HPDT_KnobPos(a1),d0
	 beq.s     .Done

	 bsr.s     HPRClearKnob
	 move.l    d0,hpr_HPDT_KnobPos(a1)
	 bsr.s     HPRRenderKnobSelected

	 move.l    hpr_HPDT_KnobPos(a1),d1
	 subq.l    #4,d1
	 move.l    hpr_HPDT_Total(a1),d0
	 sub.l     hpr_HPDT_Visible(a1),d0
	 mulu      d0,d1
	 move.l    hpr_HPDT_MaxPos(a1),d0
	 divu      d0,d1
	 ext.l     d1
	 move.l    d1,hpr_HPDT_Position(a1)

	 LBLOCKEAI GuiRootClass_ID,a0,a1
	 move.l    guir_DTA_Hook(a1),d3
	 beq.s     .Done
	 move.l    guir_DTA_HookData(a1),d0
	 move.l    d3,a1
	 moveq     #0,d2
	 jsr       (a1)

.Done:
	 move.l    (a7)+,_CurrentDomain
	 movem.l   (a7)+,d2-3
	 rts

.Release:
	 clr.l     _MinMouseX
	 clr.l     _MinMouseY

	 move.l    #GuiScreenWidth,_MaxMouseX
	 move.l    #256,_MaxMouseY

	 clr.l     _ActiveGuiObject
	 bsr.s     HPRClearKnob
	 bsr.s     HPRRenderKnob

	 move.l    (a7)+,_CurrentDomain
	 movem.l   (a7)+,d2-3
	 rts


HPROffset:
	 ds.l      1
;fe
;fs "VPropClass"
_VPropClass:
	 dc.l      0
	 dc.l      _GuiRootClass
	 dc.l      0,0,0,0,0
	 dc.l      vpr_DataSize
	 dc.l      vprop_Funcs
	 dc.l      vprop_data
	 dc.l      0
	 dc.l      vprop_Init

vprop_data:
	 dc.l      1,10,1
	 dc.l      0,0,0,0,0,0

vprop_Funcs:
	 dc.l      VPRDecr
	 dc.l      VPRIncr
	 dc.l      0

vprop_Init:
	 LBLOCKEAI GuiRootClass_ID,a2,a3
	 add.l     a1,a3

	 moveq     #22,d0
	 move.l    d0,guir_DTA_MinWidth(a3)
	 move.l    d0,guir_DTA_MaxWidth(a3)
	 clr.l     guir_DTA_MaxHeight(a3)
	 move.l    #19,guir_DTA_MinHeight(a3)

	 move.l    #GCM_Layout,d0
	 lea       VPRLayout,a1
	 bsr       _SetMethod
	 move.l    #GCM_Render,d0
	 lea       VPRRender,a1
	 bsr       _SetMethod
	 move.l    #GCM_Update,d0
	 lea       VPRUpdate,a1
	 bsr       _SetMethod
	 move.l    #GCM_Click,d0
	 lea       VPRClick,a1
	 bsr       _SetMethod
	 move.l    #GCM_Handle,d0
	 lea       VPRHandler,a1
	 bsr       _SetMethod
	 rts

VPRLayout:
	 movem.l   d2-5,-(a7)

	 LBLOCKEAI GuiRootClass_ID,a0,a1
	 move.l    gd_Height(a1),d0
	 subq.l    #4,d0
	 move.l    d0,d1

	 LBLOCKEAI VPropClass_ID,a0,a1
	 move.l    vpr_VPDT_Total(a1),d2

	 move.l    vpr_VPDT_Visible(a1),d3
	 cmp.l     d2,d3
	 bcc.s     .FullKnob

	 mulu      d3,d1
	 divu      d2,d1
	 ext.l     d1

	 cmp.l     #8,d1
	 bcc.s     .FullKnob
	 moveq     #8,d1

.FullKnob:
	 move.l    d1,vpr_VPDT_KnobSize(a1)

	 sub.l     d1,d0
	 move.l    d0,vpr_VPDT_MaxPos(a1)

	 bsr.s     VPRCalcKnobPos
	 cmp.l     d5,d1
	 sne       d0

	 tst.l     hpr_HPDT_LayoutNotify(a1)
	 beq.s     .Groumpf
	 tst.b     d0
	 ;beq.s     .Groumpf
	 move.l    hpr_HPDT_Position(a1),d1
	 LBLOCKEAI GuiRootClass_ID,a0,a1
	 move.l    guir_DTA_Hook(a1),d3
	 beq.s     .Groumpf
	 move.l    guir_DTA_HookData(a1),d0
	 move.l    d3,a1
	 moveq     #-1,d2
	 jsr       (a1)
.Groumpf:

	 moveq     #0,d0
	 movem.l   (a7)+,d2-5
	 rts

VPRDecr:
	 LBLOCKEAI VPropClass_ID,a0,a1
	 subq.l    #1,vpr_VPDT_Position(a1)
	 DOMTDJI   GCM_Update,a0

VPRIncr:
	 LBLOCKEAI VPropClass_ID,a0,a1
	 addq.l    #1,vpr_VPDT_Position(a1)
	 DOMTDJI   GCM_Update,a0

VPRUpdate:
	 movem.l   d2-7,-(a7)
	 move.l    _CurrentDomain(pc),-(a7)

	 LBLOCKEAI GuiRootClass_ID,a0,a1
	 move.l    a1,_CurrentDomain
	 LBLOCKEAI VPropClass_ID,a0,a1

	 bsr.s     VPRCalcKnobPos
	 cmp.l     d5,d1
	 sne       d7

	 bsr.s     VPRClearKnob
	 bsr.s     VPRRenderKnob

	 tst.b     d7
	 ;beq.s     .Groumpf
	 move.l    vpr_VPDT_Position(a1),d1
	 LBLOCKEAI GuiRootClass_ID,a0,a1
	 move.l    guir_DTA_Hook(a1),d3
	 beq.s     .Groumpf
	 move.l    guir_DTA_HookData(a1),d0
	 move.l    d3,a1
	 moveq     #0,d2
	 jsr       (a1)
.Groumpf:

	 move.l    (a7)+,_CurrentDomain
	 movem.l   (a7)+,d2-7
	 rts

VPRCalcKnobPos:
	 movem.l   vpr_VPDT_Total(a1),d2-3
	 move.l    vpr_VPDT_Position(a1),d5
	 move.l    d5,d1
	 bpl.s     .MinOk

	 moveq     #0,d5
.MinOk:

	 move.l    d2,d4
	 sub.l     d3,d4
	 bpl.s     .Ok
	 moveq     #0,d4
.Ok:

	 cmp.l     d5,d4
	 bcc.s     .MaxOk
	 move.l    d4,d5
.MaxOk:

	 move.l    d5,vpr_VPDT_Position(a1)
	 move.l    d5,d0

	 mulu      vpr_VPDT_MaxPos+2(a1),d0
	 sub.l     d3,d2
	 beq.s     .FullKnob

	 divu      d2,d0
	 ext.l     d0

	 move.l    vpr_VPDT_MaxPos(a1),d2
	 cmp.l     d0,d2
	 bcc.s     .MaxPosOk
	 move.l    d2,d0
.MaxPosOk:

	 addq.l    #2,d0
	 move.l    d0,vpr_VPDT_KnobPos(a1)
	 rts

.FullKnob:
	 moveq     #2,d0
	 move.l    d0,vpr_VPDT_KnobPos(a1)
	 rts

VPRRender:
	 movem.l   d2-4,-(a7)
	 move.l    _CurrentDomain(pc),-(a7)

	 LBLOCKEAI VPropClass_ID,a0,a1

	 LBLOCKEAI GuiRootClass_ID,a0,a0
	 move.l    a0,_CurrentDomain
	 moveq     #0,d0
	 moveq     #0,d1
	 movem.l   gd_Width(a0),d2-3
	 sf        d4
	 bsr.s     _DrawBevelBox

	 moveq     #2,d0
	 moveq     #1,d1
	 movem.l   gd_Width(a0),d2-3
	 subq.l    #4,d2
	 subq.l    #2,d3
	 st        d4
	 bsr.s     _DrawBevelBox

	 bsr.s     VPRRenderKnob

	 move.l    (a7)+,_CurrentDomain
	 movem.l   (a7)+,d2-4
	 rts

VPRRenderKnob:
	 moveq     #4,d0
	 moveq     #14,d2
	 movem.l   vpr_VPDT_KnobPos(a1),d1/d3
	 movem.l   d1/d3,vpr_VPDT_OldKnobPos(a1)

	 sf        d4
	 bsr.s     _DrawBevelBox

	 moveq     #8,d0
	 move.l    vpr_VPDT_KnobSize(a1),d1
	 subq.l    #4,d1
	 lsr.l     #1,d1
	 add.l     vpr_VPDT_KnobPos(a1),d1
	 bra.s     _DrawPropHole

VPRRenderKnobSelected:
	 moveq     #4,d0
	 moveq     #14,d2
	 movem.l   vpr_VPDT_KnobPos(a1),d1/d3
	 movem.l   d1/d3,vpr_VPDT_OldKnobPos(a1)

	 sf        d4
	 bsr.s     _DrawBevelBox

	 moveq     #6,d4
	 moveq     #10,d6
	 movem.l   vpr_VPDT_KnobPos(a1),d5/d7
	 addq.l    #1,d5
	 subq.l    #2,d7
	 moveq     #3,d3
	 bsr.s     _DrawRectangle

	 moveq     #8,d0
	 move.l    vpr_VPDT_KnobSize(a1),d1
	 subq.l    #4,d1
	 lsr.l     #1,d1
	 add.l     vpr_VPDT_KnobPos(a1),d1
	 bra.s     _DrawPropHole

VPRClearKnob:
	 move.l    d7,-(a7)

	 moveq     #4,d4
	 moveq     #14,d6
	 movem.l   vpr_VPDT_OldKnobPos(a1),d5/d7
	 tst.l     d7
	 beq.s     .Done
	 moveq     #0,d3
	 bsr       _DrawRectangle

	 clr.l     vpr_VPDT_OldKnobSize(a1)
.Done:
	 move.l    (a7)+,d7
	 rts

VPRClick:
	 movem.l   d2-7,-(a7)
	 move.l    _CurrentDomain(pc),-(a7)

	 LBLOCKEAI GuiRootClass_ID,a0,a1
	 move.l    a1,_CurrentDomain

	 move.l    d1,d3
	 sub.l     gd_Top(a1),d1

	 LBLOCKEAI HPropClass_ID,a0,a1

	 move.l    vpr_VPDT_KnobPos(a1),d2
	 cmp.l     d2,d1
	 bcs.s     .BeforeKnob
	 add.l     vpr_VPDT_KnobSize(a1),d2
	 cmp.l     d2,d1
	 bcc.s     .AfterKnob

	 sub.l     vpr_VPDT_KnobPos(a1),d3
	 move.l    d3,VPROffset

	 move.l    d0,_MinMouseX
	 move.l    d0,_MaxMouseX

	 add.l     _GuiPos(pc),d3
	 addq.l    #2,d3
	 move.l    d3,d1

	 move.l    d3,_MinMouseY

	 add.l     vpr_VPDT_MaxPos(a1),d1
	 move.l    d1,_MaxMouseY

	 move.l    #-1,_ActiveGuiObjData
	 move.l    a0,_ActiveGuiObject
	 bsr.s     VPRRenderKnobSelected

	 move.l    (a7)+,_CurrentDomain
	 movem.l   (a7)+,d2-7
	 rts

.AfterKnob:
	 move.l    vpr_VPDT_Visible(a1),d0
	 subq.l    #1,d0
	 bne.s     .AKOkIncr
	 moveq     #1,d0
.AKOkIncr:
	 move.l    vpr_VPDT_Position(a1),d1
	 add.l     d1,d0
	 bra.s     .KnobOk

.BeforeKnob:
	 move.l    vpr_VPDT_Visible(a1),d0
	 subq.l    #1,d0
	 bne.s     .BKOkIncr
	 moveq     #1,d0
.BKOkIncr:
	 move.l    vpr_VPDT_Position(a1),d1
	 sub.l     d0,d1
	 exg       d0,d1

.KnobOk:
	 move.l    d0,vpr_VPDT_Position(a1)

	 bsr       VPRCalcKnobPos
	 cmp.l     d5,d1
	 sne       d7

	 bsr       VPRClearKnob
	 bsr       VPRRenderKnob

	 clr.l     _ActiveGuiObjData
	 move.l    a0,_ActiveGuiObject

	 tst.b     d7
	 ;beq.s     .Done

	 move.l    vpr_VPDT_Position(a1),d1
	 LBLOCKEAI GuiRootClass_ID,a0,a1
	 move.l    guir_DTA_Hook(a1),d3
	 beq.s     .Done
	 move.l    guir_DTA_HookData(a1),d0
	 move.l    d3,a1
	 moveq     #0,d2
	 jsr       (a1)

.Done:
	 move.l    (a7)+,_CurrentDomain
	 movem.l   (a7)+,d2-7
	 rts

VPRHandler:
	 tst.b     d2
	 bne.s     VPRTrueHandler

	 tst.b     _LMBState
	 bne.s     .Done
	 clr.l     _ActiveGuiObject
.Done:
	 rts

VPRTrueHandler:
	 movem.l   d2-3,-(a7)
	 move.l    _CurrentDomain(pc),-(a7)

	 LBLOCKEAI GuiRootClass_ID,a0,a1
	 move.l    a1,_CurrentDomain

	 LBLOCKEAI HPropClass_ID,a0,a1

	 tst.b     _LMBState
	 beq.s     .Release

	 sub.l     VPROffset(pc),d1
	 cmp.l     vpr_VPDT_KnobPos(a1),d1
	 beq.s     .Done

	 bsr.s     VPRClearKnob
	 move.l    d1,vpr_VPDT_KnobPos(a1)
	 bsr.s     VPRRenderKnobSelected

	 move.l    vpr_VPDT_KnobPos(a1),d1
	 subq.l    #2,d1
	 move.l    vpr_VPDT_Total(a1),d0
	 sub.l     vpr_VPDT_Visible(a1),d0
	 mulu      d0,d1
	 move.l    vpr_VPDT_MaxPos(a1),d0
	 divu      d0,d1
	 ext.l     d1
	 move.l    d1,vpr_VPDT_Position(a1)

	 LBLOCKEAI GuiRootClass_ID,a0,a1
	 move.l    guir_DTA_Hook(a1),d3
	 beq.s     .Done
	 move.l    guir_DTA_HookData(a1),d0
	 move.l    d3,a1
	 moveq     #0,d2
	 jsr       (a1)

.Done:
	 move.l    (a7)+,_CurrentDomain
	 movem.l   (a7)+,d2-3
	 rts

.Release:
	 clr.l     _MinMouseX
	 clr.l     _MinMouseY

	 move.l    #GuiScreenWidth,_MaxMouseX
	 move.l    #256,_MaxMouseY

	 clr.l     _ActiveGuiObject
	 bsr.s     VPRClearKnob
	 bsr.s     VPRRenderKnob

	 move.l    (a7)+,_CurrentDomain
	 movem.l   (a7)+,d2-3
	 rts


VPROffset:
	 ds.l      1
;fe
;fs "_DrawPropHole"
_DrawPropHole:     ; d0/d1=X,Y

	 IFNE      DISABLEGUIGFX
	 rts

	 ELSE

	 movem.l   d0-3/a0,-(a7)

	 move.l    _CurrentDomain(pc),a0
	 add.l     gd_Left(a0),d0
	 add.l     gd_Top(a0),d1

	 move.l    _GuiBitmap(pc),a0
	 mulu      #GuiLineSize,d1
	 add.l     d1,a0
	 move.l    d0,d1
	 lsr.l     #3,d1
	 add.l     d1,a0

	 not.l     d0
	 and.l     #7,d0
	 addq.l    #3,d0

.RWait:
	 tst.l     _RectCount
	 bne.s     .RWait

	 moveq     #$1c,d1
	 lsl.w     d0,d1
	 or.w      d1,(a0)
	 lea       GuiBufferWidth(a0),a0
	 not.w     d1
	 and.w     d1,(a0)
	 lea       GuiBufferWidth(a0),a0

	 moveq     #$3f,d1
	 lsl.w     d0,d1
	 not.w     d1

	 move.w    (a0),d3
	 and.w     d1,d3
	 moveq     #$38,d2
	 lsl.w     d0,d2
	 or.w      d2,d3
	 move.w    d3,(a0)
	 lea       GuiBufferWidth(a0),a0
	 move.w    (a0),d3
	 and.w     d1,d3
	 moveq     #3,d2
	 lsl.w     d0,d2
	 or.w      d2,d3
	 move.w    d3,(a0)
	 lea       GuiBufferWidth(a0),a0

	 move.w    (a0),d3
	 and.w     d1,d3
	 moveq     #$30,d2
	 lsl.w     d0,d2
	 or.w      d2,d3
	 move.w    d3,(a0)
	 lea       GuiBufferWidth(a0),a0
	 move.w    (a0),d3
	 and.w     d1,d3
	 moveq     #7,d2
	 lsl.w     d0,d2
	 or.w      d2,d3
	 move.w    d3,(a0)
	 lea       GuiBufferWidth(a0),a0

	 moveq     #$e,d1
	 lsl.w     d0,d1
	 move.w    d1,d2
	 not.w     d2
	 and.w     d2,(a0)
	 lea       GuiBufferWidth(a0),a0
	 or.w      d1,(a0)

	 movem.l   (a7)+,d0-3/a0
	 rts

	 ENDIF
;fe
;fs "HScrollerClass"
_HScrollerClass:
	 dc.l      0
	 dc.l      _GuiRootClass
	 dc.l      0,0,0,0,0
	 dc.l      hsc_DataSize
	 dc.l      hscroller_Funcs
	 dc.l      hscroller_data
	 dc.l      0
	 dc.l      hscroller_Init

hscroller_data:
	 dc.l      1,10,1
	 dc.l      0,0

hscroller_Funcs:
	 dc.l      HSCRDecr
	 dc.l      HSCRIncr
	 dc.l      0

hscroller_Init:
	 move.l    #MTD_New,d0
	 lea       HSCRNew,a1
	 bsr       _SetMethod
	 move.l    d0,HSCRSNew

	 move.l    #GCM_GetMinMax,d0
	 lea       HSCRGetMinMax,a1
	 bsr       _SetMethod

	 move.l    #GCM_Layout,d0
	 lea       HSCRLayout,a1
	 bsr       _SetMethod
	 move.l    d0,HSCRSLayout

	 move.l    #GCM_Render,d0
	 lea       HSCRRender,a1
	 bsr       _SetMethod
	 move.l    d0,HSCRSRender

	 move.l    #GCM_Update,d0
	 lea       HSCRUpdate,a1
	 bsr       _SetMethod

	 move.l    #GCM_Click,d0
	 lea       HSCRClick,a1
	 bsr       _SetMethod
	 move.l    d0,HSCRSClick
	 rts

HSCRSNew:
	 ds.l      1
HSCRSLayout:
	 ds.l      1
HSCRSRender:
	 ds.l      1
HSCRSClick:
	 ds.l      1

HSCRNew:
	 movem.l   a2-3,-(a7)

	 move.l    a0,a3
	 move.l    HSCRSNew(pc),a1
	 jsr       (a1)

	 ;LBLOCKEAI HScrollerClass_ID,a3,a0
	 move.l    a3,HSCRHDat1
	 move.l    a3,HSCRHDat2
	 move.l    a3,HSCRHDat3

	 lea       HSCRTree,a0
	 bsr       _CreateObjectTree
	 tst.l     d0
	 beq.s     .Fail

	 move.l    d0,a2
	 DOMTDI    MTD_AddMember,a3

	 SDATALI   HSCRProp,HSDT_Prop,a3

	 moveq     #-1,d0
.Fail:
	 movem.l   (a7)+,a2-3
	 rts

HSCRProp:
	 ds.l      1

HSCRTree:
	 dc.l      OBJ_Begin,_HGroupClass
	 dc.l      HGDT_Spacing,0

	 dc.l      OBJ_Begin,_HPropClass
	 dc.l      HPDT_Position
HSCRPos:
	 dc.l      1
	 dc.l      HPDT_Total
HSCRTot:
	 dc.l      11
	 dc.l      HPDT_Visible
HSCRVis:
	 dc.l      1
	 dc.l      DTA_HookData
HSCRHDat1:
	 dc.l      0
	 dc.l      DTA_Hook,HSCRPropHook
	 STOOBJ    HSCRProp

	 dc.l      OBJ_Begin,_SmallButtonClass
	 dc.l      SBDT_Char,$8e
	 dc.l      SBDT_Width,18
	 dc.l      BDTA_Repeat,5
	 dc.l      DTA_Hook,HSCRDecrHook
	 dc.l      DTA_HookData
HSCRHDat2:
	 dc.l      0
	 ENDOBJ

	 dc.l      OBJ_Begin,_SmallButtonClass
	 dc.l      SBDT_Char,$8d
	 dc.l      SBDT_Width,18
	 dc.l      BDTA_Repeat,5
	 dc.l      DTA_Hook,HSCRIncrHook
	 dc.l      DTA_HookData
HSCRHDat3:
	 dc.l      0
	 ENDOBJ

	 ENDOBJ

HSCRPropHook:
	 move.l    d3,-(a7)

	 move.l    d0,a0
	 LBLOCKEAI HScrollerClass_ID,a0,a1
	 move.l    d1,hsc_HSDT_Position(a1)

	 LBLOCKEAI GuiRootClass_ID,a0,a1
	 move.l    guir_DTA_Hook(a1),d3
	 beq.s     .Done
	 move.l    guir_DTA_HookData(a1),d0
	 move.l    d3,a1
	 jsr       (a1)

.Done:
	 move.l    (a7)+,d3
	 rts

HSCRIncrHook:
	 move.l    d0,a0
	 LDATALI   HSDT_Prop,a0,a0
	 DOMTDJI   HPM_Incr,a0

HSCRDecrHook:
	 move.l    d0,a0
	 LDATALI   HSDT_Prop,a0,a0
	 DOMTDJI   HPM_Decr,a0

HSCRGetMinMax:
	 movem.l   d2-3/a2-3,-(a7)

	 move.l    a0,a3
	 LBLOCKEAI RootClass_ID,a0,a1
	 move.l    (a1),a2
	 DOMTDI    GCM_GetMinMax,a2

	 LBLOCKEAI GuiRootClass_ID,a2,a2
	 movem.l   guir_DTA_MinWidth(a2),d0-3
	 LBLOCKEAI GuiRootClass_ID,a3,a3
	 movem.l   d0-3,guir_DTA_MinWidth(a3)

	 movem.l   (a7)+,d2-3/a2-3
	 rts

HSCRLayout:
	 movem.l   d2-5/a2-4,-(a7)

	 LBLOCKEAI HScrollerClass_ID,a0,a4
	 move.l    hsc_HSDT_Prop(a4),a2
	 LBLOCKEAI HPropClass_ID,a2,a3
	 movem.l   (a4),d0-3
	 movem.l   d0-3,(a3)

	 LBLOCKEAI GuiRootClass_ID,a0,a2
	 LBLOCKEAI RootClass_ID,a0,a0
	 move.l    (a0),a0
	 LBLOCKEAI GuiRootClass_ID,a0,a1
	 movem.l   (a2),d0-5
	 movem.l   d0-5,(a1)

	 DOMTDI    GCM_Layout,a0
	 move.l    vpr_VPDT_Position(a3),vsc_VSDT_Position(a4)

	 moveq     #0,d0
	 movem.l   (a7)+,d2-5/a2-4
	 rts

HSCRRender:
	 LBLOCKEAI RootClass_ID,a0,a0
	 move.l    (a0),a0
	 DOMTDJI   GCM_Render,a0

HSCRUpdate:
	 LDATALI   HSDT_Prop,a0,a0
	 DOMTDJI   GCM_Update,a0

HSCRClick:
	 LBLOCKEAI RootClass_ID,a0,a0
	 move.l    (a0),a0
	 DOMTDJI   GCM_Click,a0

HSCRIncr:
	 LDATALI   HSDT_Prop,a0,a0
	 DOMTDJI   HPM_Incr,a0

HSCRDecr:
	 LDATALI   HSDT_Prop,a0,a0
	 DOMTDJI   HPM_Decr,a0
;fe
;fs "VScrollerClass"
_VScrollerClass:
	 dc.l      0
	 dc.l      _GuiRootClass
	 dc.l      0,0,0,0,0
	 dc.l      vsc_DataSize
	 dc.l      vscroller_Funcs
	 dc.l      vscroller_data
	 dc.l      0
	 dc.l      vscroller_Init

vscroller_data:
	 dc.l      1,10,1
	 dc.l      0,0

vscroller_Funcs:
	 dc.l      VSCRDecr
	 dc.l      VSCRIncr
	 dc.l      0

vscroller_Init:
	 move.l    #MTD_New,d0
	 lea       VSCRNew,a1
	 bsr       _SetMethod
	 move.l    d0,VSCRSNew

	 move.l    #GCM_GetMinMax,d0
	 lea       VSCRGetMinMax,a1
	 bsr       _SetMethod

	 move.l    #GCM_Layout,d0
	 lea       VSCRLayout,a1
	 bsr       _SetMethod
	 move.l    d0,VSCRSLayout

	 move.l    #GCM_Render,d0
	 lea       VSCRRender,a1
	 bsr       _SetMethod
	 move.l    d0,VSCRSRender

	 move.l    #GCM_Update,d0
	 lea       VSCRUpdate,a1
	 bsr       _SetMethod

	 move.l    #GCM_Click,d0
	 lea       VSCRClick,a1
	 bsr       _SetMethod
	 move.l    d0,VSCRSClick
	 rts

VSCRSNew:
	 ds.l      1
VSCRSLayout:
	 ds.l      1
VSCRSRender:
	 ds.l      1
VSCRSClick:
	 ds.l      1

VSCRNew:
	 movem.l   a2-3,-(a7)

	 move.l    a0,a3
	 move.l    VSCRSNew(pc),a1
	 jsr       (a1)

	 ;LBLOCKEAI VScrollerClass_ID,a3,a0
	 move.l    a3,VSCRHDat1
	 move.l    a3,VSCRHDat2
	 move.l    a3,VSCRHDat3

	 lea       VSCRTree,a0
	 bsr       _CreateObjectTree
	 tst.l     d0
	 beq.s     .Fail

	 move.l    d0,a2
	 DOMTDI    MTD_AddMember,a3

	 SDATALI   VSCRProp,VSDT_Prop,a3

	 moveq     #-1,d0
.Fail:
	 movem.l   (a7)+,a2-3
	 rts

VSCRProp:
	 ds.l      1

VSCRTree:
	 dc.l      OBJ_Begin,_VGroupClass
	 dc.l      VGDT_Spacing,0

	 dc.l      OBJ_Begin,_VPropClass
	 dc.l      VPDT_Position
VSCRPos:
	 dc.l      1
	 dc.l      VPDT_Total
VSCRTot:
	 dc.l      11
	 dc.l      VPDT_Visible
VSCRVis:
	 dc.l      1
	 dc.l      DTA_HookData
VSCRHDat1:
	 dc.l      0
	 dc.l      DTA_Hook,VSCRPropHook
	 STOOBJ    VSCRProp

	 dc.l      OBJ_Begin,_SmallButtonClass
	 dc.l      SBDT_Char,$90
	 dc.l      SBDT_Width,22
	 dc.l      BDTA_Repeat,5
	 dc.l      DTA_Hook,VSCRDecrHook
	 dc.l      DTA_HookData
VSCRHDat2:
	 dc.l      0
	 ENDOBJ

	 dc.l      OBJ_Begin,_SmallButtonClass
	 dc.l      SBDT_Char,$8f
	 dc.l      SBDT_Width,22
	 dc.l      BDTA_Repeat,5
	 dc.l      DTA_Hook,VSCRIncrHook
	 dc.l      DTA_HookData
VSCRHDat3:
	 dc.l      0
	 ENDOBJ

	 ENDOBJ

VSCRPropHook:
	 move.l    d3,-(a7)

	 move.l    d0,a0
	 LBLOCKEAI VScrollerClass_ID,a0,a1
	 move.l    d1,vsc_VSDT_Position(a1)

	 LBLOCKEAI GuiRootClass_ID,a0,a1
	 move.l    guir_DTA_Hook(a1),d3
	 beq.s     .Done
	 move.l    guir_DTA_HookData(a1),d0
	 move.l    d3,a1
	 jsr       (a1)

.Done:
	 move.l    (a7)+,d3
	 rts

VSCRIncrHook:
	 move.l    d0,a0
	 LDATALI   VSDT_Prop,a0,a0
	 DOMTDJI   VPM_Incr,a0

VSCRDecrHook:
	 move.l    d0,a0
	 LDATALI   VSDT_Prop,a0,a0
	 DOMTDJI   VPM_Decr,a0

VSCRGetMinMax:
	 movem.l   d2-3/a2-3,-(a7)

	 move.l    a0,a3
	 LBLOCKEAI RootClass_ID,a0,a1
	 move.l    (a1),a2
	 DOMTDI    GCM_GetMinMax,a2

	 LBLOCKEAI GuiRootClass_ID,a2,a2
	 movem.l   guir_DTA_MinWidth(a2),d0-3
	 LBLOCKEAI GuiRootClass_ID,a3,a3
	 movem.l   d0-3,guir_DTA_MinWidth(a3)

	 movem.l   (a7)+,d2-3/a2-3
	 rts

VSCRLayout:
	 movem.l   d2-5/a2-4,-(a7)

	 LBLOCKEAI VScrollerClass_ID,a0,a4
	 move.l    vsc_VSDT_Prop(a4),a2
	 LBLOCKEAI VPropClass_ID,a2,a3
	 movem.l   (a4),d0-3
	 movem.l   d0-3,(a3)

	 LBLOCKEAI GuiRootClass_ID,a0,a2
	 LBLOCKEAI RootClass_ID,a0,a0
	 move.l    (a0),a0
	 LBLOCKEAI GuiRootClass_ID,a0,a1
	 movem.l   (a2),d0-5
	 movem.l   d0-5,(a1)

	 DOMTDI    GCM_Layout,a0
	 move.l    vpr_VPDT_Position(a3),vsc_VSDT_Position(a4)

	 moveq     #0,d0
	 movem.l   (a7)+,d2-5/a2-4
	 rts

VSCRRender:
	 LBLOCKEAI RootClass_ID,a0,a0
	 move.l    (a0),a0
	 DOMTDJI   GCM_Render,a0

VSCRUpdate:
	 LDATALI   VSDT_Prop,a0,a0
	 DOMTDJI   GCM_Update,a0

VSCRClick:
	 LBLOCKEAI RootClass_ID,a0,a0
	 move.l    (a0),a0
	 DOMTDJI   GCM_Click,a0

VSCRIncr:
	 LDATALI   VSDT_Prop,a0,a0
	 DOMTDJI   VPM_Incr,a0

VSCRDecr:
	 LDATALI   VSDT_Prop,a0,a0
	 DOMTDJI   VPM_Decr,a0
;fe
;fs "ScrollAreaClass"
;fs "Structure"
_ScrollAreaClass:
	 dc.l      0
	 dc.l      _GuiRootClass
	 dc.l      0,0,0,0,0
	 dc.l      sac_DataSize
	 dc.l      scrollarea_Funcs
	 dc.l      scrollarea_data
	 dc.l      0
	 dc.l      scrollarea_Init

scrollarea_data:
	 ds.b      sac_DataSize

scrollarea_Funcs:
	 dc.l      SACNop
	 dc.l      SACNop
	 dc.l      SACNop
	 dc.l      SACNop
	 dc.l      SACNop
	 dc.l      SACNop
	 dc.l      SACNop
	 dc.l      SACVDecr
	 dc.l      SACVIncr
	 dc.l      SACHDecr
	 dc.l      SACHIncr
	 dc.l      0
;fe
;fs "Init"
scrollarea_Init:
	 move.l    #MTD_New,d0
	 lea       SACNew,a1
	 bsr       _SetMethod
	 move.l    d0,SACSNew

	 move.l    #GCM_GetMinMax,d0
	 lea       SACGetMinMax,a1
	 bsr       _SetMethod

	 move.l    #GCM_Layout,d0
	 lea       SACLayout,a1
	 bsr       _SetMethod

	 move.l    #GCM_Render,d0
	 lea       SACRender,a1
	 bsr       _SetMethod

	 move.l    #GCM_Update,d0
	 lea       SACUpdate,a1
	 bsr       _SetMethod

	 move.l    #GCM_UnderMouse,d0
	 lea       SACUnderMouse,a1
	 bsr       _SetMethod

	 move.l    #GCM_Click,d0
	 lea       SACClick,a1
	 bsr       _SetMethod
	 rts

SACSNew:
	 ds.l      1
;fe

;fs "Nop"
SACNop:
	 rts
;fe
;fs "New"
SACNew:
	 movem.l   a2-4,-(a7)

	 move.l    a0,a3
	 move.l    SACSNew(pc),a1
	 jsr       (a1)

	 LBLOCKEAI ScrollAreaClass_ID,a3,a4

	 lea       _HScrollerClass,a0
	 sub.l     a1,a1
	 bsr       _NewObject
	 move.l    d0,sac_SADT_HScroller(a4)
	 beq.s     .Fail

	 move.l    d0,a2
	 moveq     #-1,d0
	 SDATALI   d0,HSDT_LayoutNotify,a2

	 LBLOCKEAI GuiRootClass_ID,a2,a0
	 lea       SACHorHook(pc),a1
	 movem.l   a1/a3,guir_DTA_Hook(a0)

	 DOMTDI    MTD_AddMember,a3

	 lea       _VScrollerClass,a0
	 sub.l     a1,a1
	 bsr       _NewObject
	 move.l    d0,sac_SADT_VScroller(a4)
	 beq.s     .Fail

	 move.l    d0,a2
	 moveq     #-1,d0
	 SDATALI   d0,VSDT_LayoutNotify,a2

	 LBLOCKEAI GuiRootClass_ID,a2,a0
	 lea       SACVerHook(pc),a1
	 movem.l   a1/a3,guir_DTA_Hook(a0)

	 DOMTDI    MTD_AddMember,a3

	 moveq     #-1,d0
.Fail:
	 movem.l   (a7)+,a2-4
	 rts
;fe
;fs "GetMinMax"
SACGetMinMax:
	 movem.l   a2-5,-(a7)

	 LBLOCKEAI ScrollAreaClass_ID,a0,a2
	 LBLOCKEAI GuiRootClass_ID,a0,a3

	 move.l    sac_SADT_HScroller(a2),a4
	 DOMTDI    GCM_GetMinMax,a4

	 move.l    sac_SADT_VScroller(a2),a5
	 DOMTDI    GCM_GetMinMax,a5

	 LBLOCKEAI GuiRootClass_ID,a4,a0
	 LBLOCKEAI GuiRootClass_ID,a5,a1

	 move.l    guir_DTA_MinHeight(a1),guir_DTA_MinHeight(a3)
	 move.l    guir_DTA_MinWidth(a1),d0
	 add.l     guir_DTA_MinWidth(a0),d0
	 move.l    d0,guir_DTA_MinWidth(a3)

	 movem.l   (a7)+,a2-5
	 rts
;fe
;fs "Layout"
SACLayout:
	 movem.l   d2-3/d6-7/a2-6,-(a7)

	 move.l    a0,a6
	 LBLOCKEAI GuiRootClass_ID,a0,a2
	 LBLOCKEAI ScrollAreaClass_ID,a0,a3

	 move.l    gd_Width(a2),d0
	 subq.l    #4,d0
	 move.l    d0,sac_SADT_ContentsWidthNVS(a3)

	 move.l    sac_SADT_VScroller(a3),a1
	 LBLOCKEAI GuiRootClass_ID,a1,a1
	 sub.l     guir_DTA_MinWidth(a1),d0
	 move.l    d0,sac_SADT_ContentsWidthVS(a3)

	 move.l    gd_Height(a2),d0
	 subq.l    #3,d0
	 move.l    d0,sac_SADT_ContentsHeightNHS(a3)

	 move.l    sac_SADT_HScroller(a3),a1
	 LBLOCKEAI GuiRootClass_ID,a1,a1
	 sub.l     guir_DTA_MinHeight(a1),d0
	 move.l    d0,sac_SADT_ContentsHeightHS(a3)

	 DOMTDI    SAM_ContentsGetSizes,a0

	 bsr.s     SACCheckScrollers

	 moveq     #0,d0
	 movem.l   (a7)+,d2-3/d6-7/a2-6
	 rts
;fe
;fs "Render"
SACRender:
	 movem.l   d2-4/a2-3,-(a7)
	 move.l    _CurrentDomain(pc),-(a7)

	 move.l    a0,a2

	 LBLOCKEAI GuiRootClass_ID,a2,a1
	 move.l    a1,_CurrentDomain

	 LBLOCKEAI ScrollAreaClass_ID,a2,a3

	 moveq     #0,d0
	 moveq     #0,d1
	 movem.l   sac_SADT_BoxWidth(a3),d2-3
	 st        d4
	 bsr       _DrawBevelBox

	 tst.l     sac_SADT_VSFlag(a3)
	 beq.s     .NoVScroller

	 move.l    sac_SADT_VScroller(a3),a0
	 DOMTDI    GCM_Render,a0
.NoVScroller:

	 tst.l     sac_SADT_HSFlag(a3)
	 beq.s     .NoHScroller

	 move.l    sac_SADT_HScroller(a3),a0
	 DOMTDI    GCM_Render,a0
.NoHScroller:

	 clr.l     sac_SADT_HSCRedraw(a3)
	 clr.l     sac_SADT_VSCRedraw(a3)
	 clr.l     sac_SADT_RedrawContents(a3)
	 DOMTDI    SAM_ContentsRender,a2

	 move.l    (a7)+,_CurrentDomain
	 movem.l   (a7)+,d2-4/a2-3
	 rts
;fe
;fs "Update"
SACUpdate:
	 movem.l   d2-7/a2-6,-(a7)
	 move.l    _CurrentDomain(pc),-(a7)

	 move.l    a0,a6

	 LBLOCKEAI GuiRootClass_ID,a6,a2
	 move.l    a2,_CurrentDomain

	 LBLOCKEAI ScrollAreaClass_ID,a6,a3
	 bsr.s     SACCheckScrollers

	 moveq     #0,d0
	 moveq     #0,d1
	 movem.l   sac_SADT_BoxWidth(a3),d2-3
	 st        d4
	 bsr       _DrawBevelBox

	 tst.l     sac_SADT_VSFlag(a3)
	 beq.s     .VScrollerDone
	 tst.l     sac_SADT_VSCRedraw(a3)
	 bne.s     .VSCRedraw

	 move.l    sac_SADT_VScroller(a3),a0
	 DOMTDI    GCM_Update,a0
	 bra.s     .VScrollerDone

.VSCRedraw:
	 clr.l     sac_SADT_VSCRedraw(a3)
	 move.l    sac_SADT_VScroller(a3),a2
	 DOMTDI    GCM_Clear,a2
	 DOMTDI    GCM_Render,a2

.VScrollerDone:

	 tst.l     sac_SADT_HSFlag(a3)
	 beq.s     .HScrollerDone
	 tst.l     sac_SADT_HSCRedraw(a3)
	 bne.s     .HSCRedraw

	 move.l    sac_SADT_HScroller(a3),a0
	 DOMTDI    GCM_Update,a0

.HSCRedraw:
	 clr.l     sac_SADT_HSCRedraw(a3)
	 move.l    sac_SADT_HScroller(a3),a2
	 DOMTDI    GCM_Clear,a2
	 DOMTDI    GCM_Render,a2

.HScrollerDone:

	 tst.l     sac_SADT_RedrawContents(a3)
	 bne.s     .Redraw
	 DOMTDI    SAM_ContentsUpdate,a6
	 bra.s     .Done

.Redraw:
	 clr.l     sac_SADT_RedrawContents(a3)
	 DOMTDI    SAM_ContentsRender,a6

.Done:
	 move.l    (a7)+,_CurrentDomain
	 movem.l   (a7)+,d2-7/a2-6
	 rts
;fe
;fs "UnderMouse"
SACUnderMouse:
	 LBLOCKEAI ScrollAreaClass_ID,a0,a1

	 cmp2.l    gd_Left(a1),d0
	 bcs.s     .NotInContents
	 cmp2.l    gd_Top(a1),d1
	 bcs.s     .NotInContents

	 DOMTDJI   SAM_ContentsUnderMouse,a0
.NotInContents:

	 move.l    a2,a0
	 bra       _SetMousePointer
;fe
;fs "Click"
SACClick:
	 LBLOCKEAI ScrollAreaClass_ID,a0,a1

	 cmp2.l    gd_Left(a1),d0
	 bcs.s     .NotInContents
	 cmp2.l    gd_Top(a1),d1
	 bcs.s     .NotInContents

	 DOMTDJI   SAM_ContentsClick,a0
.NotInContents:

	 move.l    a2,-(a7)

	 tst.l     sac_SADT_HSFlag(a1)
	 beq.s     .NotInHScroller

	 move.l    sac_SADT_HScroller(a1),a0
	 LBLOCKEAI GuiRootClass_ID,a0,a2
	 cmp2.l    gd_Left(a2),d0
	 bcs.s     .NotInHScroller
	 cmp2.l    gd_Top(a2),d1
	 bcs.s     .NotInHScroller

	 move.l    (a7)+,a2
	 DOMTDJI   GCM_Click,a0
.NotInHScroller:

	 move.l    (a7)+,a2
	 tst.l     sac_SADT_VSFlag(a1)
	 beq.s     .NotInVScroller

	 move.l    sac_SADT_VScroller(a1),a0
	 LBLOCKEAI GuiRootClass_ID,a0,a1
	 cmp2.l    gd_Left(a1),d0
	 bcs.s     .NotInVScroller
	 cmp2.l    gd_Top(a1),d1
	 bcs.s     .NotInVScroller

	 DOMTDJI   GCM_Click,a0
.NotInVScroller:

	 rts
;fe
;fs "HIncr"
SACHIncr:
	 LDATALI   SADT_HScroller,a0,a0
	 DOMTDJI   HSM_Incr,a0
;fe
;fs "HDecr"
SACHDecr:
	 LDATALI   SADT_HScroller,a0,a0
	 DOMTDJI   HSM_Decr,a0
;fe
;fs "VIncr"
SACVIncr:
	 LDATALI   SADT_VScroller,a0,a0
	 DOMTDJI   VSM_Incr,a0
;fe
;fs "VDecr"
SACVDecr:
	 LDATALI   SADT_VScroller,a0,a0
	 DOMTDJI   HSM_Decr,a0
;fe

;fs "CheckScrollers"
SACCheckScrollers:
	 moveq     #0,d6
	 moveq     #0,d7

.CheckScrollers:
	 tst.l     d6
	 bne.s     .HSCheckOk
	 move.l    sac_SADT_HTotalNVS(a3,d7.l),d2
	 beq.s     .HSCheckOk

	 cmp.l     sac_SADT_HVisibleNVS(a3,d7.l),d2
	 ble.s     .HSCheckOk
	 moveq     #4,d6
	 tst.l     sac_SADT_HSFlag(a3)
	 bne.s     .HSCheckOk
	 move.l    d6,sac_SADT_HSCRedraw(a3)
.HSCheckOk:

	 tst.l     d7
	 bne.s     .VSCheckOk
	 move.l    sac_SADT_VTotalNVS(a3),d2
	 beq.s     .VSCheckOk

	 cmp.l     sac_SADT_VVisibleNHS(a3,d6.l),d2
	 ble.s     .VSCheckOk
	 moveq     #12,d7
	 tst.l     sac_SADT_VSFlag(a3)
	 bne.s     .CheckScrollers
	 move.l    d7,sac_SADT_VSCRedraw(a3)
	 bra.s     .CheckScrollers
.VSCheckOk:

	 movem.l   d6-7,sac_SADT_HSFlag(a3)

	 move.l    gd_Width(a2),d2
	 move.l    gd_Height(a2),d3

	 tst.l     d7
	 beq.s     .NoVScroller

	 move.l    sac_SADT_VScroller(a3),a4
	 LBLOCKEAI VScrollerClass_ID,a4,a5
	 move.l    sac_SADT_VPos(a3),vsc_VSDT_Position(a5)
	 move.l    sac_SADT_VTotalVS(a3),vsc_VSDT_Total(a5)
	 move.l    sac_SADT_VVisibleNHS(a3,d6.l),vsc_VSDT_Visible(a5)

	 LBLOCKEAI GuiRootClass_ID,a4,a5
	 move.l    guir_DTA_MinWidth(a5),d0
	 sub.l     d0,d2
	 move.l    d0,gd_Width(a5)
	 move.l    gd_Right(a2),d1
	 move.l    d1,gd_Right(a5)
	 sub.l     d0,d1
	 move.l    d1,gd_Left(a5)
	 move.l    d3,gd_Height(a5)
	 move.l    gd_Top(a2),gd_Top(a5)
	 move.l    gd_Bottom(a2),gd_Bottom(a5)

	 DOMTDI    GCM_Layout,a4
	 bra.s     .OkVScroller

.NoVScroller:
	 moveq     #-1,d0
	 move.l    d0,sac_SADT_RedrawContents(a3)

	 tst.l     sac_SADT_VPos(a3)
	 beq.s     .OkVScroller
	 clr.l     sac_SADT_VPos(a3)
	 moveq     #0,d1
	 move.l    sac_SADT_HPos(a3),d0
	 DOMTDI    SAM_ContentsNewVPos,a6

.OkVScroller:

	 tst.l     d6
	 beq.s     .NoHScroller

	 move.l    sac_SADT_HScroller(a3),a4
	 LBLOCKEAI HScrollerClass_ID,a4,a5
	 move.l    sac_SADT_HPos(a3),hsc_HSDT_Position(a5)
	 move.l    sac_SADT_HTotalNVS(a3,d7.l),hsc_HSDT_Total(a5)
	 move.l    sac_SADT_HVisibleNVS(a3,d7.l),hsc_HSDT_Visible(a5)

	 LBLOCKEAI GuiRootClass_ID,a4,a5
	 move.l    guir_DTA_MinHeight(a5),d0
	 sub.l     d0,d3
	 move.l    d0,gd_Height(a5)
	 move.l    gd_Bottom(a2),d1
	 move.l    d1,gd_Bottom(a5)
	 sub.l     d0,d1
	 move.l    d1,gd_Top(a5)
	 move.l    gd_Left(a2),d0
	 move.l    d0,gd_Left(a5)
	 add.l     d2,d0
	 move.l    d0,gd_Right(a5)
	 move.l    d2,gd_Width(a5)

	 DOMTDI    GCM_Layout,a4
	 bra.s     .OkHScroller

.NoHScroller:
	 moveq     #-1,d0
	 move.l    d0,sac_SADT_RedrawContents(a3)

	 tst.l     sac_SADT_HPos(a3)
	 beq.s     .OkHScroller
	 clr.l     sac_SADT_HPos(a3)
	 moveq     #0,d0
	 move.l    sac_SADT_VPos(a3),d1
	 DOMTDI    SAM_ContentsNewHPos,a6

.OkHScroller:

	 movem.l   d2-3,sac_SADT_BoxWidth(a3)

	 move.l    gd_Left(a2),d0
	 addq.l    #2,d0
	 move.l    d0,gd_Left(a3)
	 move.l    gd_Top(a2),d1
	 addq.l    #1,d1
	 move.l    d1,gd_Top(a3)
	 sub.l     #4,d2
	 move.l    d2,gd_Width(a3)
	 sub.l     #2,d3
	 move.l    d3,gd_Height(a3)
	 add.l     d0,d2
	 move.l    d2,gd_Right(a3)
	 add.l     d1,d3
	 move.l    d3,gd_Bottom(a3)
	 rts
;fe
;fs "HorHook"
SACHorHook:        ; d0=user d1=pos d2=lo flag
	 move.l    a2,-(a7)

	 move.l    d0,a2
	 LBLOCKEAI ScrollAreaClass_ID,a2,a1
	 move.l    d1,sac_SADT_HPos(a1)
	 move.l    d1,d0
	 move.l    sac_SADT_VPos(a1),d1

	 DOMTDI    SAM_ContentsNewHPos,a2

	 tst.l     d2
	 bne.s     .Done
	 DOMTDI    SAM_ContentsUpdate,a2

.Done:
	 move.l    (a7)+,a2
	 rts
;fe
;fs "VerHook"
SACVerHook:        ; d0=user d1=pos d2=lo flag
	 move.l    a2,-(a7)

	 move.l    d0,a2
	 LBLOCKEAI ScrollAreaClass_ID,a2,a1
	 move.l    d1,sac_SADT_VPos(a1)
	 move.l    sac_SADT_HPos(a1),d0

	 DOMTDI    SAM_ContentsNewVPos,a2

	 tst.l     d2
	 bne.s     .Done
	 DOMTDI    SAM_ContentsUpdate,a2

.Done:
	 move.l    (a7)+,a2
	 rts
;fe
;fe
;fs "ListViewClass"
;fs "Structure"
_ListViewClass:
	 dc.l      0
	 dc.l      _GuiRootClass
	 dc.l      0,0,0,0,0
	 dc.l      lvi_DataSize
	 dc.l      empty_Funcs
	 dc.l      listview_data
	 dc.l      0
	 dc.l      listview_Init

listview_data:
	 ds.b      lvi_DataSize
;fe
;fs "Init"
listview_Init:
	 move.l    #MTD_New,d0
	 lea       LVINew,a1
	 bsr       _SetMethod
	 move.l    d0,LVISNew

	 move.l    #GCM_GetMinMax,d0
	 lea       LVIGetMinMax,a1
	 bsr       _SetMethod

	 move.l    #GCM_Layout,d0
	 lea       LVILayout,a1
	 bsr       _SetMethod

	 move.l    #GCM_Render,d0
	 lea       LVIRender,a1
	 bsr       _SetMethod

	 move.l    #GCM_Click,d0
	 lea       LVIClick,a1
	 bsr       _SetMethod

	 move.l    #GCM_Handle,d0
	 lea       LVIHandle,a1
	 bsr       _SetMethod
	 rts

LVISNew:
	 ds.l      1
;fe

;fs "New"
LVINew:
	 movem.l   a2-3,-(a7)

	 move.l    a0,a3
	 move.l    LVISNew(pc),a1
	 jsr       (a1)

	 lea       _VScrollerClass,a0
	 sub.l     a1,a1
	 bsr       _NewObject
	 tst.l     d0
	 beq.s     .Fail

	 move.l    d0,a2
	 DOMTDI    MTD_AddMember,a3

	 SDATALI   a2,LVDT_Scroller,a3

	 LBLOCKEAI GuiRootClass_ID,a2,a0
	 lea       LVIHook(pc),a1
	 movem.l   a1/a3,guir_DTA_Hook(a0)

	 moveq     #-1,d0
.Fail:
	 movem.l   (a7)+,a2-3
	 rts
;fe
;fs "GetMinMax"
LVIGetMinMax:
	 movem.l   a2-3,-(a7)

	 move.l    a0,a2

	 LDATALI   LVDT_Scroller,a2,a3
	 DOMTDI    GCM_GetMinMax,a3

	 LBLOCKEAI GuiRootClass_ID,a3,a0
	 LBLOCKEAI GuiRootClass_ID,a2,a1

	 move.l    guir_DTA_MinHeight(a0),guir_DTA_MinHeight(a1)
	 moveq     #40,d0
	 add.l     guir_DTA_MinWidth(a0),d0
	 move.l    d0,guir_DTA_MinWidth(a1)

	 movem.l   (a7)+,a2-3
	 rts
;fe
;fs "Layout"
LVILayout:
	 movem.l   d2-7/a2-6,-(a7)

	 LBLOCKEAI ListViewClass_ID,a0,a2
	 LBLOCKEAI GuiRootClass_ID,a0,a4

	 move.l    lvi_LVDT_List(a2),a1
	 moveq     #0,d2
	 move.l    (a1),a1
	 move.l    lvi_LVDT_FirstVis(a2),d0
	 bne.s     .NotEmpty
	 move.l    a1,d0
.NotEmpty:
	 move.l    d0,a3
	 moveq     #0,d0

.CountLoop:
	 move.l    (a1),d1
	 beq.s     .CountDone
	 cmp.l     a1,a3
	 bne.s     .CountNext
	 move.l    d0,d2
.CountNext:
	 addq.l    #1,d0
	 move.l    d1,a1
	 bra.s     .CountLoop
.CountDone:

	 move.l    d0,lvi_LVDT_Total(a2)
	 beq.s     .NoList

	 move.l    gd_Height(a4),d3
	 move.l    d3,d4
	 subq.l    #3,d3
	 lsr.l     #3,d3

	 moveq     #-1,d5
	 cmp.l     d0,d3
	 bcs.s     .ScrollerOk
	 moveq     #0,d5
	 move.l    d0,d3
.ScrollerOk:
	 move.l    d3,lvi_LVDT_NumVis(a2)

	 move.l    d3,d6
	 lsl.l     #3,d6
	 addq.l    #1,d6
	 move.l    d6,lvi_LVDT_ClrTop(a2)
	 neg.l     d6
	 add.l     d4,d6
	 subq.l    #1,d6
	 move.l    d6,lvi_LVDT_ClrHeight(a2)

	 move.l    gd_Width(a4),d6
	 move.l    gd_Right(a4),d7

	 move.l    lvi_LVDT_ShowScroller(a2),d1
	 move.l    d5,lvi_LVDT_ShowScroller(a2)
	 beq.s     .NoScroller

	 not.l     d1
	 move.l    d1,lvi_LVDT_ClearScroller(a2)

	 move.l    lvi_LVDT_Scroller(a2),a5

	 LBLOCKEAI VScrollerClass_ID,a5,a6
	 move.l    d2,vsc_VSDT_Position(a6)
	 move.l    d0,vsc_VSDT_Total(a6)
	 move.l    d3,vsc_VSDT_Visible(a6)
	 move.l    a6,d5

	 LBLOCKEAI GuiRootClass_ID,a5,a6
	 move.l    gd_Right(a4),d1
	 move.l    d1,gd_Right(a6)
	 move.l    guir_DTA_MinWidth(a6),d0
	 move.l    d0,gd_Width(a6)
	 sub.l     d0,d1
	 move.l    d1,gd_Left(a6)

	 sub.l     d0,d6
	 sub.l     d0,d7
	 movem.l   d6-7,lvi_LVDT_Width(a2)

	 movem.l   gd_Top(a4),d0-1
	 movem.l   d0-1,gd_Top(a6)
	 move.l    gd_Height(a4),gd_Height(a6)

	 DOMTDI    GCM_Layout,a5

	 move.l    d5,a5
	 move.l    vsc_VSDT_Position(a5),d4
	 move.l    d4,lvi_LVDT_FVNum(a2)
	 move.l    d4,d5
	 subq.l    #1,d3
	 add.l     d3,d5
	 move.l    d5,lvi_LVDT_LVNum(a2)

	 sub.l     d2,d4
	 bmi.s     .Backward
	 subq.l    #1,d4
	 bmi.s     .FVOk

.FwdLoop:
	 move.l    (a3),a3
	 dbf       d4,.FwdLoop
	 bra.s     .FVOk

.Backward:
	 neg.l     d4
	 subq.l    #1,d4
	 bmi.s     .FVOk

.BwdLoop:
	 move.l    4(a3),a3
	 dbf       d4,.BwdLoop
.FVOk:

	 move.l    a3,lvi_LVDT_FirstVis(a2)

	 subq.l    #1,d3
	 bmi.s     .LVOk
.LVLoop:
	 move.l    (a3),a3
	 dbf       d3,.LVLoop
.LVOk:
	 move.l    a3,lvi_LVDT_LastVis(a2)
	 bra.s     .AllDone

.NoList:
	 clr.l     lvi_LVDT_ShowScroller(a2)
	 clr.l     lvi_LVDT_Total(a2)
	 moveq     #1,d0
	 move.l    d0,lvi_LVDT_ClrTop(a2)
	 move.l    gd_Height(a4),d0
	 subq.l    #2,d0
	 move.l    d0,lvi_LVDT_ClrHeight(a2)

	 move.l    gd_Width(a4),d0
	 move.l    gd_Right(a4),d1
	 movem.l   d0-1,lvi_LVDT_Width(a2)
	 bra.s     .AllDone

.NoScroller:
	 movem.l   d6-7,lvi_LVDT_Width(a2)
	 clr.l     lvi_LVDT_FVNum(a2)
	 subq.l    #1,d3
	 move.l    d3,lvi_LVDT_LVNum(a2)

	 move.l    lvi_LVDT_List(a2),a1
	 move.l    (a1),lvi_LVDT_FirstVis(a2)
	 move.l    8(a1),lvi_LVDT_LastVis(a2)

.AllDone:
	 moveq     #0,d0
	 movem.l   (a7)+,d2-7/a2-6
	 rts
;fe
;fs "Render"
LVIRender:
	 movem.l   d2-7/a2-5,-(a7)
	 move.l    _CurrentDomain(pc),-(a7)

	 LBLOCKEAI GuiRootClass_ID,a0,a1
	 move.l    a1,_CurrentDomain
	 LBLOCKEAI ListViewClass_ID,a0,a2

	 moveq     #0,d0
	 moveq     #0,d1
	 move.l    lvi_LVDT_Width(a2),d2
	 move.l    gd_Height(a1),d3
	 sf        d4
	 bsr       _DrawBevelBox

	 tst.l     lvi_LVDT_ShowScroller(a2)
	 beq.s     .NoScroller
	 move.l    lvi_LVDT_Scroller(a2),a3

	 tst.l     lvi_LVDT_ClearScroller(a2)
	 beq.s     .DontClrScroller
	 clr.l     lvi_LVDT_ClearScroller(a2)
	 DOMTDI    GCM_Clear,a3
.DontClrScroller:
	 DOMTDI    GCM_Render,a3
.NoScroller:

	 move.l    lvi_LVDT_Width(a2),d0
	 subq.l    #4,d0
	 move.l    d0,_TextLimit


	 move.l    lvi_LVDT_NumVis(a2),d0
	 beq.s     .NoList
	 subq.l    #1,d0

	 move.l    lvi_LVDT_FirstVis(a2),a3
	 move.l    lvi_LVDT_Selected(a2),a4
	 moveq     #1,d2

.Loop:
	 moveq     #0,d3

	 cmp.l     a3,a4
	 bne.s     .NotSel
	 moveq     #3,d3
.NotSel:

	 moveq     #2,d4
	 move.l    d2,d5
	 move.l    lvi_LVDT_Width(a2),d6
	 subq.l    #4,d6
	 moveq     #8,d7
	 bsr.s     _DrawRectangle

	 moveq     #0,d5
	 move.l    lve_Color(a3),d4
	 move.l    d2,d7
	 move.l    lve_String(a3),a5
	 moveq     #4,d6
	 bsr       _DrawText

	 move.l    (a3),a3
	 addq.l    #8,d2
	 dbf       d0,.Loop

.NoList:
	 movem.l   lvi_LVDT_ClrTop(a2),d5/d7
	 moveq     #2,d4
	 move.l    lvi_LVDT_Width(a2),d6
	 subq.l    #4,d6
	 moveq     #0,d3
	 bsr.s     _DrawRectangle

.Done:
	 clr.l     _TextLimit
	 move.l    (a7)+,_CurrentDomain
	 movem.l   (a7)+,d2-7/a2-5
	 rts
;fe
;fs "Hook"
LVIHook:
	 movem.l   a2-3,-(a7)

	 move.l    d0,a0
	 LBLOCKEAI ListViewClass_ID,a0,a1
	 move.l    lvi_LVDT_FVNum(a1),d0
	 move.l    d1,lvi_LVDT_FVNum(a1)
	 sub.l     d0,d1
	 movem.l   lvi_LVDT_FirstVis(a1),a2-3
	 add.l     d1,lvi_LVDT_LVNum(a1)

	 tst.l     d1
	 bmi.s     .Backward

	 subq.l    #1,d1
	 bmi.s     .Groumpf
.ForwardLoop:
	 move.l    (a2),a2
	 move.l    (a3),a3
	 dbf       d1,.ForwardLoop
	 bra.s     .Groumpf

.Backward:
	 neg.l     d1
	 subq.l    #1,d1
	 bmi.s     .Groumpf
.BackwardLoop:
	 move.l    4(a2),a2
	 move.l    4(a3),a3
	 dbf       d1,.BackwardLoop

.Groumpf:
	 movem.l   a2-3,lvi_LVDT_FirstVis(a1)
	 DOMTDI    GCM_Render,a0

	 movem.l   (a7)+,a2-3
	 rts
;fe
;fs "Click"
LVIClick:
	 LBLOCKEAI ListViewClass_ID,a0,a1
	 tst.l     lvi_LVDT_ShowScroller(a1)
	 beq.s     .NoScroller

	 cmp.l     lvi_LVDT_Right(a1),d0
	 bcs.s     .NoScroller

	 move.l    lvi_LVDT_Scroller(a1),a0
	 DOMTDJI   GCM_Click,a0

.NoScroller:
	 clr.l     LVICounter
	 move.l    a0,_ActiveGuiObject
	 rts
;fe
;fs "Handle"
LVIHandle:
	 tst.b     _LMBState
	 beq.s     .Release

	 movem.l   d2/a2-3,-(a7)

	 LBLOCKEAI ListViewClass_ID,a0,a2
	 tst.l     lvi_LVDT_Total(a2)
	 beq.s     .Done

	 move.l    lvi_LVDT_ShowScroller(a2),d2
	 move.l    lvi_LVDT_Selected(a2),d0

	 LBLOCKEAI GuiRootClass_ID,a0,a1
	 sub.l     gd_Top(a1),d1
	 subq.l    #1,d1
	 bmi.s     .Before

	 lsr.l     #3,d1
	 cmp.l     lvi_LVDT_NumVis(a2),d1
	 bge.s     .After

	 clr.l     LVICounter

	 move.l    lvi_LVDT_FirstVis(a2),a3
	 subq.l    #1,d1
	 bmi.s     .SelOk
.SelLoop:
	 move.l    (a3),a3
	 dbf       d1,.SelLoop
.SelOk:

	 cmp.l     d0,a3
	 beq.s     .Done
.Refresh:
	 move.l    a3,lvi_LVDT_Selected(a2)
	 DOMTDI    GCM_Render,a0
	 bra.s     .Done

.Before:
	 move.l    lvi_LVDT_FirstVis(a2),d1
	 cmp.l     d0,d1
	 beq.s     .BefOk
	 move.l    d1,a3
	 bra.s     .Refresh

.BefOk:
	 tst.l     d2
	 beq.s     .Done
	 sub.l     #1,LVICounter
	 bpl.s     .Done
	 move.l    #5,LVICounter

	 move.l    d0,a1
	 move.l    4(a1),a1
	 tst.l     (a1)
	 beq.s     .Done
	 move.l    a1,lvi_LVDT_Selected(a2)
	 move.l    lvi_LVDT_Scroller(a2),a0
	 DOMTDI    VSM_Decr,a0
	 bra.s     .Done

.After:
	 move.l    lvi_LVDT_LastVis(a2),d1
	 cmp.l     d0,d1
	 beq.s     .AftOk
	 move.l    d1,a3
	 bra.s     .Refresh

.AftOk:
	 tst.l     d2
	 beq.s     .Done
	 sub.l     #1,LVICounter
	 bpl.s     .Done
	 move.l    #5,LVICounter

	 move.l    d0,a1
	 move.l    (a1),a1
	 tst.l     (a1)
	 beq.s     .Done
	 move.l    a1,lvi_LVDT_Selected(a2)
	 move.l    lvi_LVDT_Scroller(a2),a0
	 DOMTDI    VSM_Incr,a0

.Done:
	 movem.l   (a7)+,d2/a2-3
	 rts

.Release:
	 clr.l     _ActiveGuiObject
	 rts

LVICounter:
	 ds.l      1
;fe
;fe
;fe

;fs "Obsolete"
;fs "_RefreshGuiEntry"
_RefreshGuiEntry:  ; a0=GuiEntry
	 movem.l   d3-7/a1,-(a7)

	 move.l    _CurrentDomain,-(a7)

	 lea       ge_Domain(a0),a1
	 move.l    a1,_CurrentDomain

	 bsr       _ClearDomain
	 bsr       _Layout
	 bsr       _Render

	 move.l    (a7)+,_CurrentDomain

	 movem.l   (a7)+,d3-7/a1
	 rts
;fe
;fs "_ChangeGui"
_CurrentGui:
	 ds.l      1
_ChangeGui:        ; a0=GuiTable
	 movem.l   d0-7/a0-6,-(a7)

	 bsr       _ClearGui

	 move.l    a0,d2
	 beq.s     .NewStyleGui

	 tst.l     _CurrentGui
	 bne.s     .Ok
	 move.l    _CurrentGuiObject(pc),d0
	 beq.s     .Ok
	 move.l    d0,a0
	 DOMTDI    GCM_Clear,a0
.Ok:

	 move.l    d2,a0
	 move.l    #_GuiTemp,_CtGuiTemp
	 move.l    #CopEnd,_GuiL1Ptr

	 move.l    a0,_CurrentGui

	 bsr       _GetMinMax

	 moveq     #0,d0
	 move.l    #255,d1

	 move.l    ge_MaxHeight(a0),d2
	 beq.s     .NoMax
	 move.l    d1,d0
	 sub.l     ge_MaxHeight(a0),d0
.NoMax:
	 move.l    d0,_MinGuiPos

	 sub.l     ge_MinHeight(a0),d1
	 move.l    d1,_MaxGuiPos

	 move.l    _GuiPos(pc),d2

	 cmp.l     d0,d2
	 bcc.s     .MinOk
	 move.l    d0,d2
.MinOk:

	 cmp.l     d2,d1
	 bcc.s     .MaxOk
	 move.l    d1,d2
.MaxOk:
	 move.l    d2,_GuiPos

	 bsr       _MoveGui
	 bsr       _Layout
	 bsr       _Render
	 movem.l   (a7)+,d0-7/a0-6
	 rts

.NewStyleGui:
	 clr.l     _CurrentGui
	 move.l    _CurrentGuiObject,a2
	 DOMTDI    GCM_GetMinMax,a2
	 DOMTDI    GCM_Layout,a2
	 DOMTDI    GCM_Render,a2
	 movem.l   (a7)+,d0-7/a0-6
	 rts
;fe
;fs "_MoveGui"
_GuiPos:
	 dc.l      256
_MinGuiPos:
	 dc.l      0
_MaxGuiPos:
	 dc.l      256
_MoveGui:
	 move.l    _GuiPos(pc),d0
	 move.l    d0,d1

	 add.l     #$28,d0
	 move.w    d0,GuiP

	 move.l    _CurrentGui(pc),a0

	 move.l    #2,ge_Domain+gd_Left(a0)
	 move.l    #0,ge_Domain+gd_Top(a0)

	 move.l    #GuiScreenWidth-2,ge_Domain+gd_Right(a0)
	 move.l    #GuiScreenWidth-4,ge_Domain+gd_Width(a0)

	 move.l    #255,d0
	 sub.l     d1,d0
	 move.l    d0,ge_Domain+gd_Height(a0)
	 move.l    d0,ge_Domain+gd_Bottom(a0)
	 rts
;fe
;fs "_ClearGui"
_ClearGui:
	 move.l    a0,-(a7)
	 move.l    _CurrentGui(pc),d0
	 beq.s     .Done
	 move.l    d0,a0

	 lea       ge_Domain(a0),a0
	 move.l    a0,_CurrentDomain
	 bsr       _ClearDomain

.Done:
	 move.l    (a7)+,a0
	 rts
;fe
;fs "_GetMinMax"
_GetMinMax:        ; a0=GuiEntry
	 movem.l   d0-7/a0-6,-(a7)
	 move.l    (a0),a1
	 move.l    (a1),a1
	 jsr       (a1)
	 movem.l   (a7)+,d0-7/a0-6
	 rts
;fe
;fs "_Layout"
_Layout: ; a0=GuiEntry
	 movem.l   d0-7/a0-6,-(a7)
	 move.l    (a0),a1
	 move.l    gc_Layout(a1),d0
	 beq.s     .Done
	 move.l    d0,a3

	 lea       _CurrentDomain(pc),a1
	 move.l    (a1),-(a7)
	 lea       ge_Domain(a0),a2
	 move.l    a2,(a1)

	 jsr       (a3)

	 lea       _CurrentDomain(pc),a1
	 move.l    (a7)+,(a1)

.Done:
	 movem.l   (a7)+,d0-7/a0-6
	 rts
;fe
;fs "_Render"
_Render: ; a0=GuiEntry
	 movem.l   d0-7/a0-6,-(a7)
	 move.l    (a0),a1
	 move.l    gc_Render(a1),d0
	 beq.s     .Done
	 move.l    d0,a3

	 lea       _CurrentDomain(pc),a1
	 move.l    (a1),-(a7)
	 lea       ge_Domain(a0),a2
	 move.l    a2,(a1)

	 jsr       (a3)

	 lea       _CurrentDomain(pc),a1
	 move.l    (a7)+,(a1)

.Done:
	 movem.l   (a7)+,d0-7/a0-6
	 rts
;fe
;fs "_DoClick"
_DoClick: ; a0=GuiEntry d0/d1=X,Y
	 movem.l   d0-1/d3-7/a0-6,-(a7)
	 move.l    (a0),a1
	 move.l    gc_Click(a1),d2
	 ble.s     .Done
	 move.l    d2,a3

	 lea       _CurrentDomain(pc),a1
	 move.l    (a1),-(a7)
	 lea       ge_Domain(a0),a2
	 move.l    a2,(a1)

	 jsr       (a3)

	 lea       _CurrentDomain(pc),a1
	 move.l    (a7)+,(a1)
	 moveq     #0,d2

.Done:
	 movem.l   (a7)+,d0-1/d3-7/a0-6
	 rts
;fe

;fs "Old style classes"
;fs "_HGroup"
_HGroup:
	 dc.l      HGGetMinMax
	 dc.l      HGLayout
	 dc.l      _GRender
	 dc.l      _GClick

HGGetMinMax:
	 move.l    a0,a1
	 lea       ge_Size(a0),a0
	 moveq     #0,d0
	 moveq     #0,d1
	 moveq     #0,d2
	 moveq     #0,d3
	 ;bset      #31,d3
	 not.l     d3
	 sf        d5

.Loop:
	 bsr.s     _GetMinMax

	 add.l     ge_MinWidth(a0),d0
	 move.l    ge_MaxWidth(a0),d4
	 seq       d6
	 or.b      d6,d5
	 add.l     d4,d2

	 move.l    ge_MinHeight(a0),d4
	 cmp.l     d4,d1
	 bcc.s     .MiHOk
	 move.l    d4,d1
.MiHOk:

	 move.l    ge_MaxHeight(a0),d4
	 beq.s     .MaHOk
	 cmp.l     d3,d4
	 bcc.s     .MaHOk
	 move.l    d4,d3
.MaHOk:

	 move.l    ge_Next(a0),a0
	 tst.l     (a0)
	 beq.s     .Done

	 addq.l    #GuiHorSpacing,d0
	 addq.l    #GuiHorSpacing,d2

	 bra.s     .Loop

.Done:
	 tst.b     d5
	 beq.s     .WMaxOk
	 moveq     #0,d2
.WMaxOk:

	 tst.l     d3
	 bpl.s     .HMaxOk
	 moveq     #0,d3
.HMaxOk:

	 lea       ge_Size(a0),a0
	 move.l    a0,ge_Next(a1)
	 movem.l   d0-3,ge_MinWidth(a1)
	 rts

HGLayout:
	 move.l    a0,a6
	 lea       ge_Size(a0),a0
	 move.l    a0,a5
	 moveq     #0,d7

	 move.l    _CurrentDomain(pc),a1
	 move.l    gd_Height(a1),d0
	 move.l    gd_Top(a1),d1
	 move.l    gd_Bottom(a1),d2

.InitLoop:
	 tst.l     (a0)
	 beq.s     .ILOk
	 move.l    d1,ge_Domain+gd_Top(a0)
	 move.l    d2,ge_Domain+gd_Bottom(a0)
	 clr.l     ge_Domain+gd_Width(a0)
	 move.l    d0,ge_Domain+gd_Height(a0)
	 addq.l    #1,d7

	 move.l    ge_Next(a0),a0
	 bra.s     .InitLoop

.ILOk:
	 move.l    gd_Width(a1),d5

	 move.l    d7,d0
	 subq.l    #1,d0
	 add.l     d0,d0
	 sub.l     d0,d5

.BigLoop:
	 tst.l     d7
	 beq.s     .MoreOrLessBigLoop

	 move.l    d5,d4
	 divu      d7,d4
	 ext.l     d4

.MoreOrLessBigLoop:
	 move.l    a5,a0

.Loop:
	 tst.l     ge_Domain+gd_Width(a0)
	 bne.s     .Fixed

	 move.l    ge_MinWidth(a0),d0
	 cmp.l     d0,d4
	 bcc.s     .MinOk
	 move.l    d0,ge_Domain+gd_Width(a0)
	 sub.l     d0,d5
	 subq.l    #1,d7
	 moveq     #0,d1
	 move.l    d1,ge_Domain+gd_Left(a0)
	 bra.s     .BigLoop
.MinOk:

	 move.l    ge_MaxWidth(a0),d0
	 beq.s     .Next

	 cmp.l     d4,d0
	 bcc.s     .Next
	 move.l    d0,ge_Domain+gd_Width(a0)
	 sub.l     d0,d5
	 subq.l    #1,d7
	 moveq     #1,d1
	 move.l    d1,ge_Domain+gd_Left(a0)
	 bra.s     .BigLoop

.Fixed:
	 move.l    ge_Domain+gd_Left(a0),d0
	 eor.l     d1,d0
	 beq.s     .Next

	 move.l    ge_Domain+gd_Width(a0),d0
	 add.l     d5,d0
	 move.l    d7,d2
	 addq.l    #1,d2
	 divu      d2,d0
	 ext.l     d0

	 move.l    ge_MinWidth(a0),d2
	 cmp.l     d2,d0
	 bcs.s     .Next

	 move.l    ge_MaxWidth(a0),d2
	 beq.s     .AhhR‚aah
	 cmp.l     d0,d2
	 bcs.s     .Next

.AhhR‚aah:
	 add.l     ge_Domain+gd_Width(a0),d5
	 clr.l     ge_Domain+gd_Width(a0)
	 addq.l    #1,d7
	 move.l    d0,d4
	 bra.s     .MoreOrLessBigLoop

.Next:
	 move.l    ge_Next(a0),a0
	 tst.l     (a0)
	 bne.s     .Loop

.Ok:

	 move.l    a5,a0
	 move.l    gd_Left(a1),d0

.PosLoop:
	 move.l    d0,ge_Domain+gd_Left(a0)

	 move.l    ge_Domain+gd_Width(a0),d1
	 bne.s     .PLWOk
	 move.l    d4,d1
	 move.l    d4,ge_Domain+gd_Width(a0)
.PLWOk:

	 add.l     d1,d0
	 move.l    d0,ge_Domain+gd_Right(a0)
	 addq.l    #GuiHorSpacing,d0

	 bsr       _Layout

	 move.l    ge_Next(a0),a0
	 tst.l     (a0)
	 bne.s     .PosLoop

	 rts
;fe
;fs "_VGroup"
_VGroup:
	 dc.l      VGGetMinMax
	 dc.l      VGLayout
	 dc.l      _GRender
	 dc.l      _GClick

VGGetMinMax:
	 move.l    a0,a1
	 lea       ge_Size(a0),a0
	 moveq     #0,d0
	 moveq     #0,d1
	 moveq     #0,d2
	 ;bset      #31,d2
	 not.l     d2
	 moveq     #0,d3
	 sf        d5

.Loop:
	 bsr.s     _GetMinMax

	 add.l     ge_MinHeight(a0),d1
	 move.l    ge_MaxHeight(a0),d4
	 seq       d6
	 or.b      d6,d5
	 add.l     d4,d3

	 move.l    ge_MinWidth(a0),d4
	 cmp.l     d4,d0
	 bcc.s     .MiWOk
	 move.l    d4,d0
.MiWOk:

	 move.l    ge_MaxWidth(a0),d4
	 beq.s     .MaWOk
	 cmp.l     d2,d4
	 bcc.s     .MaWOk
	 move.l    d4,d2
.MaWOk:

	 move.l    ge_Next(a0),a0
	 tst.l     (a0)
	 beq.s     .Done

	 addq.l    #GuiVerSpacing,d1
	 addq.l    #GuiVerSpacing,d3

	 bra.s     .Loop

.Done:
	 tst.b     d5
	 beq.s     .HMaxOk
	 moveq     #0,d3
.HMaxOk:

	 tst.l     d2
	 bpl.s     .WMaxOk
	 moveq     #0,d2
.WMaxOk:

	 lea       ge_Size(a0),a0
	 move.l    a0,ge_Next(a1)
	 movem.l   d0-3,ge_MinWidth(a1)
	 rts

VGLayout:
	 move.l    a0,a6
	 lea       ge_Size(a0),a0
	 move.l    a0,a5
	 moveq     #0,d7

	 move.l    _CurrentDomain(pc),a1
	 move.l    gd_Width(a1),d0
	 move.l    gd_Left(a1),d1
	 move.l    gd_Right(a1),d2

.InitLoop:
	 tst.l     (a0)
	 beq.s     .ILOk
	 move.l    d1,ge_Domain+gd_Left(a0)
	 move.l    d2,ge_Domain+gd_Right(a0)
	 move.l    d0,ge_Domain+gd_Width(a0)
	 clr.l     ge_Domain+gd_Height(a0)
	 addq.l    #1,d7

	 move.l    ge_Next(a0),a0
	 bra.s     .InitLoop

.ILOk:
	 move.l    gd_Height(a1),d5

	 move.l    d7,d0
	 subq.l    #1,d0
	 sub.l     d0,d5

.BigLoop:
	 tst.l     d7
	 beq.s     .MoreOrLessBigLoop

	 move.l    d5,d4
	 divu      d7,d4
	 ext.l     d4

.MoreOrLessBigLoop:
	 move.l    a5,a0

.Loop:
	 tst.l     ge_Domain+gd_Height(a0)
	 bne.s     .Fixed

	 move.l    ge_MinHeight(a0),d0
	 cmp.l     d0,d4
	 bcc.s     .MinOk
	 move.l    d0,ge_Domain+gd_Height(a0)
	 sub.l     d0,d5
	 subq.l    #1,d7
	 moveq     #0,d1
	 move.l    d1,ge_Domain+gd_Top(a0)
	 bra.s     .BigLoop
.MinOk:

	 move.l    ge_MaxHeight(a0),d0
	 beq.s     .Next

	 cmp.l     d4,d0
	 bcc.s     .Next
	 move.l    d0,ge_Domain+gd_Height(a0)
	 sub.l     d0,d5
	 subq.l    #1,d7
	 moveq     #1,d1
	 move.l    d1,ge_Domain+gd_Top(a0)
	 bra.s     .BigLoop

.Fixed:
	 move.l    ge_Domain+gd_Top(a0),d0
	 eor.l     d1,d0
	 beq.s     .Next

	 move.l    ge_Domain+gd_Height(a0),d0
	 add.l     d5,d0
	 move.l    d7,d2
	 addq.l    #1,d2
	 divu      d2,d0
	 ext.l     d0

	 move.l    ge_MinHeight(a0),d2
	 cmp.l     d2,d0
	 bcs.s     .Next

	 move.l    ge_MaxHeight(a0),d2
	 beq.s     .AhhR‚aah
	 cmp.l     d0,d2
	 bcs.s     .Next

.AhhR‚aah:
	 add.l     ge_Domain+gd_Height(a0),d5
	 clr.l     ge_Domain+gd_Height(a0)
	 addq.l    #1,d7
	 move.l    d0,d4
	 bra.s     .MoreOrLessBigLoop

.Next:
	 move.l    ge_Next(a0),a0
	 tst.l     (a0)
	 bne.s     .Loop

.Ok:

	 move.l    a5,a0
	 move.l    gd_Top(a1),d0

.PosLoop:
	 move.l    d0,ge_Domain+gd_Top(a0)

	 move.l    ge_Domain+gd_Height(a0),d1
	 bne.s     .PLHOk
	 move.l    d4,d1
	 move.l    d4,ge_Domain+gd_Height(a0)
.PLHOk:

	 add.l     d1,d0
	 move.l    d0,ge_Domain+gd_Bottom(a0)
	 addq.l    #GuiVerSpacing,d0

	 bsr       _Layout

	 move.l    ge_Next(a0),a0
	 tst.l     (a0)
	 bne.s     .PosLoop

	 rts
;fe
;fs "_GRender"
_GRender:
	 lea       ge_Size(a0),a0

.Loop:
	 bsr       _Render

	 move.l    ge_Next(a0),a0
	 tst.l     (a0)
	 bne.s     .Loop

	 rts
;fe
;fs "_GClick"
_GClick:
	 lea       ge_Size(a0),a0

.Loop:
	 cmp2.l    ge_Domain+gd_Left(a0),d0
	 bcs.s     .NoClick

	 cmp2.l    ge_Domain+gd_Top(a0),d1
	 bcc.s     .Bingo

.NoClick:
	 move.l    ge_Next(a0),a0
	 tst.l     (a0)
	 bne.s     .Loop
	 rts

.Bingo:
	 bsr.s     _DoClick
	 tst.l     d2
	 bmi.s     .NoClick
	 rts
;fe
;fs "_Button"
_Button:
	 dc.l      BGetMinMax
	 dc.l      0
	 dc.l      BRender
	 dc.l      BClick

BGetMinMax:
	 move.l    ge_Data(a0),a1
	 move.l    a1,a2
.StrLen:
	 tst.b     (a1)+
	 bne.s     .StrLen
	 sub.l     a2,a1
	 move.l    a1,d0

	 clr.l     ge_MaxWidth(a0)
	 lsl.l     #3,d0
	 move.l    d0,ge_MinWidth(a0)

	 subq.l    #8,d0
	 move.l    d0,ge_Temp(a0)

	 moveq     #12,d0
	 move.l    d0,ge_MinHeight(a0)
	 move.l    d0,ge_MaxHeight(a0)

	 lea       ge_Size(a0),a1
	 move.l    a1,ge_Next(a0)
	 rts

BRender:
	 move.l    _CurrentDomain(pc),a1
	 moveq     #0,d0
	 moveq     #0,d1
	 move.l    gd_Width(a1),d2
	 move.l    gd_Height(a1),d3
	 sf        d4
	 bsr       _DrawBevelBox

	 sub.l     ge_Temp(a0),d2
	 lsr.l     #1,d2
	 move.l    d2,d6
	 moveq     #2,d7
	 move.l    ge_Data(a0),a5
	 moveq     #1,d4
	 moveq     #0,d5
	 bsr       _DrawText
	 rts

BClick:
	 move.l    a0,_ActiveGuiEntry
	 lea       BHandler(pc),a1
	 move.l    a1,_ActiveThingHandler

	 sf        BPressed

BHandler:
	 tst.b     _LMBState
	 beq.s     .Desactivate

	 move.b    BPressed(pc),d2

	 cmp2.l    ge_Domain+gd_Left(a0),d0
	 scc       d0

	 cmp2.l    ge_Domain+gd_Top(a0),d1
	 scc       d1

	 and.b     d1,d0
	 move.b    d0,BPressed

	 eor.b     d0,d2
	 beq.s     .Done

	 tst.b     d0
	 bne.s     .Press

.Release:
	 move.l    _CurrentDomain(pc),a1
	 moveq     #0,d3
	 moveq     #2,d4
	 moveq     #1,d5
	 movem.l   gd_Width(a1),d6-7
	 subq.l    #4,d6
	 subq.l    #2,d7
	 bsr       _DrawRectangle

	 bra       BRender

.Press:
	 move.l    _CurrentDomain(pc),a1
	 moveq     #3,d3
	 moveq     #2,d4
	 moveq     #1,d5
	 movem.l   gd_Width(a1),d6-7
	 subq.l    #4,d6
	 subq.l    #2,d7
	 bsr       _DrawRectangle

	 move.l    _CurrentDomain(pc),a1
	 moveq     #0,d0
	 moveq     #0,d1
	 move.l    gd_Width(a1),d2
	 move.l    gd_Height(a1),d3
	 st        d4
	 bsr       _DrawBevelBox

	 sub.l     ge_Temp(a0),d2
	 lsr.l     #1,d2
	 move.l    d2,d6
	 moveq     #2,d7
	 move.l    ge_Data(a0),a5
	 moveq     #1,d4
	 moveq     #0,d5
	 bsr       _DrawText
	 rts

.Desactivate:
	 clr.l     _ActiveThingHandler

	 tst.b     BPressed
	 beq.s     .Done

	 bsr.s     .Release
	 move.l    ge_Hook(a0),d0
	 beq.s     .Done
	 move.l    d0,a1
	 jmp       (a1)

.Done:
	 rts

BPressed:
	 ds.b      1
	 even
;fe
;fs "_SmallButton"
_SmallButton:
	 dc.l      SBGetMinMax
	 dc.l      SBLayout
	 dc.l      SBRender
	 dc.l      SBClick

SBGetMinMax:
	 moveq     #16,d0
	 move.l    d0,ge_MinWidth(a0)

	 tst.l     ge_Data3(a0)
	 beq.s     .Ok
	 moveq     #0,d0
.Ok:

	 move.l    d0,ge_MaxWidth(a0)

	 moveq     #12,d0
	 move.l    d0,ge_MinHeight(a0)
	 move.l    d0,ge_MaxHeight(a0)

	 lea       ge_Size(a0),a1
	 move.l    a1,ge_Next(a0)
	 rts

SBLayout:
	 move.l    ge_Domain+gd_Width(a0),d0
	 subq.l    #8,d0
	 lsr.l     #1,d0
	 move.l    d0,ge_Temp(a0)
	 rts

SBRender:
	 move.l    _CurrentDomain(pc),a1
	 moveq     #0,d0
	 moveq     #0,d1
	 move.l    gd_Width(a1),d2
	 move.l    gd_Height(a1),d3
	 sf        d4
	 bsr       _DrawBevelBox

	 move.l    ge_Temp(a0),d6
	 moveq     #2,d7
	 move.l    ge_Data(a0),d5
	 moveq     #1,d4
	 bsr       _DrawChar
	 rts

SBClick:
	 move.l    a0,_ActiveGuiEntry
	 lea       SBHandler(pc),a1
	 move.l    a1,_ActiveThingHandler

	 sf        SBPressed

SBHandler:
	 tst.b     _LMBState
	 beq.s     .Desactivate

	 move.b    SBPressed(pc),d2
	 beq.s     .Glonk
	 move.l    ge_Data2(a0),d3
	 beq.s     .Glonk
	 move.l    d3,a1
	 movem.l   d0-2/a0,-(a7)
	 jsr       (a1)
	 movem.l   (a7)+,d0-2/a0
.Glonk:

	 cmp2.l    ge_Domain+gd_Left(a0),d0
	 scc       d0

	 cmp2.l    ge_Domain+gd_Top(a0),d1
	 scc       d1

	 and.b     d1,d0
	 move.b    d0,SBPressed

	 eor.b     d0,d2
	 beq.s     .Done

	 tst.b     d0
	 bne.s     .Press

.Release:
	 move.l    _CurrentDomain(pc),a1
	 moveq     #0,d3
	 moveq     #2,d4
	 moveq     #1,d5
	 movem.l   gd_Width(a1),d6-7
	 subq.l    #4,d6
	 subq.l    #2,d7
	 bsr       _DrawRectangle

	 bra       SBRender

.Press:
	 move.l    _CurrentDomain(pc),a1
	 moveq     #3,d3
	 moveq     #2,d4
	 moveq     #1,d5
	 movem.l   gd_Width(a1),d6-7
	 subq.l    #4,d6
	 subq.l    #2,d7
	 bsr       _DrawRectangle

	 move.l    _CurrentDomain(pc),a1
	 moveq     #0,d0
	 moveq     #0,d1
	 move.l    gd_Width(a1),d2
	 move.l    gd_Height(a1),d3
	 st        d4
	 bsr       _DrawBevelBox

	 move.l    ge_Temp(a0),d6
	 moveq     #2,d7
	 move.l    ge_Data(a0),d5
	 moveq     #1,d4
	 bsr       _DrawChar
	 rts

.Desactivate:
	 clr.l     _ActiveThingHandler

	 tst.b     SBPressed
	 beq.s     .Done

	 bsr.s     .Release
	 move.l    ge_Hook(a0),d0
	 beq.s     .Done
	 move.l    d0,a1
	 jmp       (a1)

.Done:
	 rts

SBPressed:
	 ds.b      1
	 even
;fe
;fs "_DragBar"
_DragBar:
	 dc.l      BGetMinMax
	 dc.l      0
	 dc.l      BRender
	 dc.l      DBClick

DBClick:
	 move.l    d0,_MinMouseX
	 move.l    d0,_MaxMouseX

	 move.l    a0,_ActiveGuiEntry
	 lea       DBHandler(pc),a1
	 move.l    a1,_ActiveThingHandler

	 move.l    d1,DBOffset
	 move.w    GuiSelP,d0
	 sub.w     GuiP,d0
	 move.w    d0,DBSelOffset

	 move.l    d1,d0
	 add.l     _MinGuiPos(pc),d0
	 move.l    d0,_MinMouseY

	 add.l     _MaxGuiPos(pc),d1
	 move.l    d1,_MaxMouseY

	 lea       DBMouseHook(pc),a0
	 move.l    a0,_MouseHook

	 ;move.l    #CopEnd,_GuiL1Ptr
	 rts

DBHandler:
	 tst.b     _LMBState
	 bne.s     .Ok

	 clr.l     _MouseHook
	 clr.l     _ActiveThingHandler

	 clr.l     _MinMouseX
	 clr.l     _MinMouseY

	 move.l    #GuiScreenWidth,_MaxMouseX
	 move.l    #256,_MaxMouseY

	 bsr       _ClearGui
	 bsr       _MoveGui
	 move.l    _CurrentGui(pc),a0
	 bsr       _Layout
	 bsr       _Render

.Ok:
	 rts

DBMouseHook:
	 move.l    _MouseY(pc),d0
	 sub.l     DBOffset(pc),d0
	 move.l    d0,_GuiPos

	 add.l     #$28,d0
	 move.w    d0,GuiP

	 add.w     DBSelOffset,d0
	 move.w    d0,GuiSelP
	 rts

DBOffset:
	 ds.l      1
DBSelOffset:
	 ds.w      1
;fe
;fs "_Text"
_Text:
	 dc.l      TGetMinMax
	 dc.l      0
	 dc.l      TRender
	 dc.l      0

TGetMinMax:
	 move.l    ge_Data(a0),a1
	 move.l    ge_Data2(a0),d0
	 beq.s     .TrucEtTout

	 move.l    a0,-(a7)
	 move.l    (AbsExecBase).w,a6
	 move.l    a1,a0
	 move.l    d0,a1
	 lea       TPutChar(pc),a2
	 lea       _StrBuf,a3
	 CALL      RawDoFmt
	 move.l    (a7)+,a0
	 lea       _StrBuf,a1
	 lea       CustomBase,a6

	 moveq     #0,d0

.TrucEtTout:
	 moveq     #0,d1

.LLoop:
	 addq.l    #1,d0
	 move.l    a1,a2

.CLoop:
	 move.b    (a2)+,d2
	 beq.s     .CLDone
	 cmp.b     #$a,d2
	 bne.s     .CLoop
.CLDone:

	 move.l    a2,d3
	 sub.l     a1,d3

	 cmp.l     d3,d1
	 bcc.s     .Ba‚‚‚h
	 move.l    d3,d1
.Ba‚‚‚h:

	 move.l    a2,a1
	 tst.b     d2
	 bne.s     .LLoop

	 lsl.l     #3,d0
	 move.l    d0,ge_MinHeight(a0)
	 move.l    d0,ge_MaxHeight(a0)

	 subq.l    #1,d1
	 lsl.l     #3,d1

	 clr.l     ge_MaxWidth(a0)
	 move.l    d1,ge_MinWidth(a0)

	 lea       ge_Size(a0),a1
	 move.l    a1,ge_Next(a0)
	 rts

TRender:
	 move.l    _CurrentDomain(pc),a1
	 move.l    gd_Width(a1),d1
	 move.l    ge_Data(a0),a5
	 moveq     #0,d7
	 move.l    ge_Data2(a0),d0
	 beq.s     .LLoop

	 movem.l   d1/a1,-(a7)
	 move.l    (AbsExecBase).w,a6
	 move.l    a5,a0
	 move.l    d0,a1
	 lea       TPutChar(pc),a2
	 lea       _StrBuf,a3
	 CALL      RawDoFmt
	 lea       _StrBuf,a5
	 lea       CustomBase,a6
	 movem.l   (a7)+,d1/a1

.LLoop:
	 move.l    a5,a1

.CLoop:
	 move.b    (a1)+,d2
	 beq.s     .CLDone
	 cmp.b     #$a,d2
	 bne.s     .CLoop
.CLDone:
	 move.l    a1,d5
	 sub.l     a5,d5
	 subq.l    #1,d5
	 beq.s     .Poisse

	 move.l    d5,d0
	 lsl.l     #3,d0
	 move.l    d1,d6
	 sub.l     d0,d6
	 lsr.l     #1,d6

	 moveq     #1,d4
	 bsr       _DrawText

.Poisse:
	 move.l    a1,a5
	 addq.l    #8,d7

	 tst.b     d2
	 bne.s     .LLoop

	 rts

TPutChar:
	 move.b    d0,(a3)+
	 rts
;fe
;fs "_FText"
_FText:
	 dc.l      FTGetMinMax
	 dc.l      0
	 dc.l      TRender
	 dc.l      0

FTGetMinMax:
	 bsr.s     TGetMinMax
	 move.l    ge_MinWidth(a0),ge_MaxWidth(a0)
	 rts
;fe
;fs "_HProp"
_HProp:
	 dc.l      HPGetMinMax
	 dc.l      HPLayout
	 dc.l      HPRender
	 dc.l      HPClick

HPGetMinMax:
	 moveq     #50,d0
	 move.l    d0,ge_MinWidth(a0)
	 moveq     #0,d0
	 move.l    d0,ge_MaxWidth(a0)

	 moveq     #12,d0
	 move.l    d0,ge_MinHeight(a0)
	 move.l    d0,ge_MaxHeight(a0)

	 lea       ge_Size(a0),a1
	 move.l    a1,ge_Next(a0)
	 rts

HPLayout:
	 move.l    ge_Domain+gd_Width(a0),d0
	 sub.l     #8,d0
	 move.l    d0,d1
	 move.l    ge_Data2(a0),d2

	 move.l    ge_Data3(a0),d3
	 cmp.l     d2,d3
	 bcc.s     .FullKnob

	 mulu      d3,d1
	 divu      d2,d1
	 ext.l     d1

	 cmp.l     #14,d1
	 bcc.s     .FullKnob
	 moveq     #14,d1

.FullKnob:
	 move.l    d1,ge_Temp3(a0)

	 sub.l     d1,d0
	 move.l    d0,ge_Temp(a0)

HPCalcKnobPos:
	 movem.l   ge_Data2(a0),d1-2
	 move.l    ge_Data(a0),d0
	 bpl.s     .MinOk
	 moveq     #0,d0
.MinOk:

	 move.l    d1,d3
	 sub.l     d2,d3
	 bpl.s     .Ok
	 moveq     #0,d3
.Ok:

	 cmp.l     d0,d3
	 bcc.s     .MaxOk
	 move.l    d3,d0
.MaxOk:

	 move.l    d0,ge_Data(a0)

	 mulu      ge_Temp+2(a0),d0
	 sub.l     d2,d1
	 beq.s     .FullKnob

	 divu      d1,d0
	 ext.l     d0

	 move.l    ge_Temp(a0),d1
	 cmp.l     d0,d1
	 bcc.s     .MaxPosOk
	 move.l    d1,d0
.MaxPosOk:

	 addq.l    #4,d0
	 move.l    d0,ge_Temp2(a0)
	 rts

.FullKnob:
	 moveq     #2,d0
	 move.l    d0,ge_Temp2(a0)
	 rts

HPRender:
	 moveq     #0,d0
	 moveq     #0,d1
	 movem.l   ge_Domain+gd_Width(a0),d2-3
	 sf        d4
	 bsr.s     _DrawBevelBox

	 moveq     #2,d0
	 moveq     #1,d1
	 movem.l   ge_Domain+gd_Width(a0),d2-3
	 subq.l    #4,d2
	 subq.l    #2,d3
	 st        d4
	 bsr.s     _DrawBevelBox

HPRenderKnob:
	 moveq     #2,d1
	 moveq     #8,d3
	 movem.l   ge_Temp2(a0),d0/d2
	 sf        d4
	 bsr.s     _DrawBevelBox

	 moveq     #4,d1
	 move.l    ge_Temp3(a0),d0
	 subq.l    #6,d0
	 lsr.l     #1,d0
	 add.l     ge_Temp2(a0),d0
	 bra.s     _DrawPropHole

HPRenderKnobSelected:
	 moveq     #2,d1
	 moveq     #8,d3
	 movem.l   ge_Temp2(a0),d0/d2
	 sf        d4
	 bsr.s     _DrawBevelBox

	 moveq     #3,d5
	 moveq     #6,d7
	 movem.l   ge_Temp2(a0),d4/d6
	 addq.l    #2,d4
	 subq.l    #4,d6
	 moveq     #3,d3
	 bsr.s     _DrawRectangle

	 moveq     #4,d1
	 move.l    ge_Temp3(a0),d0
	 subq.l    #6,d0
	 lsr.l     #1,d0
	 add.l     ge_Temp2(a0),d0
	 bra.s     _DrawPropHole

HPClearKnob:
	 moveq     #2,d5
	 moveq     #8,d7
	 movem.l   ge_Temp2(a0),d4/d6
	 moveq     #0,d3
	 bra.s     _DrawRectangle

HPClick:
	 move.l    d0,d3
	 sub.l     ge_Domain+gd_Left(a0),d0

	 move.l    ge_Temp2(a0),d2
	 cmp.l     d2,d0
	 bcs.s     .BeforeKnob
	 add.l     ge_Temp3(a0),d2
	 cmp.l     d2,d0
	 bcc.s     .AfterKnob

	 sub.l     ge_Temp2(a0),d3
	 move.l    d3,HPOffset

	 add.l     _GuiPos(pc),d1
	 move.l    d1,_MinMouseY
	 move.l    d1,_MaxMouseY

	 addq.l    #4,d3
	 move.l    d3,d1

	 move.l    d3,_MinMouseX

	 add.l     ge_Temp(a0),d1
	 move.l    d1,_MaxMouseX

	 move.l    a0,_ActiveGuiEntry
	 lea       HPHandler(pc),a1
	 move.l    a1,_ActiveThingHandler
	 bra       HPRenderKnobSelected

.BeforeKnob:
	 move.l    ge_Data3(a0),d1
	 subq.l    #1,d1
	 bne.s     .BKOkIncr
	 moveq     #1,d1
.BKOkIncr:

	 move.l    ge_Data(a0),d0
	 sub.l     d1,d0

.KnobOk:
	 move.l    d0,ge_Data(a0)

	 bsr       HPClearKnob

	 bsr       HPCalcKnobPos

	 lea       HPWaitHandler(pc),a1
	 move.l    a1,_ActiveThingHandler

	 move.l    ge_Hook(a0),d0
	 beq       HPRenderKnob
	 move.l    d0,a1
	 move.l    ge_Data(a0),d0

	 move.l    a0,-(a7)
	 jsr       (a1)
	 move.l    (a7)+,a0

	 bra       HPRenderKnob

.AfterKnob:
	 move.l    ge_Data3(a0),d1
	 subq.l    #1,d1
	 bne.s     .AKOkIncr
	 moveq     #1,d1
.AKOkIncr:

	 move.l    ge_Data(a0),d0
	 add.l     d1,d0

	 bra.s     .KnobOk

HPWaitHandler:
	 tst.b     _LMBState
	 bne.s     .Done
	 clr.l     _ActiveThingHandler
.Done:
	 rts

HPHandler:
	 tst.b     _LMBState
	 beq.s     .Release

	 sub.l     HPOffset(pc),d0

	 cmp.l     ge_Temp2(a0),d0
	 beq.s     .Done

	 bsr.s     HPClearKnob
	 move.l    d0,ge_Temp2(a0)
	 bsr.s     HPRenderKnobSelected

	 move.l    ge_Temp2(a0),d0
	 subq.l    #4,d0
	 move.l    ge_Data2(a0),d1
	 sub.l     ge_Data3(a0),d1
	 mulu      d1,d0
	 move.l    ge_Temp(a0),d1
	 divu      d1,d0
	 ext.l     d0

	 move.l    d0,ge_Data(a0)

	 move.l    ge_Hook(a0),d1
	 beq.s     .Done
	 move.l    d1,a1
	 jmp       (a1)

.Done:
	 rts
.Release:
	 clr.l     _MinMouseX
	 clr.l     _MinMouseY

	 move.l    #GuiScreenWidth,_MaxMouseX
	 move.l    #256,_MaxMouseY

	 clr.l     _ActiveThingHandler
	 clr.l     _ActiveGuiEntry
	 bsr.s     HPClearKnob
	 bra.s     HPRenderKnob

HPOffset:
	 ds.l      1
;fe
;fs "_VProp"
_VProp:
	 dc.l      VPGetMinMax
	 dc.l      VPLayout
	 dc.l      VPRender
	 dc.l      VPClick

VPGetMinMax:
	 moveq     #19,d0
	 move.l    d0,ge_MinHeight(a0)
	 moveq     #0,d0
	 move.l    d0,ge_MaxHeight(a0)

	 moveq     #20,d0
	 move.l    d0,ge_MinWidth(a0)
	 move.l    d0,ge_MaxWidth(a0)

	 lea       ge_Size(a0),a1
	 move.l    a1,ge_Next(a0)
	 rts

VPLayout:
	 move.l    ge_Domain+gd_Height(a0),d0
	 sub.l     #4,d0
	 move.l    d0,d1
	 move.l    ge_Data2(a0),d2

	 move.l    ge_Data3(a0),d3
	 cmp.l     d2,d3
	 bcc.s     .FullKnob

	 mulu      d3,d1
	 divu      d2,d1
	 ext.l     d1

	 cmp.l     #8,d1
	 bcc.s     .FullKnob
	 moveq     #8,d1

.FullKnob:
	 move.l    d1,ge_Temp3(a0)

	 sub.l     d1,d0
	 move.l    d0,ge_Temp(a0)

VPCalcKnobPos:
	 movem.l   ge_Data2(a0),d1-2
	 move.l    ge_Data(a0),d0
	 bpl.s     .MinOk
	 moveq     #0,d0
.MinOk:

	 move.l    d1,d3
	 sub.l     d2,d3
	 bpl.s     .Ok
	 moveq     #0,d3
.Ok:

	 cmp.l     d0,d3
	 bcc.s     .MaxOk
	 move.l    d3,d0
.MaxOk:

	 move.l    d0,ge_Data(a0)

	 mulu      ge_Temp+2(a0),d0
	 sub.l     d2,d1
	 beq.s     .FullKnob

	 divu      d1,d0
	 ext.l     d0

	 move.l    ge_Temp(a0),d1
	 cmp.l     d0,d1
	 bcc.s     .MaxPosOk
	 move.l    d1,d0
.MaxPosOk:

	 addq.l    #2,d0
	 move.l    d0,ge_Temp2(a0)
	 rts

.FullKnob:
	 moveq     #2,d0
	 move.l    d0,ge_Temp2(a0)
	 rts

VPRender:
	 moveq     #0,d0
	 moveq     #0,d1
	 movem.l   ge_Domain+gd_Width(a0),d2-3
	 sf        d4
	 bsr.s     _DrawBevelBox

	 moveq     #2,d0
	 moveq     #1,d1
	 movem.l   ge_Domain+gd_Width(a0),d2-3
	 subq.l    #4,d2
	 subq.l    #2,d3
	 st        d4
	 bsr.s     _DrawBevelBox

VPRenderKnob:
	 moveq     #4,d0
	 move.l    #12,d2
	 movem.l   ge_Temp2(a0),d1/d3
	 sf        d4
	 bsr.s     _DrawBevelBox

	 moveq     #7,d0
	 move.l    ge_Temp3(a0),d1
	 subq.l    #4,d1
	 lsr.l     #1,d1
	 add.l     ge_Temp2(a0),d1
	 bra.s     _DrawPropHole

VPRenderKnobSelected:
	 moveq     #4,d0
	 moveq     #12,d2
	 movem.l   ge_Temp2(a0),d1/d3
	 sf        d4
	 bsr.s     _DrawBevelBox

	 moveq     #6,d4
	 moveq     #8,d6
	 movem.l   ge_Temp2(a0),d5/d7
	 addq.l    #1,d5
	 subq.l    #2,d7
	 moveq     #3,d3
	 bsr.s     _DrawRectangle

	 moveq     #7,d0
	 move.l    ge_Temp3(a0),d1
	 subq.l    #4,d1
	 lsr.l     #1,d1
	 add.l     ge_Temp2(a0),d1
	 bra.s     _DrawPropHole

VPClearKnob:
	 moveq     #4,d4
	 moveq     #12,d6
	 movem.l   ge_Temp2(a0),d5/d7
	 moveq     #0,d3
	 bra.s     _DrawRectangle

VPClick:
	 move.l    d1,d3
	 sub.l     ge_Domain+gd_Top(a0),d1

	 move.l    ge_Temp2(a0),d2
	 cmp.l     d2,d1
	 bcs.s     .BeforeKnob
	 add.l     ge_Temp3(a0),d2
	 cmp.l     d2,d1
	 bcc.s     .AfterKnob

	 sub.l     ge_Temp2(a0),d3
	 move.l    d3,VPOffset

	 move.l    d0,_MinMouseX
	 move.l    d0,_MaxMouseX

	 add.l     _GuiPos(pc),d3
	 addq.l    #2,d3
	 move.l    d3,d1
	 move.l    d3,_MinMouseY

	 add.l     ge_Temp(a0),d1
	 move.l    d1,_MaxMouseY

	 move.l    a0,_ActiveGuiEntry
	 lea       VPHandler(pc),a1
	 move.l    a1,_ActiveThingHandler
	 bra       VPRenderKnobSelected

.BeforeKnob:
	 move.l    ge_Data3(a0),d1
	 subq.l    #1,d1
	 bne.s     .BKOkIncr
	 moveq     #1,d1
.BKOkIncr:

	 move.l    ge_Data(a0),d0
	 sub.l     d1,d0

.KnobOk:
	 move.l    d0,ge_Data(a0)

	 bsr       VPClearKnob

	 bsr       VPCalcKnobPos

	 lea       VPWaitHandler(pc),a1
	 move.l    a1,_ActiveThingHandler

	 move.l    ge_Hook(a0),d0
	 beq       VPRenderKnob
	 move.l    d0,a1
	 move.l    ge_Data(a0),d0

	 move.l    a0,-(a7)
	 jsr       (a1)
	 move.l    (a7)+,a0

	 bra       VPRenderKnob

.AfterKnob:
	 move.l    ge_Data3(a0),d1
	 subq.l    #1,d1
	 bne.s     .AKOkIncr
	 moveq     #1,d1
.AKOkIncr:

	 move.l    ge_Data(a0),d0
	 add.l     d1,d0

	 bra.s     .KnobOk

VPWaitHandler:
	 tst.b     _LMBState
	 bne.s     .Done
	 clr.l     _ActiveThingHandler
.Done:
	 rts

VPHandler:
	 tst.b     _LMBState
	 beq.s     .Release

	 sub.l     VPOffset(pc),d1

	 cmp.l     ge_Temp2(a0),d1
	 beq.s     .Done

	 bsr.s     VPClearKnob
	 move.l    d1,ge_Temp2(a0)
	 bsr.s     VPRenderKnobSelected

	 move.l    ge_Temp2(a0),d1
	 subq.l    #2,d1
	 move.l    ge_Data2(a0),d0
	 sub.l     ge_Data3(a0),d0
	 mulu      d0,d1
	 move.l    ge_Temp(a0),d0
	 divu      d0,d1
	 ext.l     d1
	 move.l    d1,ge_Data(a0)

	 move.l    d1,d0
	 move.l    ge_Hook(a0),d1
	 beq.s     .Done
	 move.l    d1,a1
	 jmp       (a1)

.Done:
	 rts
.Release:
	 clr.l     _MinMouseX
	 clr.l     _MinMouseY

	 move.l    #GuiScreenWidth,_MaxMouseX
	 move.l    #256,_MaxMouseY

	 clr.l     _ActiveThingHandler
	 clr.l     _ActiveGuiEntry
	 bsr.s     VPClearKnob
	 bra.s     VPRenderKnob

VPOffset:
	 ds.l      1
;fe
;fs "_HScroller"
_HScroller:
	 dc.l      HSCGetMinMax
	 dc.l      HSCLayout
	 dc.l      HSCRender
	 dc.l      HSCClick

HSCGetMinMax:
	 moveq     #0,d0
	 move.l    _CtGuiTemp(pc),a1
	 move.l    a1,ge_Temp(a0)
	 lea       ge_Size*7(a1),a2
	 move.l    a2,_CtGuiTemp

	 move.l    #_HGroup,(a1)
	 lea       ge_Size(a1),a1

	 move.l    a1,ge_Temp2(a0)
	 move.l    #_HProp,(a1)
	 move.l    ge_Data(a0),ge_Data(a1)
	 move.l    ge_Data2(a0),ge_Data2(a1)
	 move.l    ge_Data3(a0),ge_Data3(a1)
	 move.l    a0,ge_ID(a1)
	 move.l    #HSCHook,ge_Hook(a1)

	 lea       ge_Size(a1),a1
	 move.l    #_HSpacingEater,(a1)

	 lea       ge_Size(a1),a1
	 move.l    #_SmallButton,(a1)
	 move.l    #$8e,ge_Data(a1)
	 move.l    a0,ge_ID(a1)
	 move.l    #HSCRelHook,ge_Hook(a1)
	 move.l    #HSCDecrHook,ge_Data2(a1)
	 move.l    d0,ge_Data3(a1)

	 lea       ge_Size(a1),a1
	 move.l    #_HSpacingEater,(a1)

	 lea       ge_Size(a1),a1
	 move.l    #_SmallButton,(a1)
	 move.l    #$8d,ge_Data(a1)
	 move.l    a0,ge_ID(a1)
	 move.l    #HSCRelHook,ge_Hook(a1)
	 move.l    #HSCIncrHook,ge_Data2(a1)
	 move.l    d0,ge_Data3(a1)

	 lea       ge_Size(a1),a1
	 clr.l     (a1)

	 move.l    a0,a1
	 move.l    ge_Temp(a1),a0
	 bsr       _GetMinMax

	 move.l    ge_MinWidth(a0),ge_MinWidth(a1)
	 move.l    ge_MaxWidth(a0),ge_MaxWidth(a1)
	 move.l    ge_MinHeight(a0),ge_MinHeight(a1)
	 move.l    ge_MaxHeight(a0),ge_MaxHeight(a1)

	 lea       ge_Size(a1),a0
	 move.l    a0,ge_Next(a1)
	 rts

HSCLayout:
	 move.l    a0,a2
	 move.l    ge_Temp2(a0),a3
	 movem.l   ge_Data(a0),d0-2
	 movem.l   d0-2,ge_Data(a3)

	 move.l    a0,a1
	 move.l    ge_Temp(a1),a0

	 movem.l   ge_Domain(a1),d0-5
	 movem.l   d0-5,ge_Domain(a0)

	 bsr       _Layout

	 move.l    ge_Data(a3),ge_Data(a2)
	 rts

HSCRender:
	 move.l    ge_Temp(a0),a0
	 bra       _Render

HSCClick:
	 move.l    ge_Temp(a0),a0
	 bra       _DoClick

HSCHook:
	 move.l    ge_ID(a0),a1
	 movem.l   ge_Data(a0),d0-2
	 movem.l   d0-2,ge_Data(a1)

HSCCallHook:
	 move.l    ge_Hook(a1),d1
	 beq.s     .Done
	 move.l    a1,a0
	 move.l    d1,a1
	 jmp       (a1)

.Done:
	 rts

HSCDecrHook:
	 sub.l     #1,HSCHookCount
	 bpl.s     .Done

	 move.l    #5,HSCHookCount
	 move.l    ge_ID(a0),a1
	 move.l    ge_Temp2(a1),a0
	 sub.l     #1,ge_Data(a0)
	 bsr       _RefreshGuiEntry

	 move.l    ge_Data(a0),d0
	 move.l    d0,ge_Data(a1)
	 bra.s     HSCCallHook

.Done:
	 rts

HSCIncrHook:
	 sub.l     #1,HSCHookCount
	 bpl.s     .Done

	 move.l    #5,HSCHookCount
	 move.l    ge_ID(a0),a1
	 move.l    ge_Temp2(a1),a0
	 add.l     #1,ge_Data(a0)
	 bsr       _RefreshGuiEntry

	 move.l    ge_Data(a0),d0
	 move.l    d0,ge_Data(a1)
	 bra.s     HSCCallHook

.Done:
	 rts

HSCRelHook:
	 clr.l     HSCHookCount
	 rts

HSCHookCount:
	 dc.l      0
;fe
;fs "_VScroller"
_VScroller:
	 dc.l      VSCGetMinMax
	 dc.l      VSCLayout
	 dc.l      VSCRender
	 dc.l      VSCClick

VSCGetMinMax:
	 moveq     #1,d0
	 move.l    _CtGuiTemp(pc),a1
	 move.l    a1,ge_Temp(a0)
	 lea       ge_Size*7(a1),a2
	 move.l    a2,_CtGuiTemp

	 move.l    #_VGroup,(a1)
	 lea       ge_Size(a1),a1

	 move.l    a1,ge_Temp2(a0)
	 move.l    #_VProp,(a1)
	 move.l    ge_Data(a0),ge_Data(a1)
	 move.l    ge_Data2(a0),ge_Data2(a1)
	 move.l    ge_Data3(a0),ge_Data3(a1)
	 move.l    a0,ge_ID(a1)
	 move.l    #VSCHook,ge_Hook(a1)
	 lea       ge_Size(a1),a1

	 move.l    #_VSpacingEater,(a1)
	 lea       ge_Size(a1),a1

	 move.l    #_SmallButton,(a1)
	 move.l    #$90,ge_Data(a1)
	 move.l    a0,ge_ID(a1)
	 move.l    #VSCRelHook,ge_Hook(a1)
	 move.l    #VSCDecrHook,ge_Data2(a1)
	 move.l    d0,ge_Data3(a1)
	 lea       ge_Size(a1),a1

	 move.l    #_VSpacingEater,(a1)
	 lea       ge_Size(a1),a1

	 move.l    #_SmallButton,(a1)
	 move.l    #$8f,ge_Data(a1)
	 move.l    a0,ge_ID(a1)
	 move.l    #VSCRelHook,ge_Hook(a1)
	 move.l    #VSCIncrHook,ge_Data2(a1)
	 move.l    d0,ge_Data3(a1)
	 lea       ge_Size(a1),a1

	 clr.l     (a1)

	 move.l    a0,a1
	 move.l    ge_Temp(a1),a0
	 bsr       _GetMinMax

	 move.l    ge_MinWidth(a0),ge_MinWidth(a1)
	 move.l    ge_MaxWidth(a0),ge_MaxWidth(a1)
	 move.l    ge_MinHeight(a0),ge_MinHeight(a1)
	 move.l    ge_MaxHeight(a0),ge_MaxHeight(a1)

	 lea       ge_Size(a1),a0
	 move.l    a0,ge_Next(a1)
	 rts

VSCLayout:
	 move.l    a0,a2
	 move.l    ge_Temp2(a0),a3
	 movem.l   ge_Data(a0),d0-2
	 movem.l   d0-2,ge_Data(a3)

	 move.l    a0,a1
	 move.l    ge_Temp(a1),a0

	 movem.l   ge_Domain(a1),d0-5
	 movem.l   d0-5,ge_Domain(a0)

	 bsr       _Layout

	 move.l    ge_Data(a3),ge_Data(a2)
	 rts

VSCRender:
	 move.l    ge_Temp(a0),a0
	 bra       _Render

VSCClick:
	 move.l    ge_Temp(a0),a0
	 bra       _DoClick

VSCHook:
	 move.l    ge_ID(a0),a1
	 movem.l   ge_Data(a0),d0-2
	 movem.l   d0-2,ge_Data(a1)

VSCCallHook:
	 move.l    ge_Hook(a1),d1
	 beq.s     .Done
	 move.l    a1,a0
	 move.l    d1,a1
	 jmp       (a1)

.Done:
	 rts

VSCDecrHook:
	 sub.l     #1,VSCHookCount
	 bpl.s     .Done

	 move.l    #5,VSCHookCount
	 move.l    ge_ID(a0),a1
	 move.l    ge_Temp2(a1),a0
	 sub.l     #1,ge_Data(a0)
	 bsr       _RefreshGuiEntry

	 move.l    ge_Data(a0),d0
	 move.l    d0,ge_Data(a1)
	 bra.s     VSCCallHook

.Done:
	 rts

VSCIncrHook:
	 sub.l     #1,VSCHookCount
	 bpl.s     .Done

	 move.l    #5,VSCHookCount
	 move.l    ge_ID(a0),a1
	 move.l    ge_Temp2(a1),a0
	 add.l     #1,ge_Data(a0)
	 bsr       _RefreshGuiEntry

	 move.l    ge_Data(a0),d0
	 move.l    d0,ge_Data(a1)
	 bra.s     VSCCallHook

.Done:
	 rts

VSCRelHook:
	 clr.l     VSCHookCount
	 rts

VSCHookCount:
	 dc.l      0
;fe
;fs "_ListView"
_ListView:
	 dc.l      LVGetMinMax
	 dc.l      LVLayout
	 dc.l      LVRender
	 dc.l      LVClick

LVGetMinMax:
	 moveq     #1,d0
	 move.l    _CtGuiTemp(pc),a1
	 move.l    a1,ge_Temp(a0)
	 lea       ge_Size*5(a1),a2
	 move.l    a2,_CtGuiTemp

	 move.l    #_HGroup,(a1)
	 lea       ge_Size(a1),a1

	 move.l    a1,ge_Temp2(a0)
	 move.l    #IntListView,(a1)
	 move.l    ge_Data3(a0),ge_Temp3(a1)
	 move.l    a0,ge_ID(a1)
	 move.l    ge_Hook(a0),ge_Hook(a1)
	 lea       ge_Size(a1),a1

	 move.l    #_HSpacingEater,(a1)
	 lea       ge_Size(a1),a1

	 move.l    a1,ge_Temp3(a0)
	 move.l    #_VScroller,(a1)
	 move.l    ge_Data2(a0),ge_Data(a1)
	 move.l    a0,ge_ID(a1)
	 move.l    #LVHook,ge_Hook(a1)
	 lea       ge_Size(a1),a1

	 clr.l     (a1)

	 move.l    a0,a1
	 move.l    ge_Temp(a1),a0
	 bsr       _GetMinMax

	 move.l    ge_MinWidth(a0),ge_MinWidth(a1)
	 move.l    ge_MaxWidth(a0),ge_MaxWidth(a1)
	 move.l    ge_MinHeight(a0),ge_MinHeight(a1)
	 move.l    ge_MaxHeight(a0),ge_MaxHeight(a1)

	 lea       ge_Size(a1),a0
	 move.l    a0,ge_Next(a1)
	 rts

LVLayout:
	 move.l    ge_Data(a0),a1
	 moveq     #0,d6
	 move.l    (a1),a1

	 move.l    (a1),d7
	 beq.s     .EmptyList
	 move.l    d7,d0
	 move.l    a1,d7

.CountEntries:
	 addq.l    #1,d6

	 move.l    d0,a1
	 move.l    (a1),d0
	 bne.s     .CountEntries

.EmptyList:

	 move.l    a0,a3
	 move.l    ge_Temp(a0),a0

	 movem.l   ge_Domain(a3),d0-5
	 movem.l   d0-5,ge_Domain(a0)

	 subq.l    #3,d5
	 lsr.l     #3,d5
	 move.l    ge_Temp2(a3),a1
	 move.l    d5,ge_Temp(a1)
	 move.l    d7,ge_Temp2(a1)
	 lea       ge_Size*2(a1),a1
	 move.l    d6,ge_Data2(a1)
	 move.l    d5,ge_Data3(a1)

	 bsr       _Layout

	 move.l    a3,a0

LVFirstVisAddress:
	 move.l    ge_Temp3(a0),a2
	 sub.l     a1,a1

	 tst.l     ge_Data2(a2)
	 beq.s     .EmptyList

	 move.l    ge_Data(a2),d0
	 move.l    ge_Data(a0),a1

.Loop:
	 move.l    (a1),a1
	 dbf       d0,.Loop

.EmptyList:
	 move.l    ge_Temp2(a0),a2
	 move.l    a1,ge_Temp2(a2)
	 rts

LVRender:
	 move.l    a0,a1
	 move.l    ge_Temp3(a1),a0
	 bsr       _RefreshGuiEntry
	 move.l    ge_Temp2(a1),a0
	 bra       _Render

LVClick:
	 move.l    ge_Temp(a0),a0
	 bra       _DoClick

LVHook:
	 move.l    _CurrentDomain,-(a7)
	 move.l    a0,a1
	 move.l    ge_ID(a1),a0
	 move.l    ge_Data(a1),ge_Data2(a0)
	 bsr.s     LVFirstVisAddress
	 move.l    ge_Temp2(a0),a0
	 lea       ge_Domain(a0),a1
	 move.l    a1,_CurrentDomain
	 bsr       ILVClear
	 bsr       ILVRenderEntries
	 move.l    (a7)+,_CurrentDomain
	 rts

IntListView:
	 dc.l      ILVGetMinMax
	 dc.l      0
	 dc.l      ILVRender
	 dc.l      ILVClick

ILVGetMinMax:
	 move.l    #40,ge_MinWidth(a0)
	 move.l    #12,ge_MinHeight(a0)

	 clr.l     ge_MaxWidth(a0)
	 clr.l     ge_MaxHeight(a0)

	 lea       ge_Size(a0),a1
	 move.l    a1,ge_Next(a0)
	 rts

ILVRender:
	 moveq     #0,d0
	 moveq     #0,d1
	 move.l    ge_Domain+gd_Width(a0),d2
	 move.l    ge_Domain+gd_Height(a0),d3
	 sf        d4
	 bsr       _DrawBevelBox

ILVRenderEntries:
	 moveq     #-1,d0
	 move.l    d0,ge_Data2(a0)

	 move.l    ge_Domain+gd_Width(a0),d0
	 subq.l    #6,d0
	 move.l    d0,_TextLimit

	 move.l    ge_Temp2(a0),d0
	 beq.s     .EmptyList
	 move.l    d0,a1
	 move.l    (a1),d0

	 move.l    ge_Temp(a0),d1
	 subq.l    #1,d1
	 move.l    ge_Temp3(a0),a2

	 moveq     #1,d2

.Loop:
	 moveq     #0,d3
	 cmp.l     a1,a2
	 bne.s     .NoSel
	 moveq     #3,d3
.NoSel:

	 moveq     #2,d4
	 move.l    d2,d5
	 move.l    ge_Domain+gd_Width(a0),d6
	 subq.l    #4,d6
	 moveq     #8,d7
	 move.l    d5,ge_Data2(a0)
	 bsr       _DrawRectangle

;.NoSel:

	 move.l    lve_Color(a1),d4
	 moveq     #0,d5
	 move.l    lve_String(a1),a5
	 moveq     #2,d6
	 move.l    d2,d7
	 bsr.s     _DrawText

	 addq.l    #8,d2
	 move.l    d0,a1
	 move.l    (a1),d0
	 dbeq      d1,.Loop

.EmptyList:

	 clr.l     _TextLimit
	 rts

ILVClear:
	 rts
	 moveq     #0,d3
	 movem.l   ge_Domain+gd_Width(a0),d6-7
	 moveq     #2,d4
	 moveq     #1,d5
	 subq.l    #4,d6
	 subq.l    #2,d7
	 bsr       _DrawRectangle
	 rts

ILVClick:
	 move.l    d1,d2
	 subq.l    #1,d2
	 bpl.s     .Clicku
	 rts

.Clicku:
	 move.l    a0,_ActiveGuiEntry
	 move.l    #ILVHandler,_ActiveThingHandler

ILVHandler:
	 btst      #6,$bfe001
	 bne.s     .Release

	 sub.l     ge_Domain+gd_Top(a0),d1

	 subq.l    #1,d1
	 bmi.s     .Before

	 lsr.l     #3,d1
	 move.l    ge_Temp(a0),d0
	 subq.l    #1,d0

	 cmp.l     d1,d0
	 bcs.s     .After

	 move.l    ge_Temp2(a0),d0
	 beq       .Done

	 clr.l     ILVHookCount

	 move.l    d1,d2
	 move.l    d0,a1

	 subq.l    #1,d1
	 bmi.s     .Vivi

	 move.l    (a1),d0

.Loop:
	 move.l    d0,a1
	 move.l    (a1),d0

	 dbeq      d1,.Loop
	 bne.s     .Vivi

	 move.l    lve_Prev(a1),a1

.Vivi:
	 cmp.l     ge_Temp3(a0),a1
	 beq.s     .Done

	 move.l    a1,ge_Temp3(a0)

	 moveq     #0,d3
	 moveq     #2,d4
	 move.l    ge_Data2(a0),d5
	 bmi       ILVRenderEntries

	 moveq     #8,d7
	 move.l    ge_Domain+gd_Width(a0),d6
	 subq.l    #4,d6
	 bsr       _DrawRectangle
	 bra       ILVRenderEntries

.Before:
	 sub.l     #1,ILVHookCount
	 bpl.s     .Done

	 move.l    #5,ILVHookCount
	 move.l    a0,a3
	 move.l    ge_ID(a3),a1

	 move.l    ge_Temp3(a1),a0
	 move.l    ge_Data(a0),d7
	 move.l    d7,d0
	 subq.l    #1,d0
	 move.l    d0,ge_Data(a0)
	 bsr       _RefreshGuiEntry

	 cmp.l     ge_Data(a0),d7
	 beq.s     .Done

	 move.l    a1,a0
	 bsr       LVFirstVisAddress

	 move.l    a3,a0
	 move.l    ge_Temp2(a0),ge_Temp3(a0)
	 bsr       ILVClear

	 bra       ILVRenderEntries

.After:
	 sub.l     #1,ILVHookCount
	 bpl.s     .Done

	 move.l    #5,ILVHookCount
	 move.l    a0,a3
	 move.l    ge_ID(a3),a1

	 move.l    ge_Temp3(a1),a0
	 move.l    ge_Data(a0),d7
	 move.l    d7,d0
	 addq.l    #1,d0
	 move.l    d0,ge_Data(a0)
	 bsr       _RefreshGuiEntry

	 cmp.l     ge_Data(a0),d7
	 beq.s     .Done

	 move.l    a1,a0
	 bsr       LVFirstVisAddress

	 move.l    a3,a0
	 move.l    ge_Temp3(a0),a1
	 move.l    (a1),a1
	 tst.l     (a1)
	 beq.s     .MaisEuh

	 move.l    a1,ge_Temp3(a0)

.MaisEuh:
	 bsr       ILVClear

	 bra       ILVRenderEntries

.Release:
	 clr.l     _ActiveThingHandler
	 clr.l     _ActiveGuiEntry
	 clr.l     ILVHookCount

	 move.l    ge_ID(a0),a1
	 move.l    ge_Temp3(a0),d0
	 move.l    d0,ge_Data3(a1)

	 move.l    ge_Temp3(a1),a2
	 move.l    ge_Data(a2),ge_Data2(a1)

	 move.l    d0,a0
	 move.l    ge_Hook(a1),d0
	 beq.s     .Done
	 move.l    d0,a1
	 jmp       (a1)

.Done:
	 rts

ILVHookCount:
	 dc.l      0
;fe
;fs "_HSpacingEater"
_HSpacingEater:
	 dc.l      HSEGetMinMax
	 dc.l      0
	 dc.l      0
	 dc.l      -1

HSEGetMinMax:
	 moveq     #-GuiHorSpacing*2,d0
	 move.l    d0,ge_MinWidth(a0)
	 move.l    d0,ge_MaxWidth(a0)

	 clr.l     ge_MinHeight(a0)
	 clr.l     ge_MaxHeight(a0)

	 lea       ge_Size(a0),a1
	 move.l    a1,ge_Next(a0)
	 rts
;fe
;fs "_VSpacingEater"
_VSpacingEater:
	 dc.l      VSEGetMinMax
	 dc.l      0
	 dc.l      0
	 dc.l      -1

VSEGetMinMax:
	 clr.l     ge_MinWidth(a0)
	 clr.l     ge_MaxWidth(a0)

	 moveq     #-GuiVerSpacing*2,d0
	 move.l    d0,ge_MinHeight(a0)
	 move.l    d0,ge_MaxHeight(a0)

	 lea       ge_Size(a0),a1
	 move.l    a1,ge_Next(a0)
	 rts
;fe
;fs "_Empty"
_Empty:
	 dc.l      EGetMinMax
	 dc.l      0
	 dc.l      0
	 dc.l      0

EGetMinMax:
	 clr.l     ge_MinWidth(a0)
	 clr.l     ge_MaxWidth(a0)
	 clr.l     ge_MinHeight(a0)
	 clr.l     ge_MaxHeight(a0)

	 lea       ge_Size(a0),a1
	 move.l    a1,ge_Next(a0)
	 rts
;fe

;fs "_Selector"
_Selector:
	 dc.l      SGetMinMax
	 dc.l      SLayout
	 dc.l      SRender
	 dc.l      SClick

SGetMinMax:
	 move.l    #GuiScreenWidth,d2
	 move.l    d2,ge_MinWidth(a0)
	 move.l    d2,ge_MaxWidth(a0)

	 moveq     #31,d0
	 move.l    d0,ge_MinHeight(a0)

	 move.l    a0,a1
	 lea       ge_Size(a0),a0
	 moveq     #0,d0
	 moveq     #0,d1
	 lsr.l     #1,d2

.Loop:
	 addq.l    #1,d1

	 bsr.s     _GetMinMax

	 add.l     ge_MinWidth(a0),d0
	 cmp.l     d0,d2
	 bcs.s     .Skronk

	 move.l    ge_Next(a0),a0
	 tst.l     (a0)
	 beq.s     .Done

	 addq.l    #1,d0

	 bra.s     .Loop

.Skronk:
	 sub.l     ge_MinWidth(a0),d0
	 subq.l    #1,d0
	 subq.l    #1,d1
.Done:
	 sub.l     d0,d2

	 subq.l    #1,d1
	 move.l    d1,ge_Temp(a1)
	 beq.s     .SearchLast

	 divu      d1,d2
	 ext.l     d2
	 addq.l    #1,d2
	 move.l    d2,ge_Data(a1)

.SearchLast:
	 tst.l     (a0)
	 beq.s     .AllDone
	 lea       ge_Size(a0),a0
	 bra.s     .SearchLast
.AllDone:

	 lea       ge_Size(a0),a0
	 move.l    a0,ge_Next(a1)
	 rts

SLayout:
	 move.l    _CurrentDomain(pc),a1

	 move.l    a0,a1
	 move.l    ge_Data(a1),d2

	 lea       ge_Size(a0),a0
	 moveq     #0,d0

	 move.l    ge_Temp(a1),d3
	 bne.s     .PosLoop

	 move.l    #GuiScreenWidth/2,d0
	 sub.l     ge_MinWidth(a0),d0
	 lsr.l     #1,d0

.PosLoop:
	 move.l    d0,ge_Domain+gd_Left(a0)

	 move.l    ge_MinWidth(a0),d1
	 move.l    d1,ge_Domain+gd_Width(a0)

	 add.l     d1,d0
	 move.l    d0,ge_Domain+gd_Right(a0)

	 move.l    ge_MinHeight(a0),d1
	 move.l    d1,ge_Domain+gd_Height(a0)
	 move.l    d1,ge_Domain+gd_Bottom(a0)

	 clr.l     ge_Domain+gd_Top(a0)

	 add.l     d2,d0

	 bsr       _Layout

	 move.l    ge_Next(a0),a0
	 dbf       d3,.PosLoop

	 rts

SRender:
	 move.l    _CurrentDomain(pc),a1
	 move.l    gd_Top(a1),d0
	 add.w     GuiP(pc),d0
	 move.w    d0,GuiSelP

	 move.l    #GuiLayer1,_GuiL1Ptr
	 bra       _GRender

SClick:
	 move.l    _CurrentDomain(pc),a1
	 sub.l     gd_Top(a1),d1

	 lea       ge_Size(a0),a0
	 lsr.l     #1,d0

.Loop:
	 cmp2.l    ge_Domain+gd_Left(a0),d0
	 bcs.s     .AGrunt

	 cmp2.l    ge_Domain+gd_Top(a0),d1
	 bcc.s     .Bingo

.AGrunt:
	 move.l    ge_Next(a0),a0
	 tst.l     (a0)
	 bne.s     .Loop
	 rts

.Bingo:
	 bsr.s     _DoClick
	 rts
;fe
;fs "_Sprite"
_Sprite:
	 dc.l      SprGetMinMax
	 dc.l      0
	 dc.l      SprRender
	 dc.l      SprClick

SprGetMinMax:
	 move.l    ge_Data(a0),a1

	 move.l    spd_Width(a1),d0
	 move.l    d0,ge_MinWidth(a0)
	 move.l    d0,ge_MaxWidth(a0)

	 move.l    spd_Height(a1),d0
	 move.l    d0,ge_MinHeight(a0)
	 move.l    d0,ge_MaxHeight(a0)

	 lea       ge_Size(a0),a1
	 move.l    a1,ge_Next(a0)
	 rts

SprRender:         ; d6/d7=X,Y a3=SpriteData
	 move.l    ge_Data(a0),a3

	 move.l    _CurrentDomain(pc),a0
	 move.l    gd_Left(a0),d6
	 move.l    gd_Top(a0),d7

	 move.l    d6,d5
	 and.l     #$f,d5
	 ror.w     #4,d5
	 move.w    d5,d0
	 swap      d5
	 move.w    d0,d5
	 or.l      #$0fca0000,d5

	 lea       SprBlit(pc),a0
	 moveq     #0,d0
	 bsr       _GetBlitNode
	 move.l    a1,a0

	 move.l    d5,(a0)+

	 move.w    spd_WWidth+2(a3),d5
	 addq.w    #1,d5

	 move.w    #GuiSelBufferWidth,d1
	 sub.w     d5,d1
	 sub.w     d5,d1

	 moveq     #-2,d2
	 move.w    d2,(a0)+
	 move.w    d1,(a0)+

	 mulu      #GuiSelLineSize,d7
	 lsr.l     #4,d6
	 add.l     d6,d7
	 add.l     d6,d7

	 add.l     _GuiSelBitmap(pc),d7

	 movem.l   spd_Bitmap(a3),d3-4

	 move.l    d4,(a0)+
	 move.l    d3,(a0)+
	 move.l    d7,(a0)+

	 move.w    spd_Height+2(a3),d2
	 mulu      #NbPlanes,d2
	 move.w    d2,(a0)+
	 move.w    d5,(a0)

	 bsr       _AddBlitNode
	 rts

SprBlit:
	 move.l    (a0)+,bltcon0(a6)
	 moveq     #-1,d0
	 clr.w     d0
	 move.l    d0,bltafwm(a6)
	 move.w    (a0)+,d0
	 move.w    d0,bltamod(a6)
	 move.w    d0,bltbmod(a6)
	 move.w    (a0)+,d0
	 move.w    d0,bltcmod(a6)
	 move.w    d0,bltdmod(a6)
	 move.l    (a0)+,bltapt(a6)
	 move.l    (a0)+,bltbpt(a6)
	 move.l    (a0)+,d0
	 move.l    d0,bltcpt(a6)
	 move.l    d0,bltdpt(a6)
	 move.w    (a0)+,bltsizv(a6)
	 move.w    (a0),bltsizh(a6)
	 rts

SprClick:
	 move.l    a0,_ActiveGuiEntry
	 lea       SprHandler(pc),a1
	 move.l    a1,_ActiveThingHandler
	 rts

SprHandler:
	 tst.b     _LMBState
	 bne.s     .Done

	 clr.l     _ActiveThingHandler
	 move.l    ge_Hook(a0),d0
	 beq.s     .Done
	 move.l    d0,a0
	 jmp       (a0)

.Done:
	 rts
;fe
;fe

_CtGuiTemp:
	 ds.l      1
;fe

_ActiveGuiObject:
	 ds.l      1
_ActiveGuiObjData:
	 ds.l      1
_CurrentDomain:
	 ds.l      1

;fs "_ClearDomain"
_ClearDomain:
	 moveq     #0,d3
	 moveq     #0,d4
	 moveq     #0,d5
	 move.l    _CurrentDomain(pc),a1
	 move.l    gd_Width(a1),d6
	 move.l    gd_Height(a1),d7
	 bsr.s     _DrawRectangle
	 rts
;fe
;fs "_DrawBevelBox"
_DrawBevelBox:     ; d0/d1/d2/d3=X,Y,W,H d4=RecessedFlag
	 movem.l   d3-d7/a0,-(a7)

	 move.l    d3,a0
	 moveq     #2,d3
	 tst.b     d4
	 beq.s     .Raised
	 moveq     #1,d3
.Raised:

	 move.l    d0,d4
	 move.l    d1,d5
	 moveq     #2,d6
	 move.l    a0,d7
	 bsr.s     _DrawRectangle

	 eor.b     #3,d3
	 add.l     d2,d4
	 subq.l    #2,d4
	 bsr.s     _DrawRectangle

	 move.l    d0,d4
	 addq.l    #1,d4
	 add.l     a0,d5
	 subq.l    #1,d5
	 move.l    d2,d6
	 subq.l    #1,d6
	 moveq     #1,d7
	 bsr.s     _DrawRectangle

	 eor.b     #3,d3
	 move.l    d0,d4
	 move.l    d1,d5
	 bsr.s     _DrawRectangle

	 movem.l   (a7)+,d3-7/a0
	 rts
;fe
;fs "_DrawRectangle"
_DrawRectangle:    ; d4/d5/d6/d7=X,Y,W,H d3=Col

	 IFNE      DISABLEGUIGFX
	 rts

	 ELSE

	 movem.l   d0-7/a0-6,-(a7)

	 move.l    _CurrentDomain(pc),a0
	 add.l     gd_Left(a0),d4
	 add.l     gd_Top(a0),d5

	 add.l     #2,_RectCount

	 lea       _RectBlit,a0
	 moveq     #0,d0
	 bsr       _GetBlitNode
	 move.l    a1,a2

	 lea       _RectBlit,a0
	 moveq     #0,d0
	 bsr       _GetBlitNode
	 move.l    a1,a0
	 move.l    a2,a3

	 move.l    #$050c0000,d0
	 move.l    #$05fc0000,d2

	 tst.l     d3
	 bpl.s     .NoInvVid
	 move.l    #$053c0000,d0
	 move.l    d0,d2
.NoInvVid:

	 move.l    d0,d1

	 btst      #0,d3
	 beq.s     .Bp1Ok
	 move.l    d2,d0
.Bp1Ok:
	 move.l    d0,(a0)+
	 btst      #1,d3
	 beq.s     .Bp2Ok
	 move.l    d2,d1
.Bp2Ok:
	 move.l    d1,(a3)+

	 move.l    d4,d0
	 lsr.l     #4,d4

	 and.b     #$f,d0
	 extb.l    d0
	 add.l     d0,d6
	 moveq     #-1,d1
	 lsr.w     d0,d1
	 move.w    d1,(a0)+
	 move.w    d1,(a3)+

	 move.l    d6,d0
	 lsr.l     #4,d6

	 moveq     #-1,d1

	 and.b     #$f,d0
	 beq.s     .Gaaa
	 addq.l    #1,d6
	 lsr.w     d0,d1
	 not.w     d1
.Gaaa:

	 move.w    d1,(a0)+
	 move.w    d1,(a3)+

	 move.l    _GuiBitmap(pc),d0
	 add.l     d4,d0
	 add.l     d4,d0

	 move.l    d5,d1
	 move.l    #GuiLineSize,d2
	 mulu      d2,d1
	 add.l     d1,d0

	 move.l    d0,(a0)+

	 add.l     #GuiBufferWidth,d0
	 move.l    d0,(a3)+

	 sub.l     d6,d2
	 sub.l     d6,d2

	 move.w    d2,(a0)+
	 move.w    d2,(a3)+

	 move.w    d7,(a0)+
	 move.w    d7,(a3)+
	 move.w    d6,(a0)
	 move.w    d6,(a3)

	 bsr       _PreAddBlitNode
	 move.l    a2,a1
	 bsr       _AddBlitNode

	 movem.l   (a7)+,d0-7/a0-6
	 rts
_RectBlit:
	 lea       _RectHook(pc),a5
	 move.l    a5,_BlitHook

	 move.l    (a0)+,bltcon0(a6)
	 move.l    (a0)+,bltafwm(a6)
	 move.l    (a0)+,d0
	 move.l    d0,bltbpt(a6)
	 move.l    d0,bltdpt(a6)
	 move.w    (a0)+,d0
	 move.w    d0,bltbmod(a6)
	 move.w    d0,bltdmod(a6)
	 move.w    #-1,bltadat(a6)
	 move.w    (a0)+,bltsizv(a6)
	 move.w    (a0),bltsizh(a6)
	 rts
_RectHook:
	 sub.l     #1,_RectCount
	 rts
_RectCount:
	 dc.l      0

	 ENDIF
;fe
;fs "_DrawText"
_TextLimit:
	 dc.l      0
_DrawText:         ; d6/d7=X,Y d5=Length d4=Col a5=String
	 movem.l   d3/d5-6/a0/a5,-(a7)

	 tst.l     d5
	 bne.s     .LengthOk

	 move.l    a5,a0
.StrLen:
	 tst.b     (a0)+
	 bne.s     .StrLen
	 sub.l     a5,a0
	 move.l    a0,d5
	 subq.l    #1,d5
	 beq.s     .Done

.LengthOk:

	 move.l    _TextLimit(pc),d3
	 beq.s     .NoClip
	 sub.l     d6,d3
	 lsr.l     #3,d3
	 cmp.l     d5,d3
	 bcc.s     .NoClip
	 move.l    d3,d5
.NoClip:

	 subq.l    #1,d5
	 move.l    d5,d3
.Loop:
	 move.b    (a5)+,d5
	 bsr.s     _DrawChar
	 addq.l    #8,d6
	 dbf       d3,.Loop

.Done:
	 movem.l   (a7)+,d3/d5-6/a0/a5
	 rts
;fe
;fs "_DrawChar"
_DrawChar:         ; d6/d7=X,Y d5=Char d4=Col

	 IFNE      DISABLEGUIGFX
	 rts

	 ELSE

	 movem.l   d0-3/d6-7/a0-2,-(a7)

	 move.l    _CurrentDomain(pc),a0
	 add.l     gd_Left(a0),d6
	 add.l     gd_Top(a0),d7

	 cmp.b     #$a0,d5
	 beq.s     .Done
	 bcs.s     .Ok

	 cmp.b     #$ad,d5
	 bcs.s     .Pfouh
	 beq.s     .CrÈvindiou
	 subq.b    #1,d5
	 bra.s     .Pfouh
.CrÈvindiou:
	 move.b    #"-",d5
	 bra.s     .Ok
.Pfouh:
	 subq.b    #1,d5
.Ok:

	 move.l    _GuiBitmap(pc),a1
	 mulu      #GuiLineSize,d7
	 add.l     d7,a1

	 moveq     #0,d7
	 not.b     d7
	 ror.l     #8,d7

	 btst      #0,d5
	 beq.s     .EvenChar
	 subq.l    #2,a1
	 addq.l    #8,d6
	 lsr.l     #8,d7
.EvenChar:

	 lea       _GuiFont(pc),a0
	 and.b     #$fe,d5
	 add.l     d5,a0

	 move.l    d6,d0
	 lsr.l     #3,d0
	 and.b     #$fe,d0
	 add.l     d0,a1

	 and.l     #$f,d6
	 move.l    #254,d0
	 move.l    #GuiBufferWidth,d1
	 moveq     #7,d3

.RWait:
	 tst.l     _RectCount
	 bne.s     .RWait

	 lea       CharTable(pc),a2
	 jsr       (a2,d4.w*2)

.Done:
	 movem.l   (a7)+,d0-3/d6-7/a0-2
	 rts

CharTable:
	 bra.s     CharLoop0
	 bra.s     CharLoop1
	 bra.s     CharLoop2
	 bra.s     CharLoop3

CharLoop0:
	 move.l    (a0),d2
	 and.l     d7,d2
	 lsr.l     d6,d2
	 not.l     d2
	 and.l     d2,(a1)
	 add.l     d1,a1
	 and.l     d2,(a1)
	 add.l     d1,a1
	 add.l     d0,a0
	 dbf       d3,CharLoop0
	 rts
CharLoop1:
	 move.l    (a0),d2
	 and.l     d7,d2
	 lsr.l     d6,d2
	 or.l      d2,(a1)
	 not.l     d2
	 add.l     d1,a1
	 and.l     d2,(a1)
	 add.l     d1,a1
	 add.l     d0,a0
	 dbf       d3,CharLoop1
	 rts
CharLoop2:
	 move.l    (a0),d2
	 and.l     d7,d2
	 lsr.l     d6,d2
	 not.l     d2
	 and.l     d2,(a1)
	 not.l     d2
	 add.l     d1,a1
	 or.l      d2,(a1)
	 add.l     d1,a1
	 add.l     d0,a0
	 dbf       d3,CharLoop2
	 rts
CharLoop3:
	 move.l    (a0),d2
	 and.l     d7,d2
	 lsr.l     d6,d2
	 or.l      d2,(a1)
	 add.l     d1,a1
	 or.l      d2,(a1)
	 add.l     d1,a1
	 add.l     d0,a0
	 dbf       d3,CharLoop3
	 rts

	 ENDIF
;fe
;fs "Font"
_GuiFont:
	 incbin    "GuiFont.bin"
;fe
