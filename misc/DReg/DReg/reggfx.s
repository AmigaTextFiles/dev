
                even

****************************************************************************

                section     brdrdata,DATA

****************************************************************************
*
*           The coordinates data


Bitacoor:       dc.w    0,8, 0,0, 8,0
Bitbcoor:       dc.w    1,1, 1,7, 0,8, 8,8, 8,1
Bitccoor:       dc.w    2,1, 2,7
Bitxcoor:       dc.w    9,0, 9,8

Backcoor:       dc.w    2,1, 80,1, 80,7, 2,7, 2,2, 79,2, 79,6, 3,6, 3,3
                dc.w    78,3, 78,5, 4,5, 4,4, 77,4
Decacoor:       dc.w    0,7, 0,0, 1,1, 1,0, 80,0
Decbcoor:       dc.w    1,2, 1,7, 0,8, 81,8, 81,0

OSacoor:        dc.w    0,0, 0,8, 1,7, 1,0, 16,0
OSbcoor:        dc.w    1,8, 16,8, 16,0, 15,1, 15,7

RSacoor:        dc.w    0,0, 0,8, 1,7, 1,0, 15,0
RSbcoor:        dc.w    1,8, 15,8, 15,0, 14,1, 14,7

Opacoor:        dc.w    0,2, 0,6, 1,7, 1,1, 2,1, 2,0, 28,0, 29,1
Opbcoor:        dc.w    2,7, 2,8, 29,8, 29,7, 30,7, 30,1, 31,6, 31,2, 29,0
Opccoor:        dc.w    3,8, 2,8, 2,7, 1,7, 1,2, 0,6, 0,2, 1,1, 2,1, 2,0
                dc.w    29,0, 29,1
Opdcoor:        dc.w    4,8, 29,8, 29,7, 30,7, 30,1, 31,2, 31,6

*Icfcoor:        dc.w    14,1, 20,1, 20,2, 14,2
*Icecoor:        dc.w    4,4, 4,8, 20,8, 20,4, 4,4
*Icdcoor:        dc.w    23,0, 23,9
*Icbcoor:        dc.w    1,0, 1,9
*Icacoor:        dc.w    0,0, 0,9
                even

****************************************************************************

                section     brdrtext,DATA

****************************************************************************
*
*           The window, hex, flags and decimal displays' borders
*                                               - 79 struct, add 16


BordrHexpx:     dc.w    73,0                bd_LeftEdge, bd_TopEdge
                dc.b    0,0                 bd_FrontPen, bd_BackPen
                dc.b    RP_JAM1             bd_DrawMode
                dc.b    2                   bd_Count
                dc.l    Bitccoor            bd_XY
                dc.l    0                   bd_NextBorder

BordrHexp:      dc.w    73,0
                dc.b    3,0
                dc.b    RP_JAM1
                dc.b    5
                dc.l    Bitbcoor
                dc.l    BordrHexpx

BordrHexo:      dc.w    73,0
                dc.b    1,0
                dc.b    RP_JAM1
                dc.b    3
                dc.l    Bitacoor
                dc.l    BordrHexp

BordrHexny:     dc.w    63,0
                dc.b    2,0
                dc.b    RP_JAM1
                dc.b    2
                dc.l    Bitxcoor
                dc.l    BordrHexo

BordrHexnx:     dc.w    63,0
                dc.b    0,0
                dc.b    RP_JAM1
                dc.b    2
                dc.l    Bitccoor
                dc.l    BordrHexny

BordrHexn:      dc.w    63,0
                dc.b    3,0
                dc.b    RP_JAM1
                dc.b    5
                dc.l    Bitbcoor
                dc.l    BordrHexnx

BordrHexm:      dc.w    63,0
                dc.b    1,0
                dc.b    RP_JAM1
                dc.b    3
                dc.l    Bitacoor
                dc.l    BordrHexn

BordrHexly:     dc.w    53,0
                dc.b    2,0
                dc.b    RP_JAM1
                dc.b    2
                dc.l    Bitxcoor
                dc.l    BordrHexm

BordrHexlx:     dc.w    53,0
                dc.b    0,0
                dc.b    RP_JAM1
                dc.b    2
                dc.l    Bitccoor
                dc.l    BordrHexly

BordrHexl:      dc.w    53,0
                dc.b    3,0
                dc.b    RP_JAM1
                dc.b    5
                dc.l    Bitbcoor
                dc.l    BordrHexlx
* 10

BordrHexk:      dc.w    53,0
                dc.b    1,0
                dc.b    RP_JAM1
                dc.b    3
                dc.l    Bitacoor
                dc.l    BordrHexl

BordrHexjy:     dc.w    43,0
                dc.b    2,0
                dc.b    RP_JAM1
                dc.b    2
                dc.l    Bitxcoor
                dc.l    BordrHexk

BordrHexjx:     dc.w    43,0
                dc.b    0,0
                dc.b    RP_JAM1
                dc.b    2
                dc.l    Bitccoor
                dc.l    BordrHexjy

BordrHexj:      dc.w    43,0
                dc.b    3,0
                dc.b    RP_JAM1
                dc.b    5
                dc.l    Bitbcoor
                dc.l    BordrHexjx

BordrHexi:      dc.w    43,0
                dc.b    1,0
                dc.b    RP_JAM1
                dc.b    3
                dc.l    Bitacoor
                dc.l    BordrHexj

*           half a longword

BordrHexhw:     dc.w    33,0
                dc.b    2,0
                dc.b    RP_JAM1
                dc.b    2
                dc.l    Bitxcoor
                dc.l    BordrHexi

BordrHexhv:     dc.w    32,0
                dc.b    2,0
                dc.b    RP_JAM1
                dc.b    2
                dc.l    Bitxcoor
                dc.l    BordrHexhw

BordrHexhz:     dc.w    31,0
                dc.b    2,0
                dc.b    RP_JAM1
                dc.b    2
                dc.l    Bitxcoor
                dc.l    BordrHexhv

BordrHexhy:     dc.w    30,0
                dc.b    2,0
                dc.b    RP_JAM1
                dc.b    2
                dc.l    Bitxcoor
                dc.l    BordrHexhz

BordrHexhx:     dc.w    30,0
                dc.b    0,0
                dc.b    RP_JAM1
                dc.b    2
                dc.l    Bitccoor
                dc.l    BordrHexhy
* 20

BordrHexh:      dc.w    30,0
                dc.b    3,0
                dc.b    RP_JAM1
                dc.b    5
                dc.l    Bitbcoor
                dc.l    BordrHexhx

BordrHexg:      dc.w    30,0
                dc.b    1,0
                dc.b    RP_JAM1
                dc.b    3
                dc.l    Bitacoor
                dc.l    BordrHexh

BordrHexfy:     dc.w    20,0
                dc.b    2,0
                dc.b    RP_JAM1
                dc.b    2
                dc.l    Bitxcoor
                dc.l    BordrHexg

BordrHexfx:     dc.w    20,0
                dc.b    0,0
                dc.b    RP_JAM1
                dc.b    2
                dc.l    Bitccoor
                dc.l    BordrHexfy

BordrHexf:      dc.w    20,0
                dc.b    3,0
                dc.b    RP_JAM1
                dc.b    5
                dc.l    Bitbcoor
                dc.l    BordrHexfx

BordrHexe:      dc.w    20,0
                dc.b    1,0
                dc.b    RP_JAM1
                dc.b    3
                dc.l    Bitacoor
                dc.l    BordrHexf

BordrHexdy:     dc.w    10,0
                dc.b    2,0
                dc.b    RP_JAM1
                dc.b    2
                dc.l    Bitxcoor
                dc.l    BordrHexe

BordrHexdx:     dc.w    10,0
                dc.b    0,0
                dc.b    RP_JAM1
                dc.b    2
                dc.l    Bitccoor
                dc.l    BordrHexdy

BordrHexd:      dc.w    10,0
                dc.b    3,0
                dc.b    RP_JAM1
                dc.b    5
                dc.l    Bitbcoor
                dc.l    BordrHexdx

BordrHexc:      dc.w    10,0
                dc.b    1,0
                dc.b    RP_JAM1
                dc.b    3
                dc.l    Bitacoor
                dc.l    BordrHexd
* 30

BordrHexby:     dc.w    0,0
                dc.b    2,0
                dc.b    RP_JAM1
                dc.b    2
                dc.l    Bitxcoor
                dc.l    BordrHexc

BordrHexbx:     dc.w    0,0
                dc.b    0,0
                dc.b    RP_JAM1
                dc.b    2
                dc.l    Bitccoor
                dc.l    BordrHexby

BordrHexb:      dc.w    0,0
                dc.b    3,0
                dc.b    RP_JAM1
                dc.b    5
                dc.l    Bitbcoor
                dc.l    BordrHexbx

BordrHexa:      dc.w    0,0
                dc.b    1,0
                dc.b    RP_JAM1
                dc.b    3
                dc.l    Bitacoor
                dc.l    BordrHexb


*           The Status Bits' borders


BordFilli:      dc.w    40,0
                dc.b    0,0
                dc.b    RP_JAM1
                dc.b    2
                dc.l    Bitccoor
                dc.l    0

BordFillg:      dc.w    30,0
                dc.b    0,0
                dc.b    RP_JAM1
                dc.b    2
                dc.l    Bitccoor
                dc.l    BordFilli

BordFille:      dc.w    20,0
                dc.b    0,0
                dc.b    RP_JAM1
                dc.b    2
                dc.l    Bitccoor
                dc.l    BordFillg

BordFillc:      dc.w    10,0
                dc.b    0,0
                dc.b    RP_JAM1
                dc.b    2
                dc.l    Bitccoor
                dc.l    BordFille

BordFilla:      dc.w    0,0
                dc.b    0,0
                dc.b    RP_JAM1
                dc.b    2
                dc.l    Bitccoor
                dc.l    BordFillc

BordrFlgj:      dc.w    40,0
                dc.b    3,0
                dc.b    RP_JAM1
                dc.b    5
                dc.l    Bitbcoor
                dc.l    BordFilla
* 40

BordrFlgi:      dc.w    40,0
                dc.b    1,0
                dc.b    RP_JAM1
                dc.b    3
                dc.l    Bitacoor
                dc.l    BordrFlgj

BordrFlgh:      dc.w    30,0
                dc.b    3,0
                dc.b    RP_JAM1
                dc.b    5
                dc.l    Bitbcoor
                dc.l    BordrFlgi

BordrFlgg:      dc.w    30,0
                dc.b    1,0
                dc.b    RP_JAM1
                dc.b    3
                dc.l    Bitacoor
                dc.l    BordrFlgh

BordrFlgf:      dc.w    20,0
                dc.b    3,0
                dc.b    RP_JAM1
                dc.b    5
                dc.l    Bitbcoor
                dc.l    BordrFlgg

BordrFlge:      dc.w    20,0
                dc.b    1,0
                dc.b    RP_JAM1
                dc.b    3
                dc.l    Bitacoor
                dc.l    BordrFlgf

BordrFlgd:      dc.w    10,0
                dc.b    3,0
                dc.b    RP_JAM1
                dc.b    5
                dc.l    Bitbcoor
                dc.l    BordrFlge

BordrFlgc:      dc.w    10,0
                dc.b    1,0
                dc.b    RP_JAM1
                dc.b    3
                dc.l    Bitacoor
                dc.l    BordrFlgd

BordrFlgb:      dc.w    0,0
                dc.b    3,0
                dc.b    RP_JAM1
                dc.b    5
                dc.l    Bitbcoor
                dc.l    BordrFlgc

BordrFlga:      dc.w    0,0
                dc.b    1,0
                dc.b    RP_JAM1
                dc.b    3
                dc.l    Bitacoor
                dc.l    BordrFlgb


*           The bit display borders


BordBit0c:      dc.w    0,0                 bd_LeftEdge, bd_TopEdge
                dc.b    0,0
                dc.b    RP_JAM1
                dc.b    2
                dc.l    Bitccoor
                dc.l    0
* 50

BordBit0b:      dc.w    0,0
                dc.b    3,0
                dc.b    RP_JAM1
                dc.b    5
                dc.l    Bitbcoor
                dc.l    BordBit0c

BordBit0a:      dc.w    0,0
                dc.b    1,0
                dc.b    RP_JAM1
                dc.b    3
                dc.l    Bitacoor
                dc.l    BordBit0b


*           The decimal display border


BordDecDb:      dc.w    0,0                 bd_LeftEdge, bd_TopEdge
                dc.b    3,0
                dc.b    RP_JAM1
                dc.b    5
                dc.l    Decbcoor
                dc.l    0

BordDecDa:      dc.w    0,0
                dc.b    1,0
                dc.b    RP_JAM1
                dc.b    5
                dc.l    Decacoor
                dc.l    BordDecDb

BordDBack:      dc.w    0,0
                dc.b    0,0
                dc.b    RP_JAM1
                dc.b    14
                dc.l    Backcoor
                dc.l    BordDecDa


*           Gadget Border structures


BordrOpSzd:     dc.w    0,0                 bd_LeftEdge, bd_TopEdge
                dc.b    1,0                 bd_FrontPen, bd_BackPen
                dc.b    RP_JAM1             bd_DrawMode
                dc.b    5                   bd_Count
                dc.l    OSbcoor             bd_XY
                dc.l    0                   bd_NextBorder

BordrOpSzc:     dc.w    0,0
                dc.b    0,0
                dc.b    RP_JAM1
                dc.b    5
                dc.l    OSacoor
                dc.l    BordrOpSzd          bd_NextBorder

BordrOpSzb:     dc.w    0,0
                dc.b    0,0
                dc.b    RP_JAM1
                dc.b    5
                dc.l    OSbcoor
                dc.l    0

BordrOpSza:     dc.w    0,0
                dc.b    1,0
                dc.b    RP_JAM1
                dc.b    5
                dc.l    OSacoor
                dc.l    BordrOpSzb

BordrRegd:      dc.w    0,0
                dc.b    1,0
                dc.b    RP_JAM1
                dc.b    5
                dc.l    RSbcoor
                dc.l    0
* 60

BordrRegc:      dc.w    0,0
                dc.b    0,0
                dc.b    RP_JAM1
                dc.b    5
                dc.l    RSacoor
                dc.l    BordrRegd

BordrRegb:      dc.w    0,0
                dc.b    0,0
                dc.b    RP_JAM1
                dc.b    5
                dc.l    RSbcoor
                dc.l    0

BordrRega:      dc.w    0,0
                dc.b    1,0
                dc.b    RP_JAM1
                dc.b    5
                dc.l    RSacoor
                dc.l    BordrRegb

BordrOpd:       dc.w    0,0
                dc.b    1,0
                dc.b    RP_JAM1
                dc.b    7
                dc.l    Opdcoor
                dc.l    0

BordrOpc:       dc.w    0,0
                dc.b    0,0
                dc.b    RP_JAM1
                dc.b    12
                dc.l    Opccoor
                dc.l    BordrOpd

BordrOpb:       dc.w    0,0
                dc.b    0,0
                dc.b    RP_JAM1
                dc.b    9
                dc.l    Opbcoor
                dc.l    0

BordrOpa:       dc.w    0,0
                dc.b    1,0
                dc.b    RP_JAM1
                dc.b    8
                dc.l    Opacoor
                dc.l    BordrOpb

BoEnd:          dc.w    0
                even

bordbytes:      equ     BoEnd-BordrHexpx
BsLen:          equ     BoEnd-BordrOpa
nrBs:           equ     bordbytes/BsLen


****************************************************************************

                section     intuidata,DATA

****************************************************************************
*
*           Gadget and other text strings


FormLSign:      dc.b    '%15ld',0           signed decimal long
FormISign:      dc.b    '%15d',0,0          signed decimal int

TxtLng:         dc.b    '.L',0,0
TxtWrd:         dc.b    '.W',0,0
TxtByt:         dc.b    '.B',0,0

TxtRd0:         dc.b    'D0',0,0
TxtRd1:         dc.b    'D1',0,0
TxtRd2:         dc.b    'D2',0,0
TxtRd3:         dc.b    'D3',0,0

flagsdispx:     dc.b    '0',0
flagsdispn:     dc.b    '0',0
flagsdispz:     dc.b    '0',0
flagsdispv:     dc.b    '0',0
flagsdispc:     dc.b    '0',0

srchexdn1:      dc.b    '0',0               these are going right...
srchexdn2:      dc.b    '0',0
srchexdn3:      dc.b    '0',0
srchexdn4:      dc.b    '0',0
srchexdn5:      dc.b    '0',0
srchexdn6:      dc.b    '0',0
srchexdn7:      dc.b    '0',0
srchexdn8:      dc.b    '0',0                           ...to left

                dc.b    '000000000000000',0     RawDoFmt into here,
sdecstring:     dc.b    '              0',0         then dots into here

dsthexdn1:      dc.b    '0',0
dsthexdn2:      dc.b    '0',0
dsthexdn3:      dc.b    '0',0
dsthexdn4:      dc.b    '0',0
dsthexdn5:      dc.b    '0',0
dsthexdn6:      dc.b    '0',0
dsthexdn7:      dc.b    '0',0
dsthexdn8:      dc.b    '0',0

                dc.b    '000000000000000',0
ddecstring:     dc.b    '              0',0


TxtCLR:         dc.b    'CLR',0
TxtNEG:         dc.b    'NEG',0
TxtNOT:         dc.b    'NOT',0
TxtAND:         dc.b    'AND',0
TxtOR:          dc.b    'OR',0,0
TxtEOR:         dc.b    'EOR',0
TxtLSL:         dc.b    'LSL',0
TxtROL:         dc.b    'ROL',0
TxtROXL:        dc.b    'ROXL',0,0
TxtLSR:         dc.b    'LSR',0
TxtROR:         dc.b    'ROR',0
TxtROXR:        dc.b    'ROXR',0,0
TxtASL:         dc.b    'ASL',0
TxtMULU:        dc.b    'MULU',0,0
TxtMULS:        dc.b    'MULS',0,0
TxtASR:         dc.b    'ASR',0
TxtDIVU:        dc.b    'DIVU',0,0
TxtDIVS:        dc.b    'DIVS',0,0
TxtADD:         dc.b    'ADD',0
TxtEXG:         dc.b    'EXG',0
TxtMOVE:        dc.b    'MOVE',0,0
TxtSUB:         dc.b    'SUB',0
TxtSWAP:        dc.b    'SWAP',0,0
TxtINPUT:       dc.b    'HEX',0
TxtABOUT:       dc.b    'ABOUT',0
TxtOKAY:        dc.b    'YEAH!',0

textstbit:      dc.b    "Status Bits:",0,0
textxnzvc:      dc.b    "X N Z V C",0
textphin:       dc.b    "DReg v1.2 - ~} 1994, P.Juhasz",0
                even
aboutlin1:      dc.b    "DReg v1.2 is Copyright ~} 94 of Paul Juhasz, "
                dc.b    " 28 Ellora Rd,",0
aboutlin2:      dc.b    " Streatham",0
aboutlin3:      dc.b    " London SW16 6JF",0
aboutlin4:      dc.b    "This program is Freeware. Permission is hereby "
                dc.b    "given to any individual to copy",0
aboutlin5:      dc.b    "and distribute it as long as no fee is charged "
                dc.b    "for the program itself.",0
aboutlin6:      dc.b    "If you like it - spread it, if you don't - wipe"
                dc.b    " it from your disk.",0
                even

****************************************************************************

                section     intuitext,DATA

****************************************************************************
*
*           Gadget and other text structures    - 66 structures, add 20

                even

ITxtLng:        dc.b    1                   BYTE    it_FrontPen
                dc.b    2                   BYTE    it_BackPen
                dc.b    RP_JAM2             BYTE    it_DrawMode
                dc.b    0                   BYTE    it_KludgeFill00
                dc.w    3                   WORD    it_LeftEdge
                dc.w    1                   WORD    it_TopEdge
                dc.l    RegFntTA            APTR    it_ITextFont
                dc.l    TxtLng              APTR    it_IText
                dc.l    0                   APTR    it_NextText

ITxtWrd:        dc.b    1,2,RP_JAM2,0
                dc.w    2,1
                dc.l    RegFntTA
                dc.l    TxtWrd
                dc.l    0

ITxtByt:        dc.b    1,2,RP_JAM2,0
                dc.w    3,1
                dc.l    RegFntTA
                dc.l    TxtByt
                dc.l    0

ITxtSSel:       dc.b    1,2,RP_JAM2,0
                dc.w    4,1
                dc.l    RegFntTA
                dc.l    TxtRd0
                dc.l    0

ITxtDSel:       dc.b    1,2,RP_JAM2,0
                dc.w    4,1
                dc.l    RegFntTA
                dc.l    TxtRd1
                dc.l    0


*           the Status Bits plus decimal and hexadecimal display values


ITxtFlgc:       dc.b    1,0,RP_JAM2,0
                dc.w    76
                dc.w    25
                dc.l    RegFntTA
                dc.l    flagsdispc
                dc.l    0

ITxtFlgv:       dc.b    1,0,RP_JAM2,0
                dc.w    66
                dc.w    25
                dc.l    RegFntTA
                dc.l    flagsdispv
                dc.l    ITxtFlgc

ITxtFlgz:       dc.b    1,0,RP_JAM2,0
                dc.w    56
                dc.w    25
                dc.l    RegFntTA
                dc.l    flagsdispz
                dc.l    ITxtFlgv

ITxtFlgn:       dc.b    1,0,RP_JAM2,0
                dc.w    46
                dc.w    25
                dc.l    RegFntTA
                dc.l    flagsdispn
                dc.l    ITxtFlgz

ITxtFlgx:       dc.b    1,0,RP_JAM2,0
                dc.w    36
                dc.w    25
                dc.l    RegFntTA
                dc.l    flagsdispx
                dc.l    ITxtFlgn
* 10

*           The Register values in HEX


ITxDNib7:       dc.b    1,0,RP_JAM2,0
                dc.w    76
                dc.w    13
                dc.l    RegFntTA
                dc.l    dsthexdn1
                dc.l    0

ITxDNib6:       dc.b    1,0,RP_JAM2,0
                dc.w    66
                dc.w    13
                dc.l    RegFntTA
                dc.l    dsthexdn2
                dc.l    ITxDNib7

ITxDNib5:       dc.b    1,0,RP_JAM2,0
                dc.w    56
                dc.w    13
                dc.l    RegFntTA
                dc.l    dsthexdn3
                dc.l    ITxDNib6

ITxDNib4:       dc.b    1,0,RP_JAM2,0
                dc.w    46
                dc.w    13
                dc.l    RegFntTA
                dc.l    dsthexdn4
                dc.l    ITxDNib5

ITxDNib3:       dc.b    1,0,RP_JAM2,0
                dc.w    33
                dc.w    13
                dc.l    RegFntTA
                dc.l    dsthexdn5
                dc.l    ITxDNib4

ITxDNib2:       dc.b    1,0,RP_JAM2,0
                dc.w    23
                dc.w    13
                dc.l    RegFntTA
                dc.l    dsthexdn6
                dc.l    ITxDNib3

ITxDNib1:       dc.b    1,0,RP_JAM2,0
                dc.w    13
                dc.w    13
                dc.l    RegFntTA
                dc.l    dsthexdn7
                dc.l    ITxDNib2

ITxDNib0:       dc.b    1,0,RP_JAM2,0
                dc.w    3
                dc.w    13
                dc.l    RegFntTA
                dc.l    dsthexdn8
                dc.l    ITxDNib1


ITxSNib7:       dc.b    1,0,RP_JAM2,0
                dc.w    76
                dc.w    1
                dc.l    RegFntTA
                dc.l    srchexdn1
                dc.l    ITxDNib0

ITxSNib6:       dc.b    1,0,RP_JAM2,0
                dc.w    66
                dc.w    1
                dc.l    RegFntTA
                dc.l    srchexdn2
                dc.l    ITxSNib7
* 20

ITxSNib5:       dc.b    1,0,RP_JAM2,0
                dc.w    56
                dc.w    1
                dc.l    RegFntTA
                dc.l    srchexdn3
                dc.l    ITxSNib6

ITxSNib4:       dc.b    1,0,RP_JAM2,0
                dc.w    46
                dc.w    1
                dc.l    RegFntTA
                dc.l    srchexdn4
                dc.l    ITxSNib5

ITxSNib3:       dc.b    1,0,RP_JAM2,0
                dc.w    33
                dc.w    1
                dc.l    RegFntTA
                dc.l    srchexdn5
                dc.l    ITxSNib4

ITxSNib2:       dc.b    1,0,RP_JAM2,0
                dc.w    23
                dc.w    1
                dc.l    RegFntTA
                dc.l    srchexdn6
                dc.l    ITxSNib3

ITxSNib1:       dc.b    1,0,RP_JAM2,0
                dc.w    13
                dc.w    1
                dc.l    RegFntTA
                dc.l    srchexdn7
                dc.l    ITxSNib2

ITxSNib0:       dc.b    1,0,RP_JAM2,0
                dc.w    3
                dc.w    1
                dc.l    RegFntTA
                dc.l    srchexdn8
                dc.l    ITxSNib1


*           and register values in decimal


ITxtDDec:       dc.b    1,0,RP_JAM2,0
                dc.w    5
                dc.w    13
                dc.l    RegFntTA
                dc.l    ddecstring
                dc.l    0

ITxtSDec:       dc.b    1,0,RP_JAM2,0
                dc.w    5
                dc.w    1
                dc.l    RegFntTA
                dc.l    sdecstring
                dc.l    ITxtDDec


*           Gadget text structures for OpCode gadgets


ITxtCLR:        dc.b    1,2,RP_JAM2,0
                dc.w    8
                dc.w    1
                dc.l    RegFntTA
                dc.l    TxtCLR
                dc.l    0

ITxtNEG:        dc.b    1,2,RP_JAM2,0
                dc.w    8
                dc.w    1
                dc.l    RegFntTA
                dc.l    TxtNEG
                dc.l    0
* 30

ITxtNOT:        dc.b    1,2,RP_JAM2,0
                dc.w    8
                dc.w    1
                dc.l    RegFntTA
                dc.l    TxtNOT
                dc.l    0

ITxtAND:        dc.b    1,2,RP_JAM2,0
                dc.w    8
                dc.w    1
                dc.l    RegFntTA
                dc.l    TxtAND
                dc.l    0

ITxtOR:         dc.b    1,2,RP_JAM2,0
                dc.w    10
                dc.w    1
                dc.l    RegFntTA
                dc.l    TxtOR
                dc.l    0

ITxtEOR:        dc.b    1,2,RP_JAM2,0
                dc.w    8
                dc.w    1
                dc.l    RegFntTA
                dc.l    TxtEOR
                dc.l    0

ITxtLSL:        dc.b    1,2,RP_JAM2,0
                dc.w    8
                dc.w    1
                dc.l    RegFntTA
                dc.l    TxtLSL
                dc.l    0

ITxtROL:        dc.b    1,2,RP_JAM2,0
                dc.w    8
                dc.w    1
                dc.l    RegFntTA
                dc.l    TxtROL
                dc.l    0

ITxtROXL:       dc.b    1,2,RP_JAM2,0
                dc.w    6
                dc.w    1
                dc.l    RegFntTA
                dc.l    TxtROXL
                dc.l    0

ITxtLSR:        dc.b    1,2,RP_JAM2,0
                dc.w    8
                dc.w    1
                dc.l    RegFntTA
                dc.l    TxtLSR
                dc.l    0

ITxtROR:        dc.b    1,2,RP_JAM2,0
                dc.w    8
                dc.w    1
                dc.l    RegFntTA
                dc.l    TxtROR
                dc.l    0

ITxtROXR:       dc.b    1,2,RP_JAM2,0
                dc.w    6
                dc.w    1
                dc.l    RegFntTA
                dc.l    TxtROXR
                dc.l    0
* 40

ITxtASL:        dc.b    1,2,RP_JAM2,0
                dc.w    8
                dc.w    1
                dc.l    RegFntTA
                dc.l    TxtASL
                dc.l    0

ITxtMULU:       dc.b    1,2,RP_JAM2,0
                dc.w    6
                dc.w    1
                dc.l    RegFntTA
                dc.l    TxtMULU
                dc.l    0

ITxtMULS:       dc.b    1,2,RP_JAM2,0
                dc.w    6
                dc.w    1
                dc.l    RegFntTA
                dc.l    TxtMULS
                dc.l    0

ITxtASR:        dc.b    1,2,RP_JAM2,0
                dc.w    8
                dc.w    1
                dc.l    RegFntTA
                dc.l    TxtASR
                dc.l    0

ITxtDIVU:       dc.b    1,2,RP_JAM2,0
                dc.w    6
                dc.w    1
                dc.l    RegFntTA
                dc.l    TxtDIVU
                dc.l    0

ITxtDIVS:       dc.b    1,2,RP_JAM2,0
                dc.w    6
                dc.w    1
                dc.l    RegFntTA
                dc.l    TxtDIVS
                dc.l    0

ITxtADD:        dc.b    1,2,RP_JAM2,0
                dc.w    8
                dc.w    1
                dc.l    RegFntTA
                dc.l    TxtADD
                dc.l    0

ITxtEXG:        dc.b    1,2,RP_JAM2,0
                dc.w    8
                dc.w    1
                dc.l    RegFntTA
                dc.l    TxtEXG
                dc.l    0

ITxtMOVE:       dc.b    1,2,RP_JAM2,0
                dc.w    6
                dc.w    1
                dc.l    RegFntTA
                dc.l    TxtMOVE
                dc.l    0

ITxtSUB:        dc.b    1,2,RP_JAM2,0
                dc.w    8
                dc.w    1
                dc.l    RegFntTA
                dc.l    TxtSUB
                dc.l    0
* 50

ITxtSWAP:       dc.b    1,2,RP_JAM2,0
                dc.w    6
                dc.w    1
                dc.l    RegFntTA
                dc.l    TxtSWAP
                dc.l    0

ITxtINPUT:      dc.b    1,2,RP_JAM2,0
                dc.w    8
                dc.w    1
                dc.l    RegFntTA
                dc.l    TxtINPUT
                dc.l    0

ITxtABOUT:      dc.b    1,2,RP_JAM2,0
                dc.w    5
                dc.w    1
                dc.l    RegFntTA
                dc.l    TxtABOUT
                dc.l    0

ITxtOKAY:       dc.b    1,2,RP_JAM2,0
                dc.w    4
                dc.w    1
                dc.l    RegFntTA
                dc.l    TxtOKAY
                dc.l    0


*           IText structures for panel


ITxtFPhin:      dc.b    1,0,RP_JAM1,0
                dc.w    296
                dc.w    62
                dc.l    RegFntTA
                dc.l    textphin
                dc.l    0

ITxFxnzvc:      dc.b    1,0,RP_JAM1,0
                dc.w    395
                dc.w    48
                dc.l    RegFntTA
                dc.l    textxnzvc
                dc.l    ITxtFPhin

ITxFStBit:      dc.b    1,0,RP_JAM1,0
                dc.w    325
                dc.w    39
                dc.l    RegFntTA
                dc.l    textstbit
                dc.l    ITxFxnzvc

ITxtSPhin:      dc.b    0,0,RP_JAM1,0
                dc.w    298
                dc.w    63
                dc.l    RegFntTA
                dc.l    textphin
                dc.l    ITxFStBit

ITxSxnzvc:      dc.b    0,0,RP_JAM1,0
                dc.w    397
                dc.w    49
                dc.l    RegFntTA
                dc.l    textxnzvc
                dc.l    ITxtSPhin

ITxSStBit:      dc.b    0,0,RP_JAM1,0
                dc.w    327
                dc.w    40
                dc.l    RegFntTA
                dc.l    textstbit
                dc.l    ITxSxnzvc
* 60

*       The IText structures for the About requester - foreground col


ITxFShr3:       dc.b    0,0,RP_JAM1,0
                dc.w    49
                dc.w    49
                dc.l    RegFntTA
                dc.l    aboutlin6
                dc.l    0

ITxFShr2:       dc.b    0,0,RP_JAM1,0
                dc.w    43
                dc.w    40
                dc.l    RegFntTA
                dc.l    aboutlin5
                dc.l    ITxFShr3

ITxFShr1:       dc.b    0,0,RP_JAM1,0
                dc.w    19
                dc.w    31
                dc.l    RegFntTA
                dc.l    aboutlin4
                dc.l    ITxFShr2

ITxFAdr3:       dc.b    1,0,RP_JAM1,0
                dc.w    272
                dc.w    21
                dc.l    RegFntTA
                dc.l    aboutlin3
                dc.l    ITxFShr1

ITxFAdr2:       dc.b    1,0,RP_JAM1,0
                dc.w    272
                dc.w    12
                dc.l    RegFntTA
                dc.l    aboutlin2
                dc.l    ITxFAdr3

ITxFCpyRt:      dc.b    1,0,RP_JAM1,0
                dc.w    47                  it_LeftEdge
                dc.w    2                   it_TopEdge
                dc.l    RegFntTA
                dc.l    aboutlin1
                dc.l    ITxFAdr2

ITEnd:          dc.w    0
                even

ITextbytes:     equ     ITEnd-ITxtLng
IsLen:          equ     ITEnd-ITxFCpyRt
nrIs:           equ     ITextbytes/IsLen


****************************************************************************

                section     fontdata,DATA_C

****************************************************************************
*
*       Font name:                 smfont.font
*       Struct name:                    RegFnt
*       Height:                              7
*       Characters:                   32 - 127
*               Courtesy of IncludeFont from the Amiga C Encyclopaedia


RegFntData:
    dc.w     $0000,$0200,$0000,$0000,$0000,$0000,$0000,$0000
    dc.w     $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
    dc.w     $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
    dc.w     $0000,$0000,$0000,$0000,$0000,$3C00
    dc.w     $0114,$A799,$8421,$1400,$0001,$6339,$C179,$9E63
    dc.w     $0001,$011C,$7338,$EE7B,$CE93,$8928,$465C,$6718
    dc.w     $E946,$3297,$9D07,$1004,$0400,$2038,$1021,$2040
    dc.w     $0000,$0000,$4000,$0000,$0648,$4000
    dc.w     $0115,$FA22,$0440,$8840,$0002,$9104,$2342,$0494
    dc.w     $8842,$7882,$8CA5,$2942,$1091,$0928,$6F52,$94A0
    dc.w     $4946,$B291,$1081,$2802,$771C,$E621,$DC00,$244F
    dc.w     $719C,$7738,$E94A,$3297,$8848,$5800
    dc.w     $0100,$A771,$E040,$94E0,$7804,$9118,$C573,$8863
    dc.w     $8004,$004C,$BCB9,$097B,$D6F1,$09C8,$56D2,$9718
    dc.w     $4946,$AC72,$1041,$0000,$94A1,$297A,$5221,$384A
    dc.w     $CA52,$94B0,$494A,$AC91,$1808,$5000
    dc.w     $0001,$F2A2,$4040,$8040,$0008,$9120,$2F8A,$4890
    dc.w     $8002,$7880,$BFA5,$0942,$1291,$0928,$465C,$9484
    dc.w     $492A,$B214,$1021,$0000,$94A1,$2A21,$D221,$244A
    dc.w     $CA52,$9408,$492A,$B272,$0848,$5800
    dc.w     $0100,$AF7D,$C021,$0002,$0090,$613D,$C171,$8863
    dc.w     $0841,$0108,$84B8,$EE7A,$0E93,$912F,$4650,$7CB8
    dc.w     $4611,$5267,$9C17,$03E0,$771C,$E720,$5221,$244A
    dc.w     $C99C,$7438,$4619,$5217,$8648,$4000
    dc.w     $0000,$0200,$0000,$0002,$0000,$0000,$0000,$0000
    dc.w     $0080,$0000,$7000,$0000,$0000,$0000,$0000,$0000
    dc.w     $0000,$0000,$0000,$0000,$0000,$0001,$8002,$0000
    dc.w     $0010,$1000,$0000,$0060,$0000,$3C00


*       The location and width of each character:

RegFntLoc:
    dc.l     $00000005,$00050005,$000A0005,$000F0005
    dc.l     $00140005,$00190005,$001E0005,$00230005
    dc.l     $00280005,$002D0005,$00320005,$00370005
    dc.l     $003C0005,$00410005,$00460005,$004B0005
    dc.l     $00500005,$00550005,$005A0005,$005F0005
    dc.l     $00640005,$00690005,$006E0005,$00730005
    dc.l     $00780005,$007D0005,$00820005,$00870005
    dc.l     $008C0005,$00910005,$00960005,$009B0005
    dc.l     $00A00005,$00A50005,$00AA0005,$00AF0005
    dc.l     $00B40005,$00B90005,$00BE0005,$00C30005
    dc.l     $00C80005,$00CD0005,$00D20005,$00D70005
    dc.l     $00DC0005,$00E10005,$00E60005,$00500005
    dc.l     $00EB0005,$00F00005,$00F50005,$00FA0005
    dc.l     $00FF0005,$01040005,$01090005,$010E0005
    dc.l     $01130005,$01180005,$011D0005,$01220005
    dc.l     $01270005,$012C0005,$01310005,$01360005
    dc.l     $013B0005,$01400005,$01450005,$014A0005
    dc.l     $014F0005,$01540005,$01590005,$015E0005
    dc.l     $01630005,$01680005,$016D0005,$01720005
    dc.l     $01770005,$017C0005,$01810005,$01860005
    dc.l     $018B0005,$01900005,$01950005,$019A0005
    dc.l     $019F0005,$01A40005,$01A90005,$01AE0005
    dc.l     $01B30005,$01B80005,$01BD0005,$01C20005
    dc.l     $01C70005,$01CC0005,$01D10005,$01CC0005


****************************************************************************

                section     fontstruct,DATA

****************************************************************************
*
*       The actual TextFont and TextAttr structures


FntName:    dc.b    'DRegPrc.font',0

RegFntTA:   dc.l    FntName                     APTR    ta_Name
            dc.w    7                           UWORD   ta_YSize
            dc.b    8                           UBYTE   ta_Style
            dc.b    74                          UBYTE   ta_Flags

RegFntFont: dc.l    0                           APTR    LN_SUCC
            dc.l    0                           APTR    LN_PRED
            dc.b    NT_FONT                     UBYTE   LN_TYPE
            dc.b    0                           BYTE    LN_PRI
            dc.l    FntName                     APTR    LN_NAME
            dc.l    0                           APTR    MN_REPLYPORT
            dc.w    808                         UWORD   MN_LENGTH
            dc.w    7                           UWORD   tf_YSize
            dc.b    8                           UBYTE   tf_Style
            dc.b    74                          UBYTE   tf_Flags
            dc.w    5                           UWORD   tf_XSize
            dc.w    5                           UWORD   tf_Baseline
            dc.w    1                           UWORD   tf_BoldSmear
            dc.w    0                           UWORD   tf_Accessors
            dc.b    32                          UBYTE   tf_LoChar
            dc.b    127                         UBYTE   tf_HiChar
            dc.l    RegFntData                  APTR    tf_CharData
            dc.w    60                          UWORD   tf_Modulo
            dc.l    RegFntLoc                   APTR    tf_CharLoc
            dc.l    0                           APTR    tf_CharSpace
            dc.l    0                           APTR    tf_CharKern


****************************************************************************




