*
* CdBSian Obviously Universal & Interactive Nonsense (COUIN)
* (Absurdité CdBSienne Manifestement Universelle et Interactive)
* ©1997-1998, CdBS Software (MORB)
* Chip datas
* $Id: ChipDats.s 0.7 1997/09/11 12:56:12 MORB Exp MORB $
*

	 section   gna,data_c

;fs "Game Copper lists"
WrapDat:
	 ds.l      2+1
	 comove    $20,bplcon3
Wcol1:
	 ;cocol     $500,0
	 conop
WBpPtrs:
	 ds.l      2*NbPlanes
	 comove    0,copjmp2

WrapDat2:
	 ds.l      2+1
	 comove    $20,bplcon3
	 ;cocol     $005,0
Wcol2:
	 conop
WBpPtrs2:
	 ds.l      2*NbPlanes
	 comove    0,copjmp2

cl11dat:
	 conop
	 conop
	 cocol     $f00,0
	 conop
	 conop
	 conop

	 conop
	 cowait    $38,$2a
	 cocol     $f0,0
	 conop
	 conop
	 conop

	 conop
	 cowait    $38,$2b
	 cocol     $f,0
	 conop
	 conop
	 conop

	 conop
	 cowait    $38,$2c
	 cocol     $f00,0
	 conop
	 conop
	 conop

	 conop
	 cowait    $38,$2d
	 cocol     $f0,0
	 conop
	 conop
	 conop

	 conop
	 cowait    $38,$2e
	 cocol     $f,0
	 conop
	 conop
	 conop

	 conop
	 cowait    $38,$2f
	 cocol     0,0
	 conop
	 conop
	 conop

	 conop
	 cowait    $38,$30
	 conop
	 conop
	 conop
	 conop

	 coend

cl21dat:
	 ds.l      2

	 cocol     $ff0,0

	 comove    0,copjmp2


CopperList:
	 dc.w      bplcon0
_GameBplCon0:
	 dc.w      $0611

	 ;comove    $5201,bplcon0       ; $0211
	 comove    $1020,bplcon3
	 comove    9,bplcon2
	 comove    $23,bplcon4

	 comove    0,diwhigh
	 comove    $2991,diwstrt       ; Left 16 pixels R.I.P
	 comove    $29c1,diwstop

	 comove    $30,ddfstrt
	 comove    $c8,ddfstop

	 comove    Modulo,bpl1mod
	 comove    Modulo,bpl2mod

	 comove    $c|1,fmode

	;dc.w    $0180,$000,$0182,$0f2,$0184,$0c1,$0186,$081,$0188,$050
	;dc.w    $018a,$020,$018c,$ddd,$018e,$bbb,$0190,$888,$0192,$666
	;dc.w    $0194,$444,$0196,$f00,$0198,$c00,$019a,$a00,$019c,$700
	;dc.w    $019e,$000

	 incbin    "Test.pal"

	 cocol     $fff,0

	 comove    $3020,bplcon3
	 cocol     0,1
	 cocol     $fff,2
	 comove    $1020,bplcon3


	 ;include   "Blks.pal"

	 ;dc.w      $180
;cdbg:
	 ;dc.w      0

	 cowait    0,$10
GDwarvesPtrs:
	 ds.l      16

BpPtrs:
	 ds.l      2*NbPlanes
BpPtrs2:
	 ds.l      2*NbPlanes

	 dc.w      bplcon1
_BplCon1:
	 dc.w      0


	 ;dc.w      $4d01,$fffe
	 ;dc.w      $9c,$8010
	 ;dc.w      $180,$f0f

	 ;dc.w      $5081,$fffe

	 ;dc.w      $84,$0007
	 ;dc.w      $86,$0000
	 ;dc.w      $8a,$0000

	 ;cowait    0,$25
	 ;cocol     $f0,0
	 ;comove    $8010,intreq


GameNml:
	 ds.l      4

;Wrap2:
;         dc.w      $ffe1,$fffe
;
;Wrap:
;         dc.w      $4905,$fffe
;         dc.w      $180,$500
;WBpPtrs:
;         ds.l      2*NbPlanes

	 coend

CL_Pal:
	 ds.b      2112
	 coend
;fe
;fs "Gui Copper lists"
_GuiCList:
	 conop
	 conop
	 ds.l      1

	 comove    GuiModulo,bpl1mod
	 comove    GuiModulo,bpl2mod
	 comove    $38,ddfstrt
	 comove    $c8,ddfstop
	 comove    $2991,diwstrt
	 comove    $29c1,diwstop
	 comove    $a201,bplcon0
	 comove    $4400,bplcon1
	 comove    $20,bplcon3
	 comove    $c|3,fmode
_GuiBpPtrs:
	 ds.l      4

	 cocol     $aaa,0
	 cocol     0,1
	 cocol     $fff,2
	 cocol     $f00,3

GuiSprPtrs:
	 ;ds.l      16

	 comove    0,spr+8+sd_ctl
	 comove    0,spr+16+sd_ctl
	 comove    0,spr+24+sd_ctl
	 comove    0,spr+32+sd_ctl
	 comove    0,spr+40+sd_ctl
	 comove    0,spr+48+sd_ctl

	 comove    0,spr+8+sd_pos
	 comove    0,spr+16+sd_pos
	 comove    0,spr+24+sd_pos
	 comove    0,spr+32+sd_pos
	 comove    0,spr+40+sd_pos
	 comove    0,spr+48+sd_pos

GuiNml:
	 ds.l      5

_GuiSelCList:
	 conop
	 conop
	 ds.l      1

	 comove    GuiSelModulo,bpl1mod
	 comove    GuiSelModulo,bpl2mod
	 comove    $40,ddfstrt
	 comove    $b8,ddfstop
	 comove    $2991,diwstrt
	 comove    $29c1,diwstop
	 comove    $4201,bplcon0
	 comove    $4400,bplcon1
	 comove    $c|3,fmode

_GuiSelBpPtrs:
	 ds.l      2*NbPlanes

	 ;include   "blks.pal"
	 incbin    "Test.pal"


GuiSelNml:
	 ds.l      5

;fe

	 cnop      0,8
_EmptyGardenDwarf:
	 ds.l      2*4
_StdMouseGardenDwarfDat:
	 incbin    "MousePointer.bin"

_EDMouseGardenDwarfDat:
	 incbin    "EDMousePointer.bin"
_HKMouseGardenDwarfDat:
	 incbin    "HKMousePointer.bin"
_VKMouseGardenDwarfDat:
	 incbin    "VKMousePointer.bin"

_BackDats:
	 incbin    "Back.bin"
_BackDats1:
	 incbin    "Back1.bin"
_BackDats2:
	 incbin    "Back2.bin"
_BackDats3:
	 incbin    "Back3.bin"

TestSprBm:
	 ds.b      4*33*4
TestSprMsk:
	 dcb.b     4*33*4,$ff

TestSpr2Bm:
	 incbin    "TestSpr2.bin"
TestSpr2Msk:
	 incbin    "TestSpr2.msk"

	 section   gni,data

Plf1Tiles:
	 incbin    "Plf1Tiles.bin"

Plf2Tiles:
	 incbin    "Plf2Tiles.bin"
	 even
