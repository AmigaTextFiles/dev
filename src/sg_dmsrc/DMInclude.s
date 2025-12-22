NORTH		equ	1
EAST		equ	2
SOUTH		equ	3
WEST		equ	4
NumPlanes	equ	4

Screen_Width	EQU	320
Screen_Length	EQU	256
BytesPerLine	EQU	Screen_Width/8
Window_Width	EQU	28	; Number of bytes
Window_Length	EQU	136	; Number of lines
CNo_pln		EQU	1

Arrows_XStart		EQU	233
Arrows_YStart		EQU	126
Arrows_Length		EQU	45
Arrows_RealWidth	EQU	96
Arrows_Width		EQU	Arrows_RealWidth/8
Arrows_NoPln		EQU	1

Map_XStart		EQU	233
Map_YStart		EQU	26
Map_Height		EQU	65
Map_RealWidth		EQU	112
Map_Width		EQU	Map_RealWidth/8
Map_Offset		EQU	(Map_RealWidth*Map_Height)/8
Map_NoPln		EQU	1

BkGrd_XStart	EQU	0
BkGrd_YStart	EQU	35
BkGrd_Length	EQU	136
BkGrd_RealWidth	EQU	240
BkGrd_Width	EQU	BkGrd_RealWidth/8
BkGrd_NoPln	EQU	4

BkGrd_Offset	EQU	(BkGrd_RealWidth*BkGrd_Length)/8

Wall_N2_03X	EQU	0
Wall_N2_03Y	EQU	2
Wall_N1_03X	EQU	4
Wall_N1_03Y	EQU	6
Wall_00_03X	EQU	8
Wall_00_03Y	EQU	10
Wall_P1_03X	EQU	12
Wall_P1_03Y	EQU	14
Wall_P2_03X	EQU	16
Wall_P2_03Y	EQU	18

Wall_N2_02X	EQU	20
Wall_N2_02Y	EQU	22
Wall_N1_02X	EQU	24
Wall_N1_02Y	EQU	26
Wall_00_02X	EQU	28
Wall_00_02Y	EQU	30
Wall_P1_02X	EQU	32
Wall_P1_02Y	EQU	34
Wall_P2_02X	EQU	36
Wall_P2_02Y	EQU	38

Wall_N1_01X	EQU	40
Wall_N1_01Y	EQU	42
Wall_00_01X	EQU	44
Wall_00_01Y	EQU	46
Wall_P1_01X	EQU	48
Wall_P1_01Y	EQU	50

Wall_N1_00X	EQU	52
Wall_N1_00Y	EQU	54
Wall_00_00X	EQU	56
Wall_00_00Y	EQU	58
Wall_P1_00X	EQU	60
Wall_P1_00Y	EQU	62

WallN1_00_XStart	EQU	0
WallN1_00_YStart	EQU	35
WallP1_00_XStart	EQU	191	;ADJ
WallP1_00_YStart	EQU	35
Wall01_00_Height	EQU	136
Wall01_00_RealWidth	EQU	48
Wall01_00_Width		EQU	Wall01_00_RealWidth/8
Wall01_00_Offset	EQU	(Wall01_00_RealWidth*Wall01_00_Height)/8
Wall01_00_NoPln		EQU	NumPlanes

WallN1_01_XStart	EQU	0
WallN1_01_YStart	EQU	44
Wall00_01_XStart	EQU	32
Wall00_01_YStart	EQU	44
WallP1_01_XStart	EQU	163
WallP1_01_YStart	EQU	44
Wall01_01_Height	EQU	111
Wall01_01_RealWidth	EQU	80
Wall01_01_Width		EQU	Wall01_01_RealWidth/8
Wall01_01_Offset	EQU	(Wall01_01_RealWidth*Wall01_01_Height)/8
Wall00_01_RealWidth	EQU	176
Wall00_01_Width		EQU	Wall00_01_RealWidth/8
Wall00_01_Offset	EQU	(Wall00_01_RealWidth*Wall01_01_Height)/8
Wall01_01_NoPln		EQU	NumPlanes


WallN2_02_XStart	EQU	0
WallN2_02_YStart	EQU	59
WallN1_02_XStart	EQU	0
WallN1_02_YStart	EQU	54
Wall00_02_XStart	EQU	59
Wall00_02_YStart	EQU	54
WallP1_02_XStart	EQU	145
WallP1_02_YStart	EQU	54
WallP2_02_XStart	EQU	215
WallP2_02_YStart	EQU	59

Wall01_02_Height	EQU	74
Wall01_02_RealWidth	EQU	96
Wall01_02_Width		EQU	Wall01_02_RealWidth/8
Wall01_02_Offset	EQU	(Wall01_02_RealWidth*Wall01_02_Height)/8
Wall02_02_Height	EQU	52
Wall02_02_RealWidth	EQU	32
Wall02_02_Width		EQU	Wall02_02_RealWidth/8
Wall02_02_Offset	EQU	(Wall02_02_RealWidth*Wall02_02_Height)/8
Wall00_02_RealWidth	EQU	128
Wall00_02_Width		EQU	Wall00_02_RealWidth/8
Wall00_02_Offset	EQU	(Wall00_02_RealWidth*Wall01_02_Height)/8
Wall00_02_NoPln		EQU	NumPlanes


WallN2_03_XStart	EQU	0
WallN2_03_YStart	EQU	60
WallN1_03_XStart	EQU	7
WallN1_03_YStart	EQU	60
Wall00_03_XStart	EQU	78
Wall00_03_YStart	EQU	60
WallP1_03_XStart	EQU	134	;ADJ
WallP1_03_YStart	EQU	60
WallP2_03_XStart	EQU	185
WallP2_03_YStart	EQU	60

Wall01_03_Height	EQU	49
Wall01_03_RealWidth	EQU	112
Wall01_03_Width		EQU	Wall01_03_RealWidth/8
Wall01_03_Offset	EQU	(Wall01_03_RealWidth*Wall01_03_Height)/8
Wall02_03_Height	EQU	49
Wall02_03_RealWidth	EQU	64
Wall02_03_Width		EQU	Wall02_03_RealWidth/8
Wall02_03_Offset	EQU	(Wall02_03_RealWidth*Wall02_03_Height)/8
Wall00_03_RealWidth	EQU	112
Wall00_03_Width		EQU	Wall00_03_RealWidth/8
Wall00_03_Offset	EQU	(Wall00_03_RealWidth*Wall01_03_Height)/8
Wall00_03_NoPln		EQU	NumPlanes

ma_Direc	equ	0
ma_ForwardX	equ	2
ma_ForwardY	equ	4
ma_LeftX	equ	6
ma_LeftY	equ	8
ma_RightX	equ	10
ma_RightY	equ	12
ma_BackwardX	equ	14
ma_BackwardY	equ	16
ma_NxtDirec	equ	18
