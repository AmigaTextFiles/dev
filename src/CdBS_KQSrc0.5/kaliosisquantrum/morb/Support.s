*
* CdBSian Obviously Universal & Interactive Nonsense (COUIN)
* (Absurdité CdBSienne Manifestement Universelle et Interactive)
* ©1997-1998, CdBS Software (MORB)
* Support routines
* $Id: Support.s 0.25 1998/03/30 18:25:16 MORB Exp MORB $
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

	 bsr       _HandleGui

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
