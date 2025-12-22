
*   reggds.s    -   struct Gadget definitions
                even

*****************************************************************************

                section     reggads,DATA

*****************************************************************************
*
*       These are the 70 gadgets to be selected by program as well
*                       as by Intuition                             +44


OpSizLong:      dc.l    0                               gg_NextGadget
                dc.w    8                               gg_LeftEdge
                dc.w    61                              gg_TopEdge
                dc.w    16                              gg_Width
                dc.w    9                               gg_Height
                dc.w    GADGHIMAGE                      gg_Flags
                dc.w    bitactiv                        gg_Activation
                dc.w    BOOLGADGET                      gg_GadgetType
                dc.l    BordrOpSza                      gg_GadgetRender
                dc.l    BordrOpSzc                      gg_SelectRender
                dc.l    ITxtLng                         gg_GadgetText
                dc.l    0                               gg_MutualExclude
                dc.l    0                               gg_SpecialInfo
                dc.w    92                              gg_GadgetID
                dc.l    0                               gg_UserData

OpSizWord:      dc.l    OpSizLong
                dc.w    8,51,16,9
                dc.w    GADGHIMAGE
                dc.w    bitactiv
                dc.w    BOOLGADGET
                dc.l    BordrOpSza
                dc.l    BordrOpSzc
                dc.l    ITxtWrd
                dc.l    0,0
                dc.w    91
                dc.l    0

OpSizByte:      dc.l    OpSizWord
                dc.w    8,41,16,9
                dc.w    GADGHIMAGE
                dc.w    bitactiv
                dc.w    BOOLGADGET
                dc.l    BordrOpSza
                dc.l    BordrOpSzc
                dc.l    ITxtByt
                dc.l    0,0
                dc.w    90
                dc.l    0


*****************************************************************************
*
*       Source and destination registers select


SrcSelGdg:      dc.l    OpSizByte
                dc.w    339,14,16,9
                dc.w    GADGHIMAGE
                dc.w    RELVERIFY
                dc.w    BOOLGADGET
                dc.l    BordrRega
                dc.l    BordrRegc
                dc.l    ITxtSSel
                dc.l    0,0
                dc.w    81
                dc.l    0

DstSelGdg:      dc.l    SrcSelGdg
                dc.w    339,26,16,9
                dc.w    GADGHIMAGE
                dc.w    RELVERIFY
                dc.w    BOOLGADGET
                dc.l    BordrRega
                dc.l    BordrRegc
                dc.l    ITxtDSel
                dc.l    0,0
                dc.w    80
                dc.l    0


*****************************************************************************
*
*       Destination register bits


DstRGdg31:      dc.l    DstSelGdg
                dc.w    8,26,9,9
                dc.w    bitflags,bitactiv
                dc.w    BOOLGADGET
                dc.l    ImageBit0
                dc.l    ImageBit1
                dc.l    0,0,0
                dc.w    72
                dc.l    0

DstRGdg30:      dc.l    DstRGdg31
                dc.w    18,26,9,9
                dc.w    bitflags,bitactiv
                dc.w    BOOLGADGET
                dc.l    ImageBit0
                dc.l    ImageBit1
                dc.l    0,0,0
                dc.w    71
                dc.l    0

DstRGdg29:      dc.l    DstRGdg30
                dc.w    28,26,9,9
                dc.w    bitflags,bitactiv
                dc.w    BOOLGADGET
                dc.l    ImageBit0
                dc.l    ImageBit1
                dc.l    0,0,0
                dc.w    70
                dc.l    0

DstRGdg28:      dc.l    DstRGdg29
                dc.w    38,26,9,9
                dc.w    bitflags,bitactiv
                dc.w    BOOLGADGET
                dc.l    ImageBit0
                dc.l    ImageBit1
                dc.l    0,0,0
                dc.w    69
                dc.l    0

DstRGdg27:      dc.l    DstRGdg28
                dc.w    48,26,9,9
                dc.w    bitflags,bitactiv
                dc.w    BOOLGADGET
                dc.l    ImageBit0
                dc.l    ImageBit1
                dc.l    0,0,0
                dc.w    68
                dc.l    0

DstRGdg26:      dc.l    DstRGdg27
                dc.w    58,26,9,9
                dc.w    bitflags,bitactiv
                dc.w    BOOLGADGET
                dc.l    ImageBit0
                dc.l    ImageBit1
                dc.l    0,0,0
                dc.w    67
                dc.l    0

DstRGdg25:      dc.l    DstRGdg26
                dc.w    68,26,9,9
                dc.w    bitflags,bitactiv
                dc.w    BOOLGADGET
                dc.l    ImageBit0
                dc.l    ImageBit1
                dc.l    0,0,0
                dc.w    66
                dc.l    0

DstRGdg24:      dc.l    DstRGdg25
                dc.w    78,26,9,9
                dc.w    bitflags,bitactiv
                dc.w    BOOLGADGET
                dc.l    ImageBit0
                dc.l    ImageBit1
                dc.l    0,0,0
                dc.w    65
                dc.l    0

DstRGdg23:      dc.l    DstRGdg24
                dc.w    90,26,9,9
                dc.w    bitflags,bitactiv
                dc.w    BOOLGADGET
                dc.l    ImageBit0
                dc.l    ImageBit1
                dc.l    0,0,0
                dc.w    64
                dc.l    0

DstRGdg22:      dc.l    DstRGdg23
                dc.w    100,26,9,9
                dc.w    bitflags,bitactiv
                dc.w    BOOLGADGET
                dc.l    ImageBit0
                dc.l    ImageBit1
                dc.l    0,0,0
                dc.w    63
                dc.l    0

DstRGdg21:      dc.l    DstRGdg22
                dc.w    110,26,9,9
                dc.w    bitflags,bitactiv
                dc.w    BOOLGADGET
                dc.l    ImageBit0
                dc.l    ImageBit1
                dc.l    0,0,0
                dc.w    62
                dc.l    0

DstRGdg20:      dc.l    DstRGdg21
                dc.w    120,26,9,9
                dc.w    bitflags,bitactiv
                dc.w    BOOLGADGET
                dc.l    ImageBit0
                dc.l    ImageBit1
                dc.l    0,0,0
                dc.w    61
                dc.l    0

DstRGdg19:      dc.l    DstRGdg20
                dc.w    130,26,9,9
                dc.w    bitflags,bitactiv
                dc.w    BOOLGADGET
                dc.l    ImageBit0
                dc.l    ImageBit1
                dc.l    0,0,0
                dc.w    60
                dc.l    0

DstRGdg18:      dc.l    DstRGdg19
                dc.w    140,26,9,9
                dc.w    bitflags,bitactiv
                dc.w    BOOLGADGET
                dc.l    ImageBit0
                dc.l    ImageBit1
                dc.l    0,0,0
                dc.w    59
                dc.l    0

DstRGdg17:      dc.l    DstRGdg18
                dc.w    150,26,9,9
                dc.w    bitflags,bitactiv
                dc.w    BOOLGADGET
                dc.l    ImageBit0
                dc.l    ImageBit1
                dc.l    0,0,0
                dc.w    58
                dc.l    0

DstRGdg16:      dc.l    DstRGdg17
                dc.w    160,26,9,9
                dc.w    bitflags,bitactiv
                dc.w    BOOLGADGET
                dc.l    ImageBit0
                dc.l    ImageBit1
                dc.l    0,0,0
                dc.w    57
                dc.l    0

DstRGdg15:      dc.l    DstRGdg16
                dc.w    174,26,9,9
                dc.w    bitflags,bitactiv
                dc.w    BOOLGADGET
                dc.l    ImageBit0
                dc.l    ImageBit1
                dc.l    0,0,0
                dc.w    56
                dc.l    0

DstRGdg14:      dc.l    DstRGdg15
                dc.w    184,26,9,9
                dc.w    bitflags,bitactiv
                dc.w    BOOLGADGET
                dc.l    ImageBit0
                dc.l    ImageBit1
                dc.l    0,0,0
                dc.w    55
                dc.l    0

DstRGdg13:      dc.l    DstRGdg14
                dc.w    194,26,9,9
                dc.w    bitflags,bitactiv
                dc.w    BOOLGADGET
                dc.l    ImageBit0
                dc.l    ImageBit1
                dc.l    0,0,0
                dc.w    54
                dc.l    0

DstRGdg12:      dc.l    DstRGdg13
                dc.w    204,26,9,9
                dc.w    bitflags,bitactiv
                dc.w    BOOLGADGET
                dc.l    ImageBit0
                dc.l    ImageBit1
                dc.l    0,0,0
                dc.w    53
                dc.l    0

DstRGdg11:      dc.l    DstRGdg12
                dc.w    214,26,9,9
                dc.w    bitflags,bitactiv
                dc.w    BOOLGADGET
                dc.l    ImageBit0
                dc.l    ImageBit1
                dc.l    0,0,0
                dc.w    52
                dc.l    0

DstRGdg10:      dc.l    DstRGdg11
                dc.w    224,26,9,9
                dc.w    bitflags,bitactiv
                dc.w    BOOLGADGET
                dc.l    ImageBit0
                dc.l    ImageBit1
                dc.l    0,0,0
                dc.w    51
                dc.l    0

DstRGdg09:      dc.l    DstRGdg10
                dc.w    234,26,9,9
                dc.w    bitflags,bitactiv
                dc.w    BOOLGADGET
                dc.l    ImageBit0
                dc.l    ImageBit1
                dc.l    0,0,0
                dc.w    50
                dc.l    0

DstRGdg08:      dc.l    DstRGdg09
                dc.w    244,26,9,9
                dc.w    bitflags,bitactiv
                dc.w    BOOLGADGET
                dc.l    ImageBit0
                dc.l    ImageBit1
                dc.l    0,0,0
                dc.w    49
                dc.l    0

DstRGdg07:      dc.l    DstRGdg08
                dc.w    256,26,9,9
                dc.w    bitflags,bitactiv
                dc.w    BOOLGADGET
                dc.l    ImageBit0
                dc.l    ImageBit1
                dc.l    0,0,0
                dc.w    48
                dc.l    0

DstRGdg06:      dc.l    DstRGdg07
                dc.w    266,26,9,9
                dc.w    bitflags,bitactiv
                dc.w    BOOLGADGET
                dc.l    ImageBit0
                dc.l    ImageBit1
                dc.l    0,0,0
                dc.w    47
                dc.l    0

DstRGdg05:      dc.l    DstRGdg06
                dc.w    276,26,9,9
                dc.w    bitflags,bitactiv
                dc.w    BOOLGADGET
                dc.l    ImageBit0
                dc.l    ImageBit1
                dc.l    0,0,0
                dc.w    46
                dc.l    0

DstRGdg04:      dc.l    DstRGdg05
                dc.w    286,26,9,9
                dc.w    bitflags,bitactiv
                dc.w    BOOLGADGET
                dc.l    ImageBit0
                dc.l    ImageBit1
                dc.l    0,0,0
                dc.w    45
                dc.l    0

DstRGdg03:      dc.l    DstRGdg04
                dc.w    296,26,9,9
                dc.w    bitflags,bitactiv
                dc.w    BOOLGADGET
                dc.l    ImageBit0
                dc.l    ImageBit1
                dc.l    0,0,0
                dc.w    44
                dc.l    0

DstRGdg02:      dc.l    DstRGdg03
                dc.w    306,26,9,9
                dc.w    bitflags,bitactiv
                dc.w    BOOLGADGET
                dc.l    ImageBit0
                dc.l    ImageBit1
                dc.l    0,0,0
                dc.w    43
                dc.l    0

DstRGdg01:      dc.l    DstRGdg02
                dc.w    316,26,9,9
                dc.w    bitflags,bitactiv
                dc.w    BOOLGADGET
                dc.l    ImageBit0
                dc.l    ImageBit1
                dc.l    0,0,0
                dc.w    42
                dc.l    0

DstRGdg00:      dc.l    DstRGdg01
                dc.w    326,26,9,9
                dc.w    bitflags,bitactiv
                dc.w    BOOLGADGET
                dc.l    ImageBit0
                dc.l    ImageBit1
                dc.l    0,0,0
                dc.w    41
                dc.l    0


*****************************************************************************
*
*       Source register bits


SrcRGdg31:      dc.l    DstRGdg00
                dc.w    8,14,9,9
                dc.w    bitflags,bitactiv
                dc.w    BOOLGADGET
                dc.l    ImageBit0
                dc.l    ImageBit1
                dc.l    0,0,0
                dc.w    32
                dc.l    0

SrcRGdg30:      dc.l    SrcRGdg31
                dc.w    18,14,9,9
                dc.w    bitflags,bitactiv
                dc.w    BOOLGADGET
                dc.l    ImageBit0
                dc.l    ImageBit1
                dc.l    0,0,0
                dc.w    31
                dc.l    0

SrcRGdg29:      dc.l    SrcRGdg30
                dc.w    28,14,9,9
                dc.w    bitflags,bitactiv
                dc.w    BOOLGADGET
                dc.l    ImageBit0
                dc.l    ImageBit1
                dc.l    0,0,0
                dc.w    30
                dc.l    0

SrcRGdg28:      dc.l    SrcRGdg29
                dc.w    38,14,9,9
                dc.w    bitflags,bitactiv
                dc.w    BOOLGADGET
                dc.l    ImageBit0
                dc.l    ImageBit1
                dc.l    0,0,0
                dc.w    29
                dc.l    0

SrcRGdg27:      dc.l    SrcRGdg28
                dc.w    48,14,9,9
                dc.w    bitflags,bitactiv
                dc.w    BOOLGADGET
                dc.l    ImageBit0
                dc.l    ImageBit1
                dc.l    0,0,0
                dc.w    28
                dc.l    0

SrcRGdg26:      dc.l    SrcRGdg27
                dc.w    58,14,9,9
                dc.w    bitflags,bitactiv
                dc.w    BOOLGADGET
                dc.l    ImageBit0
                dc.l    ImageBit1
                dc.l    0,0,0
                dc.w    27
                dc.l    0

SrcRGdg25:      dc.l    SrcRGdg26
                dc.w    68,14,9,9
                dc.w    bitflags,bitactiv
                dc.w    BOOLGADGET
                dc.l    ImageBit0
                dc.l    ImageBit1
                dc.l    0,0,0
                dc.w    26
                dc.l    0

SrcRGdg24:      dc.l    SrcRGdg25
                dc.w    78,14,9,9
                dc.w    bitflags,bitactiv
                dc.w    BOOLGADGET
                dc.l    ImageBit0
                dc.l    ImageBit1
                dc.l    0,0,0
                dc.w    25
                dc.l    0

SrcRGdg23:      dc.l    SrcRGdg24
                dc.w    90,14,9,9
                dc.w    bitflags,bitactiv
                dc.w    BOOLGADGET
                dc.l    ImageBit0
                dc.l    ImageBit1
                dc.l    0,0,0
                dc.w    24
                dc.l    0

SrcRGdg22:      dc.l    SrcRGdg23
                dc.w    100,14,9,9
                dc.w    bitflags,bitactiv
                dc.w    BOOLGADGET
                dc.l    ImageBit0
                dc.l    ImageBit1
                dc.l    0,0,0
                dc.w    23
                dc.l    0

SrcRGdg21:      dc.l    SrcRGdg22
                dc.w    110,14,9,9
                dc.w    bitflags,bitactiv
                dc.w    BOOLGADGET
                dc.l    ImageBit0
                dc.l    ImageBit1
                dc.l    0,0,0
                dc.w    22
                dc.l    0

SrcRGdg20:      dc.l    SrcRGdg21
                dc.w    120,14,9,9
                dc.w    bitflags,bitactiv
                dc.w    BOOLGADGET
                dc.l    ImageBit0
                dc.l    ImageBit1
                dc.l    0,0,0
                dc.w    21
                dc.l    0

SrcRGdg19:      dc.l    SrcRGdg20
                dc.w    130,14,9,9
                dc.w    bitflags,bitactiv
                dc.w    BOOLGADGET
                dc.l    ImageBit0
                dc.l    ImageBit1
                dc.l    0,0,0
                dc.w    20
                dc.l    0

SrcRGdg18:      dc.l    SrcRGdg19
                dc.w    140,14,9,9
                dc.w    bitflags,bitactiv
                dc.w    BOOLGADGET
                dc.l    ImageBit0
                dc.l    ImageBit1
                dc.l    0,0,0
                dc.w    19
                dc.l    0

SrcRGdg17:      dc.l    SrcRGdg18
                dc.w    150,14,9,9
                dc.w    bitflags,bitactiv
                dc.w    BOOLGADGET
                dc.l    ImageBit0
                dc.l    ImageBit1
                dc.l    0,0,0
                dc.w    18
                dc.l    0

SrcRGdg16:      dc.l    SrcRGdg17
                dc.w    160,14,9,9
                dc.w    bitflags,bitactiv
                dc.w    BOOLGADGET
                dc.l    ImageBit0
                dc.l    ImageBit1
                dc.l    0,0,0
                dc.w    17
                dc.l    0

SrcRGdg15:      dc.l    SrcRGdg16
                dc.w    174,14,9,9
                dc.w    bitflags,bitactiv
                dc.w    BOOLGADGET
                dc.l    ImageBit0
                dc.l    ImageBit1
                dc.l    0,0,0
                dc.w    16
                dc.l    0

SrcRGdg14:      dc.l    SrcRGdg15
                dc.w    184,14,9,9
                dc.w    bitflags,bitactiv
                dc.w    BOOLGADGET
                dc.l    ImageBit0
                dc.l    ImageBit1
                dc.l    0,0,0
                dc.w    15
                dc.l    0

SrcRGdg13:      dc.l    SrcRGdg14
                dc.w    194,14,9,9
                dc.w    bitflags,bitactiv
                dc.w    BOOLGADGET
                dc.l    ImageBit0
                dc.l    ImageBit1
                dc.l    0,0,0
                dc.w    14
                dc.l    0

SrcRGdg12:      dc.l    SrcRGdg13
                dc.w    204,14,9,9
                dc.w    bitflags,bitactiv
                dc.w    BOOLGADGET
                dc.l    ImageBit0
                dc.l    ImageBit1
                dc.l    0,0,0
                dc.w    13
                dc.l    0

SrcRGdg11:      dc.l    SrcRGdg12
                dc.w    214,14,9,9
                dc.w    bitflags,bitactiv
                dc.w    BOOLGADGET
                dc.l    ImageBit0
                dc.l    ImageBit1
                dc.l    0,0,0
                dc.w    12
                dc.l    0

SrcRGdg10:      dc.l    SrcRGdg11
                dc.w    224,14,9,9
                dc.w    bitflags,bitactiv
                dc.w    BOOLGADGET
                dc.l    ImageBit0
                dc.l    ImageBit1
                dc.l    0,0,0
                dc.w    11
                dc.l    0

SrcRGdg09:      dc.l    SrcRGdg10
                dc.w    234,14,9,9
                dc.w    bitflags,bitactiv
                dc.w    BOOLGADGET
                dc.l    ImageBit0
                dc.l    ImageBit1
                dc.l    0,0,0
                dc.w    10
                dc.l    0

SrcRGdg08:      dc.l    SrcRGdg09
                dc.w    244,14,9,9
                dc.w    bitflags,bitactiv
                dc.w    BOOLGADGET
                dc.l    ImageBit0
                dc.l    ImageBit1
                dc.l    0,0,0
                dc.w    9
                dc.l    0

SrcRGdg07:      dc.l    SrcRGdg08
                dc.w    256,14,9,9
                dc.w    bitflags,bitactiv
                dc.w    BOOLGADGET
                dc.l    ImageBit0
                dc.l    ImageBit1
                dc.l    0,0,0
                dc.w    8
                dc.l    0

SrcRGdg06:      dc.l    SrcRGdg07
                dc.w    266,14,9,9
                dc.w    bitflags,bitactiv
                dc.w    BOOLGADGET
                dc.l    ImageBit0
                dc.l    ImageBit1
                dc.l    0,0,0
                dc.w    7
                dc.l    0

SrcRGdg05:      dc.l    SrcRGdg06
                dc.w    276,14,9,9
                dc.w    bitflags,bitactiv
                dc.w    BOOLGADGET
                dc.l    ImageBit0
                dc.l    ImageBit1
                dc.l    0,0,0
                dc.w    6
                dc.l    0

SrcRGdg04:      dc.l    SrcRGdg05
                dc.w    286,14,9,9
                dc.w    bitflags,bitactiv
                dc.w    BOOLGADGET
                dc.l    ImageBit0
                dc.l    ImageBit1
                dc.l    0,0,0
                dc.w    5
                dc.l    0

SrcRGdg03:      dc.l    SrcRGdg04
                dc.w    296,14,9,9
                dc.w    bitflags,bitactiv
                dc.w    BOOLGADGET
                dc.l    ImageBit0
                dc.l    ImageBit1
                dc.l    0,0,0
                dc.w    4
                dc.l    0

SrcRGdg02:      dc.l    SrcRGdg03
                dc.w    306,14,9,9
                dc.w    bitflags,bitactiv
                dc.w    BOOLGADGET
                dc.l    ImageBit0
                dc.l    ImageBit1
                dc.l    0,0,0
                dc.w    3
                dc.l    0

SrcRGdg01:      dc.l    SrcRGdg02
                dc.w    316,14,9,9
                dc.w    bitflags,bitactiv
                dc.w    BOOLGADGET
                dc.l    ImageBit0
                dc.l    ImageBit1
                dc.l    0,0,0
                dc.w    2
                dc.l    0

SrcRGdg00:      dc.l    SrcRGdg01
                dc.w    326,14,9,9
                dc.w    bitflags,bitactiv
                dc.w    BOOLGADGET
                dc.l    ImageBit0
                dc.l    ImageBit1
                dc.l    0,0,0
                dc.w    1
                dc.l    0


*****************************************************************************
*
*       These are 25 action gadgets selected only by IDCMP


OpClr:          dc.l    SrcRGdg00                       gg_NextGadget
                dc.w    34,41,32,9                  gg_LeftEdge - gg_Height
                dc.w    GADGHIMAGE                      gg_Flags
                dc.w    opactiv                         gg_Activation
                dc.w    BOOLGADGET                      gg_GadgetType
                dc.l    BordrOpa                        gg_GadgetRender
                dc.l    BordrOpc                        gg_SelectRender
                dc.l    ITxtCLR
                dc.l    0,0
                dc.w    200                             gg_GadgetID
                dc.l    0                               gg_UserData

OpNeg:          dc.l    OpClr
                dc.w    34,51,32,9
                dc.w    GADGHIMAGE
                dc.w    opactiv
                dc.w    BOOLGADGET
                dc.l    BordrOpa
                dc.l    BordrOpc
                dc.l    ITxtNEG
                dc.l    0,0
                dc.w    201
                dc.l    0

OpNot:          dc.l    OpNeg
                dc.w    34,61,32,9
                dc.w    GADGHIMAGE
                dc.w    opactiv
                dc.w    BOOLGADGET
                dc.l    BordrOpa
                dc.l    BordrOpc
                dc.l    ITxtNOT
                dc.l    0,0
                dc.w    202
                dc.l    0

OpAnd:          dc.l    OpNot
                dc.w    71,41,32,9
                dc.w    GADGHIMAGE
                dc.w    opactiv
                dc.w    BOOLGADGET
                dc.l    BordrOpa
                dc.l    BordrOpc
                dc.l    ITxtAND
                dc.l    0,0
                dc.w    203
                dc.l    0

OpOr:           dc.l    OpAnd
                dc.w    71,51,32,9
                dc.w    GADGHIMAGE
                dc.w    opactiv
                dc.w    BOOLGADGET
                dc.l    BordrOpa
                dc.l    BordrOpc
                dc.l    ITxtOR
                dc.l    0,0
                dc.w    204
                dc.l    0

OpEor:          dc.l    OpOr
                dc.w    71,61,32,9
                dc.w    GADGHIMAGE
                dc.w    opactiv
                dc.w    BOOLGADGET
                dc.l    BordrOpa
                dc.l    BordrOpc
                dc.l    ITxtEOR
                dc.l    0,0
                dc.w    205
                dc.l    0

OpLsl:          dc.l    OpEor
                dc.w    108,41,32,9
                dc.w    GADGHIMAGE
                dc.w    opactiv
                dc.w    BOOLGADGET
                dc.l    BordrOpa
                dc.l    BordrOpc
                dc.l    ITxtLSL
                dc.l    0,0
                dc.w    206
                dc.l    0

OpRol:          dc.l    OpLsl
                dc.w    108,51,32,9
                dc.w    GADGHIMAGE
                dc.w    opactiv
                dc.w    BOOLGADGET
                dc.l    BordrOpa
                dc.l    BordrOpc
                dc.l    ITxtROL
                dc.l    0,0
                dc.w    207
                dc.l    0

OpRoxl:         dc.l    OpRol
                dc.w    108,61,32,9
                dc.w    GADGHIMAGE
                dc.w    opactiv
                dc.w    BOOLGADGET
                dc.l    BordrOpa
                dc.l    BordrOpc
                dc.l    ITxtROXL
                dc.l    0,0
                dc.w    208
                dc.l    0

OpLsr:          dc.l    OpRoxl
                dc.w    141,41,32,9
                dc.w    GADGHIMAGE
                dc.w    opactiv
                dc.w    BOOLGADGET
                dc.l    BordrOpa
                dc.l    BordrOpc
                dc.l    ITxtLSR
                dc.l    0,0
                dc.w    209
                dc.l    0

OpRor:          dc.l    OpLsr
                dc.w    141,51,32,9
                dc.w    GADGHIMAGE
                dc.w    opactiv
                dc.w    BOOLGADGET
                dc.l    BordrOpa
                dc.l    BordrOpc
                dc.l    ITxtROR
                dc.l    0,0
                dc.w    210
                dc.l    0

OpRoxr:         dc.l    OpRor
                dc.w    141,61,32,9
                dc.w    GADGHIMAGE
                dc.w    opactiv
                dc.w    BOOLGADGET
                dc.l    BordrOpa
                dc.l    BordrOpc
                dc.l    ITxtROXR
                dc.l    0,0
                dc.w    211
                dc.l    0

OpAsl:          dc.l    OpRoxr
                dc.w    178,41,32,9
                dc.w    GADGHIMAGE
                dc.w    opactiv
                dc.w    BOOLGADGET
                dc.l    BordrOpa
                dc.l    BordrOpc
                dc.l    ITxtASL
                dc.l    0,0
                dc.w    212
                dc.l    0

OpMulu:         dc.l    OpAsl
                dc.w    178,51,32,9
                dc.w    GADGHIMAGE
                dc.w    opactiv
                dc.w    BOOLGADGET
                dc.l    BordrOpa
                dc.l    BordrOpc
                dc.l    ITxtMULU
                dc.l    0,0
                dc.w    213
                dc.l    0

OpMuls:         dc.l    OpMulu
                dc.w    178,61,32,9
                dc.w    GADGHIMAGE
                dc.w    opactiv
                dc.w    BOOLGADGET
                dc.l    BordrOpa
                dc.l    BordrOpc
                dc.l    ITxtMULS
                dc.l    0,0
                dc.w    214
                dc.l    0

OpAsr:          dc.l    OpMuls
                dc.w    211,41,32,9
                dc.w    GADGHIMAGE
                dc.w    opactiv
                dc.w    BOOLGADGET
                dc.l    BordrOpa
                dc.l    BordrOpc
                dc.l    ITxtASR
                dc.l    0,0
                dc.w    215
                dc.l    0

OpDivu:         dc.l    OpAsr
                dc.w    211,51,32,9
                dc.w    GADGHIMAGE
                dc.w    opactiv
                dc.w    BOOLGADGET
                dc.l    BordrOpa
                dc.l    BordrOpc
                dc.l    ITxtDIVU
                dc.l    0,0
                dc.w    216
                dc.l    0

OpDivs:         dc.l    OpDivu
                dc.w    211,61,32,9
                dc.w    GADGHIMAGE
                dc.w    opactiv
                dc.w    BOOLGADGET
                dc.l    BordrOpa
                dc.l    BordrOpc
                dc.l    ITxtDIVS
                dc.l    0,0
                dc.w    217
                dc.l    0

OpAdd:          dc.l    OpDivs
                dc.w    248,41,32,9
                dc.w    GADGHIMAGE
                dc.w    opactiv
                dc.w    BOOLGADGET
                dc.l    BordrOpa
                dc.l    BordrOpc
                dc.l    ITxtADD
                dc.l    0,0
                dc.w    218
                dc.l    0

OpExg:          dc.l    OpAdd
                dc.w    248,51,32,9
                dc.w    GADGHIMAGE
                dc.w    opactiv
                dc.w    BOOLGADGET
                dc.l    BordrOpa
                dc.l    BordrOpc
                dc.l    ITxtEXG
                dc.l    0,0
                dc.w    219
                dc.l    0

OpMove:         dc.l    OpExg
                dc.w    248,61,32,9
                dc.w    GADGHIMAGE
                dc.w    opactiv
                dc.w    BOOLGADGET
                dc.l    BordrOpa
                dc.l    BordrOpc
                dc.l    ITxtMOVE
                dc.l    0,0
                dc.w    220
                dc.l    0

OpSub:          dc.l    OpMove
                dc.w    281,41,32,9
                dc.w    GADGHIMAGE
                dc.w    opactiv
                dc.w    BOOLGADGET
                dc.l    BordrOpa
                dc.l    BordrOpc
                dc.l    ITxtSUB
                dc.l    0,0
                dc.w    221
                dc.l    0

OpSwap:         dc.l    OpSub
                dc.w    281,51,32,9
                dc.w    GADGHIMAGE
                dc.w    opactiv
                dc.w    BOOLGADGET
                dc.l    BordrOpa
                dc.l    BordrOpc
                dc.l    ITxtSWAP
                dc.l    0,0
                dc.w    222
                dc.l    0

OpInp:          dc.l    OpSwap
                dc.w    318,51,32,9
                dc.w    GADGHIMAGE
                dc.w    opactiv
                dc.w    BOOLGADGET
                dc.l    BordrOpa
                dc.l    BordrOpc
                dc.l    ITxtINPUT
                dc.l    0,0
                dc.w    223
                dc.l    0

Iconizer:       dc.l    OpInp
                dc.w    372,0,24,10
                dc.w    bitflags
                dc.w    opactiv+TOPBORDER
                dc.w    BOOLGADGET
                dc.l    ImageIcona
                dc.l    ImageIconb
                dc.l    0
                dc.l    0,0
                dc.w    300
                dc.l    0

OpAbout:        dc.l    Iconizer
                dc.w    355,51,32,9
                dc.w    GADGHIMAGE
                dc.w    opactiv
                dc.w    BOOLGADGET
                dc.l    BordrOpa
                dc.l    BordrOpc
                dc.l    ITxtABOUT
                dc.l    0,0
                dc.w    999
                dc.l    0

AbOkay:         dc.l    0
                dc.w    382,19,32,9
                dc.w    GADGHIMAGE
                dc.w    RELVERIFY+ENDGADGET
                dc.w    BOOLGADGET+REQGADGET
                dc.l    BordrOpa
                dc.l    BordrOpc
                dc.l    ITxtOKAY
                dc.l    0,0
                dc.w    888
                dc.l    0

Icondumm:       dc.l    0
                dc.w    372,0,24,10
                dc.w    bitflags
                dc.w    opactiv+TOPBORDER
                dc.w    BOOLGADGET
                dc.l    ImageIcona          gg_GadgetRender
                dc.l    ImageIconb          gg_SelectRender
                dc.l    0
                dc.l    0,0
                dc.w    301
                dc.l    0

gadEnd:         dc.w    0
                even

gadstsiz:       equ     gadEnd-Icondumm


****************************************************************************

        SECTION         ImageStructure,DATA

        
ImageBit0:
        dc.w    0                           ig_LeftEdge
        dc.w    0                           ig_TopEdge
        dc.w    9                           ig_Width
        dc.w    9                           ig_Height
        dc.w    2                           ig_Depth
        dc.l    ImageDataBit0               ig_ImageData
        dc.b    $03                         ig_PlanePick
        dc.b    $00                         ig_PlaneOnOff
        dc.l    0                           ig_NextImage

ImageBit1:
        dc.w    0,0,9,9,2
        dc.l    ImageDataBit1
        dc.b    $03
        dc.b    $00
        dc.l    0

ImageIcona:
        dc.w    0,0,24,10,2
        dc.l    ImageDataIcona
        dc.b    $03
        dc.b    $00
        dc.l    0

ImageIconb:
        dc.w    0,0,24,10,2
        dc.l    ImageDataIconb
        dc.b    $03
        dc.b    $00
        dc.l    0

ImageIcon2a:
        dc.w    0,0,24,11,2
        dc.l    ImageDataIcon2a
        dc.b    $03
        dc.b    $00
        dc.l    0

ImageIcon2b:
        dc.w    0,0,24,11,2
        dc.l    ImageDataIcon2b
        dc.b    $03
        dc.b    $00
        dc.l    0

        even

****************************************************************************

        SECTION         GadImageData,DATA_C


ImageDataBit0:
        dc.w    $FF80,$C080,$CC80,$D280,$D280,$D280,$CC80,$C080   -> WB1.3
        dc.w    $FF80,$0000,$4080,$4080,$4080,$4080,$4080,$4080
        dc.w    $4080,$7F80

ImageDataBit1:
        dc.w    $FF80,$C080,$CC80,$C480,$C480,$C480,$CE80,$C080
        dc.w    $FF80,$0000,$4080,$4080,$4080,$4080,$4080,$4080
        dc.w    $4080,$7F80

ImageDat2Bit0:
        dc.w    $0000,$7F80,$7380,$6D80,$6D80,$6D80,$7380,$7F80   -> WB2.xx
        dc.w    $FF80,$FF80,$C080,$CC80,$D280,$D280,$D280,$CC80
        dc.w    $C080,$FF80

ImageDat2Bit1:
        dc.w    $0000,$7F80,$7380,$7B80,$7B80,$7B80,$7B80,$7F80
        dc.w    $FF80,$FF80,$C080,$CC80,$C480,$C480,$C480,$C480
        dc.w    $C080,$FF80

ImageDataIcona:
        dc.w    $BFFF,$FE00,$BFFC,$0600,$BFFC,$0600,$BFFF,$FE00
        dc.w    $B000,$0600,$B7FF,$F600,$B3FF,$D600,$B2AA,$A600
        dc.w    $B000,$0600,$FFFF,$FF00,$0000,$0000,$0000,$0000
        dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w    $0400,$0000,$0000,$1000,$0000,$0000,$0000,$0000

ImageDataIconb:
        dc.w    $BFFF,$FE00,$BFFF,$FE00,$BFFF,$FE00,$BFFF,$FE00
        dc.w    $B000,$0600,$B000,$0600,$B000,$0600,$B000,$0600
        dc.w    $B000,$0600,$FFFF,$FF00,$0000,$0000,$0003,$F800
        dc.w    $0003,$F800,$0000,$0000,$0000,$0000,$07FF,$F000
        dc.w    $07FF,$D000,$02AA,$A000,$0000,$0000,$0000,$0000

ImageDataIcon2a:
        dc.w    $4000,$0100,$4003,$F900,$4003,$F900,$4000,$0100
        dc.w    $47FF,$F900,$4400,$0900,$4400,$2900,$4555,$5900
        dc.w    $47FF,$F900,$4000,$0100,$FFFF,$FF00,$BFFF,$FE00
        dc.w    $2000,$0000,$2000,$0000,$2000,$0000,$2000,$0000
        dc.w    $2000,$0000,$2000,$0000,$2000,$0000,$2000,$0000
        dc.w    $2000,$0000,$0000,$0000

ImageDataIcon2b:
        dc.w    $7FFF,$FF00,$6000,$0000,$6000,$0000,$6000,$0000
        dc.w    $67FF,$F800,$67FF,$F800,$67FF,$F800,$67FF,$F800
        dc.w    $67FF,$F800,$6000,$0000,$C000,$0000,$0000,$0000
        dc.w    $0003,$F900,$0003,$F900,$0000,$0100,$0000,$0100
        dc.w    $03FF,$F100,$03FF,$D100,$02AA,$A100,$0000,$0100
        dc.w    $0000,$0100,$3FFF,$FF00


*****************************************************************************



