*
* CdBSian Obviously Universal & Interactive Nonsense (COUIN)
* (Absurdité CdBSienne Manifestement Universelle et Interactive)
* ©1997-1998, CdBS Software (MORB)
* Bitmap auto cropping routines
* $Id: AutoCrop.s 0.4 1997/09/14 17:09:24 MORB Exp MORB $
*

;fs "_ACScanBitmap"
_ACScanBitmap:     ; a0=Bitmap d0=Width d1=Height
	 moveq     #0,d3
	 move.l    d0,d2
	 lsr.l     #4,d2
	 addx.l    d3,d2
	 move.l    d2,-(a7)
	 mulu      #NbPlanes,d2
	 move.l    d2,d7
	 subq.l    #1,d2

.TopScan:
	 move.l    d2,d3
	 move.l    a0,a2

.TopScanLine:
	 tst.w     (a2)+
	 dbne      d3,.TopScanLine

	 tst.w     -2(a2)
	 bne.s     .TopScanDone

	 move.l    a2,a0
	 subq.l    #1,d1
	 beq.s     .EmptyBitmap

	 bra.s     .TopScan

.TopScanDone:

	 move.l    d7,d3
	 mulu      d1,d3
	 lea       (a0,d3.l*2),a2

	 move.l    d7,d2
	 subq.l    #1,d2

.BottomScan:
	 move.l    d2,d3
	 move.l    a2,a3

.BottomScanLine:
	 tst.w     -(a3)
	 dbne      d3,.BottomScanLine

	 tst.w     (a3)
	 bne.s     .BottomScanDone

	 move.l    a3,a2
	 subq.l    #1,d1
	 bra.s     .BottomScan

.BottomScanDone:

	 move.l    a0,a2
	 move.l    (a7)+,d2
	 move.l    d2,d7
	 add.l     d7,d7
	 moveq     #0,d5
	 moveq     #0,d6

.LeftScan:
	 move.l    d1,d3
	 mulu      #NbPlanes,d3
	 subq.l    #1,d3
	 move.l    a2,a3

.LeftScanColumn:
	 or.w      (a3),d5
	 add.l     d7,a3
	 dbf       d3,.LeftScanColumn

	 tst.w     d5
	 bne.s     .LeftScanDone

	 addq.l    #2,a2
	 subq.l    #1,d2
	 bra.s     .LeftScan

.LeftScanDone:

	 bfffo     d5{16:16},d5
	 sub.l     #16,d5
	 move.l    a2,a0

	 lea       -2(a0,d2.l*2),a2
	 moveq     #0,d4

.RightScan:
	 move.l    d1,d3
	 mulu      #NbPlanes,d3
	 subq.l    #1,d3
	 move.l    a2,a3
	 sub.l     d7,a3

.RightScanColumn:
	 add.l     d7,a3
	 or.w      (a3),d4
	 dbf       d3,.RightScanColumn

	 tst.w     d4
	 bne.s     .RightScanDone

	 subq.l    #2,a2
	 subq.l    #1,d2
	 bra.s     .RightScan

.RightScanDone:

	 movem.l   d1-2/d5/d7/a0,_ACHeight
	 moveq     #-1,d0

.CountRightBits:
	 addq.l    #1,d0
	 lsr.w     #1,d4
	 bcc.s     .CountRightBits
	 move.l    d0,_ACRightBits

	 moveq     #-1,d0
	 rts

.EmptyBitmap:
	 moveq     #0,d0
	 rts
;fe
;fs "_ACCut"
_ACHeight:
	 ds.l      1
_ACWidth:
	 ds.l      1
_ACShift:
	 ds.l      1
_ACTotWidth:
	 ds.l      1
_ACBitmap:
	 ds.l      1
_ACDestModulo:
	 ds.l      1
_ACRightBits:
	 ds.l      1
_ACCut:  ; a0=Dest. bitmap
	 movem.l   _ACHeight,d0-3/a1-2

	 ;not.w     d2
	 ;addq.l    #1,d2
	 ;and.w     #$f,d2

	 ;tst.b     d2
	 ;beq.s     .Glorpf
	 ;subq.l    #2,a0
	 ;subq.l    #2,a2
.Glorpf:

	 mulu      #NbPlanes,d0
	 subq.l    #1,d0
	 sub.l     d1,d3
	 sub.l     d1,d3
	 subq.l    #2,d3
	 subq.l    #1,d1

	 moveq     #-1,d7
	 lsr.w     d2,d7

.YLoop:
	 move.l    d0,a3

	 move.l    d1,d4
	 move.w    (a1)+,d5

.XLoop:
	 swap      d5
	 move.w    (a1)+,d5
	 move.l    d5,d6
	 lsl.l     d2,d6
	 swap      d6
	 move.w    d6,(a0)+
	 dbf       d4,.XLoop

	 add.l     d3,a1
	 add.l     a2,a0
	 move.l    a3,d0
	 dbf       d0,.YLoop
	 rts
;fe
