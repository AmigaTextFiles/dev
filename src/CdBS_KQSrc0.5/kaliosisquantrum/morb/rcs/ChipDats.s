head	0.7;
access;
symbols;
locks
	MORB:0.7; strict;
comment	@# @;


0.7
date	97.09.11.12.56.12;	author MORB;	state Exp;
branches;
next	0.6;

0.6
date	97.09.09.00.08.36;	author MORB;	state Exp;
branches;
next	0.5;

0.5
date	97.08.26.15.17.59;	author MORB;	state Exp;
branches;
next	0.4;

0.4
date	97.08.25.12.28.20;	author MORB;	state Exp;
branches;
next	0.3;

0.3
date	97.08.23.01.32.13;	author MORB;	state Exp;
branches;
next	0.2;

0.2
date	97.08.22.18.30.22;	author MORB;	state Exp;
branches;
next	0.1;

0.1
date	97.08.22.15.20.37;	author MORB;	state Exp;
branches;
next	0.0;

0.0
date	97.08.22.15.00.27;	author MORB;	state Exp;
branches;
next	;


desc
@Jeu à la beast avec des scrolls partout
RCS for GoldED · Initial login date: Aujourd'hui
@


0.7
log
@Déplaçu truc sprites pour arrêter scrolling fond bugger. Grûnt.
@
text
@*
* CdBSian Obviously Universal & Interactive Nonsense (COUIN)
* (Absurdité CdBSienne Manifestement Universelle et Interactive)
* ©1997, CdBS Software (MORB)
* Chip datas
* $Id: ChipDats.s 0.6 1997/09/09 00:08:36 MORB Exp MORB $
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

         include   "blks.pal"

GuiSelNml:
         ds.l      5

;fe

         cnop      0,8
_EmptyGardenDwarf:
         ds.l      2*4
_MouseGardenDwarfDat:
         incbin    "MousePointer.bin"

_BackDats:
         incbin    "Back.bin"
_BackDats1:
         incbin    "Back1.bin"
_BackDats2:
         incbin    "Back2.bin"
_BackDats3:
         incbin    "Back3.bin"

TestSprBm:
         incbin    "TestSpr.bin"

TestSprMsk:
         incbin    "TestSpr.msk"
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
@


0.6
log
@Modifications diverses de copperlists pour intégrer tous les plans et gratter 16 pixels à gauche :)))))
@
text
@d6 1
a6 1
* $Id: ChipDats.s 0.5 1997/08/26 15:17:59 MORB Exp MORB $
d109 1
d142 2
a143 1
SprPtrs:
a145 1
         cowait    0,$10
d213 17
d247 1
d259 1
a259 1
_EmptySprite:
d261 1
a261 1
_MouseSpriteDat:
d266 6
@


0.5
log
@Ajout de la copperliste du sélécteur, et corrections de deux trois trucs
@
text
@d6 1
a6 1
* $Id: ChipDats.s 0.4 1997/08/25 12:28:20 MORB Exp MORB $
d14 4
a17 2
         cocol     $500,0
         ;conop
d22 10
d102 1
a102 1
         dc.w      $5201
d105 3
a107 1
         comove    $20,bplcon3
d109 1
a109 1
         comove    $29a1,diwstrt       ; Left 32 pixels R.I.P
d112 2
a113 2
         comove    $38,ddfstrt
         comove    $c0,ddfstop
d125 11
a135 1
         include   "blks.pal"
d147 2
d196 3
a198 3
         comove    $48,ddfstrt
         comove    $c0,ddfstop
         comove    $29a1,diwstrt
d201 2
a202 1
         comove    0,bplcon1
a211 3
         cocol     0,17
         cocol     $fff,18

d224 1
a224 1
         comove    $29a1,diwstrt
d226 2
a227 2
         comove    $5201,bplcon0
         comove    $8800,bplcon1
d245 3
d253 10
d264 2
a265 2
TestTiles:
         incbin    "blks.bin"
@


0.4
log
@Améliorations et corrections diverses de copperlistes
@
text
@d6 1
a6 1
* $Id: ChipDats.s 0.3 1997/08/23 01:32:13 MORB Exp MORB $
d14 2
a15 1
         ;cocol     $500,0
d88 5
a92 1
         comove    $5201,bplcon0       ; $0211
d99 1
a99 1
         comove    $c8,ddfstop
a162 15
bgcdat:
         ds.l      3
         comove    $a201,bplcon0
         comove    0,bplcon1
         comove    GuiModulo,bpl1mod
         comove    GuiModulo,bpl2mod
         comove    $48,ddfstrt
         comove    $c8,ddfstop
         comove    $29a1,diwstrt
         comove    $29c1,diwstop
;_GuiBpPtrs:
         ds.l      4
         cocol     $aaa,0
         comove    0,copjmp2

d171 1
a171 1
         comove    $c8,ddfstop
d189 23
a211 1
         ds.l      4
d214 1
@


0.3
log
@Réduction de la largeur de la gui de 32 pixels
@
text
@d6 1
a6 1
* $Id: ChipDats.s 0.2 1997/08/22 18:30:22 MORB Exp MORB $
d14 1
a14 1
         cocol     $500,0
d87 1
a87 1
         comove    $5200,bplcon0       ; $0211
d99 1
a99 1
         comove    1,fmode
d112 4
a115 1
         cowait    4,$10
d159 11
a169 2
         ds.l      2
         comove    DMAF_SETCLR|DMAF_RASTER,dmacon
d174 4
a177 4
         comove    DMAF_RASTER,dmacon
         comove    3,fmode
         comove    $a201,bplcon0
         comove    0,bplcon1
d184 3
a186 1

d190 1
a190 1
         cocol     0,0
d195 3
d202 5
@


0.2
log
@Changement RCS ($Id)
@
text
@d6 1
a6 1
* $Id$
d168 1
a168 1
         comove    $38,ddfstrt
d170 1
a170 1
         comove    $2981,diwstrt
@


0.1
log
@Première version truc
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
