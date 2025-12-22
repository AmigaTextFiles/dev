; Wild Sector source made by META2Wild
; Made on 02:25:04 of 01-21-1978
; Sector name is SkruHead

SECTOR_SkruHead
	Dc.l	SkruHead_Succ,SkruHead_Pred
	QuickRefRel	0,0,0
	Dc.l	SkruHead_Parent
	Dc.l	0
	Dc.b	0,0
	ListHeader	SkruHeadShell,FACE_SkruHead1,FACE_SkruHead10
	ListHeader	SkruHeadWire,EDGE_SkruHead1,EDGE_SkruHead15
	ListHeader	SkruHeadNebula,DOT_SkruHead1,DOT_SkruHead7
	Ds.b	Sphere_SIZE
	Dc.l	FACE_SkruHead2

COLOR_SkruHead0	EQU	$FFEEDD

FACE_SkruHead1
	Dc.l	FACE_SkruHead2,SkruHeadShell_Head
	Dc.l	0,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruHead1,DOT_SkruHead2,DOT_SkruHead3
	Dc.l	EDGE_SkruHead1,EDGE_SkruHead2,EDGE_SkruHead3
	Dc.l	TEXTURE_SkruHead0
	Dc.b	0,0
	Dc.b	0,0
	Dc.b	0,0
FACE_SkruHead2
	Dc.l	FACE_SkruHead3,FACE_SkruHead1
	Dc.l	0,FACE_SkruHead3
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruHead3,DOT_SkruHead4,DOT_SkruHead5
	Dc.l	EDGE_SkruHead4,EDGE_SkruHead5,EDGE_SkruHead6
	Dc.l	TEXTURE_SkruHead0
	Dc.b	0,0
	Dc.b	0,0
	Dc.b	0,0
FACE_SkruHead3
	Dc.l	FACE_SkruHead4,FACE_SkruHead2
	Dc.l	0,FACE_SkruHead6
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruHead4,DOT_SkruHead2,DOT_SkruHead6
	Dc.l	EDGE_SkruHead7,EDGE_SkruHead8,EDGE_SkruHead9
	Dc.l	TEXTURE_SkruHead0
	Dc.b	0,0
	Dc.b	0,0
	Dc.b	0,0
FACE_SkruHead4
	Dc.l	FACE_SkruHead5,FACE_SkruHead3
	Dc.l	0,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruHead6,DOT_SkruHead7,DOT_SkruHead4
	Dc.l	EDGE_SkruHead10,EDGE_SkruHead11,EDGE_SkruHead9
	Dc.l	TEXTURE_SkruHead0
	Dc.b	0,0
	Dc.b	0,0
	Dc.b	0,0
FACE_SkruHead5
	Dc.l	FACE_SkruHead6,FACE_SkruHead4
	Dc.l	FACE_SkruHead10,FACE_SkruHead9
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruHead7,DOT_SkruHead4,DOT_SkruHead5
	Dc.l	EDGE_SkruHead11,EDGE_SkruHead5,EDGE_SkruHead12
	Dc.l	TEXTURE_SkruHead0
	Dc.b	0,0
	Dc.b	0,0
	Dc.b	0,0
FACE_SkruHead6
	Dc.l	FACE_SkruHead7,FACE_SkruHead5
	Dc.l	FACE_SkruHead5,FACE_SkruHead7
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruHead7,DOT_SkruHead5,DOT_SkruHead3
	Dc.l	EDGE_SkruHead12,EDGE_SkruHead6,EDGE_SkruHead13
	Dc.l	TEXTURE_SkruHead0
	Dc.b	0,0
	Dc.b	0,0
	Dc.b	0,0
FACE_SkruHead7
	Dc.l	FACE_SkruHead8,FACE_SkruHead6
	Dc.l	FACE_SkruHead8,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruHead7,DOT_SkruHead3,DOT_SkruHead1
	Dc.l	EDGE_SkruHead13,EDGE_SkruHead3,EDGE_SkruHead14
	Dc.l	TEXTURE_SkruHead0
	Dc.b	0,0
	Dc.b	0,0
	Dc.b	0,0
FACE_SkruHead8
	Dc.l	FACE_SkruHead9,FACE_SkruHead7
	Dc.l	FACE_SkruHead1,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruHead7,DOT_SkruHead1,DOT_SkruHead2
	Dc.l	EDGE_SkruHead14,EDGE_SkruHead1,EDGE_SkruHead15
	Dc.l	TEXTURE_SkruHead0
	Dc.b	0,0
	Dc.b	0,0
	Dc.b	0,0
FACE_SkruHead9
	Dc.l	FACE_SkruHead10,FACE_SkruHead8
	Dc.l	FACE_SkruHead4,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruHead7,DOT_SkruHead2,DOT_SkruHead6
	Dc.l	EDGE_SkruHead15,EDGE_SkruHead8,EDGE_SkruHead10
	Dc.l	TEXTURE_SkruHead0
	Dc.b	0,0
	Dc.b	0,0
	Dc.b	0,0
FACE_SkruHead10
	Dc.l	SkruHeadShell_Tail,FACE_SkruHead9
	Dc.l	0,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruHead3,DOT_SkruHead4,DOT_SkruHead2
	Dc.l	EDGE_SkruHead4,EDGE_SkruHead7,EDGE_SkruHead2
	Dc.l	TEXTURE_SkruHead0
	Dc.b	0,0
	Dc.b	0,0
	Dc.b	0,0

EDGE_SkruHead1
	Dc.l	EDGE_SkruHead2,SkruHeadWire_Head
	Dc.l	DOT_SkruHead1,DOT_SkruHead2
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHead2
	Dc.l	EDGE_SkruHead3,EDGE_SkruHead1
	Dc.l	DOT_SkruHead2,DOT_SkruHead3
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHead3
	Dc.l	EDGE_SkruHead4,EDGE_SkruHead2
	Dc.l	DOT_SkruHead1,DOT_SkruHead3
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHead4
	Dc.l	EDGE_SkruHead5,EDGE_SkruHead3
	Dc.l	DOT_SkruHead3,DOT_SkruHead4
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHead5
	Dc.l	EDGE_SkruHead6,EDGE_SkruHead4
	Dc.l	DOT_SkruHead4,DOT_SkruHead5
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHead6
	Dc.l	EDGE_SkruHead7,EDGE_SkruHead5
	Dc.l	DOT_SkruHead3,DOT_SkruHead5
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHead7
	Dc.l	EDGE_SkruHead8,EDGE_SkruHead6
	Dc.l	DOT_SkruHead4,DOT_SkruHead2
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHead8
	Dc.l	EDGE_SkruHead9,EDGE_SkruHead7
	Dc.l	DOT_SkruHead2,DOT_SkruHead6
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHead9
	Dc.l	EDGE_SkruHead10,EDGE_SkruHead8
	Dc.l	DOT_SkruHead4,DOT_SkruHead6
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHead10
	Dc.l	EDGE_SkruHead11,EDGE_SkruHead9
	Dc.l	DOT_SkruHead6,DOT_SkruHead7
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHead11
	Dc.l	EDGE_SkruHead12,EDGE_SkruHead10
	Dc.l	DOT_SkruHead7,DOT_SkruHead4
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHead12
	Dc.l	EDGE_SkruHead13,EDGE_SkruHead11
	Dc.l	DOT_SkruHead7,DOT_SkruHead5
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHead13
	Dc.l	EDGE_SkruHead14,EDGE_SkruHead12
	Dc.l	DOT_SkruHead7,DOT_SkruHead3
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHead14
	Dc.l	EDGE_SkruHead15,EDGE_SkruHead13
	Dc.l	DOT_SkruHead7,DOT_SkruHead1
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHead15
	Dc.l	SkruHeadWire_Tail,EDGE_SkruHead14
	Dc.l	DOT_SkruHead7,DOT_SkruHead2
	Dc.b	0,0,0,0
	Dc.l	0

DOT_SkruHead1
	Dc.l	DOT_SkruHead2,SkruHeadNebula_Head
	Dc.l	-120,-200,80
	Dc.l	COLOR_SkruHead0
	Dc.b	0,0
	Dc.l	0
DOT_SkruHead2
	Dc.l	DOT_SkruHead3,DOT_SkruHead1
	Dc.l	-60,0,-40
	Dc.l	COLOR_SkruHead0
	Dc.b	0,0
	Dc.l	0
DOT_SkruHead3
	Dc.l	DOT_SkruHead4,DOT_SkruHead2
	Dc.l	0,0,60
	Dc.l	COLOR_SkruHead0
	Dc.b	0,0
	Dc.l	0
DOT_SkruHead4
	Dc.l	DOT_SkruHead5,DOT_SkruHead3
	Dc.l	60,0,-40
	Dc.l	COLOR_SkruHead0
	Dc.b	0,0
	Dc.l	0
DOT_SkruHead5
	Dc.l	DOT_SkruHead6,DOT_SkruHead4
	Dc.l	120,-200,80
	Dc.l	COLOR_SkruHead0
	Dc.b	0,0
	Dc.l	0
DOT_SkruHead6
	Dc.l	DOT_SkruHead7,DOT_SkruHead5
	Dc.l	0,-200,-160
	Dc.l	COLOR_SkruHead0
	Dc.b	0,0
	Dc.l	0
DOT_SkruHead7
	Dc.l	SkruHeadNebula_Tail,DOT_SkruHead6
	Dc.l	0,-69,0
	Dc.l	COLOR_SkruHead0
	Dc.b	0,0
	Dc.l	0
