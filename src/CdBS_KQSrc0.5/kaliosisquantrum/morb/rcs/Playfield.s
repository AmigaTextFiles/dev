head	0.19;
access;
symbols;
locks
	MORB:0.19; strict;
comment	@# @;


0.19
date	97.09.09.00.12.21;	author MORB;	state Exp;
branches;
next	0.18;

0.18
date	97.09.08.16.45.11;	author MORB;	state Exp;
branches;
next	0.17;

0.17
date	97.09.07.11.27.18;	author MORB;	state Exp;
branches;
next	0.16;

0.16
date	97.09.06.22.55.34;	author MORB;	state Exp;
branches;
next	0.15;

0.15
date	97.09.06.19.15.36;	author MORB;	state Exp;
branches;
next	0.14;

0.14
date	97.09.03.12.30.45;	author MORB;	state Exp;
branches;
next	0.13;

0.13
date	97.09.03.00.34.30;	author MORB;	state Exp;
branches;
next	0.12;

0.12
date	97.09.02.12.44.59;	author MORB;	state Exp;
branches;
next	0.11;

0.11
date	97.08.31.17.36.58;	author MORB;	state Exp;
branches;
next	0.10;

0.10
date	97.08.30.23.06.34;	author MORB;	state Exp;
branches;
next	0.9;

0.9
date	97.08.30.19.03.10;	author MORB;	state Exp;
branches;
next	0.8;

0.8
date	97.08.30.11.40.01;	author MORB;	state Exp;
branches;
next	0.7;

0.7
date	97.08.29.18.00.30;	author MORB;	state Exp;
branches;
next	0.6;

0.6
date	97.08.28.21.32.28;	author MORB;	state Exp;
branches;
next	0.5;

0.5
date	97.08.28.18.53.24;	author MORB;	state Exp;
branches
	0.5.1.1;
next	0.4;

0.4
date	97.08.27.21.29.49;	author MORB;	state Exp;
branches;
next	0.3;

0.3
date	97.08.23.01.20.08;	author MORB;	state Exp;
branches;
next	0.2;

0.2
date	97.08.22.18.36.16;	author MORB;	state Exp;
branches;
next	0.1;

0.1
date	97.08.22.15.22.39;	author MORB;	state Exp;
branches;
next	0.0;

0.0
date	97.08.22.15.00.33;	author MORB;	state Exp;
branches;
next	;

0.5.1.1
date	97.08.29.17.49.39;	author MORB;	state Exp;
branches;
next	;


desc
@Jeu à la beast avec des scrolls partout
RCS for GoldED · Initial login date: Aujourd'hui
@


0.19
log
@Une ou deux modifs et un bon coup de hache dans Scrolling().
@
text
@*
* CdBSian Obviously Universal & Interactive Nonsense (COUIN)
* (Absurdité CdBSienne Manifestement Universelle et Interactive)
* ©1997, CdBS Software (MORB)
* Scrolling, sprites & double-buffer
* $Id: Playfield.s 0.18 1997/09/08 16:45:11 MORB Exp MORB $
*

;fs "_ScrlInit"
_ScrlInit:
         moveq     #-1,d0
         move.l    d0,pf_LeftCount(a5)
         move.l    d0,pf_UpCount(a5)

         move.l    pf_Map(a5),a0
         move.l    pf_Width(a5),d0
         move.l    d0,d1
         lsl.l     #2,d1
         addq.l    #4,d1
         sub.l     d1,a0
         move.l    a0,pf_OMapAddr(a5)

         lsl.l     #6,d0
         sub.w     #304*4,d0
         move.l    d0,pf_MaxX(a5)

         move.l    pf_Height(a5),d0
         lsl.l     #4,d0
         sub.w     #256,d0
         move.l    d0,pf_MaxY(a5)

         move.l    pf_X(a5),d6
         bpl.s     .XPos
         moveq     #0,d6
         bra.s     .XOk
.XPos:
         move.l    pf_MaxX(a5),d0
         cmp.l     d6,d0
         bcc.s     .XOk
         move.l    d0,d6
.XOk:
         move.l    d6,pf_X(a5)
         add.l     #HMargin/2*TileWidth*64,d6
         move.l    d6,pf_iX(a5)
         move.l    d6,pf_LastX(a5)

         move.l    pf_Y(a5),d7
         bpl.s     .YPos
         moveq     #0,d7
         bra.s     .YOk
.YPos:
         move.l    pf_MaxY(a5),d0
         cmp.l     d7,d0
         bcc.s     .YOk
         move.l    d0,d7
.YOk:
         move.l    d7,pf_Y(a5)
         add.l     #VMargin/2*TileHeight,d7
         move.l    d7,pf_iY(a5)
         move.l    d7,pf_LastY(a5)

         move.l    d7,d0
         divu      #BufferHeight,d0
         swap      d0
         move.w    #BufferHeight,d1
         sub.w     d0,d1

         move.l    d1,d4
         add.w     d7,d4
         move.l    pf_Y(a5),d3
         and.b     #$f0,d3
         sub.w     d3,d4
         move.w    d4,pf_WrapPos+2(a5)

         add.w     #$28,d1
         move.l    pf_WPosPtr(a5),a0
         move.w    d1,(a0)


**** Obsolete - MergeCopperLists s'occupe de tout ****
;         cmp.w     #$100,d1
;         bcs.s     .Gna
;         move.l    #$ffe1fffe,Wrap2
;         bra.s     .Couin
;.Gna:
;         move.l    #$01800000,Wrap2
;.Couin:


         move.l    d0,d1
         and.b     #$f0,d1
         mulu      #LineSize,d1
         mulu      #LineSize,d0

         move.l    d6,d3
         lsr.l     #5,d3

         and.b     #$fc,d3
         addq.l    #4,d3
         add.l     d3,d0
         move.l    d0,d1
         ;add.l     pf_ODispBitmap(a5),d0
         ;add.l     pf_OWorkBitmap(a5),d1

         lsr.l     #6,d6
         move.l    d6,pf_X16(a5)
         lsr.l     #4,d7
         move.l    d7,pf_Y16(a5)
         move.l    d7,d2
         mulu      pf_Width+2(a5),d2
         add.l     d6,d2
         add.l     a0,d2
         move.l    d2,pf_CMapAddr(a5)

         subq.l    #2,d7
         divu      #NbVerTile,d7

         swap      d7
         move.w    d7,pf_BufY16+2(a5)
         mulu      #LineSize*TileHeight,d7
         move.l    d7,pf_VBitmapOffset(a5)

         add.l     d6,d6
         move.l    d6,pf_WBitmapOffset(a5)
         add.l     d6,d7
         move.l    d7,pf_BitmapOffset(a5)
         add.l     #(BufferHeight-1)*LineSize,d6
         move.l    d6,pf_MaxBmOffset(a5)

         rts
         ;move.l    pf_ODispBitmap(a5),d3
         add.l     d7,d3
         move.l    d6,d4
         ;add.l     pf_ODispBitmap(a5),d4
         move.l    d2,a3
         move.l    pf_Width(a5),d5
         sub.l     #NbHorTile,d5
         move.w    #NbVerTile-1,d7

         ;move.w    #$4000,intena(a6)
         ;lea       $8f00000,a6

         ;bsr       _WaitVbl

.YLoop:
         move.w    #NbHorTile-1,d6

.XLoop:
         moveq     #0,d2
         move.b    (a3)+,d2
         moveq     #0,d1
         moveq     #0,d0
         sub.l     a0,a0
         bsr.s     _Gerflor
         addq.l    #2,d3
         dbf       d6,.XLoop

         add.l     d5,a3
         add.l     #LineSize*TileHeight-BufferWidth,d3
         cmp.l     d4,d3
         bcs.s     .Gloups
         move.l    pf_WBitmapOffset(a5),d3
         ;add.l     pf_ODispBitmap(a5),d3
.Gloups:

         dbf       d7,.YLoop

         rts

         sub.l     a0,a0
         moveq     #0,d0
         bsr       _GetBlitNode
         move.l    a1,a0
         move.l    #$09f00000,(a0)+
         moveq     #-1,d0
         move.l    d0,(a0)+
         addq.l    #8,a0
         ;move.l    pf_ODispBitmap(a5),(a0)+
         ;move.l    pf_OWorkBitmap(a5),(a0)
         lea       16(a0),a4
         addq.l    #8,a0
         clr.l     (a4)
         move.w    #(BufferHeight+1)*NbPlanes,(a0)+
         move.w    #BufferWidth/2,(a0)
         bsr       _AddBlitNode

         ;lea       CustomBase,a6
         ;move.w    #$c000,intena(a6)

         rts
;fe

;fs "_HardwareScrolling"
_HardwareScrolling:          ; a5=Playfield structure
         move.l    pf_X(a5),d6
         bpl.s     .XPos
         moveq     #0,d6
         bra.s     .XOk
.XPos:
         move.l    pf_MaxX(a5),d0
         cmp.l     d6,d0
         bcc.s     .XOk
         move.l    d0,d6
.XOk:
         move.l    d6,pf_X(a5)
         add.l     #HMargin/2*TileWidth*64,d6
         move.l    d6,pf_iX(a5)
         move.l    d6,d2
         sub.l     pf_LastX(a5),d6
         move.l    d6,pf_DeltaX(a5)
         move.l    d2,pf_LastX(a5)

         move.l    pf_Y(a5),d7
         bpl.s     .YPos
         moveq     #0,d7
         bra.s     .YOk
.YPos:
         move.l    pf_MaxY(a5),d0
         cmp.l     d7,d0
         bcc.s     .YOk
         move.l    d0,d7
.YOk:
         move.l    d7,pf_Y(a5)
         add.l     #VMargin/2*TileHeight,d7
         move.l    d7,pf_iY(a5)
         move.l    d7,d5
         sub.l     pf_LastY(a5),d7
         move.l    d7,pf_DeltaY(a5)
         move.l    d5,pf_LastY(a5)


**** ¡”$“®“® ¡©¡ |“$ ™“$™$ ’“ ’“—|ª©“‡“”™$ |¡‡¡™“
**** “™ |“ ß®ª”©h“‡“”™ $µ® |“ ‡“®’¡“® ’“ $©®ø||¡”9 $—“©¡ª| —øµ®
**** |“$ ’“—|ª©“‡“”™$ ¡‡—ø®tª”™$ “” ’øµß|“ ßµ££“®


         move.l    d5,d0
         divu      #BufferHeight,d0
         swap      d0
         move.w    #BufferHeight,d1
         sub.w     d0,d1

         move.l    pf_iY(a5),d4
         add.w     d1,d4
         move.l    pf_Y(a5),d3
         and.b     #$f0,d3
         sub.w     d3,d4
         move.w    d4,pf_WrapPos+2(a5)

         add.w     #$28,d1
         move.l    pf_WPosPtr(a5),a0
         move.w    d1,(a0)

         move.l    d0,d1
         and.b     #$f0,d1
         mulu      #LineSize,d1
         mulu      #LineSize,d0

         move.l    d2,d3
         lsr.l     #5,d3
         and.b     #$fc,d3
         addq.l    #4,d3
         add.l     d3,d0

         lea       pf_Bitmaps(a5),a1
         add.l     pf_DispOfst(a5),a1
         move.l    (a1),d1
         add.l     d1,d0

         move.l    pf_BpPtrs(a5),a0
         moveq     #NbPlanes-1,d4
.BpLoop:
         swap      d0
         move.w    d0,(a0)
         addq.l    #4,a0
         swap      d0
         move.w    d0,(a0)
         addq.l    #4,a0
         add.l     #BufferWidth,d0
         dbf       d4,.BpLoop

         add.l     d3,d1
         move.l    pf_BpWPtrs(a5),a0
         moveq     #NbPlanes-1,d3
.WBpLoop:
         swap      d1
         move.w    d1,(a0)
         addq.l    #4,a0
         swap      d1
         move.w    d1,(a0)
         addq.l    #4,a0
         add.l     #BufferWidth,d1
         dbf       d3,.WBpLoop

         move.l    d2,pf_HShift(a5)
         sub.l     #64,d2
         not.w     d2

         move.w    d2,d0
         and.w     #2,d0
         ror.w     #2,d0
         move.b    d2,d0
         and.b     #$40,d0
         lsr.b     #6,d0
         ror.w     #2,d0
         lsr.b     #2,d2
         and.b     #$f,d2
         lsl.b     #4,d2
         move.b    d2,d0
         ;move.w    d0,d2
         ;lsr.w     #4,d2
         ;or.w      d2,d0

         ;move.w    d0,_BplCon1
         rts
;fe
;fs "_GerflorScrolling"
_GerflorScrolling: ; a5=Playfield structure
         movem.l   pf_DeltaX(a5),d6-7
         movem.l   pf_iX(a5),d3/d5


         move.l    pf_iX(a5),d0
         lsr.l     #6,d0
         move.l    pf_iY(a5),d1
         lsr.l     #4,d1
         move.l    d1,d2
         mulu      pf_Width+2(a5),d2
         add.l     d0,d2
         add.l     pf_OMapAddr(a5),d2
         move.l    d2,pf_CMapAddr(a5)

         move.l    pf_X16(a5),d2
         cmp.l     d0,d2
         beq.s     .HorOk
         move.l    d0,pf_X16(a5)
         sub.l     d2,d0
         bpl.s     .UlOk
         move.w    pf_UpCount(a5),d2
         ble.s     .UlNoUp
         subq.w    #1,d2
         move.w    d2,pf_UpCount(a5)
.UlNoUp:
         move.w    pf_DownCount(a5),d2
         ble.s     .UlOk
         subq.w    #1,d2
         move.w    d2,pf_DownCount(a5)
.UlOk:

         moveq     #-1,d0
         move.l    d0,pf_LeftCount(a5)
.HorOk:

         move.l    pf_Y16(a5),d2
         cmp.l     d1,d2
         beq.s     .VerOk
         move.l    d1,pf_Y16(a5)
         sub.l     d2,d1
         bpl.s     .UuOk
         move.w    pf_LeftCount(a5),d2
         ble.s     .UuNoLeft
         subq.w    #1,d2
         move.w    d2,pf_LeftCount(a5)
.UuNoLeft:
         move.w    pf_RightCount(a5),d2
         ble.s     .UuOk
         subq.w    #1,d2
         move.w    d2,pf_RightCount(a5)
.UuOk:

         moveq     #-1,d0
         move.l    d0,pf_UpCount(a5)
.VerOk:

         move.l    pf_Y16(a5),d0
         subq.l    #2,d0
         divu      #NbVerTile,d0
         swap      d0
         move.w    d0,pf_BufY16+2(a5)

         mulu      #LineSize*TileHeight,d0
         move.l    d0,pf_VBitmapOffset(a5)
         move.l    pf_X16(a5),d1
         add.l     d1,d1
         move.l    d1,pf_WBitmapOffset(a5)
         add.l     d1,d0
         move.l    d0,pf_BitmapOffset(a5)
         add.l     #(BufferHeight-1)*LineSize,d1
         move.l    d1,pf_MaxBmOffset(a5)

         move.l    #NbHorTile*2,d0
         and.l     #$f,d5
         tst.l     d7
         beq.s     .VerScrollOk
         spl       d0
         move.b    d0,pf_UpDownFlag(a5)
         bne.s     .DoDown
         move.l    d5,d0
         neg.w     d7
         divu      d7,d0
         tst.w     pf_UpCount(a5)
         bpl.s     .VerScrollOk
         move.l    pf_CMapAddr(a5),pf_UMapAddr(a5)
         move.l    pf_BitmapOffset(a5),pf_UBmOffset(a5)
         move.w    #BufferWidth/(TileWidth*2),pf_UpCount(a5)
         bra.s     .VerScrollOk

.DoDown:
         moveq     #TileHeight,d0
         sub.b     d5,d0
         divu      d7,d0
         tst.w     pf_DownCount(a5)
         bpl.s     .VerScrollOk
         move.l    #NbVerTile-1,d1
         mulu      pf_Width+2(a5),d1
         add.l     pf_CMapAddr(a5),d1
         move.l    d1,pf_DMapAddr(a5)
         move.l    pf_VBitmapOffset(a5),d1
         add.l     #(BufferHeight-TileHeight)*LineSize,d1
         move.l    #BufferHeight*LineSize,d2
         cmp.l     d2,d1
         bcs.s     .DOk
         sub.l     d2,d1
.DOk:
         move.l    pf_X16(a5),d2
         add.l     d2,d2
         add.l     d2,d1
         move.l    d1,pf_DBmOffset(a5)
         move.w    #BufferWidth/(TileWidth*2),pf_DownCount(a5)
.VerScrollOk:

         move.l    d0,d7
         swap      d7
         tst.w     d7
         bne.s     .VRoundUp
         tst.w     d0
         bne.s     .VNoRoundUp
.VRoundUp:
         addq.w    #1,d0
.VNoRoundUp:
         move.w    d0,-(a7)

         move.l    #NbVerTile*2,d0
         and.l     #$3f,d3
         tst.l     d6
         beq.s     .HorScrollOk
         spl       d0
         move.b    d0,pf_LeftRightFlag(a5)
         bne.s     .DoRight
         move.l    d3,d0
         neg.w     d6
         divu      d6,d0
         tst.w     pf_LeftCount(a5)
         bpl.s     .HorScrollOk
         move.l    pf_WBitmapOffset(a5),pf_LWBmOffset(a5)
         move.l    pf_MaxBmOffset(a5),pf_LMBmOffset(a5)
         move.l    pf_CMapAddr(a5),pf_LMapAddr(a5)
         move.l    pf_BitmapOffset(a5),pf_LBmOffset(a5)
         move.w    #BufferHeight/TileHeight,pf_LeftCount(a5)
         bra.s     .HorScrollOk

.DoRight:
         moveq     #TileWidth*64,d0
         sub.b     d3,d0
         divu      d6,d0
         tst.w     pf_RightCount(a5)
         bpl.s     .HorScrollOk
         move.l    pf_WBitmapOffset(a5),pf_RWBmOffset(a5)
         move.l    pf_MaxBmOffset(a5),pf_RMBmOffset(a5)
         move.l    pf_CMapAddr(a5),d1
         add.l     #NbHorTile-1,d1
         move.l    d1,pf_RMapAddr(a5)
         move.l    pf_BitmapOffset(a5),d1
         add.l     #BufferWidth-TileWidth*2,d1
         move.l    d1,pf_RBmOffset(a5)
         move.w    #BufferHeight/TileHeight,pf_RightCount(a5)

.HorScrollOk:
         move.l    d0,d6
         swap      d6
         tst.w     d6
         bne.s     .HRoundUp
         tst.w     d0
         bne.s     .HNoRoundUp
.HRoundUp:
         addq.w    #1,d0
.HNoRoundUp:

         tst.b     pf_LeftRightFlag(a5)
         bne.s     .DrwRight

         move.w    pf_LeftCount(a5),d4
         ble.s     .Ni
         ext.l     d4
         divu      d0,d4
         move.l    d4,d0
         swap      d0
         tst.w     d0
         bne.s     .LRoundUp
         subq.w    #1,d4
.LRoundUp:
         sub.w     d4,pf_LeftCount(a5)
         sub.w     #1,pf_LeftCount(a5)

         move.l    pf_LBmOffset(a5),d5
         move.l    d5,d6
         lea       pf_Bitmaps(a5),a2
         add.l     (a2),d6
         move.l    d5,d7
         add.l     4(a2),d7
         move.l    d5,a4
         add.l     8(a2),a4
         move.l    d5,a1
         add.l     12(a2),a1
         move.l    pf_LMapAddr(a5),a3

.LeftLoop:
         moveq     #0,d2
         move.b    (a3),d2
         move.l    d6,d3
         st        d1
         moveq     #0,d0
         sub.l     a0,a0
         bsr       _Gerflor

         moveq     #0,d2
         move.b    (a3),d2
         move.l    d7,d3
         st        d1
         moveq     #0,d0
         sub.l     a0,a0
         bsr       _Gerflor

         moveq     #0,d2
         move.b    (a3),d2
         move.l    a4,d3
         st        d1
         moveq     #0,d0
         sub.l     a0,a0
         bsr       _Gerflor

         moveq     #0,d2
         move.b    (a3),d2
         move.l    a1,d3
         st        d1
         moveq     #0,d0
         sub.l     a0,a0
         bsr       _Gerflor

         add.l     pf_Width(a5),a3
         add.l     #LineSize*TileHeight,d5
         add.l     #LineSize*TileHeight,d6
         add.l     #LineSize*TileHeight,d7
         lea       LineSize*TileHeight(a4),a4
         lea       LineSize*TileHeight(a1),a1

         cmp.l     pf_LMBmOffset(a5),d5
         bcs.s     .LDontWrap

         move.l    pf_LWBmOffset(a5),d5
         move.l    d5,d6
         add.l     (a2),d6
         move.l    d5,d7
         add.l     4(a2),d7
         move.l    d5,a4
         add.l     8(a2),a4
         move.l    d5,a1
         add.l     12(a2),a1

.LDontWrap:

         dbf       d4,.LeftLoop
         move.l    d5,pf_LBmOffset(a5)
         move.l    a3,pf_LMapAddr(a5)
         bra.s     .Ni

.DrwRight:
         move.w    pf_RightCount(a5),d4
         ble.s     .Ni
         ext.l     d4
         divu      d0,d4
         move.l    d4,d0
         swap      d0
         tst.w     d0
         bne.s     .RRoundUp
         subq.w    #1,d4
.RRoundUp:
         sub.w     d4,pf_RightCount(a5)
         sub.w     #1,pf_RightCount(a5)

         move.l    pf_RBmOffset(a5),d5
         move.l    d5,d6
         lea       pf_Bitmaps(a5),a2
         add.l     (a2),d6
         move.l    d5,d7
         add.l     4(a2),d7
         move.l    d5,a4
         add.l     8(a2),a4
         move.l    d5,a1
         add.l     12(a2),a1
         move.l    pf_RMapAddr(a5),a3

.RightLoop:
         moveq     #0,d2
         move.b    (a3),d2
         move.l    d6,d3
         st        d1
         moveq     #0,d0
         sub.l     a0,a0
         bsr       _Gerflor

         moveq     #0,d2
         move.b    (a3),d2
         move.l    d7,d3
         st        d1
         moveq     #0,d0
         sub.l     a0,a0
         bsr       _Gerflor

         moveq     #0,d2
         move.b    (a3),d2
         move.l    a4,d3
         st        d1
         moveq     #0,d0
         sub.l     a0,a0
         bsr       _Gerflor

         moveq     #0,d2
         move.b    (a3),d2
         move.l    a1,d3
         st        d1
         moveq     #0,d0
         sub.l     a0,a0
         bsr       _Gerflor

         add.l     pf_Width(a5),a3
         add.l     #LineSize*TileHeight,d5
         add.l     #LineSize*TileHeight,d6
         add.l     #LineSize*TileHeight,d7
         lea       LineSize*TileHeight(a4),a4
         lea       LineSize*TileHeight(a1),a1

         cmp.l     pf_RMBmOffset(a5),d5
         bcs.s     .RDontWrap

         move.l    pf_RWBmOffset(a5),d5
         add.l     #BufferWidth-(TileWidth*2),d5
         move.l    d5,d6
         add.l     (a2),d6
         move.l    d5,d7
         add.l     4(a2),d7
         move.l    d5,a4
         add.l     8(a2),a4
         move.l    d5,a1
         add.l     12(a2),a1

.RDontWrap:

         dbf       d4,.RightLoop
         move.l    d5,pf_RBmOffset(a5)
         move.l    a3,pf_RMapAddr(a5)

.Ni:

         move.w    (a7)+,d0
         tst.b     pf_UpDownFlag(a5)
         bne.s     .DrwDown

         move.w    pf_UpCount(a5),d4
         ble.s     .EkiEkiEkiEkiEkiEkiTaPang
         ext.l     d4
         divu      d0,d4
         move.l    d4,d0
         swap      d0
         tst.w     d0
         bne.s     .URoundUp
         subq.w    #1,d4
.URoundUp:
         sub.w     d4,pf_UpCount(a5)
         sub.w     #1,pf_UpCount(a5)

         move.l    pf_UBmOffset(a5),d5
         move.l    d5,d6
         lea       pf_Bitmaps(a5),a2
         add.l     (a2),d6
         move.l    d5,d7
         add.l     4(a2),d7
         move.l    d5,a4
         add.l     8(a2),a4
         move.l    d5,a1
         add.l     12(a2),a1
         move.l    pf_UMapAddr(a5),a3

.UpLoop:
         moveq     #0,d2
         move.b    (a3),d2
         move.l    d6,d3
         st        d1
         moveq     #0,d0
         sub.l     a0,a0
         bsr       _Gerflor

         moveq     #0,d2
         move.b    (a3),d2
         move.l    d7,d3
         st        d1
         moveq     #0,d0
         sub.l     a0,a0
         bsr       _Gerflor

         moveq     #0,d2
         move.b    (a3),d2
         move.l    a4,d3
         st        d1
         moveq     #0,d0
         sub.l     a0,a0
         bsr       _Gerflor

         moveq     #0,d2
         move.b    (a3)+,d2
         move.l    a1,d3
         st        d1
         moveq     #0,d0
         sub.l     a0,a0
         bsr       _Gerflor

         addq.l    #2,d5
         addq.l    #2,d6
         addq.l    #2,d7
         addq.l    #2,a4
         addq.l    #2,a1
         dbf       d4,.UpLoop

         move.l    d5,pf_UBmOffset(a5)
         move.l    a3,pf_UMapAddr(a5)
         bra.s     .EkiEkiEkiEkiEkiEkiTaPang

.DrwDown:
         move.w    pf_DownCount(a5),d4
         ble       .EkiEkiEkiEkiEkiEkiTaPang
         ext.l     d4
         divu      d0,d4
         move.l    d4,d0
         swap      d0
         tst.w     d0
         bne.s     .DRoundUp
         subq.w    #1,d4
.DRoundUp:
         sub.w     d4,pf_DownCount(a5)
         sub.w     #1,pf_DownCount(a5)

         move.l    pf_DBmOffset(a5),d5
         move.l    d5,d6
         lea       pf_Bitmaps(a5),a2
         add.l     (a2),d6
         move.l    d5,d7
         add.l     4(a2),d7
         move.l    d5,a4
         add.l     8(a2),a4
         move.l    d5,a1
         add.l     12(a2),a1
         move.l    pf_DMapAddr(a5),a3

.DownLoop:
         moveq     #0,d2
         move.b    (a3),d2
         move.l    d6,d3
         st        d1
         moveq     #0,d0
         sub.l     a0,a0
         bsr       _Gerflor

         moveq     #0,d2
         move.b    (a3),d2
         move.l    d7,d3
         st        d1
         moveq     #0,d0
         sub.l     a0,a0
         bsr       _Gerflor

         moveq     #0,d2
         move.b    (a3),d2
         move.l    a4,d3
         st        d1
         moveq     #0,d0
         sub.l     a0,a0
         bsr       _Gerflor

         moveq     #0,d2
         move.b    (a3)+,d2
         move.l    a1,d3
         st        d1
         moveq     #0,d0
         sub.l     a0,a0
         bsr       _Gerflor

         addq.l    #2,d5
         addq.l    #2,d6
         addq.l    #2,d7
         addq.l    #2,a4
         addq.l    #2,a1
         dbf       d4,.DownLoop

         move.l    d5,pf_DBmOffset(a5)
         move.l    a3,pf_DMapAddr(a5)

.EkiEkiEkiEkiEkiEkiTaPang:

         rts
;fe

;fs "_Gerflor"





;_Gerflor:         ; d2=Tile Nb d1=Scrolling flag d3=Dest
         ;rts
         move.l    a4,-(a7)
         lea       _DTBlit(pc),a0
         bsr       _GetBlitNode
         move.l    a1,a0
         ;lsl.l     #TileSizeSh,d2
         mulu      #TileWidth*TileHeight*NbPlanes*2,d2
         add.l     pf_TilesBank(a5),d2
         move.l    d2,(a0)+
         move.l    d3,(a0)
         tst.b     d1
         beq.s     .NoScroll
         bsr       _AddBlitNode
         move.l    (a7)+,a4
         rts
.NoScroll:
         move.l    a1,d0
         sub.l     #12,d0
         move.l    d0,_LastPlayfieldBlit
         bsr       _AddBlitNode
         move.l    (a7)+,a4
         rts
_DTBlit:
         move.w    #$f,$dff180
         tst.b     d0
         bne.s     .Raaah

         move.l    #$09f00000,bltcon0(a6)
         move.l    #-1,bltafwm(a6)
         clr.w     bltamod(a6)
         move.w    #BufferWidth-2,bltdmod(a6)

.Raaah:
         move.l    (a0)+,bltapt(a6)
         move.l    (a0),bltdpt(a6)
         move.w    #16*NbPlanes*64+1,bltsize(a6)

         clr.w     $dff180
         cmp.l     #2,-8(a0)
         beq.s     .Gaa
         rts
.Gaa:
;         lea       _DBufHook,a0
         move.l    a0,_BlitHook
         rts
;fe
;fs "CPU _Gerflor"
_Gerflor:          ; d2=Tile Nb d3=Dest
         move.l    a1,-(a7)
         ;move.w    #$f0f,$dff180
         mulu      #TileWidth*TileHeight*NbPlanes*2,d2
         add.l     pf_TilesBank(a5),d2
         move.l    d2,a0
         move.l    d3,a1
         move.l    #BufferWidth,d1

         rept      64
         move.w    (a0)+,(a1)
         add.l     d1,a1
         endr

         ;clr.w     $dff180
         move.l    (a7)+,a1
         rts
;fe

;fs "_ChangeBuffers"
_ChangeBuffers:    ; a5=playfield
         movem.l   pf_DispOfst(a5),d0-2
         movem.l   d1-2,pf_DispOfst(a5)
         move.l    d0,pf_CpuWorkOfst(a5)
         rts
;fe
;fs "_RefreshBuffer"
_RefreshBuffer:    ; a5=playfield
         ;rts
         ;bsr       _CheckBlitLists
         move.l    pf_WorkOfst(a5),d0
         move.l    pf_RefreshTbls(a5,d0.l),a4
         move.l    a4,pf_RefreshPtrs(a5,d0.l)

.Loop:
         tst.l     2(a4)
         bmi.s     .Done

         lea       _ClrBlit(pc),a0
         lea       _ClrCPU(pc),a1
         move.l    a1,d1
         moveq     #1,d0
         bsr       _GetBlitNode
         move.l    a1,_LastPlayfieldBlit

         movem.l   (a4)+,d0-2
         movem.l   d0-2,(a1)
         move.w    (a4)+,12(a1)

         bsr       _AddCPUBlitNode

         bra.s     .Loop

.Done:
         ;bsr       _CheckBlitLists
         rts

_ClrBlit:
         ;bsr       _CheckBlitLists
         move.l    a0,-(a7)
         tst.b     d0
         bne.s     .Raaah

         move.l    #$09f00000,bltcon0(a6)
         moveq     #-1,d0
         move.l    d0,bltafwm(a6)

.Raaah:
         move.w    (a0)+,d0
         move.w    d0,bltamod(a6)
         move.w    d0,bltdmod(a6)

         move.l    (a0)+,bltapt(a6)
         move.l    (a0)+,bltdpt(a6)

         move.w    (a0)+,bltsizv(a6)
         move.w    (a0),bltsizh(a6)

         move.l    (a7)+,a0
         cmp.l     #2,-4(a0)
         beq.s     .Gaa
         ;bsr       _CheckBlitLists
         rts
.Gaa:
         lea       _CBufHook,a0
         move.l    a0,_BlitHook
         ;bsr       _CheckBlitLists
         rts

_ClrCPU:
         move.w    (a0)+,d0
         addq.w    #1,d0
         and.b     #$fc,d0

         move.l    (a0)+,d1
         and.b     #$fc,d1
         move.l    d1,a1

         move.l    (a0)+,d1
         and.b     #$fc,d1
         move.l    d1,a2

         move.w    (a0)+,d1
         subq.w    #1,d1

         move.w    (a0)+,d2
         addq.w    #1,d2
         lsr.w     #1,d2
         subq.w    #1,d2
         ;move.w    #$00f,$dff180

.YLoop:
         move.w    d2,d3

.XLoop:
         move.l    (a1)+,(a2)+
         ;clr.l     (a2)
         ;clr.l     (a2)+
         dbf       d3,.XLoop

         add.w     d0,a1
         add.w     d0,a2

         dbf       d1,.YLoop

         rts
;fe
;fs "_DrawSpriteList"
_DrawSpriteList:   ; a5=Playfield
         move.l    pf_Sprites(a5),a4
         move.l    a4,a3

.Loop:
         move.l    (a3),d0
         beq.s     .Done
         move.l    d0,a3
         bsr.s     _DrawSprite
         bra.s     .Loop

.Done:
         move.l    pf_WorkOfst(a5),d0
         move.l    pf_RefreshPtrs(a5,d0.l),a0
         moveq     #-1,d0
         move.l    d0,2(a0)
         rts
;fe
;fs "_DrawSprite"
_DrawSprite:       ; a3=Sprite a4=SpritesHeader a5=Playfield
         ;bsr       _CheckBlitLists
         movem.l   a3-4,-(a7)
         move.l    sh_PosOfst(a4),d0
         ;bchg      #4,d0
         move.l    sh_Playfield(a4),a0
         lea       sp_Pos(a3),a4
         add.l     d0,a4
         move.l    spp_Data(a4),a3

         movem.l   (a4),d6-7

         sub.l     spd_Hx(a3),d6
         sub.l     spd_Hy(a3),d7

         move.l    pf_X16(a0),d0
         subq.l    #4,d0
         lsl.l     #4,d0
         sub.l     d0,d6

         move.l    pf_Y16(a0),d0
         subq.l    #4,d0
         lsl.l     #4,d0
         sub.l     d0,d7

         cmp.l     #BufferWidth*8,d6
         bge.s     .OffScreen
         cmp.l     #BufferHeight,d7
         bge.s     .OffScreen

         move.l    d6,d0
         add.l     spd_Width(a3),d0
         bmi.s     .OffScreen

         move.l    d7,d1
         add.l     spd_Height(a3),d1
         subq.l    #1,d1
         bpl.s     .Ok

.OffScreen:
         ;bsr       _CheckBlitLists
         movem.l   (a7)+,a3-4
         rts

.Ok:
         ;link      a4,#-8
         ;movem.l   d7/a3,-(a7)

         move.l    pf_WrapPos(a5),d0

         cmp.l     d0,d7
         bcc.s     DS_Normal

         cmp.l     d0,d1
         bcc.s     DS_Splitted

DS_Normal:
         move.l    d7,-(a7)
         move.l    d6,d5
         and.l     #$f,d5
         move.l    d5,d4
         ror.w     #4,d5
         move.w    d5,d0
         swap      d5
         move.w    d0,d5
         or.l      #$0fca0000,d5

         lea       _DSBlit(pc),a0
         lea       _DSCPU(pc),a1
         move.l    a1,d1
         moveq     #1,d0
         bsr       _GetBlitNode
         move.l    a1,a0

         move.l    d4,(a0)+

         move.l    d5,(a0)+

         move.w    spd_WWidth+2(a3),d5
         addq.w    #1,d5

         movem.l   spd_Bitmap(a3),d3-4

         move.w    #BufferWidth,d1
         sub.w     d5,d1
         sub.w     d5,d1

         muls      #LineSize,d7
         move.l    d6,d0
         asr.l     #4,d0
         ;move.l    d0,-4(a4)
         add.l     d0,d7
         add.l     d0,d7

         add.l     pf_VBitmapOffset(a5),d7
         move.l    #BufferHeight*LineSize,d2
         cmp.l     d2,d7
         bcs.s     .Ok
         sub.l     d2,d7
.Ok:
         move.l    pf_X16(a5),d2
         add.l     d2,d2
         add.l     d2,d7

         moveq     #-2,d2

         tst.l     d6
         ;addq.l    #8,d6
         ;addq.l    #8,d6
         bpl.s     .LeftOk

         neg.l     d6
         lsr.l     #4,d6
         sub.l     d6,d5
         ;add.l     d6,-4(a4)
         add.l     d6,d6

         add.l     d6,d3
         add.l     d6,d4
         add.l     d6,d7

         add.l     d6,d2
         add.l     d6,d1

.LeftOk:

         add.l     spd_WWidth(a3),d0
         sub.l     #BufferWidth/2-TileWidth,d0
         bmi.s     .RightOk

         sub.l     d0,d5

         add.l     d0,d0
         add.l     d0,d2
         add.l     d0,d1

.RightOk:

         move.l    pf_WorkOfst(a5),d0
         move.l    pf_RefreshPtrs(a5,d0.l),a4

         move.w    d2,(a0)+
         move.w    d1,(a0)+

         move.w    d1,(a4)+

         move.w    spd_Height+2(a3),d2

         move.l    (a7)+,d6

         move.l    d6,d0
         add.l     #TileHeight,d0
         bpl.s     .UpOk

         neg.l     d0
         sub.l     d0,d2
         move.l    d0,d1
         mulu      spd_WWidth(a3),d0
         mulu      #NbPlanes*2,d0
         add.l     d0,d3
         add.l     d0,d4

         mulu      #LineSize,d1
         add.l     d1,d7

.UpOk:

         move.l    pf_ClearBuffer(a5),d0
         add.l     d7,d0
         move.l    d0,(a4)+

         move.l    pf_WorkOfst(a5),d0
         add.l     pf_Bitmaps(a5,d0.l),d7
         move.l    d7,(a4)+

         move.l    d4,(a0)+
         move.l    d3,(a0)+
         move.l    d7,(a0)+

         add.w     spd_Height(a3),d6
         sub.l     #BufferHeight-TileHeight,d6
         bmi.s     .DownOk

         sub.l     d6,d2

.DownOk:

         mulu      #NbPlanes,d2
         move.w    d2,(a0)+
         move.w    d5,(a0)

         movem.w   d2/d5,(a4)
         addq.l    #4,a4
         move.l    a4,pf_RefreshPtrs(a5,d0.l)

         move.l    a1,_LastPlayfieldBlit
         bsr       _AddCPUBlitNode

         movem.l   (a7)+,a3-4
         rts

DS_Splitted:
         move.l    d7,d2
         sub.l     d7,d0
         move.l    d0,d4

         move.l    d6,d5
         and.l     #$f,d5
         move.l    d5,d3
         ror.w     #4,d5
         move.w    d5,d0
         swap      d5
         move.w    d0,d5
         or.l      #$0fca0000,d5

         lea       _DSBlit(pc),a0
         lea       _DSCPU(pc),a1
         move.l    a1,d1
         moveq     #1,d0
         bsr       _GetBlitNode
         move.l    a1,-(a7)
         lea       _DSBlit(pc),a0
         lea       _DSCPU(pc),a1
         move.l    a1,d1
         moveq     #1,d0
         bsr       _GetBlitNode
         move.l    (a7),a0
         move.l    a1,-(a7)
         move.l    d4,-(a7)

         move.l    d3,(a0)+
         move.l    d3,(a1)+

         move.l    d5,(a0)+
         move.l    d5,(a1)+

         move.w    spd_WWidth+2(a3),d5
         addq.w    #1,d5

         movem.l   spd_Bitmap(a3),d3-4

         move.w    #BufferWidth,d1
         sub.w     d5,d1
         sub.w     d5,d1

         mulu      #LineSize,d7
         move.l    d6,d0
         asr.l     #4,d0
         add.l     d0,d7
         add.l     d0,d7
         move.l    d0,-(a7)
         move.l    d2,-(a7)

         add.l     pf_VBitmapOffset(a5),d7
         move.l    #BufferHeight*LineSize,d2
         cmp.l     d2,d7
         bcs.s     .Ok
         sub.l     d2,d7
.Ok:
         move.l    pf_X16(a5),d2
         add.l     d2,d7
         add.l     d2,d7
         add.l     d2,4(a7)

         moveq     #-2,d2

         ;addq.l    #8,d6
         ;addq.l    #8,d6
         tst.l     d6
         bpl.s     .LeftOk

         neg.l     d6
         lsr.l     #4,d6
         sub.l     d6,d5
         add.l     d6,d6

         add.l     d6,d3
         add.l     d6,d4
         add.l     d6,d7

         add.l     d6,d2
         add.l     d6,d1

.LeftOk:

         add.l     spd_WWidth(a3),d0
         sub.l     #BufferWidth/2-TileWidth,d0
         bmi.s     .RightOk

         sub.l     d0,d5

         add.l     d0,d0
         add.l     d0,d2
         add.l     d0,d1

.RightOk:

         move.l    pf_WorkOfst(a5),d0
         move.l    pf_RefreshPtrs(a5,d0.l),a4

         move.w    d2,(a0)+
         move.w    d1,(a0)+
         move.w    d2,(a1)+
         move.w    d1,(a1)+

         move.w    d1,14(a4)
         move.w    d1,(a4)+

         move.l    spd_Height(a3),d2
         ;move.l    d2,$8c00000
         move.l    (a7)+,d6

         move.l    d6,d0
         add.l     #TileHeight,d0
         bpl.s     .UpOk

         neg.l     d0
         sub.l     d0,d2
         move.l    d0,d1
         mulu      spd_WWidth+2(a3),d0
         mulu      #NbPlanes*2,d0
         add.l     d0,d3
         add.l     d0,d4

         mulu      #LineSize,d1
         add.l     d1,d7

.UpOk:
         move.l    pf_ClearBuffer(a5),d0
         add.l     d7,d0
         move.l    d0,14(a4)

         move.l    pf_WorkOfst(a5),d0
         lea       pf_Bitmaps(a5,d0.l),a2
         add.l     (a2),d7
         move.l    d7,18(a4)

         move.l    d4,(a0)+
         move.l    d3,(a0)+
         move.l    d7,(a0)+

         move.l    pf_ClearBuffer(a5),a6
         lea       pf_RefreshPtrs(a5,d0.l),a5

         movem.l   (a7)+,d0-1
         add.l     d0,d0

         add.l     d0,a6
         move.l    a6,(a4)+
         lea       CustomBase,a6

         add.l     (a2),d0
         move.l    d0,(a4)+

         mulu      #NbPlanes,d1
         move.l    d1,d7
         mulu      spd_WWidth+2(a3),d1

         add.l     d1,d1
         add.l     d1,d3
         add.l     d1,d4

         move.l    d4,(a1)+
         move.l    d3,(a1)+
         move.l    d0,(a1)+

         move.l    d6,$8c00000

         add.w     spd_Height(a3),d6
         sub.l     #BufferHeight-TileHeight,d6
         bmi.s     .DownOk

         sub.l     d6,d2

.DownOk:
         mulu      #NbPlanes,d2
         move.l    a1,a2
         move.l    (a7)+,a1

         clr.w     (a4)

         sub.l     d7,d2
         bgt.s     .SecPartOk

         ;move.l    d7,$8c00000

         bsr       _CancelBlit
         bra.s     .DoFirstPart

.SecPartOk:
         move.w    d2,(a2)+
         move.w    d5,(a2)

         movem.w   d2/d5,(a4)

         bsr       _PreAddCPUBlitNode

.DoFirstPart:
         move.l    (a7)+,a1
         move.w    d7,(a0)+
         move.w    d5,(a0)

         move.w    d7,14(a4)
         move.w    d5,16(a4)
         lea       18(a4),a4
         move.l    a4,(a5)

         move.l    a1,_LastPlayfieldBlit
         bsr       _AddCPUBlitNode

         ;movem.l   (a7)+,d4/a3
         movem.l   (a7)+,a3-4
         rts

_DSBlit:
         ;bsr       _CheckBlitLists
         ;rts
         ;move.w    #$f80,$dff180
         move.l    a0,-(a7)
         addq.l    #4,a0
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

         move.l    (a7)+,a0
         cmp.l     #2,-4(a0)
         beq.s     .Gaa
         ;bsr       _CheckBlitLists
         rts
.Gaa:

         ;move.w    $dff006,d0
         ;and.w     #$ff0,d0
         ;move.w    d0,$dff180
         ;btst      #6,$dff016
         ;bne.s     .Gaa
.guuu:
         ;btst      #6,$dff016
         ;beq.s     .guuu

         lea       _CBufHook,a0
         move.l    a0,_BlitHook
         ;bsr       _CheckBlitLists
         rts

_DSCPU:
         ;rts
         move.l    (a0),d3
         addq.l    #8,a0

         movem.w   (a0)+,d6-7
         addq.w    #1,d6
         and.b     #$fc,d6
         addq.w    #1,d7
         and.b     #$fc,d7
         move.w    d6,a4
         move.w    d7,a5

         movem.l   (a0)+,d5-7

         btst      #1,d7
         beq.s     .ShiftOk
         add.w     #16,d3
.ShiftOk:

         and.b     #$fc,d5
         and.b     #$fc,d6
         and.b     #$fc,d7

         move.w    (a0)+,a6
         move.w    (a0),d2
         addq.l    #1,d2
         lsr.w     #1,d2
         subq.l    #1,d2
         move.w    d2,a0

         move.l    d6,a1
         move.l    d5,a2
         move.l    d7,a3

.Beuah:
         move.l    a0,d2
         moveq     #0,d6
         moveq     #0,d7

.Gleurp:
         move.l    (a1)+,d0

         moveq     #-1,d4
         lsr.l     d3,d4

         ror.l     d3,d0
         move.l    d0,d5
         and.l     d4,d0
         eor.l     d0,d5
         or.l      d6,d0
         move.l    d5,d6

         tst.w     d2
         bne.s     .LwOk
         moveq     #0,d1
         addq.l    #4,a2
         bra.s     .LwMsk
.LwOk:

         move.l    (a2)+,d1

         ror.l     d3,d1
         move.l    d1,d5
         and.l     d4,d1
         eor.l     d1,d5

.LwMsk:
         or.l      d7,d1
         move.l    d5,d7

         move.l    (a3),d4
         and.l     d1,d0
         ;not.l     d1
         and.l     d1,d4
         or.l      d0,d4

         move.l    d1,(a3)+

         dbf       d2,.Gleurp

         add.l     a4,a1
         add.l     a4,a2
         add.l     a5,a3

         subq.l    #1,a6
         move.l    a6,d2
         bne.s     .Beuah

         rts
;fe
@


0.18
log
@Des modifs pour le scroll parallaxe
@
text
@d6 1
a6 1
* $Id: Playfield.s 0.17 1997/09/07 11:27:18 MORB Exp MORB $
d24 1
a24 1
         sub.w     #288*4,d0
d296 1
d319 2
a320 2
         movem.l   pf_HShift(a5),d3/d6-7
         move.l    pf_LastY(a5),d5
@


0.17
log
@Sha
@
text
@d6 1
a6 1
* $Id: Playfield.s 0.16 1997/09/06 22:55:34 MORB Exp MORB $
d76 2
a77 1
         move.w    d1,Wrap
a117 4
         move.w    d7,d1
         mulu      #NbHorTile,d1
         move.l    d1,pf_RMapOffset(a5)

a191 2
;fs "_Scrolling"
_Scrolling:        ; a5=Playfield structure
d193 2
d210 1
d228 1
d251 2
a252 13
         move.w    d1,Wrap

         bsr       _MergeCopperLists

**** Obsolete - MergeCopperLists s'occupe de tout ****
;         cmp.w     #$100,d1
;         bcs.s     .Gna
;         move.l    #$ffe1fffe,Wrap2
;         bra.s     .Couin
;.Gna:
;         move.l    #$01800000,Wrap2
;.Couin:

d270 1
a270 1
         lea       BpPtrs+2,a0
d283 1
a283 1
         lea       WBpPtrs+2,a0
d295 1
a295 1
         move.l    d2,d3
d309 11
a319 3
         move.w    d0,d2
         lsr.w     #4,d2
         or.w      d2,d0
a320 1
         move.w    d0,_BplCon1
a379 4
         move.w    d0,d1
         mulu      #NbHorTile,d1
         move.l    d1,pf_RMapOffset(a5)

d810 1
a872 1
         moveq     #4-1,d0
d874 1
a874 2
.Loop:
         rept      20
d878 1
a878 1
         dbf       d0,.Loop
d894 1
a894 1
         bsr       _CheckBlitLists
d919 1
a919 1
         bsr       _CheckBlitLists
d923 1
a923 1
         bsr       _CheckBlitLists
d946 1
a946 1
         bsr       _CheckBlitLists
d951 1
a951 1
         bsr       _CheckBlitLists
d1058 1
a1058 1
         movem.l   d7/a3,-(a7)
d1210 2
a1211 1
         bra.s     DS_UpdateRefreshMap
d1422 1
a1422 4
DS_UpdateRefreshMap:
         ;bsr       _CheckBlitLists
         movem.l   (a7)+,d4/a3
         ;unlk      a4
a1425 102
         move.l    pf_WorkRefreshMap(a5),d7
         add.l     pf_RMapOffset(a5),d7
         ;move.l    pf_OWorkBitmap(a5),a1
         move.l    a1,a2
         add.l     pf_WBitmapOffset(a5),a2
         move.l    a1,d1
         add.l     pf_BitmapOffset(a5),a1
         moveq     #0,d5
         add.l     pf_MaxBmOffset(a5),d1

         move.l    -8(a4),d2
         subq.w    #1,d2
         move.l    -4(a4),d3
         add.l     d3,d7
         add.l     d3,d3
         add.l     d3,a1
         add.l     d3,a2

         move.l    spd_Height(a3),d0

         tst.l     d4
         bpl.s     .UpOk
         moveq     #0,d4
.UpOk:

         add.l     d4,d0
         lsr.l     #4,d0
         addx.l    d5,d0
         lsr.l     #4,d4
         move.l    d4,d6
         sub.l     d4,d0

         moveq     #NbVerTile-1,d3
         cmp.l     d0,d3
         bcc.s     .DownOk
         move.l    d3,d0
.DownOk:

         move.l    d4,d3
         move.l    pf_BufY16(a5),d3
         add.l     d3,d4
         cmp.l     #NbVerTile,d4
         bcs.s     .JaiFaimJaiFaimJaiFaimJaiFaimJaiFaim
         sub.l     #NbVerTile,d4
.JaiFaimJaiFaimJaiFaimJaiFaimJaiFaim:
         sub.l     d3,d4
         muls      #NbHorTile,d4
         add.l     d4,d7
         muls      #2*TileHeight*NbPlanes,d4
         add.l     d4,a1

         move.l    -4(a4),d5
         unlk      a4
         add.l     pf_X16(a5),d5
         subq.l    #4,d5
         move.l    pf_Map(a5),a4
         add.l     d5,a4

         add.l     pf_Y16(a5),d6
         subq.l    #4,d6
         mulu      pf_Width+2(a5),d6
         add.l     d6,a4

         move.l    pf_RefreshTblPtr(a5),a6

.EuhhhSimonOnPeutSeTutoyer:
         move.w    d2,d3
         move.l    d7,a0
         movem.l   a1/a4,-(a7)

.Ouais:
         tst.b     (a0)
         bne.s     .TesLourd

         st        (a0)
         move.l    a0,(a6)+
         move.l    a4,(a6)+
         move.l    a1,(a6)+

.TesLourd:

         addq.l    #1,a0
         addq.l    #1,a4
         addq.l    #TileWidth*2,a1

         dbf       d3,.Ouais

         movem.l   (a7)+,a1/a4
         add.l     #NbHorTile,d7
         add.l     pf_Width(a5),a4
         add.l     #LineSize*TileHeight,a1

         cmp.l     d1,a1
         bcs.s     .OuaisMaisJaiFaimQuandMeme
         move.l    a2,a1
.OuaisMaisJaiFaimQuandMeme:

         dbf       d0,.EuhhhSimonOnPeutSeTutoyer

         move.l    a6,pf_RefreshTblPtr(a5)
         movem.l   (a7)+,a3-4
         rts
d1427 1
a1427 1
         bsr       _CheckBlitLists
d1453 1
a1453 1
         bsr       _CheckBlitLists
d1468 1
a1468 1
         bsr       _CheckBlitLists
@


0.16
log
@Correctu petit bug dans DrawSprite(). Sans vouloir me montrer pesant.
@
text
@d6 1
a6 1
* $Id: Playfield.s 0.15 1997/09/06 19:15:36 MORB Exp MORB $
d875 1
a875 1
         move.w    #$f0f,$dff180
d889 1
a889 1
         clr.w     $dff180
d984 1
a984 1
         move.w    #$00f,$dff180
d1543 1
a1543 1
         move.w    #$f80,$dff180
@


0.15
log
@Nimplémentu et débuggu triple-buffer etc. et correctu un bug de clippage de lutin eugnpfouharg sprite voulais-je dire.
@
text
@d6 1
a6 1
* $Id: Playfield.s 0.14 1997/09/03 12:30:45 MORB Exp MORB $
d1287 3
a1289 2
         addq.l    #8,d6
         addq.l    #8,d6
d1330 1
a1330 1

d1387 2
d1404 2
@


0.14
log
@Réimplémentation de l'effacement des sprites
@
text
@d6 1
a6 1
* $Id: Playfield.s 0.13 1997/09/03 00:34:30 MORB Exp MORB $
d844 1
a844 1
         move.l    d0,_LastMainCodeBlit
d868 1
a868 1
         lea       _DBufHook,a0
d894 7
d902 1
a902 1
_RefreshBuffer:     ; a5=playfield
d904 4
a907 3
         move.l    pf_DispOfst(a5),d0
         move.l    pf_RefreshTbls(a5),a4
         move.l    a4,pf_RefreshPtrs(a5)
d916 1
a916 1
         moveq     #0,d0
d918 1
d922 1
a922 1
         move.w    (a4),12(a1)
a925 1
         addq.l    #2,a4
d929 1
d933 2
d952 10
d984 1
d991 2
d1015 4
d1023 1
d1062 1
d1128 3
a1130 2
         addq.l    #8,d6
         addq.l    #8,d6
d1160 1
a1160 1
         move.l    pf_DispOfst(a5),d0
d1193 1
a1193 1
         move.l    pf_DispOfst(a5),d0
d1217 1
a1217 3
         move.l    a1,d0
         sub.l     #12,d0
         move.l    d0,_LastMainCodeBlit
d1317 1
a1317 1
         move.l    pf_DispOfst(a5),d0
d1352 1
a1352 1
         move.l    pf_DispOfst(a5),d0
d1423 1
a1423 1
         move.l    a1,_LastMainCodeBlit
d1427 1
d1536 1
d1562 1
d1565 11
a1575 1
         lea       _DBufHook,a0
d1577 1
d1653 1
a1653 1
         not.l     d1
d1657 1
a1657 1
         move.l    d4,(a3)+
@


0.13
log
@DrawTile() s'appelle désormais Gerflor() et n'utilise plus le blitter. Scrolling() est donc plus rapide. Aussi ajout des trucs dans DrawSpr
@
text
@d6 1
a6 1
* $Id: Playfield.s 0.12 1997/09/02 12:44:59 MORB Exp MORB $
d521 2
d550 8
d563 1
d575 2
d607 2
d636 8
d649 1
d662 2
d698 2
d720 8
d729 1
a729 1
         move.l    a4,d3
d739 1
d768 2
d790 8
d799 1
a799 1
         move.l    a4,d3
d809 1
d874 1
d890 1
d897 4
a900 1
         move.l    pf_DispRefreshTbl(a5),a4
d902 1
a902 1
         move.l    (a4)+,d0
d905 9
a913 2
         move.l    d0,a0
         sf        (a0)
d915 1
a915 8
         sub.l     a0,a0
         moveq     #1,d0
         move.l    (a4)+,a1
         moveq     #0,d2
         move.b    (a1),d2
         move.l    (a4)+,d3
         sf        d1
         bsr.s     _Gerflor
d917 1
d919 1
d922 55
d1506 1
@


0.12
log
@Adaptation de DrawSprite() aux nouvelles nouvelles routines blitter (utilisation du CPU ou du blitter)
@
text
@a0 1

d6 1
a6 1
* $Id: Playfield.s 0.11 1997/08/31 17:36:58 MORB Exp MORB $
d157 1
a157 1
         bsr.s     _DrawTile
d530 1
a530 1
         bsr       _DrawTile
d538 1
a538 1
         bsr       _DrawTile
d546 1
a546 1
         bsr       _DrawTile
d603 1
a603 1
         bsr       _DrawTile
d611 1
a611 1
         bsr       _DrawTile
d619 1
a619 1
         bsr       _DrawTile
d681 1
a681 1
         bsr       _DrawTile
d689 1
a689 1
         bsr       _DrawTile
d697 1
a697 1
         bsr       _DrawTile
d740 1
a740 1
         bsr       _DrawTile
d748 1
a748 1
         bsr       _DrawTile
d756 1
a756 1
         bsr       _DrawTile
d771 1
a771 1
;fs "_DrawTile"
d777 1
a777 1
;_DrawTile:         ; d2=Tile Nb d1=Scrolling flag d3=Dest
d824 2
a825 2
;fs "CPU _DrawTile"
_DrawTile:         ; d2=Tile Nb d3=Dest
d844 2
a845 2
;fs "_RefreshTiles"
_RefreshTiles:     ; a5=playfield
d862 1
a862 1
         bsr.s     _DrawTile
a985 4
         move.l    pf_DispOfst(a5),d2
         lea       pf_Bitmaps(a5,d2.l),a4
         add.l     (a4),d7

d1019 3
d1025 2
d1048 8
d1071 4
a1074 1
         ;move.l    d5,-8(a4)
a1145 4
         move.l    pf_DispOfst(a5),d2
         lea       pf_Bitmaps(a5,d2.l),a4
         add.l     (a4),d7

d1178 3
d1186 3
d1209 8
d1222 3
d1227 8
a1234 1
         add.l     (a4),d0
d1238 1
d1242 1
d1257 3
d1270 2
d1278 5
@


0.11
log
@Adaptation de DrawTile() aux nouvelles routines blitter. Scrolling() s'éxécute désormais à une vitesse décente...
@
text
@d1 1
d7 1
a7 1
* $Id: Playfield.s 0.10 1997/08/30 23:06:34 MORB Exp MORB $
d102 2
a103 4
         add.l     pf_ODispBitmap(a5),d0
         move.l    d0,pf_CDispBitmap(a5)
         add.l     pf_OWorkBitmap(a5),d1
         move.l    d1,pf_CWorkBitmap(a5)
d134 2
a135 1
         move.l    pf_ODispBitmap(a5),d3
d138 1
a138 1
         add.l     pf_ODispBitmap(a5),d4
a143 2
         rts

d167 1
a167 1
         add.l     pf_ODispBitmap(a5),d3
d172 2
d182 2
a183 2
         move.l    pf_ODispBitmap(a5),(a0)+
         move.l    pf_OWorkBitmap(a5),(a0)
d234 1
a234 1
**** ¡”$“®“® ¡©¡ |“$ ™“$™$ ’“ ’“—|ª©“‡“”™$ |¡‡¡™“$
a276 5
         move.l    d0,d1
         add.l     pf_ODispBitmap(a5),d0
         move.l    d0,pf_CDispBitmap(a5)
         add.l     pf_OWorkBitmap(a5),d1
         move.l    d1,pf_CWorkBitmap(a5)
d278 5
a282 1
         move.l    d0,d1
d295 1
a295 2
         move.l    pf_ODispBitmap(a5),d0
         add.l     d3,d0
d299 2
a300 2
         swap      d0
         move.w    d0,(a0)
d302 2
a303 2
         swap      d0
         move.w    d0,(a0)
d305 1
a305 1
         add.l     #BufferWidth,d0
d513 1
d516 2
a517 1
         add.l     pf_ODispBitmap(a5),d6
d519 3
a521 1
         add.l     pf_OWorkBitmap(a5),d7
d523 1
a524 1
         ;rept      2
a531 1
         ;endr
d540 9
d553 1
d557 1
d560 1
a560 1
         add.l     pf_ODispBitmap(a5),d6
d562 4
a565 1
         add.l     pf_OWorkBitmap(a5),d7
d586 1
d589 2
a590 1
         add.l     pf_ODispBitmap(a5),d6
d592 3
a594 1
         add.l     pf_OWorkBitmap(a5),d7
d596 1
a597 1
         ;rept      2
d605 1
a605 1
         ;endr
d613 9
d626 1
d630 1
d634 1
a634 1
         add.l     pf_ODispBitmap(a5),d6
d636 4
a639 1
         add.l     pf_OWorkBitmap(a5),d7
d664 1
d667 2
a668 1
         add.l     pf_ODispBitmap(a5),d6
d670 3
a672 1
         add.l     pf_OWorkBitmap(a5),d7
d674 1
a675 1
         ;rept      2
d682 10
a691 2
         bsr.s     _DrawTile
         ;endr
d694 1
a694 1
         move.l    d7,d3
d698 2
a699 1
         bsr.s     _DrawTile
d703 1
d705 1
d712 1
a712 1
         ble.s     .EkiEkiEkiEkiEkiEkiTaPang
d723 1
d726 2
a727 1
         add.l     pf_ODispBitmap(a5),d6
d729 3
a731 1
         add.l     pf_OWorkBitmap(a5),d7
d733 1
a734 1
         ;rept      2
d741 10
a750 2
         bsr.s     _DrawTile
         ;endr
d753 1
a753 1
         move.l    d7,d3
d757 2
a758 1
         bsr.s     _DrawTile
d762 1
d764 1
d773 6
a778 1
_DrawTile:         ; d2=Tile Nb d1=Scrolling flag d3=Dest
d795 3
a797 1
         move.l    a1,_LastMainCodeBlit
d802 1
d815 27
d847 1
d928 1
a928 1
         link      a4,#-8
d943 1
d950 3
a952 1
         sub.l     a0,a0
d957 2
a959 3
         moveq     #-1,d0
         not.w     d0
         move.l    d0,(a0)+
d973 1
a973 1
         move.l    d0,-4(a4)
d987 3
a989 1
         add.l     pf_OWorkBitmap(a5),d7
d1000 1
a1000 1
         add.l     d6,-4(a4)
d1024 2
a1025 5
         lea       24(a0),a2
         move.w    d1,(a2)+
         move.w    d2,(a2)+
         move.w    d2,(a2)+
         move.w    d1,(a2)
d1048 2
a1050 3
         move.l    d3,(a0)+
         move.l    d4,(a0)+
         move.l    d7,(a0)
a1060 1
         addq.l    #8,a0
d1063 1
a1063 1
         move.l    d5,-8(a4)
d1065 4
a1068 2
         move.l    a1,_LastMainCodeBlit
         bsr       _AddBlitNode
d1079 1
d1086 3
a1088 1
         sub.l     a0,a0
d1092 3
a1094 1
         sub.l     a0,a0
d1101 3
a1105 4
         moveq     #-1,d0
         not.w     d0
         move.l    d0,(a0)+
         move.l    d0,(a1)+
a1118 1
         move.l    d0,-4(a4)
d1135 3
a1137 1
         add.l     pf_OWorkBitmap(a5),d7
a1147 1
         add.l     d6,-4(a4)
d1171 4
a1174 10
         lea       24(a0),a2
         move.w    d1,(a2)+
         move.w    d2,(a2)+
         move.w    d2,(a2)+
         move.w    d1,(a2)
         lea       24(a1),a2
         move.w    d1,(a2)+
         move.w    d2,(a2)+
         move.w    d2,(a2)+
         move.w    d1,(a2)
d1197 2
a1199 3
         move.l    d3,(a0)+
         move.l    d4,(a0)+
         move.l    d7,(a0)
d1203 1
a1203 2
         add.l     pf_OWorkBitmap(a5),d0
         move.l    d0,(a1)+
d1210 1
d1212 1
a1212 2
         move.l    d4,(a1)+
         move.l    d0,(a1)
a1220 1
         move.l    a0,a3
a1224 1
         ;beq.s     .Baaah
a1226 1
.Baaah:
a1230 1
         addq.l    #8,a2
d1234 1
a1234 1
         bsr       _PreAddBlitNode
d1238 2
a1239 4
         addq.l    #8,a3
         move.w    d7,(a3)+
         move.w    d5,(a3)
         move.l    d5,-8(a4)
d1242 1
a1242 1
         bsr       _AddBlitNode
d1246 3
d1252 1
a1252 1
         move.l    pf_OWorkBitmap(a5),a1
d1351 121
@


0.10
log
@Correction d'un bug dans DrawSprite()
@
text
@d6 1
a6 1
* $Id: Playfield.s 0.9 1997/08/30 19:03:10 MORB Exp MORB $
d144 1
a144 1
         ;rts
d522 1
d530 2
d578 1
d586 1
d638 1
d646 1
d682 1
d690 1
d713 1
a715 4
         move.l    #$09f00000,(a0)+
         moveq     #-1,d0
         move.l    d0,(a0)+
         addq.l    #8,a0
a720 5
         lea       16(a0),a4
         addq.l    #8,a0
         move.l    #BufferWidth-2,(a4)
         move.w    #16*NbPlanes,(a0)+
         move.w    #1,(a0)
d731 14
d747 2
a748 2
;fs "_RefreshBuffer"
_RefreshBuffer:    ; a5=playfield
d770 15
d787 1
d789 1
d800 1
a800 1
         move.l    pf_X16(a5),d0
d805 1
a805 1
         move.l    pf_Y16(a5),d0
d825 1
d1257 1
@


0.9
log
@Modifica
@
text
@d6 1
a6 1
* $Id: Playfield.s 0.8 1997/08/30 11:40:01 MORB Exp MORB $
d748 1
d789 1
d1097 1
d1100 1
@


0.8
log
@La mise à jour de la
@
text
@d6 1
a6 1
* $Id: Playfield.s 0.7 1997/08/29 18:00:30 MORB Exp MORB $
d187 2
a188 2
         move.w    #BufferHeight*NbPlanes,(a0)+
         move.w    #BufferWidth/2,(a0)+
d720 7
a726 6
         ;tst.b     d1
         ;beq.s     .NoScroll
         ;bsr       _AddBlitNodeHead
         ;move.l    (a7)+,a4
         ;rts
;.NoScroll:
d743 1
a743 1
         moveq     #0,d0
d816 1
a816 1
         moveq     #0,d0
d851 1
a851 1
         add.l     pf_ODispBitmap(a5),d7
d932 1
a937 6

         ;move.w    #$f00,$dff180
         ;btst      #7,$bfe001
         ;bne.s     DS_Splitted
         ;rts

d951 1
a951 1
         moveq     #0,d0
d955 1
a955 1
         moveq     #0,d0
d997 1
a997 1
         add.l     pf_ODispBitmap(a5),d7
d1071 1
a1071 1
         add.l     pf_ODispBitmap(a5),d0
d1114 1
d1120 1
a1120 1
         move.l    pf_DispRefreshMap(a5),d7
d1122 1
a1122 1
         move.l    pf_ODispBitmap(a5),a1
d1183 1
a1183 1
         move.l    pf_DispRTblPtr(a5),a6
d1219 1
a1219 1
         move.l    a6,pf_DispRTblPtr(a5)
@


0.7
log
@MergeCopperLists() est maintenant appelée le plus tôt possible par Scrolling()
@
text
@d6 1
a6 1
* $Id: Playfield.s 0.6 1997/08/28 21:32:28 MORB Exp MORB $
d793 2
a794 1
         movem.l   d6-7/a3,-(a7)
d836 1
d861 1
d929 1
d984 1
d1012 1
d1116 1
d1121 1
a1121 2
         movem.l   (a7)+,d3-4/a3
         ;rts
d1133 3
a1135 6
         move.l    spd_Width(a3),d2
         add.l     d3,d2
         lsr.l     #4,d2
         addx.l    d5,d2
         lsr.l     #4,d3
         sub.l     d3,d2
d1142 6
d1152 1
d1154 7
d1164 1
a1164 1
         cmp.l     #NbVerTile,d3
d1174 4
a1177 1
         movem.l   spp_X(a4),d5-6
d1180 4
a1183 2
         move.l    pf_Width(a5),d4
         mulu      d4,d6
d1189 1
a1189 1
         move.l    d2,d3
@


0.6
log
@Correction vaseuse d'un problème avec le blitter et DrawTile
@
text
@d6 1
a6 1
* $Id: Playfield.s 0.5 1997/08/28 18:53:24 MORB Exp MORB $
d255 1
d703 1
a703 1
         movem.l   d0-7/a0-6,-(a7)
d727 1
a727 1
         movem.l   (a7)+,d0-7/a0-6
@


0.5
log
@Correction d'un bug de positionnement de sprites
@
text
@d6 1
a6 1
* $Id: Playfield.s 0.4 1997/08/27 21:29:49 MORB Exp MORB $
d702 1
a702 1
         move.l    a4,-(a7)
d726 1
a726 1
         move.l    (a7)+,a4
a758 1
         move.l    a3,-(a7)
a788 1
         addq.l    #4,a7
d792 2
d1113 2
a1114 2
         move.l    (a7)+,a3
         rts
a1126 1
         move.l    spp_X(a4),d3
d1138 1
a1138 2
         move.l    spp_Y(a4),d3
         add.l     d3,d0
d1141 5
a1145 5
         lsr.l     #4,d3
         sub.l     d3,d0
         move.l    d3,d4
         move.l    pf_BufY16(a5),d4
         add.l     d4,d3
d1148 1
a1148 1
         sub.l     #NbVerTile,d3
d1150 5
a1154 5
         sub.l     d4,d3
         muls      #NbHorTile,d3
         add.l     d3,d7
         muls      #2*TileHeight*NbPlanes,d3
         add.l     d3,a1
@


0.5.1.1
log
@MergeCopperLists() est maintenant appelée le plus tôt possible par Scrolling()
@
text
@d6 1
a6 1
* $Id: Playfield.s 0.5 1997/08/28 18:53:24 MORB Exp MORB $
a144 1
         ;lea       CustomBase,a6
d191 1
a254 1
         bsr       _MergeCopperLists
d1114 1
a1114 1
         ;rts
@


0.4
log
@Correction du placement des sprites (relatif au coin hg de la map) et correction de quelques bugs de clippage
@
text
@d6 1
a6 1
* $Id: Playfield.s 0.3 1997/08/23 01:20:08 MORB Exp MORB $
d767 1
d772 1
@


0.3
log
@Utilisation de PreAddBlitNode() dans DrawSprite()
@
text
@d6 1
a6 1
* $Id: Playfield.s 0.2 1997/08/22 18:36:16 MORB Exp MORB $
d755 1
d761 31
d793 2
a794 2
         move.l    spp_Y(a4),d1
         cmp.l     d0,d1
d796 1
a796 1
         add.l     spd_Height(a3),d1
d799 1
d801 1
a801 1
         movem.l   (a4),d6-7
d825 2
a826 1
         move.w    #BufferWidth/2,d1
a827 1
         add.w     d1,d1
d829 1
a829 1
         mulu      #LineSize,d7
d831 1
a831 1
         lsr.l     #4,d0
d863 1
a863 1
         sub.l     d6,d1
d875 1
a875 1
         sub.l     d0,d1
d887 1
a887 1
         move.w    spp_Y(a4),d6
d935 2
a936 1
         sub.l     spp_Y(a4),d0
a938 1
         movem.l   (a4),d6-7
d970 2
a971 1
         move.w    #BufferWidth/2,d1
a972 1
         add.w     d1,d1
d976 1
a976 1
         lsr.l     #4,d0
d980 1
d991 1
a991 1
         add.l     d2,(a7)
d1011 1
a1011 1
         sub.l     d6,d1
d1023 1
a1023 1
         sub.l     d0,d1
d1040 1
a1040 1
         move.w    spp_Y(a4),d6
a1110 1
         ;rts
d1112 2
@


0.2
log
@Changement RCS ($Id)
@
text
@d6 1
a6 1
* $Id$
d1066 1
a1066 1
         bsr       _AddBlitNode
@


0.1
log
@Devinez
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
