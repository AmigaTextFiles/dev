head	0.8;
access;
symbols;
locks
	MORB:0.8; strict;
comment	@# @;


0.8
date	97.09.27.22.50.21;	author MORB;	state Exp;
branches;
next	0.7;

0.7
date	97.09.11.21.43.30;	author MORB;	state Exp;
branches;
next	0.6;

0.6
date	97.09.10.22.27.04;	author MORB;	state Exp;
branches;
next	0.5;

0.5
date	97.09.09.00.06.19;	author MORB;	state Exp;
branches;
next	0.4;

0.4
date	97.09.07.11.23.58;	author MORB;	state Exp;
branches;
next	0.3;

0.3
date	97.09.06.19.12.11;	author MORB;	state Exp;
branches;
next	0.2;

0.2
date	97.08.22.18.34.42;	author MORB;	state Exp;
branches;
next	0.1;

0.1
date	97.08.22.15.17.11;	author MORB;	state Exp;
branches;
next	0.0;

0.0
date	97.08.22.15.00.32;	author MORB;	state Exp;
branches;
next	;


desc
@Jeu à la beast avec des scrolls partout
RCS for GoldED · Initial login date: Aujourd'hui
@


0.8
log
@Une modif toute glonka klubz klonzluk paf.
@
text
@*
* CdBSian Obviously Universal & Interactive Nonsense (COUIN)
* (Absurdité CdBSienne Manifestement Universelle et Interactive)
* ©1997, CdBS Software (MORB)
* Main routine
* $Id: Main.s 0.7 1997/09/11 21:43:30 MORB Exp MORB $
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

         move.l    #_MouseGardenDwarfDat,_GDwarfTable

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
         bsr.s     _HandleGui
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
         dc.l      (16+3)*4
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

@


0.7
log
@Un poil de nettoyage. ga.
@
text
@d6 1
a6 1
* $Id: Main.s 0.6 1997/09/10 22:27:04 MORB Exp MORB $
d178 3
a180 2
         cmp.l     #CopEnd,_GuiLayerPtr
         beq.s     .NoGui
d182 2
a183 1
.NoGui:
a311 5
         movem.l   X,d0-1
         lsr.l     #1,d0
         lsr.l     #1,d1
         movem.l   d0-1,X2

d324 1
a325 1
         bsr       _HardwareScrolling
d330 1
@


0.6
log
@Najout du scrolling du plan de au fond.
@
text
@d6 1
a6 1
* $Id: Main.s 0.5 1997/09/09 00:06:19 MORB Exp MORB $
a11 13
         lea       CustomBase,a6
         move.w    dmaconr(a6),-(a7)
         move.w    intenar(a6),-(a7)
         move.w    intreqr(a6),-(a7)

         move.w    #$7fff,intena(a6)
         move.w    #$7fff,intreq(a6)
         move.w    #$7fff,dmacon(a6)
         clr.w     $180(a6)
         move.w    #$20,beamcon0(a6)
         movec     vbr,d0
         move.l    d0,a0
         move.l    $6c(a0),-(a7)
a12 2
         lea       _Level3_Int(pc),a1
         move.l    a1,$6c(a0)
a13 1
         move.w    #$c068,intena(a6)
a100 4
         ;movem.l   d0-7/a0-6,-(a7)
         ;bsr       _MergeCopperLists
         ;movem.l   (a7)+,d0-7/a0-6

d122 5
d129 3
d227 1
a227 1
         bra.s     .BigLoop
d233 1
a233 1
         beq.s     .BigLoop              
d258 1
a258 1
         bra.s     .BigLoop
d280 3
a282 15
         lea       $dff000,a6
         move.w    #$7fff,intena(a6)
         move.w    #$7fff,intreq(a6)
         btst      #6,dmaconr(a6)
.Wblit:
         btst      #6,dmaconr(a6)
         bne.s     .Wblit
         move.w    #$7fff,dmacon(a6)
gnarghm:
         movec     vbr,d0
         move.l    d0,a0
         move.l    (a7)+,$6c(a0)
         move.l    Gfx_Base,a0
         move.l    gb_copinit(a0),cop1lc(a6)
         clr.w     copjmp1(a6)
a283 11
         move.w    (a7)+,d0
         bset      #15,d0
         move.w    d0,intreq(a6)
         move.w    (a7)+,d0
         bset      #15,d0
         move.w    d0,intena(a6)
         move.w    (a7)+,d0
         bset      #15,d0
         move.w    d0,dmacon(a6)
         movem.l   (a7)+,d0-7/a0-6
         rte
d289 1
d295 1
a295 1
         sub.l     #16,X
d299 1
a299 1
         add.l     #16,X
d303 1
a303 1
         sub.l     #8,Y
d307 1
a307 1
         add.l     #8,Y
@


0.5
log
@(Dés)intégration de tous les plans pfouarf raâââh booôôô.
@
text
@d6 1
a6 1
* $Id: Main.s 0.4 1997/09/07 11:23:58 MORB Exp MORB $
d89 1
a89 1
         move.l    #_MouseSpriteDat,_SprTable
d91 6
a96 6
         lea       _SprTable+2*4,a3
         moveq     #5-1,d5
         lea       _BackDats,a4
         lea       BGSprs,a0
         moveq     #32,d7    ; 67
         moveq     #0,d6
d99 21
a119 24
         move.l    a4,(a3)+
         move.l    a4,(a0)
         move.w    d6,csp_X(a0)
         move.w    d7,csp_Y(a0)
         bsr       _RefreshSprite
         lea       2*16+122*16(a4),a4
         lea       csp_Size(a0),a0
         add.l     #64,d6
         dbf       d5,.BgLoop

         bsr       _LoadSpritePtrs

         bsr       _MakeRipolin

         movem.l   d0-7/a0-6,-(a7)
         bsr       _MergeCopperLists
         movem.l   (a7)+,d0-7/a0-6

         move.l    #CopperList,cop1lc(a6)
         clr.w     copjmp1(a6)
         move.w    #DMAF_SETCLR|DMAF_MASTER|DMAF_RASTER|DMAF_COPPER|DMAF_BLITTER|DMAF_SPRITE,dmacon(a6)
         ;move.w    #1,fmode(a6)

         bsr       _DebugMenu
d130 6
d142 4
d147 6
a351 1
         lea       Plf2(pc),a5
d357 4
d413 2
a414 1
         dc.l      CopLayer4,-1
d444 1
a444 1
BGSprs:
d477 1
a477 1
         dc.l      BufferHeight*3+150+30
d479 1
a479 1
         dc.l      0,0,0,0,0
d517 1
a517 1
         dc.l      0,0,0,0,0
@


0.4
log
@Nettoyu les moves dedans color0 de test qui traînaient partout
@
text
@d6 1
a6 1
* $Id: Main.s 0.3 1997/09/06 19:12:11 MORB Exp MORB $
d28 1
d35 14
d53 1
a53 1
FillClst_Loop:
d65 14
d80 6
d87 1
a87 1
         dbf       d1,FillClst_Loop
d90 19
d111 2
a112 1
         move.l    #_GameCopTable,_CopperTable
d124 1
a124 1
         lea       TestPlf(pc),a5
d132 3
d150 1
a150 1
         ;lea       TestPlf(pc),a5
d158 1
a158 1
         ;lea       TestPlf(pc),a5
d166 1
a166 1
         lea       TestPlf(pc),a5
d190 1
a190 1
         lea       TestPlf(pc),a5
d196 1
a196 1
         bsr       _CheckBlitLists
d208 1
a208 1
         bsr       _CheckBlitLists
d252 1
a252 1
         lea       TestPlf(pc),a5
d260 1
a260 1
         lea       TestPlf(pc),a5
d324 1
a324 1
         sub.l     #4,Y
d328 1
a328 1
         add.l     #4,Y
d330 27
a356 2
         lea       TestPlf(pc),a5
         bsr       _Scrolling
d368 1
a368 1
         sub.l     #8,X
d372 1
a372 1
         add.l     #8,X
d383 5
a387 2
         lea       TestPlf(pc),a5
         bsr       _Scrolling
d395 1
a395 1
         dc.l      cl12,CopLayer3
d399 1
a399 1
         dc.l      cl12,0
d401 1
a401 1
         dc.l      cl11dat
d403 1
a403 1
         dc.l      24
d421 20
a440 1
TestSprH:
d442 1
a442 1
         dc.l      TestPlf
d445 3
a447 3
TestPlf:
         dc.l      TestTiles
         dc.l      TestSprH
d449 1
a449 1
         dc.l      TstMap
d454 1
a454 1
         dc.l      120,120
d462 1
a462 1
         dc.l      0,0
d465 1
a465 1

d477 35
a511 6
         dc.l      $8f00000
         dc.l      $8f00000
         dc.l      $8f00000
         dc.l      $8f00000
         dc.l      $8f00000
         dc.l      $8f00000
d513 3
d521 7
a527 2
TstMap:
         incbin    "examplemap.120.120"
@


0.3
log
@Nimplémenté et débuggé triple-buffering et utilisation du cpu en plus du blitter. Pfouargplbl.
@
text
@d6 1
a6 1
* $Id: Main.s 0.2 1997/08/22 18:34:42 MORB Exp MORB $
d172 1
a172 1
         move.w    #$ff0,$dff180         
d177 5
a181 5
         move.w    $dff006,d0
         and.w     #$f0f,d0
         move.w    d0,$dff180
         btst      #6,$dff016
         bne.s     .gagu
d183 2
a184 2
         btst      #6,$dff016
         beq.s     .gneee
d187 3
a189 3
         move.w    $dff006,d0
         and.w     #$ff0,d0
         move.w    d0,$dff180
@


0.2
log
@Changement RCS ($Id)
@
text
@d6 1
a6 1
* $Id$
d28 1
a28 1
         move.w    #$c060,intena(a6)
d30 1
a32 1
         bsr       _GuiTest
a33 3
         move.l    _DispBitmap,d2
         move.l    d2,_DispBitmap2
         move.l    _WorkBitmap,_WorkBitmap2
d54 3
d64 1
a64 1
         move.w    #DMAF_SETCLR|DMAF_MASTER|DMAF_RASTER|DMAF_COPPER|DMAF_BLITTER,dmacon(a6)
d67 1
d70 6
a75 3
         move.l    #TestRMap,pf_DispRefreshMap(a5)
         move.l    #TestRTbl,pf_DispRefreshTbl(a5)

d77 3
d105 8
a112 3
         ;tst.b     _BlitterBusy
         ;bne.s     .BigLoop
         ;move.w    #$fff,$dff180
d114 4
d119 12
a130 2
         btst      #6,$dff016
         bne.s     .meuh
d133 2
a134 2
         lea       TestSprH(pc),a4
         lea       TestSpr(pc),a3
d136 21
a156 1
         move.l    pf_DispRefreshTbl(a5),pf_DispRTblPtr(a5)
d158 11
a168 1
         bsr       _DrawSprite
d170 13
a182 5
         move.l    pf_DispRTblPtr(a5),a0
         moveq     #-1,d0
         move.l    d0,(a0)

.honk:
d184 8
a191 1
         beq.s     .honk
d193 5
a197 1
.meuh:
d199 1
a199 2
         btst      #7,$bfe001
         bne.s     .BigLoop
d201 1
d203 7
a209 9
         bsr       _RefreshBuffer
         move.l    pf_DispRefreshTbl(a5),pf_DispRTblPtr(a5)
         move.l    pf_DispRTblPtr(a5),a0
         moveq     #-1,d0
         move.l    d0,(a0)

.Bof:
         btst      #7,$bfe001
         beq.s     .Bof
d211 2
a212 1
         bra.s     .BigLoop
d214 5
d222 2
a223 2
         ;move.w    #$7fff,intena(a6)
         ;move.w    #$7fff,intreq(a6)
d228 1
a228 1
         ;move.w    #$7fff,dmacon(a6)
a235 1
         ;move.w    gb_current_monitor+ms_BeamCon0(a0),beamcon0(a6)
d251 3
d274 2
d277 22
a298 1
         bsr       _MergeCopperLists
d300 2
d304 3
d309 3
a311 4
         dc.l      CopLayer1,CopLayer2,CopLayer3,CopLayer4,-1
_GuiCopTable:
         dc.l      GuiNml
         dc.l      GuiLayer1,-1
a334 17
CopLayer4:
         dc.l      0,0
         dc.w      $29+150,CET_BREAK
         ;dc.l      0,0
         dc.l      _GuiCList
         dc.l      _GuiCopTable

GuiLayer1:
         dc.l      guibrk,0
         dc.w      $29+151,CET_SHORT
         dc.l      bgcdat

guibrk:
         dc.l      0,0
         dc.w      $29+256,CET_BREAK
         dc.l      0,0

d336 1
a339 18
TestSpr:
         dc.l      50,160
         dc.l      TestSprD
         dc.l      50,160
         dc.l      TestSprD

TestSpr2:
         dc.l      50,100
         dc.l      TestSprD
         dc.l      50,100
         dc.l      TestSprD

TestSprD:
         dc.l      TestSprBm
         dc.l      TestSprMsk
         dc.l      6,96,51
         dc.l      0,0

d353 1
a353 1
         dc.l      50
d359 1
a359 1
         dc.l      0,0
d362 2
a363 1
_DispBitmap:
d365 1
a365 1
_WorkBitmap:
d367 1
a367 3
_DispBitmap2:
         ds.l      1
_WorkBitmap2:
d369 10
@


0.1
log
@Première version historifiée
@
text
@d2 1
a2 1
* CdBSian Obviously Universal & Interactive Nonsense (COUIN) v0.0
d6 1
a6 2
* $Revision$
* $Date$
@


0.0
log
@*** empty log message ***
@
text
@d6 2
@
