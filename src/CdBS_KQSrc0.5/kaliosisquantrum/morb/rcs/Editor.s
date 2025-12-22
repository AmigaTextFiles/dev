head	0.16;
access;
symbols;
locks
	MORB:0.16; strict;
comment	@# @;


0.16
date	98.04.29.13.41.09;	author MORB;	state Exp;
branches;
next	0.15;

0.15
date	98.04.28.12.24.00;	author MORB;	state Exp;
branches;
next	0.14;

0.14
date	98.04.27.01.19.22;	author MORB;	state Exp;
branches;
next	0.13;

0.13
date	98.04.26.23.27.41;	author MORB;	state Exp;
branches;
next	0.12;

0.12
date	98.04.15.14.16.27;	author MORB;	state Exp;
branches;
next	0.11;

0.11
date	98.04.14.03.25.47;	author MORB;	state Exp;
branches;
next	0.10;

0.10
date	98.04.14.03.15.01;	author MORB;	state Exp;
branches;
next	0.9;

0.9
date	98.04.14.02.29.57;	author MORB;	state Exp;
branches;
next	0.8;

0.8
date	98.04.13.16.07.20;	author MORB;	state Exp;
branches;
next	0.7;

0.7
date	98.04.12.13.53.40;	author MORB;	state Exp;
branches;
next	0.6;

0.6
date	98.03.31.17.58.07;	author MORB;	state Exp;
branches;
next	0.5;

0.5
date	98.01.10.23.25.33;	author MORB;	state Exp;
branches;
next	0.4;

0.4
date	98.01.10.20.32.28;	author MORB;	state Exp;
branches;
next	0.3;

0.3
date	98.01.10.16.00.26;	author MORB;	state Exp;
branches;
next	0.2;

0.2
date	98.01.10.11.49.10;	author MORB;	state Exp;
branches;
next	0.1;

0.1
date	98.01.05.22.19.37;	author MORB;	state Exp;
branches;
next	0.0;

0.0
date	98.01.05.22.16.35;	author MORB;	state Exp;
branches;
next	;


desc
@@


0.16
log
@Written VomitBuffer method. * The Editor Class is complete !!! * (argh)
@
text
@*
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
@


0.15
log
@Mouse pointer can not longer go out of the editor while lmb is down.
@
text
@d6 1
a6 1
* $Id: Editor.s 0.14 1998/04/27 01:19:22 MORB Exp MORB $
d832 41
@


0.14
log
@Implemented mouse cursor teleportation feature
@
text
@d6 1
a6 1
* $Id: Editor.s 0.13 1998/04/26 23:27:41 MORB Exp MORB $
d662 11
d732 4
a736 3

;REDCounter:
;         ds.l      1
d1932 5
d1963 19
d1984 1
d1990 3
a1992 1
	 jmp       (a1)
@


0.13
log
@Added some cursor/scrolling stuff
@
text
@d6 1
a6 1
* $Id: Editor.s 0.12 1998/04/15 14:16:27 MORB Exp MORB $
d18 1
d35 1
d119 1
d647 3
a662 1
	 rts
d666 40
a705 2
	 btst      #6,$bfe001
	 bne.s     .Release
d707 6
d715 2
d723 2
a724 2
REDCounter:
	 ds.l      1
d1316 1
d1349 4
d1361 1
d1936 4
d2023 10
@


0.12
log
@Fixed many graphic bugs. It looks pretty good now...
@
text
@d6 1
a6 1
* $Id: Editor.s 0.11 1998/04/14 03:25:47 MORB Exp MORB $
d34 1
a96 32
;fs "New"
;REDNew:
;         movem.l   a2-3,-(a7)
;
;         move.l    a0,a3
;         ;move.l    REDSNew(pc),a1
;         jsr       (a1)
;
;         lea       _VScrollerClass,a0
;         sub.l     a1,a1
;         bsr       _NewObject
;         tst.l     d0
;         beq.s     .Fail
;
;         move.l    d0,a2
;         DOMTDI    MTD_AddMember,a3
;
;         SDATALI   a2,REDT_Scroller,a3
;
;         moveq     #-1,d0
;         SDATALI   d0,VSDT_LayoutNotify,a2
;
;         LBLOCKEAI GuiRootClass_ID,a2,a0
;         ;lea       REDHook(pc),a1
;         movem.l   a1/a3,guir_DTA_Hook(a0)
;
;         moveq     #-1,d0
;.Fail:
;         movem.l   (a7)+,a2-3
;         rts
;fe

d116 1
a118 20
;fs "GetMinMax"
;REDGetMinMax:
;         movem.l   a2-3,-(a7)
;
;         move.l    a0,a2
;
;         LDATALI   REDT_Scroller,a2,a3
;         DOMTDI    GCM_GetMinMax,a3
;
;         LBLOCKEAI GuiRootClass_ID,a3,a0
;         LBLOCKEAI GuiRootClass_ID,a2,a1
;
;         move.l    guir_DTA_MinHeight(a0),guir_DTA_MinHeight(a1)
;         moveq     #40,d0
;         add.l     guir_DTA_MinWidth(a0),d0
;         move.l    d0,guir_DTA_MinWidth(a1)
;
;         movem.l   (a7)+,a2-3
;         rts
;fe
d366 1
a436 1
	 ;illegal
d448 1
a519 40
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

.Done:
	 ;rts
	 bra.s     REDPlaceCursor
;fe
d522 1
a522 1
	 movem.l   d3-4/a2,-(a7)
d525 2
a526 2
	 LBLOCKEAI ScrollAreaClass_ID,a0,a1
	 tst.l     sac_SADT_VSFlag(a1)
a531 2
	 ;move.l    red_REDT_CNumOfst(a1),d3

a556 2
	 ;cmp.l     d4,d1
	 ;bcs.s     .BwdDone
d565 1
a566 1
	 clr.l     red_REDT_FLCharOffset(a1)
d570 76
a645 7
;         tst.l     d2
;         bne.s     .Grumbl
;         ;illegal
;         DOMTDI    GCM_Update,a0
;.Grumbl:
;
	 movem.l   (a7)+,d3-4/a2
d776 1
d783 2
d786 1
d797 1
d804 2
d807 1
d815 1
a815 1
	 move.l    a2,-(a7)
d818 1
d825 2
d829 1
d831 1
a831 1
	 move.l    (a7)+,a2
d836 1
a836 1
	 move.l    a2,-(a7)
d839 1
d846 2
d849 1
d852 1
a852 1
	 move.l    (a7)+,a2
d1071 2
d1074 1
d1124 2
d1127 1
d1210 3
a1212 2
	 clr.l     red_REDT_CursorOffset(a2)
	 move.l    a2,a1
d1215 5
d1221 1
d1519 1
a1519 1
	 tst.l     red_REDT_CursorDisplayed(a1)
d1524 1
a1524 1
	 move.l    d0,red_REDT_CursorDisplayed(a1)
d1529 1
a1529 1
	 tst.l     red_REDT_CursorDisplayed(a1)
d1533 1
a1533 1
	 clr.l     red_REDT_CursorDisplayed(a1)
d1551 1
a1551 1
	 tst.l     red_REDT_CursorDisplayed(a1)
d1557 1
a1557 1
	 move.l    a0,-(a7)
d1559 1
d1600 2
d1603 1
a1603 1
	 move.l    (a7)+,a0
d1608 1
a1608 1
	 move.l    a0,-(a7)
d1610 1
d1613 3
a1615 3
	 move.l    red_REDT_CursorDLNum(a1),d0
	 addq.l    #1,d0
	 cmp.l     red_REDT_DispEntNum(a1),d0
d1626 1
d1659 2
d1662 1
a1662 1
	 move.l    (a7)+,a0
d1667 1
a1667 1
	 move.l    a0,-(a7)
d1669 2
a1670 1
	 move.l    red_REDT_CursorOffset(a1),d0
d1678 1
a1678 1
	 move.l    ble_Length(a0),d0
d1680 1
a1680 1
	 addq.l    #1,d0
d1682 1
a1682 1
	 subq.l    #1,d0
d1684 1
a1684 1
	 move.l    d0,red_REDT_CursorOffset(a1)
d1688 2
d1691 1
a1691 1
	 move.l    (a7)+,a0
d1696 1
a1696 1
	 move.l    a0,-(a7)
a1703 1
	 ;cmp.l     ble_Length(a0),d0
d1706 1
a1710 1
	 moveq     #0,d0
d1717 2
d1720 1
a1720 1
	 move.l    (a7)+,a0
a1724 1
	 ;rts
a1736 2
	 ;move.l    red_REDT_CNumOfst(a1),d0
	 ;move.l    red_REDT_DLLengthNS(a1,d0.w),d0
d1875 4
d1880 1
d1919 43
@


0.11
log
@Added simple tab handling, and fixed a small cursor bug.
@
text
@d6 1
a6 1
* $Id: Editor.s 0.10 1998/04/14 03:15:01 MORB Exp MORB $
d420 1
d422 6
a427 31
;fs "Obsolete"
;         moveq     #0,d0
;         moveq     #0,d1
;         move.l    red_REDT_Width(a1),d2
;         move.l    gd_Height(a2),d3
;         st        d4
;         bsr       _DrawBevelBox

;         tst.l     red_REDT_CNumOfst(a1)
;         beq.s     .NoScroller
;         move.l    red_REDT_Scroller(a1),a3
;
;         move.l    a1,d2
;         move.l    a0,d3
;
;         tst.l     red_REDT_ClearScroller(a1)
;         beq.s     .DontClrScroller
;         clr.l     red_REDT_ClearScroller(a1)
;         DOMTDI    GCM_Clear,a3
;.DontClrScroller:
;         DOMTDI    GCM_Render,a3
;         move.l    d3,a0
;         move.l    d2,a1
;.NoScroller:

;         move.l    red_REDT_Width(a1),d0
;         subq.l    #4,d0
;         move.l    d0,_TextLimit
;fe

	 move.l    gd_Width(a6),_TextLimit
a435 1
	 ;move.l    a2,-(a7)
a450 1
	 subq.l    #4,d6
a468 1
	 ;move.l    (a7)+,a2
a471 1
	 ;subq.l    #4,d6
d475 2
a476 2
	 subq.l    #1,d7
	 ;bsr       _DrawRectangle
d503 6
a508 25
;fs "Obsolete"
;         moveq     #0,d0
;         moveq     #0,d1
;         move.l    red_REDT_Width(a1),d2
;         move.l    gd_Height(a2),d3
;         st        d4
;         bsr       _DrawBevelBox

;         tst.l     red_REDT_CNumOfst(a1)
;         beq.s     .NoScroller
;         move.l    red_REDT_Scroller(a1),a3

;         move.l    a1,d2
;         move.l    a0,d3
;
;         clr.l     red_REDT_ClearScroller(a1)
;         DOMTDI    GCM_Render,a3
;         move.l    d3,a0
;         move.l    d2,a1
;.NoScroller:

;         move.l    red_REDT_Width(a1),d0
;         subq.l    #4,d0
;         move.l    d0,_TextLimit
;fe
a535 1
	 subq.l    #4,d6
d554 10
d1130 13
@


0.10
log
@Written CatenateLines, and added backspace handling.
@
text
@d6 1
a6 1
* $Id: Editor.s 0.9 1998/04/14 02:29:57 MORB Exp MORB $
d999 3
d1059 12
a1633 5
	 ;addq.l    #1,d0
	 move.l    d0,red_REDT_CursorDLNum(a1)
	 moveq     #8,d0
	 add.l     d0,red_REDT_CursorY(a1)

d1636 6
d1644 4
@


0.9
log
@Written RemoveChar routine.
@
text
@d6 1
a6 1
* $Id: Editor.s 0.8 1998/04/13 16:07:20 MORB Exp MORB $
d1004 4
d1013 1
a1013 1
	 beq.s     REDRemoveChar
d1015 1
a1015 1
	 beq.s     .BreakLine
d1042 21
d1064 2
d1067 28
d1107 53
a1159 1
.BreakLine:
a1227 30
	 movem.l   (a7)+,d2-7/a2-a6
	 rts
;fe
;fs "RemoveChar"
REDRemoveChar:
	 lea       _EditBuffer,a0
	 add.l     red_REDT_CursorOffset(a2),a0

.Loop:
	 move.b    1(a0),(a0)+
	 bne.s     .Loop

	 move.l    _EditBufferLength,d0
	 subq.l    #1,d0
	 move.l    d0,_EditBufferLength
	 move.l    red_REDT_SelectedLine(a2),a0
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

	 DOMTDI    GCM_Update,a4
a1230 1

@


0.8
log
@Added newline insertion handling
@
text
@d6 1
a6 1
* $Id: Editor.s 0.7 1998/04/12 13:53:40 MORB Exp MORB $
d171 1
a171 1
	 movem.l   d2-7/a2-5,-(a7)
a208 1
	 move.l    d0,red_REDT_RebuildDTbl(a4)
a216 5
	 move.l    red_REDT_Reformat(a4),d0
	 clr.l     red_REDT_Reformat(a4)

	 cmp.l     sac_SADT_HVisibleNVS(a3),d2
	 sne       d1
d219 1
a219 3
	 or.b      d1,d0
	 cmp.l     sac_SADT_HVisibleVS(a3),d3
	 sne       d1
a221 1
	 or.b      d1,d0
d223 2
a224 5
	 tst.l     d0
	 beq.s     .DontReformat

	 clr.l     red_REDT_Reformat(a4)
	 ;clr.l     red_REDT_FLOffset(a4)
d282 1
a282 1
	 movem.l   (a7)+,d2-7/a2-5
d296 1
a296 1
	 movem.l   (a7)+,d2-7/a2-5
d382 1
a382 1
	 movem.l   (a7)+,d2-7/a2-5
d621 1
d636 1
d958 1
a958 1
	 beq.s     .Done
d967 3
a969 1
	 clr.w     (a6)
d973 1
a973 3
	 beq.s     .Ok
	 move.l    ble_String(a0),a1
	 move.l    a6,ble_String(a0)
d1008 2
a1015 1
	 beq.s     .EDBEmpty
d1017 1
a1017 1
	 addq.l    #2,a1
d1019 1
d1021 1
a1021 1
	 move.b    -2(a1),-(a1)
a1024 1
.EDBEmpty:
a1034 1
	 move.l    d0,red_REDT_Reformat(a2)
a1046 1
	 ;DOMTDI    GCM_Layout,a4
d1101 7
d1124 32
d1737 1
a1737 1
	 moveq     #TXTA_WWCENTER,d0
@


0.7
log
@Added caracter insertion routine, made RawEditorClass a subclass of scrollareaclass, and dynamic mouse pointer change when it's over it.
@
text
@d6 1
a6 1
* $Id: Editor.s 0.6 1998/03/31 17:58:07 MORB Exp MORB $
d809 1
d934 1
a934 3
	 beq.s     .Done

	 move.l    d0,d2
a943 1
	 subq.l    #1,d2
d946 1
a946 1
	 dbf       d2,.CpyLoop
d976 2
a977 2
	 lea       _EditBuffer,a2
	 clr.w     (a2)
d983 1
a983 1
	 move.l    a2,ble_String(a0)
d986 1
a986 1
	 move.b    (a0)+,(a2)+
d989 1
d1010 1
a1010 2
;.glop
;         bra       .glop
d1018 3
d1060 65
@


0.6
log
@Added cursor handling, floattext and editor classes
@
text
@d6 1
a6 1
* $Id: Editor.s 0.5 1998/01/10 23:25:33 MORB Exp MORB $
d22 1
a22 1
	 dc.l      _GuiRootClass
d34 3
d47 4
a50 4
	 move.l    #MTD_New,d0
	 lea       REDNew,a1
	 bsr       _SetMethod
	 move.l    d0,REDSNew
d57 6
a62 2
	 move.l    #GCM_GetMinMax,d0
	 lea       REDGetMinMax,a1
d65 2
a66 2
	 move.l    #GCM_Layout,d0
	 lea       REDLayout,a1
d69 2
a70 2
	 move.l    #GCM_Render,d0
	 lea       REDRender,a1
d73 1
a73 1
	 move.l    #GCM_Update,d0
d77 5
a81 1
	 move.l    #GCM_Click,d0
d90 2
a91 2
REDSNew:
	 ds.l      1
d97 30
a126 24
REDNew:
	 movem.l   a2-3,-(a7)

	 move.l    a0,a3
	 move.l    REDSNew(pc),a1
	 jsr       (a1)

	 lea       _VScrollerClass,a0
	 sub.l     a1,a1
	 bsr       _NewObject
	 tst.l     d0
	 beq.s     .Fail

	 move.l    d0,a2
	 DOMTDI    MTD_AddMember,a3

	 SDATALI   a2,REDT_Scroller,a3

	 moveq     #-1,d0
	 SDATALI   d0,VSDT_LayoutNotify,a2

	 LBLOCKEAI GuiRootClass_ID,a2,a0
	 lea       REDHook(pc),a1
	 movem.l   a1/a3,guir_DTA_Hook(a0)
a127 5
	 moveq     #-1,d0
.Fail:
	 movem.l   (a7)+,a2-3
	 rts
;fe
d150 18
a167 18
REDGetMinMax:
	 movem.l   a2-3,-(a7)

	 move.l    a0,a2

	 LDATALI   REDT_Scroller,a2,a3
	 DOMTDI    GCM_GetMinMax,a3

	 LBLOCKEAI GuiRootClass_ID,a3,a0
	 LBLOCKEAI GuiRootClass_ID,a2,a1

	 move.l    guir_DTA_MinHeight(a0),guir_DTA_MinHeight(a1)
	 moveq     #40,d0
	 add.l     guir_DTA_MinWidth(a0),d0
	 move.l    d0,guir_DTA_MinWidth(a1)

	 movem.l   (a7)+,a2-3
	 rts
d169 3
a171 3
;fs "Layout"
REDLayout:
	 movem.l   d2-7/a2-6,-(a7)
d174 1
a174 1
	 LBLOCKEAI GuiRootClass_ID,a2,a3
d178 1
a178 1
	 beq.s     .NoScroller
d180 1
a180 2
	 move.l    gd_Height(a3),d2
	 subq.l    #4,d2
d182 5
d213 1
a213 7
	 move.l    red_REDT_Scroller(a4),a6
	 LBLOCKEAI GuiRootClass_ID,a6,a5

	 move.l    gd_Width(a3),d2
	 subq.l    #8,d2
	 move.l    d2,d3
	 sub.l     guir_DTA_MinWidth(a5),d3
d215 1
d221 1
a221 1
	 cmp.l     red_REDT_DLLengthNS(a4),d2
d223 2
d226 1
a226 1
	 cmp.l     red_REDT_DLLengthSC(a4),d3
d228 2
a231 2
	 movem.l   d2-3,red_REDT_DLLengthNS(a4)

d276 2
a277 1
	 movem.l   d5-6,red_REDT_NDispLinesNS(a4)
a279 27
	 moveq     #0,d0
	 move.l    red_REDT_DispEntNum(a4),d1
	 cmp.l     red_REDT_NDispLinesNS(a4),d1
	 bcc.s     .NoScroller

	 move.l    red_REDT_CNumOfst(a4),d0
	 eor.b     #4,d0
	 move.l    d0,red_REDT_ClearScroller(a4)
	 moveq     #4,d0
	 move.l    d0,red_REDT_CNumOfst(a4)

	 move.l    gd_Right(a3),d2
	 move.l    d2,gd_Right(a5)
	 move.l    guir_DTA_MinWidth(a5),d1
	 sub.l     d1,d2
	 move.l    d1,gd_Width(a5)

	 move.l    gd_Width(a3),d0
	 sub.l     d1,d0
	 move.l    d2,gd_Left(a5)

	 movem.l   d0/d2,red_REDT_Width(a4)

	 movem.l   gd_Top(a3),d0-1
	 movem.l   d0-1,gd_Top(a5)
	 move.l    gd_Height(a3),gd_Height(a5)

d285 1
a285 1
	 move.l    red_REDT_DLLengthSC(a4),d0
a289 3
	 LBLOCKEAI VScrollerClass_ID,a6,a0
	 move.l    red_REDT_NDispLinesSC(a4),vsc_VSDT_Total(a0)
	 move.l    red_REDT_DispEntNum(a4),vsc_VSDT_Visible(a0)
d291 2
a292 2
	 move.l    d0,vsc_VSDT_Position(a0)
	 move.l    d0,red_REDT_FLineNumSC(a4)
d294 2
a295 2
	 ;move.l    a4,a1
	 ;bsr       REDPlaceCursor
d297 6
a302 3
	 DOMTDI    GCM_Layout,a6

	 bra.s     .AllDone
d304 1
a304 7
.NoScroller:
	 clr.l     red_REDT_CNumOfst(a4)
	 move.l    gd_Width(a3),red_REDT_Width(a4)
	 move.l    gd_Right(a3),red_REDT_Right(a4)

	 clr.l     red_REDT_FLineNumSC(a4)
	 move.l    red_REDT_BufferList(a4),red_REDT_FirstLine(a4)
d308 50
a357 2
	 clr.l     red_REDT_FLOffset(a4)
	 clr.l     red_REDT_FLCharOffset(a4)
d359 1
d362 28
d394 1
a394 1
	 movem.l   (a7)+,d2-7/a2-6
d412 1
a412 1
;fs "Render"
d414 1
a414 1
	 movem.l   d2-7/a2-5,-(a7)
d418 1
d427 1
a427 1
	 bsr.s     _RebuildDisplayBuffer
d431 1
a431 2
	 LBLOCKEAI GuiRootClass_ID,a0,a2
	 move.l    a2,_CurrentDomain
d433 29
d463 1
a463 27
	 moveq     #0,d0
	 moveq     #0,d1
	 move.l    red_REDT_Width(a1),d2
	 move.l    gd_Height(a2),d3
	 st        d4
	 bsr       _DrawBevelBox

	 tst.l     red_REDT_CNumOfst(a1)
	 beq.s     .NoScroller
	 move.l    red_REDT_Scroller(a1),a3

	 move.l    a1,d2
	 move.l    a0,d3

	 tst.l     red_REDT_ClearScroller(a1)
	 beq.s     .DontClrScroller
	 clr.l     red_REDT_ClearScroller(a1)
	 DOMTDI    GCM_Clear,a3
.DontClrScroller:
	 DOMTDI    GCM_Render,a3
	 move.l    d3,a0
	 move.l    d2,a1
.NoScroller:

	 move.l    red_REDT_Width(a1),d0
	 subq.l    #4,d0
	 move.l    d0,_TextLimit
d471 2
a472 2
	 moveq     #2,d2
	 move.l    a2,-(a7)
d485 1
a485 1
	 moveq     #2,d4
d487 1
a487 1
	 move.l    red_REDT_Width(a1),d6
d499 1
a499 1
	 bsr.s     REDCursor
d507 1
a507 1
	 move.l    (a7)+,a2
d509 3
a511 3
	 moveq     #2,d4
	 move.l    red_REDT_Width(a1),d6
	 subq.l    #4,d6
d513 1
a513 1
	 move.l    gd_Height(a2),d7
d516 1
a516 1
	 bsr       _DrawRectangle
d521 1
a521 1
	 movem.l   (a7)+,d2-7/a2-5
d524 1
a524 1
;fs "Update"
d527 1
a527 1
	 movem.l   d2-7/a2-5,-(a7)
d531 2
d541 1
a541 2
	 LBLOCKEAI GuiRootClass_ID,a0,a2
	 move.l    a2,_CurrentDomain
d543 25
a567 23
	 moveq     #0,d0
	 moveq     #0,d1
	 move.l    red_REDT_Width(a1),d2
	 move.l    gd_Height(a2),d3
	 st        d4
	 bsr       _DrawBevelBox

	 tst.l     red_REDT_CNumOfst(a1)
	 beq.s     .NoScroller
	 move.l    red_REDT_Scroller(a1),a3

	 move.l    a1,d2
	 move.l    a0,d3

	 clr.l     red_REDT_ClearScroller(a1)
	 DOMTDI    GCM_Render,a3
	 move.l    d3,a0
	 move.l    d2,a1
.NoScroller:

	 move.l    red_REDT_Width(a1),d0
	 subq.l    #4,d0
	 move.l    d0,_TextLimit
d569 1
d576 1
a576 1
	 moveq     #2,d2
d592 1
a592 1
	 moveq     #2,d4
d594 1
a594 1
	 move.l    red_REDT_Width(a1),d6
d616 1
a616 1
	 movem.l   (a7)+,d2-7/a2-5
d627 2
a628 2
	 move.l    red_REDT_CNumOfst(a1),d1
	 move.l    red_REDT_DLLengthNS(a1,d1.w),d0
d657 2
a658 2
;fs "Scroller hook"
REDHook:
d661 6
a666 1
	 move.l    d0,a0
d669 1
a669 1
	 move.l    red_REDT_CNumOfst(a1),d3
a699 1
	 ;b.s     .BwdDone
d711 6
a716 6
	 tst.l     d2
	 bne.s     .Grumbl
	 ;illegal
	 DOMTDI    GCM_Update,a0
.Grumbl:

d721 6
a726 1
;fs "Click"
a727 11
	 LBLOCKEAI ListViewClass_ID,a0,a1
	 tst.l     red_REDT_CNumOfst(a1)
	 beq.s     .NoScroller

	 cmp.l     red_REDT_Right(a1),d0
	 bcs.s     .NoScroller

	 move.l    red_REDT_Scroller(a1),a0
	 DOMTDJI   GCM_Click,a0

.NoScroller:
d847 2
a848 2
	 LBLOCKEAI GuiRootClass_ID,a0,a1
	 move.l    a1,_CurrentDomain
d864 2
a865 2
	 LBLOCKEAI GuiRootClass_ID,a0,a1
	 move.l    a1,_CurrentDomain
d881 1
a881 1
	 LBLOCKEAI GuiRootClass_ID,a0,a1
d898 1
a898 1
	 LBLOCKEAI GuiRootClass_ID,a0,a1
d910 172
d1121 1
a1121 1
	 moveq     #4,d6
d1142 1
d1158 2
a1159 1
	 movem.l   d2-4/d7/a0/a4,-(a7)
d1189 1
a1189 1
	 movem.l   (a7)+,d2-4/d7/a0/a4
d1193 1
d1343 1
d1431 1
a1431 1
	 addq.l    #4,d0
d1481 1
a1481 1
	 addq.l    #4,d0
d1502 1
a1502 1

d1521 4
a1524 1
	 cmp.l     ble_Length(a0),d0
d1544 1
d1555 4
a1558 2
	 move.l    red_REDT_CNumOfst(a1),d0
	 move.l    red_REDT_DLLengthNS(a1,d0.w),d0
d1567 1
a1567 1
	 moveq     #2,d3
d1593 1
a1593 1
	 addq.l    #4,d0
d1693 4
d1731 5
@


0.5
log
@Implémentation du mode centré
@
text
@d6 1
a6 1
* $Id: Editor.s 0.4 1998/01/10 20:32:28 MORB Exp MORB $
d16 2
d34 5
d223 1
a223 1
	 clr.l     red_REDT_FLOffset(a4)
d239 1
d253 1
a253 1
	 move.l    d0,bve_ChunksNS(a1)
d258 2
a259 2
	 move.l    d0,bve_ChunksSC(a1)
	 ;move.l    d0,bve_ChunksNS(a1)
d293 10
d306 6
a311 1
	 move.l    red_REDT_FLineNumSC(a4),vsc_VSDT_Position(a0)
d326 6
d351 1
a351 1
	 dc.b      "Couldn't alloc display buffer",0
d356 1
a356 1
	 movem.l   d2-7/a2-4,-(a7)
d411 2
d432 1
a432 1
	 beq.s     .Next
d435 5
d446 1
d460 1
a460 1
	 movem.l   (a7)+,d2-7/a2-4
d466 1
a466 1
	 movem.l   d2-7/a2-4,-(a7)
d512 1
d535 1
a535 1
	 beq.s     .Next
d537 5
d551 1
a551 1
	 movem.l   (a7)+,d2-7/a2-4
d568 1
d589 2
a590 1
	 rts
d609 1
a609 1
	 move.l    bve_ChunksNS(a2,d3.w),d4
d625 1
a625 1
	 move.l    bve_ChunksNS(a2,d3.w),d4
d638 1
a664 1
	 clr.l     REDCounter
d717 1
a717 1
	 move.l    #bve_Size,d0
d722 2
a723 2
	 clr.l     bve_Length(a4)
	 clr.l     bve_String(a4)
d744 1
a744 1
	 move.l    d4,bve_Length(a4)
d748 1
a748 1
	 move.l    d0,bve_String(a4)
d766 3
d775 72
d863 2
d871 1
a871 1
	 movem.l   d2-3/a0,-(a7)
d873 3
a875 2
	 move.l    bve_Length(a2),d3
	 move.l    bve_String(a2),a0
d877 2
a878 1
	 movem.l   (a7)+,d2-3/a0
d889 8
d903 2
d907 1
a907 1
	 move.l    bve_Length(a1),d1
d922 3
a924 2
	 movem.l   d2-4/a0/a4,-(a7)
	 move.l    bve_String(a2),a4
d926 1
d930 1
a930 1
	 add.l     bve_Length(a2),d4
d947 1
d952 14
a965 1
	 movem.l   (a7)+,d2-4/a0/a4
d973 1
a973 1
	 move.l    bve_Length(a1),d2
d976 1
a976 1
	 move.l    bve_String(a1),a4
d990 5
a994 4
	 movem.l   d2-5/a0/a4-5,-(a7)
	 move.l    bve_String(a2),a4
	 move.l    bve_Length(a2),d5
	 ;beq.s     .Done
d1001 1
d1018 1
d1027 7
a1033 1
	 movem.l   (a7)+,d2-5/a0/a4-5
d1067 2
d1087 1
a1087 1
REDStoreDEntry:    ; a3=DEntry, d2=XPos, d3=Numchars, a0=Text
d1093 6
d1102 2
a1103 2
	 move.l    dte_CRC(a3),d3
	 move.l    d2,dte_CRC(a3)
d1110 372
@


0.4
log
@Implementation de wordwraping
@
text
@d6 1
a6 1
* $Id: Editor.s 0.3 1998/01/10 16:00:26 MORB Exp MORB $
d733 4
d863 1
d886 1
a886 1
	 lea       (a4,d0.l),a4
d888 1
d903 21
d929 1
a929 1
	 add.l     a0,d2
@


0.3
log
@Implémentation du mode SimpleWrap et correction de moulte bugs
@
text
@d6 1
a6 1
* $Id: Editor.s 0.2 1998/01/10 11:49:10 MORB Exp MORB $
d732 1
d814 84
@


0.2
log
@Implémentation d'une bonne partie du truc (layout et affichage)... arf
@
text
@d6 1
a6 1
* $Id: Editor.s 0.1 1998/01/05 22:19:37 MORB Exp MORB $
d216 2
d239 1
a239 1
	 move.l    d5,red_REDT_FLineNumSC(a4)
d244 1
a244 1
	 add.l     d0,d6
d249 1
a249 1
	 add.l     d0,d5
d251 1
d521 1
d529 1
d579 1
d581 2
a582 2
	 cmp.l     d4,d1
	 bcs.s     .BwdDone
d585 2
a586 2
	 move.l    4(a2),a2
	 bra.s     .BwdLoop
d744 1
a745 7

	 move.l    d2,dte_XPos(a3)

	 move.l    bve_String(a2),d3
	 add.l     d3,d2
	 move.l    d3,dte_Text(a3)

d747 3
a749 9
	 add.l     d3,d2
	 move.l    d3,dte_NumChars(a3)

	 move.l    dte_CRC(a3),d3
	 move.l    d2,dte_CRC(a3)
	 eor.l     d2,d3
	 move.l    d3,dte_Update(a3)

	 lea       dte_Size(a3),a3
d768 12
a779 1
	 moveq     #1,d0
d783 4
d788 2
d791 3
a793 1
	 move.l    bve_Length(a2),
d795 3
d799 9
d809 6
a814 3

	 moveq     #4,d2

d817 2
a818 3
	 move.l    bve_String(a2),d3
	 add.l     d3,d2
	 move.l    d3,dte_Text(a3)
a819 1
	 move.l    bve_Length(a2),d3
a829 2


@


0.1
log
@Ajout de plein de folder en prevision du code polytentaculaire final
@
text
@d6 1
a6 1
* $Id: Editor.s 0.0 1998/01/05 22:16:35 MORB Exp MORB $
d10 7
d37 33
a69 24
	 ;move.l    #MTD_New,d0
	 ;lea       REDNew,a1
	 ;bsr       _SetMethod
	 ;move.l    d0,REDSNew

	 ;move.l    #GCM_GetMinMax,d0
	 ;lea       REDGetMinMax,a1
	 ;bsr       _SetMethod

	 ;move.l    #GCM_Layout,d0
	 ;lea       REDLayout,a1
	 ;bsr       _SetMethod

	 ;move.l    #GCM_Render,d0
	 ;lea       REDRender,a1
	 ;bsr       _SetMethod

	 ;move.l    #GCM_Click,d0
	 ;lea       REDClick,a1
	 ;bsr       _SetMethod

	 ;move.l    #GCM_Handle,d0
	 ;lea       REDHandle,a1
	 ;bsr       _SetMethod
d74 2
d97 3
d101 2
a102 2
	 ;lea       REDHook(pc),a1
	 ;movem.l   a1/a3,guir_DTA_Hook(a0)
d109 21
d136 1
a136 1
	 LDATALI   LVDT_Scroller,a2,a3
d154 6
a159 2
	 LBLOCKEAI ListViewClass_ID,a0,a2
	 LBLOCKEAI GuiRootClass_ID,a0,a4
d161 5
a165 9
	 ;move.l    red_REDT_List(a2),a1
	 moveq     #0,d2
	 move.l    (a1),a1
	 ;move.l    red_REDT_FirstVis(a2),d0
	 bne.s     .NotEmpty
	 move.l    a1,d0
.NotEmpty:
	 move.l    d0,a3
	 moveq     #0,d0
d167 4
a170 19
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

	 move.l    d0,red_REDT_Total(a2)
	 beq.s     .NoList

	 move.l    gd_Height(a4),d3
	 move.l    d3,d4
	 subq.l    #3,d3
	 lsr.l     #3,d3
d172 2
a173 4
	 moveq     #-1,d5
	 cmp.l     d0,d3
	 bcs.s     .ScrollerOk
	 moveq     #0,d5
d175 5
a179 2
.ScrollerOk:
	 move.l    d3,red_REDT_NumVis(a2)
d181 18
a198 8
	 move.l    d3,d6
	 lsl.l     #3,d6
	 addq.l    #1,d6
	 move.l    d6,red_REDT_ClrTop(a2)
	 neg.l     d6
	 add.l     d4,d6
	 subq.l    #1,d6
	 move.l    d6,red_REDT_ClrHeight(a2)
d200 2
a201 2
	 move.l    gd_Width(a4),d6
	 move.l    gd_Right(a4),d7
d203 6
a208 3
	 move.l    red_REDT_ShowScroller(a2),d1
	 move.l    d5,red_REDT_ShowScroller(a2)
	 beq.s     .NoScroller
d210 1
a210 2
	 not.l     d1
	 move.l    d1,red_REDT_ClearScroller(a2)
d212 2
a213 1
	 move.l    red_REDT_Scroller(a2),a5
d215 5
a219 13
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
d221 10
a230 3
	 sub.l     d0,d6
	 sub.l     d0,d7
	 movem.l   d6-7,red_REDT_Width(a2)
d232 2
a233 3
	 movem.l   gd_Top(a4),d0-1
	 movem.l   d0-1,gd_Top(a6)
	 move.l    gd_Height(a4),gd_Height(a6)
d235 14
a248 1
	 DOMTDI    GCM_Layout,a5
d250 1
a250 7
	 move.l    d5,a5
	 move.l    vsc_VSDT_Position(a5),d4
	 ;move.l    d4,red_REDT_FVNum(a2)
	 move.l    d4,d5
	 subq.l    #1,d3
	 add.l     d3,d5
	 ;move.l    d5,red_REDT_LVNum(a2)
d252 2
a253 4
	 sub.l     d2,d4
	 bmi.s     .Backward
	 subq.l    #1,d4
	 bmi.s     .FVOk
d255 31
a285 4
.FwdLoop:
	 move.l    (a3),a3
	 dbf       d4,.FwdLoop
	 bra.s     .FVOk
d287 1
a287 4
.Backward:
	 neg.l     d4
	 subq.l    #1,d4
	 bmi.s     .FVOk
a288 28
.BwdLoop:
	 move.l    4(a3),a3
	 dbf       d4,.BwdLoop
.FVOk:

	 ;move.l    a3,red_REDT_FirstVis(a2)

	 subq.l    #1,d3
	 bmi.s     .LVOk
.LVLoop:
	 move.l    (a3),a3
	 dbf       d3,.LVLoop
.LVOk:
	 ;move.l    a3,red_REDT_LastVis(a2)
	 bra.s     .AllDone

.NoList:
	 clr.l     red_REDT_ShowScroller(a2)
	 clr.l     red_REDT_Total(a2)
	 moveq     #1,d0
	 move.l    d0,red_REDT_ClrTop(a2)
	 move.l    gd_Height(a4),d0
	 subq.l    #2,d0
	 move.l    d0,red_REDT_ClrHeight(a2)

	 move.l    gd_Width(a4),d0
	 move.l    gd_Right(a4),d1
	 movem.l   d0-1,red_REDT_Width(a2)
d292 3
a294 8
	 movem.l   d6-7,red_REDT_Width(a2)
	 ;clr.l     red_REDT_FVNum(a2)
	 subq.l    #1,d3
	 ;move.l    d3,red_REDT_LVNum(a2)

	 ;move.l    red_REDT_List(a2),a1
	 ;move.l    (a1),red_REDT_FirstVis(a2)
	 ;move.l    8(a1),red_REDT_LastVis(a2)
d296 4
d302 2
d306 15
d324 1
a324 1
	 movem.l   d2-7/a2-5,-(a7)
d327 16
a342 3
	 LBLOCKEAI GuiRootClass_ID,a0,a1
	 move.l    a1,_CurrentDomain
	 LBLOCKEAI ListViewClass_ID,a0,a2
d346 3
a348 3
	 move.l    red_REDT_Width(a2),d2
	 move.l    gd_Height(a1),d3
	 sf        d4
d351 1
a351 1
	 tst.l     red_REDT_ShowScroller(a2)
d353 4
a356 1
	 move.l    red_REDT_Scroller(a2),a3
d358 1
a358 1
	 tst.l     red_REDT_ClearScroller(a2)
d360 1
a360 1
	 clr.l     red_REDT_ClearScroller(a2)
d364 2
d368 1
a368 1
	 move.l    red_REDT_Width(a2),d0
d372 4
d377 2
a378 7
	 move.l    red_REDT_NumVis(a2),d0
	 beq.s     .NoList
	 subq.l    #1,d0

	 ;move.l    red_REDT_FirstVis(a2),a3
	 ;move.l    red_REDT_Selected(a2),a4
	 moveq     #1,d2
d381 4
a384 1
	 moveq     #0,d3
d386 2
a387 4
	 cmp.l     a3,a4
	 bne.s     .NotSel
	 moveq     #3,d3
.NotSel:
d389 1
d392 1
a392 1
	 move.l    red_REDT_Width(a2),d6
d395 1
a395 1
	 bsr.s     _DrawRectangle
d397 3
a399 6
	 moveq     #0,d5
	 move.l    lve_Color(a3),d4
	 move.l    d2,d7
	 move.l    lve_String(a3),a5
	 moveq     #4,d6
	 bsr       _DrawText
d401 2
a402 1
	 move.l    (a3),a3
d404 1
a404 1
	 dbf       d0,.Loop
d406 2
a407 2
.NoList:
	 movem.l   red_REDT_ClrTop(a2),d5/d7
d409 1
a409 1
	 move.l    red_REDT_Width(a2),d6
d411 74
d486 15
a500 1
	 bsr.s     _DrawRectangle
d505 35
a539 1
	 movem.l   (a7)+,d2-7/a2-5
d544 1
a544 1
	 movem.l   a2-3,-(a7)
d547 8
a554 3
	 LBLOCKEAI ListViewClass_ID,a0,a1
	 ;move.l    red_REDT_FVNum(a1),d0
	 ;move.l    d1,red_REDT_FVNum(a1)
d556 1
a556 2
	 ;movem.l   red_REDT_FirstVis(a1),a2-3
	 ;add.l     d1,red_REDT_LVNum(a1)
d558 4
a561 2
	 tst.l     d1
	 bmi.s     .Backward
d563 1
a563 3
	 subq.l    #1,d1
	 bmi.s     .Groumpf
.ForwardLoop:
d565 3
a567 2
	 move.l    (a3),a3
	 dbf       d1,.ForwardLoop
d572 7
a578 3
	 subq.l    #1,d1
	 bmi.s     .Groumpf
.BackwardLoop:
d580 4
a583 2
	 move.l    4(a3),a3
	 dbf       d1,.BackwardLoop
a585 2
	 ;movem.l   a2-3,red_REDT_FirstVis(a1)
	 DOMTDI    GCM_Render,a0
d587 10
a596 1
	 movem.l   (a7)+,a2-3
d599 1
d603 1
a603 1
	 tst.l     red_REDT_ShowScroller(a1)
a623 1
	 movem.l   (a7)+,d2/a2-3
d658 1
a658 1
	 lea       red_REDT_BufList(a2),a3
d706 1
d713 2
a714 1
	 move.l    d2,red_REDT_NumLines(a2)
d720 87
@


0.0
log
@Groumpf
@
text
@d6 1
a6 1
* $Id$
d10 1
d27 2
a28 1

d58 1
d60 1
d87 2
a88 1

d107 2
a108 1

d265 2
a266 1

d346 2
a347 1

d385 2
a386 1

d402 3
a404 2

REDHandle:
d419 2
a420 2


d505 1
@
