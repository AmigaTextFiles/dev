*
* CdBSian Obviously Universal & Interactive Nonsense (COUIN)
* (Absurdité CdBSienne Manifestement Universelle et Interactive)
* ©1997-1998, CdBS Software (MORB)
* Map Editor
* $Id: MapEditor.s 0.1 1997/09/14 22:00:05 MORB Exp MORB $
*

;fs "_MapEditor"
_MapEditor:
	 move.l    _CurrentGui,MapEdLastGui

	 lea       _SMedClrHandler(pc),a0
	 move.l    a0,_PreHandler
	 lea       _SMedHandler(pc),a0
	 move.l    a0,_PlayfieldClickHandler

	 lea       MapEdGui(pc),a0
	 bra       _ChangeGui

ExitMapEd:
	 clr.l     _PlayfieldClickHandler

	 move.l    MapEdLastGui(pc),a0
	 bra       _ChangeGui

MapEdLastGui:
	 ds.l      1

MapEdGui:
	 GENTRY    _VGroup,0,0

	 GENTRY    _HGroup,0,0
	 GENTRY    _SmallButton,"X",ExitMapEd
	 GENTRY    _SmallButton,"I",_Iconify
	 GENTRY    _DragBar,MapEdTitle,0
	 GEND

	 GENTRY    _HGroup,0,0
	 GENTRY    _Button,MELIffBk,_NYI
	 GENTRY    _Button,MELIffBr,_NYI
	 GEND

	 GENTRY    _HGroup,0,0
	 GENTRY    _Button,MEShBk,_NYI
	 GENTRY    _Button,MEShBr,_NYI
	 GEND

	 GENTRY    _Selector,0,0
	 GENTRY    _GerflorBank,0,0
	 GEND

	 GEND

MapEdTitle:
	 dc.b      "COUIN's Map Editor",0
MELIffBk:
	 dc.b      "Load IFF Gerflor bank",0
MELIffBr:
	 dc.b      "Load IFF Brush",0
MEShBk:
	 dc.b      "Show Gerflor bank",0
MEShBr:
	 dc.b      "Show Gerflor Brushes",0
	 even
;fe
;fs "_SMedHandler"
SMHLastOffset:
	 ds.l      1
SMHLastMapAddr:
	 ds.l      1

_SMedClrHandler:
	 lea       Plf1,a5

	 movem.l   SMHLastOffset(pc),d6/a0
	 move.l    a0,d0
	 beq.s     .Schneurfleugleup

	 moveq     #0,d7
	 move.b    (a0),d7

	 lea       pf_Bitmaps(a5),a4

	 move.l    (a4)+,d3
	 add.l     d6,d3
	 move.l    d7,d2
	 bsr       _Gerflor
	 move.l    (a4)+,d3
	 add.l     d6,d3
	 move.l    d7,d2
	 bsr       _Gerflor
	 move.l    (a4)+,d3
	 add.l     d6,d3
	 move.l    d7,d2
	 bsr       _Gerflor
	 move.l    (a4)+,d3
	 add.l     d6,d3
	 move.l    d7,d2
	 bsr       _Gerflor

.Schneurfleugleup:
	 rts

_SMedHandler:
	 lea       Plf1,a5

	 add.l     d0,d0
	 add.l     pf_X(a5),d0
	 lsr.l     #6,d0

	 add.l     pf_Y(a5),d1
	 lsr.l     #4,d1

	 move.l    pf_Width(a5),d7
	 mulu      d1,d7
	 add.l     d0,d7
	 add.l     pf_Map(a5),d7

	 sub.l     pf_Y16(a5),d1
	 add.l     pf_BufY16(a5),d1
	 addq.l    #4,d1
	 mulu      #LineSize*TileHeight,d1

	 move.l    #BufferHeight*LineSize,d2
	 cmp.l     d2,d1
	 bcs.s     .Ok
	 sub.l     d2,d1
.Ok:

	 addq.l    #4,d0
	 add.l     d0,d0
	 add.l     d0,d1

	 move.l    d1,SMHLastOffset
	 move.l    d7,SMHLastMapAddr
	 move.l    d1,d6

	 tst.b     _LMBState
	 beq.s     .DontGlueGerflor

	 move.l    d7,a0
	 move.b    #$a,(a0)
	 clr.l     SMHLastMapAddr

.DontGlueGerflor:
	 lea       pf_Bitmaps(a5),a4

	 move.l    (a4)+,d3
	 add.l     d6,d3
	 moveq     #$a,d2
	 bsr       _Gerflor
	 move.l    (a4)+,d3
	 add.l     d6,d3
	 moveq     #$a,d2
	 bsr       _Gerflor
	 move.l    (a4)+,d3
	 add.l     d6,d3
	 moveq     #$a,d2
	 bsr       _Gerflor
	 move.l    (a4)+,d3
	 add.l     d6,d3
	 moveq     #$a,d2
	 bsr       _Gerflor
	 rts
;fe

;fs "_GerflorBank"
_GerflorBank:
	 dc.l      GBGetMinMax
	 dc.l      0
	 dc.l      GBRender
	 dc.l      0         ; GBClick

GBGetMinMax:
	 move.l    #GuiScreenWidth/2,d0
	 move.l    d0,ge_MinWidth(a0)
	 move.l    d0,ge_MaxWidth(a0)

	 move.l    #256,d0
	 move.l    d0,ge_MinHeight(a0)
	 move.l    d0,ge_MaxHeight(a0)

	 lea       ge_Size(a0),a1
	 move.l    a1,ge_Next(a0)
	 rts

GBRender:
	 move.l    #54,d0
	 moveq     #0,d5
	 moveq     #0,d7

	 moveq     #15-1,d1
.YLoop:
	 moveq     #8,d6
	 moveq     #17-1,d2

.XLoop:
	 bsr       _SelGerflor
	 addq.l    #1,d5
	 add.l     #17,d6
	 subq.l    #1,d0
	 dbeq      d2,.XLoop

	 add.l     #17,d7

	 tst.l     d0
	 dbeq      d1,.YLoop
	 rts
;fe
;fs "_SelGerflor"
_CurrentGerflorBank:
	 dc.l      Plf1Tiles

_SelGerflor:       ; d6/d7=X,Y d5=Gerflor
	 movem.l   d0-1/d5-7/a0-1,-(a7)
	 mulu      #TileWidth*TileHeight*NbPlanes*2,d5
	 add.l     _CurrentGerflorBank(pc),d5
	 move.l    d5,a0

	 mulu      #GuiSelLineSize,d7
	 move.l    d6,d0
	 lsr.l     #4,d0
	 add.l     d0,d7
	 add.l     d0,d7

	 and.l     #$f,d6

	 move.l    _GuiSelBitmap,a1
	 add.l     d7,a1

	 move.l    #GuiSelBufferWidth,d7

	 moveq     #TileHeight*NbPlanes-1,d0
.Loop:
	 move.w    (a0)+,d1
	 swap      d1
	 clr.w     d1
	 lsr.l     d6,d1
	 or.l      d1,(a1)
	 add.l     d7,a1
	 dbf       d0,.Loop
	 movem.l   (a7)+,d0-1/d5-7/a0-1
	 rts
;fe
