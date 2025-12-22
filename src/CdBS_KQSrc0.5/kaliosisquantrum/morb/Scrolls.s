*
* CdBSian Obviously Universal & Interactive Nonsense (COUIN)
* (Absurdité CdBSienne Manifestement Universelle et Interactive)
* ©1997-1998, CdBS Software (MORB)
* Various scrolling & floor-mapping routines
* $Id: Scrolls.s 0.1 1997/09/10 22:26:12 MORB Exp MORB $
*

_BackGroundScroll: ; d0=Xpos
	 move.l    _BGDwarfSize,d7

	 lea       _BGTbl(pc),a3
	 move.l    d0,d1
	 and.l     #$c0,d1
	 lsr.l     #4,d1
	 move.l    (a3,d1.l),a3

	 move.l    d0,d1
	 lsr.l     #8,d1
	 divs      #5,d1
	 swap      d1

	 lea       _GDwarfTable+2<<2,a1
	 moveq     #5,d2
	 sub.w     d1,d2

	 mulu      d7,d1
	 lea       (a3,d1.l),a2
	 lea       BGDwarves,a0

	 moveq     #63,d3
	 sub.l     d0,d3
	 move.l    d3,d0
	 ;not.l     d0
	 ;addq.l    #1,d0
	 and.l     #$3f,d0
	 sub.l     #64,d0

	 moveq     #5-1,d3
.Loop:
	 move.l    a2,(a1)+
	 move.l    a2,(a0)
	 move.w    d0,gdw_X(a0)
	 move.w    #32,gdw_Y(a0)
	 bsr       _RefreshGardenDwarf
	 add.l     d7,a2
	 lea       gdw_Size(a0),a0
	 add.l     #64<<2,d0

	 subq.l    #1,d2
	 bne.s     .Ouîk
	 move.l    a3,a2
.Ouîk:

	 dbf       d3,.Loop

	 bsr       _LoadGardenDwarvesPtrs
	 rts

_BGDwarfSize:
	 dc.l      (2+122)<<4
_BGTbl:
	 dc.l      _BackDats,_BackDats1,_BackDats2,_BackDats3
