; Wild Sector source made by META2Wild
; Made on 00:01:35 of 02-02-1978
; Sector name is SkruHeadB

SECTOR_SkruHeadB
	Dc.l	SkruHeadB_Succ,SkruHeadB_Pred
	QuickRefRel	0+SkruHeadB_PosX,0+SkruHeadB_PosY,0+SkruHeadB_PosZ
	Dc.l	SkruHeadB_Parent
	Dc.l	0
	Dc.b	0,0
	ListHeader	SkruHeadBShell,FACE_SkruHeadB1,FACE_SkruHeadB10
	ListHeader	SkruHeadBWire,EDGE_SkruHeadB1,EDGE_SkruHeadB15
	ListHeader	SkruHeadBNebula,DOT_SkruHeadB1,DOT_SkruHeadB7
	Ds.b	Sphere_SIZE
	Dc.l	FACE_SkruHeadB2

COLOR_SkruHeadB0	EQU	$FFEEDD

FACE_SkruHeadB1
	Dc.l	FACE_SkruHeadB2,SkruHeadBShell_Head
	Dc.l	0,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruHeadB1,DOT_SkruHeadB2,DOT_SkruHeadB3
	Dc.l	EDGE_SkruHeadB1,EDGE_SkruHeadB2,EDGE_SkruHeadB3
	Dc.l	TEXTURE_SkruHeadB0
	Dc.b	69,-4
	Dc.b	82,-32
	Dc.b	95,-9
FACE_SkruHeadB2
	Dc.l	FACE_SkruHeadB3,FACE_SkruHeadB1
	Dc.l	0,FACE_SkruHeadB3
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruHeadB3,DOT_SkruHeadB4,DOT_SkruHeadB5
	Dc.l	EDGE_SkruHeadB4,EDGE_SkruHeadB5,EDGE_SkruHeadB6
	Dc.l	TEXTURE_SkruHeadB0
	Dc.b	95,-9
	Dc.b	107,-32
	Dc.b	120,-4
FACE_SkruHeadB3
	Dc.l	FACE_SkruHeadB4,FACE_SkruHeadB2
	Dc.l	0,FACE_SkruHeadB6
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruHeadB4,DOT_SkruHeadB2,DOT_SkruHeadB6
	Dc.l	EDGE_SkruHeadB7,EDGE_SkruHeadB8,EDGE_SkruHeadB9
	Dc.l	TEXTURE_SkruHeadB0
	Dc.b	107,-32
	Dc.b	82,-32
	Dc.b	95,-60
FACE_SkruHeadB4
	Dc.l	FACE_SkruHeadB5,FACE_SkruHeadB3
	Dc.l	0,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruHeadB6,DOT_SkruHeadB7,DOT_SkruHeadB4
	Dc.l	EDGE_SkruHeadB10,EDGE_SkruHeadB11,EDGE_SkruHeadB9
	Dc.l	TEXTURE_SkruHeadB0
	Dc.b	95,-60
	Dc.b	95,-23
	Dc.b	107,-32
FACE_SkruHeadB5
	Dc.l	FACE_SkruHeadB6,FACE_SkruHeadB4
	Dc.l	FACE_SkruHeadB10,FACE_SkruHeadB9
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruHeadB7,DOT_SkruHeadB4,DOT_SkruHeadB5
	Dc.l	EDGE_SkruHeadB11,EDGE_SkruHeadB5,EDGE_SkruHeadB12
	Dc.l	TEXTURE_SkruHeadB0
	Dc.b	95,-23
	Dc.b	107,-32
	Dc.b	120,-4
FACE_SkruHeadB6
	Dc.l	FACE_SkruHeadB7,FACE_SkruHeadB5
	Dc.l	FACE_SkruHeadB5,FACE_SkruHeadB7
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruHeadB7,DOT_SkruHeadB5,DOT_SkruHeadB3
	Dc.l	EDGE_SkruHeadB12,EDGE_SkruHeadB6,EDGE_SkruHeadB13
	Dc.l	TEXTURE_SkruHeadB0
	Dc.b	95,-23
	Dc.b	120,-4
	Dc.b	95,-9
FACE_SkruHeadB7
	Dc.l	FACE_SkruHeadB8,FACE_SkruHeadB6
	Dc.l	FACE_SkruHeadB8,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruHeadB7,DOT_SkruHeadB3,DOT_SkruHeadB1
	Dc.l	EDGE_SkruHeadB13,EDGE_SkruHeadB3,EDGE_SkruHeadB14
	Dc.l	TEXTURE_SkruHeadB0
	Dc.b	95,-23
	Dc.b	95,-9
	Dc.b	69,-4
FACE_SkruHeadB8
	Dc.l	FACE_SkruHeadB9,FACE_SkruHeadB7
	Dc.l	FACE_SkruHeadB1,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruHeadB7,DOT_SkruHeadB1,DOT_SkruHeadB2
	Dc.l	EDGE_SkruHeadB14,EDGE_SkruHeadB1,EDGE_SkruHeadB15
	Dc.l	TEXTURE_SkruHeadB0
	Dc.b	95,-23
	Dc.b	69,-4
	Dc.b	82,-32
FACE_SkruHeadB9
	Dc.l	FACE_SkruHeadB10,FACE_SkruHeadB8
	Dc.l	FACE_SkruHeadB4,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruHeadB7,DOT_SkruHeadB2,DOT_SkruHeadB6
	Dc.l	EDGE_SkruHeadB15,EDGE_SkruHeadB8,EDGE_SkruHeadB10
	Dc.l	TEXTURE_SkruHeadB0
	Dc.b	95,-23
	Dc.b	82,-32
	Dc.b	95,-60
FACE_SkruHeadB10
	Dc.l	SkruHeadBShell_Tail,FACE_SkruHeadB9
	Dc.l	0,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruHeadB3,DOT_SkruHeadB4,DOT_SkruHeadB2
	Dc.l	EDGE_SkruHeadB4,EDGE_SkruHeadB7,EDGE_SkruHeadB2
	Dc.l	TEXTURE_SkruHeadB0
	Dc.b	95,-9
	Dc.b	107,-32
	Dc.b	82,-32

EDGE_SkruHeadB1
	Dc.l	EDGE_SkruHeadB2,SkruHeadBWire_Head
	Dc.l	DOT_SkruHeadB1,DOT_SkruHeadB2
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadB2
	Dc.l	EDGE_SkruHeadB3,EDGE_SkruHeadB1
	Dc.l	DOT_SkruHeadB2,DOT_SkruHeadB3
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadB3
	Dc.l	EDGE_SkruHeadB4,EDGE_SkruHeadB2
	Dc.l	DOT_SkruHeadB1,DOT_SkruHeadB3
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadB4
	Dc.l	EDGE_SkruHeadB5,EDGE_SkruHeadB3
	Dc.l	DOT_SkruHeadB3,DOT_SkruHeadB4
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadB5
	Dc.l	EDGE_SkruHeadB6,EDGE_SkruHeadB4
	Dc.l	DOT_SkruHeadB4,DOT_SkruHeadB5
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadB6
	Dc.l	EDGE_SkruHeadB7,EDGE_SkruHeadB5
	Dc.l	DOT_SkruHeadB3,DOT_SkruHeadB5
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadB7
	Dc.l	EDGE_SkruHeadB8,EDGE_SkruHeadB6
	Dc.l	DOT_SkruHeadB4,DOT_SkruHeadB2
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadB8
	Dc.l	EDGE_SkruHeadB9,EDGE_SkruHeadB7
	Dc.l	DOT_SkruHeadB2,DOT_SkruHeadB6
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadB9
	Dc.l	EDGE_SkruHeadB10,EDGE_SkruHeadB8
	Dc.l	DOT_SkruHeadB4,DOT_SkruHeadB6
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadB10
	Dc.l	EDGE_SkruHeadB11,EDGE_SkruHeadB9
	Dc.l	DOT_SkruHeadB6,DOT_SkruHeadB7
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadB11
	Dc.l	EDGE_SkruHeadB12,EDGE_SkruHeadB10
	Dc.l	DOT_SkruHeadB7,DOT_SkruHeadB4
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadB12
	Dc.l	EDGE_SkruHeadB13,EDGE_SkruHeadB11
	Dc.l	DOT_SkruHeadB7,DOT_SkruHeadB5
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadB13
	Dc.l	EDGE_SkruHeadB14,EDGE_SkruHeadB12
	Dc.l	DOT_SkruHeadB7,DOT_SkruHeadB3
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadB14
	Dc.l	EDGE_SkruHeadB15,EDGE_SkruHeadB13
	Dc.l	DOT_SkruHeadB7,DOT_SkruHeadB1
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadB15
	Dc.l	SkruHeadBWire_Tail,EDGE_SkruHeadB14
	Dc.l	DOT_SkruHeadB7,DOT_SkruHeadB2
	Dc.b	0,0,0,0
	Dc.l	0

DOT_SkruHeadB1
	Dc.l	DOT_SkruHeadB2,SkruHeadBNebula_Head
	Dc.l	-120,-200,80
	Dc.l	COLOR_SkruHeadB0
	Dc.b	0,0
	Dc.l	0
DOT_SkruHeadB2
	Dc.l	DOT_SkruHeadB3,DOT_SkruHeadB1
	Dc.l	-60,0,-40
	Dc.l	COLOR_SkruHeadB0
	Dc.b	0,0
	Dc.l	0
DOT_SkruHeadB3
	Dc.l	DOT_SkruHeadB4,DOT_SkruHeadB2
	Dc.l	0,0,60
	Dc.l	COLOR_SkruHeadB0
	Dc.b	0,0
	Dc.l	0
DOT_SkruHeadB4
	Dc.l	DOT_SkruHeadB5,DOT_SkruHeadB3
	Dc.l	60,0,-40
	Dc.l	COLOR_SkruHeadB0
	Dc.b	0,0
	Dc.l	0
DOT_SkruHeadB5
	Dc.l	DOT_SkruHeadB6,DOT_SkruHeadB4
	Dc.l	120,-200,80
	Dc.l	COLOR_SkruHeadB0
	Dc.b	0,0
	Dc.l	0
DOT_SkruHeadB6
	Dc.l	DOT_SkruHeadB7,DOT_SkruHeadB5
	Dc.l	0,-200,-160
	Dc.l	COLOR_SkruHeadB0
	Dc.b	0,0
	Dc.l	0
DOT_SkruHeadB7
	Dc.l	SkruHeadBNebula_Tail,DOT_SkruHeadB6
	Dc.l	0,-69,0
	Dc.l	COLOR_SkruHeadB0
	Dc.b	0,0
	Dc.l	0
