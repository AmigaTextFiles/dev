head	0.25;
access;
symbols;
locks
	MORB:0.25; strict;
comment	@# @;


0.25
date	98.03.30.18.25.16;	author MORB;	state Exp;
branches;
next	0.24;

0.24
date	98.02.13.13.18.19;	author MORB;	state Exp;
branches;
next	0.23;

0.23
date	97.09.17.19.57.43;	author MORB;	state Exp;
branches;
next	0.22;

0.22
date	97.09.17.18.03.27;	author MORB;	state Exp;
branches;
next	0.21;

0.21
date	97.09.10.22.26.37;	author MORB;	state Exp;
branches;
next	0.20;

0.20
date	97.09.10.17.39.50;	author MORB;	state Exp;
branches;
next	0.19;

0.19
date	97.09.10.16.48.42;	author MORB;	state Exp;
branches;
next	0.18;

0.18
date	97.09.09.00.13.03;	author MORB;	state Exp;
branches;
next	0.17;

0.17
date	97.09.07.11.26.20;	author MORB;	state Exp;
branches;
next	0.16;

0.16
date	97.09.06.22.56.47;	author MORB;	state Exp;
branches;
next	0.15;

0.15
date	97.09.06.19.13.33;	author MORB;	state Exp;
branches;
next	0.14;

0.14
date	97.09.01.17.54.26;	author MORB;	state Exp;
branches;
next	0.13;

0.13
date	97.08.31.18.16.15;	author MORB;	state Exp;
branches;
next	0.12;

0.12
date	97.08.31.17.38.31;	author MORB;	state Exp;
branches;
next	0.11;

0.11
date	97.08.31.17.35.48;	author MORB;	state Exp;
branches;
next	0.10;

0.10
date	97.08.30.23.07.34;	author MORB;	state Exp;
branches;
next	0.9;

0.9
date	97.08.30.11.39.22;	author MORB;	state Exp;
branches;
next	0.8;

0.8
date	97.08.29.17.45.54;	author MORB;	state Exp;
branches;
next	0.7;

0.7
date	97.08.29.17.05.53;	author MORB;	state Exp;
branches;
next	0.6;

0.6
date	97.08.25.23.17.05;	author MORB;	state Exp;
branches;
next	0.5;

0.5
date	97.08.24.17.56.04;	author MORB;	state Exp;
branches;
next	0.4;

0.4
date	97.08.23.01.18.03;	author MORB;	state Exp;
branches;
next	0.3;

0.3
date	97.08.22.18.37.15;	author MORB;	state Exp;
branches;
next	0.2;

0.2
date	97.08.22.15.27.42;	author MORB;	state Exp;
branches;
next	0.1;

0.1
date	97.08.22.15.05.31;	author MORB;	state Exp;
branches;
next	0.0;

0.0
date	97.08.22.15.00.41;	author MORB;	state Exp;
branches;
next	;


desc
@Jeu à la beast avec des scrolls partout
RCS for GoldED · Initial login date: Aujourd'hui
@


0.25
log
@Added key repeat
@
text
@*
* CdBSian Obviously Universal & Interactive Nonsense (COUIN)
* (Absurdité CdBSienne Manifestement Universelle et Interactive)
* ©1997-1998, CdBS Software (MORB)
* Support routines
* $Id: Support.s 0.24 1998/02/13 13:18:19 MORB Exp MORB $
*

;fs "_WaitVbl"
_WaitVbl:
	 bclr      #0,_VblFlag
	 beq       _WaitVbl
	 rts
;fe
;fs "_InitBlitNodes"
_InitBlitNodes:
	 lea       _BlitQueue,a0
	 move.l    a0,_NextFreeBN
	 move.l    #BlitQueueSize-2,d0
.Loop:
	 lea       bn_Size(a0),a1
	 move.l    a1,(a0)
	 move.l    a1,a0
	 dbf       d0,.Loop
	 rts
;fe
;fs "_Level3_Int"
_Level3_Int:
	 movem.l   d0-7/a0-6,-(a7)
	 lea       CustomBase,a6
	 move.w    intreqr(a6),d7

	 ;btst      #4,d7
	 ;bne       .cop


	 btst      #6,d7
	 bne       .Blitter
	 move.w    #$20,intreq(a6)

	 ;not.w     cdbg

	 bset      #0,_VblFlag
	 move.w    _Timer,d0
	 beq       .NoTimer
	 subq.w    #1,d0
	 move.w    d0,_Timer
.NoTimer:
	 move.l    _VblHook,d0
	 beq       .NoHook
	 move.l    d0,a0
	 jsr       (a0)
.NoHook:
	 btst      #7,$bfe001
	 bne       .NoLMB
	 lea       _Quit(pc),a0
	 move.l    a0,2+15*4(a7)
.NoLMB:
	 bsr       _KBHandleRepeat
.NoVBlank:
	 movem.l   (a7)+,d0-7/a0-6
	 rte

.cop:
	 ;move.w    #$10,intreq(a6)
	 ;lea       Plf1(pc),a5
	 ;lea       TestSprH(pc),a4
	 ;lea       TestSpr(pc),a3
	 ;bsr       _DrawSprite
	 ;movem.l   (a7)+,d0-7/a0-6
	 ;rte



; 1 BlitNode = 62 octets
.Blitter:
	 ;move.w    #0,$dff180

	 move.w    #$40,intreq(a6)

	 move.w    #$2700,sr
	 ;bsr       _CheckBlitLists

	 ;tst.w     _Debug
	 ;beq       .EtHop
.grunt:
	 ;move.w    #$ff,$dff180
	 ;btst      #2,$dff016
	 ;bne       .grunt
.gleuarp:
	 ;btst      #2,$dff016
	 ;beq       .gleuarp

	 btst      #6,dmaconr(a6)
.EtHop:
	 btst      #6,dmaconr(a6)
	 bne       .EtHop

	 move.w    #1,_Debug

	 move.l    _BlitHook(pc),d0
	 beq       .SiOnMangeaisChinoisChraisHyperContent
	 move.l    d0,a0
	 jsr       (a0)
	 clr.l     _BlitHook
.SiOnMangeaisChinoisChraisHyperContent:

	 lea       _NextBlit(pc),a0
	 move.l    (a0),d7
	 beq       .NonItalienDéfinitivementItalien
	 ;bsr       _CheckBlitLists

	 move.l    d7,a1
	 move.l    bn_Count(a1),d7
	 subq.l    #1,d7
	 ;bpl.s     .Skleuneufleurgl

	 move.l    (a1),(a0)
	 bne       .AréoportDeNiceAréoportDeNiceDeuxMinutesDarrêt
	 move.l    a0,_LastBlit
.AréoportDeNiceAréoportDeNiceDeuxMinutesDarrêt:

	 sub.l     #1,_NumBlit

	 ;bsr       _CheckBlitLists
	 move.l    a1,$8b00000
	 move.l    _NextFreeBN,$8b00004
	 move.l    _NextFreeBN(pc),(a1)
	 move.l    a1,_NextFreeBN

	 add.l     #1,_NumFreeBN


.Skleuneufleurgl:
	 move.l    d7,bn_Count(a1)
	 ;bsr       _CheckBlitLists

	 ;move.w    #$f00,$dff180

	 lea       bn_Data(a1),a0
	 move.l    bn_Code(a1),a2
	 cmp.l     _LastBlitCode,a2
	 seq       d0
	 move.l    a2,_LastBlitCode
	 jsr       (a2)
	 clr.l     bn_HData(a1)
	 ;clr.w     $dff180
	 ;bsr       _CheckBlitLists
	 bra       .BDone

.NonItalienDéfinitivementItalien:
	 move.l    a0,_LastBlit
	 bclr      #0,_BlitterBusy
	 ;bsr       _CheckBlitLists
.BDone:

	 ;bsr       _CheckBlitLists
	 clr.w     _Debug
	 move.w    #$2000,sr
	 movem.l   (a7)+,d0-7/a0-6
	 rte
_Quit:
	 move.l    _A7Save(pc),a7
	 bra       _Exit

_LastBlitCode:
	 ds.l      1
_BlitHook:
	 ds.l      1
_BHData:
	 ds.l      1
_NextBlit:
	 ds.l      1
_LastBlit:
	 dc.l      _NextBlit
_NextFreeBN:
	 ds.l      1
_BlitterBusy:
	 ds.b      1
_VblFlag:
	 ds.b      1
_CurrentBitmap:
	 ds.l      1
_A7Save:
	 ds.l      1
_VblHook:
	 dc.l      0
_Timer:
	 dc.w      0
;fe
;fs "_GetBlitNode"
_GetBlitNode:      ; a0=Code d1=CPUCode d0=Data
	 move.l    d2,-(a7)
	 lea       CustomBase,a6
	 move.w    #$2000,sr
	 move.w    #$8040,intena(a6)

	 lea       _NextFreeBN(pc),a1

.WaitForBN:
	 ;move.w    $dff006,$dff180
	 move.l    (a1),d2
	 beq       .WaitForBN

	 move.w    #$0040,intena(a6)
	 move.w    #$2700,sr
	 move.w    #$f80,_Debug

	 ;bsr       _CheckBlitLists
	 move.l    (a1),a1
	 move.l    (a1),_NextFreeBN
	 clr.l     (a1)+
	 clr.l     (a1)+
	 move.l    a0,(a1)+
	 move.l    d1,(a1)+
	 move.l    d0,(a1)+

	 sub.l     #1,_NumFreeBN

	 ;bsr       _CheckBlitLists

	 move.l    (a7)+,d2
	 rts
_AAAAArgh:
	 bsr       _CheckBlitLists
.klonk:
	 move.w    $dff006,$dff180
	 btst      #2,$dff016
	 bne       .klonk
	 move.w    #$2000,sr
	 bra       _Quit
;fe
;fs "_PreAddBlitNode"
_PreAddBlitNode:      ; a1=Node
	 ;bsr       _CheckBlitLists
	 move.l    a0,-(a7)
	 lea       -bn_Data(a1),a1
	 move.l    _LastBlit(pc),a0
	 move.l    a1,(a0)
	 move.l    a1,_LastBlit

	 add.l     #1,_NumBlit
	 move.l    (a7)+,a0
	 ;bsr       _CheckBlitLists
	 rts
;fe
;fs "_PreAddCPUBlitNode"
_PreAddCPUBlitNode:      ; a1=Node
	 tst.b     _UseCPU
	 beq       _PreAddBlitNode

	 move.l    a0,-(a7)
	 lea       -bn_Data(a1),a1
	 move.l    _LastCPUBlit(pc),a0
	 move.l    a1,(a0)
	 move.l    a1,_LastCPUBlit
	 move.l    (a7)+,a0
	 rts
;fe
;fs "_AddBlitNode"
_AddBlitNode:      ; a1=Node
	 ;bsr       _CheckBlitLists
	 move.l    a2,-(a7)
	 move.l    a1,a0
	 lea       -bn_Data(a1),a1
	 bset      #0,_BlitterBusy
	 bne       .Gerflor

	 btst      #6,dmaconr(a6)
.EtHop:
	 btst      #6,dmaconr(a6)
	 bne       .EtHop

	 ;move.w    #$f00,$dff180
	 ;bsr       _CheckBlitLists

	 ;bsr       _CheckBlitLists
	 move.l    bn_Code(a1),a2
	 cmp.l     _LastBlitCode,a2
	 seq       d0
	 move.l    a2,_LastBlitCode
	 jsr       (a2)
	 ;clr.w     $dff180
	 clr.l     bn_HData(a1)

	 move.l    bn_Count(a1),d0
	 subq.l    #1,d0
	 bpl.s     .Gerflor

	 move.l    _NextFreeBN(pc),(a1)
	 move.l    a1,_NextFreeBN
	 add.l     #1,_NumFreeBN
	 bra.s     .Done

.Gerflor:
	 move.l    d0,bn_Count(a1)
	 move.l    _LastBlit(pc),a0
	 move.l    a1,(a0)
	 move.l    a1,_LastBlit
	 add.l     #1,_NumBlit
.Done:
	 ;bsr       _CheckBlitLists
	 clr.w     _Debug
	 bclr      #1,_BlitterBusy
	 move.w    #$2000,sr
	 move.w    #$8040,intena(a6)
	 move.l    (a7)+,a2
	 rts
;fe
;fs "_AddCPUBlitNode"
_AddCPUBlitNode:      ; a1=Node
	 tst.b     _UseCPU
	 beq       _AddBlitNode
	 ;bsr       _CheckBlitLists

	 add.l     #1,_NumCPU
	 move.l    a0,-(a7)
	 lea       -bn_Data(a1),a1
	 move.l    _LastCPUBlit(pc),a0
	 move.l    a1,(a0)
	 move.l    a1,_LastCPUBlit
	 move.l    (a7)+,a0
	 clr.w     _Debug
	 ;bsr       _CheckBlitLists
	 move.w    #$2000,sr
	 move.w    #$8040,intena(a6)
	 rts
;fe
;fs "_CancelBlit"
_CancelBlit:
	 ;move.w    $dff006,d0
	 ;and.w     #$f0f,d0
	 ;move.w    d0,$dff180
	 ;btst      #6,$bfe001
	 ;bne       _CancelBlit

	 lea       -bn_Data(a1),a1
	 move.l    _NextFreeBN(pc),(a1)
	 move.l    a1,_NextFreeBN
	 rts
;fe
;fs "_DoCPUBlits"
_DoCPUBlits:
	 movem.l   d1-7/a0-6,-(a7)

	 ;move.w    #$0040,intena(a6)
	 ;move.w    #$2700,sr


.Loop:
	 ;bsr       _CheckBlitLists
	 lea       _NextCPUBlit(pc),a0
	 move.l    (a0),d7
	 beq       .NonItalienDéfinitivementItalien

	 tst.b     _UseCPU
	 beq       .GiveToBlitter

	 move.l    d7,a1
	 move.l    bn_Count(a1),d7
	 subq.l    #1,d7
	 bpl.s     .Skleuneufleurgl

	 move.l    (a1),(a0)
	 bne       .AréoportDeNiceAréoportDeNiceDeuxMinutesDarrêt
	 move.l    a0,_LastCPUBlit
.AréoportDeNiceAréoportDeNiceDeuxMinutesDarrêt:

	 move.w    #$0040,intena(a6)
	 move.w    #$2700,sr

	 ;move.w    #$ff,_Debug
	 move.l    _NextFreeBN(pc),(a1)
	 move.l    a1,_NextFreeBN
	 ;clr.w     _Debug

	 sub.l     #1,_NumCPU
	 add.l     #1,_NumFreeBN

	 ;bsr       _CheckBlitLists

	 move.w    #$2000,sr
	 move.w    #$8040,intena(a6)

	 ;move.w    #$f00,$dff180

.Skleuneufleurgl:
	 move.l    d7,bn_Count(a1)

	 clr.l     bn_HData(a1)
	 lea       bn_Data(a1),a0
	 move.l    bn_CPUCode(a1),a2
	 move.l    a0,-(a7)
	 jsr       (a2)
	 move.l    (a7)+,a0
	 ;clr.w     $dff180
	 ;bsr       _CheckBlitLists
	 bra       .Loop

.NonItalienDéfinitivementItalien:
	 ;bsr       _CheckBlitLists
	 move.l    a0,_LastCPUBlit
	 ;move.w    #$2000,sr
	 ;move.w    #$8040,intena(a6)
	 movem.l   (a7)+,d1-7/a0-6
	 moveq     #-1,d0
	 rts

.GiveToBlitter:

	 ;bra       .NonItalienDéfinitivementItalien

	 move.w    #$0040,intena(a6)
	 move.w    #$2700,sr

	 move.l    _LastBlit(pc),a1
	 move.l    _LastCPUBlit,_LastBlit
	 move.l    a0,_LastCPUBlit
	 move.l    d7,(a1)
	 clr.l     (a0)
	 move.l    _NumCPU,d0
	 add.l     d0,_NumBlit
	 clr.l     _NumCPU

	 lea       Plf1(pc),a5
	 st        _UseCPU
	 move.l    pf_CpuWorkOfst(a5),pf_WorkOfst(a5)

	 move.w    #$2000,sr
	 move.w    #$8040,intena(a6)

	 bset      #0,_BlitterBusy
	 bne       .Done
	 ;bsr       _CheckBlitLists

	 lea       _NextBlit(pc),a0

	 btst      #6,dmaconr(a6)
.EtHop:
	 btst      #6,dmaconr(a6)
	 bne       .EtHop

	 move.l    (a0),d7
	 move.l    d7,a1
	 sub.l     #1,bn_Count(a1)
	 bpl.s     .Garglop

	 move.l    (a1),(a0)
	 bne       .Glonk
	 move.l    a0,_LastBlit
.Glonk:

	 move.w    #1,_Debug
	 move.l    _NextFreeBN(pc),(a1)
	 move.l    a1,_NextFreeBN
	 clr.w     _Debug
	 add.l     #1,_NumFreeBN
.Garglop:

	 sub.l     #1,_NumBlit
	 ;bsr       _CheckBlitLists

	 lea       bn_Data(a1),a0
	 move.l    bn_Code(a1),a2
	 cmp.l     _LastBlitCode,a2
	 seq       d0
	 move.l    a2,_LastBlitCode
	 jsr       (a2)
	 clr.l     bn_HData(a1)
	 ;clr.w     $dff180

.Done:
	 ;bsr       _CheckBlitLists
	 movem.l   (a7)+,d1-7/a0-6
	 moveq     #0,d0
	 rts

_NextCPUBlit:
	 ds.l      1
_LastCPUBlit:
	 dc.l      _NextCPUBlit
_UseCPU:
	 dc.b      0
	 even
;fe

;fs "_CheckBlitLists"
_NumFreeBN:
	 dc.l      BlitQueueSize
_NumBlit:
	 dc.l      0
_NumCPU:
	 dc.l      0

_CheckBlitLists:
	 rts
	 move.l    (a7),$8a00000
	 movem.l   d0-7/a0-6,-(a7)
	 lea       CustomBase,a6
	 move.w    intenar(a6),-(a7)
	 move.w    sr,-(a7)

	 move.w    #$0040,intena(a6)
	 move.w    #$2700,sr

	 moveq     #0,d7
	 lea       _NextFreeBN(pc),a0
.FreeLoop:
	 move.l    (a0),d0
	 beq       .FreeOk
	 addq.l    #1,d7
	 move.l    d0,a0
	 bra       .FreeLoop
.FreeOk:
	 cmp.l     _NumFreeBN,d7
	 bne       .FailFree

	 moveq     #0,d7
	 lea       _NextBlit(pc),a0
.BlitLoop:
	 move.l    (a0),d0
	 beq       .BlitOk
	 addq.l    #1,d7
	 move.l    d0,a0
	 bra       .BlitLoop
.BlitOk:
	 cmp.l     _NumBlit,d7
	 bne       .FailBlit

	 moveq     #0,d7
	 lea       _NextCPUBlit(pc),a0
.CPULoop:
	 move.l    (a0),d0
	 beq       .CPUOk
	 addq.l    #1,d7
	 move.l    d0,a0
	 bra       .CPULoop
.CPUOk:
	 cmp.l     _NumCPU,d7
	 bne       .FailCPU

	 move.w    (a7)+,sr
	 move.w    (a7)+,d0
	 bset      #15,d0
	 move.w    d0,intena(a6)
	 movem.l   (a7)+,d0-7/a0-6
	 rts

.FailFree:
	 move.l    d7,$8a00004
	 move.l    _NumFreeBN,$8a00008
.floop:
	 move.w    $dff006,d0
	 and.w     #$f00,d0
	 move.w    d0,$dff180
	 btst      #2,$dff016
	 bne       .floop
	 move.w    #$2000,sr
	 bra       _Quit

.FailBlit:
	 move.l    d7,$8a00004
	 move.l    _NumBlit,$8a00008
.bloop:
	 move.w    $dff006,d0
	 and.w     #$f0,d0
	 move.w    d0,$dff180
	 btst      #2,$dff016
	 bne       .bloop
	 move.w    #$2000,sr
	 bra       _Quit

.FailCPU:
	 move.l    d7,$8a00004
	 move.l    _NumCPU,$8a00008
.cloop:
	 move.w    $dff006,d0
	 and.w     #$f,d0
	 move.w    d0,$dff180
	 btst      #2,$dff016
	 bne       .cloop
	 move.w    #$2000,sr
	 bra       _Quit
;fe

;fs "_LoadGardenDwarvesPtrs"
_LoadGardenDwarvesPtrs:
	 move.l    CtGDwarfPtrs(pc),a0
	 lea       _GDwarfTable,a1
	 moveq     #8-1,d0
	 move.l    #gdwarfpt,d1
.Loop:
	 move.l    (a1)+,d2
	 swap      d2
	 move.w    d1,(a0)+
	 move.w    d2,(a0)+
	 addq.w    #2,d1
	 move.w    d1,(a0)+
	 swap      d2
	 move.w    d2,(a0)+
	 addq.w    #2,d1
	 dbf       d0,.Loop
	 rts
CtGDwarfPtrs:
	 dc.l      GDwarvesPtrs
_GDwarfTable:
	 rept      8
	 dc.l      _EmptyGardenDwarf
	 endr
;fe
;fs "_RefreshGardenDwarf"
_RefreshGardenDwarf:         ; a0=Garden dwarf
	 movem.l   d0-3/d6-7,-(a7)
	 moveq     #0,d7
	 moveq     #0,d6
	 move.w    gdw_Y(a0),d0
	 add.w     #$29,d0
	 move.w    d0,d1
	 add.w     gdw_Height(a0),d1
	 roxl.w    #8,d1
	 addx.w    d7,d1
	 add.b     d1,d1
	 roxl.w    #8,d0
	 addx.w    d7,d6
	 lsl.b     #2,d6
	 or.b      d6,d1
	 move.w    gdw_X(a0),d2
	 add.w     #$90*4,d2
	 move.w    d2,d3
	 roxr.w    #3,d2
	 addx.w    d7,d1
	 and.b     #3,d3
	 lsl.b     #3,d3
	 or.b      d3,d1
	 move.l    gdw_Data(a0),a2
	 move.w    d1,8(a2)
	 move.b    d2,d0
	 move.w    d0,(a2)
	 move.l    gdw_Attach(a0),d2
	 beq       .Ok
	 move.l    d2,a2
	 move.w    d0,(a2)
	 or.w      #$80,d1
	 move.w    d1,8(a2)
.Ok:
	 movem.l   (a7)+,d0-3/d6-7
	 rts
;fe

;fs "_KeyBoardInt"
;_KeyBoardInt:
;         move.l    Low_Base,a6
;         CALL      GetKey
;
;         cmp.b     #$40,d0
;         bne       .Done
;
;         cmp.l     #CopEnd,_GuiLayerPtr
;         beq       .ShowGui
;
;         move.l    #CopEnd,_GuiLayerPtr
;
;.Done:
;         moveq     #0,d0
;         rts
;.ShowGui:
;         move.l    #CopLayer4,_GuiLayerPtr
;         moveq     #0,d0
;         rts
;fe
@


0.24
log
@Gna viru vieille routine clavier
@
text
@d6 1
a6 1
* $Id: Support.s 0.23 1997/09/17 19:57:43 MORB Exp MORB $
d59 1
@


0.23
log
@Correction d'un nième bug dans GetBlitNode(). Grompf
@
text
@d4 1
a4 1
* ©1997, CdBS Software (MORB)
d6 1
a6 1
* $Id: Support.s 0.22 1997/09/17 18:03:27 MORB Exp MORB $
d11 3
a13 3
         bclr      #0,_VblFlag
         beq       _WaitVbl
         rts
d17 3
a19 3
         lea       _BlitQueue,a0
         move.l    a0,_NextFreeBN
         move.l    #BlitQueueSize-2,d0
d21 5
a25 5
         lea       bn_Size(a0),a1
         move.l    a1,(a0)
         move.l    a1,a0
         dbf       d0,.Loop
         rts
d29 3
a31 3
         movem.l   d0-7/a0-6,-(a7)
         lea       CustomBase,a6
         move.w    intreqr(a6),d7
d33 2
a34 2
         ;btst      #4,d7
         ;bne       .cop
d37 3
a39 3
         btst      #6,d7
         bne       .Blitter
         move.w    #$20,intreq(a6)
d41 1
a41 1
         ;not.w     cdbg
d43 5
a47 5
         bset      #0,_VblFlag
         move.w    _Timer,d0
         beq       .NoTimer
         subq.w    #1,d0
         move.w    d0,_Timer
d49 4
a52 4
         move.l    _VblHook,d0
         beq       .NoHook
         move.l    d0,a0
         jsr       (a0)
d54 4
a57 4
         btst      #7,$bfe001
         bne       .NoLMB
         lea       _Quit(pc),a0
         move.l    a0,2+15*4(a7)
d60 2
a61 2
         movem.l   (a7)+,d0-7/a0-6
         rte
d64 7
a70 7
         ;move.w    #$10,intreq(a6)
         ;lea       Plf1(pc),a5
         ;lea       TestSprH(pc),a4
         ;lea       TestSpr(pc),a3
         ;bsr       _DrawSprite
         ;movem.l   (a7)+,d0-7/a0-6
         ;rte
d76 1
a76 1
         ;move.w    #0,$dff180
d78 1
a78 1
         move.w    #$40,intreq(a6)
d80 2
a81 2
         move.w    #$2700,sr
         ;bsr       _CheckBlitLists
d83 2
a84 2
         ;tst.w     _Debug
         ;beq       .EtHop
d86 3
a88 3
         ;move.w    #$ff,$dff180
         ;btst      #2,$dff016
         ;bne       .grunt
d90 2
a91 2
         ;btst      #2,$dff016
         ;beq       .gleuarp
d93 1
a93 1
         btst      #6,dmaconr(a6)
d95 2
a96 2
         btst      #6,dmaconr(a6)
         bne       .EtHop
d98 1
a98 1
         move.w    #1,_Debug
d100 5
a104 5
         move.l    _BlitHook(pc),d0
         beq       .SiOnMangeaisChinoisChraisHyperContent
         move.l    d0,a0
         jsr       (a0)
         clr.l     _BlitHook
d107 13
a119 9
         lea       _NextBlit(pc),a0
         move.l    (a0),d7
         beq       .NonItalienDéfinitivementItalien
         ;bsr       _CheckBlitLists

         move.l    d7,a1
         move.l    (a1),(a0)
         bne       .AréoportDeNiceAréoportDeNiceDeuxMinutesDarrêt
         move.l    a0,_LastBlit
d122 1
a122 1
         sub.l     #1,_NumBlit
d124 25
a148 22
         ;bsr       _CheckBlitLists
         move.l    a1,$8b00000
         move.l    _NextFreeBN,$8b00004
         move.l    _NextFreeBN(pc),(a1)
         move.l    a1,_NextFreeBN

         add.l     #1,_NumFreeBN

         ;bsr       _CheckBlitLists

         ;move.w    #$f00,$dff180

         lea       bn_Data(a1),a0
         move.l    bn_Code(a1),a2
         cmp.l     _LastBlitCode,a2
         seq       d0
         move.l    a2,_LastBlitCode
         jsr       (a2)
         clr.l     bn_HData(a1)
         ;clr.w     $dff180
         ;bsr       _CheckBlitLists
         bra       .BDone
d151 3
a153 3
         move.l    a0,_LastBlit
         bclr      #0,_BlitterBusy
         ;bsr       _CheckBlitLists
d156 5
a160 5
         ;bsr       _CheckBlitLists
         clr.w     _Debug
         move.w    #$2000,sr
         movem.l   (a7)+,d0-7/a0-6
         rte
d162 2
a163 2
         move.l    _A7Save(pc),a7
         bra       _Exit
d166 1
a166 1
         ds.l      1
d168 1
a168 1
         ds.l      1
d170 1
a170 1
         ds.l      1
d172 1
a172 1
         ds.l      1
d174 1
a174 1
         dc.l      _NextBlit
d176 1
a176 1
         ds.l      1
d178 1
a178 1
         ds.b      1
d180 1
a180 1
         ds.b      1
d182 1
a182 1
         ds.l      1
d184 1
a184 1
         ds.l      1
d186 1
a186 1
         dc.l      0
d188 1
a188 1
         dc.w      0
d192 4
a195 4
         move.l    d2,-(a7)
         lea       CustomBase,a6
         move.w    #$2000,sr
         move.w    #$8040,intena(a6)
d197 1
a197 1
         lea       _NextFreeBN(pc),a1
d200 16
a215 15
         ;move.w    $dff006,$dff180
         move.l    (a1),d2
         beq       .WaitForBN

         move.w    #$0040,intena(a6)
         move.w    #$2700,sr
         move.w    #$f80,_Debug

         ;bsr       _CheckBlitLists
         move.l    (a1),a1
         move.l    (a1),_NextFreeBN
         clr.l     (a1)+
         move.l    a0,(a1)+
         move.l    d1,(a1)+
         move.l    d0,(a1)+
d217 1
a217 1
         sub.l     #1,_NumFreeBN
d219 1
a219 1
         ;bsr       _CheckBlitLists
d221 2
a222 2
         move.l    (a7)+,d2
         rts
d224 1
a224 1
         bsr       _CheckBlitLists
d226 5
a230 5
         move.w    $dff006,$dff180
         btst      #2,$dff016
         bne       .klonk
         move.w    #$2000,sr
         bra       _Quit
d234 11
a244 11
         ;bsr       _CheckBlitLists
         move.l    a0,-(a7)
         lea       -bn_Data(a1),a1
         move.l    _LastBlit(pc),a0
         move.l    a1,(a0)
         move.l    a1,_LastBlit

         add.l     #1,_NumBlit
         move.l    (a7)+,a0
         ;bsr       _CheckBlitLists
         rts
d248 2
a249 2
         tst.b     _UseCPU
         beq       _PreAddBlitNode
d251 7
a257 7
         move.l    a0,-(a7)
         lea       -bn_Data(a1),a1
         move.l    _LastCPUBlit(pc),a0
         move.l    a1,(a0)
         move.l    a1,_LastCPUBlit
         move.l    (a7)+,a0
         rts
d261 6
a266 6
         ;bsr       _CheckBlitLists
         move.l    a2,-(a7)
         move.l    a1,a0
         lea       -bn_Data(a1),a1
         bset      #0,_BlitterBusy
         bne       .Gerflor
d268 1
a268 1
         btst      #6,dmaconr(a6)
d270 2
a271 2
         btst      #6,dmaconr(a6)
         bne       .EtHop
d273 20
a292 15
         ;move.w    #$f00,$dff180
         ;bsr       _CheckBlitLists
         move.l    _NextFreeBN(pc),(a1)
         move.l    a1,_NextFreeBN
         add.l     #1,_NumFreeBN

         ;bsr       _CheckBlitLists
         move.l    bn_Code(a1),a2
         cmp.l     _LastBlitCode,a2
         seq       d0
         move.l    a2,_LastBlitCode
         jsr       (a2)
         ;clr.w     $dff180
         clr.l     bn_HData(a1)
         bra       .Done
d295 5
a299 4
         move.l    _LastBlit(pc),a0
         move.l    a1,(a0)
         move.l    a1,_LastBlit
         add.l     #1,_NumBlit
d301 7
a307 7
         ;bsr       _CheckBlitLists
         clr.w     _Debug
         bclr      #1,_BlitterBusy
         move.w    #$2000,sr
         move.w    #$8040,intena(a6)
         move.l    (a7)+,a2
         rts
d311 16
a326 16
         tst.b     _UseCPU
         beq       _AddBlitNode
         ;bsr       _CheckBlitLists

         add.l     #1,_NumCPU
         move.l    a0,-(a7)
         lea       -bn_Data(a1),a1
         move.l    _LastCPUBlit(pc),a0
         move.l    a1,(a0)
         move.l    a1,_LastCPUBlit
         move.l    (a7)+,a0
         clr.w     _Debug
         ;bsr       _CheckBlitLists
         move.w    #$2000,sr
         move.w    #$8040,intena(a6)
         rts
d330 10
a339 10
         ;move.w    $dff006,d0
         ;and.w     #$f0f,d0
         ;move.w    d0,$dff180
         ;btst      #6,$bfe001
         ;bne       _CancelBlit

         lea       -bn_Data(a1),a1
         move.l    _NextFreeBN(pc),(a1)
         move.l    a1,_NextFreeBN
         rts
d343 1
a343 1
         movem.l   d1-7/a0-6,-(a7)
d345 2
a346 2
         ;move.w    #$0040,intena(a6)
         ;move.w    #$2700,sr
d350 16
a365 12
         ;bsr       _CheckBlitLists
         lea       _NextCPUBlit(pc),a0
         move.l    (a0),d7
         beq       .NonItalienDéfinitivementItalien

         tst.b     _UseCPU
         beq       .GiveToBlitter

         move.l    d7,a1
         move.l    (a1),(a0)
         bne       .AréoportDeNiceAréoportDeNiceDeuxMinutesDarrêt
         move.l    a0,_LastCPUBlit
d368 2
a369 2
         move.w    #$0040,intena(a6)
         move.w    #$2700,sr
d371 27
a397 24
         ;move.w    #$ff,_Debug
         move.l    _NextFreeBN(pc),(a1)
         move.l    a1,_NextFreeBN
         ;clr.w     _Debug

         sub.l     #1,_NumCPU
         add.l     #1,_NumFreeBN

         ;bsr       _CheckBlitLists

         move.w    #$2000,sr
         move.w    #$8040,intena(a6)

         ;move.w    #$f00,$dff180

         clr.l     bn_HData(a1)
         lea       bn_Data(a1),a0
         move.l    bn_CPUCode(a1),a2
         move.l    a0,-(a7)
         jsr       (a2)
         move.l    (a7)+,a0
         ;clr.w     $dff180
         ;bsr       _CheckBlitLists
         bra       .Loop
d400 7
a406 7
         ;bsr       _CheckBlitLists
         move.l    a0,_LastCPUBlit
         ;move.w    #$2000,sr
         ;move.w    #$8040,intena(a6)
         movem.l   (a7)+,d1-7/a0-6
         moveq     #-1,d0
         rts
d410 1
a410 1
         ;bra       .NonItalienDéfinitivementItalien
d412 2
a413 2
         move.w    #$0040,intena(a6)
         move.w    #$2700,sr
d415 19
a433 19
         move.l    _LastBlit(pc),a1
         move.l    _LastCPUBlit,_LastBlit
         move.l    a0,_LastCPUBlit
         move.l    d7,(a1)
         clr.l     (a0)
         move.l    _NumCPU,d0
         add.l     d0,_NumBlit
         clr.l     _NumCPU

         lea       Plf1(pc),a5
         st        _UseCPU
         move.l    pf_CpuWorkOfst(a5),pf_WorkOfst(a5)

         move.w    #$2000,sr
         move.w    #$8040,intena(a6)

         bset      #0,_BlitterBusy
         bne       .Done
         ;bsr       _CheckBlitLists
d435 1
a435 1
         lea       _NextBlit(pc),a0
d437 1
a437 1
         btst      #6,dmaconr(a6)
d439 2
a440 2
         btst      #6,dmaconr(a6)
         bne       .EtHop
d442 8
a449 5
         move.l    (a0),d7
         move.l    d7,a1
         move.l    (a1),(a0)
         bne       .Glonk
         move.l    a0,_LastBlit
d452 18
a469 17
         move.w    #1,_Debug
         move.l    _NextFreeBN(pc),(a1)
         move.l    a1,_NextFreeBN
         clr.w     _Debug

         sub.l     #1,_NumBlit
         add.l     #1,_NumFreeBN
         ;bsr       _CheckBlitLists

         lea       bn_Data(a1),a0
         move.l    bn_Code(a1),a2
         cmp.l     _LastBlitCode,a2
         seq       d0
         move.l    a2,_LastBlitCode
         jsr       (a2)
         clr.l     bn_HData(a1)
         ;clr.w     $dff180
d472 4
a475 4
         ;bsr       _CheckBlitLists
         movem.l   (a7)+,d1-7/a0-6
         moveq     #0,d0
         rts
d478 1
a478 1
         ds.l      1
d480 1
a480 1
         dc.l      _NextCPUBlit
d482 2
a483 2
         dc.b      0
         even
d488 1
a488 1
         dc.l      BlitQueueSize
d490 1
a490 1
         dc.l      0
d492 1
a492 1
         dc.l      0
d495 6
a500 6
         rts
         move.l    (a7),$8a00000
         movem.l   d0-7/a0-6,-(a7)
         lea       CustomBase,a6
         move.w    intenar(a6),-(a7)
         move.w    sr,-(a7)
d502 2
a503 2
         move.w    #$0040,intena(a6)
         move.w    #$2700,sr
d505 2
a506 2
         moveq     #0,d7
         lea       _NextFreeBN(pc),a0
d508 5
a512 5
         move.l    (a0),d0
         beq       .FreeOk
         addq.l    #1,d7
         move.l    d0,a0
         bra       .FreeLoop
d514 2
a515 2
         cmp.l     _NumFreeBN,d7
         bne       .FailFree
d517 2
a518 2
         moveq     #0,d7
         lea       _NextBlit(pc),a0
d520 5
a524 5
         move.l    (a0),d0
         beq       .BlitOk
         addq.l    #1,d7
         move.l    d0,a0
         bra       .BlitLoop
d526 2
a527 2
         cmp.l     _NumBlit,d7
         bne       .FailBlit
d529 2
a530 2
         moveq     #0,d7
         lea       _NextCPUBlit(pc),a0
d532 5
a536 5
         move.l    (a0),d0
         beq       .CPUOk
         addq.l    #1,d7
         move.l    d0,a0
         bra       .CPULoop
d538 2
a539 2
         cmp.l     _NumCPU,d7
         bne       .FailCPU
d541 6
a546 6
         move.w    (a7)+,sr
         move.w    (a7)+,d0
         bset      #15,d0
         move.w    d0,intena(a6)
         movem.l   (a7)+,d0-7/a0-6
         rts
d549 2
a550 2
         move.l    d7,$8a00004
         move.l    _NumFreeBN,$8a00008
d552 7
a558 7
         move.w    $dff006,d0
         and.w     #$f00,d0
         move.w    d0,$dff180
         btst      #2,$dff016
         bne       .floop
         move.w    #$2000,sr
         bra       _Quit
d561 2
a562 2
         move.l    d7,$8a00004
         move.l    _NumBlit,$8a00008
d564 7
a570 7
         move.w    $dff006,d0
         and.w     #$f0,d0
         move.w    d0,$dff180
         btst      #2,$dff016
         bne       .bloop
         move.w    #$2000,sr
         bra       _Quit
d573 2
a574 2
         move.l    d7,$8a00004
         move.l    _NumCPU,$8a00008
d576 7
a582 7
         move.w    $dff006,d0
         and.w     #$f,d0
         move.w    d0,$dff180
         btst      #2,$dff016
         bne       .cloop
         move.w    #$2000,sr
         bra       _Quit
d587 4
a590 4
         move.l    CtGDwarfPtrs(pc),a0
         lea       _GDwarfTable,a1
         moveq     #8-1,d0
         move.l    #gdwarfpt,d1
d592 11
a602 11
         move.l    (a1)+,d2
         swap      d2
         move.w    d1,(a0)+
         move.w    d2,(a0)+
         addq.w    #2,d1
         move.w    d1,(a0)+
         swap      d2
         move.w    d2,(a0)+
         addq.w    #2,d1
         dbf       d0,.Loop
         rts
d604 1
a604 1
         dc.l      GDwarvesPtrs
d606 3
a608 3
         rept      8
         dc.l      _EmptyGardenDwarf
         endr
d612 32
a643 32
         movem.l   d0-3/d6-7,-(a7)
         moveq     #0,d7
         moveq     #0,d6
         move.w    gdw_Y(a0),d0
         add.w     #$29,d0
         move.w    d0,d1
         add.w     gdw_Height(a0),d1
         roxl.w    #8,d1
         addx.w    d7,d1
         add.b     d1,d1
         roxl.w    #8,d0
         addx.w    d7,d6
         lsl.b     #2,d6
         or.b      d6,d1
         move.w    gdw_X(a0),d2
         add.w     #$90*4,d2
         move.w    d2,d3
         roxr.w    #3,d2
         addx.w    d7,d1
         and.b     #3,d3
         lsl.b     #3,d3
         or.b      d3,d1
         move.l    gdw_Data(a0),a2
         move.w    d1,8(a2)
         move.b    d2,d0
         move.w    d0,(a2)
         move.l    gdw_Attach(a0),d2
         beq       .Ok
         move.l    d2,a2
         move.w    d0,(a2)
         or.w      #$80,d1
         move.w    d1,8(a2)
d645 2
a646 2
         movem.l   (a7)+,d0-3/d6-7
         rts
d650 19
a668 19
_KeyBoardInt:
         move.l    Low_Base,a6
         CALL      GetKey

         cmp.b     #$40,d0
         bne       .Done

         cmp.l     #CopEnd,_GuiLayerPtr
         beq       .ShowGui

         move.l    #CopEnd,_GuiLayerPtr

.Done:
         moveq     #0,d0
         rts
.ShowGui:
         move.l    #CopLayer4,_GuiLayerPtr
         moveq     #0,d0
         rts
@


0.22
log
@Correction d'un petit bug dans GetBlitNode()
@
text
@d6 1
a6 1
* $Id: Support.s 0.21 1997/09/10 22:26:37 MORB Exp MORB $
a188 1
         ;bsr       _CheckBlitLists
d193 1
a193 1
         move.w    $dff006,$dff180
d201 2
a202 2

         move.l    d2,a1
d266 1
@


0.21
log
@Une ou deux modifs mineures.
@
text
@d6 1
a6 1
* $Id: Support.s 0.20 1997/09/10 17:39:50 MORB Exp MORB $
d12 1
a12 1
         beq.s     _WaitVbl
d34 1
a34 1
         ;bne.s     .cop
d38 1
a38 1
         bne.s     .Blitter
d45 1
a45 1
         beq.s     .NoTimer
d50 1
a50 1
         beq.s     .NoHook
d55 1
a55 1
         bne.s     .NoLMB
d84 1
a84 1
         ;beq.s     .EtHop
d88 1
a88 1
         ;bne.s     .grunt
d91 1
a91 1
         ;beq.s     .gleuarp
d96 1
a96 1
         bne.s     .EtHop
d101 1
a101 1
         beq.s     .SiOnMangeaisChinoisChraisHyperContent
d109 1
a109 1
         beq.s     .NonItalienDéfinitivementItalien
d114 1
a114 1
         bne.s     .AréoportDeNiceAréoportDeNiceDeuxMinutesDarrêt
d141 1
a141 1
         bra.s     .BDone
d187 2
d194 1
a194 1
         ;move.w    $dff006,$dff180
d196 1
a196 1
         beq.s     .WaitForBN
d221 1
a221 1
         bne.s     .klonk
d242 1
a242 1
         beq.s     _PreAddBlitNode
d259 1
a259 1
         bne.s     .Gerflor
d264 1
a264 1
         bne.s     .EtHop
d279 1
a279 1
         bra.s     .Done
d283 1
a284 1
         move.l    a1,(a0)
d298 1
a298 1
         beq.s     _AddBlitNode
d320 1
a320 1
         ;bne.s     _CancelBlit
d339 1
a339 1
         beq.s     .NonItalienDéfinitivementItalien
d342 1
a342 1
         beq.s     .GiveToBlitter
d346 1
a346 1
         bne.s     .AréoportDeNiceAréoportDeNiceDeuxMinutesDarrêt
d376 1
a376 1
         bra.s     .Loop
d389 1
a389 1
         ;bra.s     .NonItalienDéfinitivementItalien
d411 1
a411 1
         bne.s     .Done
d419 1
a419 1
         bne.s     .EtHop
d424 1
a424 1
         bne.s     .Glonk
d484 1
a484 1
         beq.s     .FreeOk
d487 1
a487 1
         bra.s     .FreeLoop
d490 1
a490 1
         bne.s     .FailFree
d496 1
a496 1
         beq.s     .BlitOk
d499 1
a499 1
         bra.s     .BlitLoop
d502 1
a502 1
         bne.s     .FailBlit
d508 1
a508 1
         beq.s     .CPUOk
d511 1
a511 1
         bra.s     .CPULoop
d514 1
a514 1
         bne.s     .FailCPU
d531 1
a531 1
         bne.s     .floop
d533 1
a533 1
         bra.s     _Quit
d543 1
a543 1
         bne.s     .bloop
d545 1
a545 1
         bra.s     _Quit
d555 1
a555 1
         bne.s     .cloop
d557 1
a557 1
         bra.s     _Quit
d614 1
a614 1
         beq.s     .Ok
d630 1
a630 1
         bne.s     .Done
d633 1
a633 1
         beq.s     .ShowGui
@


0.20
log
@Changement de sprite en GardenDwarf
@
text
@d6 1
a6 1
* $Id: Support.s 0.19 1997/09/10 16:48:42 MORB Exp MORB $
d560 2
a561 2
         move.l    CtSprPtrs(pc),a0
         lea       _SprTable,a1
d563 1
a563 1
         move.l    #sprpt,d1
d577 1
a577 1
         dc.l      GDwarfPtrs
d585 1
a585 1
         movem.l   d6-7,-(a7)
d588 1
a588 1
         move.w    csp_Y(a0),d0
d591 1
a591 1
         add.w     csp_Height(a0),d1
d599 1
a599 1
         move.w    csp_X(a0),d2
d607 1
a607 1
         move.l    csp_Data(a0),a2
d611 1
a611 1
         move.l    csp_Attach(a0),d2
d618 1
a618 1
         movem.l   (a7)+,d6-7
@


0.19
log
@Modification de RefreshSprite() pour supporter le positionnement au quart de pixel près
@
text
@d6 1
a6 1
* $Id: Support.s 0.18 1997/09/09 00:13:03 MORB Exp MORB $
d558 2
a559 2
;fs "_LoadSpritePtrs"
_LoadSpritePtrs:
d576 3
a578 3
CtSprPtrs:
         dc.l      SprPtrs
_SprTable:
d580 1
a580 1
         dc.l      _EmptySprite
d583 2
a584 2
;fs "_RefreshSprite"
_RefreshSprite:    ; a0=Sprite
@


0.18
log
@Une ou deux modifs pour scroll parallaxeuh. Gaââ fatigu.
@
text
@d6 1
a6 1
* $Id: Support.s 0.17 1997/09/07 11:26:20 MORB Exp MORB $
d600 3
a602 2
         add.w     #$90,d2
         roxr.w    #1,d2
d604 3
@


0.17
log
@Nettoyement des move color0 horribles immondes qui touschier faisaient.
@
text
@d6 1
a6 1
* $Id: Support.s 0.16 1997/09/06 22:56:47 MORB Exp MORB $
d65 1
a65 1
         ;lea       TestPlf(pc),a5
d149 1
a149 1
         bsr       _CheckBlitLists
d187 1
a187 1
         bsr       _CheckBlitLists
d210 1
a210 1
         bsr       _CheckBlitLists
d225 1
a225 1
         bsr       _CheckBlitLists
d234 1
a234 1
         bsr       _CheckBlitLists
d252 1
a252 1
         bsr       _CheckBlitLists
d269 1
a269 1
         bsr       _CheckBlitLists
d285 1
a285 1
         bsr       _CheckBlitLists
d297 1
a297 1
         bsr       _CheckBlitLists
d307 1
a307 1
         bsr       _CheckBlitLists
d334 1
a334 1
         bsr       _CheckBlitLists
d359 1
a359 1
         bsr       _CheckBlitLists
d373 1
a373 1
         bsr       _CheckBlitLists
d377 1
a377 1
         bsr       _CheckBlitLists
d401 1
a401 1
         lea       TestPlf(pc),a5
d410 1
a410 1
         bsr       _CheckBlitLists
d433 1
a433 1
         bsr       _CheckBlitLists
d445 1
a445 1
         bsr       _CheckBlitLists
d600 1
a600 1
         add.w     #$a0,d2
@


0.16
log
@Sauvegardu d2 dedans GetBlitNode() pour pas DrawSprite() bugger pouvoir.
@
text
@d6 1
a6 1
* $Id: Support.s 0.15 1997/09/06 19:13:33 MORB Exp MORB $
d76 1
a76 1
         move.w    #0,$dff180
d83 2
a84 2
         tst.w     _Debug
         beq.s     .EtHop
d86 3
a88 3
         move.w    #$ff,$dff180
         btst      #2,$dff016
         bne.s     .grunt
d90 2
a91 2
         btst      #2,$dff016
         beq.s     .gleuarp
d192 1
a192 1
         move.w    $dff006,$dff180
d264 1
a264 1
         move.w    #$f00,$dff180
d275 1
a275 1
         clr.w     $dff180
d442 1
a442 1
         clr.w     $dff180
@


0.15
log
@Nimplémentu et débuggu triple-buffer trtuc et tout aaaargh raaââââh.
@
text
@d6 1
a6 1
* $Id: Support.s 0.14 1997/09/01 17:54:26 MORB Exp MORB $
d185 1
d212 1
@


0.14
log
@Ajout des routines pour supporter les blits au cpu ?-)
@
text
@d6 1
a6 1
* $Id: Support.s 0.13 1997/08/31 18:16:15 MORB Exp MORB $
d19 1
a19 1
         move.l    #BlitQueueSize-100,d0
d80 13
d98 2
d110 1
d117 6
d124 5
a128 1
         move.l    d7,_NextFreeBN
d130 1
a130 1
         move.w    #$f00,$dff180
d138 3
a140 1
         clr.w     $dff180
d146 1
d149 3
d186 1
a186 2
         move.w    #$0060,intena(a6)
         move      #$2700,sr
d188 9
a198 4
         move.l    _NextFreeBN(pc),a1

         move.l    a1,d0
         beq.s     _AAAAArgh
d200 1
d207 4
d213 2
d217 2
a218 2
         bne.s     _AAAAArgh
         move      #$2000,sr
d223 1
d229 2
d232 1
d250 1
d263 5
d274 1
a274 2
         move.l    _NextFreeBN(pc),(a1)
         move.l    a1,_NextFreeBN
d281 1
d283 1
d286 2
a287 2
         move      #$2000,sr
         move.w    #$8060,intena(a6)
d295 1
d297 1
d304 3
a306 12
         rts
;fe
;fs "_AddBlitNodeHead"
_AddBlitNodeHead:  ; a1=Node
         move.l    a1,d0
         cmp.l     #$dff040,d0
         beq.s     .Done
         lea       -12(a1),a1
         move.w    #$40,intena(a6)
         move.l    _NextBlit(pc),a0
         move.l    a0,(a1)
         move.l    a1,_NextBlit
a307 1
.Done:
d325 8
d345 5
d351 10
a360 1
         move.l    d7,_NextFreeBN
d364 1
d367 1
d369 1
d371 2
a372 1
         bra.s     _DoCPUBlits
d375 1
d377 3
d384 8
d393 52
a444 3
         move.l    _LastBlit(pc),a0
         move.l    d7,_LastBlit
         move.l    d7,(a0)
d452 102
@


0.13
log
@Correction d'un bug avec BlitHook dans l'interruption blitter
@
text
@d6 1
a6 1
* $Id: Support.s 0.12 1997/08/31 17:38:31 MORB Exp MORB $
d76 2
a79 2
         move.w    #$f80,$dff180

d95 1
d104 2
d112 1
a119 1
         clr.w     $dff180
d152 1
a152 1
_GetBlitNode:      ; a0=Code d0=Data
d167 1
d180 2
a181 1
         lea       -12(a1),a1
d185 14
d203 1
d205 1
a205 1
         lea       -12(a1),a1
d214 1
d220 1
d234 14
d272 1
d276 43
@


0.12
log
@Adaptation de PreAddBlitNode()
@
text
@d6 1
a6 1
* $Id: Support.s 0.11 1997/08/31 17:35:48 MORB Exp MORB $
d89 1
@


0.11
log
@Simplification et optimisation des routines blitter. Nécéssite des modifs dans les routines qui les utilisent...
@
text
@d6 1
a6 1
* $Id: Support.s 0.10 1997/08/30 23:07:34 MORB Exp MORB $
a174 3
         move.l    a1,d0
         cmp.l     #$dff040,d0
         beq.s     .Done
a178 1
.Done:
@


0.10
log
@Correction d'un bug dans CancelBlit()
@
text
@d6 1
a6 1
* $Id: Support.s 0.9 1997/08/30 11:39:22 MORB Exp MORB $
d78 2
a84 1
         move.l    _BHData(pc),a0
d87 2
a88 3
         move.l    d0,a1
         jsr       (a1)
         clr.l     _BlitHook
d90 1
d99 1
a99 1
         move.l    _NextFreeBN(pc),(a1)+
a100 3
         move.l    (a1)+,_BlitHook
         move.l    (a1),_BHData
         clr.l     (a1)+
d102 7
a108 1
         ;bra.s     .EtHop
a109 28
         lea       bltcon0(a6),a6
         movem.w   (a1)+,d0-3
         move.w    d0,(a6)+
         move.w    d1,(a6)+
         move.w    d2,(a6)+
         move.w    d3,(a6)+
         movem.l   (a1)+,d0-3
         move.l    d0,(a6)+
         move.l    d1,(a6)+
         move.l    d2,(a6)+
         move.l    d3,(a6)+
         lea       8(a6),a5
         addq.l    #4,a1
         movem.w   (a1)+,d0-5
         move.w    d2,(a5)+
         move.w    d3,(a5)+
         move.w    d4,(a5)+
         move.w    d5,(a5)+
         addq.l    #8,a5
         addq.l    #8,a1
         movem.w   (a1)+,d2-4
         move.w    d2,(a5)+
         move.w    d3,(a5)+
         move.w    d4,(a5)+
         addq.l    #4,a6
         move.w    d0,(a6)+
         move.w    d1,(a6)
         bra.s     .BDone
d115 1
a115 1
         ;clr.w     $dff180
d122 2
d148 1
a148 1
_GetBlitNode:      ; a0=Hook d0=Data
a150 1
         bset      #1,_BlitterBusy
a154 13
         bset      #0,_BlitterBusy
         bne.s     .Gerflor
         lea       CustomBase,a1
         btst      #6,dmaconr(a1)
.EtHop:
         btst      #6,dmaconr(a1)
         bne.s     .EtHop

         lea       bltcon0(a1),a1
         move.l    a0,_BlitHook
         move.l    d0,_BHData
         rts
.Gerflor:
d187 1
a187 3
         move.l    a1,d0
         cmp.l     #$dff040,d0
         beq.s     .Done
d189 18
@


0.9
log
@Désactivation des interruptions pendant le traitement d'une interruption blitter
@
text
@d6 1
a6 1
* $Id: Support.s 0.8 1997/08/29 17:45:54 MORB Exp MORB $
d19 1
a19 1
         move.l    #BlitQueueSize-1,d0
a77 4
         move      #$2700,sr

         ;move.w    #$840,$dff180

d101 2
a102 1
         move.l    (a1)+,_BHData
d135 2
a136 1
         sf        _BlitterBusy
a139 1
         move      #$2000,sr
d171 3
d175 2
a176 1
         move.w    #$4000,intena(a6)
d192 4
d200 1
d202 6
d228 1
a229 1
         move.l    a1,_LastBlit
d231 2
d234 1
a234 1
         move.w    #$c000,intena(a6)
d253 6
a260 2
         move      #$2000,sr
         move.w    #$c000,intena(a6)
@


0.8
log
@Nettoyage de quelques trucs dans les routines blitter
@
text
@d6 1
a6 1
* $Id: Support.s 0.7 1997/08/29 17:05:53 MORB Exp MORB $
d78 2
d142 1
a142 1
         lea       CustomBase,a6
@


0.7
log
@Correction d'un problème de désactivation d'interruption dans les routines blitter. Devrait faire disparaître plain de bugs collants
@
text
@d6 1
a6 1
* $Id: Support.s 0.6 1997/08/25 23:17:05 MORB Exp MORB $
a28 8
         tst.b     _NoInt
         beq.s     .OkInt

         move.w    $dff006,$dff180

         rte
.OkInt:

a76 12
         ;tst.w     _Debug
         ;beq.s     .ah
.greuk:
         ;move.w    $dff006,$dff180
         ;btst      #2,$dff016
         ;bne.s     .greuk
.eerk:
         ;btst      #2,$dff016
         ;beq.s     .eerk
.ah:

         move.w    #$4000,intena(a6)
a140 1
         move.w    #$c000,intena(a6)
a160 3
_NoInt:
         ds.b      1
         even
a171 1
         lea       CustomBase,a6
d177 2
a178 1
         btst      #6,dmaconr(a6)
d180 1
a180 1
         btst      #6,dmaconr(a6)
d183 1
a183 1
         lea       bltcon0(a6),a1
a187 4
         ;bset      #0,_BlitSem
         ;beq.s     .Raah
         ;stop      #

a208 1
         lea       CustomBase,a6
a216 1
         bclr      #0,_NoInt
a238 1
         bclr      #0,_NoInt
@


0.6
log
@Embryon de gestion du clavier (touche espace pour faire apparaitre/disparaitre la gui)
@
text
@d6 1
a6 1
* $Id: Support.s 0.5 1997/08/24 17:56:04 MORB Exp MORB $
d29 8
d85 12
d160 2
d182 3
d196 2
d199 1
d202 1
a202 2
         lea       CustomBase,a1
         btst      #6,dmaconr(a1)
d204 1
a204 1
         btst      #6,dmaconr(a1)
d207 1
a207 1
         lea       bltcon0(a1),a1
d212 4
d237 1
d246 2
d269 2
d343 1
a343 1
         cmp.l     #GuiLayer1,_GuiLayerPtr
d346 1
a346 1
         move.l    #GuiLayer1,_GuiLayerPtr
@


0.5
log
@Ajout des routines pour les sprites hard
@
text
@d6 1
a6 1
* $Id: Support.s 0.4 1997/08/23 01:18:03 MORB Exp MORB $
d54 1
a54 1
         btst      #6,$bfe001
d56 1
a56 1
         lea       .Leave(pc),a0
d142 1
a142 1
.Leave:
d281 1
a281 1
         add.w     #$80,d2
d296 22
@


0.4
log
@Implémentation de PreAddBlitNode()
@
text
@d6 1
a6 1
* $Id: Support.s 0.3 1997/08/22 18:37:15 MORB Exp MORB $
d236 60
@


0.3
log
@Changement RCS ($Id)
@
text
@d6 1
a6 1
* $Id$
d190 12
@


0.2
log
@Modification truc RCS. Désolé.
@
text
@d6 1
a6 2
* $Revision$
* $Date$
@


0.1
log
@Première version historifiée
@
text
@d6 2
a7 1
* $VER$
@


0.0
log
@*** empty log message ***
@
text
@d2 1
a2 1
* CdBSian Obviously Universal & Interactive Nonsense (COUIN) v0.0
d6 1
@
