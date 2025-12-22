*
* CdBSian Obviously Universal & Interactive Nonsense (COUIN)
* (Absurdité CdBSienne Manifestement Universelle et Interactive)
* ©1997-1998, CdBS Software (MORB)
* Text editor engine and related classes
* $Id: Editor.s 0.15 1998/04/28 12:24:00 MORB Exp MORB $
*

;fs "RawEditorClass"
;fs "Internal defs"
	 rsreset
REDAlignStruct     rs.b      0
ras_CountChunks    rs.l      1
ras_Layout         rs.l      1
ras_Render         rs.l      1
ras_FindDline      rs.l      1
ras_CursorPos      rs.l      1
ras_CursorClick    rs.l      1
;fe
;fs "Structure"
_RawEditorClass:
	 dc.l      0
	 dc.l      _ScrollAreaClass
	 dc.l      0,0,0,0,0
	 dc.l      red_DataSize
	 dc.l      rawedit_Funcs
	 dc.l      rawedit_data
	 dc.l      0
	 dc.l      rawedit_Init

rawedit_data:
	 ds.b      red_DataSize

rawedit_Funcs:
	 dc.l      REDClicked
	 dc.l      REDMakeCursorVisible
	 dc.l      REDInsertChar
	 dc.l      REDSelectLine
	 dc.l      REDUnSelectLine
	 dc.l      REDMoveCursorDown
	 dc.l      REDMoveCursorUp
	 dc.l      REDMoveCursorRight
	 dc.l      REDMoveCursorLeft
	 dc.l      REDVomitBuffer
	 dc.l      REDDigestBuffer
	 dc.l      0
;fe
;fs "Init"
rawedit_Init:
	 ;move.l    #MTD_New,d0
	 ;lea       REDNew,a1
	 ;bsr       _SetMethod
	 ;move.l    d0,REDSNew

	 move.l    #MTD_Dispose,d0
	 lea       REDDispose,a1
	 bsr       _SetMethod
	 move.l    d0,REDSDispose

	 ;move.l    #GCM_GetMinMax,d0
	 ;lea       REDGetMinMax,a1
	 ;bsr       _SetMethod

	 move.l    #SAM_ContentsGetSizes,d0
	 lea       REDGetSizes,a1
	 bsr       _SetMethod

	 move.l    #SAM_ContentsRender,d0
	 lea       REDRender,a1
	 bsr       _SetMethod

	 move.l    #SAM_ContentsNewVPos,d0
	 lea       REDNewVPos,a1
	 bsr       _SetMethod

	 move.l    #SAM_ContentsUpdate,d0
	 lea       REDUpdate,a1
	 bsr       _SetMethod

	 move.l    #SAM_ContentsUnderMouse,d0
	 lea       REDUnderMouse,a1
	 bsr       _SetMethod

	 move.l    #SAM_ContentsClick,d0
	 lea       REDClick,a1
	 bsr       _SetMethod

	 move.l    #GCM_Handle,d0
	 lea       REDHandler,a1
	 bsr       _SetMethod
	 rts

;REDSNew:
;         ds.l      1
REDSDispose:
	 ds.l      1
;fe

;fs "Dispose"
REDDispose:
	 movem.l   a0/a2-3/a6,-(a7)

	 move.l    a0,a2
	 LBLOCKEAI RawEditorClass_ID,a2,a3

	 move.l    (AbsExecBase).w,a6
	 move.l    red_REDT_DispTable(a3),a1
	 CALL      FreeVec

	 move.l    red_REDT_BufListMemPool(a3),d0
	 beq.s     .NoMemPool
	 move.l    d0,a0
	 CALL      DeletePool
.NoMemPool:

	 movem.l   (a7)+,a0/a2-3/a6
	 move.l    REDSDispose(pc),-(a7)
REDMakeCursorVisible:
REDClicked:
	 rts
;fe
;fs "ContentsGetSizes"
REDGetSizes:
	 movem.l   d2-7/a2-6,-(a7)

	 move.l    a0,a2
	 LBLOCKEAI ScrollAreaClass_ID,a2,a3
	 LBLOCKEAI RawEditorClass_ID,a2,a4

	 tst.l     red_REDT_NumBufLines(a4)
	 beq.s     .Empty

	 move.l    sac_SADT_ContentsHeightHS(a3),d2
	 lsr.l     #3,d2
	 move.l    d2,sac_SADT_VVisibleHS(a3)
	 move.l    sac_SADT_ContentsHeightNHS(a3),d2
	 lsr.l     #3,d2
	 move.l    d2,sac_SADT_VVisibleNHS(a3)

	 cmp.l     red_REDT_DispEntNum(a4),d2
	 beq.s     .DispBufOk

	 clr.l     red_REDT_DispEntNum(a4)
	 move.l    (AbsExecBase).w,a6
	 move.l    red_REDT_DispTable(a4),a1
	 CALL      FreeVec

	 move.l    d2,d0
	 mulu      #dte_Size,d0
	 move.l    d0,d3
	 addq.l    #4,d0
	 move.l    #MEMF_CLEAR,d1
	 CALL      AllocVec
	 move.l    d0,red_REDT_DispTable(a4)
	 beq.s     .DTAllocFail

	 add.l     d0,d3
	 move.l    d2,red_REDT_DispEntNum(a4)
	 moveq     #-1,d0
	 move.l    d3,a0
	 move.l    d0,(a0)

.DispBufOk:

	 move.l    sac_SADT_ContentsWidthNVS(a3),d2
	 lsr.l     #3,d2
	 move.l    sac_SADT_ContentsWidthVS(a3),d3
	 lsr.l     #3,d3

	 move.l    d2,sac_SADT_HVisibleNVS(a3)
	 move.l    d2,sac_SADT_HTotalNVS(a3)

	 move.l    d3,sac_SADT_HVisibleVS(a3)
	 move.l    d3,sac_SADT_HTotalVS(a3)

	 moveq     #-1,d0
	 move.l    d0,red_REDT_RebuildDTbl(a4)

	 move.l    red_REDT_AlignType(a4),d0
	 lea       REDAlignTable(pc),a0
	 move.l    (a0,d0.w),a0
	 move.l    (a0),a0

	 lea       red_REDT_BufferList(a4),a1
	 move.l    red_REDT_NumBufLines(a4),d4
	 subq.l    #1,d4
	 moveq     #0,d5
	 moveq     #0,d6
	 move.l    red_REDT_FirstLine(a4),d7
	 bne.s     .FLOk
	 move.l    (a1),d7
	 move.l    d7,red_REDT_FirstLine(a4)
	 clr.l     red_REDT_FLCharOffset(a4)
.FLOk:

.ReformatLoop:
	 move.l    (a1),a1

	 cmp.l     d7,a1
	 bne.s     .NotFirstLine
	 move.l    d6,red_REDT_FLineNumSC(a4)
.NotFirstLine:

	 move.l    d2,d0
	 jsr       (a0)
	 add.l     d0,d5
	 move.l    d0,ble_ChunksNS(a1)

	 move.l    d3,d0
	 jsr       (a0)
	 add.l     d0,d6
	 move.l    d0,ble_ChunksSC(a1)
	 ;move.l    d0,ble_ChunksNS(a1)

	 dbf       d4,.ReformatLoop

	 move.l    d5,sac_SADT_VTotalNVS(a3)
	 move.l    d6,sac_SADT_VTotalVS(a3)
.DontReformat:

	 move.l    red_REDT_AlignType(a4),d0
	 lea       REDAlignTable(pc),a1
	 move.l    (a1,d0.w),a1
	 move.l    ras_FindDline(a1),a1
	 move.l    red_REDT_FirstLine(a4),a0
	 move.l    sac_SADT_HTotalVS(a3),d0
	 move.l    red_REDT_FLCharOffset(a4),d1
	 jsr       (a1)
	 move.l    d0,red_REDT_FLOffset(a4)

	 add.l     red_REDT_FLineNumSC(a4),d0
	 ;move.l    d0,vsc_VSDT_Position(a0)
	 move.l    d0,sac_SADT_VPos(a3)

	 movem.l   (a7)+,d2-7/a2-6
	 rts

.Empty:
	 moveq     #0,d0
	 move.l    d0,sac_SADT_HTotalNVS(a3)
	 move.l    d0,sac_SADT_HTotalVS(a3)
	 move.l    d0,sac_SADT_VTotalNVS(a3)
	 move.l    d0,sac_SADT_VTotalVS(a3)

	 ;move.l    red_REDT_BufferList(a4),red_REDT_FirstLine(a4)
	 moveq     #-1,d0
	 move.l    d0,red_REDT_RebuildDTbl(a4)

	 movem.l   (a7)+,d2-7/a2-6
	 rts

;fs "Trash"
;fs "Useless"
;         moveq     #0,d0
;         move.l    red_REDT_DispEntNum(a4),d1
;         cmp.l     red_REDT_NDispLinesNS(a4),d1
;         bcc.s     .NoScroller
;
;         move.l    red_REDT_CNumOfst(a4),d0
;         eor.b     #4,d0
;         move.l    d0,red_REDT_ClearScroller(a4)
;         moveq     #4,d0
;         move.l    d0,red_REDT_CNumOfst(a4)
;
;         move.l    gd_Right(a3),d2
;         move.l    d2,gd_Right(a5)
;         move.l    guir_DTA_MinWidth(a5),d1
;         sub.l     d1,d2
;         move.l    d1,gd_Width(a5)
;
;         move.l    gd_Width(a3),d0
;         sub.l     d1,d0
;         move.l    d2,gd_Left(a5)
;
;         movem.l   d0/d2,red_REDT_Width(a4)
;
;         movem.l   gd_Top(a3),d0-1
;         movem.l   d0-1,gd_Top(a5)
;         move.l    gd_Height(a3),gd_Height(a5)
;fe
;         move.l    red_REDT_AlignType(a4),d0
;         lea       REDAlignTable(pc),a1
;         move.l    (a1,d0.w),a1
;         move.l    ras_FindDline(a1),a1
;         move.l    red_REDT_FirstLine(a4),a0
;         move.l    red_REDT_DLLengthSC(a4),d0
;         move.l    red_REDT_FLCharOffset(a4),d1
;         jsr       (a1)
;         move.l    d0,red_REDT_FLOffset(a4)
;
;fs "Useless"
;         LBLOCKEAI VScrollerClass_ID,a6,a0
;         move.l    red_REDT_NDispLinesSC(a4),vsc_VSDT_Total(a0)
;         move.l    red_REDT_DispEntNum(a4),vsc_VSDT_Visible(a0)
;fe
;         add.l     red_REDT_FLineNumSC(a4),d0
;         move.l    d0,vsc_VSDT_Position(a0)
;         move.l    d0,red_REDT_FLineNumSC(a4)

;fs "Useless"
	 ;move.l    a4,a1
	 ;bsr       REDPlaceCursor

	 DOMTDI    GCM_Layout,a6

	 bra.s     .AllDone
;fe
;.NoScroller:
;         clr.l     red_REDT_CNumOfst(a4)
;         move.l    gd_Width(a3),red_REDT_Width(a4)
;         move.l    gd_Right(a3),red_REDT_Right(a4)
;
;         clr.l     red_REDT_FLineNumSC(a4)
;         move.l    red_REDT_BufferList(a4),red_REDT_FirstLine(a4)
;         moveq     #-1,d0
;         move.l    d0,red_REDT_RebuildDTbl(a4)
;
;         clr.l     red_REDT_FLOffset(a4)
;         clr.l     red_REDT_FLCharOffset(a4)
;
;         ;move.l    a4,a1
;         ;bsr       REDPlaceCursor
;.AllDone:
;         moveq     #0,d0
;
;.Fail:
;         movem.l   (a7)+,d2-7/a2-6
;         rts
;fe

.AllDone:
	 moveq     #0,d0

.Fail:
	 movem.l   (a7)+,d2-7/a2-6
	 rts

.DTAllocFail:
	 lea       REDDTAF(pc),a0
	 move.l    a0,d0
	 bra.s     .Fail

REDDTAF:
	 dc.l      REDName
	 dc.l      REDDTAllocFail

REDName:
	 dc.b      "RawEditorClass",0
REDDTAllocFail:
	 dc.b      "Couldn't allocate display buffer",0
	 even
;fe
;fs "ContentsRender"
REDRender:
	 movem.l   d2-7/a2-6,-(a7)
	 move.l    _CurrentDomain(pc),-(a7)

	 LBLOCKEAI RawEditorClass_ID,a0,a1
	 LBLOCKEAI ScrollAreaClass_ID,a0,a6

	 tst.l     red_REDT_NumBufLines(a1)
	 beq.s     .NoBuf

	 tst.l     red_REDT_RebuildDTbl(a1)
	 beq.s     .DontRebuild

	 clr.l     red_REDT_RebuildDTbl(a1)
	 bsr       _RebuildDisplayBuffer
	 bsr       REDPlaceCursor

.DontRebuild:

	 move.l    a6,_CurrentDomain
	 move.l    gd_Width(a6),_TextLimit

	 moveq     #0,d3
	 moveq     #0,d4
	 moveq     #0,d5
	 move.l    gd_Width(a6),d6
	 moveq     #1,d7
	 bsr       _DrawRectangle

	 move.l    red_REDT_AlignType(a1),d0
	 lea       REDAlignTable(pc),a3
	 move.l    (a3,d0.w),a3
	 move.l    ras_Render(a3),a4

	 move.l    red_REDT_DispTable(a1),a3
	 moveq     #1,d2
	 move.l    red_REDT_CursorDLine(a1),a2

.Loop:
	 move.l    dte_Text(a3),d0
	 bmi.s     .Done
	 tst.l     dte_NumChars(a3)
	 bmi.s     .Done

	 clr.l     dte_Update(a3)
	 move.l    d0,a5

	 moveq     #0,d3
	 moveq     #0,d4
	 move.l    d2,d5
	 move.l    gd_Width(a6),d6
	 moveq     #8,d7
	 bsr       _DrawRectangle

	 tst.l     d0
	 beq.s     .EmptyLine
	 jsr       (a4)

.EmptyLine:
	 cmp.l     a3,a2
	 bne.s     .Next
	 bsr       REDCursor

.Next:
	 lea       dte_Size(a3),a3
	 addq.l    #8,d2
	 bra.s     .Loop

.Done:
	 moveq     #0,d3
	 moveq     #0,d4
	 move.l    gd_Width(a6),d6
	 move.l    d2,d5
	 move.l    gd_Height(a6),d7
	 sub.l     d2,d7
	 beq.s     .NoBuf
	 bsr       _DrawRectangle

.NoBuf:
	 clr.l     _TextLimit
	 move.l    (a7)+,_CurrentDomain
	 movem.l   (a7)+,d2-7/a2-6
	 rts
;fe
;fs "ContentsUpdate"
REDUpdate:
	 movem.l   d2-7/a2-6,-(a7)
	 move.l    _CurrentDomain(pc),-(a7)

	 LBLOCKEAI RawEditorClass_ID,a0,a1
	 LBLOCKEAI ScrollAreaClass_ID,a0,a6

	 tst.l     red_REDT_RebuildDTbl(a1)
	 beq.s     .DontRebuild

	 clr.l     red_REDT_RebuildDTbl(a1)
	 bsr.s     _RebuildDisplayBuffer
	 bsr       REDPlaceCursor

.DontRebuild:

	 move.l    a6,_CurrentDomain

	 moveq     #0,d3
	 moveq     #0,d4
	 moveq     #0,d5
	 move.l    gd_Width(a6),d6
	 moveq     #1,d7
	 bsr       _DrawRectangle

	 move.l    gd_Width(a6),_TextLimit
	 move.l    red_REDT_AlignType(a1),d0
	 lea       REDAlignTable(pc),a3
	 move.l    (a3,d0.w),a3
	 move.l    ras_Render(a3),a4

	 move.l    red_REDT_DispTable(a1),a3
	 moveq     #1,d2
	 move.l    red_REDT_CursorDLine(a1),a2

.Loop:
	 move.l    dte_Text(a3),d0
	 bmi.s     .Done
	 tst.l     dte_NumChars(a3)
	 bmi.s     .Done

	 tst.l     dte_Update(a3)
	 beq.s     .Next

	 clr.l     dte_Update(a3)
	 move.l    d0,a5

	 moveq     #0,d3
	 moveq     #0,d4
	 move.l    d2,d5
	 move.l    gd_Width(a6),d6
	 moveq     #8,d7
	 bsr       _DrawRectangle

	 tst.l     d0
	 beq.s     .EmptyLine
	 jsr       (a4)
.EmptyLine:

	 cmp.l     a3,a2
	 bne.s     .Next
	 bsr.s     REDCursor

.Next:
	 lea       dte_Size(a3),a3
	 addq.l    #8,d2
	 bra.s     .Loop

.Done:
	 moveq     #0,d3
	 moveq     #0,d4
	 move.l    gd_Width(a6),d6
	 move.l    d2,d5
	 move.l    gd_Height(a6),d7
	 sub.l     d2,d7
	 beq.s     .Glarkeu
	 bsr       _DrawRectangle

.Glarkeu:
	 clr.l     _TextLimit
	 move.l    (a7)+,_CurrentDomain
	 movem.l   (a7)+,d2-7/a2-6
	 rts
;fe
;fs "ContentsNewVPos"
REDNewVPos:
	 movem.l   d3-4/a2-6,-(a7)

	 moveq     #0,d3
	 LBLOCKEAI ScrollAreaClass_ID,a0,a6
	 tst.l     sac_SADT_VSFlag(a6)
	 sne       d3
	 and.b     #4,d3

	 LBLOCKEAI RawEditorClass_ID,a0,a1

	 move.l    red_REDT_FirstLine(a1),a2
	 move.l    red_REDT_FLineNumSC(a1),d0
	 sub.l     red_REDT_FLOffset(a1),d0
	 move.l    d1,red_REDT_FLineNumSC(a1)
	 sub.l     d0,d1
	 bmi.s     .Backward

.FwdLoop:
	 move.l    ble_ChunksNS(a2,d3.w),d4
	 cmp.l     d4,d1
	 bcs.s     .FwdDone

	 sub.l     d4,d1
	 move.l    (a2),a2
	 bra.s     .FwdLoop
.FwdDone:
	 movem.l   d1/a2,red_REDT_FLOffset(a1)
	 bra.s     .Groumpf

.Backward:
	 neg.l     d1

.BwdLoop:
	 move.l    4(a2),a2
	 move.l    ble_ChunksNS(a2,d3.w),d4

	 sub.l     d4,d1
	 bgt.s     .BwdLoop
.BwdDone:
	 neg.l     d1
	 movem.l   d1/a2,red_REDT_FLOffset(a1)

.Groumpf:
	 clr.l     red_REDT_FLCharOffset(a1)

	 moveq     #-1,d0
	 move.l    d0,red_REDT_RebuildDTbl(a1)

	 tst.l     red_REDT_CursorEnabled(a1)
	 beq.s     .Done
	 tst.l     red_REDT_CursorAlwayVisible(a1)
	 beq.s     .Done

	 clr.l     red_REDT_RebuildDTbl(a1)
	 bsr.s     _RebuildDisplayBuffer

	 move.l    red_REDT_CursorDLine(a1),a0
	 move.l    dte_Offset(a0),red_REDT_CursorDLOffset(a1)

	 move.l    red_REDT_CursorDLCharOffset(a1),d0
	 move.l    dte_NumChars(a0),d1

	 cmp.l     d0,d1
	 bcc.s     .Ok
	 move.l    d1,d0
.Ok:
	 move.l    d0,red_REDT_CursorDLCharOffset(a1)
	 move.l    dte_BLEntry(a0),a2
	 move.l    a2,red_REDT_CursorLine(a1)
	 move.l    dte_Text(a0),d1
	 sub.l     ble_String(a2),d1
	 add.l     d0,d1
	 move.l    d1,red_REDT_CursorOffset(a1)

	 move.l    red_REDT_AlignType(a1),d1
	 lea       REDAlignTable(pc),a2
	 move.l    (a2,d1.w),a2
	 move.l    ras_CursorPos(a2),a2
	 jsr       (a2)

	 addq.l    #2,d0
	 move.l    d0,red_REDT_CursorX(a1)

.Done:
	 movem.l   (a7)+,d3-4/a2-a6
	 rts
;fe
;fs "_RebuildDisplayBuffer"
_RebuildDisplayBuffer:
	 lea       REDAlignTable(pc),a4
	 move.l    red_REDT_AlignType(a1),d0
	 move.l    (a4,d0.w),a4
	 move.l    ras_Layout(a4),a4

	 move.l    red_REDT_DispTable(a1),a3
	 move.l    sac_SADT_VSFlag(a6),d1
	 move.l    sac_SADT_HVisibleNVS(a6,d1.w),d0
	 move.l    red_REDT_FLOffset(a1),d4

	 move.l    red_REDT_FirstLine(a1),a2
	 jsr       (a4)
	 clr.l     ble_Refresh(a2)
	 move.l    d1,red_REDT_FLCharOffset(a1)

	 move.l    (a2),d7
	 beq.s     .Zlonk
	 move.l    d7,a2
	 moveq     #0,d4

.Loop:
	 tst.l     (a3)
	 bmi.s     .Done

	 move.l    (a2),d7
	 beq.s     .Zlonk
	 jsr       (a4)
	 clr.l     ble_Refresh(a2)
	 move.l    d7,a2
	 bra.s     .Loop

.Zlonk:
	 move.l    #-1,dte_NumChars(a3)
	 lea       dte_Size(a3),a3
	 tst.l     (a3)
	 bpl.s     .Zlonk

.Done:
	 rts
;fe

;fs "ContentsUnderMouse"
REDUnderMouse:
	 lea       EDMousePointer,a0
	 bra       _SetMousePointer
;fe
;fs "ContentsClick"
REDClick:
	 LBLOCKEAI ScrollAreaClass_ID,a0,a1

	 move.l    _GuiPos,d0
	 move.l    gd_Left(a1),_MinMouseX
	 move.l    d0,d1
	 move.l    gd_Right(a1),_MaxMouseX

	 add.l     gd_Top(a1),d0
	 move.l    d0,_MinMouseY
	 add.l     gd_Bottom(a1),d1
	 move.l    d1,_MaxMouseY
	 move.l    a0,_ActiveGuiObject
;fe
;fs "Handler"
REDHandler:
	 tst.b     _LMBState
	 beq.s     .Release

	 movem.l   a2-3,-(a7)
	 move.l    _CurrentDomain(pc),-(a7)

	 move.l    a0,a3
	 LBLOCKEAI ScrollAreaClass_ID,a3,a1
	 move.l    a1,_CurrentDomain
	 sub.l     gd_Top(a1),d1
	 lsr.l     #3,d1
	 sub.l     gd_Left(a1),d0

	 LBLOCKEAI RawEditorClass_ID,a3,a1

	 mulu      #dte_Size,d1
	 move.l    red_REDT_DispTable(a1),a2
	 add.l     d1,a2

	 tst.l     (a2)
	 bmi.s     .Done
	 tst.l     dte_NumChars(a2)
	 bmi.s     .Done

	 move.l    red_REDT_AlignType(a1),d1
	 lea       REDAlignTable(pc),a0
	 move.l    (a0,d1.w),a0
	 move.l    ras_CursorClick(a0),a0
	 jsr       (a0)

	 bsr       REDCursor
	 add.l     dte_Text(a2),d0
	 move.l    dte_BLEntry(a2),a2
	 sub.l     ble_String(a2),d0

	 move.l    ble_Length(a2),d1
	 cmp.l     d0,d1
	 bcc.s     .Ok
	 move.l    d1,d0
.Ok:

	 DOMTDI    REM_Clicked,a3

	 DOMTDI    REM_MakeCursorVisible,a3
	 tst.l     d0
	 bne.s     .Done
	 bsr       REDCursor

.Done:
	 move.l    (a7)+,_CurrentDomain
	 movem.l   (a7)+,a2-3
	 rts

.Release:
	 clr.l     _ActiveGuiObject
	 clr.l     _MinMouseX
	 clr.l     _MinMouseY
	 move.l    #GuiScreenWidth,_MaxMouseX
	 move.l    #256,_MaxMouseY
	 rts
;fe
;fs "DigestBuffer"
REDDigestBuffer:
	 movem.l   d2-5/d7/a2-6,-(a7)

	 move.l    (AbsExecBase).w,a6
	 LBLOCKEAI RawEditorClass_ID,a0,a2

	 move.l    red_REDT_Buffer(a2),d3
	 beq.s     .Fail

	 move.l    red_REDT_BufListMemPool(a2),d7
	 bne.s     .MemPoolOk

	 moveq     #0,d0
	 move.l    #512,d1
	 move.l    d1,d2
	 CALL      CreatePool
	 move.l    d0,d7
	 beq.s     .Fail
	 move.l    d7,red_REDT_BufListMemPool(a2)

.MemPoolOk:

	 move.l    d3,a5

	 lea       red_REDT_BufferList(a2),a3
	 NEWLIST   a3
	 moveq     #0,d2

.Loop:
	 addq.l    #1,d2

	 move.l    d7,a0
	 move.l    #ble_Size,d0
	 CALL      AllocPooled
	 tst.l     d0
	 beq.s     .Fail
	 move.l    d0,a4
	 clr.l     ble_Length(a4)
	 clr.l     ble_String(a4)

	 move.l    a3,a0
	 move.l    a4,a1
	 ADDTAIL

	 move.l    a5,a0
.CountLoop:
	 move.b    (a0)+,d3
	 beq.s     .CountOk
	 cmp.b     #$a,d3
	 bne.s     .CountLoop
.CountOk:

	 move.l    a5,d5
	 move.l    a0,a5
	 move.l    a0,d4
	 sub.l     d5,d4
	 subq.l    #1,d4
	 beq.s     .NextLine

	 move.l    d4,ble_Length(a4)
	 move.l    d4,d0
	 addq.l    #1,d0
	 move.l    d7,a0
	 CALL      AllocPooled
	 move.l    d0,ble_String(a4)
	 beq.s     .Fail

	 move.l    d5,a5
	 move.l    d0,a0
	 subq.l    #1,d4
.CpyLoop:
	 move.b    (a5)+,(a0)+
	 dbf       d4,.CpyLoop
	 addq.l    #1,a5
	 clr.b     (a0)+

.NextLine:
	 tst.b     d3
	 bne.s     .Loop

	 move.l    d2,red_REDT_NumBufLines(a2)
	 clr.l     red_REDT_FirstLine(a2)

	 lea       red_REDT_BufferList(a2),a0
	 move.l    (a0),red_REDT_CursorLine(a2)
	 moveq     #-1,d0

.Fail:
	 movem.l   (a7)+,d2-5/d7/a2-6
	 rts
;fe
;fs "VomitBuffer"
REDVomitBuffer:
	 movem.l   a2/a6,-(a7)

	 LBLOCKEAI RawEditorClass_ID,a0,a2

	 lea       red_REDT_BufferList(a2),a2
	 move.l    (a2),a2
	 move.l    a2,a1
	 moveq     #0,d0

.CountLinesLoop:
	 move.l    (a1),d1
	 beq.s     .CLDone
	 add.l     ble_Length(a1),d0
	 addq.l    #1,d0
	 move.l    d1,a1
	 bra.s     .CountLinesLoop
.CLDone:

	 move.l    (AbsExecBase).w,a6
	 moveq     #0,d1
	 CALL      AllocVec
	 tst.l     d0
	 beq.s     .Fail

	 move.l    d0,a0
.Loop:
	 move.l    (a2),d1
	 beq.s     .Done
	 move.l    ble_String(a2),a1
.CpyLoop:
	 move.b    (a1)+,(a0)+
	 bne.s     .CpyLoop
	 move.b    #$a,-1(a0)
	 move.l    d1,a2
	 bra.s     .Loop

.Done:
	 clr.b     -1(a0)

.Fail:
	 movem.l   (a7)+,a2/a6
	 rts
;fe
;fs "MoveCursorLeft"
REDMoveCursorLeft:
	 movem.l   d2-7/a2-6,-(a7)
	 move.l    _CurrentDomain(pc),-(a7)

	 move.l    a0,a4
	 LBLOCKEAI ScrollAreaClass_ID,a0,a6
	 move.l    a6,_CurrentDomain

	 LBLOCKEAI RawEditorClass_ID,a0,a1
	 bsr       REDCursor
	 bsr       REDCursorLeft
	 tst.l     d0
	 bne.s     .Done
	 bsr       REDCursor
.Done:

	 move.l    (a7)+,_CurrentDomain
	 movem.l   (a7)+,d2-7/a2-6
	 rts
;fe
;fs "MoveCursorRight"
REDMoveCursorRight:
	 movem.l   d2-7/a2-6,-(a7)
	 move.l    _CurrentDomain(pc),-(a7)

	 move.l    a0,a4
	 LBLOCKEAI ScrollAreaClass_ID,a0,a6
	 move.l    a6,_CurrentDomain

	 LBLOCKEAI RawEditorClass_ID,a0,a1
	 bsr       REDCursor
	 bsr       REDCursorRight
	 tst.l     d0
	 bne.s     .Done
	 bsr       REDCursor
.Done:

	 move.l    (a7)+,_CurrentDomain
	 movem.l   (a7)+,d2-7/a2-6
	 rts
;fe
;fs "MoveCursorUp"
REDMoveCursorUp:
	 movem.l   a2/a4,-(a7)
	 move.l    _CurrentDomain(pc),-(a7)

	 move.l    a0,a4
	 LBLOCKEAI ScrollAreaClass_ID,a0,a1
	 move.l    a1,_CurrentDomain

	 LBLOCKEAI RawEditorClass_ID,a0,a1
	 bsr       REDCursor
	 bsr       REDCursorUp
	 tst.l     d0
	 bne.s     .Done
	 bsr       REDCursor

.Done:
	 move.l    (a7)+,_CurrentDomain
	 movem.l   (a7)+,a2/a4
	 rts
;fe
;fs "MoveCursorDown"
REDMoveCursorDown:
	 movem.l   a2/a4,-(a7)
	 move.l    _CurrentDomain(pc),-(a7)

	 move.l    a0,a4
	 LBLOCKEAI ScrollAreaClass_ID,a0,a1
	 move.l    a1,_CurrentDomain

	 LBLOCKEAI RawEditorClass_ID,a0,a1
	 bsr       REDCursor
	 bsr       REDCursorDown
	 tst.l     d0
	 bne.s     .Done
	 bsr       REDCursor
.Done:

	 move.l    (a7)+,_CurrentDomain
	 movem.l   (a7)+,a2/a4
	 rts
;fe
;fs "UnSelectLine"
REDUnSelectLine:
	 movem.l   d2/a2-4/a6,-(a7)

	 LBLOCKEAI RawEditorClass_ID,a0,a2

	 lea       _EditBuffer,a1
	 move.l    a1,a3
	 move.l    a1,d0
.CountLength:
	 move.b    (a1)+,d1
	 beq.s     .CLDone
	 cmp.b     #" ",d1
	 beq.s     .CountLength
	 cmp.b     #9,d1
	 beq.s     .CountLength
	 move.l    a1,d0
	 bra.s     .CountLength
.CLDone:

	 sub.l     a3,d0
	 move.l    red_REDT_SelectedLine(a2),a4
	 move.l    d0,ble_Length(a4)
	 ;beq.s     .Done

	 move.l    (AbsExecBase).w,a6
	 addq.l    #1,d0
	 move.l    red_REDT_BufListMemPool(a2),a0
	 CALL      AllocPooled
	 move.l    d0,ble_String(a4)
	 beq.s     .Fail

	 move.l    d0,a0
.CpyLoop:
	 move.b    (a3)+,(a0)+
	 bne.s     .CpyLoop

.Done:
	 clr.l     red_REDT_SelectedLine(a2)
	 movem.l   (a7)+,d2/a2-4/a6
	 rts

.Fail:
	 clr.l     ble_Length(a4)
	 bra.s     .Done
;fe
;fs "SelectLine"
REDSelectLine:
	 movem.l   d2-3/a2/a6,-(a7)

	 LBLOCKEAI RawEditorClass_ID,a0,a2
	 move.l    red_REDT_CursorLine(a2),d2
	 beq.s     .Fail

	 move.l    red_REDT_SelectedLine(a2),d3
	 beq.s     .DontStoreOld
	 cmp.l     d2,d3
	 beq.s     .Ok

	 DOMTDI    REM_UnSelectLine,a0

.DontStoreOld:
	 move.l    d2,red_REDT_SelectedLine(a2)
	 move.l    d2,a0

	 lea       _EditBuffer,a6
	 clr.b     (a6)
	 move.l    ble_String(a0),a1
	 move.l    a6,ble_String(a0)

	 move.l    ble_Length(a0),d0
	 move.l    d0,_EditBufferLength

	 move.l    a1,a0
.StrCpy:
	 move.b    (a0)+,(a6)+
	 bne.s     .StrCpy

	 addq.l    #1,d0
	 move.l    (AbsExecBase).w,a6
	 move.l    red_REDT_BufListMemPool(a2),a0
	 CALL      FreePooled

.Ok:
	 moveq     #-1,d0

.Done:
	 movem.l   (a7)+,d2-3/a2/a6
	 rts

.Fail:
	 moveq     #0,d0
	 bra.s     .Done
_EditBufferLength:
	 ds.l      1
;fe
;fs "InsertChar"
REDInsertChar:     ; d2=char
	 cmp.b     #9,d2
	 beq.s     .Tab

	 movem.l   d2-7/a2-6,-(a7)

	 move.l    a0,a4
	 LBLOCKEAI RawEditorClass_ID,a0,a2
	 LBLOCKEAI ScrollAreaClass_ID,a0,a6

	 cmp.b     #8,d2
	 beq.s     .BackSpace

	 DOMTDI    REM_SelectLine,a0
	 tst.l     d0
	 beq.s     .Fail

	 cmp.b     #$7f,d2
	 beq       REDRemoveChar
	 cmp.b     #$a,d2
	 beq       REDBreakLine

	 lea       _EditBuffer,a0
	 move.l    a0,a1
	 move.l    _EditBufferLength,d0
	 add.l     d0,a1
	 addq.l    #1,a1
	 add.l     red_REDT_CursorOffset(a2),a0

.Loop:
	 move.b    -(a1),1(a1)
	 cmp.l     a0,a1
	 bne.s     .Loop

	 move.b    d2,(a1)

	 addq.l    #1,d0
	 move.l    d0,_EditBufferLength
	 move.l    red_REDT_SelectedLine(a2),a0
	 move.l    d0,ble_Length(a0)

	 moveq     #-1,d0
	 move.l    d0,ble_Refresh(a0)
	 move.l    d0,red_REDT_RebuildDTbl(a2)

	 move.l    a2,a1
	 bsr       REDCursorRight
	 move.l    a1,a2

	 move.l    a0,a1
	 move.l    ble_ChunksNS(a1),d0
	 sub.l     d0,sac_SADT_VTotalNVS(a6)
	 move.l    ble_ChunksSC(a1),d0
	 sub.l     d0,sac_SADT_VTotalVS(a6)
	 bsr       REDCountBLineChunks

	 DOMTDI    GCM_Update,a4
.Fail:
	 movem.l   (a7)+,d2-7/a2-a6
	 rts

.Tab:
	 move.l    d2,-(a7)

	 moveq     #" ",d2
	 bsr       REDInsertChar
	 bsr       REDInsertChar
	 bsr       REDInsertChar
	 bsr       REDInsertChar

	 move.l    (a7)+,d2
	 rts

.BackSpace:
	 move.l    red_REDT_CursorLine(a2),d0
	 cmp.l     red_REDT_FirstLine(a2),d0
	 bne.s     .BSOk
	 tst.l     red_REDT_CursorOffset(a2)
	 beq.s     .Fail
.BSOk:

	 move.l    a2,a1
	 bsr       REDCursorLeft
	 move.l    a1,a2

	 DOMTDI    REM_SelectLine,a0
	 tst.l     d0
	 beq.s     .Fail
;fe
;fs "RemoveChar"
REDRemoveChar:
	 lea       _EditBuffer,a1
	 add.l     red_REDT_CursorOffset(a2),a1

	 move.l    red_REDT_SelectedLine(a2),a0

	 tst.b     (a1)
	 beq.s     REDCatenateLines

.Loop:
	 move.b    1(a1),(a1)+
	 bne.s     .Loop

	 move.l    _EditBufferLength,d0
	 subq.l    #1,d0
	 move.l    d0,_EditBufferLength
	 move.l    d0,ble_Length(a0)

	 moveq     #-1,d0
	 move.l    d0,ble_Refresh(a0)
	 move.l    d0,red_REDT_RebuildDTbl(a2)

	 move.l    a0,a1
	 move.l    ble_ChunksNS(a1),d0
	 sub.l     d0,sac_SADT_VTotalNVS(a6)
	 move.l    ble_ChunksSC(a1),d0
	 sub.l     d0,sac_SADT_VTotalVS(a6)
	 bsr.s     REDCountBLineChunks

	 move.l    red_REDT_CursorAlwayVisible(a2),d2
	 clr.l     red_REDT_CursorAlwayVisible(a2)
	 DOMTDI    GCM_Update,a4
	 move.l    d2,red_REDT_CursorAlwayVisible(a2)
.Fail:
	 movem.l   (a7)+,d2-7/a2-a6
	 rts

;fe
;fs "CatenateLines"
REDCatenateLines:
	 move.l    (a0),a5
	 tst.l     (a5)
	 beq.s     .Fail

	 move.l    a0,a3
	 DOMTDI    REM_SelectLine,a4

	 move.l    ble_ChunksNS(a3),d0
	 sub.l     d0,sac_SADT_VTotalNVS(a6)
	 move.l    ble_ChunksSC(a3),d0
	 sub.l     d0,sac_SADT_VTotalVS(a6)
	 move.l    ble_ChunksNS(a5),d0
	 sub.l     d0,sac_SADT_VTotalNVS(a6)
	 move.l    ble_ChunksSC(a5),d0
	 sub.l     d0,sac_SADT_VTotalVS(a6)

	 move.l    ble_String(a3),a1
	 move.l    ble_Length(a3),d0
	 add.l     d0,a1

	 add.l     ble_Length(a5),d0
	 move.l    d0,ble_Length(a3)
	 move.l    d0,_EditBufferLength

	 move.l    ble_String(a5),a0

.CpyLoop:
	 move.b    (a0)+,(a1)+
	 bne.s     .CpyLoop

	 move.l    a5,a1
	 REMOVE

	 moveq     #-1,d0
	 move.l    d0,ble_Refresh(a3)
	 move.l    d0,red_REDT_RebuildDTbl(a2)
	 moveq     #1,d0
	 sub.l     d0,red_REDT_NumBufLines(a2)

	 move.l    a3,a1
	 bsr       REDCountBLineChunks

	 move.l    red_REDT_CursorAlwayVisible(a2),d2
	 clr.l     red_REDT_CursorAlwayVisible(a2)
	 DOMTDI    GCM_Update,a4
	 move.l    d2,red_REDT_CursorAlwayVisible(a2)

	 move.l    (AbsExecBase).w,a6
	 move.l    ble_String(a5),a1
	 move.l    red_REDT_BufListMemPool(a2),a3
	 move.l    a3,a0
	 move.l    ble_Length(a5),d0
	 addq.l    #1,d0
	 CALL      FreePooled

	 move.l    a5,a1
	 move.l    a3,a0
	 moveq     #ble_Size,d0
	 CALL      FreePooled

.Fail:
	 movem.l   (a7)+,d2-7/a2-a6
	 rts
;fe
;fs "BreakLine"
REDBreakLine:
	 move.l    red_REDT_SelectedLine(a2),a3

	 move.l    ble_ChunksNS(a3),d0
	 sub.l     d0,sac_SADT_VTotalNVS(a6)
	 move.l    ble_ChunksSC(a3),d0
	 sub.l     d0,sac_SADT_VTotalVS(a6)

	 move.l    red_REDT_CursorOffset(a2),d2
	 move.l    ble_Length(a3),d3
	 sub.l     d2,d3

	 move.l    a6,d7
	 move.l    (AbsExecBase).w,a6
	 move.l    red_REDT_BufListMemPool(a2),a0
	 moveq     #ble_Size,d0
	 CALL      AllocPooled
	 tst.l     d0
	 beq.s     .Fail
	 move.l    d0,a5

	 move.l    d3,d0
	 move.l    red_REDT_BufListMemPool(a2),a0
	 addq.l    #1,d0
	 CALL      AllocPooled
	 move.l    d0,ble_String(a5)
	 beq.s     .Fail

	 move.l    d3,ble_Length(a5)
	 move.l    d0,a1
	 lea       _EditBuffer,a0
	 move.l    a0,a6
	 add.l     d2,a0

.CpyLoop:
	 move.b    (a0)+,(a1)+
	 bne.s     .CpyLoop

	 clr.b     (a6,d2.l)
	 move.l    d2,ble_Length(a3)
	 move.l    d2,_EditBufferLength

	 move.l    d7,a6
	 move.l    ble_Next(a3),a0
	 move.l    a0,ble_Next(a5)
	 move.l    a5,ble_Next(a3)
	 move.l    a3,ble_Prev(a5)
	 move.l    a5,ble_Prev(a0)

	 moveq     #-1,d0
	 move.l    d0,ble_Refresh(a3)
	 move.l    d0,ble_Refresh(a5)
	 move.l    d0,red_REDT_RebuildDTbl(a2)
	 moveq     #1,d0
	 add.l     d0,red_REDT_NumBufLines(a2)

	 move.l    a3,a1
	 bsr       REDCountBLineChunks

	 move.l    a5,a1
	 bsr       REDCountBLineChunks

	 move.l    a5,red_REDT_CursorLine(a2)
	 move.l    a2,a5
	 clr.l     red_REDT_CursorOffset(a5)
	 move.l    a5,a1
	 bsr       REDPlaceCursor

	 DOMTDI    REM_MakeCursorVisible,a4
	 tst.l     d0
	 bne.s     .Fail
	 move.l    red_REDT_CursorAlwayVisible(a5),d2
	 clr.l     red_REDT_CursorAlwayVisible(a5)
	 DOMTDI    GCM_Update,a4
	 move.l    d2,red_REDT_CursorAlwayVisible(a5)

.Fail:
	 movem.l   (a7)+,d2-7/a2-a6
	 rts
;fe

;fs "CountBLineChunks"
REDCountBLineChunks:         ; a1=bline
	 move.l    red_REDT_AlignType(a2),d0
	 lea       REDAlignTable(pc),a0
	 move.l    (a0,d0.w),a0
	 move.l    (a0),a0

	 move.l    sac_SADT_HVisibleNVS(a6),d0
	 jsr       (a0)
	 move.l    d0,ble_ChunksNS(a1)
	 add.l     d0,sac_SADT_VTotalNVS(a6)

	 move.l    sac_SADT_HVisibleVS(a6),d0
	 jsr       (a0)
	 move.l    d0,ble_ChunksSC(a1)
	 add.l     d0,sac_SADT_VTotalVS(a6)

	 rts
;fe

;fs "Alignment methods table"
REDAlignTable:
	 dc.l      REDNoWrap
	 dc.l      REDSimpleWrap
	 dc.l      REDWWLeft
	 dc.l      REDWWLeft ; Ici prochainement, ouverture d'un mode
			     ; aligné à droite
	 dc.l      REDWWCenter


;fs "Nowrap"
REDNoWrap:
	 dc.l      REDNoWrapCC
	 dc.l      REDNoWrapLO
	 dc.l      REDNoWrapRE
	 dc.l      REDNoWrapFDL
	 dc.l      REDNoWrapCP
	 dc.l      REDNoWrapCCK

REDNoWrapCC:
	 moveq     #1,d0
	 rts

REDNoWrapLO:
	 movem.l   d2-3/d7/a0,-(a7)
	 moveq     #4,d2
	 move.l    ble_Length(a2),d3
	 move.l    ble_String(a2),a0
	 moveq     #0,d7
	 bsr.s     REDStoreDEntry
	 moveq     #0,d1
	 movem.l   (a7)+,d2-3/d7/a0
	 rts

REDNoWrapRE:
	 move.l    dte_NumChars(a3),d5
	 moveq     #1,d4
	 move.l    d2,d7
	 move.l    dte_Text(a3),a5
	 moveq     #2,d6
	 bsr       _DrawText
	 rts

REDNoWrapFDL:      ; a0=buffer line d0=llength d1=offset
	 moveq     #0,d0
	 rts

REDNoWrapCP:       ; a0=DLine d0=DLOffset
	 lsl.l     #3,d0
	 rts

REDNoWrapCCK:      ; a0=DLine d0=X
	 lsr.l     #3,d0
	 rts
;fe
;fs "Simplewrap"
REDSimpleWrap:
	 dc.l      REDSWrapCC
	 dc.l      REDSWrapLO
	 dc.l      REDNoWrapRE
	 dc.l      REDSWrapFDL
	 dc.l      REDNoWrapCP
	 dc.l      REDNoWrapCCK

REDSWrapCC:
	 subq.l    #1,d0
	 move.l    ble_Length(a1),d1
	 divu      d0,d1
	 move.l    d1,d0
	 swap      d1

	 ext.l     d0
	 beq.s     .Pff
	 tst.w     d1
	 beq.s     .Done
.Pff:
	 addq.l    #1,d0
.Done:
	 rts

REDSWrapLO:
	 movem.l   d0/d2-4/d7/a0/a4,-(a7)
	 subq.l    #1,d0
	 move.l    ble_String(a2),a4
	 move.l    d4,d7
	 mulu      d0,d4
	 move.l    d4,d1
	 add.l     d4,a4

	 neg.l     d4
	 add.l     ble_Length(a2),d4

.Loop:
	 tst.l     (a3)
	 bmi.s     .Done

	 move.l    a4,a0
	 moveq     #4,d2
	 move.l    d0,d3

	 cmp.l     d0,d4
	 bcc.s     .LengthOk
	 move.l    d4,d3
.LengthOk:
	 bsr       REDStoreDEntry

	 add.l     d0,a4
	 addq.l    #1,d7
	 sub.l     d0,d4
	 bgt.s     .Loop

.Done:
	 movem.l   (a7)+,d0/d2-4/d7/a0/a4
	 rts

REDSWrapFDL:       ; a0=buffer line d0=llength d1=offset
	 subq.l    #1,d0
	 move.l    ble_Length(a0),d2
	 cmp.l     d1,d2
	 bcc.s     .Ok
	 move.l    d2,d1
.Ok:
	 divu      d0,d1
	 move.w    d1,d0
	 ext.l     d0
	 swap      d1
	 ext.l     d1
	 rts
;fe

;fs "Word wrap"
REDWWrapCC:
	 movem.l   d2-3/a4-5,-(a7)
	 moveq     #1,d3
	 move.l    ble_Length(a1),d2
	 beq.s     .Done

	 move.l    ble_String(a1),a4
.Loop:
	 cmp.l     d2,d0
	 bcc.s     .Done
	 bsr       REDWWSkipChunk
	 sub.l     d1,d2
	 addq.l    #1,d3
	 bra.s     .Loop
.Done:
	 move.l    d3,d0
	 movem.l   (a7)+,d2-3/a4-5
	 rts

REDWWrapLO:
	 movem.l   d2-7/a0/a4-5,-(a7)
	 move.l    ble_String(a2),a4
	 move.l    ble_Length(a2),d5
	 moveq     #0,d6
	 move.l    d4,d7
	 subq.l    #1,d4
	 bmi.s     .Loop

.SkipChunksLoop:
	 bsr       REDWWSkipChunk
	 sub.l     d1,d5
	 add.l     d1,d6
	 dbf       d4,.SkipChunksLoop

.Loop:
	 tst.l     (a3)
	 bmi.s     .Done

	 move.l    a4,a0
	 moveq     #4,d2
	 move.l    d5,d3
	 cmp.l     d5,d0
	 bcc.s     .LastChunk
	 bsr       REDWWSkipChunk
	 move.l    d1,d3
	 subq.l    #1,d3
	 bsr       REDStoreDEntry

	 addq.l    #1,d7
	 sub.l     d1,d5
	 bgt.s     .Loop
	 bra.s     .Done

.LastChunk:
	 bsr       REDStoreDEntry

.Done:
	 move.l    d6,d1
	 movem.l   (a7)+,d2-7/a0/a4-5
	 rts

REDWWrapFDL:       ; a0=bufline d0=llength d1=offset
	 moveq     #0,d0
	 moveq     #0,d1
	 rts

REDWWSkipChunk:    ; a4=str d0=lwidth
	 lea       (a4,d0.l),a5
	 move.l    d0,d1
	 subq.l    #1,d1

.Loop:
	 cmp.b     #" ",-(a5)
	 beq.s     .Ok
	 dbf       d1,.Loop
	 lea       -1(a4,d0.l),a4
	 move.l    d0,d1
	 ;addq.l    #1,d1
	 rts
.Ok:
	 move.l    a5,d1
	 sub.l     a4,d1
	 addq.l    #1,d1
	 lea       1(a5),a4
	 rts
;fe
;fs "WW Left"
REDWWLeft:
	 dc.l      REDWWrapCC
	 dc.l      REDWWrapLO
	 dc.l      REDNoWrapRE
;fe
;fs "WW Center"
REDWWCenter:
	 dc.l      REDWWrapCC
	 dc.l      REDWWrapLO
	 dc.l      REDCenterRE
	 dc.l      REDWWrapFDL
	 dc.l      REDNoWrapCP

REDCenterRE:
	 move.l    dte_NumChars(a3),d5
	 move.l    d5,d0
	 lsl.l     #3,d0

	 move.l    red_REDT_Width(a1),d6
	 sub.l     d0,d6
	 lsr.l     #1,d6
	 move.l    d6,dte_XPos(a3)
	 move.l    d2,d7
	 move.l    dte_Text(a3),a5
	 moveq     #1,d4
	 bsr       _DrawText
	 rts
;fe

;fs "Common code"
REDStoreDEntry:    ; a3=DEntry, d2=XPos, d3=Numchars, a0=Text, a2=blentry
	 move.l    d2,dte_XPos(a3)

	 move.l    a0,d2
	 move.l    a0,dte_Text(a3)

	 add.l     a2,d2
	 move.l    a2,dte_BLEntry(a3)

	 add.l     d7,d2
	 move.l    d7,dte_Offset(a3)

	 add.l     d3,d2
	 move.l    d3,dte_NumChars(a3)

	 move.l    dte_Check(a3),d3
	 move.l    d2,dte_Check(a3)
	 eor.l     d2,d3
	 or.l      ble_Refresh(a2),d3
	 move.l    d3,dte_Update(a3)

	 lea       dte_Size(a3),a3
	 rts
;fe
;fe

;fs "Cursor handling"
;fs "ShowCursor"
REDShowCursor:
	 tst.l     red_REDT_CursorEnabled(a1)
	 beq.s     .Ok
	 rts
.Ok:
	 moveq     #-1,d0
	 move.l    d0,red_REDT_CursorEnabled(a1)
	 bra.s     REDDrawCursor
;fe
;fs "HideCursor"
REDHideCursor:
	 tst.l     red_REDT_CursorEnabled(a1)
	 bne.s     .Ok
	 rts
.Ok:
	 clr.l     red_REDT_CursorEnabled(a1)
;fe
;fs "DrawCursor"
REDDrawCursor:
	 movem.l   d3-7,-(a7)
	 move.l    red_REDT_CursorX(a1),d4
	 bmi.s     .Done
	 move.l    red_REDT_CursorY(a1),d5
	 moveq     #8,d6
	 moveq     #8,d7
	 moveq     #-1,d3
	 bsr       _DrawRectangle
.Done:
	 movem.l   (a7)+,d3-7
	 rts
;fe
;fs "Cursor"
REDCursor:
	 tst.l     red_REDT_CursorEnabled(a1)
	 bne.s     REDDrawCursor
	 rts
;fe
;fs "CursorUp"
REDCursorUp:
	 movem.l   a0-1,-(a7)

	 moveq     #0,d0
	 tst.l     red_REDT_CursorX(a1)
	 bmi.s     .Done
	 move.l    red_REDT_CursorDLNum(a1),d0
	 beq.s     .Done

	 subq.l    #1,d0
	 move.l    d0,red_REDT_CursorDLNum(a1)
	 moveq     #8,d0
	 sub.l     d0,red_REDT_CursorY(a1)

	 move.l    red_REDT_CursorDLine(a1),a0
	 lea       -dte_Size(a0),a0
	 move.l    a0,red_REDT_CursorDLine(a1)
	 move.l    dte_Offset(a0),red_REDT_CursorDLOffset(a1)

	 move.l    red_REDT_CursorDLCharOffset(a1),d0
	 move.l    dte_NumChars(a0),d1

	 cmp.l     d0,d1
	 bcc.s     .Ok
	 move.l    d1,d0
.Ok:

	 move.l    d0,red_REDT_CursorDLCharOffset(a1)
	 move.l    dte_BLEntry(a0),a2
	 move.l    a2,red_REDT_CursorLine(a1)
	 move.l    dte_Text(a0),d1
	 sub.l     ble_String(a2),d1
	 add.l     d0,d1
	 move.l    d1,red_REDT_CursorOffset(a1)

	 move.l    red_REDT_AlignType(a1),d1
	 lea       REDAlignTable(pc),a2
	 move.l    (a2,d1.w),a2
	 move.l    ras_CursorPos(a2),a2
	 jsr       (a2)

	 addq.l    #2,d0
	 move.l    d0,red_REDT_CursorX(a1)

	 DOMTDI    REM_MakeCursorVisible,a4

.Done:
	 movem.l   (a7)+,a0-1
	 rts
;fe
;fs "CursorDown"
REDCursorDown:
	 movem.l   a0-1,-(a7)

	 moveq     #0,d0
	 tst.l     red_REDT_CursorX(a1)
	 bmi.s     .Done
	 move.l    red_REDT_CursorDLNum(a1),d1
	 addq.l    #1,d1
	 cmp.l     red_REDT_DispEntNum(a1),d1
	 beq.s     .Done

	 move.l    red_REDT_CursorDLine(a1),a0
	 lea       dte_Size(a0),a0

	 tst.l     dte_Text(a0)
	 bmi.s     .Done
	 tst.l     dte_NumChars(a0)
	 bmi.s     .Done

	 move.l    d1,d0
	 move.l    a0,red_REDT_CursorDLine(a1)
	 move.l    dte_Offset(a0),red_REDT_CursorDLOffset(a1)

	 move.l    d0,red_REDT_CursorDLNum(a1)
	 moveq     #8,d0
	 add.l     d0,red_REDT_CursorY(a1)

	 move.l    red_REDT_CursorDLCharOffset(a1),d0
	 move.l    dte_NumChars(a0),d1

	 cmp.l     d0,d1
	 bcc.s     .Ok
	 move.l    d1,d0
.Ok:

	 move.l    d0,red_REDT_CursorDLCharOffset(a1)
	 move.l    dte_BLEntry(a0),a2
	 move.l    a2,red_REDT_CursorLine(a1)
	 move.l    dte_Text(a0),d1
	 sub.l     ble_String(a2),d1
	 add.l     d0,d1
	 move.l    d1,red_REDT_CursorOffset(a1)

	 move.l    red_REDT_AlignType(a1),d1
	 lea       REDAlignTable(pc),a2
	 move.l    (a2,d1.w),a2
	 move.l    ras_CursorPos(a2),a2
	 jsr       (a2)

	 addq.l    #2,d0
	 move.l    d0,red_REDT_CursorX(a1)

	 DOMTDI    REM_MakeCursorVisible,a4

.Done:
	 movem.l   (a7)+,a0-1
	 rts
;fe
;fs "CursorLeft"
REDCursorLeft:
	 movem.l   a0-1,-(a7)

	 moveq     #0,d0
	 move.l    red_REDT_CursorOffset(a1),d1
	 bne.s     .Ok

	 move.l    red_REDT_CursorLine(a1),a0
	 move.l    ble_Prev(a0),a0
	 tst.l     ble_Prev(a0)
	 beq.s     .Done
	 move.l    a0,red_REDT_CursorLine(a1)
	 move.l    ble_Length(a0),d1
	 beq.s     .Gna
	 addq.l    #1,d1
.Ok:
	 subq.l    #1,d1
.Gna:
	 move.l    d1,red_REDT_CursorOffset(a1)

	 bsr       REDPlaceCursor

	 DOMTDI    REM_MakeCursorVisible,a4

.Done:
	 movem.l   (a7)+,a0-1
	 rts
;fe
;fs "CursorRight"
REDCursorRight:
	 movem.l   a0-1,-(a7)

	 move.l    red_REDT_CursorLine(a1),a0
	 move.l    red_REDT_CursorOffset(a1),d0
	 addq.l    #1,d0
	 move.l    ble_Length(a0),d1
	 addq.l    #1,d1
	 cmp.l     d1,d0
	 bcs.s     .Ok

	 moveq     #0,d0
	 move.l    (a0),a0
	 tst.l     (a0)
	 beq.s     .Done
	 move.l    a0,red_REDT_CursorLine(a1)

.Ok:
	 move.l    d0,red_REDT_CursorOffset(a1)

	 bsr       REDPlaceCursor

	 DOMTDI    REM_MakeCursorVisible,a4

.Done:
	 movem.l   (a7)+,a0-1
	 rts
;fe
;fs "PlaceCursor"
REDPlaceCursor:
	 move.l    a0,-(a7)
	 tst.l     red_REDT_NumBufLines(a1)
	 beq.s     .OffScreen

	 move.l    red_REDT_AlignType(a1),d0
	 lea       REDAlignTable(pc),a2
	 move.l    (a2,d0.w),a2
	 move.l    ras_FindDline(a2),a3

	 move.l    red_REDT_CursorLine(a1),a0
	 move.l    sac_SADT_VSFlag(a6),d0
	 move.l    sac_SADT_HTotalNVS(a6,d0.w),d0
	 move.l    red_REDT_CursorOffset(a1),d1
	 jsr       (a3)

	 movem.l   d0-1,red_REDT_CursorDLOffset(a1)

	 move.l    red_REDT_DispTable(a1),a0
	 move.l    red_REDT_CursorLine(a1),a3
	 move.l    red_REDT_CursorDLOffset(a1),d0
	 moveq     #1,d3
	 moveq     #0,d4
.Loop:
	 move.l    dte_Text(a0),d1
	 bmi.s     .OffScreen
	 move.l    dte_NumChars(a0),d2
	 bmi.s     .OffScreen

	 cmp.l     dte_BLEntry(a0),a3
	 bne.s     .Next

	 cmp.l     dte_Offset(a0),d0
	 beq.s     .Found
.Next:
	 addq.l    #8,d3
	 addq.l    #1,d4
	 lea       dte_Size(a0),a0
	 bra.s     .Loop

.Found:
	 movem.l   d3-4,red_REDT_CursorY(a1)
	 move.l    a0,red_REDT_CursorDLine(a1)

	 move.l    ras_CursorPos(a2),a3
	 move.l    red_REDT_CursorDLCharOffset(a1),d0
	 jsr       (a3)
	 addq.l    #2,d0
	 move.l    d0,red_REDT_CursorX(a1)

	 move.l    (a7)+,a0
	 rts

.OffScreen:
	 move.l    #-1,red_REDT_CursorX(a1)
	 move.l    (a7)+,a0
	 rts
;fe
;fe
;fe

;fs "FloatTextClass"
;fs "Structure"
_FloatTextClass:
	 dc.l      0
	 dc.l      _RawEditorClass
	 dc.l      0,0,0,0,0
	 dc.l      flt_DataSize
	 dc.l      empty_Funcs
	 dc.l      floattext_data
	 dc.l      0
	 dc.l      floattext_Init

floattext_data:
	 ds.b      flt_DataSize
;fe
;fs "Init"
floattext_Init:
	 move.l    #MTD_New,d0
	 lea       FTXTNew,a1
	 bsr       _SetMethod
	 move.l    d0,FTXTSNew
	 rts
FTXTSNew:
	 ds.l      1
;fe

;fs "New"
FTXTNew:
	 move.l    a0,-(a7)
	 move.l    FTXTSNew(pc),a1
	 jsr       (a1)
	 move.l    (a7)+,a0

	 movem.l   a0-4,-(a7)

	 LBLOCKEAI RawEditorClass_ID,a0,a4
	 moveq     #TXTA_SIMPLEWRAP,d0
	 move.l    d0,red_REDT_AlignType(a4)

	 LBLOCKEAI FloatTextClass_ID,a0,a1
	 move.l    flt_FLTX_FData(a1),d0
	 beq.s     .TrucEtTout

	 move.l    a0,-(a7)
	 move.l    (AbsExecBase).w,a6
	 move.l    red_REDT_Buffer(a4),a0
	 move.l    d0,a1
	 lea       .PutChar(pc),a2
	 lea       _StrBuf,a3
	 move.l    a3,red_REDT_Buffer(a4)
	 CALL      RawDoFmt
	 move.l    (a7)+,a0
	 lea       CustomBase,a6

.TrucEtTout:
	 movem.l   (a7)+,a0-4

	 DOMTDJI   REM_DigestBuffer,a0

.PutChar:
	 move.b    d0,(a3)+
	 rts
;fe
;fe
;fs "EditorClass"
;fs "Structure"
_EditorClass:
	 dc.l      0
	 dc.l      _RawEditorClass
	 dc.l      0,0,0,0,0
	 dc.l      0
	 dc.l      empty_Funcs
	 dc.l      0
	 dc.l      0
	 dc.l      editor_Init
;fe
;fs "Init"
editor_Init:
	 move.l    #MTD_New,d0
	 lea       EDNew,a1
	 bsr       _SetMethod
	 move.l    d0,EDSNew

	 move.l    #GCM_Click,d0
	 lea       EDClick,a1
	 bsr       _SetMethod
	 move.l    d0,EDSClick

	 move.l    #GCM_HandleRawKey,d0
	 lea       EDRawKey,a1
	 bsr       _SetMethod

	 move.l    #GCM_HandleAsciiKey,d0
	 lea       EDAsciiKey,a1
	 bsr       _SetMethod

	 move.l    #REM_MakeCursorVisible,d0
	 lea       EDMakeCursorVisible,a1
	 bsr       _SetMethod

	 move.l    #REM_Clicked,d0
	 lea       EDClicked,a1
	 bsr       _SetMethod
	 rts

EDSClick:
	 ds.l      1
;fe

;fs "New"
EDNew:
	 move.l    a2,-(a7)
	 move.l    a0,a2
	 move.l    EDSNew(pc),a1
	 jsr       (a1)

	 LBLOCKEAI RawEditorClass_ID,a2,a1
	 moveq     #-1,d0
	 move.l    d0,red_REDT_CursorEnabled(a1)
	 move.l    d0,red_REDT_CursorAlwayVisible(a1)
	 moveq     #TXTA_SIMPLEWRAP,d0
	 move.l    d0,red_REDT_AlignType(a1)
	 move.l    (a7)+,a2
	 rts

EDSNew:
	 ds.l      1
;fe
;fs "Click"
EDClick:
	 move.l    a2,-(a7)
	 move.l    a0,a2
	 move.l    _CurrentGuiObject,a0
	 DOMTDI    GM_Activate,a0
	 move.l    a2,a0
	 move.l    EDSClick(pc),a1
	 jsr       (a1)
	 move.l    (a7)+,a2
	 rts
;fe
;fs "HandleRawKey"
EDRawKey:
	 cmp.b     #$4f,d0
	 beq.s     .Left
	 cmp.b     #$4e,d0
	 beq.s     .Right
	 cmp.b     #$4c,d0
	 beq.s     .Up
	 cmp.b     #$4d,d0
	 beq.s     .Down
	 rts

.Left:
	 DOMTDJI   REM_MoveCursorLeft,a0
.Right:
	 DOMTDJI   REM_MoveCursorRight,a0
.Up:
	 DOMTDJI   REM_MoveCursorUp,a0
.Down:
	 DOMTDJI   REM_MoveCursorDown,a0
;fe
;fs "HandleAsciiKey"
EDAsciiKey:
	 move.b    d0,d2
	 DOMTDJI   REM_InsertChar,a0
;fe
;fs "MakeCursorVisible"
EDMakeCursorVisible:
	 movem.l   d2/a2,-(a7)

	 LBLOCKEAI RawEditorClass_ID,a0,a1
	 LBLOCKEAI ScrollAreaClass_ID,a0,a2

	 move.l    red_REDT_CursorDLNum(a1),d0
	 move.l    sac_SADT_VPos(a2),d2

	 moveq     #2,d1
	 sub.l     d0,d1
	 ;bra       .VMinOk
	 bmi.s     .VMinOk
	 sub.l     d1,d2
	 bmi.s     .DontUpdate
	 bra.s     .Update
.VMinOk:

	 addq.l    #3,d0
	 move.l    sac_SADT_HSFlag(a2),d1
	 sub.l     sac_SADT_VVisibleNHS(a2,d1.l),d0
	 bmi.s     .DontUpdate
	 add.l     d0,d2

.Update:
	 move.l    d2,sac_SADT_VPos(a2)

	 move.l    a1,a2
	 move.l    red_REDT_CursorAlwayVisible(a2),d2
	 clr.l     red_REDT_CursorAlwayVisible(a2)
	 DOMTDI    GCM_Update,a0
	 move.l    d2,red_REDT_CursorAlwayVisible(a2)
	 moveq     #-1,d0
	 bra.s     .Done

.DontUpdate:
	 moveq     #0,d0

.Done:
	 movem.l   (a7)+,d2/a2
	 rts
;fe
;fs "Clicked"
EDClicked:
	 LBLOCKEAI RawEditorClass_ID,a0,a1
	 move.l    a2,red_REDT_CursorLine(a1)
	 move.l    d0,red_REDT_CursorOffset(a1)
	 moveq     #-1,d0
	 move.l    d0,red_REDT_RebuildDTbl(a1)

	 DOMTDJI   SAM_ContentsUpdate,a0
;fe
;fe
