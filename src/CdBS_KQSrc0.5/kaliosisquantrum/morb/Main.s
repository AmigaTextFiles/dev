*
* CdBSian Obviously Universal & Interactive Nonsense (COUIN)
* (Absurdité CdBSienne Manifestement Universelle et Interactive)
* ©1997-1998, CdBS Software (MORB)
* Main routine
* $Id: Main.s 0.8 1997/09/27 22:50:21 MORB Exp MORB $
*

_Main:
	 movem.l   d0-7/a0-6,-(a7)

	 move.l    a7,_A7Save
	 move.l    #_GameCopTable,_CopperTable
	 bsr       _InitBlitNodes
	 clr.w     _Debug

	 bsr       _InitGui

	 lea       Plf1(pc),a5
	 lea       BpPtrs+2,a1
	 lea       WBpPtrs+2,a2
	 move.l    a1,pf_BpPtrs(a5)
	 move.l    a2,pf_BpWPtrs(a5)
	 move.l    #Wrap,pf_WPosPtr(a5)

	 lea       Plf2(pc),a5
	 lea       BpPtrs2+2,a1
	 lea       WBpPtrs2+2,a2
	 move.l    a1,pf_BpPtrs(a5)
	 move.l    a2,pf_BpWPtrs(a5)
	 move.l    #Wrap2,pf_WPosPtr(a5)

	 lea       BpPtrs,a1
	 lea       WBpPtrs,a2
	 move.w    #bplpt,d0
	 moveq     #NbPlanes-1,d1
.FillClst_Loop:
	 swap      d2
	 move.w    d0,(a1)+
	 move.w    d0,(a2)+
	 move.w    d2,(a1)+
	 move.w    d2,(a2)+
	 addq.w    #2,d0
	 move.w    d0,(a1)+
	 move.w    d0,(a2)+
	 swap      d2
	 move.w    d2,(a1)+
	 move.w    d2,(a2)+
	 addq.w    #6,d0
	 add.l     #BufferWidth,d2
	 dbf       d1,.FillClst_Loop

	 lea       BpPtrs2,a1
	 lea       WBpPtrs2,a2
	 move.w    #bplpt+4,d0
	 moveq     #NbPlanes-1,d1
.FillClst_Loop2:
	 swap      d2
	 move.w    d0,(a1)+
	 move.w    d0,(a2)+
	 move.w    d2,(a1)+
	 move.w    d2,(a2)+
	 addq.w    #2,d0
	 move.w    d0,(a1)+
	 move.w    d0,(a2)+
	 swap      d2
	 move.w    d2,(a1)+
	 move.w    d2,(a2)+
	 addq.w    #6,d0
	 add.l     #BufferWidth,d2
	 dbf       d1,.FillClst_Loop2

	 move.l    #_StdMouseGardenDwarfDat,_GDwarfTable

	 ;lea       _GDwarfTable+2*4,a3
	 ;moveq     #5-1,d5
	 ;lea       _BackDats,a4
	 ;lea       BGDwarves,a0
	 ;moveq     #32,d7    ; 67
	 ;moveq     #0,d6

.BgLoop:
	 ;move.l    a4,(a3)+
	 ;move.l    a4,(a0)
	 ;move.w    d6,gdw_X(a0)
	 ;move.w    d7,gdw_Y(a0)
	 ;bsr       _RefreshGardenDwarf
	 ;lea       2*16+122*16(a4),a4
	 ;lea       gdw_Size(a0),a0
	 ;add.l     #64*4,d6
	 ;dbf       d5,.BgLoop

	 ;bsr       _LoadGardenDwarvesPtrs


	 moveq     #100,d0
	 bsr       _BackGroundScroll

	 bsr       _Ripolin

	 lea       Plf1(pc),a5
	 move.l    #RTbl1,pf_RefreshTbls(a5)
	 move.l    #RTbl1,pf_RefreshPtrs(a5)
	 move.l    #RTbl2,pf_RefreshTbls+4(a5)
	 move.l    #RTbl2,pf_RefreshPtrs+4(a5)
	 move.l    #RTbl3,pf_RefreshTbls+8(a5)
	 move.l    #RTbl3,pf_RefreshPtrs+8(a5)
	 bsr       _ScrlInit
	 lea       Plf2(pc),a5

	 movem.l   X,d0-1
	 lsr.l     #1,d0
	 lsr.l     #1,d1
	 movem.l   d0-1,X2

	 bsr       _ScrlInit

	 move.l    #-1,RTbl1
	 move.l    #-1,RTbl2
	 move.l    #-1,RTbl3

	 movem.l   d0-7/a0-6,-(a7)
	 bsr       _MergeCopperLists
	 movem.l   (a7)+,d0-7/a0-6

	 lea       CustomBase,a6
	 move.l    #CopperList,cop1lc(a6)
	 clr.w     copjmp1(a6)

	 bsr       _SwitchToCOUIN

	 ;move.w    #1,fmode(a6)

	 move.l    #TstScrl,_VblHook
	 bsr       _WaitVbl

	 move.w    #DMAF_SETCLR|DMAF_MASTER|DMAF_RASTER|DMAF_COPPER|DMAF_BLITTER|DMAF_SPRITE,dmacon(a6)

	 bsr       _DebugMenu



	 ;move.w    #$20,$dff09a

	 ;moveq     #7,d2
	 ;sf        d1
	 ;move.l    _DispBitmap,d3
	 ;add.l     #4,d3
	 ;moveq     #0,d0
	 ;sub.l     a0,a0
	 ;lea       Plf1(pc),a5
	 ;bsr       _DrawTile
	 ;moveq     #8,d2
	 ;sf        d1
	 ;move.l    _DispBitmap,d3
	 ;add.l     #6,d3
	 ;moveq     #0,d0
	 ;sub.l     a0,a0
	 ;lea       Plf1(pc),a5
	 ;bsr       _DrawTile


.BigLoop:
	 bsr.s     _WaitVbl
	 clr.l     _LastPlayfieldBlit

	 lea       Plf1(pc),a5
	 move.l    pf_Sprites(a5),a4
	 move.l    sh_PosOfst(a4),d0
	 bchg      #4,d0
	 ;move.l    d0,sh_PosOfst(a4)

	 bset      #1,_BlitDone
	 move.b    _UseCPU,_CpuGnaFlag
	 bsr       _RefreshBuffer
	 bsr       _DrawSpriteList

	 ;cmp.l     #CopEnd,_GuiLayerPtr
	 ;beq.s     .NoGui
	 ;bsr       _CheckBlitLists
	 ;;;;;;;;;;;;;;;;;;;;bsr.s     _HandleGui
	 ;bsr       _CheckBlitLists
;.NoGui:

	 bclr      #1,_BlitDone

	 ;bclr      #0,_BlitDone
	 ;beq.s     .GnaBlitter
	 ;sf        _UseCPU
	 ;move.l    pf_BlitWorkOfst(a5),pf_WorkOfst(a5)
.GnaBlitter:

	 lea       Plf1(pc),a5
	 st        _UseCPU
	 move.l    pf_CpuWorkOfst(a5),pf_WorkOfst(a5)

	 move.w    #$0040,intena(a6)
	 move.w    #$2700,sr
	 ;bsr       _CheckBlitLists
	 move.l    _LastPlayfieldBlit,a0
	 move.l    a0,d0
	 beq.s     .DoCBuf
	 cmp.l     #1,-4(a0)
	 bne.s     .DoCBuf

	 move.l    #2,-4(a0)
	 bra.s     .BlitOk

.DoCBuf:
	 bclr      #0,_BlitDone
	 ;bsr       _CheckBlitLists
	 bsr       _ChangeBuffers
	 sf        _UseCPU
	 move.l    pf_BlitWorkOfst(a5),pf_WorkOfst(a5)
	 move.w    #$2000,sr
	 move.w    #$8040,intena(a6)
	 bra.s     .BigLoop

.BlitOk:
	 move.w    #$2000,sr
	 move.w    #$8040,intena(a6)

	 tst.b     _CpuGnaFlag
	 bne.s     .GnaCpu

.gleurp:
	 tst.b     _UseCPU
	 bne.s     .gleurp
	 bra       .BigLoop

.GnaCpu:
	 bsr       _DoCPUBlits           
	 ;move.w    #$ff0,$dff180
	 tst.b     d0                    
	 beq       .BigLoop
					 
.gagu:                                   
	 ;move.w    $dff006,d0
	 ;and.w     #$f0f,d0
	 ;move.w    d0,$dff180
	 ;btst      #6,$dff016
	 ;bne.s     .gagu
.gneee:                                  
	 ;btst      #6,$dff016
	 ;beq.s     .gneee
					 
.WaitForBlitter:                         
	 ;move.w    $dff006,d0
	 ;and.w     #$ff0,d0
	 ;move.w    d0,$dff180
	 tst.b     _UseCPU
	 bne.s     .WaitForBlitter

	 bsr       _WaitVbl
	 lea       Plf1(pc),a5
	 bsr       _ChangeBuffers
	 sf        _UseCPU
	 move.l    pf_BlitWorkOfst(a5),pf_WorkOfst(a5)

	 bra       .BigLoop

_CBufHook:
	 lea       Plf1(pc),a5
	 bsr       _ChangeBuffers
	 bset      #0,_BlitDone
	 btst      #1,_BlitDone
	 bne.s     .Ouin

	 sf        _UseCPU
	 move.l    pf_BlitWorkOfst(a5),pf_WorkOfst(a5)

.Ouin:
	 rts

_CpuGnaFlag:
	 ds.b      1
_BlitDone:
	 ds.b      1
	 even

_Exit:
	 bsr       _SwitchToSystem
	 movem.l   (a7)+,d0-7/a0-6
	 rts


TstScrl:
	 move.l    Low_Base,a6

	 bsr       _HandleMouse
	 movem.l   XSpeed,d6-7

	 moveq     #1,d0
	 CALL      ReadJoyPort
	 btst      #JPB_JOY_LEFT,d0
	 beq.s     .NoLeft
	 sub.l     d6,X
.NoLeft:
	 btst      #JPB_JOY_RIGHT,d0
	 beq.s     .NoRight
	 add.l     d6,X
.NoRight:
	 btst      #JPB_JOY_UP,d0
	 beq.s     .NoUp
	 sub.l     d7,Y
.NoUp:
	 btst      #JPB_JOY_DOWN,d0
	 beq.s     .NoDown
	 add.l     d7,Y
.NoDown:

	 lea       Plf1(pc),a5
	 bsr       _HardwareScrolling
	 move.l    d0,-(a7)

	 movem.l   X,d0-1
	 lsr.l     #1,d0
	 lsr.l     #1,d1
	 ;sub.l     #150,d1
	 movem.l   d0-1,X2
	 lsr.l     #1,d0
	 bsr       _BackGroundScroll

	 lea       Plf2(pc),a5
	 bsr       _HardwareScrolling

	 move.l    (a7)+,d1
	 lsr.w     #4,d1
	 or.w      d1,d0
	 move.w    d0,_BplCon1

	 bsr       _MergeCopperLists

	 lea       Plf1(pc),a5
	 bsr       _GerflorScrolling
	 lea       Plf2(pc),a5
	 bsr       _GerflorScrolling
	 rts
gna:

	 move.l    Low_Base,a6

	 bsr       _HandleMouse

	 moveq     #1,d0
	 CALL      ReadJoyPort
	 btst      #JPB_JOY_LEFT,d0
	 beq.s     .NoLeft
	 sub.l     #4,X
.NoLeft:
	 btst      #JPB_JOY_RIGHT,d0
	 beq.s     .NoRight
	 add.l     #4,X
.NoRight:
	 btst      #JPB_JOY_UP,d0
	 beq.s     .NoUp
	 sub.l     #2,Y
.NoUp:
	 btst      #JPB_JOY_DOWN,d0
	 beq.s     .NoDown
	 add.l     #2,Y
.NoDown

	 lea       Plf1(pc),a5
	 bsr       _HardwareScrolling
	 bsr       _MergeCopperLists
	 lea       Plf1(pc),a5
	 bsr       _GerflorScrolling
	 rts

_LastPlayfieldBlit:
	 ds.l      1

_GameCopTable:
	 dc.l      GameNml
	 dc.l      CopLayer1,CopLayer3,CopLayer2000
_GuiLayerPtr:
	 dc.l      CopEnd,-1
	 ;dc.l      CopLayer4,-1
CopLayer1:
	 dc.l      0,0
	 dc.w      $29,CET_LONG
	 dc.l      RipolinBuf
	 dc.l      LST_BLOCK
	 dc.l      (16+4+3)*4
cl12:
	 dc.l      0,0
	 dc.w      $30,CET_LONG
	 dc.l      cl12buf
	 dc.l      LST_NOMANSLAND

CopLayer2:
	 dc.l      0,0
	 dc.w      $110,CET_SHORT
	 dc.l      cl21dat

CopLayer3:
	 dc.l      0,0
Wrap:
	 dc.w      $40,CET_LATE
	 dc.l      WrapDat

CopLayer2000:
	 dc.l      0,0
Wrap2:
	 dc.w      $40,CET_LATE
	 dc.l      WrapDat2

BGDwarves:
	 rept      5

	 dc.l      0,0
	 dc.w      0,0,122

	 endr

Plf1SprH:
	 dc.l      0
	 dc.l      Plf1
	 dc.l      0

Plf2SprH:
	 dc.l      0
	 dc.l      Plf2
	 dc.l      0

Plf1:
	 dc.l      Plf1Tiles
	 dc.l      Plf1SprH

	 dc.l      Plf1Map+12

	 dc.l      0         ;TstMap-45*4-4
	 dc.l      0         ;TstMap-45*4-4

	 dc.l      100,100
	 dc.l      0,0       ;1728,5184

X:
	 dc.l      400*4
Y:
	 dc.l      5000      ;BufferHeight*3+150+30
	 dc.l      0,0
	 dc.l      0,0,0,0

	 dc.l      0,0,0,0
	 dc.l      0,0,0
	 dc.l      0,0,0,0
	 dc.l      4,0,4,8
_Bitmap1:
	 ds.l      1
_Bitmap2:
	 ds.l      1
_Bitmap3:
	 ds.l      1

_ClearBitmap:
	 dc.l      0
	 dc.l      0,0,0,0,0,0

	 dc.w      0
	 dc.w      0,0,0,0   ;-1,-1,-1,-1
	 ds.l      30

Plf2:
	 dc.l      Plf2Tiles
	 dc.l      Plf2SprH

	 dc.l      Plf2Map+12

	 dc.l      0         ;TstMap-45*4-4
	 dc.l      0         ;TstMap-45*4-4

	 dc.l      61,58
	 dc.l      0,0       ;1728,5184

X2:
	 dc.l      400*4
;Y:
	 dc.l      BufferHeight*3+150+30
	 dc.l      0,0
	 dc.l      0,0,0,0

	 dc.l      0,0,0,0
	 dc.l      0,0,0
	 dc.l      0,0,0,0
	 dc.l      4,0,4,8
_Bitmap4:
	 ds.l      1
_Bitmap5:
	 ds.l      1
_Bitmap6:
	 ds.l      1

_ClearBitmap2:
	 dc.l      0
	 dc.l      0,0,0,0,0,0

	 dc.w      0
	 dc.w      0,0,0,0   ;-1,-1,-1,-1
	 ds.l      30

Plf1Map:
	 incbin    "test.map"
	 even
Plf2Map:
	 incbin    "test2.map"
	 even

