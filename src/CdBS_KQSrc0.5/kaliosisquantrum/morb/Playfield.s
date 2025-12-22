*
* CdBSian Obviously Universal & Interactive Nonsense (COUIN)
* (Absurdité CdBSienne Manifestement Universelle et Interactive)
* ©1997-1998, CdBS Software (MORB)
* Scrolling, sprites & double-buffer
* $Id: Playfield.s 0.19 1997/09/09 00:12:21 MORB Exp MORB $
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
	 move.l    pf_WPosPtr(a5),a1
	 move.w    d1,(a1)


**** Obsolete - MergeCopperLists s'occupe de tout ****
;         cmp.w     #$100,d1
;         bcs.s     .Gna
;         move.l    #$ffe1fffe,Wrap2
;         bra.s     .Couin
;.Gna:
;         move.l    #$01800000,Wrap2
;.Couin:

	 ;bsr       _HardwareScrolling

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

	 ;rts
	 move.l    pf_Bitmaps(a5),d3
	 add.l     d7,d3
	 move.l    d6,d4
	 add.l     pf_Bitmaps(a5),d4
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
	 add.l     pf_Bitmaps(a5),d3
.Gloups:

	 dbf       d7,.YLoop


	 lea       pf_Bitmaps(a5),a4
	 move.l    (a4)+,a0
	 move.l    (a4)+,a1
	 move.l    (a4)+,a2
	 move.l    (a4)+,a3
	 move.l    #BufferSize/4,d0
.CpyLoop:
	 move.l    (a0)+,d1
	 move.l    d1,(a1)+
	 move.l    d1,(a2)+
	 move.l    d1,(a3)+
	 subq.l    #1,d0
	 bne.s     .CpyLoop

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

	 ;move.l    d2,pf_HShift(a5)
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
